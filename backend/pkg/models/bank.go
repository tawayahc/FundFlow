package models

import (
	"gorm.io/gorm"
)

type BankDetail struct {
	gorm.Model
	Name          string        `gorm:"size:50;not null;unique"` // Unique name for each account
	BankName      string        `gorm:"size:50;not null"`        // Bank name
	Amount        float64       `gorm:"type:decimal(15,2);default:0.00"`
	Transactions  []Transaction `gorm:"foreignKey:BankID"`
	UserProfileID uint          `gorm:"not null"`
	UserProfile   UserProfile   `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:UserProfileID;references:AuthID"`
}

type CreateBankRequest struct {
	Name     string `json:"name" binding:"required"`
	BankName string `json:"bank_name" binding:"required"`
}
