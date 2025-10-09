#!/bin/bash

# OpenCart Complete Automated Setup Script
# This script automatically sets up OpenCart with Docker with minimal user intervention

set -e

echo "🚀 OpenCart Complete Automated Setup"
echo "===================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    local status=$1
    local message=$2
    case $status in
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ;;
        "INFO") echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "STEP") echo -e "${CYAN}🔧 $message${NC}" ;;
    esac
}

# Generate secure random password
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-16 2>/dev/null || echo "$(date +%s)_secure_$(whoami)"
}

print_status "INFO" "Starting complete OpenCart automated setup..."
echo ""

# Check if Docker/Docker Compose is available
print_status "STEP" "Step 1: Checking Docker availability..."
if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_CMD="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    DOCKER_CMD="docker compose"
else
    print_status "ERROR" "Docker/Docker Compose not found"
    echo ""
    echo "Please install Docker first:"
    echo "- Docker Desktop: https://docker.com/get-started"
    echo "- Or follow installation guide for your OS"
    echo ""
    echo "After installing Docker, run this script again."
    exit 1
fi

print_status "SUCCESS" "Docker Compose available: $DOCKER_CMD"
echo ""

# Stop any existing services
print_status "STEP" "Step 2: Cleaning up any existing services..."
$DOCKER_CMD down --remove-orphans >/dev/null 2>&1 || true
print_status "SUCCESS" "Existing services cleaned up"
echo ""

# Set up environment file with secure defaults
print_status "STEP" "Step 3: Setting up secure environment configuration..."

if [ -f ".env" ]; then
    print_status "WARNING" ".env file exists - backing up to .env.backup"
    cp .env .env.backup
fi

# Generate secure passwords
ROOT_PASSWORD=$(generate_password)
DB_PASSWORD=$(generate_password)
ADMIN_PASSWORD=$(generate_password)

# Create .env file with secure defaults
cat > .env << EOF
# MariaDB Configuration (Auto-generated secure passwords)
MARIADB_ROOT_PASSWORD=${ROOT_PASSWORD}
MARIADB_DATABASE=opencart_db
MARIADB_USER=opencart
MARIADB_PASSWORD=${DB_PASSWORD}

# OpenCart Configuration
OPENCART_ADMIN_USERNAME=admin
OPENCART_ADMIN_PASSWORD=${ADMIN_PASSWORD}
OPENCART_ADMIN_EMAIL=admin@localhost.local

# Timezone
TZ=UTC
EOF

print_status "SUCCESS" "Environment configuration created with secure passwords"
echo ""

# Start Docker services
print_status "STEP" "Step 4: Starting OpenCart Docker services..."
echo "This may take a few minutes on first run (downloading images)..."
echo ""

$DOCKER_CMD up -d

print_status "SUCCESS" "Docker services started"
echo ""

# Wait for database to be ready
print_status "STEP" "Step 5: Waiting for database to be ready..."
MAX_WAIT=120
WAIT_COUNT=0

echo -n "Waiting for MariaDB to start"
while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if $DOCKER_CMD logs opencart_mariadb 2>/dev/null | grep -q "ready for connections"; then
        echo ""
        print_status "SUCCESS" "Database is ready and accepting connections"
        break
    fi
    echo -n "."
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

if [ $WAIT_COUNT -ge $MAX_WAIT ]; then
    echo ""
    print_status "ERROR" "Database didn't start within $MAX_WAIT seconds"
    print_status "INFO" "Check logs with: $DOCKER_CMD logs opencart_mariadb"
    exit 1
fi
echo ""

# Wait for OpenCart to be ready
print_status "STEP" "Step 6: Waiting for OpenCart to be ready..."
MAX_WAIT=60
WAIT_COUNT=0

echo -n "Waiting for OpenCart web server"
while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if command -v curl >/dev/null 2>&1; then
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null || echo "000")
        if [ "$HTTP_STATUS" = "200" ]; then
            echo ""
            print_status "SUCCESS" "OpenCart web server is ready"
            break
        fi
    fi
    echo -n "."
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done
echo ""

if [ "$HTTP_STATUS" != "200" ]; then
    print_status "WARNING" "OpenCart may still be starting up"
    print_status "INFO" "Check logs with: $DOCKER_CMD logs opencart"
    echo ""
