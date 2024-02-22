# Job App Backend

### Using the dev environment

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