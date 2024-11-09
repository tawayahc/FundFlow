package controllers

import (
	"fundflow/pkg/models"
	"fundflow/pkg/services"
	"fundflow/pkg/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// Get all transactions
func GetTransactions(c *gin.Context) {
	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	transactions, err := services.GetTransactions(claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, transactions)
}

// Get a transaction by ID
func GetTransaction(c *gin.Context) {
	transactionID, err := strconv.ParseUint(c.Param("id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid transaction ID"})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	transaction, err := services.GetTransaction(uint(transactionID), claims.UserID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, transaction)
}

// Create a transaction
func CreateTransaction(c *gin.Context) {
	var transaction models.CreateTransactionRequest
	if err := c.ShouldBindJSON(&transaction); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.CreateTransaction(transaction, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Transaction created successfully"})
}

// Update a transaction
func UpdateTransaction(c *gin.Context) {
	transactionID, err := strconv.ParseUint(c.Param("transaction_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid transaction ID"})
		return
	}

	var transaction models.UpdateTransactionRequest
	if err := c.ShouldBindJSON(&transaction); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.UpdateTransaction(uint(transactionID), transaction, claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Transaction updated successfully"})
}

// Delete a transaction
func DeleteTransaction(c *gin.Context) {
	transactionID, err := strconv.ParseUint(c.Param("transaction_id"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid transaction ID"})
		return
	}

	claims, _ := utils.ExtractDataFromToken(c.GetHeader("Authorization"))

	if err := services.DeleteTransaction(uint(transactionID), claims.UserID); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Transaction deleted successfully"})
}
