package jobListingApi

import (
	"context"
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
}

func (s *Service) GetJobListings(c *gin.Context) {
	jobListings, err := s.queries.GetJobListings(context.Background())

	if err != nil {
		c.JSON(500, err)
		return
	}

	c.JSON(200, jobListings)
}
