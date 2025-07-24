package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/handler"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	r := handler.NewRouter() 

	fmt.Println("Server listening on port", port)
	log.Fatal(http.ListenAndServe(":"+port, r))
}
