# Developer Documentation

## Environment Setup

### Prerequisites

* Linux system
* Docker
* Docker Compose
* Make

### Initial Setup

1. Clone the repository
2. Create a `.env` file in `srcs/`
3. Add all environement variable nedded inside the .env file

## Build and Launch

To build and start the project:

```bash
docker compose up --build / make up
```

Builds Docker images, creates volumes and network and launches all services

## Managing Containers

```bash
docker compose ps
```

List all running containers

```bash
docker volume ls
```

List all volumes

```bash
docker volume inspect <volume_name>
```

Displays detailed information about a volume, such as its mount point, driver, and usage.

```bash
docker compose down / make down
```

Stop and remove all container

```bash
docker compose stop / make stop
```

Stop all container

```bash
make re
```

Stop, remove and restart all container

```bash
make execMariadb / execWP / execNginx
```

Execute command inside the container

```bash
make clean
```

Remove all container, images, volumes, networks and caches

## Volumes and Data Persistence

Persistent data is stored on the host at:

* `/home/safandri/data/wordpress`
* `/home/safandri/data/mariadb`

These directories are mounted into containers using Docker volumes.

## Project Structure

```
.
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       ├── wordpress/
│       └── mariadb/
```
