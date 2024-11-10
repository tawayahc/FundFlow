package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
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

	userID, _ := utils.GetUserIDByUserName(creds.Username)

	// Generate JWT token
	tokenString, err := services.GenerateJWTToken(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error generating token"})
		return
	}

	// Send the token in the response
	c.JSON(http.StatusOK, gin.H{"token": tokenString})
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
	tokenString, err := services.GenerateJWTToken(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error generating token"})
		return
	}

	// Send the token in the response
	c.JSON(http.StatusOK, gin.H{"token": tokenString})
}
