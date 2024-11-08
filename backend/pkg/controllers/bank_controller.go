package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Get a bank by ID
func GetBank(c *gin.Context) {
	bankID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bank ID"})
		return
	}

	userProfile, _ := utils.GetUserProfileFromToken(c.GetHeader("Authorization"))

	bank, err := services.GetBank(uint(bankID), userProfile.AuthID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, bank)
}

// Creat a new bank
func CreateBank(c *gin.Context) {
	var bank models.CreateBankRequest
	if err := c.ShouldBindJSON(&bank); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userProfile, _ := utils.GetUserProfileFromToken(c.GetHeader("Authorization"))

	if err := services.CreateBank(bank.Name, bank.BankName, userProfile.AuthID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bank created successfully"})
}
