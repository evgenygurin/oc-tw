#!/bin/bash

# OpenCart Installation Diagnostics
# This script helps determine the current state of your OpenCart installation

set -e

echo "🔍 OpenCart Installation Diagnostics"
echo "====================================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if .env file exists
print_status "INFO" "Checking environment configuration..."
if [ -f ".env" ]; then
    print_status "SUCCESS" ".env file found"
    echo "   Database: $(grep MARIADB_DATABASE .env | cut -d'=' -f2)"
    echo "   User: $(grep MARIADB_USER .env | cut -d'=' -f2)"
else
    print_status "WARNING" ".env file not found - need to create from .env.example"
    echo ""
    echo "   Quick fix: cp .env.example .env"
    echo "   Then edit .env with your secure credentials"
fi
echo ""

# Check if docker-compose.yml exists
print_status "INFO" "Checking Docker configuration..."
if [ -f "docker-compose.yml" ]; then
    print_status "SUCCESS" "docker-compose.yml found"
else
    print_status "ERROR" "docker-compose.yml not found - this is required"
fi
echo ""

# Check if Docker/Docker Compose is available
print_status "INFO" "Checking Docker availability..."
if command -v docker-compose >/dev/null 2>&1; then
    print_status "SUCCESS" "docker-compose is available"
    DOCKER_CMD="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    print_status "SUCCESS" "docker compose (plugin) is available"
    DOCKER_CMD="docker compose"
else
    print_status "ERROR" "Docker/Docker Compose not found"
    echo "   Please install Docker and Docker Compose first"
    exit 1
fi
echo ""

# Check Docker services status
print_status "INFO" "Checking Docker services..."
if $DOCKER_CMD ps >/dev/null 2>&1; then
    SERVICE_STATUS=$($DOCKER_CMD ps --format "table {{.Name}}\t{{.Status}}" 2>/dev/null || echo "No services running")
    
    if echo "$SERVICE_STATUS" | grep -q "opencart_app"; then
        if echo "$SERVICE_STATUS" | grep "opencart_app" | grep -q "Up"; then
            print_status "SUCCESS" "OpenCart container is running"
        else
            print_status "ERROR" "OpenCart container is not healthy"
        fi
    else
        print_status "WARNING" "OpenCart container not found - may need to start services"
    fi
    
    if echo "$SERVICE_STATUS" | grep -q "opencart_mariadb"; then
        if echo "$SERVICE_STATUS" | grep "opencart_mariadb" | grep -q "Up"; then
            print_status "SUCCESS" "Database container is running"
        else
            print_status "ERROR" "Database container is not healthy"
        fi
    else
        print_status "WARNING" "Database container not found - may need to start services"
    fi
    
    echo ""
    echo "Current services:"
    echo "$SERVICE_STATUS"
else
    print_status "WARNING" "No Docker services are currently running"
fi
echo ""

# Check OpenCart accessibility
print_status "INFO" "Checking OpenCart accessibility..."
if command -v curl >/dev/null 2>&1; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ 2>/dev/null || echo "000")
    
    case $HTTP_STATUS in
        "200") 
            print_status "SUCCESS" "OpenCart is accessible at http://localhost:8080/"
            # Check if it's the install page or actual store
            if curl -s http://localhost:8080/ | grep -q "OpenCart" || curl -s http://localhost:8080/ | grep -q "installation"; then
                if curl -s http://localhost:8080/ | grep -q "Installation"; then
                    print_status "INFO" "OpenCart installation wizard is active"
                else
                    print_status "SUCCESS" "OpenCart store is running"
                fi
            fi
            ;;
        "000")
            print_status "ERROR" "Cannot connect to localhost:8080 - services may be down"
            ;;
        *)
            print_status "WARNING" "HTTP status: $HTTP_STATUS - may indicate an issue"
            ;;
    esac
else
    print_status "WARNING" "curl not available - cannot test HTTP connectivity"
fi
echo ""

# Summary and recommendations
echo "🎯 RECOMMENDATIONS:"
echo "==================="

if [ ! -f ".env" ]; then
    echo "1. Create environment file: cp .env.example .env"
    echo "2. Edit .env with secure credentials"
fi

if ! $DOCKER_CMD ps | grep -q "Up.*opencart"; then
    echo "3. Start Docker services: $DOCKER_CMD up -d"
fi

if [ "$HTTP_STATUS" = "200" ]; then
    echo "4. Your OpenCart is accessible at: http://localhost:8080/"
    echo "5. Admin panel should be at: http://localhost:8080/admin"
    echo ""
    print_status "SUCCESS" "OpenCart appears to be working correctly!"
    echo ""
    echo "🔒 SECURITY REMINDER:"
    echo "   - Remove /install directory after setup completion"
    echo "   - Only access upgrade URLs when actually upgrading"
    echo "   - Always backup before making changes"
else
    echo "4. Check the troubleshooting guide in opencart-upgrade-guide.md"
fi

echo ""
echo "📋 NEXT STEPS based on your needs:"
echo ""
echo "🆕 First-time setup:"
echo "   - Go to http://localhost:8080/install (not the upgrade URL)"
echo "   - Complete the installation wizard"
echo "   - Remove install directory after completion"
echo ""
echo "🔄 Existing installation:"
echo "   - Access your store at http://localhost:8080/"
echo "   - Admin panel at http://localhost:8080/admin"
echo "   - Only use upgrade URLs during actual upgrades"
echo ""
echo "✨ Done! Check the recommendations above for next steps."