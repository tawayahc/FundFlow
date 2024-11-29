package utils

import (
	"errors"
	"fundflow/pkg/models"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

// ExtractUsernameFromToken extracts the username from the JWT token
func ExtractDataFromToken(authHeader string) (*models.Claims, error) {
	// The Authorization header should contain "Bearer <token>"
	tokenString := strings.TrimPrefix(authHeader, "Bearer ")

	// Parse the JWT token without validation
	claims := &models.Claims{}
	_, _, err := new(jwt.Parser).ParseUnverified(tokenString, claims)
	if err != nil {
		return nil, errors.New("invalid token")
	}

	return claims, nil
}

// Check that username in token was in database
func ValidateTokenUserID(userID uint) error {
	_, err := GetUserProfileByUserID(userID)
	if err != nil {
		return errors.New("user not found")
	}
	return nil
}
