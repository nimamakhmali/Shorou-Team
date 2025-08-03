package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/config"
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/handler"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("Warning: .env file not found, using system environment variables")
	}

	// Load configuration
	cfg := config.Load()

	// Initialize router
	r := handler.NewRouter()

	// Start server
	addr := fmt.Sprintf("%s:%s", cfg.Server.Host, cfg.Server.Port)
	fmt.Printf(" Server starting on http://%s\n", addr)
	fmt.Printf(" Environment: %s\n", getEnv("ENVIRONMENT", "development"))

	if err := http.ListenAndServe(addr, r); err != nil {
		log.Fatalf(" Server failed to start: %v", err)
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
