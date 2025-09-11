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
	@echo "  make up-ready         # up + wait for health + banner"
	@echo "  make up-all           # start everything (incl. api-only, extras)"
	@echo "  make api              # start only API-focused labs"
	@echo "  make api-ready        # api + wait for health + banner"
	@echo "  make down             # stop containers"
	@echo "  make ps               # list containers"
	@echo "  make logs             # tail logs"
	@echo "  make check            # curl-based smoke checks"
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

# ----- Health & Smoke -----

# default set (web-basics + modern-api)
SERVICES ?= dvwa bwapp mutillidae juice-shop mongodb vampi

wait:
	@echo "== Waiting for services to be healthy =="
	@for s in $(SERVICES); do \
		echo " - $$s"; \
		timeout 180s bash -ceu ' \
			while true; do \
				status=$$(docker inspect --format="{{json .State.Health}}" $$s 2>/dev/null || echo "null"); \
				if [[ "$$status" == "null" ]]; then exit 0; fi; \
				health=$$(echo "$$status" | sed -nE "s/.*\"Status\":\"([^\"]+)\".*/\\1/p"); \
				if [ "$$health" = "healthy" ]; then exit 0; fi; \
				sleep 3; \
			done'; \
	done
	@echo "✓ All services healthy (or running without healthcheck)."

check:
	@echo "== Smoke checks (HTTP HEAD) =="
	@bash -ceu 'curl -I --silent http://localhost:8080/ | head -n1 || exit 1'    # DVWA
	@bash -ceu 'curl -I --silent http://localhost:8081/ | head -n1 || exit 1'    # bWAPP
	@bash -ceu 'curl -I --silent http://localhost:8082/ | head -n1 || exit 1'    # Mutillidae
	@bash -ceu 'curl -I --silent http://localhost:3000/ | head -n1 || exit 1'    # Juice Shop
	@bash -ceu 'curl -I --silent http://localhost:5000/ | head -n1 || true'      # VAmPI (200/401/404 acceptable)
	@echo "✓ Smoke checks passed"

up-ready: up wait
	@./scripts/hosts-banner.sh

api-ready:
	@$(MAKE) api
	@$(MAKE) wait SERVICES="dvws dvga"
	@./scripts/hosts-banner.sh

# ----- crAPI helpers -----
crapi: bootstrap
	@cd labs/crapi && docker compose up -d
	@./scripts/hosts-banner.sh

crapi-down:
	@cd labs/crapi && docker compose down

# ----- Vulhub helpers -----
vulhub: bootstrap
	@if [ -z "$(SCENARIO)" ]; then \
		echo "Usage: make vulhub SCENARIO=tomcat/CVE-2017-12615"; exit 1; \
	fi
	@cd labs/vulhub/$(SCENARIO) && docker compose up -d
	@./scripts/hosts-banner.sh

vulhub-down:
	@if [ -z "$(SCENARIO)" ]; then \
		echo "Usage: make vulhub-down SCENARIO=tomcat/CVE-2017-12615"; exit 1; \
	fi
	@cd labs/vulhub/$(SCENARIO) && docker compose down

vulhub-list:
	@find labs/vulhub -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | sort

