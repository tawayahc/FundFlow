package routes

import (
	"fundflow/pkg/controllers"
	"fundflow/pkg/middleware"

	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// CORS middleware
	r.Use(middleware.CORSMiddleware())

	// Authentication routes
	r.POST("/register", controllers.Register)
	r.POST("/login", controllers.Login)

	// OTP routes
	r.POST("/claim-otp", controllers.GenerateOTP)
	r.POST("/verify-otp", controllers.VerifyOTP)
	r.POST("/reset-password", controllers.Repassword)

	// Setting routes with authentication
	protectedSetting := r.Group("/settings")
	protectedSetting.Use(middleware.AuthMiddleware())
	{
		protectedSetting.POST("/change-email", controllers.ChangeEmail)
		protectedSetting.POST("/change-password", controllers.ChangePassword)
		protectedSetting.DELETE("/delete-account", controllers.DeleteAccount)
	}

	// Profile routes with authentication
	protectedProfile := r.Group("/profile")
	protectedProfile.Use(middleware.AuthMiddleware())
	{
		protectedProfile.GET("/", controllers.GetProfile)
		protectedProfile.PUT("/", controllers.UpdateProfile)
	}

	// Category routes with authentication
	protectedCategory := r.Group("/categories")
	protectedCategory.Use(middleware.AuthMiddleware())
	{
		protectedCategory.GET("/:category_id", controllers.GetCategory)
		protectedCategory.GET("/all", controllers.GetCategories)
		protectedCategory.POST("/create", controllers.CreateCategory)
		protectedCategory.PUT("/:category_id", controllers.UpdateCategory)
		protectedCategory.DELETE("/:category_id", controllers.DeleteCategory)
	}

	// Bank routes with authentication
	protectedBank := r.Group("/banks")
	protectedBank.Use(middleware.AuthMiddleware())
	{
		protectedBank.GET("/:id", controllers.GetBank)
		protectedBank.GET("/all", controllers.GetBanks)
		protectedBank.POST("/create", controllers.CreateBank)
		protectedBank.PUT("/:bank_id", controllers.UpdateBank)
		protectedBank.DELETE("/:bank_id", controllers.DeleteBank)
	}

	// Transaction routes with authentication
	protectedTransaction := r.Group("/transactions")
	protectedTransaction.Use(middleware.AuthMiddleware())
	{
		protectedTransaction.GET("/:id", controllers.GetTransaction)
		protectedTransaction.GET("/all", controllers.GetTransactions)
		protectedTransaction.POST("/create", controllers.CreateTransaction)
		protectedTransaction.PUT("/:transaction_id", controllers.UpdateTransaction)
		protectedTransaction.DELETE("/:transaction_id", controllers.DeleteTransaction)
	}

	return r
}
