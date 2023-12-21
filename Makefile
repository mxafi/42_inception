COMPOSE_FILE_PATH		= ./srcs/docker-compose.yml
ENV_FILE_PATH				=	./srcs/.env

COMPOSE_COMMAND_SEQ	=	docker compose --env-file $(ENV_FILE_PATH) -f $(COMPOSE_FILE_PATH)

include $(ENV_FILE_PATH)

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

.PHONY: reup-wordpress
reup-wordpress:
	$(COMPOSE_COMMAND_SEQ) build --no-cache wordpress
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d wordpress

.PHONY: reup-nginx
reup-nginx:
	$(COMPOSE_COMMAND_SEQ) build --no-cache nginx
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d nginx

.PHONY: exec-wordpress
exec-wordpress:
	docker exec -it wordpress sh

.PHONY: exec-nginx
exec-nginx:
	docker exec -it nginx sh

.PHONY: ps
ps:
	$(COMPOSE_COMMAND_SEQ) ps

.PHONY: clean-data
clean-data: clean remove-data-path create-data-path

.PHONY: create-data-path
create-data-path:
	mkdir -p $(DATA_ROOT)/wordpress
	mkdir -p $(DATA_ROOT)/mariadb

.PHONY: remove-data-path
remove-data-path:
	doas rm -rf $(DATA_ROOT)/wordpress
	doas rm -rf $(DATA_ROOT)/mariadb
