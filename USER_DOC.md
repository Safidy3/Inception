# User Documentation

## Overview

This document explains how to use and manage the Inception project as an end user or administrator.

## Provided Services

The stack provides the following services:

* **NGINX**: HTTPS web server and reverse proxy
* **WordPress**: Content management system
* **MariaDB**: Database server used by WordPress

## Starting the Project

From the project root:

```bash
make up
```

This command builds and starts all containers.

## Stopping the Project

To stop all services:

```bash
make stop/down
```

* stop : Stops running containers without removing them.
* down : Stops and removes containers, networks, and volumes created by docker-compose

## Accessing the Website

Open a web browser and go to:

```
https://safandri.42.fr
```

A TLS warning may appear because a self-signed certificate is used.

## Administration Panel

To access the WordPress admin dashboard:

```
https://safandri.42.fr/wp-admin
```

Log in using the administrator credentials created during installation.

## Credentials Management

Credentials are stored in a .env file that needs to be copied inside the srcs folder. that file is not included in the Git repository.

## Checking Services Status

To check running containers:

```bash
docker ps
```

To inspect logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

If all containers are running, the stack is functioning correctly.
