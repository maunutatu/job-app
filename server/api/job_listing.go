package api

import (
	"context"
	"github.com/gin-gonic/gin"
)

func (s *Service) GetJobListings(c *gin.Context) {
	jobListings, err := s.queries.GetJobListings(context.Background())

	if err != nil {
		c.JSON(500, err)
		return
	}

	c.JSON(200, jobListings)
}
