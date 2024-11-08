package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
)

// Get a bank by bankID
func GetBank(bankID uint, userID uint) (models.BankDetail, error) {
	var bank models.BankDetail
	if err := config.DB.Where("id = ? AND user_profile_id = ?", bankID, userID).First(&bank).Error; err != nil {
		return models.BankDetail{}, errors.New("bank not found")
	}

	return bank, nil
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
