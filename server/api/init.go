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
	router.GET("/jobListings", s.GetJobListings)
	router.GET("/user/:userID", s.GetUser)
	router.POST("/user", s.CreateUser)
	router.PUT("/user", s.UpdateUser)
	router.GET("/jobApplication", s.GetJobApplication)
	router.POST("/jobApplication", s.CreateJobApplication)
	router.PUT("/jobApplication", s.UpdateJobApplication)
	router.DELETE("/jobApplication", s.DeleteJobApplication)
}
