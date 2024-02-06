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

.PHONY: wordpress
wordpress:
	$(COMPOSE_COMMAND_SEQ) build --no-cache wordpress
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d wordpress

.PHONY: nginx
nginx:
	$(COMPOSE_COMMAND_SEQ) build --no-cache nginx
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d nginx

.PHONY: mariadb
mariadb:
	$(COMPOSE_COMMAND_SEQ) build --no-cache mariadb
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d mariadb

.PHONY: redis
redis:
	$(COMPOSE_COMMAND_SEQ) build --no-cache redis
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d redis

.PHONY: vsftpd
vsftpd:
	$(COMPOSE_COMMAND_SEQ) build --no-cache vsftpd
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d vsftpd

.PHONY: adminer
adminer:
	$(COMPOSE_COMMAND_SEQ) build --no-cache adminer
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d adminer

.PHONY: hugo
hugo:
	$(COMPOSE_COMMAND_SEQ) build --no-cache hugo
	$(COMPOSE_COMMAND_SEQ) up --force-recreate --no-deps -d hugo

.PHONY: exec-wordpress
exec-wordpress:
	docker exec -it wordpress sh

.PHONY: exec-nginx
exec-nginx:
	docker exec -it nginx sh

.PHONY: exec-mariadb
exec-mariadb:
	docker exec -it mariadb sh

.PHONY: exec-redis
exec-redis:
	docker exec -it redis sh

.PHONY: exec-vsftpd
exec-vsftpd:
	docker exec -it vsftpd sh

.PHONY: exec-adminer
exec-adminer:
	docker exec -it adminer sh

.PHONY: exec-hugo
exec-hugo:
	docker exec -it hugo sh

.PHONY: ps
ps:
	$(COMPOSE_COMMAND_SEQ) ps

.PHONY: clean-data
clean-data: clean remove-data-path create-data-path

.PHONY: create-data-path
create-data-path:
	mkdir -p $(DATA_ROOT)/wordpress
	mkdir -p $(DATA_ROOT)/mariadb
	mkdir -p $(DATA_ROOT)/nginx-logs

.PHONY: remove-data-path
remove-data-path:
	doas rm -rf $(DATA_ROOT)/wordpress
	doas rm -rf $(DATA_ROOT)/mariadb
	doas rm -rf $(DATA_ROOT)/nginx-logs

.PHONY: dev
dev:
	docker stop alpine &> /dev/null || true
	docker run --rm -it --name alpine alpine:$(ALPINE_PENULTIMATE_VERSION_TAG) /bin/ash