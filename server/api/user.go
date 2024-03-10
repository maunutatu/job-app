package api

import (
	"context"
	"github.com/gin-gonic/gin"
	"server/database"
	"strconv"
)

type GetUserResponse struct {
	database.User
	JobApplications     []database.GetUserJobApplicationsRow
	favoriteJobListings []database.GetUserFavoriteJobListingsRow
}

func (s *Service) GetUser(c *gin.Context) {
	userIDStr := c.Param("userID")
	userID, err := strconv.Atoi(userIDStr)

	if err != nil {
		c.JSON(500, gin.H{"error": "Invalid user id"})
		return
	}

	user, err := s.queries.GetUser(context.Background(), int32(userID))

	if err != nil {
		c.JSON(500, err)
		return
	}

	jobApplications, err := s.queries.GetUserJobApplications(context.Background(), int32(userID))
	if err != nil {
		c.JSON(500, err)
		return
	}

	favoriteJobListings, err := s.queries.GetUserFavoriteJobListings(context.Background(), int32(userID))
	if err != nil {
		c.JSON(500, err)
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
		c.JSON(500, err)
		return
	}

	newUser, err := s.queries.CreateUser(context.Background(), user)

	if err != nil {
		c.JSON(500, err)
		return
	}

	c.JSON(200, newUser)
}

func (s *Service) UpdateUser(c *gin.Context) {
	var user database.UpdateUserParams
	err := c.BindJSON(&user)

	if err != nil {
		c.JSON(500, err)
		return
	}

	newUser, err := s.queries.UpdateUser(context.Background(), user)

	if err != nil {
		c.JSON(500, err)
		return
	}

	c.JSON(200, newUser)
}
