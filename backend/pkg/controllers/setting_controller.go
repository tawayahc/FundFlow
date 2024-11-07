package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ChangeEmail changes the email of the user
func ChangeEmail(c *gin.Context) {
	var emailRequest models.ChangeEmailRequest
	if err := c.ShouldBindJSON(&emailRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	userName, _ := utils.ExtractUsernameFromToken(c.GetHeader("Authorization"))

	err := services.ChangeEmail(emailRequest.NewEmail, userName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Email updated successfully"})
}

// ChangePassword changes the password of the user
func ChangePassword(c *gin.Context) {
	var passwordRequest models.ChangePasswordRequest
	if err := c.ShouldBindJSON(&passwordRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	userName, _ := utils.ExtractUsernameFromToken(c.GetHeader("Authorization"))

	err := services.ChangePassword(passwordRequest.OldPassword, passwordRequest.NewPassword, userName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Password updated successfully"})
}

func DeleteAccount(c *gin.Context) {
	userName, _ := utils.ExtractUsernameFromToken(c.GetHeader("Authorization"))

	err := services.DeleteAccount(userName)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Account deleted successfully"})
}
