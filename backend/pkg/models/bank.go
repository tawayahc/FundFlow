package models

import (
	"gorm.io/gorm"
)

type BankDetail struct {
	gorm.Model
	Name          string        `gorm:"size:50;not null"`
	BankName      string        `gorm:"size:50;not null"` // Bank name
	Amount        float64       `gorm:"type:decimal(15,2);default:0.00"`
	Transactions  []Transaction `gorm:"foreignKey:BankID"`
	UserProfileID uint          `gorm:"not null"`
	UserProfile   UserProfile   `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:UserProfileID;references:AuthID"`
}

type CreateBankRequest struct {
	Name     string `json:"name" binding:"required"`
	BankName string `json:"bank_name" binding:"required"`
}

type UpdateBankRequest struct {
	Name     string `json:"name" binding:"required"`
	BankName string `json:"bank_name" binding:"required"`
}

type BankDetailDTO struct {
	ID       uint    `json:"id"`
	Name     string  `json:"name"`
	BankName string  `json:"bank_name"`
	Amount   float64 `json:"amount"`
}

type TransferRequest struct {
	FromBankID uint    `json:"from_bank_id" binding:"required"`
	ToBankID   uint    `json:"to_bank_id" binding:"required"`
	Amount     float64 `json:"amount" binding:"required"`
}

// All transactions in a bank
type BankTransactionsDTO struct {
	BankDetailDTO
	Transactions []TransactionDTO `json:"transactions"`
}