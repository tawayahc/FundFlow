package config

import (
	"log"

	"book-management-system/pkg/models" // Import your models

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDB() {
	dsn := "host=db user=postgres password=postgres dbname=bookdb port=5432 sslmode=disable"
	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to the database:", err)
	}

	// Run migrations for both Book and User models
	err = DB.AutoMigrate(&models.Book{}, &models.User{})
	if err != nil {
		log.Fatal("Failed to migrate database:", err)
	}
}

func InitDB() {
	ConnectDB()
}
