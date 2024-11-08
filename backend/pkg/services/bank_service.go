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
