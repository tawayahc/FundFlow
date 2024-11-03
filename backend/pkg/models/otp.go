package models

import (
	"time"

	"gorm.io/gorm"
)

type OTP struct {
	gorm.Model
	Email      string
	OTP        string
	IsVerified bool
	Expired_at time.Time
}

type OTPRequest struct {
	Email string `json:"email" binding:"required"`
}

type OTPVerifyRequest struct {
	Email string `json:"email" binding:"required"`
	OTP   string `json:"otp" binding:"required"`
}

type RepasswordRequest struct {
	Email       string `json:"email" binding:"required"`
	NewPassword string `json:"new_password" binding:"required,min=8"`
}
