package services

import (
	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"fundflow/pkg/utils"
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

	var otpRecordCheck struct {
		OTP        string
		ExpiredAt  time.Time
		IsVerified bool
	}

	// Check if the user has already requested an OTP within the last 5 minutes and it's not verified
	if err := config.DB.Model(&models.OTP{}).
		Select("otp, expired_at, is_verified").
		Where("email = ?", email).
		Order("created_at desc"). // This ensures the latest OTP is selected
		Limit(1).                 // Only retrieve the latest OTP
		Scan(&otpRecordCheck).Error; err == nil {

		// Check if OTP was requested within the last 5 minutes and is unverified
		if time.Since(otpRecordCheck.ExpiredAt) < 5*time.Minute && !otpRecordCheck.IsVerified {
			return errors.New("OTP already requested within the last 5 minutes")
		}
	}

	// Generate a new OTP and store it in memory with a 5-minute expiration
	otp := utils.GenerateRandomOTP()
	otpStorage[email] = otp
	otpExpiry[email] = time.Now().Add(5 * time.Minute)

	// Store OTP in the database
	otpRecord := models.OTP{Email: email, OTP: otp, Expired_at: otpExpiry[email]}
	if err := config.DB.Create(&otpRecord).Error; err != nil {
		return errors.New("failed to store OTP")
	}

	// Send OTP to the user via email
	fmt.Println("OTP:", otp)
	if err := utils.SendOTPEmail(email, otp); err != nil {
		return errors.New("failed to send OTP email")
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

	// If OTP is valid and not expired, mark it as verified
	if err := config.DB.Model(&models.OTP{}).Where("email = ?", email).
		Order("created_at desc"). // This ensures the latest OTP is selected
		Limit(1).                 // Only retrieve the latest OTP
		Update("is_verified", true).Error; err != nil {
		return errors.New("failed to update OTP")
	}

	return nil
}

func CheckOtpVerification(email string) error {
	// Define a struct to hold the result from the database
	var otpRecord struct {
		IsVerified bool
	}

	// Query the OTP and expiration time in one database call
	if err := config.DB.Model(&models.OTP{}).
		Select("is_verified").
		Where("email = ?", email).
		Order("created_at desc"). // This ensures the latest OTP is selected
		Limit(1).                 // Only retrieve the latest OTP
		Scan(&otpRecord).Error; err != nil {
		return errors.New("OTP not found")
	}

	// Check if the OTP matches
	if !otpRecord.IsVerified {
		return errors.New("otp hasn't verified")
	}

	return nil
}

// UpdatePassword updates the password for a user based on their email
func UpdatePassword(email string, newPassword string) error {
	// Start a transaction to ensure atomicity
	tx := config.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// Fetch the user profile and related authentication in one query using Preload
	var userProfile models.UserProfile
	if err := tx.Preload("Authentication").Where("email = ?", email).First(&userProfile).Error; err != nil {
		tx.Rollback()
		return errors.New("user not found")
	}

	// Check if the related Authentication is loaded
	if userProfile.Authentication == nil {
		tx.Rollback()
		return errors.New("user authentication record not found")
	}

	// Hash the new password
	hashPassword, err := utils.HashPassword(newPassword)
	if err != nil {
		tx.Rollback()
		return errors.New("failed to hash password")
	}

	// Update the password directly on the related Authentication record
	userProfile.Authentication.Password = hashPassword
	if err := tx.Save(&userProfile.Authentication).Error; err != nil {
		tx.Rollback()
		return errors.New("failed to update password")
	}

	// Delete the OTP record associated with the email
	if err := tx.Where("email = ?", email).Delete(&models.OTP{}).Error; err != nil {
		tx.Rollback()
		return errors.New("failed to delete OTP record")
	}

	// Commit the transaction
	return tx.Commit().Error
}
