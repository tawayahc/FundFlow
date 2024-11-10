package services

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
)

// Get a profile by ID
func GetProfile(userID uint) (models.UserProfileDTO, error) {
	var profile models.UserProfileDTO

	if err := config.DB.
		Table("user_profiles").
		Select("user_profiles.id, user_profiles.first_name, user_profiles.last_name, user_profiles.user_profile_pic, user_profiles.email, user_profiles.phone_number, user_profiles.address, user_profiles.date_of_birth, auth.username AS username").
		Joins("JOIN authentications auth ON user_profiles.auth_id = auth.id").
		Where("user_profiles.auth_id = ?", userID).
		First(&profile).Error; err != nil {
		return models.UserProfileDTO{}, errors.New("profile not found")
	}

	return profile, nil
}

func UpdateProfile(profile models.UpdateUserProfileRequest, userID uint) error {
	var existingProfile models.UserProfile
	if err := config.DB.Where("auth_id = ?", userID).First(&existingProfile).Error; err != nil {
		return errors.New("profile not found")
	}

	// Create a map to hold the fields to be updated
	updates := make(map[string]interface{})

	// Check each field for nil and add to the updates map if not nil
	if profile.NewUserName != nil {
		// Check if the new username is already in use
		var usernameCheck models.Authentication
		if err := config.DB.Where("user_name = ?", *profile.NewUserName).First(&usernameCheck).Error; err == nil {
			return errors.New("username already in use")
		} else {
			// Search for the user's authentication record by ID
			var auth models.Authentication
			config.DB.First(&auth, userID)

			// Update the username in the authentication record
			auth.Username = *profile.NewUserName
			if err := config.DB.Save(&auth).Error; err != nil {
				return errors.New("failed to update username")
			}
		}
	}
	if profile.NewFirstName != nil {
		updates["first_name"] = *profile.NewFirstName
	}
	if profile.NewLastName != nil {
		updates["last_name"] = *profile.NewLastName
	}
	if profile.NewUserProfilePic != nil {
		updates["user_profile_pic"] = *profile.NewUserProfilePic
	}
	if profile.NewEmail != nil {
		// Check if the new email is already in use
		var emailCheck models.UserProfile
		if err := config.DB.Where("email = ?", *profile.NewEmail).First(&emailCheck).Error; err == nil {
			return errors.New("email already in use")
		} else {
			updates["email"] = *profile.NewEmail
		}
	}
	if profile.NewPhoneNumber != nil {
		updates["phone_number"] = *profile.NewPhoneNumber
	}
	if profile.NewAddress != nil {
		updates["address"] = *profile.NewAddress
	}
	if profile.NewDateOfBirth != nil {
		updates["date_of_birth"] = *profile.NewDateOfBirth
	}

	if len(updates) == 0 && profile.NewUserName == nil {
		return errors.New("no fields to update")
	}

	// Only update fields with new values using GORM's `Updates` method
	if err := config.DB.Model(&existingProfile).Updates(updates).Error; err != nil {
		return errors.New("failed to update profile")
	}

	return nil
}
