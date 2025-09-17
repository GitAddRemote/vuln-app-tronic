# dvws.Dockerfile
FROM node:16-bullseye-slim

# Minimal runtime + build toolchain for native deps (e.g., bcrypt)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      python3 make g++ socat netcat-openbsd ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Help node-gyp find Python and build from source when needed
ENV npm_config_python=/usr/bin/python3
ENV npm_config_build_from_source=true
ENV npm_config_loglevel=warn

# ---- App lives in labs/dvws-node ----
WORKDIR /app/labs/dvws-node

# Install deps first (better caching)
COPY labs/dvws-node/package*.json ./
# No lockfile? fall back to install; omit dev deps for smaller image
RUN npm ci --omit=dev || npm install --omit=dev

# Copy the rest of the app
COPY labs/dvws-node/. .

# Entry that waits for MySQL with nc and starts socat, then execs node
COPY docker/entrypoint-dvws.sh /docker/entrypoint-dvws.sh
RUN chmod +x /docker/entrypoint-dvws.sh
ENTRYPOINT ["/docker/entrypoint-dvws.sh"]

# Start the Node app in this folder
CMD ["node", "app.js"]

