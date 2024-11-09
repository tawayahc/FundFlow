package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Get a Category by ID
func GetCategory(c *gin.Context) {
	categoryID, err := strconv.ParseUint(c.Param("category_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category ID"})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	category, err := services.GetCategory(uint(categoryID), claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, category)
}

// Get all categories
func GetCategories(c *gin.Context) {
	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	categories, err := services.GetCategories(claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, categories)
}

// Creates a new category
func CreateCategory(c *gin.Context) {
	var category models.CreateCategoryRequest
	if err := c.ShouldBindJSON(&category); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.CreateCategory(category.Name, category.ColorCode, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Category created successfully"})
}

// Update a category
func UpdateCategory(c *gin.Context) {
	categoryID, err := strconv.ParseUint(c.Param("category_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category ID"})
		return
	}

	var category models.UpdateCategoryRequest
	if err := c.ShouldBindJSON(&category); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.UpdateCategory(uint(categoryID), category.NewName, category.NewColorCode, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Category updated successfully"})
}

// Delete a category
func DeleteCategory(c *gin.Context) {
	categoryID, err := strconv.ParseUint(c.Param("category_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category ID"})
		return
	}

	var category models.DeleteCategoryRequest
	if err := c.ShouldBindJSON(&category); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.DeleteCategory(uint(categoryID), claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Category deleted successfully"})
}
