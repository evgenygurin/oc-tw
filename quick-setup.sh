#!/bin/bash

# OpenCart Quick Setup Script
# This script helps you get OpenCart up and running quickly

set -e

echo "🚀 OpenCart Quick Setup"
echo "======================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    local status=$1
    local message=$2
    case $status in
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ;;
        "INFO") echo -e "${BLUE}ℹ️  $message${NC}" ;;
    esac
}

# Check if Docker Compose is available
if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_CMD="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    DOCKER_CMD="docker compose"
else
    print_status "ERROR" "Docker/Docker Compose not found"
    echo "Please install Docker and Docker Compose first"
    exit 1
fi

# Step 1: Environment setup
print_status "INFO" "Step 1: Setting up environment..."
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_status "SUCCESS" "Created .env file from template"
        print_status "WARNING" "Please edit .env file with your secure credentials before continuing"
        echo ""
        echo "Edit these values in .env:"
        echo "- MARIADB_ROOT_PASSWORD=your_secure_root_password"
        echo "- MARIADB_PASSWORD=your_secure_password"
        echo "- OPENCART_ADMIN_PASSWORD=your_admin_password"
        echo ""
        read -p "Press Enter after editing .env file to continue..."
    else
        print_status "ERROR" ".env.example not found"
        exit 1
    fi
else
    print_status "SUCCESS" ".env file already exists"
fi
echo ""

# Step 2: Start services
print_status "INFO" "Step 2: Starting Docker services..."
echo "This may take a few minutes on first run (downloading images)..."
$DOCKER_CMD up -d

# Wait for services to be ready
print_status "INFO" "Waiting for services to start..."
sleep 10

# Check service status
SERVICE_STATUS=$($DOCKER_CMD ps --format "table {{.Name}}\t{{.Status}}")
echo "$SERVICE_STATUS"
echo ""

# Step 3: Wait for database to be ready
print_status "INFO" "Step 3: Waiting for database to be ready..."
MAX_WAIT=60
WAIT_COUNT=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if $DOCKER_CMD logs opencart_mariadb 2>/dev/null | grep -q "ready for connections"; then
        print_status "SUCCESS" "Database is ready"
        break
    fi
    echo -n "."
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

if [ $WAIT_COUNT -ge $MAX_WAIT ]; then
    print_status "ERROR" "Database didn't start within $MAX_WAIT seconds"
    echo "Check logs with: $DOCKER_CMD logs opencart_mariadb"
    exit 1
fi
echo ""

# Step 4: Check OpenCart accessibility
print_status "INFO" "Step 4: Checking OpenCart accessibility..."
sleep 5  # Give OpenCart a moment to start

MAX_WAIT=30
WAIT_COUNT=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if command -v curl >/dev/null 2>&1; then
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null || echo "000")
        if [ "$HTTP_STATUS" = "200" ]; then
            print_status "SUCCESS" "OpenCart is accessible"
            break
        fi
    fi
    echo -n "."
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done
echo ""

if [ "$HTTP_STATUS" != "200" ]; then
    print_status "WARNING" "OpenCart may not be fully ready yet"
    print_status "INFO" "Check logs with: $DOCKER_CMD logs opencart"
fi

# Step 5: Provide next steps
print_status "SUCCESS" "Setup complete!"
echo ""
echo "🌐 ACCESS YOUR OPENCART:"
echo "========================"
echo "Store:      http://localhost:8080/"
echo "Install:    http://localhost:8080/install  (for first-time setup)"
echo "Admin:      http://localhost:8080/admin    (after installation)"
echo ""
echo "Database Access (if needed):"
echo "Host:       localhost"
echo "Port:       3306"
echo "Database:   $(grep MARIADB_DATABASE .env | cut -d'=' -f2)"
echo "Username:   $(grep MARIADB_USER .env | cut -d'=' -f2)"
echo "Password:   $(grep MARIADB_PASSWORD .env | cut -d'=' -f2)"
echo ""
echo "📋 NEXT STEPS:"
echo "=============="
echo "1. Visit http://localhost:8080/"
echo "2. If you see the OpenCart installation wizard, complete it"
echo "3. If you see a store page, OpenCart is already set up"
echo "4. Access admin panel at http://localhost:8080/admin"
echo ""
echo "🔒 SECURITY REMINDERS:"
echo "======================"
echo "- After completing installation, remove the /install directory"
echo "- Use strong passwords in your .env file"
echo "- Never commit .env file to version control"
echo ""
echo "🛠️  USEFUL COMMANDS:"
echo "==================="
echo "View logs:         $DOCKER_CMD logs opencart"
echo "Restart services:  $DOCKER_CMD restart"
echo "Stop services:     $DOCKER_CMD down"
echo "View status:       $DOCKER_CMD ps"
echo ""
echo "✨ Happy OpenCart development!"