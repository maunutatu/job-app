package main

import (
	"context"
	"github.com/jackc/pgx/v5"
	"os"
)

func main() {
	ctx := context.Background()

	// connect to the database
	dbUser := os.Getenv("POSTGRES_USER")
	dbPassword := os.Getenv("POSTGRES_PASSWORD")
	dbName := os.Getenv("POSTGRES_DB")
	dbPort := os.Getenv("POSTGRES_PORT")
	dbHost := os.Getenv("POSTGRES_HOST")

	conn, err := pgx.Connect(ctx, "host="+dbHost+" port="+dbPort+" user="+dbUser+" password="+dbPassword+" dbname="+dbName)
	if err != nil {
		panic(err)
	}
	defer conn.Close(ctx)

	// ping db
	err = conn.Ping(ctx)
	if err != nil {
		panic(err)
	}
}
