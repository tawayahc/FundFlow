package controllers

import (
	"book-management-system/pkg/config"
	"book-management-system/pkg/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreateBook(c *gin.Context) {
	var book models.Book
	if err := c.ShouldBindJSON(&book); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	config.DB.Create(&book)
	c.JSON(http.StatusOK, book)
}

func GetBooks(c *gin.Context) {
	var books []models.Book
	config.DB.Find(&books)
	c.JSON(http.StatusOK, books)
}

func UpdateBook(c *gin.Context) {
	var book models.Book
	if err := config.DB.First(&book, c.Param("id")).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Book not found"})
		return
	}
	if err := c.ShouldBindJSON(&book); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	config.DB.Save(&book)
	c.JSON(http.StatusOK, book)
}

func DeleteBook(c *gin.Context) {
	var book models.Book
	if err := config.DB.First(&book, c.Param("id")).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Book not found"})
		return
	}
	config.DB.Delete(&book)
	c.JSON(http.StatusOK, gin.H{"message": "Book deleted"})
}
