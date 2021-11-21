# Project

## Docker Configuration 

`cd WPIDDC`

### Docker Containers Start

`docker network create wpid-app-pre-existing-network`

`docker-compose up -d --remove-orphans --build`

### Docker Containers Stop

`docker-compose stop`

### Docker Containers Explore

`docker exec -it wpid-app bash`

### Browse Project Directory bash

`cd WPID`

### Run the project

`http://localhost:8101`
