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

	return r
}
