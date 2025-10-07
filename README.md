# OpenCart + Astro Ecommerce Theme (Docker)

Production-ready OpenCart setup with a custom theme inspired by [Astro Ecommerce](https://www.creative-tim.com/product/astro-ecommerce) by Creative Tim.

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd oc-tw

# 2. Copy environment variables
cp .env.example .env

# 3. Start the services
docker compose up -d

# 4. Open your browser
open http://localhost:8080
```

## 📦 What's Included

- **OpenCart** (latest stable via Bitnami) - E-commerce platform
- **MariaDB 11.3** - Database
- **phpMyAdmin** (port 8081) - Database management UI
- **MailHog** (port 8025) - Email testing for development
- **oc-astro Theme** - Modern theme based on Astro Ecommerce design

## 🔧 Services & Ports

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| OpenCart | 8080 | http://localhost:8080 | Main store |
| OpenCart Admin | 8080/admin | http://localhost:8080/admin | Admin panel |
| phpMyAdmin | 8081 | http://localhost:8081 | Database GUI |
| MailHog UI | 8025 | http://localhost:8025 | Email testing |

## ⚙️ Configuration

### Environment Variables (`.env`)

```env
# OpenCart Settings
OPENCART_HOST=localhost
OPENCART_USERNAME=admin
OPENCART_PASSWORD=admin123
OPENCART_EMAIL=admin@example.com

# Database Settings
MARIADB_ROOT_PASSWORD=rootpassword
MARIADB_USER=bn_opencart
MARIADB_PASSWORD=opencart
MARIADB_DATABASE=bitnami_opencart

# SMTP (MailHog for local dev)
SMTP_HOST=mailhog
SMTP_PORT=1025
```

## 🎨 oc-astro Theme

The `oc-astro` theme is a modern, responsive OpenCart theme inspired by Astro Ecommerce:

### Features
- 🎨 Modern UI with Bootstrap 5
- 📱 Fully responsive design
- 🛍️ Product cards with hover effects
- 🛒 Shopping cart components
- ⭐ Product reviews and ratings
- 📦 Order history views

### Installation

1. **Start OpenCart** via Docker Compose
2. **Complete the OpenCart installation** wizard at http://localhost:8080
3. **Activate the theme:**
   - Login to admin panel: http://localhost:8080/admin
   - Go to **Extensions → Extensions → Themes**
   - Find "oc-astro" and click **Install** then **Edit**

### Theme Development

Theme files are bind-mounted from `./theme/oc-astro/` to the container, so changes reflect immediately:

```
theme/oc-astro/
├── template/
│   ├── common/          # Header, footer, home
│   ├── product/         # Product pages
│   └── checkout/        # Cart, checkout
├── stylesheet/
│   └── stylesheet.css   # Custom styles
└── js/
    └── common.js        # Custom JS
```

See [theme/oc-astro/README.md](theme/oc-astro/README.md) for detailed documentation.

## 🛠️ Development Workflow

### Start Services
```bash
docker compose up -d
```

### View Logs
```bash
docker compose logs -f opencart
docker compose logs -f mariadb
```

### Stop Services
```bash
docker compose down
```

### Reset Database (Clean Install)
```bash
docker compose down -v  # ⚠️ This deletes all data
docker compose up -d
```

### Access phpMyAdmin
1. Open http://localhost:8081
2. Server: `mariadb`
3. Username: `bn_opencart` (or `root`)
4. Password: from your `.env`

### Test Emails with MailHog
All emails sent by OpenCart will be captured by MailHog:
- UI: http://localhost:8025
- No emails leave your local environment

## 🗂️ Project Structure

```
.
├── docker-compose.yml        # Docker orchestration
├── .env.example             # Environment variables template
├── theme/
│   └── oc-astro/           # OpenCart theme (bind-mounted)
│       ├── template/       # Twig templates
│       ├── stylesheet/     # CSS files
│       ├── js/            # JavaScript
│       └── README.md      # Theme documentation
└── README.md              # This file
```

## 📚 Resources

- **OpenCart Docs**: https://docs.opencart.com/
- **Bitnami OpenCart**: https://hub.docker.com/r/bitnami/opencart
- **Astro Ecommerce**: https://www.creative-tim.com/product/astro-ecommerce
- **Bootstrap 5**: https://getbootstrap.com/
- **FontAwesome**: https://fontawesome.com/

## 🐛 Troubleshooting

### OpenCart installation wizard not appearing
- Make sure the database is healthy: `docker compose ps`
- Wait for the healthcheck: `docker compose logs mariadb`
- If stuck, restart: `docker compose restart opencart`

### Theme not showing up in admin
- Verify bind mount: `docker compose exec opencart ls -la /bitnami/opencart/catalog/view/theme/`
- You should see `oc-astro` directory
- Check file permissions

### Database connection errors
- Check `.env` values match between `MARIADB_*` and `OPENCART_*`
- Ensure MariaDB is healthy: `docker compose ps`
- Try recreating containers: `docker compose down && docker compose up -d`

### Port conflicts
If ports 8080, 8081, or 8025 are in use, edit `docker-compose.yml`:
```yaml
ports:
  - "9080:8080"  # Change host port (left side)
```

## 📄 License

- **This Project**: MIT (or specify your license)
- **Astro Ecommerce**: MIT by Creative Tim
- **OpenCart**: GPL
- **Bootstrap**: MIT
- **FontAwesome**: CC BY 4.0 / SIL OFL 1.1

## 🙋 Support

For issues related to:
- **OpenCart**: [OpenCart Forums](https://forum.opencart.com/)
- **Astro Ecommerce Design**: [Creative Tim Support](https://www.creative-tim.com/support)
- **This setup**: Open an issue in this repository

---

**Built with** ❤️ using Docker, OpenCart, and Astro Ecommerce design inspiration.

