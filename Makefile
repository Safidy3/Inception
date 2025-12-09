USERNAME=safandri
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

all: up

setup:
	mkdir -p /home/$(USERNAME)/data/mariadb
	mkdir -p /home/$(USERNAME)/data/wordpress

rmDB:
	sudo rm -rf /home/$(USERNAME)/data

up: setup
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

stop:
	docker compose -f $(DOCKER_COMPOSE_FILE) stop

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down
	make rmDB

restart: down up

clean: down
	docker volume rm -f srcs_mariadb_data srcs_wordpress_files || true

prune: clean
	docker system prune -af --volumes
	make rmDB

deepRestart: prune up

deepClean: clean
	docker stop $(docker ps -aq)
	docker rm $(docker ps -aq)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q)
	make rmDB


execMariadb:
	docker exec -it mariadb bash

execMysql:
	docker exec -it mariadb mariadb -u wp_user -p

execWP:
	docker exec -it wordpress bash

checkWP:
	docker exec -it wordpress netstat -tulpen | grep 9000 || true
	docker exec -it wordpress ps aux | grep php || true

.PHONY: all build up down logs clean execMariadb execMysql execWP checkWP deepClean
