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
	// Get userAuthentication from username
	var userAuthentication models.Authentication
	config.DB.Where("username = ?", userName).First(&userAuthentication)

	// Validate the old password
	if err := utils.ComparePasswords(userAuthentication.Password, oldPassword); err != nil {
		return errors.New("invalid old password")
	}

	// Update the password
	hashedPassword, err := utils.HashPassword(newPassword)
	if err != nil {
		return errors.New("failed to hash password")
	}

	if err := config.DB.Model(&userAuthentication).Update("password", hashedPassword).Error; err != nil {
		return errors.New("failed to update password")
	}

	return nil
}
