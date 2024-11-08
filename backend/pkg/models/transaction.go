package models

import (
	"gorm.io/gorm"
)

type Transaction struct {
	gorm.Model
	BankID        uint        `gorm:"not null"`
	Bank          BankDetail  `gorm:"constraint:OnDelete:CASCADE;foreignKey:BankID;references:ID"`
	Type          string      `gorm:"not null"`
	Amount        float64     `gorm:"type:decimal(15,2);not null"`
	CategoryID    *uint       `gorm:""` // Nullable to allow deletion of Category without breaking references
	Category      Category    `gorm:"constraint:OnDelete:SET NULL;foreignKey:CategoryID;references:ID"`
	UserProfileID uint        `gorm:"not null"`
	UserProfile   UserProfile `gorm:"constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:UserProfileID;references:AuthID"`
	MetaData      string      `gorm:"type:text"`
	Memo          string      `gorm:"type:text"`
}

