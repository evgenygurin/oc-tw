# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**oc-tw** is an OpenCart e-commerce platform running in Docker with custom theming and modern development workflow automation.

## Architecture

### OpenCart Stack (Docker-based)

- OpenCart PHP application (custom Dockerfile)
- MariaDB 11.3 database
- phpMyAdmin for database management
- MailHog for email testing
- Custom `oc-astro` theme (inspired by Astro Ecommerce design)

### Key Architectural Decisions

**Theme Development via Bind Mounts**: The `theme/oc-astro/` directory is bind-mounted to the OpenCart container at `/var/www/html/catalog/view/theme/oc-astro`. This enables real-time theme development without rebuilding containers.

**Custom OpenCart Docker Image**: Uses `vimagick/opencart:latest` base with permission fixes for the bind-mounted theme directory. The Dockerfile is minimal to allow easy updates.

## Development Commands

### CRITICAL: Modern CLI Tools

**ALWAYS use these modern tools instead of traditional Unix commands:**

- `fd` instead of `find` - Fast file search
- `rg` (ripgrep) instead of `grep` - Fast content search
- `ast-grep` - AST-based code search for precise refactoring
- `fzf` - Fuzzy finder for interactive selection
- `jq` - JSON processing and querying
- `yq` - YAML/XML processing (like jq for YAML)

```bash
# Examples:
fd "*.php"                         # Find all PHP files
rg "function" --type php           # Search in PHP files
ast-grep --pattern 'function $NAME() { $$$ }'  # Find function patterns
fd "controller" | fzf              # Interactive file selection
cat composer.json | jq '.require'  # Parse JSON
```

### OpenCart (Docker Stack)

```bash
# Initial setup
cp .env.example .env           # Configure database credentials
docker compose up -d           # Start all services

# Service management
docker compose logs -f opencart        # View OpenCart logs
docker compose logs -f mariadb         # View database logs
docker compose restart opencart        # Restart OpenCart after config changes
docker compose down                    # Stop all services
docker compose down -v                 # Stop and remove volumes (fresh install)

# Access services
# OpenCart:    http://localhost:8080
# Admin:       http://localhost:8080/admin
# phpMyAdmin:  http://localhost:8081
# MailHog:     http://localhost:8025
```

### Theme Development (OpenCart)

Theme files in `theme/oc-astro/` are live-mounted:

```bash
# After editing theme files, changes are immediately available
# No restart needed for template changes (Twig files)
# Restart OpenCart for PHP logic changes:
docker compose restart opencart

# Theme structure:
# theme/oc-astro/
#   template/
#     common/       - header.twig, footer.twig, home.twig
#     product/      - product.twig (product detail page)
#   stylesheet/
#     stylesheet.css - Custom theme styles
```

**Theme Activation**: After first install, activate theme in OpenCart admin:

1. Extensions → Extensions → Themes
2. Find "oc-astro" → Install → Edit

## Critical Workflows

### First-Time Setup

```bash
# 1. Environment configuration
cp .env.example .env
# Edit .env with secure credentials

# 2. Start OpenCart stack
docker compose up -d

# 3. Complete OpenCart installation wizard
open http://localhost:8080/install
# Follow wizard, use database credentials from .env

# 4. IMPORTANT: Remove install directory (security)
docker compose exec opencart rm -rf /var/www/html/install

# 5. Activate custom theme
# Login to http://localhost:8080/admin
# Extensions → Themes → oc-astro → Install → Edit
```

**Security Note**: The `/install` directory MUST be removed from the container after installation to prevent unauthorized reinstallation. The local `/install` directory in your project contains the OpenCart installer source code and should remain in the repository.

### Database Reset (Fresh OpenCart Install)

```bash
docker compose down -v          # WARNING: Deletes all data
docker compose up -d
# Complete installation wizard again at http://localhost:8080
```

### Adding Bootstrap/FontAwesome to Theme

The `oc-astro` theme requires Bootstrap 5 and FontAwesome. Two options:

**Option A: CDN (Quick)**
Edit `theme/oc-astro/template/common/header.twig` to add CDN links

**Option B: Local Assets (Production)**

```bash
# Download and place in theme directory:
# - Bootstrap 5 → theme/oc-astro/stylesheet/bootstrap.min.css
#               → theme/oc-astro/js/bootstrap.bundle.min.js
# - FontAwesome → theme/oc-astro/stylesheet/fontawesome.min.css
```

## Environment Variables

**Required for OpenCart** (`.env`):

- `MARIADB_ROOT_PASSWORD`: Database root password
- `MARIADB_USER`: OpenCart database user (default: `opencart`)
- `MARIADB_PASSWORD`: OpenCart database password
- `MARIADB_DATABASE`: Database name (default: `opencart_db`)
- `OPENCART_ADMIN_USERNAME`: Admin username (default: `admin`)
- `OPENCART_ADMIN_PASSWORD`: Admin password (default: `admin123`)
- `OPENCART_ADMIN_EMAIL`: Admin email

