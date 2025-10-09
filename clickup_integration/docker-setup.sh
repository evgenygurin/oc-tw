#!/bin/bash

# ClickUp Integration Docker Setup Script
# This script sets up the ClickUp integration in the Docker environment

echo "🚀 Setting up ClickUp Integration for OpenCart Docker Environment"
echo "================================================================"

# Check if Docker is running
if ! docker compose ps | grep -q opencart; then
    echo "❌ Error: OpenCart Docker container is not running"
    echo "Please start the Docker environment first:"
    echo "  docker compose up -d"
    exit 1
fi

echo "✅ Docker environment is running"

# Wait for OpenCart to be fully ready
echo "⏳ Waiting for OpenCart to be ready..."
timeout=60
count=0
until docker compose exec opencart curl -f http://localhost:80/ &>/dev/null || [ $count -eq $timeout ]; do
    printf '.'
    sleep 1
    count=$((count+1))
done

if [ $count -eq $timeout ]; then
    echo "❌ Error: OpenCart is not responding after $timeout seconds"
    exit 1
fi

echo ""
echo "✅ OpenCart is ready"

# Copy ClickUp integration files to the container
echo "📁 Copying ClickUp integration files..."

# Create clickup_integration directory in container if it doesn't exist
docker compose exec opencart mkdir -p /var/www/html/clickup_integration

# Copy all integration files to the container
docker compose cp clickup_integration/. opencart:/var/www/html/clickup_integration/

echo "✅ Files copied successfully"

# Run the installation script inside the container
echo "🔧 Running installation script..."
docker compose exec opencart php /var/www/html/clickup_integration/install.php

# Set proper permissions
echo "🔒 Setting file permissions..."
docker compose exec opencart chown -R www-data:www-data /var/www/html/clickup_integration
docker compose exec opencart chown -R www-data:www-data /var/www/html/admin/controller/extension/module/clickup.php 2>/dev/null || true
docker compose exec opencart chown -R www-data:www-data /var/www/html/admin/view/template/extension/module/clickup.twig 2>/dev/null || true
docker compose exec opencart chown -R www-data:www-data /var/www/html/admin/language/en-gb/extension/module/clickup.php 2>/dev/null || true

echo "✅ Permissions set successfully"

# Create environment variables file for ClickUp settings (optional)
if [ ! -f ".env.clickup" ]; then
    echo "📝 Creating ClickUp environment template..."
    cat > .env.clickup << EOF
# ClickUp Integration Settings
# Copy your ClickUp API token here and source this file
CLICKUP_API_TOKEN=your_clickup_api_token_here
CLICKUP_WORKSPACE_ID=your_workspace_id_here
CLICKUP_DEFAULT_LIST_ID=your_default_list_id_here

# Usage:
# 1. Get your API token from https://app.clickup.com/settings/apps
# 2. Update the values above
# 3. Source this file: source .env.clickup
# 4. Configure in OpenCart admin panel
EOF
    echo "✅ Created .env.clickup template"
fi

# Check if OpenCart is properly configured
echo "🔍 Checking OpenCart configuration..."
if docker compose exec opencart test -f /var/www/html/config.php; then
    echo "✅ OpenCart config.php found"
else
    echo "⚠️  Warning: OpenCart config.php not found. Please complete OpenCart installation first."
fi

if docker compose exec opencart test -f /var/www/html/admin/config.php; then
    echo "✅ OpenCart admin config.php found"
else
    echo "⚠️  Warning: OpenCart admin config.php not found. Please complete OpenCart installation first."
fi

# Display final instructions
echo ""
echo "🎉 ClickUp Integration setup completed successfully!"
echo "================================================="
echo ""
echo "Next steps:"
echo "1. 🌐 Access your OpenCart admin panel: http://localhost:8080/admin"
echo "2. 🔧 Go to Extensions > Extensions > Modules"
echo "3. 🔍 Find 'ClickUp Integration' and click Install"
echo "4. ✏️  Click Edit to configure your ClickUp API token"
echo "5. 🔗 Get your API token from: https://app.clickup.com/settings/apps"
echo "6. ✅ Test the connection and configure your workspace"
echo "7. 🤖 Enable the automation features you want"
echo ""
echo "📚 For detailed configuration instructions, see README_CLICKUP.md"
echo ""
echo "🐳 Docker Container Status:"
docker compose ps
echo ""
echo "📊 You can monitor logs with:"
echo "  docker compose logs -f opencart"
echo ""
echo "🔧 To restart OpenCart after configuration:"
echo "  docker compose restart opencart"
echo ""

# Optional: Test database connection
echo "🧪 Testing database connection..."
if docker compose exec mariadb mysql -u opencart -popencart_pass opencart_db -e "SELECT 1" &>/dev/null; then
    echo "✅ Database connection successful"
else
    echo "❌ Database connection failed. Please check your database configuration."
fi

echo ""
echo "✨ Setup complete! Your OpenCart store is now ready for ClickUp integration."
echo "   Happy task managing! 🚀"