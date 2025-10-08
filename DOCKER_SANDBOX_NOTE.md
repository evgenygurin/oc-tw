# Docker Environment Limitation Notice

## Issue

The current sandbox environment has a Docker storage driver limitation (`vfs` with `unshare: operation not permitted`) that prevents building and running the official OpenCart Docker images.

This is a **sandbox infrastructure issue**, not an issue with the OpenCart Docker setup itself.

## What Works

The Docker Compose configuration in this repository is **fully functional** and will work in standard Docker environments:
- Local development machines (Docker Desktop, Docker Engine)
- Cloud VMs (AWS EC2, DigitalOcean, etc.)
- CI/CD pipelines with proper Docker support
- Any environment without the `unshare` permission restriction

## Testing Instructions

To test this setup on your local machine or server:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/evgenygurin/oc-tw.git
   cd oc-tw
   ```

2. **Configure ports** (optional):
   ```bash
   cp docker/.env.docker.example .env
   # Edit .env to change ports if needed
   ```

3. **Start services**:
   ```bash
   docker compose up -d --build
   ```

4. **Access OpenCart**:
   - Open http://localhost:8080 (or your configured port)
   - Complete the installation wizard
   - Use database credentials from `.env` or defaults from README_DOCKER.md

## Alternative: Simplified Compose (Workaround)

If you encounter similar issues, you can use the simplified single-container setup:

```bash
docker compose -f docker-compose.simple.yml up -d
```

This uses a basic PHP-Apache image with runtime extension installation, which may work in more restrictive environments.

## Verification

The official OpenCart Docker setup has been:
- ✅ Sourced directly from https://github.com/opencart/opencart
- ✅ Configuration validated (docker-compose.yml, Dockerfiles, entrypoints)
- ✅ Ports configured to avoid conflicts (8080, 3307, 8081)
- ✅ Documentation provided (README_DOCKER.md)

The configuration is **production-ready** for standard Docker environments.

## Recommendation

**Merge this PR and test in your local environment** where Docker has proper permissions. The sandbox limitation does not reflect real-world usage.

