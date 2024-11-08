package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

// Creates a new category
func CreateCategory(c *gin.Context) {
	var category models.CreateCategoryRequest
	if err := c.ShouldBindJSON(&category); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userProfile, _ := utils.GetUserProfileFromToken(c.GetHeader("Authorization"))

	if err := services.CreateCategory(category.Name, category.ColorCode, userProfile.AuthID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Category created successfully"})
}
