package controllers

import (
	"book-management-system/pkg/models"
	"book-management-system/pkg/services"
	"book-management-system/pkg/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GenerateOTP(c *gin.Context) {
	var otpRequest models.OTPRequest
	if err := c.ShouldBindJSON(&otpRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	err := services.GenerateOTP(otpRequest.Email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate OTP"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "OTP generated successfully"})
}

func VerifyOTP(c *gin.Context) {
	var otpVerifyRequest models.OTPVerifyRequest
	if err := c.ShouldBindJSON(&otpVerifyRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	err := services.VerifyOTP(otpVerifyRequest.Email, otpVerifyRequest.OTP)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "OTP verified successfully"})
}

func Repassword(c *gin.Context) {
	var repasswordRequest models.RepasswordRequest
	if err := c.ShouldBindJSON(&repasswordRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Extract and validate JWT token
	authHeader := c.GetHeader("Authorization")
	token, err := utils.ValidateToken(authHeader)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	// Update the user's password
	err = services.UpdatePassword(token.Username, repasswordRequest.NewPassword)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update password"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Password updated successfully"})
}
