package repository

import "github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/model"

type UserRepository interface {
	GetAll() []model.User
}

type userRepository struct{}

func NewUserRepository() UserRepository {
	return &userRepository{}
}

func (r *userRepository) GetAll() []model.User {
	return []model.User{
		{ID: 1, Name: "Ali", Email: "ali@example.com"},
		{ID: 2, Name: "Sara", Email: "sara@example.com"},
	}
}
