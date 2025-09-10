#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "   🐞 Vuln Labs - Running Targets Banner   "
echo "=========================================="

# Pull values from .env or fall back to defaults
source .env 2>/dev/null || true

echo "DVWA       → http://localhost:${DVWA_PORT:-8080}"
echo "bWAPP      → http://localhost:${BWAPP_PORT:-8081}"
echo "Mutillidae → http://localhost:${MUTILLIDAE_PORT:-8082}"
echo "Juice Shop → http://localhost:${JUICESHOP_PORT:-3000}"
echo "VAmPI      → http://localhost:${VAMPI_PORT:-5000}"
echo "DVWS       → http://localhost:${DVWS_PORT:-8888}"
echo "DVGA       → http://localhost:${DVGA_PORT:-5010}/graphiql"
echo "Hackazon   → http://localhost:${HACKAZON_PORT:-8083}"

echo "------------------------------------------"
echo "Heavy labs (manual start):"
echo " - crAPI:    cd labs/crapi && docker compose up -d"
echo " - Vulhub:   make vulhub SCENARIO=product/CVE-XXXX-YYYY"
echo "=========================================="

