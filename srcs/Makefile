USERNAME=safandri

all: up

setup:
	mkdir -p /home/$(USERNAME)/data/mariadb
	mkdir -p /home/$(USERNAME)/data/wordpress

rmSetup:
	sudo rm -rf /home/$(USERNAME)/data

up: setup
	docker compose up -d --build

down:
	docker compose down

clean: down
	docker volume rm -f srcs_mariadb_data srcs_wordpress_files || true

prune: clean
	docker system prune -af --volumes
	make rmSetup

deepClean: clean
	docker stop $(docker ps -aq)
	docker rm $(docker ps -aq)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q)
	make rmSetup

execMariadb:
	docker exec -it mariadb bash

execMysql:
	docker exec -it mariadb mysql -u root -p

.PHONY: all build up down logs clean execMariadb execMysql deepClean