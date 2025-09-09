#!/usr/bin/env bash
set -euo pipefail
read -rp "This will remove ALL volumes for this project. Continue? [y/N] " yn
[[ "${yn}" =~ ^[Yy]$ ]] || exit 1
docker compose down -v
echo "Done."

