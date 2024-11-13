package routes

import (
	"fundflow/pkg/handlers"
	"fundflow/pkg/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// CORS middleware
	r.Use(middleware.CORSMiddleware())

	// Authentication routes
	r.POST("/register", handlers.Register)
	r.POST("/login", handlers.Login)

	// OTP routes
	r.POST("/claim-otp", handlers.GenerateOTP)
	r.POST("/verify-otp", handlers.VerifyOTP)
	r.POST("/reset-password", handlers.Repassword)

	// Setting routes with authentication
	protectedSetting := r.Group("/settings")
	protectedSetting.Use(middleware.AuthMiddleware())
	{
		protectedSetting.POST("/change-email", handlers.ChangeEmail)
		protectedSetting.POST("/change-password", handlers.ChangePassword)
		protectedSetting.DELETE("/delete-account", handlers.DeleteAccount)
	}

	// Profile routes with authentication
	protectedProfile := r.Group("/profile")
	protectedProfile.Use(middleware.AuthMiddleware())
	{
		protectedProfile.GET("/", handlers.GetProfile)
		protectedProfile.PUT("/", handlers.UpdateProfile)
	}

	// Category routes with authentication
	protectedCategory := r.Group("/categories")
	protectedCategory.Use(middleware.AuthMiddleware())
	{
		protectedCategory.GET("/:category_id", handlers.GetCategory)
		protectedCategory.GET("/all", handlers.GetCategories)
		protectedCategory.POST("/create", handlers.CreateCategory)
		protectedCategory.POST("/transfer", handlers.TransferFunds)
		protectedCategory.PUT("/:category_id", handlers.UpdateCategory)
		protectedCategory.DELETE("/:category_id", handlers.DeleteCategory)
	}

	// Bank routes with authentication
	protectedBank := r.Group("/banks")
	protectedBank.Use(middleware.AuthMiddleware())
	{
		protectedBank.GET("/:id", handlers.GetBank)
		protectedBank.GET("/transfer/:bank_id", handlers.GetBankTransfer)
		protectedBank.GET("/all", handlers.GetBanks)
		protectedBank.POST("/create", handlers.CreateBank)
		protectedBank.POST("/transfer", handlers.TransferMoney)
		protectedBank.PUT("/:bank_id", handlers.UpdateBank)
		protectedBank.DELETE("/:bank_id", handlers.DeleteBank)
	}

	// Transaction routes with authentication
	protectedTransaction := r.Group("/transactions")
	protectedTransaction.Use(middleware.AuthMiddleware())
	{
		protectedTransaction.GET("/:id", handlers.GetTransaction)
		protectedTransaction.GET("/all", handlers.GetTransactions)
		protectedTransaction.POST("/create", handlers.CreateTransaction)
		protectedTransaction.PUT("/:transaction_id", handlers.UpdateTransaction)
		protectedTransaction.DELETE("/:transaction_id", handlers.DeleteTransaction)
	}

	return r
}
