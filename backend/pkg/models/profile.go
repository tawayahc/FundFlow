package models

import (
	"time"

	"gorm.io/gorm"
)

// UserProfile model
type UserProfile struct {
	gorm.Model
	AuthID         uint            `gorm:"unique;not null"` // Foreign key referencing Authentication
	FirstName      string          // First name
	LastName       string          // Last name
	UserProfilePic string          // Profile picture
	Email          string          `gorm:"unique;not null"` // Email must be unique
	PhoneNumber    string          // Phone
	Address        string          // Address
	DateOfBirth    time.Time       // Date of birth
	Authentication *Authentication `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:AuthID"` // Belongs to Authentication
	Transactions   []Transaction   `gorm:"foreignKey:UserProfileID"`                                       // One-to-many relation with Transaction
	BankDetails    []BankDetail    `gorm:"foreignKey:UserProfileID"`                                       // One-to-many relation with BankDetail
	Categories     []Category      `gorm:"foreignKey:UserProfileID"`                                       // One-to-many relation with Category
}

type UpdateUserProfileRequest struct {
	NewUserName       *string    `json:"new_user_name"`
	NewFirstName      *string    `json:"new_first_name"`
	NewLastName       *string    `json:"new_last_name"`
	NewUserProfilePic *string    `json:"new_user_profile_pic"`
	NewEmail          *string    `json:"new_email"`
	NewPhoneNumber    *string    `json:"new_phone_number"`
	NewAddress        *string    `json:"new_address"`
	NewDateOfBirth    *time.Time `json:"new_date_of_birth"`
}

type UserProfileDTO struct {
	ID             uint      `json:"id"`
	Username       string    `json:"username"`
	FirstName      string    `json:"first_name"`
	LastName       string    `json:"last_name"`
	UserProfilePic string    `json:"user_profile_pic"`
	Email          string    `json:"email"`
	PhoneNumber    string    `json:"phone_number"`
	Address        string    `json:"address"`
	DateOfBirth    time.Time `json:"date_of_birth"`
}
