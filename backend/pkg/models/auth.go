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

// Credentials struct for login (no email required for login)
type Credentials struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required,min=8"`
}

// Registration struct to include email during registration
type Registration struct {
	Username string `json:"username" binding:"required"`
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required,min=8"`
}

// Claims for JWT token
type Claims struct {
	Username string `json:"username"`
	UserID   uint   `json:"user_id"`
	jwt.RegisteredClaims
}
