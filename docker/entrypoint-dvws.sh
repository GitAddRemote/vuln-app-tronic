#!/usr/bin/env sh
set -eu

# --- Wait for MySQL (dvws-db) and forward to localhost:3306 ---
until getent hosts dvws-db >/dev/null 2>&1; do sleep 1; done
until nc -z dvws-db 3306 >/dev/null 2>&1; do sleep 1; done
# Quiet: no -dd and send stderr to /dev/null
socat tcp-listen:3306,bind=127.0.0.1,fork,reuseaddr tcp-connect:dvws-db:3306 >/dev/null 2>&1 &

# --- Wait for MongoDB (mongodb) and forward to localhost:27017 ---
until getent hosts mongodb >/dev/null 2>&1; do sleep 1; done
until nc -z mongodb 27017 >/dev/null 2>&1; do sleep 1; done
socat tcp-listen:27017,bind=127.0.0.1,fork,reuseaddr tcp-connect:mongodb:27017 >/dev/null 2>&1 &

# tiny settle so listeners are up before starting the app
sleep 0.5

# Hand off to the Node app (Dockerfile sets WORKDIR and CMD)
exec "$@"

