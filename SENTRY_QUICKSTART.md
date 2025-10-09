# 🚀 Sentry MCP Integration - Quick Start

## 1️⃣ Configure Sentry Credentials

Edit `.env` file and replace placeholder values:

```bash
SENTRY_DSN=https://YOUR_KEY@o0.ingest.sentry.io/PROJECT_ID
SENTRY_ORGANIZATION=your-org-slug
SENTRY_PROJECT=your-project-name
SENTRY_AUTH_TOKEN=sntrys_YOUR_TOKEN
```

Get these from: https://sentry.io/settings/[YOUR_ORG]/projects/

## 2️⃣ Run Setup Script

```bash
./setup-sentry-integration.sh
```

## 3️⃣ Rebuild Docker & Install Dependencies

```bash
# Rebuild containers
docker compose down
docker compose build --no-cache
docker compose up -d

# Install PHP dependencies
docker compose exec opencart composer install

# Setup Sentry in OpenCart
docker compose exec opencart php scripts/setup-sentry-opencart.php
```

## 4️⃣ Test Integration

Visit: http://localhost:8080/test-sentry.php

## 5️⃣ Start MCP Server (for Codegen)

```bash
npm run sentry-mcp
```

Now you can use Codegen to interact with Sentry! 🎉

---
📚 Full docs: `docs/SENTRY_MCP_INTEGRATION.md`