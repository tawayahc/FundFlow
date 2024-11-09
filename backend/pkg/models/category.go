package models

import (
	"gorm.io/gorm"
)

type Category struct {
	gorm.Model
	Name          string        `gorm:"size:50;not null"`
	ColorCode     string        `gorm:"size:10;not null"`
	Amount        float64       `gorm:"type:decimal(15,2);default:0.00"`
	UserProfileID uint          `gorm:"not null"`
	UserProfile   UserProfile   `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:UserProfileID;references:AuthID"`
	Transactions  []Transaction `gorm:"foreignKey:CategoryID"`
}

type CreateCategoryRequest struct {
	Name      string  `json:"name" binding:"required"`
	ColorCode string  `json:"color_code" binding:"required"`
	Amount    float64 `json:"amount" binding:"required"`
}

type DeleteCategoryRequest struct {
	ID uint `json:"id" binding:"required"`
}

type UpdateCategoryRequest struct {
	NewName      *string  `json:"new_name"`
	NewColorCode *string  `json:"new_color_code"`
	Amount       *float64 `json:"amount"`
}

// Data Transfer Object
type CategoryDTO struct {
	ID        uint    `json:"id"`
	Name      string  `json:"name"`
	ColorCode string  `json:"color_code"`
	Amount    float64 `json:"amount"`
}

// All transactions in a category
type CategoryTransactionsDTO struct {
	CategoryDTO
	Transactions []TransactionDTO `json:"transactions"`
}
