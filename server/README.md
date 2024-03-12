# Job App Backend

## API Endpoints

Brief overview on the available endpoints. For more detailed information about each endpoint, please refer to the `api` directory.

### Job Listings Endpoint

- `GET /job-listings`: Retrieves a list of all job listings. No query parameters are required. Returns a JSON array of job listings or an error message.

### User Endpoints

- `GET /users/:userID`: Retrieves a user along with their job applications and favorite job listings. Replace `:userID` with the ID of the user. Returns a JSON object of the user or an error message.

- `POST /users`: Creates a new user. Requires a JSON object in the request body with the details of the user. Returns a JSON object of the created user or an error message.

- `PUT /users`: Updates an existing user. Requires a JSON object in the request body with the updated details of the user. Returns a JSON object of the updated user or an error message.

### User Favorite Job Listing Endpoints

- `POST /user/favorites`: Adds a job listing to a user's favorites. Requires `userID` and `jobListingID` as query parameters. Returns a success message or an error message.

- `DELETE /user/favorites`: Removes a job listing from a user's favorites. Requires `userID` and `jobListingID` as query parameters. Returns a success message or an error message.

### Job Application Endpoints

- `GET /job-application`: Retrieves a job application. Requires `userID` and `jobListingID` as query parameters. Returns a JSON object of the job application or an error message.

- `POST /job-application`: Creates a new job application. Requires a JSON object in the request body with the details of the job application. Returns a JSON object of the created job application or an error message.

- `PUT /job-application`: Updates an existing job application. Requires a JSON object in the request body with the updated details of the job application. Returns a JSON object of the updated job application or an error message.

- `DELETE /job-application`: Deletes a job application. Requires `userID` and `jobListingID` as query parameters. Returns a success message or an error message.

## Using the dev environment

Tested on WSL2 Ubuntu 22.04.1 LTS

1. Make sure to have [Docker Desktop](https://docs.docker.com/desktop/) installed on your machine.
2. Navigate to the server directory
3. Add a .env file with the following variables:

```
POSTGRES_USER=whateverUserYouWant
POSTGRES_PASSWORD=whateverPasswordYouWant
POSTGRES_DB=whateverNameYouWant
POSTGRES_PORT=whateverPortYouWant
POSTGRES_HOST=yourOwnDefaultIPv4Address
API_PORT=whateverPortYouWant
```

4. Run the following command to start the api and the database:

```bash
docker-compose --env-file .env up -d
```

5. Call the API locally at POSTGRES_HOST:API_PORT

In case you need to add mock data into the database, you can do so by running the insert_mockdata.sh script. (Make sure to have the .env file created and [psql](https://www.postgresql.org/download/) installed.)

```bash
bash insert_mockdata.sh
```
