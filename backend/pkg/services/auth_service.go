package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"fundflow/pkg/utils"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func CreateUser(creds models.Registration) error {
	// Start a transaction
	tx := config.DB.Begin()

	// Hash the password
	hashedPassword, err := utils.HashPassword(creds.Password)
	if err != nil {
		return err
	}

	// Create a new user record for authentication
	userAuth := models.Authentication{Username: creds.Username, Password: hashedPassword}
	if err := tx.Create(&userAuth).Error; err != nil {
		tx.Rollback() // Rollback the transaction in case of error
		return errors.New("username already exists")
	}

	// Create a new user profile
	userProfile := models.UserProfile{Email: creds.Email, AuthID: userAuth.ID} // Assuming there's a foreign key
	if err := tx.Create(&userProfile).Error; err != nil {
		tx.Rollback() // Rollback the transaction in case of error
		return errors.New("email already exists")
	}

	// Commit the transaction
	if err := tx.Commit().Error; err != nil {
		return errors.New("failed to complete transaction")
	}

	return nil
}

func ValidateUserCredentials(creds models.Credentials) (*models.Authentication, error) {
	var user models.Authentication
	result := config.DB.Where("username = ?", creds.Username).First(&user)

	// Check if user exists and handle failed login attempts
	if result.Error != nil {
		return nil, errors.New("invalid credentials")
	}

	// Validate password
	if err := utils.ComparePasswords(user.Password, creds.Password); err != nil {
		// Increment failed login attempts
		user.FailedAttempts++
		config.DB.Save(&user)
		return nil, errors.New("invalid credentials")
	}

	// Reset failed login attempts upon successful login
	user.FailedAttempts = 0
	user.LastLogin = time.Now() // Update last login timestamp
	config.DB.Save(&user)

	return &user, nil
}

func GenerateJWTToken(username string, userID uint) (string, error) {
	expirationTime := time.Now().Add(24 * time.Hour)
	claims := &models.Claims{
		Username: username,
		UserID:   userID,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	// Sign the token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(config.GetEnv("JWT_SECRET")))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
