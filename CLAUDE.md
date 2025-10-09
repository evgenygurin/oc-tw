# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**oc-tw** is a hybrid e-commerce project combining **OpenCart** (PHP-based e-commerce platform) with **Next.js 15** (React frontend). The architecture supports two development modes:

1. **OpenCart Backend**: Full e-commerce platform running in Docker with custom theming
2. **Next.js Frontend**: Modern React/TypeScript frontend (potentially for headless commerce integration)

## Architecture

### Dual-Stack Design

This project maintains two parallel stacks:

**OpenCart Stack** (Docker-based):

- OpenCart PHP application (custom Dockerfile)
- MariaDB 11.3 database
- phpMyAdmin for database management
- MailHog for email testing
- Custom `oc-astro` theme (inspired by Astro Ecommerce design)

**Next.js Stack** (Node-based):

- Next.js 15 with App Router
- TypeScript
- Tailwind CSS v4 with PostCSS
- shadcn/ui components (New York style)
- Turbopack for fast builds
- Lucide icons

### Key Architectural Decisions

**Theme Development via Bind Mounts**: The `theme/oc-astro/` directory is bind-mounted to the OpenCart container at `/var/www/html/catalog/view/theme/oc-astro`. This enables real-time theme development without rebuilding containers.

**Custom OpenCart Docker Image**: Uses `vimagick/opencart:latest` base with permission fixes for the bind-mounted theme directory. The Dockerfile is minimal to allow easy updates.

**shadcn/ui Integration**: Configured with path aliases (`@/components`, `@/lib`) and neutral color scheme for component library consistency.

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
fd "*.tsx"                        # Find all TypeScript JSX files
rg "export default" --type ts     # Search in TypeScript files
ast-grep --pattern 'function $NAME() { $$$ }'  # Find function patterns
fd "component" | fzf              # Interactive file selection
cat package.json | jq '.dependencies'  # Parse JSON
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

### Next.js (Frontend Stack)

```bash
# Development
npm install                    # Install dependencies
npm run dev                    # Start dev server with Turbopack (http://localhost:3000)
npm run build                  # Production build with Turbopack
npm start                      # Start production server
npm run lint                   # Run ESLint
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

### Component Development (Next.js)

```bash
# shadcn/ui component installation (when needed)
npx shadcn@latest add <component-name>

# Component locations:
# src/components/ui/     - shadcn/ui components
# src/components/        - Custom components
# src/lib/utils.ts       - Utility functions (cn helper)
```

## Critical Workflows

### First-Time Setup

```bash
# 1. Environment configuration
cp .env.example .env
# Edit .env with secure credentials

# 2. Start OpenCart stack
docker compose up -d

# 3. Complete OpenCart installation wizard
open http://localhost:8080
# Follow wizard, use database credentials from .env

# 4. Activate custom theme
# Login to http://localhost:8080/admin
# Extensions → Themes → oc-astro → Install → Edit

