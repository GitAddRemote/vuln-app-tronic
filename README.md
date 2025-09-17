# 🔐 Vuln Apps Tronic — Docker One-Stop Shop

A curated collection of intentionally vulnerable **web apps and APIs**, packaged with Docker Compose for fast, reproducible security practice.
Built as a personal hacking playground for **bug bounty hunters, penetration testers, and students** to explore OWASP Top 10 and API vulns.

---

## ✨ Features

* 🚀 **One command up** — spin multiple labs side-by-side with `make up`
* 🐞 **Classics**: DVWA, bWAPP, Mutillidae
* 🕸️ **Modern apps & APIs**: Juice Shop, VAmPI, DVWS, DVGA (GraphQL)
* 🛍️ **Extras**: Hackazon (legacy e-commerce)
* 🔑 **Optional heavy labs**: OWASP crAPI + full Vulhub CVE catalog (submodules)
* 📦 Organized with Docker Compose **profiles** for selective startup
* 🛡️ Runs safely on `localhost` only (not exposed to the internet)
* 🧰 **Self-contained DVWS**:

  * No host env vars required
  * Auto-creates MySQL DB/user on startup
  * Internal loopback proxies so the app can talk to `localhost:3306` (MySQL) and `localhost:27017` (Mongo) inside the container

---

## 🚀 Quickstart

```bash
# Clone with submodules (crAPI + Vulhub + DVWS)
git clone <this-repo-url> vuln-tronic-labs
cd vuln-tronic-labs
git submodule update --init --recursive

# Copy example env (defines ports like 8080/8081/etc for the classic apps)
cp .env.example .env

# Start the core labs (web-basics + modern-api)
make up
```

After startup, you’ll see a **banner** with running lab URLs:

```
==========================================
   🐞 Vuln Labs - Running Targets Banner
==========================================
DVWA       → http://localhost:8080
bWAPP      → http://localhost:8081
Mutillidae → http://localhost:8082
Juice Shop → http://localhost:3000
VAmPI      → http://localhost:5000
DVWS       → http://localhost:8888
DVGA       → http://localhost:5010/graphiql
Hackazon   → http://localhost:8083
------------------------------------------
Heavy labs (manual start):
 - crAPI:    cd labs/crapi && docker compose up -d
 - Vulhub:   make vulhub SCENARIO=product/CVE-XXXX-YYYY
==========================================
```

Then open any of the listed URLs in your browser.

> **Tip (API-only focus):**
> Start just the API labs (DVWS, DVGA, Mongo, etc):
>
> ```bash
> make api
> # Optionally wait for health (uses the Makefile "wait" helper):
> make wait SERVICES="mongodb dvws dvga"
> ```

---

## 🗂️ Ports & URLs (defaults from `.env.example`)

