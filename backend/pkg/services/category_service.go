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

// Get Categories retrieves all categories for a user
func GetCategories(userID uint) ([]models.CategoryDTO, error) {
	var categories []models.CategoryDTO
	if err := config.DB.Table("categories").Select("id, name, color_code").Where("user_profile_id = ?", userID).Find(&categories).Error; err != nil {
		return nil, errors.New("failed to retrieve categories")
	}

	return categories, nil
}

// Delete Category deletes a category
func DeleteCategory(categoryID uint, userID uint) error {
	var category models.Category
	if err := config.DB.Where("id = ? AND user_profile_id = ?", categoryID, userID).First(&category).Error; err != nil {
		return errors.New("category not found")
	}

	if err := config.DB.Unscoped().Delete(&category).Error; err != nil {
		return errors.New("failed to delete category")
	}

	return nil
}

// UpdateCategory updates a category
func UpdateCategory(categoryID uint, categoryName string, colorCode string, userID uint) error {
	var category models.Category
	// Check if the category exists
	if err := config.DB.Where("id = ? AND user_profile_id = ?", categoryID, userID).First(&category).Error; err != nil {
		return errors.New("category not found")
	}

	// Check repetition of category name
	var categoryCheck models.Category
	if err := config.DB.Where("name = ? AND user_profile_id = ?", categoryName, userID).First(&categoryCheck).Error; err == nil {
		return errors.New("category already exists")
	}

	// Update the category
	if err := config.DB.Model(&category).Updates(models.Category{Name: categoryName, ColorCode: colorCode}).Error; err != nil {
		return errors.New("failed to update category")
	}

	return nil
}
