package utils

import (
	"errors"
	"fundflow/pkg/models"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

// ExtractUsernameFromToken extracts the username from the JWT token
func ExtractUsernameFromToken(authHeader string) (string, error) {
	// The Authorization header should contain "Bearer <token>"
	tokenString := strings.TrimPrefix(authHeader, "Bearer ")

	// Parse the JWT token without validation
	claims := &models.Claims{}
	_, _, err := new(jwt.Parser).ParseUnverified(tokenString, claims)
	if err != nil {
		return "", errors.New("invalid token")
	}

	return claims.Username, nil
}

// Check that username in token was in database
func ValidateTokenUsername(username string) error {
	_, err := GetUserProfileByUsername(username)
	if err != nil {
		return errors.New("user not found")
	}
	return nil
}