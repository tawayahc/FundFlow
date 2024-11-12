package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"

	"gorm.io/gorm"
)

// GetCategories retrieves all categories for a user
func GetCategories(userID uint) ([]models.CategoryDTO, error) {
	var categories []models.CategoryDTO

	// Retrieve categories for the user
	if err := config.DB.Table("categories").Select("id, name, color_code, amount").
		Where("user_profile_id = ?", userID).Find(&categories).Error; err != nil {
		return nil, errors.New("failed to retrieve categories")
	}

	// Calculate total bank amount for the user
	var totalBankAmount float64
	if err := config.DB.Table("bank_details").Select("COALESCE(sum(amount), 0)").
		Where("user_profile_id = ?", userID).Row().Scan(&totalBankAmount); err != nil {
		return nil, errors.New("failed to retrieve total bank amount")
	}

	// Calculate total amount across all categories for the user
	var totalCategoriesAmount float64
	config.DB.Table("categories").Select("COALESCE(sum(amount), 0)").
		Where("user_profile_id = ?", userID).Row().Scan(&totalCategoriesAmount)

	// Calculate the amount of null category transactions
	// var nullCategoryAmount float64
	// config.DB.Table("transactions").Select("COALESCE(sum(amount), 0)").
	// 	Where("user_profile_id = ? AND category_id IS NULL", userID).Row().Scan(&nullCategoryAmount)

	// Create and add Cash Box category
	cashBox := models.CategoryDTO{
		ID:        0,
		Name:      "Cash Box",
		ColorCode: "0xFFFFFFF",
		Amount:    totalBankAmount - totalCategoriesAmount,
	}

	// Organize results in the desired pattern
	result := []models.CategoryDTO{cashBox}
	result = append(result, categories...)

	return result, nil
}

// GetCategory retrieves transactions for a specific category or "Other" category if categoryID is 0
func GetCategory(categoryID, userID uint) (models.CategoryTransactionsDTO, error) {
	var category models.CategoryDTO
	var transactions []models.TransactionDTO

	// Determine if fetching "Other" category or a specific category
	if categoryID == 0 {
		// Fetch the "Other" category total amount (where category_id is NULL)
		if err := config.DB.Table("transactions").Select("COALESCE(sum(amount), 0)").
			Where("user_profile_id = ? AND category_id IS NULL", userID).
			Row().Scan(&category.Amount); err != nil {
			return models.CategoryTransactionsDTO{}, errors.New("failed to retrieve 'Other' category amount")
		}

		// Define the "Other" category
		category = models.CategoryDTO{
			ID:        0,
			Name:      "Other",
			ColorCode: "0xFFFFFFF",
			Amount:    category.Amount * -1,
		}

		// Retrieve transactions with no category (category_id is NULL)
		if err := config.DB.Table("transactions").
			Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, transactions.created_at, bank_details.name as bank_nickname, bank_details.bank_name").
			Joins("LEFT JOIN bank_details ON transactions.bank_id = bank_details.id").
			Where("transactions.category_id IS NULL AND transactions.user_profile_id = ?", userID).
			Find(&transactions).Error; err != nil {
			return models.CategoryTransactionsDTO{}, errors.New("failed to retrieve transactions for 'Other' category")
		}

	} else {
		// Fetch specific category details
		if err := config.DB.Table("categories").
			Select("id, name, color_code, amount").
			Where("id = ? AND user_profile_id = ?", categoryID, userID).
			First(&category).Error; err != nil {
			return models.CategoryTransactionsDTO{}, errors.New("category not found")
		}

		// Retrieve transactions for the specific category
		if err := config.DB.Table("transactions").
			Select("transactions.id, transactions.type, transactions.amount, transactions.category_id, transactions.meta_data, transactions.memo, transactions.bank_id, bank_details.name as bank_nickname, bank_details.bank_name").
			Joins("LEFT JOIN bank_details ON transactions.bank_id = bank_details.id").
			Where("transactions.category_id = ? AND transactions.user_profile_id = ?", categoryID, userID).
			Find(&transactions).Error; err != nil {
			return models.CategoryTransactionsDTO{}, errors.New("failed to retrieve transactions for category")
		}
	}

	return models.CategoryTransactionsDTO{CategoryDTO: category, Transactions: transactions}, nil
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
func DeleteCategory(categoryID, userID uint) error {
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
	if UpdateCategory.NewAmount != nil {
		updates["amount"] = *UpdateCategory.NewAmount
	}

	if len(updates) == 0 {
		return errors.New("no fields to update")
	}

	if err := config.DB.Model(&existingCategory).Updates(updates).Error; err != nil {
		return errors.New("failed to update category")
	}

	return nil
}

// TransferCategory transfers an amount between two categories
func TransferCategory(transferRequest models.TransferCategoryRequest, userID uint) error {
	// Validate the transfer amount
	if transferRequest.Amount <= 0 {
		return errors.New("invalid transfer amount")
	}

	// Check if the categories exist and are different
	var fromCategory, toCategory models.Category
	if transferRequest.FromCategoryID != 0 {
		if err := config.DB.Where("id = ? AND user_profile_id = ?", transferRequest.FromCategoryID, userID).First(&fromCategory).Error; err != nil {
			return errors.New("from category not found")
		}
		if fromCategory.Amount < transferRequest.Amount {
			return errors.New("insufficient funds in the from category")
		}
	}

	if err := config.DB.Where("id = ? AND user_profile_id = ?", transferRequest.ToCategoryID, userID).First(&toCategory).Error; err != nil {
		return errors.New("to category not found")
	}
	if transferRequest.FromCategoryID != 0 && fromCategory.ID == toCategory.ID {
		return errors.New("cannot transfer to the same category")
	}

	// Check Cash Box if FromCategoryID is 0 (Cash Box transaction)
	if transferRequest.FromCategoryID == 0 {
		var totalBankAmount, totalCategoriesAmount float64
		config.DB.Table("bank_details").Select("COALESCE(sum(amount), 0)").Where("user_profile_id = ?", userID).Row().Scan(&totalBankAmount)
		config.DB.Table("categories").Select("COALESCE(sum(amount), 0)").Where("user_profile_id = ?", userID).Row().Scan(&totalCategoriesAmount)

		if totalBankAmount-totalCategoriesAmount < transferRequest.Amount {
			return errors.New("insufficient funds in the Cash Box")
		}
	}

	// Update categories in a transaction
	return config.DB.Transaction(func(tx *gorm.DB) error {
		if transferRequest.FromCategoryID != 0 {
			if err := tx.Model(&fromCategory).Update("amount", gorm.Expr("amount - ?", transferRequest.Amount)).Error; err != nil {
				return errors.New("failed to update 'from' category amount")
			}
		}
		if err := tx.Model(&toCategory).Update("amount", gorm.Expr("amount + ?", transferRequest.Amount)).Error; err != nil {
			return errors.New("failed to update 'to' category amount")
		}
		return nil
	})
}
