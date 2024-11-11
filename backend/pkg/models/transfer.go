package models

import (
	"time"

	"gorm.io/gorm"
)

type TransferTransaction struct {
	gorm.Model
	FromBankID    uint `gorm:"not null"`
	FromBank      BankDetail
	ToBankID      uint `gorm:"not null"`
	ToBank        BankDetail
	Amount        float64     `gorm:"type:decimal(15,2);not null"`
	UserProfileID uint        `gorm:"not null"`
	UserProfile   UserProfile `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:UserProfileID;references:AuthID"`
	CreatedAt     time.Time   `gorm:"not null"`
}

type TransferRequest struct {
	FromBankID    uint    `json:"from_bank_id" binding:"required"`
	ToBankID      uint    `json:"to_bank_id" binding:"required"`
	Amount        float64 `json:"amount" binding:"required"`
	CreatedAtDate string  `json:"created_at_date" binding:"required"`
	CreatedAtTime string  `json:"created_at_time"`
}

type TransferDTO struct {
	FromBankID       uint    `json:"from_bank_id"`
	FromBankNickName string  `json:"from_bank_nickname"`
	FromBankName     string  `json:"from_bank_name"`
	ToBankID         uint    `json:"to_bank_id"`
	ToBankNickName   string  `json:"to_bank_nickname"`
	ToBankName       string  `json:"to_bank_name"`
	Amount           float64 `json:"amount"`
	CreatedAt        string  `json:"created_at"`
}
