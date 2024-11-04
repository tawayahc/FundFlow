package controllers

import (
	"book-management-system/pkg/models"
	"book-management-system/pkg/services"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Register a new user (with email)
func Register(c *gin.Context) {
	var creds models.Registration // Use Registration struct to include email
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Create a new user
	if err := services.CreateUser(creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User registered successfully"})
}

// Login a user and issue a JWT (email not required for login)
func Login(c *gin.Context) {
	var creds models.Credentials // Use Credentials struct for login (no email)
	if err := c.ShouldBindJSON(&creds); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Validate user credentials
	user, err := services.ValidateUserCredentials(creds)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	// Generate JWT token
	tokenString, err := services.GenerateJWTToken(user.Username)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error generating token"})
		return
	}

	// Send the token in the response
	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}
