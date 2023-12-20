COMPOSE_FILE_PATH		= ./srcs/docker-compose.yml
ENV_FILE_PATH				=	./srcs/.env
DATA_PATH						= /home/malaakso/data

COMPOSE_COMMAND_SEQ	=	docker compose --env-file $(ENV_FILE_PATH) -f $(COMPOSE_FILE_PATH)

.PHONY: all
all: up

.PHONY: up
up: create-data-path build
	$(COMPOSE_COMMAND_SEQ) up --detach

.PHONY: build
build:
	$(COMPOSE_COMMAND_SEQ) build --no-cache

.PHONY: down
down:
	$(COMPOSE_COMMAND_SEQ) down

.PHONY: stop
stop:
	$(COMPOSE_COMMAND_SEQ) stop

.PHONY: clean
clean: stop
	docker system prune -f

.PHONY: fclean
fclean: stop 
	docker system prune -af --volumes

.PHONY: reup
reup: clean up

.PHONY: ps
ps:
	$(COMPOSE_COMMAND_SEQ) ps

.PHONY: clean-data
clean-data: remove-data-path create-data-path

.PHONY: create-data-path
create-data-path:
	mkdir -p $(DATA_PATH)/wordpress
	mkdir -p $(DATA_PATH)/mariadb

.PHONY: remove-data-path
remove-data-path:
	doas rm -rf $(DATA_PATH)/wordpress
	doas rm -rf $(DATA_PATH)/mariadb
