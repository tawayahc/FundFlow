package models

import (
	"time"
)

// Authentication model
type Authentication struct {
	AuthID         uint      `gorm:"primaryKey"`      // Primary key
	Username       string    `gorm:"unique;not null"` // Username, must be unique
	Password       string    `gorm:"not null"`        // Hashed version of the password
	LastLogin      time.Time // Timestamp of last login
	FailedAttempts int       // Number of failed login attempts

	UserProfile UserProfile `gorm:"foreignKey:AuthID"` // One-to-one relation with UserProfile
}

// UserProfile model
type UserProfile struct {
	UserID      uint      `gorm:"primaryKey"` // Primary key
	FirstName   string    // First name
	LastName    string    // Last name
	Email       string    `gorm:"unique;not null"` // Email must be unique
	PhoneNumber string    // Phone number
	Address     string    // Address
	DateOfBirth time.Time // Date of birth

	AuthID uint // Foreign key for the one-to-one relationship
}
