package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"fundflow/pkg/utils"
)

// Get transactions for a bank
func GetBank(bankID uint, userID uint) (models.BankTransactionsDTO, error) {
	var bank models.BankDetailDTO
	if err := config.DB.Table("bank_details").Select("id, name, bank_name, amount").Where("id = ? AND user_profile_id = ?", bankID, userID).First(&bank).Error; err != nil {
		return models.BankTransactionsDTO{}, errors.New("bank not found")
	}

	// Get all transactions for the bank with bank_nickname and bank_name
	var transactions []models.TransactionDTO
	if err := config.DB.Table("transactions").
		Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, transactions.created_at, bank_details.name as bank_nickname, bank_details.bank_name").
		Joins("left join bank_details on transactions.bank_id = bank_details.id").
		Where("transactions.bank_id = ?", bankID).
		Find(&transactions).Error; err != nil {
		return models.BankTransactionsDTO{}, errors.New("failed to retrieve transactions")
	}

	return models.BankTransactionsDTO{BankDetailDTO: bank, Transactions: transactions}, nil
}

// GetBanks retrieves all banks for a user
func GetBanks(userID uint) ([]models.BankDetailDTO, error) {
	var banks []models.BankDetailDTO
	if err := config.DB.Table("bank_details").Select("id, name, bank_name, amount").Where("user_profile_id = ?", userID).Find(&banks).Error; err != nil {
		return nil, errors.New("failed to retrieve banks")
	}

	return banks, nil
}

// CreateBank creates a new bank
func CreateBank(createBank models.CreateBankRequest, userID uint) error {
	// Check if the amount is negative
	if createBank.Amount < 0 {
		return errors.New("amount cannot be negative")
	}

	// Check if the bank already exists
	var bank models.BankDetail
	if err := config.DB.Where("name = ? AND user_profile_id = ?", createBank.Name, userID).First(&bank).Error; err == nil {
		return errors.New("bank already exists")
	}

	// Create a new bank
	newBank := models.BankDetail{
		Name:          createBank.Name,
		BankName:      createBank.BankName,
		Amount:        createBank.Amount,
		UserProfileID: userID,
	}
	if err := config.DB.Create(&newBank).Error; err != nil {
		return errors.New("failed to create bank")
	}

	return nil
}

// UpdateBank updates a bank
func UpdateBank(bankID uint, updateBank models.UpdateBankRequest, userID uint) error {
	// Check if the bank exists
	var bank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", bankID, userID).First(&bank).Error; err != nil {
		return errors.New("bank not found")
	}

	// Create a map to hold the fields to be updated
	updates := make(map[string]interface{})

	// Check each field for nil and add to the updates map if not nil
	if updateBank.NewName != nil {
		// Check if the new name is already in use
		var nameCheck models.BankDetail
		if err := config.DB.Where("name = ? AND user_profile_id = ?", *updateBank.NewName, userID).First(&nameCheck).Error; err == nil {
			return errors.New("name already in use")
		} else {
			updates["name"] = *updateBank.NewName
		}
	}
	if updateBank.NewBankName != nil {
		updates["bank_name"] = *updateBank.NewBankName
	}
	if updateBank.NewAmount != nil {
		updates["amount"] = *updateBank.NewAmount
	}

	if len(updates) == 0 {
		return errors.New("no updates provided")
	}

	// Update the bank
	if err := config.DB.Model(&bank).Updates(updates).Error; err != nil {
		return errors.New("failed to update bank")
	}

	return nil
}

// DeleteBank deletes a bank
func DeleteBank(bankID uint, userID uint) error {
	// Check if the bank exists
	var bank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", bankID, userID).First(&bank).Error; err != nil {
		return errors.New("bank not found")
	}

	// Delete the bank
	if err := config.DB.Unscoped().Delete(&bank).Error; err != nil {
		return errors.New("failed to delete bank")
	}

	return nil
}

// TransferMoney transfers money between banks
func TransferMoney(transfer models.TransferRequest, userID uint) error {
	// Check if the banks exist
	var fromBank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", transfer.FromBankID, userID).First(&fromBank).Error; err != nil {
		return errors.New("source bank not found")
	}

	var toBank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", transfer.ToBankID, userID).First(&toBank).Error; err != nil {
		return errors.New("destination bank not found")
	}

	// Check if the source bank has enough balance
	if fromBank.Amount < transfer.Amount {
		return errors.New("insufficient balance")
	}

	// Deduct the amount from the source bank
	if err := config.DB.Model(&fromBank).Update("amount", fromBank.Amount-transfer.Amount).Error; err != nil {
		return errors.New("failed to deduct amount from source bank")
	}

	// Add the amount to the destination bank
	if err := config.DB.Model(&toBank).Update("amount", toBank.Amount+transfer.Amount).Error; err != nil {
		return errors.New("failed to add amount to destination bank")
	}

	// Parse the created at date and time
	createdAt, err := utils.ParseCreatedAt(transfer.CreatedAtDate, transfer.CreatedAtTime)
	if err != nil {
		return err
	}

	// Create a transaction record
	transaction := models.TransferTransaction{
		FromBankID:    transfer.FromBankID,
		ToBankID:      transfer.ToBankID,
		Amount:        transfer.Amount,
		UserProfileID: userID,
		CreatedAt:     createdAt,
	}

	if err := config.DB.Create(&transaction).Error; err != nil {
		return errors.New("failed to create transaction")
	}

	return nil
}

// GetTransferTransactions retrieves all transfer transactions for fromBankID
func GetTransferTransactions(fromBankID uint, userID uint) ([]models.TransferDTO, error) {
	var transactions []models.TransferDTO
	if err := config.DB.Table("transfer_transactions").
		Select("transfer_transactions.id, transfer_transactions.amount, transfer_transactions.from_bank_id, transfer_transactions.to_bank_id, transfer_transactions.created_at, bank_details.name as from_bank_name, bank_details.bank_name as from_bank_bank_name, bank_details_2.name as to_bank_name, bank_details_2.bank_name as to_bank_bank_name").
		Joins("left join bank_details on transfer_transactions.from_bank_id = bank_details.id").
		Joins("left join bank_details as bank_details_2 on transfer_transactions.to_bank_id = bank_details_2.id").
		Where("transfer_transactions.from_bank_id = ? AND transfer_transactions.user_profile_id = ?", fromBankID, userID).
		Find(&transactions).Error; err != nil {
		return nil, errors.New("failed to retrieve transactions")
	}

	return transactions, nil
}

// GetTransferTransactions by userID
func GetTransferTransactionsByUserID(userID uint) ([]models.TransferDTO, error) {
	var transactions []models.TransferDTO
	if err := config.DB.Table("transfer_transactions").
		Select("transfer_transactions.id, transfer_transactions.amount, transfer_transactions.from_bank_id, transfer_transactions.to_bank_id, transfer_transactions.created_at, bank_details.name as from_bank_name, bank_details.bank_name as from_bank_bank_name, bank_details_2.name as to_bank_name, bank_details_2.bank_name as to_bank_bank_name").
		Joins("left join bank_details on transfer_transactions.from_bank_id = bank_details.id").
		Joins("left join bank_details as bank_details_2 on transfer_transactions.to_bank_id = bank_details_2.id").
		Where("transfer_transactions.user_profile_id = ?", userID).
		Find(&transactions).Error; err != nil {
		return nil, errors.New("failed to retrieve transactions")
	}

	return transactions, nil
}