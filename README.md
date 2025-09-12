# 🔐 Vuln Apps Tronic — Docker One-Stop Shop

A curated collection of intentionally vulnerable **web apps and APIs**, packaged with Docker Compose for fast, reproducible security practice.
Built as a personal hacking playground for **bug bounty hunters, penetration testers, and students** to explore OWASP Top 10 vulnerabilities and beyond.

---

## ✨ Features

* 🚀 **One command up** — spin multiple labs side-by-side with `make up`
* 🐞 **Classics**: DVWA, bWAPP, Mutillidae
* 🕸️ **Modern apps & APIs**: Juice Shop, VAmPI, DVWS, DVGA (GraphQL)
* 🛍️ **Extras**: Hackazon (legacy e-commerce)
* 🔑 **Optional heavy labs**: OWASP crAPI (microservices) and full Vulhub CVE catalog
* 📦 Organized with Docker Compose **profiles** for selective startup
* 🎯 Perfect for pairing with **Burp Suite**, **ZAP**, or your favorite toolkit
* 🛡️ Runs safely on `localhost` only (not exposed to the internet)

---

## 🚀 Quickstart

```bash
# Clone with submodules (crAPI + Vulhub)
git clone <this-repo>
cd vuln-tronic-labs
git submodule update --init --recursive

# Copy example env
cp .env.example .env

# Start the core labs (DVWA, bWAPP, Mutillidae, Juice Shop, VAmPI)
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

---

## 🗂️ Ports & URLs (default from `.env.example`)

| Lab        | Port | URL                                                              | Profile    |
| ---------- | ---- | ---------------------------------------------------------------- | ---------- |
| DVWA       | 8080 | [http://localhost:8080](http://localhost:8080)                   | web-basics |
| bWAPP      | 8081 | [http://localhost:8081](http://localhost:8081)                   | web-basics |
| Mutillidae | 8082 | [http://localhost:8082](http://localhost:8082)                   | web-basics |
| Juice Shop | 3000 | [http://localhost:3000](http://localhost:3000)                   | modern-api |
| VAmPI      | 5000 | [http://localhost:5000](http://localhost:5000)                   | modern-api |
| DVWS       | 8888 | [http://localhost:8888](http://localhost:8888)                   | api-only   |
| DVGA       | 5010 | [http://localhost:5010/graphiql](http://localhost:5010/graphiql) | api-only   |
| Hackazon   | 8083 | [http://localhost:8083](http://localhost:8083)                   | extras     |
| crAPI      | —    | runs in `labs/crapi` (see below)                                 | submodule  |
| Vulhub     | —    | runs per-CVE in `labs/vulhub`                                    | submodule  |

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

---

## 🧩 Submodules

This repo includes:

* **OWASP crAPI** — pinned at `v1.1.5`
* **Vulhub** — full CVE catalog

### Updating crAPI to a new version

```bash
cd labs/crapi
git fetch --tags
git checkout vX.Y.Z
cd ../../
git add labs/crapi
git commit -m "Bump crAPI submodule to vX.Y.Z"
```

### Adding DVWS submodule (required)

```bash
git submodule add --depth 1 https://github.com/snoopysecurity/dvws-node.git labs/dvws-node
git submodule update --init --recursive
```

*(This is necessary since there is no official DVWS image.)*

---

## 🛡️ Safety Notes

* These apps are **intentionally vulnerable**.
* They bind only to `127.0.0.1` by default.
* Do **NOT** expose them on the internet or run on shared networks.
* Best practice: run inside a VM or dedicated dev box if you’re experimenting aggressively.

---

## 🎯 Burp Suite Setup

1. Start the labs with `make up`.
2. In Burp → **Target → Scope**, add `http://localhost:{ports}` for each lab.
3. (Optional) Import the provided `burp/vuln-labs-scope.json` (gitignored).
4. Use **Proxy → HTTP history** + **Repeater** for manual testing.

Community edition works fine for this lab.

---

## ⚙️ Development

### Requirements

* Docker Engine ≥ 20.x
* Docker Compose v2 plugin
* GNU Make
* Git (with submodule support)

### CI/CD

The repo includes a GitHub Actions workflow (`.github/workflows/ci.yml`) that:

* Checks out submodules
* Validates `docker-compose.yml`

---

## 📜 License

This repo contains **wrapper configs** around third-party vulnerable applications.
Each lab has its own license (see submodules).

For this repo’s configs/scripts:
MIT License © 2025 \[Your Name or Org]

---

## 🙌 Acknowledgments

* [OWASP crAPI](https://github.com/OWASP/crAPI)
* [OWASP Juice Shop](https://github.com/juice-shop/juice-shop)
* [OWASP DVWA](http://www.dvwa.co.uk/)
* [OWASP Mutillidae II](https://github.com/webpwnized/mutillidae)
* [bWAPP](http://itsecgames.com/)
* [DVWS](https://github.com/snoopysecurity/dvws)
* [DVGA](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application)
* [Hackazon](https://github.com/rapid7/hackazon)
* [Vulhub](https://github.com/vulhub/vulhub)

---

## 📚 Suggested Learning Roadmap

1. **DVWA / Mutillidae / bWAPP** → Build a foundation in OWASP Top 10 basics (XSS, SQLi, CSRF, file upload).
2. **Juice Shop** → Move into a modern SPA + REST API target, practice intercepting JSON API traffic.
3. **DVWS / DVGA** → Explore API-specific attack surfaces (REST and GraphQL), including endpoint fuzzing and schema abuse.
4. **Hackazon** → Work on business logic flaws and end-to-end e-commerce exploitation scenarios.
5. **crAPI** → Dive into realistic microservices and token-based authz/authn issues, practice chaining vulnerabilities across services.
6. **Vulhub** → Learn how to identify software versions, research CVEs, and reproduce real-world exploits for deeper pentest training.

---

## 🏁 Project Roadmap

### Realism & Robustness Enhancements

* [ ] Traefik reverse proxy with lab hostnames (e.g., `dvwa.labs.local`)
* [ ] HTTPS with self-signed certs for encrypted traffic testing
* [ ] Burp/ZAP/Nuclei scope presets and scan templates
* [ ] Publish prebuilt Docker images to Docker Hub / GHCR
* [ ] Healthcheck dashboard + `make status` target
* [ ] Persistence & reset scripts for repeatable exploits
* [ ] Seeded datasets (users, orders, transactions)
* [ ] CI test matrix across Linux/macOS/Windows
* [ ] Multi-arch builds (ARM64 + x86) for Apple Silicon/Raspberry Pi
* [ ] Walkthroughs & guided practice scenarios
* [ ] Automation demos (SQLi, XSS, fuzzing playbooks)
* [ ] Telemetry toggle for optional request logging/metrics

📎 Footer

📎 Footer

Curated with ❤️ and maintained with ![GitHub](https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png).
