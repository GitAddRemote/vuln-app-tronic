SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

bootstrap:
	@if [ ! -d "labs/crapi/.git" ] || [ ! -d "labs/vulhub/.git" ]; then \
		echo "→ Initializing submodules..."; \
		git submodule update --init --recursive; \
		echo "✓ Submodules ready."; \
	fi

help:
	@echo "vuln-labs Make targets:"
	@echo "  make up               # start default profiles (web-basics + modern-api)"
	@echo "  make up-all           # start everything (incl. api-only, extras)"
	@echo "  make api              # start only API-focused labs"
	@echo "  make down             # stop containers"
	@echo "  make ps               # list containers"
	@echo "  make logs             # tail logs"
	@echo "  make clean            # stop + remove volumes (DANGEROUS)"
	@echo "  make crapi            # run crAPI via its own compose (labs/crapi)"
	@echo "  make crapi-down       # stop crAPI"
	@echo "  make vulhub SCENARIO=product/CVE-XXXX-YYYY"
	@echo "  make vulhub-down SCENARIO=product/CVE-XXXX-YYYY"
	@echo "  make vulhub-list      # list top-level vulhub products"

up: bootstrap
	docker compose --profile web-basics --profile modern-api up -d
	@./scripts/hosts-banner.sh

up-all: bootstrap
	docker compose --profile web-basics --profile modern-api --profile api-only --profile extras up -d
	@./scripts/hosts-banner.sh

api: bootstrap
	docker compose --profile api-only up -d
	@./scripts/hosts-banner.sh

down:
	docker compose down

ps:
	docker compose ps

logs:
	docker compose logs -f --tail=100

clean:
	./scripts/wipe-volumes.sh

# crAPI
crapi: bootstrap
	@cd labs/crapi && docker compose up -d
	@./scripts/hosts-banner.sh

crapi-down:
	@cd labs/crapi && docker compose down

# Vulhub
vulhub: bootstrap
	@if [ -z "$(SCENARIO)" ]; then \
		echo "Usage: make vulhub SCENARIO=product/CVE-XXXX-YYYY"; exit 1; \
	fi
	@cd labs/vulhub/$(SCENARIO) && docker compose up -d
	@./scripts/hosts-banner.sh

vulhub-down:
	@if [ -z "$(SCENARIO)" ]; then \
		echo "Usage: make vulhub-down SCENARIO=product/CVE-XXXX-YYYY"; exit 1; \
	fi
	@cd labs/vulhub/$(SCENARIO) && docker compose down

vulhub-list:
	@find labs/vulhub -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | sort

