package models

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
	"gorm.io/gorm"
)

// Authentication model
type Authentication struct {
	gorm.Model
	Username       string       `gorm:"unique;not null"` // Username, must be unique
	Password       string       `gorm:"not null"`        // Hashed version of the password
	LastLogin      time.Time    // Timestamp of last login
	FailedAttempts int          // Number of failed login attempts
	UserProfile    *UserProfile `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:AuthID"` // One-to-one relation with UserProfile
}

// UserProfile model
type UserProfile struct {
	gorm.Model
	AuthID         uint            `gorm:"unique;not null"` // Foreign key referencing Authentication
	FirstName      string          // First name
	LastName       string          // Last name
	Email          string          `gorm:"unique;not null"` // Email must be unique
	PhoneNumber    string          // Phone
	Address        string          // Address
	DateOfBirth    time.Time       // Date of birth
	Authentication *Authentication `gorm:"foreignKey:AuthID"` // Belongs to Authentication
}

// Credentials struct for login (no email required for login)
type Credentials struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// Registration struct to include email during registration
type Registration struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// Claims for JWT token
type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}
