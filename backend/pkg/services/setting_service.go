package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"fundflow/pkg/utils"
)

func ChangeEmail(email string, userName string) error {
	// Check if the email already exists
	var user models.UserProfile
	if err := config.DB.Where("email = ?", email).First(&user).Error; err == nil {
		return errors.New("email already exists")
	}

	// Get the userProfile from username
	userProfile, _ := utils.GetUserProfileByUsername(userName)

	// Update the email
	if err := config.DB.Model(&userProfile).Update("email", email).Error; err != nil {
		return errors.New("failed to update email")
	}

	return nil
}

func ChangePassword(oldPassword string, newPassword string, userName string) error {

	// Check if the old password is correct
	var user models.Authentication
	if err := config.DB.Where("password = ?", oldPassword).First(&user).Error; err != nil {
		return errors.New("incorrect old password")
	}

	// Update the password
	if err := config.DB.Model(&user).Update("password", newPassword).Error; err != nil {
		return errors.New("failed to update password")
	}

	return nil
}
