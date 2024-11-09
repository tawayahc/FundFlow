package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
)

// Get Categories retrieves all categories for a user
func GetCategories(userID uint) ([]models.CategoryDTO, error) {
	var categories []models.CategoryDTO
	if err := config.DB.Table("categories").Select("id, name, color_code, amount").Where("user_profile_id = ?", userID).Find(&categories).Error; err != nil {
		return nil, errors.New("failed to retrieve categories")
	}

	return categories, nil
}

// Get Category retrieves a category by ID
func GetCategory(categoryID uint, userID uint) (models.Category, error) {
	var category models.Category
	if err := config.DB.Where("id = ? AND user_profile_id = ?", categoryID, userID).First(&category).Error; err != nil {
		return models.Category{}, errors.New("category not found")
	}

	return category, nil
}

// CreateCategory creates a new category
func CreateCategory(CreateCategory models.CreateCategoryRequest, userID uint) error {
	// Check if the category already exists
	var categoryCheck models.Category
	if err := config.DB.Where("name = ? AND user_profile_id = ?", CreateCategory.Name, userID).First(&categoryCheck).Error; err == nil {
		return errors.New("category already exists")
	}

	// Create a new category
	newCategory := models.Category{
		Name:          CreateCategory.Name,
		ColorCode:     CreateCategory.ColorCode,
		UserProfileID: userID,
		Amount:        CreateCategory.Amount,
	}
	if err := config.DB.Create(&newCategory).Error; err != nil {
		return errors.New("failed to create category")
	}

	return nil
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
func UpdateCategory(categoryID uint, UpdateCategory models.UpdateCategoryRequest, userID uint) error {
	var existingCategory models.Category
	if err := config.DB.First(&existingCategory, categoryID).Error; err != nil {
		return errors.New("category not found")
	}

	// Create a map to hold the fields to be updated
	updates := make(map[string]interface{})

	// Check each field for nil and add to the updates map if not nil
	if UpdateCategory.NewName != nil {
		// Check if the new name is already in use
		var nameCheck models.Category
		if err := config.DB.Where("name = ? AND user_profile_id = ?", *UpdateCategory.NewName, userID).First(&nameCheck).Error; err == nil {
			return errors.New("name already in use")
		} else {
			updates["name"] = *UpdateCategory.NewName
		}
	}
	if UpdateCategory.NewColorCode != nil {
		updates["color_code"] = *UpdateCategory.NewColorCode
	}

	if err := config.DB.Model(&existingCategory).Updates(updates).Error; err != nil {
		return errors.New("failed to update category")
	}

	return nil
}
