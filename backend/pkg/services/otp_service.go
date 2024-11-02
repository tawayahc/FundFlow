package services

import (
	"book-management-system/pkg/config"
	"book-management-system/pkg/models"
	"book-management-system/pkg/utils"
	"errors"
	"fmt"
	"time"
)

var otpStorage = make(map[string]string)
var otpExpiry = make(map[string]time.Time)

func GenerateOTP(email string) error {
	var user models.UserProfile
	if err := config.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return errors.New("email not found")
	}

	otp := utils.GenerateRandomOTP()
	otpStorage[email] = otp
	otpExpiry[email] = time.Now().Add(5 * time.Minute)

	// Store OTP in the database
	otpRecord := models.OTP{Email: email, OTP: otp, Expired_at: otpExpiry[email]}
	if err := config.DB.Create(&otpRecord).Error; err != nil {
		return errors.New("failed to store OTP")
	}

	return nil
}

func VerifyOTP(email string, otp string) error {
	// Define a struct to hold the result from the database
	var otpRecord struct {
		OTP        string
		Expired_at time.Time
	}

	fmt.Println(email, otp)

	// Query the OTP and expiration time in one database call
	if err := config.DB.Model(&models.OTP{}).
		Select("otp, expired_at").
		Where("email = ?", email).
		Order("created_at desc"). // This ensures the latest OTP is selected
		Limit(1).                 // Only retrieve the latest OTP
		Scan(&otpRecord).Error; err != nil {
		return errors.New("OTP not found")
	}

	fmt.Println(otpRecord)

	// Check if the OTP matches
	if otpRecord.OTP != otp {
		return errors.New("invalid otp")
	}

	// Check if the OTP has expired
	if time.Now().After(otpRecord.Expired_at) {
		return errors.New("otp expired")
	}

	// If OTP is valid and not expired, delete the OTP from the database
	if err := config.DB.Where("email = ?", email).Delete(&models.OTP{}).Error; err != nil {
		return errors.New("failed to delete otp")
	}

	return nil
}

func UpdatePassword(username string, newPassword string) error {
	// Fetch the user based on the username
	var user models.Authentication
	if err := config.DB.Where("username = ?", username).First(&user).Error; err != nil {
		return errors.New("user not found")
	}

	// Update the password
	hashPassword, err := utils.HashPassword(newPassword)
	if err != nil {
		return errors.New("failed to hash password")
	}

	user.Password = hashPassword
	if err := config.DB.Save(&user).Error; err != nil {
		return errors.New("failed to update password")
	}

	return nil
}
