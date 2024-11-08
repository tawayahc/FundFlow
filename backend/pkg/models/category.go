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
	Name      string `json:"name" binding:"required"`
	ColorCode string `json:"color_code" binding:"required"`
}

type DeleteCategoryRequest struct {
	ID uint `json:"id" binding:"required"`
}

type UpdateCategoryRequest struct {
	CategoryID   uint   `json:"category_id" binding:"required"`
	NewName      string `json:"new_name" binding:"required"`
	NewColorCode string `json:"new_color_code" binding:"required"`
}

// Data Transfer Object
type CategoryDTO struct {
	ID        uint   `json:"id"`
	Name      string `json:"name"`
	ColorCode string `json:"color_code"`
}