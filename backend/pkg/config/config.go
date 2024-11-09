package config

import (
	"fmt"
	"log"
	"os"

	"fundflow/pkg/models" // Import your models

	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/joho/godotenv"
)

var DB *gorm.DB

// Load environment variables from .env
func LoadEnv() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
}

// ConnectDB initializes the database connection using environment variables
func ConnectDB() {
	// Get environment variables for DSN
	host := GetEnv("DB_HOST")
	user := GetEnv("DB_USER")
	password := GetEnv("DB_PASSWORD")
	dbName := GetEnv("DB_NAME")
	port := GetEnv("DB_PORT")
	sslMode := GetEnv("DB_SSLMODE")

	// Build DSN string
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		host, user, password, dbName, port, sslMode)

	// Open connection to the database
	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}

	// Run migrations for Book and User models
	err = DB.AutoMigrate(&models.Authentication{}, &models.UserProfile{}, &models.OTP{}, &models.Transaction{}, &models.BankDetail{}, &models.Category{})
	if err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}
}

// InitDB initializes the environment variables and database connection
func InitDB() {
	LoadEnv()   // Load the environment variables first
	ConnectDB() // Then connect to the database
}

// GetEnv is a helper function to retrieve environment variables
func GetEnv(key string) string {
	value := os.Getenv(key)
	if value == "" {
		log.Fatalf("Environment variable not set: %s", key)
	}
	return value
}
