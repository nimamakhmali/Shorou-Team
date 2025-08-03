package handler

import (
	"net/http"


	"github.com/go-chi/chi/v5"
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/repository"
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/service"
)

func NewRouter() chi.Router {
	r := chi.NewRouter()

	// health check
	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("✅ Server is healthy"))
	})

	// Dependency injection
	userRepo := repository.NewUserRepository()
	userService := service.NewUserService(userRepo)
	userHandler := NewUserHandler(userService)

	// User endpoints
	r.Get("/users", userHandler.GetAllUsers)

	return r
}