**Optional** (for email testing):

- `SMTP_HOST=mailhog`: MailHog captures all emails locally
- `SMTP_PORT=1025`: MailHog SMTP port

## File Structure & Conventions

```bash
oc-tw/
├── theme/
│   └── oc-astro/                # OpenCart theme (bind-mounted)
│       ├── template/
│       │   ├── common/          # Header, footer, home
│       │   └── product/         # Product templates
│       └── stylesheet/          # CSS files
│
├── docker-compose.yml           # Multi-service stack definition
├── Dockerfile                   # Custom OpenCart image
├── .env                         # Environment variables (git-ignored)
└── .env.example                 # Template for configuration
```

## Technology Stack Details

**Backend (OpenCart)**:

- OpenCart (vimagick/opencart image)
- PHP with Apache
- MariaDB 11.3
- Twig templating engine

**Development Tools**:

- Docker Compose
- phpMyAdmin (database GUI)
- MailHog (email testing)

## Common Issues & Solutions

**OpenCart installation wizard not appearing**:

- Check database health: `docker compose ps` (mariadb should be "healthy")
- Wait for healthcheck: `docker compose logs mariadb | grep "ready for connections"`
- Restart if needed: `docker compose restart opencart`

**Theme not visible in admin**:

- Verify bind mount: `docker compose exec opencart ls -la /var/www/html/catalog/view/theme/`
- Should show `oc-astro` directory
- Check file permissions in theme directory

**Database connection errors**:

- Ensure `.env` credentials match between `MARIADB_*` and `OPENCART_*` variables
- Verify MariaDB is running: `docker compose ps mariadb`
- Check OpenCart logs: `docker compose logs opencart`

**Port conflicts (8080, 8081, 8025)**:

- Edit `docker-compose.yml` ports section
- Change left side (host port): `"9080:80"` instead of `"8080:80"`

## Pull Request Rules

### PR Template Requirements

**Every PR MUST include:**

1. **Clear Description**
   - Brief summary of changes (2-3 sentences)
   - WHY the change was made (business/technical reason)
   - Link to related issue/ticket if applicable

2. **Type Classification** (choose one):
   - `feat:` - New feature (OpenCart module, theme component)
   - `fix:` - Bug fix
   - `refactor:` - Code restructuring without behavior change
   - `style:` - UI/UX changes (theme, CSS)
   - `docs:` - Documentation updates
   - `chore:` - Maintenance (dependencies, config)
   - `perf:` - Performance improvements

3. **Testing Evidence**
   - Screenshots for UI changes
   - Test results for backend changes
   - Manual testing steps performed

4. **Affected Components** (check all that apply):
   - [ ] OpenCart backend
   - [ ] Docker configuration
   - [ ] Theme (oc-astro)
   - [ ] Database schema

### Code Quality Requirements

**Before submitting PR:**

```bash
# Docker services
docker compose up -d            # Must start without errors
docker compose ps               # All services must be healthy
```

### PR Checklist

- [ ] **Branch naming**: `feat/description` or `fix/description`
- [ ] **Commit messages**: Follow conventional commits format
- [ ] **No secrets**: `.env` files excluded, no hardcoded credentials
- [ ] **Dependencies**: `composer.json` updated if needed
- [ ] **Documentation**: CLAUDE.md updated for architectural changes
- [ ] **Backwards compatibility**: Migrations provided for breaking changes
- [ ] **Performance**: No N+1 queries, optimized images, lazy loading where applicable

### Automated Checks (Codegen)

Codegen agent will automatically:

1. **Analyze code quality**
   - PHP coding standards (PSR-12)

2. **Check for issues**
   - Security vulnerabilities
   - Deprecated dependencies
   - Missing error handling

3. **Verify integration**
   - Docker services health
   - Database migrations
   - API compatibility

### Review Process

**Reviewer checklist:**

- [ ] Code follows project architecture patterns
- [ ] No unnecessary complexity introduced
- [ ] Error handling implemented properly
- [ ] Security best practices followed
- [ ] Performance implications considered
- [ ] Documentation is clear and accurate

### Examples of Good PR Titles

```text
feat(opencart): add product comparison functionality
fix(theme): resolve mobile menu overflow issue
style(ui): update checkout flow with modern design
perf(docker): optimize image build with multi-stage
docs(setup): add troubleshooting guide for M1 Macs
```

### Auto-merge Criteria

PR will be auto-merged if:

- All automated checks pass
- Approved by at least 1 reviewer
- No merge conflicts
- Branch is up-to-date with main

### Blocked PR Scenarios

PR will be blocked if:

- Docker build fails
- Security vulnerabilities detected
- Missing required checklist items
- No description provided

## Resources

- **OpenCart Docs**: <https://docs.opencart.com/>
- **Astro Ecommerce Design**: <https://www.creative-tim.com/product/astro-ecommerce>
- **Conventional Commits**: <https://www.conventionalcommits.org/>
