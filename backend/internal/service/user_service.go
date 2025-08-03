package service

import (
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/model"
	"github.com/nimamakhmali/Shorou-Team/go-web-backend/internal/repository"
)

type UserService interface {
	GetAllUsers() []model.User
}

type userService struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) UserService {
	return &userService{
		repo: repo,
	}
}

func (s *userService) GetAllUsers() []model.User {
	return s.repo.GetAll()
}
