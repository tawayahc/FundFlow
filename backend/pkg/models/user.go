package models

import (
	"time"
	"github.com/golang-jwt/jwt/v5"
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

// Credentials struct for login (no email required for login)
type Credentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// Registration struct to include email during registration
type Registration struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

// Claims for JWT token
type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}