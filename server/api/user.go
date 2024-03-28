package api

import (
	"context"
	"github.com/gin-gonic/gin"
	"server/database"
)

type GetUserResponse struct {
	database.User
	JobApplications     []database.GetUserJobApplicationsRow
	FavoriteJobListings []database.GetUserFavoriteJobListingsRow
}

func (s *Service) GetUser(c *gin.Context) {
	userIDStr := c.Param("userID")
	user, err := s.queries.GetUser(context.Background(), userIDStr)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	jobApplications, err := s.queries.GetUserJobApplications(context.Background(), user.ID)
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	favoriteJobListings, err := s.queries.GetUserFavoriteJobListings(context.Background(), user.ID)
	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	userResponse := GetUserResponse{
		user,
		jobApplications,
		favoriteJobListings,
	}

	c.JSON(200, userResponse)
}

func (s *Service) CreateUser(c *gin.Context) {
	var user database.CreateUserParams
	err := c.BindJSON(&user)

	if err != nil {
		c.JSON(400, err)
		return
	}

	newUser, err := s.queries.CreateUser(context.Background(), user)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, newUser)
}

func (s *Service) UpdateUser(c *gin.Context) {
	var user database.UpdateUserParams
	err := c.BindJSON(&user)

	if err != nil {
		c.JSON(400, err)
		return
	}

	newUser, err := s.queries.UpdateUser(context.Background(), user)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, newUser)
}
