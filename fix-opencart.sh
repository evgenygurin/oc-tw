#!/bin/bash

echo "🔧 Fixing OpenCart vendor dependencies..."

# Stop services
echo "Stopping services..."
docker compose down

# Clean up any existing vendor issues
echo "Cleaning up..."
docker compose build --no-cache opencart

# Start services
echo "Starting services..."
docker compose up -d

# Wait for MariaDB to be ready
echo "Waiting for database..."
sleep 20

# Install dependencies in container
echo "Installing Composer dependencies..."
docker compose exec opencart bash -c "
cd /var/www/html
curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev --optimize-autoloader
chown -R www-data:www-data .
chmod -R 755 vendor/
"

echo "✅ OpenCart should now be ready!"
echo "🌐 Access: http://localhost:8080"
echo "📋 Admin: http://localhost:8080/admin"

# Check status
docker compose ps