fi

# Display service status
print_status "STEP" "Step 7: Checking service status..."
SERVICE_STATUS=$($DOCKER_CMD ps --format "table {{.Name}}\t{{.Status}}")
echo "$SERVICE_STATUS"
echo ""

# Display completion information
print_status "SUCCESS" "🎉 OpenCart Complete Setup Finished!"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "🌐 ACCESS YOUR OPENCART"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "📱 Store Front:    http://localhost:8080/"
echo "🔧 Installation:   http://localhost:8080/install"
echo "👨‍💼 Admin Panel:    http://localhost:8080/admin"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "🔐 AUTO-GENERATED CREDENTIALS"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Database Connection (for installation wizard):"
echo "   Host:       localhost (or mariadb from inside container)"
echo "   Port:       3306"
echo "   Database:   opencart_db"
echo "   Username:   opencart"
echo "   Password:   ${DB_PASSWORD}"
echo ""
echo "Admin Account:"
echo "   Username:   admin"
echo "   Password:   ${ADMIN_PASSWORD}"
echo "   Email:      admin@localhost.local"
echo ""
echo "Database Root (for advanced users):"
echo "   Username:   root"
echo "   Password:   ${ROOT_PASSWORD}"
echo ""
echo "💾 IMPORTANT: These credentials are saved in your .env file"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "📋 NEXT STEPS"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. 🌐 Open your browser and go to:"
echo "   http://localhost:8080/"
echo ""
echo "2. 🔧 If you see the installation wizard:"
echo "   - Click through the installation steps"
echo "   - Use the database credentials shown above"
echo "   - Use the admin credentials shown above"
echo ""
echo "3. 🏪 If you see the OpenCart store:"
echo "   - Your OpenCart is already set up!"
echo "   - Go to http://localhost:8080/admin to manage"
echo ""
echo "4. 🔒 SECURITY: After installation completes:"
echo "   - The install directory should be automatically removed"
echo "   - Change default passwords in admin panel"
echo "   - Consider enabling SSL in production"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "🛠️  USEFUL COMMANDS"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "View logs:         $DOCKER_CMD logs opencart"
echo "View database:     $DOCKER_CMD logs opencart_mariadb"
echo "Restart services:  $DOCKER_CMD restart"
echo "Stop services:     $DOCKER_CMD down"
echo "View status:       $DOCKER_CMD ps"
echo "Enter container:   $DOCKER_CMD exec opencart bash"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "🚨 TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "If you encounter issues:"
echo "1. Check service status: $DOCKER_CMD ps"
echo "2. Check logs: $DOCKER_CMD logs opencart"
echo "3. Restart services: $DOCKER_CMD restart"
echo "4. Full reset: $DOCKER_CMD down -v && ./auto-setup-complete.sh"
echo ""

# Test final accessibility
if command -v curl >/dev/null 2>&1; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null || echo "000")
    if [ "$HTTP_STATUS" = "200" ]; then
        print_status "SUCCESS" "✅ OpenCart is accessible at http://localhost:8080/"
    else
        print_status "WARNING" "⚠️  OpenCart may still be starting. Try again in a moment."
    fi
fi

echo ""
echo "🎉 Setup complete! Happy OpenCart development! 🚀"
echo ""

# Save credentials to a separate file for easy reference
cat > .credentials.txt << EOF
OpenCart Setup Credentials (Generated: $(date))
===============================================

🌐 URLs:
Store:       http://localhost:8080/
Install:     http://localhost:8080/install
Admin:       http://localhost:8080/admin

🔐 Database (for installation):
Host:        localhost
Port:        3306
Database:    opencart_db
Username:    opencart
Password:    ${DB_PASSWORD}

👨‍💼 Admin Account:
Username:    admin
Password:    ${ADMIN_PASSWORD}
Email:       admin@localhost.local

🔑 Database Root:
Username:    root
Password:    ${ROOT_PASSWORD}

⚠️  SECURITY: Delete this file after noting your credentials!
EOF

print_status "INFO" "Credentials also saved to .credentials.txt (remember to delete after use)"
echo ""