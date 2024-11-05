package main

import (
	"fundflow/pkg/config"
	"fundflow/pkg/routes"
)

func main() {
	config.InitDB()
	r := routes.SetupRouter()
	r.Run(":8080")
}
