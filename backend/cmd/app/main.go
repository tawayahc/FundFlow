package main

import (
	"book-management-system/pkg/config"
	"book-management-system/pkg/routes"
)

func main() {
	config.InitDB()
	r := routes.SetupRouter()
	r.Run(":8080")
}
