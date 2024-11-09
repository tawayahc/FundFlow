package services

import (
	"errors"
	"fmt"
	"fundflow/pkg/config"
	"fundflow/pkg/models"

	"gorm.io/gorm"
)

// GetTransactions retrieves all transactions for a user
func GetTransactions(userID uint) ([]models.TransactionDTO, error) {
	var transactions []models.TransactionDTO

	// Retrieve transactions with bank details in a single query
	if err := config.DB.
		Table("transactions").
		Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, bank_details.name AS bank_nickname, bank_details.bank_name").
		Joins("LEFT JOIN bank_details ON transactions.bank_id = bank_details.id").
		Where("transactions.user_profile_id = ?", userID).
		Find(&transactions).Error; err != nil {
		return nil, fmt.Errorf("failed to retrieve transactions: %w", err)
	}

	return transactions, nil
}

// GetTransaction retrieves a transaction by ID
func GetTransaction(transactionID uint, userID uint) (models.TransactionDTO, error) {
	var transaction models.TransactionDTO

	// Retrieve transaction with bank details in a single query
	if err := config.DB.
		Table("transactions").
		Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, bank_details.name AS bank_nickname, bank_details.bank_name").
		Joins("LEFT JOIN bank_details ON transactions.bank_id = bank_details.id").
		Where("transactions.id = ? AND transactions.user_profile_id = ?", transactionID, userID).
		First(&transaction).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return models.TransactionDTO{}, errors.New("transaction not found")
		}
		return models.TransactionDTO{}, fmt.Errorf("failed to retrieve transaction: %w", err)
	}

	return transaction, nil
}

// CreateTransaction creates a new transaction
func CreateTransaction(transaction models.CreateTransactionRequest, userID uint) error {
	// Check if the bank exists
	var bank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", transaction.BankID, userID).First(&bank).Error; err != nil {
		return errors.New("bank not found")
	}

	// Check if the category exists
	if transaction.CategoryID != nil {
		var category models.Category
		if err := config.DB.Where("id = ?", *transaction.CategoryID).First(&category).Error; err != nil {
			return errors.New("category not found")
		}
	}

	// Create a new transaction
	newTransaction := models.Transaction{
		BankID:        transaction.BankID,
		Type:          transaction.Type,
		Amount:        transaction.Amount,
		CategoryID:    transaction.CategoryID,
		UserProfileID: userID,
		MetaData:      transaction.MetaData,
		Memo:          transaction.Memo,
	}
	if err := config.DB.Create(&newTransaction).Error; err != nil {
		return errors.New("failed to create transaction")
	}

	// Update the bank amount
	if transaction.Type == "income" {
		bank.Amount += transaction.Amount
	} else if transaction.Type == "expense" {
		bank.Amount -= transaction.Amount
	} else {
		return errors.New("invalid transaction type")
	}

	if err := config.DB.Save(&bank).Error; err != nil {
		return errors.New("failed to update bank amount")
	}

	return nil
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

	// Update the transaction with the new values
	if len(updates) > 0 {
		if err := config.DB.Model(&transaction).Updates(updates).Error; err != nil {
			return errors.New("failed to update transaction")
		}
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
