#!/usr/bin/env bash
set -euo pipefail

echo "⚠️  This will stop containers and REMOVE ALL DOCKER VOLUMES for this project."
read -rp "Proceed? [y/N] " yn
if [[ ! "${yn:-N}" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

docker compose down -v
echo "✅ Volumes removed."

