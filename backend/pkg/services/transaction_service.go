package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"fundflow/pkg/utils"

	"gorm.io/gorm"
)

// GetTransactions retrieves all transactions for a user
func GetTransactions(userID uint) ([]models.TransactionDTO, error) {
	var transactions []models.TransactionDTO

	// Retrieve transactions with bank details in a single query
	if err := config.DB.
		Table("transactions").
		Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, transactions.created_at, bank_details.name AS bank_nickname, bank_details.bank_name").
		Joins("LEFT JOIN bank_details ON transactions.bank_id = bank_details.id").
		Where("transactions.user_profile_id = ?", userID).
		Find(&transactions).Error; err != nil {
		return nil, errors.New("failed to retrieve transactions")
	}

	return transactions, nil
}

// GetTransaction retrieves a transaction by ID
func GetTransaction(transactionID uint, userID uint) (models.TransactionDTO, error) {
	var transaction models.TransactionDTO

	// Retrieve transaction with bank details in a single query
	if err := config.DB.
		Table("transactions").
		Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, transactions.created_at, bank_details.name AS bank_nickname, bank_details.bank_name").
		Joins("LEFT JOIN bank_details ON transactions.bank_id = bank_details.id").
		Where("transactions.id = ? AND transactions.user_profile_id = ?", transactionID, userID).
		First(&transaction).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return models.TransactionDTO{}, errors.New("transaction not found")
		}
		return models.TransactionDTO{}, errors.New("failed to retrieve transaction")
	}

	return transaction, nil
}

// CreateTransaction creates a new transaction
func CreateTransaction(transaction models.CreateTransactionRequest, userID uint) error {
	// Check if the bank exists and update the amount based on transaction type
	var bank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", transaction.BankID, userID).First(&bank).Error; err != nil {
		return errors.New("bank not found")
	}

	// Adjust the bank amount
	if transaction.Type == "income" {
		bank.Amount += transaction.Amount
	} else if transaction.Type == "expense" {
		bank.Amount -= transaction.Amount
	} else {
		return errors.New("invalid transaction type")
	}

	// Check if the category exists and update amount if applicable
	var category *models.Category
	if transaction.CategoryID != nil {
		category = &models.Category{}
		if err := config.DB.Where("id = ? AND user_profile_id = ?", *transaction.CategoryID, userID).First(category).Error; err != nil {
			return errors.New("category not found")
		}
		if transaction.Type == "expense" {
			category.Amount -= transaction.Amount
		}
	}

	// Parse the created at date and time
	createdAt, err := utils.ParseCreatedAt(transaction.CreatedAtDate, transaction.CreatedAtTime)
	if err != nil {
		return err
	}

	// Check if MetaData is an empty string and set it to nil if true
	var metaData *string
	if transaction.MetaData == "" {
		metaData = nil
	} else {
		metaData = &transaction.MetaData
	}

	// Check if the transaction repetition of amount, bank id, created at and user profile id
	// var existingTransaction models.Transaction
	// if err := config.DB.Where("amount = ? AND bank_id = ? AND created_at = ? AND user_profile_id = ?", transaction.Amount, transaction.BankID, createdAt, userID).First(&existingTransaction).Error; err == nil {
	// 	return errors.New("transaction already exists")
	// }

	// Create a new transaction
	newTransaction := models.Transaction{
		BankID:        transaction.BankID,
		Type:          transaction.Type,
		Amount:        transaction.Amount,
		CategoryID:    transaction.CategoryID,
		CreatedAt:     createdAt,
		MetaData:      metaData,
		UserProfileID: userID,
		Memo:          transaction.Memo,
	}
	if err := config.DB.Create(&newTransaction).Error; err != nil {
		return errors.New("failed to create transaction")
	}

	// Save updates to bank and category in a single transaction
	return config.DB.Transaction(func(tx *gorm.DB) error {
		if err := tx.Save(&bank).Error; err != nil {
			return errors.New("failed to update bank amount")
		}
		if category != nil {
			if err := tx.Save(category).Error; err != nil {
				return errors.New("failed to update category amount")
			}
		}
		return nil
	})
}

// UpdateTransaction updates a transaction
func UpdateTransaction(transactionID uint, updateTransaction models.UpdateTransactionRequest, userID uint) error {
	// Check if the transaction exists
	var transaction models.Transaction
	if err := config.DB.Where("id = ? AND user_profile_id = ?", transactionID, userID).First(&transaction).Error; err != nil {
		return errors.New("transaction not found")
	}

	// Check if the category exists
	if updateTransaction.NewCategoryID != nil {
		var category models.Category
		if err := config.DB.Where("id = ? AND user_profile_id = ?", *updateTransaction.NewCategoryID, userID).First(&category).Error; err != nil {
			return errors.New("category not found")
		}
	}

	// Create a map to hold the fields to be updated
	updates := make(map[string]interface{})

	// Add fields to the map only if they have new values
	if updateTransaction.NewCategoryID != nil {
		updates["category_id"] = *updateTransaction.NewCategoryID
	}
	if updateTransaction.NewMemo != nil {
		updates["memo"] = *updateTransaction.NewMemo
	}

	if len(updates) == 0 {
		return errors.New("no fields to update")
	}

	// Update the transaction with the new values
	if err := config.DB.Model(&transaction).Updates(updates).Error; err != nil {
		return errors.New("failed to update transaction")
	}

	return nil
}

// DeleteTransaction deletes a transaction
func DeleteTransaction(transactionID uint, userID uint) error {
	// Check if the transaction exists
	var transaction models.Transaction
	if err := config.DB.Where("id = ? AND user_profile_id = ?", transactionID, userID).First(&transaction).Error; err != nil {
		return errors.New("transaction not found")
	}

	// Delete the transaction
	if err := config.DB.Unscoped().Delete(&transaction).Error; err != nil {
		return errors.New("failed to delete transaction")
	}

	return nil
}
