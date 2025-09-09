SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

help:
	@echo "vuln-labs Make targets:"
	@echo "  make up               # start default profiles (web-basics + modern-api)"
	@echo "  make up-all           # start everything (incl. api-only, extras)"
	@echo "  make api              # start only API-focused labs"
	@echo "  make down             # stop containers"
	@echo "  make ps               # list"
	@echo "  make logs             # tail logs"
	@echo "  make clean            # stop + remove volumes (DANGEROUS)"
	@echo "  make crapi            # run crAPI via its own compose (labs/crapi)"

up:
	docker compose --profile web-basics --profile modern-api up -d

up-all:
	docker compose --profile web-basics --profile modern-api --profile api-only --profile extras up -d

api:
	docker compose --profile api-only up -d

down:
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs -f --tail=100

clean:
	./scripts/wipe-volumes.sh

crapi:
	@cd labs/crapi && docker compose up -d

