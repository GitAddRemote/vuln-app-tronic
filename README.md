# Vuln Labs — Docker One-Stop Shop

This project is a curated collection of intentionally vulnerable **web applications and APIs**, packaged together with Docker for fast, reproducible security practice.  
It’s designed as a personal hacking playground for **bug bounty hunters, penetration testers, and students** who want hands-on experience with OWASP Top 10 and beyond.

## Features
- 🚀 Spin up multiple labs side-by-side with a single `docker compose up`
- 🐞 Includes classics (DVWA, bWAPP, Mutillidae) and modern apps (OWASP Juice Shop, VAmPI, DVGA, DVWS, Hackazon)
- 🔑 Optional extras like OWASP crAPI for realistic microservice API hacking
- 📦 Organized with profiles (`web-basics`, `modern-api`, `api-only`, `extras`) so you can focus your training
- 🎯 Perfect for pairing with **Burp Suite**, **ZAP**, or your favorite hacking toolkit
- 🛡️ Safe, local environment (not exposed to the internet)

## Why this repo?
Setting up individual vulnerable apps can be time-consuming and inconsistent. This repo pulls them into one **self-contained lab** with:
- Centralized configs (`.env`)
- Friendly `make` commands
- Isolated Docker network
- Ready-to-hack targets on predictable ports

## Disclaimer
⚠️ These applications are intentionally vulnerable.  
Run them **locally only**, never on a public-facing server. Use responsibly.

