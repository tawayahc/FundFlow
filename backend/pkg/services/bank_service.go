package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
)

// Get a bank by bankID
func GetBank(bankID uint, userID uint) (models.BankTransactionsDTO, error) {
	var bank models.BankDetailDTO
	if err := config.DB.Table("bank_details").Select("id, name, bank_name, amount").Where("id = ? AND user_profile_id = ?", bankID, userID).First(&bank).Error; err != nil {
		return models.BankTransactionsDTO{}, errors.New("bank not found")
	}

	// Get all transactions for the bank with bank_nickname and bank_name
	var transactions []models.TransactionDTO
	if err := config.DB.Table("transactions").
		Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, bank_details.name as bank_nickname, bank_details.bank_name").
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
func CreateBank(name string, bankName string, userID uint) error {
	// Check if the bank already exists
	var bank models.BankDetail
	if err := config.DB.Where("name = ? AND bank_name = ? AND user_profile_id = ?", name, bankName, userID).First(&bank).Error; err == nil {
		return errors.New("bank already exists")
	}

	// Create a new bank
	newBank := models.BankDetail{Name: name, BankName: bankName, UserProfileID: userID}
	if err := config.DB.Create(&newBank).Error; err != nil {
		return errors.New("failed to create bank")
	}

	return nil
}

// UpdateBank updates a bank
func UpdateBank(bankID uint, name string, bankName string, userID uint) error {
	// Check if the bank exists
	var bank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", bankID, userID).First(&bank).Error; err != nil {
		return errors.New("bank not found")
	}

	// Check repition name and bank name
	var bankDetail models.BankDetail
	if err := config.DB.Where("name = ? AND bank_name = ? AND user_profile_id = ?", name, bankName, userID).First(&bankDetail).Error; err == nil {
		return errors.New("this name in this bank_name already exists")
	}

	// Update the bank
	if err := config.DB.Model(&bank).Updates(models.BankDetail{Name: name, BankName: bankName}).Error; err != nil {
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
func TransferMoney(fromBankID uint, toBankID uint, amount float64, userID uint) error {
	// Check if the banks exist
	var fromBank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", fromBankID, userID).First(&fromBank).Error; err != nil {
		return errors.New("source bank not found")
	}

	var toBank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", toBankID, userID).First(&toBank).Error; err != nil {
		return errors.New("destination bank not found")
	}

	// Check if the source bank has enough balance
	if fromBank.Amount < amount {
		return errors.New("insufficient balance")
	}

	// Deduct the amount from the source bank
	if err := config.DB.Model(&fromBank).Update("amount", fromBank.Amount-amount).Error; err != nil {
		return errors.New("failed to deduct amount from source bank")
	}

	// Add the amount to the destination bank
	if err := config.DB.Model(&toBank).Update("amount", toBank.Amount+amount).Error; err != nil {
		return errors.New("failed to add amount to destination bank")
	}

	return nil
}
