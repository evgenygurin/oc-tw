# OpenCart Docker Setup

This repository contains the official OpenCart e-commerce platform with Docker Compose configuration for easy local development.

## Quick Start

### 1. Configuration (Optional)

Copy the example environment file and adjust if needed:

```bash
cp docker/.env.docker.example .env
```

Default ports:
- **OpenCart**: http://localhost:8080 (HTTP_EXPOSE_PORT=8080)
- **MySQL**: 3307 (DB_EXPOSE_PORT=3307)
- **Adminer**: http://localhost:8081 (ADMINER_EXPOSE_PORT=8081)

> **Note**: We use non-standard ports (8080, 3307, 8081) by default to avoid conflicts with other services.

### 2. Start Docker Containers

```bash
docker compose up -d --build
```

Wait for all containers to be healthy (~30-60 seconds).

### 3. Complete OpenCart Installation

Open http://localhost:8080 in your browser and follow the installation wizard.

**Database Configuration** (use these exact values):
- **Hostname**: `mysql`
- **Username**: `opencart`
- **Password**: `opencart`
- **Database**: `opencart`
- **Port**: `3306` (internal port, not the exposed 3307)
- **Prefix**: `oc_`

**Admin Configuration**:
- **Username**: `admin` (or customize via `OPENCART_USERNAME` in .env)
- **Password**: `admin` (or customize via `OPENCART_PASSWORD` in .env)
- **Email**: `admin@example.com` (or customize via `OPENCART_ADMIN_EMAIL` in .env)

### 4. Access

- **Storefront**: http://localhost:8080
- **Admin Panel**: http://localhost:8080/admin
- **Adminer** (DB tool): http://localhost:8081 (enable with `--profile adminer`)

## Docker Services

The setup includes:
- **apache**: Apache 2.4 web server
- **php**: PHP-FPM 8.4 with OpenCart dependencies
- **mysql**: MariaDB database

Optional services (use `--profile <name>`):
- **adminer**: Database management UI (`--profile adminer`)
- **redis**: Redis cache (`--profile redis`)
- **memcached**: Memcached cache (`--profile memcached`)
- **postgres**: PostgreSQL database (`--profile postgres`)

## Common Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# View logs
docker compose logs -f

# Rebuild containers
docker compose up -d --build

# Clean everything (including database)
docker compose down -v

# Enable Adminer
docker compose --profile adminer up -d
```

## Troubleshooting

### Port Conflicts

If ports are already in use, modify these in `.env`:
- `HTTP_EXPOSE_PORT` (default: 8080)
- `DB_EXPOSE_PORT` (default: 3307)
- `ADMINER_EXPOSE_PORT` (default: 8081)

### Reset Installation

To start fresh:
```bash
docker compose down -v
docker compose up -d --build
```

This will delete all data including the database.

## Development

OpenCart source files are in the `upload/` directory. Changes to PHP files will be reflected immediately.

For theme/extension development, see the official [OpenCart documentation](https://docs.opencart.com/).

## Official Resources

- **OpenCart GitHub**: https://github.com/opencart/opencart
- **Official Website**: https://www.opencart.com/
- **Documentation**: https://docs.opencart.com/
- **Community Forum**: https://forum.opencart.com/

