USERNAME=safandri

all: up

setup:
	mkdir -p /home/$(USERNAME)/data/mariadb
	mkdir -p /home/$(USERNAME)/data/wordpress

rmSetup:
	sudo rm -rf /home/$(USERNAME)/data

up: setup
	docker compose up -d --build

stop:
	docker compose stop

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
	docker exec -it mariadb mariadb -u wp_user -p

execWP:
	docker exec -it wordpress bash

checkWP:
	docker exec -it wordpress netstat -tulpen | grep 9000 || true
	docker exec -it wordpress ps aux | grep php || true

.PHONY: all build up down logs clean execMariadb execMysql execWP checkWP deepClean
