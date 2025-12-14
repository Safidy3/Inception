*This project has been created as part of the 42 curriculum by safandri.*

## Description

This project, **Inception**, consists of building a small web infrastructure using **Docker** and **Docker Compose**. The goal is to understand container-based system administration by deploying a secure WordPress stack composed of multiple services, each running in its own container.

The infrastructure includes:

* **NGINX** as a reverse proxy and HTTPS entry point
* **WordPress** running with PHP-FPM
* **MariaDB** as the database backend

All services are isolated, connected through a Docker network, and configured to persist data using Docker volumes.

## Project Overview

The stack is designed to follow modern infrastructure best practices:

* One service per container
* Secure communication using TLS
* No credentials stored in source code
* Persistent data outside containers

Docker is used instead of virtual machines to provide a lightweight, reproducible, and portable environment.

## Instructions

### Requirements

* Linux system
* Docker
* Docker Compose
* Make

### Build and Run

Clone the repository, then run:

```bash
make up
```

This will:

* Build all Docker images
* Create the required volumes and network
* Start the services

Access the website at:

```
https://safandri.42.fr
```

## Design Choices and Comparisons

### Virtual Machines vs Docker

* Virtual Machines run a full operating system and are resource-heavy.
* Docker containers share the host kernel, start faster, and use fewer resources.

### Secrets vs Environment Variables

* Environment variables are generally used for non-sensitive configuration but can be also used to store sensitive configuration if not stored in the repository.
* Secrets are used for sensitive configuration and are never stored in the repository.

### Docker Network vs Host Network

* Docker networks isolate containers and allow communication by service name.
* Host networking removes isolation and is less secure (therefore not used).

### Docker Volumes vs Bind Mounts

* Docker volumes manage persistent data cleanly.
* Bind mounts are used here to store data in `/home/safandri/data` for visibility and persistence.

## Resources

### Technical References

* Docker documentation: [https://docs.docker.com/](https://docs.docker.com/)
* Docker Compose documentation: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
* NGINX documentation: [https://nginx.org/en/docs/](https://nginx.org/en/docs/)
* WordPress documentation: [https://wordpress.org/support/](https://wordpress.org/support/)
* MariaDB documentation: [https://mariadb.com/kb/en/documentation/](https://mariadb.com/kb/en/documentation/)

### AI Usage

AI tools were used to:

* Clarify Docker and Docker Compose concepts
* Help understand and set up the wordpress entrypoint configuration
* Review configuration files
* Help structure documentation

All implementation and final decisions were made by myself.