# 5. (Optional) Start Next.js frontend
npm install && npm run dev
```

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
- `MARIADB_USER`: OpenCart database user (default: `bn_opencart`)
- `MARIADB_PASSWORD`: OpenCart database password
- `MARIADB_DATABASE`: Database name (default: `bitnami_opencart`)
- `OPENCART_USERNAME`: Admin username (default: `admin`)
- `OPENCART_PASSWORD`: Admin password (default: `admin123`)
- `OPENCART_EMAIL`: Admin email

**Optional** (for email testing):

- `SMTP_HOST=mailhog`: MailHog captures all emails locally
- `SMTP_PORT=1025`: MailHog SMTP port

## File Structure & Conventions

```bash
oc-tw/
├── src/                          # Next.js application
│   ├── app/
│   │   ├── layout.tsx           # Root layout with Geist fonts
│   │   ├── page.tsx             # Homepage
│   │   └── globals.css          # Tailwind base styles
│   ├── components/
│   │   └── ui/                  # shadcn/ui components
│   └── lib/
│       └── utils.ts             # Utilities (cn for class merging)
│
├── theme/
│   └── oc-astro/                # OpenCart theme (bind-mounted)
│       ├── template/
│       │   ├── common/          # Header, footer, home
│       │   └── product/         # Product templates
│       └── stylesheet/          # CSS files
│
├── docker-compose.yml           # Multi-service stack definition
├── Dockerfile.opencart          # Custom OpenCart image
├── .env                         # Environment variables (git-ignored)
└── .env.example                 # Template for configuration
```

## Technology Stack Details

**Frontend**:

- Next.js 15.5.4 (App Router, Turbopack)
- React 19.1.0
- TypeScript 5
- Tailwind CSS 4 (PostCSS)
- shadcn/ui (Radix UI primitives)
- Lucide icons

**Backend (OpenCart)**:

- OpenCart (vimagick/opencart image)
- PHP with Apache
- MariaDB 11.3
- Twig templating engine

**Development Tools**:

- Docker Compose
- phpMyAdmin (database GUI)
- MailHog (email testing)
- ESLint 9
- Turbopack (faster than Webpack)

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

**Next.js and OpenCart both running**:

- Next.js: `http://localhost:3000`
- OpenCart: `http://localhost:8080`
- No conflict; they can run simultaneously for headless integration development

## Pull Request Rules

### PR Template Requirements

**Every PR MUST include:**

1. **Clear Description**
   - Brief summary of changes (2-3 sentences)
   - WHY the change was made (business/technical reason)
   - Link to related issue/ticket if applicable

2. **Type Classification** (choose one):
   - `feat:` - New feature (OpenCart module, Next.js component)
   - `fix:` - Bug fix
   - `refactor:` - Code restructuring without behavior change
   - `style:` - UI/UX changes (theme, CSS, components)
   - `docs:` - Documentation updates
   - `chore:` - Maintenance (dependencies, config)
   - `perf:` - Performance improvements

3. **Testing Evidence**
   - Screenshots for UI changes
   - Test results for backend changes
   - Manual testing steps performed

4. **Affected Components** (check all that apply):
   - [ ] OpenCart backend
   - [ ] Next.js frontend
   - [ ] Docker configuration
   - [ ] Theme (oc-astro)
   - [ ] Database schema

### Code Quality Requirements

**Before submitting PR:**

```bash
# Next.js code
npm run lint                    # Must pass without errors
npm run build                   # Must build successfully

# Docker services
docker compose up -d            # Must start without errors
docker compose ps               # All services must be healthy
```

### PR Checklist

- [ ] **Branch naming**: `feat/description` or `fix/description`
- [ ] **Commit messages**: Follow conventional commits format
- [ ] **No secrets**: `.env` files excluded, no hardcoded credentials
- [ ] **Dependencies**: `package.json` or `composer.json` updated if needed
- [ ] **Documentation**: CLAUDE.md updated for architectural changes
- [ ] **Backwards compatibility**: Migrations provided for breaking changes
- [ ] **Performance**: No N+1 queries, optimized images, lazy loading where applicable

### Automated Checks (Codegen)

Codegen agent will automatically:

1. **Analyze code quality**
   - TypeScript type safety
   - ESLint compliance
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
refactor(next): migrate to app router structure
style(ui): update checkout flow with shadcn components
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

- ESLint errors present
- Docker build fails
- Security vulnerabilities detected
- Missing required checklist items
- No description provided

## Resources

- **OpenCart Docs**: <https://docs.opencart.com/>
- **Next.js 15 Docs**: <https://nextjs.org/docs>
- **Astro Ecommerce Design**: <https://www.creative-tim.com/product/astro-ecommerce>
- **shadcn/ui**: <https://ui.shadcn.com/>
- **Tailwind CSS**: <https://tailwindcss.com/>
- **Conventional Commits**: <https://www.conventionalcommits.org/>
