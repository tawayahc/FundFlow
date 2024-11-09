package models

import (
	"time"

	"gorm.io/gorm"
)

type Transaction struct {
	gorm.Model
	BankID        uint        `gorm:"not null"`
	Bank          BankDetail  `gorm:"constraint:OnDelete:CASCADE;foreignKey:BankID;references:ID"`
	Type          string      `gorm:"not null;check:type IN ('income', 'expense')"` // Enforce valid values
	Amount        float64     `gorm:"type:decimal(15,2);not null"`
	CategoryID    *uint       `gorm:""` // Nullable to allow deletion of Category without breaking references
	Category      Category    `gorm:"constraint:OnDelete:SET NULL;foreignKey:CategoryID;references:ID"`
	UserProfileID uint        `gorm:"not null"`
	UserProfile   UserProfile `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:UserProfileID;references:AuthID"`
	MetaData      *string     `gorm:"type:text;unique"`
	Memo          string      `gorm:"type:text"`
	CreatedAt     time.Time   `gorm:"not null"`
}

type CreateTransactionRequest struct {
	BankID        uint    `json:"bank_id" binding:"required"`
	Type          string  `json:"type" binding:"required"`
	Amount        float64 `json:"amount" binding:"required"`
	CategoryID    *uint   `json:"category_id"`
	CreatedAtDate string  `json:"created_at_date" binding:"required"`
	CreatedAtTime string  `json:"created_at_time"`
	MetaData      string  `json:"meta_data"`
	Memo          string  `json:"memo"`
}

type TransactionDTO struct {
	ID           uint    `json:"id"`
	BankID       uint    `json:"bank_id"`
	BankNickname string  `json:"bank_nickname"` // Custom name like "Soma"
	BankName     string  `json:"bank_name"`     // Official bank name like "KrungThai"
	Type         string  `json:"type"`
	Amount       float64 `json:"amount"`
	CategoryID   *uint   `json:"category_id"`
	MetaData     string  `json:"meta_data"`
	Memo         string  `json:"memo"`
	CreatedAt    string  `json:"created_at"`
}

type UpdateTransactionRequest struct {
	NewCategoryID *uint   `json:"new_category_id"`
	NewMemo       *string `json:"new_memo"`
}
