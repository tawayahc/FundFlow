package utils

import (
	"errors"
	"strings"
	"time"

	"fundflow/pkg/config"
	"fundflow/pkg/models"

	"github.com/golang-jwt/jwt/v5"
)

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

func GenerateJWTToken(username string) (string, error) {
	// Generate JWT token
	expirationTime := time.Now().Add(24 * time.Hour)
	claims := &models.Claims{
		Username: username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	// Sign the token
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	return token.SignedString([]byte(config.GetEnv("JWT_SECRET")))
}
