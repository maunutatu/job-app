package api

import (
	"context"
	"github.com/gin-gonic/gin"
	"server/database"
	"strconv"
)

func (s *Service) GetJobApplication(c *gin.Context) {
	userIDStr := c.Query("userID")
	userID, err := strconv.Atoi(userIDStr)

	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid user id"})
		return
	}
	jobListingIDStr := c.Query("jobListingID")
	jobListingID, err := strconv.Atoi(jobListingIDStr)

	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid job listing id"})
		return
	}

	arg := database.GetJobApplicationParams{
		User:       int32(userID),
		JobListing: int32(jobListingID),
	}

	jobApplication, err := s.queries.GetJobApplication(context.Background(), arg)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, jobApplication)
}

func (s *Service) CreateJobApplication(c *gin.Context) {
	var jobApplication database.CreateJobApplicationParams

	err := c.BindJSON(&jobApplication)
	if err != nil {
		c.JSON(400, err)
		return
	}

	newJobApplication, err := s.queries.CreateJobApplication(context.Background(), jobApplication)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, newJobApplication)
}

func (s *Service) UpdateJobApplication(c *gin.Context) {
	var jobApplication database.UpdateJobApplicationParams
	err := c.BindJSON(&jobApplication)
	if err != nil {
		c.JSON(400, err)
		return
	}

	updatedJobApplication, err := s.queries.UpdateJobApplication(context.Background(), jobApplication)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, updatedJobApplication)
}

func (s *Service) DeleteJobApplication(c *gin.Context) {
	userIDStr := c.Query("userID")
	userID, err := strconv.Atoi(userIDStr)

	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid user id"})
		return
	}
	jobListingIDStr := c.Query("jobListingID")
	jobListingID, err := strconv.Atoi(jobListingIDStr)

	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid job listing id"})
		return
	}

	arg := database.DeleteJobApplicationParams{
		User:       int32(userID),
		JobListing: int32(jobListingID),
	}

	err = s.queries.DeleteJobApplication(context.Background(), arg)

	if err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}

	c.JSON(200, gin.H{"message": "Job application deleted"})
}
