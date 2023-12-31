LOGIN			:= jinacio-
COMPOSE			:= srcs/docker-compose.yml
VOLUMES_PATH	:= /home/$(LOGIN)/data

# Change path if running on MacOS
ifeq ($(shell uname),Darwin)
VOLUMES_PATH	:= $(HOME)/data
endif

export VOLUMES_PATH # Make it available for the Dockerfiles

all: srcs/.env up

up:
	docker-compose --file=$(COMPOSE) up --build --detach

down:
	docker-compose --file=$(COMPOSE) down

config:
	docker-compose --file=$(COMPOSE) config

srcs/.env:
	@echo "Missing .env file in srcs folder" && exit 1

fprune:
	docker system prune --all --force --volumes

setup: srcs/.env
	mkdir -p $(VOLUMES_PATH)/wordpress
	mkdir -p $(VOLUMES_PATH)/mariadb
	grep $(LOGIN).42.fr /etc/hosts || echo "127.0.0.1 $(LOGIN).42.fr" >> /etc/hosts
	grep VOLUMES_PATH srcs/.env || echo "VOLUMES_PATH=$(VOLUMES_PATH)" >> srcs/.env
