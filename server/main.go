package main

import (
	"context"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"os"
	"server/api"
	"server/database"
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

	queries := database.New(conn)

	router := gin.Default()

	apiService := api.NewService(queries)
	apiService.RegisterHandlers(router)

	router.Run()
}
