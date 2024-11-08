package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
)

// CreateCategory creates a new category
func CreateCategory(categoryName string, colorCode string, userID uint) error {
	// Check if the category already exists
	var category models.Category
	if err := config.DB.Where("name = ? AND user_profile_id = ?", categoryName, userID).First(&category).Error; err == nil {
		return errors.New("category already exists")
	}

	// Create a new category
	newCategory := models.Category{Name: categoryName, ColorCode: colorCode, UserProfileID: userID}
	if err := config.DB.Create(&newCategory).Error; err != nil {
		return errors.New("failed to create category")
	}

	return nil
}
