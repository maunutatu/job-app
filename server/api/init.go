package api

import (
	"github.com/gin-gonic/gin"
	"server/database"
)

type Service struct {
	queries *database.Queries
}

func NewService(queries *database.Queries) *Service {
	return &Service{queries: queries}
}

func (s *Service) RegisterHandlers(router *gin.Engine) {
	router.GET("/job-listings", s.GetJobListings)
	router.GET("/users/:userID", s.GetUser)
	router.POST("/users", s.CreateUser)
	router.PUT("/users", s.UpdateUser)
	router.GET("/job-application", s.GetJobApplication)
	router.POST("/job-application", s.CreateJobApplication)
	router.PUT("/job-application", s.UpdateJobApplication)
	router.DELETE("/job-application", s.DeleteJobApplication)
	router.POST("/user/favorites", s.AddUserFavoriteJobListing)
	router.DELETE("/user/favorites", s.RemoveUserFavoriteJobListing)
}
