package utils

import (
	"errors"
	"fundflow/pkg/config"
	"fundflow/pkg/models"
	"strings"

	"github.com/golang-jwt/jwt/v5"
)

// ValidateToken validates the JWT token
func ValidateToken(authHeader string) (*models.Claims, error) {
	if authHeader == "" {
		return nil, errors.New("authorization header is required")
	}

	// The Authorization header should contain "Bearer <token>"
	tokenString := strings.TrimPrefix(authHeader, "Bearer ")
	if tokenString == authHeader {
		return nil, errors.New("invalid authorization header format")
	}

	// Parse the JWT token
	claims := &models.Claims{}
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(config.GetEnv("JWT_SECRET")), nil
	})

	// Check for errors and validate the token
	if err != nil || !token.Valid {
		return nil, errors.New("invalid or expired token")
	}

	return claims, nil
}

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
func ValidateTokenUsername(username string) error {
	_, err := GetUserProfileByUsername(username)
	if err != nil {
		return errors.New("user not found")
	}
	return nil
}

// Get UserProfile from token
func GetUserProfileFromToken(authHeader string) (*models.UserProfile, error) {
	claims, err := ExtractDataFromToken(authHeader)
	if err != nil {
		return nil, err
	}

	userProfile, err := GetUserProfileByUsername(claims.Username)
	if err != nil {
		return nil, err
	}

	return userProfile, nil
}
