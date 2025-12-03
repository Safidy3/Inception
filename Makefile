USERNAME=safandri

all: up

setup:
	mkdir -p /home/$(USERNAME)/data/mariadb
	mkdir -p /home/$(USERNAME)/data/wordpress

up: setup
    docker compose up -d --build

down:
    docker compose down

clean: down
    docker volume rm -f srcs_mariadb_data srcs_wordpress_files || true

.PHONY: all build up down logs clean