package config

import (
	"fmt"
	"log"
	"os"
	"time"

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
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
		PrepareStmt: true, // Enable prepared statement cache
	})
	if err != nil {
		log.Fatalf("Failed to connect to the database: %v", err)
	}

	// Get the underlying *sql.DB instance
	sqlDB, err := DB.DB()
	if err != nil {
		log.Fatalf("Failed to get underlying *sql.DB: %v", err)
	}

	// Configure connection pool settings
	sqlDB.SetMaxIdleConns(10)                  // Maximum number of idle connections
	sqlDB.SetMaxOpenConns(100)                 // Maximum number of open connections
	sqlDB.SetConnMaxLifetime(time.Hour)        // Maximum lifetime of a connection
	sqlDB.SetConnMaxIdleTime(10 * time.Minute) // Maximum idle time for a connection

	// Verify connection
	if err := sqlDB.Ping(); err != nil {
		log.Fatalf("Failed to ping database: %v", err)
	}

	// Run migrations for Book and User models
	err = DB.AutoMigrate(&models.Authentication{}, &models.UserProfile{}, &models.OTP{}, &models.Transaction{}, &models.BankDetail{}, &models.Category{}, &models.TransferTransaction{})
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
