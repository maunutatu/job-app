#!bin/bash

set -a
source .env
set +a

export PGHOST=$POSTGRES_HOST
export PGPORT=$POSTGRES_PORT
export PGUSER=$POSTGRES_USER
export PGPASSWORD=$POSTGRES_PASSWORD
export PGDATABASE=$POSTGRES_DB

echo "Inserting the mock data into the database"

psql -f ./sql/data/mock_data.sql

echo "Mock data inserted successfully"