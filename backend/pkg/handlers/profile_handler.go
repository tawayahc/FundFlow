package handlers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Get a user profile
func GetProfile(c *gin.Context) {
	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	profile, err := services.GetProfile(claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, profile)
}

// Update a user profile
func UpdateProfile(c *gin.Context) {
	var profile models.UpdateUserProfileRequest
	if err := c.ShouldBindJSON(&profile); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.UpdateProfile(profile, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Profile updated successfully"})
}