| Lab        | Port | URL                                                                                                                                                             | Profile    |
| ---------- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| DVWA       | 8080 | <a href="http://localhost:8080" target="_blank" rel="noopener noreferrer">[http://localhost:8080](http://localhost:8080)</a>                                    | web-basics |
| bWAPP      | 8081 | <a href="http://localhost:8081" target="_blank" rel="noopener noreferrer">[http://localhost:8081](http://localhost:8081)</a>                                    | web-basics |
| Mutillidae | 8082 | <a href="http://localhost:8082" target="_blank" rel="noopener noreferrer">[http://localhost:8082](http://localhost:8082)</a>                                    | web-basics |
| Juice Shop | 3000 | <a href="http://localhost:3000" target="_blank" rel="noopener noreferrer">[http://localhost:3000](http://localhost:3000)</a>                                    | modern-api |
| VAmPI      | 5000 | <a href="http://localhost:5000" target="_blank" rel="noopener noreferrer">[http://localhost:5000](http://localhost:5000)</a>                                    | modern-api |
| **DVWS**   | 8888 | <a href="http://localhost:8888" target="_blank" rel="noopener noreferrer">[http://localhost:8888](http://localhost:8888)</a> (REST UI; GraphQL proxied via app) | api-only   |
| DVGA       | 5010 | <a href="http://localhost:5010/graphiql" target="_blank" rel="noopener noreferrer">[http://localhost:5010/graphiql](http://localhost:5010/graphiql)</a>         | api-only   |
| Hackazon   | 8083 | <a href="http://localhost:8083" target="_blank" rel="noopener noreferrer">[http://localhost:8083](http://localhost:8083)</a>                                    | extras     |
| crAPI      | —    | runs in `labs/crapi` (see below)                                                                                                                                | submodule  |
| Vulhub     | —    | runs per-CVE in `labs/vulhub`                                                                                                                                   | submodule  |

> **DVWS internals (for testers):**
> Inside the `dvws` container, two loopback proxies are started automatically:
>
> * `127.0.0.1:3306` → `dvws-db:3306` (MySQL)
> * `127.0.0.1:27017` → `mongodb:27017` (Mongo)
>   This matches apps that expect `localhost` DBs, and it removes host setup entirely.

---

## 🛠️ Makefile Commands

```bash
make up          # Start default profiles (web-basics + modern-api)
make up-all      # Start everything (incl. api-only, extras)
make api         # Start only API-focused labs
make down        # Stop all containers
make ps          # List running containers
make logs        # Tail logs
make clean       # Stop & remove volumes (DANGEROUS)
make check       # Run smoke tests (HTTP HEAD)

# Heavy labs
make crapi       # Start crAPI (from labs/crapi)
make crapi-down  # Stop crAPI

# Vulhub usage
make vulhub SCENARIO=tomcat/CVE-2017-12615
make vulhub-down SCENARIO=tomcat/CVE-2017-12615
make vulhub-list
```

> **Tip:** You can also run specific profiles with Docker Compose directly, e.g.
> `docker compose --profile api-only up -d --build dvws`

---

## 🧩 Submodules

This repo includes:

* **OWASP crAPI** — microservices vulnerable app
* **Vulhub** — full CVE catalog
* **DVWS (dvws-node)** — intentionally vulnerable web services (API)

### Update submodules

```bash
git submodule update --remote --merge
```

### Adding DVWS submodule (if you ever re-init)

```bash
git submodule add --depth 1 https://github.com/snoopysecurity/dvws-node.git labs/dvws-node
git submodule update --init --recursive
```

*(DVWS builds from source; there’s no official image.)*

---

## 🛡️ Safety Notes

* These apps are **intentionally vulnerable**.
* They bind only to `127.0.0.1` by default.
  Do **NOT** expose them on the internet or run on shared networks.
* Prefer running on a lab machine or VM if you’ll be experimenting hard.

---

## 🎯 Burp Suite Setup (quick)

1. Start the labs (`make up` or `make api`).
2. In your browser, set proxy to **127.0.0.1:8080** (Burp default).
3. In Burp → **Target → Scope**, add the URLs from the banner.
4. Intercept requests and explore with **Repeater**, **Intruder** (Pro), **Comparer**.

**High-leverage practice ideas:**

* **DVWS**

  * Intercept `/api/register` and `/api/login` → test for SQLi/weak auth.
  * Try **IDOR** patterns on any `/api/*/{id}` resources.
  * Hit GraphQL via the app’s proxy path (look for `/graphql` endpoints); try introspection, field suggestions, and common GraphQL abuses (deep queries, alias abuse).
  * XML-RPC (logs show `XML-RPC server listening on 9090`) — look for endpoints proxied via the app and fuzz method names.
* **DVGA**

  * Open `/graphiql` and learn GraphQL introspection, enum guessing, auth bypass.
* **Juice Shop**

  * Great for modern client-side vulns (XSS, JWT, CSP bypasses).
* **VAmPI**

  * Practice REST fuzzing, broken object level authorization, and auth flows.

---

## ⚙️ Development

### Requirements

* Docker Engine ≥ 20.x
* Docker Compose (v2)
* GNU Make
* Git (with submodule support)

### What the DVWS images do at runtime

* `dvws-db` (MySQL 5.7) is brought up and health-checked.
* A tiny one-shot `dvws-db-init` container runs SQL to **ensure**:

  * Database: `dvws_sqldb`
  * User: `dvws_user` / password `dvws_pass`
  * Grants applied
* The `dvws` container waits for MySQL **and** Mongo, then:

  * Starts a local forwarder `127.0.0.1:3306` → `dvws-db:3306`
  * Starts a local forwarder `127.0.0.1:27017` → `mongodb:27017`
  * Launches the Node app (dvws-node)

> All credentials here are **lab-only** defaults hard-coded in Compose; no host env exports required.

### CI/CD

A GitHub Actions workflow can validate Compose and basic project health (optional; not required to run locally).

---

## 🧯 Troubleshooting

**`dvws` restarting with DB errors**

* Check logs: `docker logs dvws --tail 120`
* Verify forwarders are up: inside the container
  `docker exec dvws nc -vz 127.0.0.1 3306` and `docker exec dvws nc -vz 127.0.0.1 27017`
  (Should both say “succeeded”.)

**`dvws-db-init` fails**

* You may have an old MySQL volume initialized with different creds. Reset just this stack:

  ```bash
  docker compose --profile api-only down -v
  docker compose --profile api-only up -d --build dvws
  ```

**“DVWS not found / app.js missing” on a fresh clone**

* Ensure the DVWS submodule exists:
  `ls labs/dvws-node/package.json` should exist. If not:
  `git submodule update --init --recursive`

**Compose warns about “Build using Bake / buildx not installed”**

* Harmless for local use; you can ignore it.

**Ports already in use**

* Adjust ports in `.env` (e.g., change `DVWA_PORT=8080` → `8089`) and re-`make up`.

---

## 📜 License

This repo contains **wrapper configs** around third-party vulnerable applications.
Each lab has its own license (see submodules).

For this repo’s configs/scripts:
MIT License © 2025 \[Your Name or Org]

---

## 🙌 Acknowledgments

* OWASP crAPI — <a href="https://github.com/OWASP/crAPI" target="_blank" rel="noopener noreferrer">[https://github.com/OWASP/crAPI](https://github.com/OWASP/crAPI)</a>
* OWASP Juice Shop — <a href="https://github.com/juice-shop/juice-shop" target="_blank" rel="noopener noreferrer">[https://github.com/juice-shop/juice-shop](https://github.com/juice-shop/juice-shop)</a>
* OWASP DVWA — <a href="http://www.dvwa.co.uk/" target="_blank" rel="noopener noreferrer">[http://www.dvwa.co.uk/](http://www.dvwa.co.uk/)</a>
* OWASP Mutillidae II — <a href="https://github.com/webpwnized/mutillidae" target="_blank" rel="noopener noreferrer">[https://github.com/webpwnized/mutillidae](https://github.com/webpwnized/mutillidae)</a>
* bWAPP — <a href="http://itsecgames.com/" target="_blank" rel="noopener noreferrer">[http://itsecgames.com/](http://itsecgames.com/)</a>
* DVWS (dvws-node) — <a href="https://github.com/snoopysecurity/dvws-node" target="_blank" rel="noopener noreferrer">[https://github.com/snoopysecurity/dvws-node](https://github.com/snoopysecurity/dvws-node)</a>
* DVGA — <a href="https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application" target="_blank" rel="noopener noreferrer">[https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application)</a>
* Hackazon — <a href="https://github.com/rapid7/hackazon" target="_blank" rel="noopener noreferrer">[https://github.com/rapid7/hackazon](https://github.com/rapid7/hackazon)</a>
* Vulhub — <a href="https://github.com/vulhub/vulhub" target="_blank" rel="noopener noreferrer">[https://github.com/vulhub/vulhub](https://github.com/vulhub/vulhub)</a>

---

## 📚 Suggested Learning Roadmap

1. **DVWA / Mutillidae / bWAPP** → OWASP Top 10 basics (XSS, SQLi, CSRF, file upload).
2. **Juice Shop** → Modern SPA + REST; learn to proxy/fuzz JSON APIs.
3. **DVWS / DVGA** → API-specific attack surface: IDOR/BOLA, auth, GraphQL introspection and abuse.
4. **Hackazon** → Business logic flaws and e-commerce flows.
5. **crAPI** → Realistic microservices, token auth, multi-service chains.
6. **Vulhub** → Identify software versions, map to CVEs, reproduce exploits safely.

---

## 🏁 Project Roadmap (nice-to-haves)

* [ ] Traefik reverse proxy with local hostnames (e.g., `dvws.labs.local`)
* [ ] HTTPS with self-signed certs for TLS testing
* [ ] Burp/ZAP/Nuclei scope presets and scan templates
* [ ] Health dashboard + `make status`
* [ ] Seed datasets for repeatable scenarios
* [ ] Multi-arch images (ARM64 + x86)
* [ ] Guided walkthroughs & automation playbooks

---

Curated with ❤️ for learners and hunters.

