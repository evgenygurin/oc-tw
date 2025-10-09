# oc-tw - OpenCart E-commerce Platform

OpenCart e-commerce platform running in Docker with MariaDB and phpMyAdmin.

## 📋 PR Automation Setup

**🎉 This repository has comprehensive PR automation!**

For contributors:

- 📖 Read [Contributing Guide](.github/CONTRIBUTING.md)
- ✨ See [PR Example](.github/PR_EXAMPLE.md)

For maintainers:

- ⚙️ Apply [GitHub Settings](.github/branch-protection.md)
- 🤖 Configure [Codegen AI](.github/AGENTS.md)
- 📊 See [Full Summary](PR_RULES_SUMMARY.md)

## 🚀 Quick Start

### Prerequisites

- Docker Desktop installed and running
- Stable internet connection for pulling Docker images

### Installation

```bash
# 1. Start Docker Desktop
open -a Docker

# 2. Configure environment
cp .env.example .env
# Edit .env with your secure credentials

# 3. Start services
docker compose up -d

# 4. Complete installation wizard
open http://localhost:8080/install

# 5. Remove install directory (security)
docker compose exec opencart rm -rf /var/www/html/install
```

**Default Credentials** (from `.env`):

- Username: `admin`
- Password: `admin123`
- Email: `admin@example.com`
- Admin Panel: <http://localhost:8080/admin>

**⚠️ Security Note**: After installation, the `/install` directory is automatically removed from the container for security. The local `/install` directory in your project is the OpenCart installer source code and should remain in the repository.

## 📦 What's Included

- **OpenCart**: Latest version from master branch
- **MariaDB 10.11**: Optimized MySQL-compatible database
- **Adminer**: Web-based database management (<http://localhost:8081>)
- **MailHog**: Email testing tool (<http://localhost:8025>)
- **Custom Theme**: `oc-astro` theme with modern styling

## 🛠️ Available Commands

Run `make help` to see all available commands:

```bash
make help          # Show all commands
make build         # Build Docker containers
make up            # Start all services
make down          # Stop all services
make restart       # Restart services
make logs          # View logs (all services)
make logs-opencart # View OpenCart logs only
make status        # Show service status
make clean         # Remove containers and volumes
make install       # Fresh installation
make reset         # Complete reset (clean + install)
make health        # Health check all services
make backup-db     # Backup database
make shell-opencart # Shell into OpenCart container
make db-shell      # MySQL CLI access
```

## 🏗️ Architecture

### Services

1. **OpenCart** (Port 8080)
   - PHP 8.2 with Apache
   - Auto-installs on first run
   - Volume-mounted for persistence

2. **MariaDB** (Port 3307)
   - MariaDB 10.11
   - Optimized for Docker (io_uring disabled, binlog skipped)
   - Health checks enabled

3. **Adminer** (Port 8081)
   - Lightweight phpMyAdmin alternative
   - Connect with: Server=`mysql`, User=`opencart`, Pass=`opencart_pass`

4. **MailHog** (Port 8025)
   - Catches all outgoing emails
   - Web UI for viewing emails

### Directory Structure

```text
oc-tw/
├── theme/
│   └── oc-astro/            # Custom OpenCart theme (bind-mounted)
│       ├── template/
│       ├── stylesheet/
│       ├── image/
│       └── js/
├── scripts/
│   └── opencart-entrypoint.sh  # Container initialization script
├── docker-compose.yml       # Service orchestration
├── Dockerfile              # OpenCart image definition
├── Makefile                # Development commands
├── .env                    # Environment variables
└── README.md               # This file
```

## 🎨 Theme Development

The `oc-astro` theme is bind-mounted, allowing real-time development:

```bash
# Edit theme files
nano theme/oc-astro/stylesheet/stylesheet.css

# Changes are immediately available (no restart needed for templates)
# Restart OpenCart only for PHP logic changes:
make restart
```

### Theme Structure

```text
theme/oc-astro/
├── template/
│   ├── common/      # header.twig, footer.twig, home.twig
│   └── product/     # product.twig
├── stylesheet/      # CSS files
├── image/           # Theme images
└── js/              # JavaScript files
```

## 🐛 Troubleshooting

### "Too many open files" error

This is a Docker Desktop on macOS issue. Solutions:

1. Restart Docker Desktop
2. Increase file descriptor limits (already set in config)
3. Use `make prune` to clean up Docker resources

### OpenCart installation fails

```bash
# Check logs
make logs-opencart

# Reset everything
make reset
```

### MySQL connection errors

```bash
# Check MySQL health
make logs-mysql
docker compose exec mysql mysqladmin ping -h localhost

# Verify environment variables match
cat .env
```

### Port conflicts

Edit `docker-compose.yml` and change ports:

```yaml
ports:
  - "9080:80"  # Change 8080 to 9080
```

## 🔧 Configuration

### Environment Variables (.env)

```env
# MySQL/MariaDB
MYSQL_ROOT_PASSWORD=root_secure_2025
MYSQL_DATABASE=opencart_db
MYSQL_USER=opencart
MYSQL_PASSWORD=opencart_pass

# OpenCart Admin
OPENCART_ADMIN_USERNAME=admin
OPENCART_ADMIN_PASSWORD=admin123
OPENCART_ADMIN_EMAIL=admin@example.com
OPENCART_HTTP_SERVER=http://localhost:8080/

# Timezone
TZ=UTC
```

### Database Access

**Via Adminer** (Web UI):

- URL: <http://localhost:8081>
- System: MySQL
- Server: `mysql`
- Username: `opencart`
- Password: `opencart_pass`
- Database: `opencart_db`

**Via Command Line**:

```bash
make db-shell
# Or manually:
docker compose exec mysql mysql -u opencart -popencart_pass opencart_db
```

## 📊 Database Backup & Restore

```bash
# Backup database
make backup-db
# Creates: backups/opencart_YYYYMMDD_HHMMSS.sql

# Restore database
make restore-db file=backups/opencart_20250108_120000.sql
```

## 🚀 Production Deployment

**DO NOT** use this Docker setup in production. This is a development environment.

For production:

1. Use managed database (RDS, CloudSQL, etc.)
2. Deploy OpenCart to a PHP hosting environment
3. Configure proper SSL/TLS
4. Harden security settings
5. Set up proper backups
6. Configure CDN for static assets

## 📚 Resources

- [OpenCart Documentation](https://docs.opencart.com/)
- [OpenCart GitHub](https://github.com/opencart/opencart)
- [MariaDB Documentation](https://mariadb.org/documentation/)

## ⚠️ Security Notes

- Change default admin credentials immediately
- Update `.env` with strong passwords
- Don't commit `.env` to version control (already in .gitignore)
- Remove `install/` directory after installation (auto-removed by entrypoint)
- Keep OpenCart and dependencies updated

## 🐳 Docker Commands Reference

```bash
# View all containers
docker compose ps

# View logs
docker compose logs -f

# Stop services
docker compose down

# Remove volumes (WARNING: deletes data)
docker compose down -v

# Rebuild from scratch
docker compose build --no-cache

# Execute command in container
docker compose exec opencart bash
docker compose exec mysql mysql -u root -p
```

## 📝 License

OpenCart is licensed under GPL v3.0. See OpenCart documentation for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🆘 Support

For issues:

1. Check logs: `make logs`
2. Verify health: `make health`
3. Review troubleshooting section above
4. Check OpenCart community forums
5. Open an issue in this repository
