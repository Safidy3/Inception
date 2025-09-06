all: up

setup:
	mkdir -p /home/pcmr/data/mariadb
	mkdir -p /home/pcmr/data/wordpress

up: setup
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker system prune -af --volumes

deep_clean: clean
	docker rmi -f $(docker images -qa)
	docker volume rm $(docker volume ls -q)
	docker network rm $(docker network ls -q) 2>/dev/null

re: clean all

deep_re: deep_clean all

.PHONY: all up down clean re
