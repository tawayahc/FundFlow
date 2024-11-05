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

	// Book routes with authentication
	protected := r.Group("/books")
	protected.Use(middleware.AuthMiddleware())
	{
		protected.POST("", controllers.CreateBook)
		protected.GET("", controllers.GetBooks)
		protected.PUT("/:id", controllers.UpdateBook)
		protected.DELETE("/:id", controllers.DeleteBook)
	}

	return r
}
