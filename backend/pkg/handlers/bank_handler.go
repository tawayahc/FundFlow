package handlers

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

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	bank, err := services.GetBank(uint(bankID), claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, bank)
}

// Get all banks
func GetBanks(c *gin.Context) {
	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	banks, err := services.GetBanks(claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, banks)
}

// Creat a new bank
func CreateBank(c *gin.Context) {
	var bank models.CreateBankRequest
	if err := c.ShouldBindJSON(&bank); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.CreateBank(bank, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bank created successfully"})
}

// Update a bank
func UpdateBank(c *gin.Context) {
	bankID, err := strconv.ParseUint(c.Param("bank_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bank ID"})
		return
	}

	var bank models.UpdateBankRequest
	if err := c.ShouldBindJSON(&bank); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.UpdateBank(uint(bankID), bank, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bank updated successfully"})
}

// Delete a bank
func DeleteBank(c *gin.Context) {
	bankID, err := strconv.ParseUint(c.Param("bank_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bank ID"})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.DeleteBank(uint(bankID), claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bank deleted successfully"})
}

// Transfer money between banks
func TransferMoney(c *gin.Context) {
	var transfer models.TransferRequest
	if err := c.ShouldBindJSON(&transfer); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.TransferMoney(transfer, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Money transferred successfully"})
}

// Get all transfer transactions of a bank
func GetBankTransfer(c *gin.Context) {
	bankID, err := strconv.ParseUint(c.Param("bank_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid bank ID"})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	transfers, err := services.GetTransferTransactions(uint(bankID), claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, transfers)
}
