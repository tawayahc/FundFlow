package controllers

import (
	"book-management-system/pkg/config"
	"book-management-system/pkg/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5" // Correct import path
	"golang.org/x/crypto/bcrypt"
)

// Credentials struct for login (no email required for login)
type Credentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// Registration struct to include email during registration
type Registration struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

// Claims for JWT token
type Claims struct {
	Username string `json:"username"`
	jwt.RegisteredClaims
}

// Register a new user (with email)
func Register(c *gin.Context) {
	var creds Registration // Use Registration struct to include email
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Hash the password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(creds.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error hashing password"})
		return
	}

	// Start a transaction
	tx := config.DB.Begin()

	// Create a new user record for authentication
	userAuth := models.Authentication{Username: creds.Username, Password: string(hashedPassword)}
	if err := tx.Create(&userAuth).Error; err != nil {
		tx.Rollback() // Rollback the transaction in case of error
		c.JSON(http.StatusBadRequest, gin.H{"error": "Username already exists"})
		return
	}

	// Create a new user profile
	userProfile := models.UserProfile{Email: creds.Email, AuthID: userAuth.AuthID} // Assuming there's a foreign key
	if err := tx.Create(&userProfile).Error; err != nil {
		tx.Rollback() // Rollback the transaction in case of error
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already exists"})
		return
	}

	// Commit the transaction
	if err := tx.Commit().Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to complete transaction"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User registered successfully"})
}

// Login a user and issue a JWT (email not required for login)
func Login(c *gin.Context) {
	var creds Credentials // Use Credentials struct for login (no email)
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Fetch user based on username
	var user models.Authentication
	result := config.DB.Where("username = ?", creds.Username).First(&user)

	// Check if user exists and handle failed login attempts
	if result.Error != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	// Validate password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(creds.Password)); err != nil {
		// Increment failed login attempts
		user.FailedAttempts++
		config.DB.Save(&user)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	// Reset failed login attempts upon successful login
	user.FailedAttempts = 0
	user.LastLogin = time.Now() // Update last login timestamp
	config.DB.Save(&user)

	// Generate JWT token
	expirationTime := time.Now().Add(24 * time.Hour)
	claims := &Claims{
		Username: creds.Username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	// Sign the token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(config.GetEnv("JWT_SECRET")))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error generating token"})
		return
	}

	// Send the token in the response
	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}
