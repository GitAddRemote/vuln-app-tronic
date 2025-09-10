#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "labs/crapi/.git" || ! -d "labs/vulhub/.git" ]]; then
  echo "→ Initializing submodules…"
  git submodule update --init --recursive
  echo "✓ Submodules ready."
fi

if [[ ! -f ".env" && -f ".env.example" ]]; then
  echo "→ Creating .env from .env.example"
  cp .env.example .env
fi

echo "Bootstrap complete."

