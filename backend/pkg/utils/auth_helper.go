package utils

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"

	"golang.org/x/crypto/bcrypt"
)

// HashPassword hashes the given password using bcrypt
func HashPassword(password string) (string, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", errors.New("error hashing password")
	}
	return string(hashedPassword), nil
}

// ComparePasswords compares the given password with the hashed password
func ComparePasswords(hashedPassword string, password string) error {
	err := bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(password))
	if err != nil {
		return errors.New("invalid password")
	}
	return nil
}

// GetUserProfileByUserID retrieves a user profile by user ID
func GetUserProfileByUserID(userID uint) (*models.UserProfile, error) {
	var auth models.Authentication
	if err := config.DB.Where("id = ?", userID).First(&auth).Error; err != nil {
		return nil, errors.New("user not found")
	}

	var userProfile models.UserProfile
	if err := config.DB.Where("auth_id = ?", userID).First(&userProfile).Error; err != nil {
		return nil, errors.New("user profile not found")
	}

	return &userProfile, nil
}

// GetUserProfileByUserName retrieves a user profile by username
func GetUserProfileByUserName(username string) (*models.UserProfile, error) {
	var auth models.Authentication
	if err := config.DB.Where("username = ?", username).First(&auth).Error; err != nil {
		return nil, errors.New("user not found")
	}

	var userProfile models.UserProfile
	if err := config.DB.Where("auth_id = ?", auth.ID).First(&userProfile).Error; err != nil {
		return nil, errors.New("user profile not found")
	}

	return &userProfile, nil
}
