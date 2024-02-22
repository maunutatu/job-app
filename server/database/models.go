// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.25.0

package database

import (
	"github.com/jackc/pgx/v5/pgtype"
)

type Company struct {
	ID          int32
	Name        string
	Description string
	Website     string
	Email       string
	PhoneNumber string
}

type JobListing struct {
	ID             int32
	Title          string
	Description    string
	Salary         pgtype.Numeric
	Company        int32
	DatePosted     pgtype.Date
	StartDate      pgtype.Date
	EndDate        pgtype.Date
	Location       string
	Field          string
	WorkingHours   string
	EmploymentType string
}
