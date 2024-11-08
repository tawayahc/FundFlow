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

// Get all categories
func GetCategories(c *gin.Context) {
	userProfile, _ := utils.GetUserProfileFromToken(c.GetHeader("Authorization"))

	categories, err := services.GetCategories(userProfile.AuthID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, categories)
}

// Delete a category
func DeleteCategory(c *gin.Context) {
	var category models.DeleteCategoryRequest
	if err := c.ShouldBindJSON(&category); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userProfile, _ := utils.GetUserProfileFromToken(c.GetHeader("Authorization"))

	if err := services.DeleteCategory(category.ID, userProfile.AuthID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Category deleted successfully"})
}

func UpdateCategory(c *gin.Context) {
	var category models.UpdateCategoryRequest
	if err := c.ShouldBindJSON(&category); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userProfile, _ := utils.GetUserProfileFromToken(c.GetHeader("Authorization"))

	if err := services.UpdateCategory(category.CategoryID, category.NewName, category.NewColorCode, userProfile.AuthID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Category updated successfully"})
}
