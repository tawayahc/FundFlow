package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
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
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
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

	// Check OTP verification
	err := services.CheckOtpVerification(repasswordRequest.Email)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	// Update password
	err = services.UpdatePassword(repasswordRequest.Email, repasswordRequest.NewPassword)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Password updated successfully"})
}
