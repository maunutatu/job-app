package api

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"server/database"
	"strconv"
)

func (s *Service) AddUserFavoriteJobListing(c *gin.Context) {
	userIDString := c.Query("userID")
	userID, err := strconv.Atoi(userIDString)

	if err != nil {
		c.JSON(500, gin.H{"error": "Invalid user id"})
		return
	}

	jobListingIDString := c.Query("jobListingID")
	jobListingID, err := strconv.Atoi(jobListingIDString)

	if err != nil {
		c.JSON(500, gin.H{"error": "Invalid job listing id"})
		return
	}

	userFavoriteJobListing := database.AddUserFavoriteJobListingParams{
		User:       int32(userID),
		JobListing: int32(jobListingID),
	}

	err = s.queries.AddUserFavoriteJobListing(c, userFavoriteJobListing)

	if err != nil {
		c.JSON(500, err)
		return
	}

	c.JSON(200, gin.H{"message": fmt.Sprintf("Job listing %d added to favorites", userFavoriteJobListing.JobListing)})
}

func (s *Service) RemoveUserFavoriteJobListing(c *gin.Context) {
	userIDString := c.Query("userID")
	userID, err := strconv.Atoi(userIDString)

	if err != nil {
		c.JSON(500, gin.H{"error": "Invalid user id"})
		return
	}

	jobListingIDString := c.Query("jobListingID")
	jobListingID, err := strconv.Atoi(jobListingIDString)

	if err != nil {
		c.JSON(500, gin.H{"error": "Invalid job listing id"})
		return
	}

	userFavoriteJobListing := database.RemoveUserFavoriteJobListingParams{
		User:       int32(userID),
		JobListing: int32(jobListingID),
	}

	err = s.queries.RemoveUserFavoriteJobListing(c, userFavoriteJobListing)

	if err != nil {
		c.JSON(500, err)
		return
	}

	c.JSON(200, gin.H{"message": fmt.Sprintf("Job listing %d removed from favorites", userFavoriteJobListing.JobListing)})
}
