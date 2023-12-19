COMPOSE_FILE_PATH		= ./srcs/docker-compose.yml
ENV_FILE_PATH				=	./srcs/.env

COMPOSE_COMMAND_SEQ	=	docker compose --env-file $(ENV_FILE_PATH) -f $(COMPOSE_FILE_PATH)

.PHONY: all
all: up

.PHONY: up
up:
	$(COMPOSE_COMMAND_SEQ) build --no-cache
	$(COMPOSE_COMMAND_SEQ) up --detach

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