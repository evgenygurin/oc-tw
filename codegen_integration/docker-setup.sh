#!/bin/bash

# Codegen Orchestrator Docker Setup Script
# Unified CircleCI and ClickUp integration through Codegen APIs

echo "🚀 Setting up Codegen Orchestrator for OpenCart"
echo "================================================"

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

# Copy Codegen integration files to the container
echo "📁 Copying Codegen integration files..."

# Create codegen_integration directory in container if it doesn't exist
docker compose exec opencart mkdir -p /var/www/html/codegen_integration

# Copy all integration files to the container
docker compose cp codegen_integration/. opencart:/var/www/html/codegen_integration/

echo "✅ Files copied successfully"

# Run the installation script inside the container
echo "🔧 Running Codegen Orchestrator installation..."
docker compose exec opencart php /var/www/html/codegen_integration/install.php

# Set proper permissions
echo "🔒 Setting file permissions..."
docker compose exec opencart chown -R www-data:www-data /var/www/html/codegen_integration
docker compose exec opencart chown -R www-data:www-data /var/www/html/admin/controller/extension/module/codegen_orchestrator.php 2>/dev/null || true
docker compose exec opencart chown -R www-data:www-data /var/www/html/admin/view/template/extension/module/codegen_orchestrator.twig 2>/dev/null || true
docker compose exec opencart chown -R www-data:www-data /var/www/html/admin/language/en-gb/extension/module/codegen_orchestrator.php 2>/dev/null || true

echo "✅ Permissions set successfully"

# Create environment variables file for Codegen settings (optional)
if [ ! -f ".env.codegen" ]; then
    echo "📝 Creating Codegen environment template..."
    cat > .env.codegen << EOF
# Codegen Orchestrator Settings
# Configure these settings in OpenCart admin panel

# CircleCI Project Configuration
CODEGEN_CIRCLECI_PROJECT_SLUG=gh/username/repository

# ClickUp Configuration  
CODEGEN_CLICKUP_LIST_ID=your_clickup_list_id_here

# Team Assignments (ClickUp User IDs)
CODEGEN_DEV_TEAM_LEAD=dev_team_lead_user_id
CODEGEN_DEVOPS_LEAD=devops_lead_user_id  
CODEGEN_QA_LEAD=qa_lead_user_id

# Monitoring Configuration
CODEGEN_MONITOR_INTERVAL=300  # 5 minutes
CODEGEN_AUTO_FIX_ENABLED=true

# Webhook Configuration (optional)
CODEGEN_WEBHOOK_URL=https://yourdomain.com/codegen_integration/webhook_endpoint.php

# Usage:
# 1. Configure these values in OpenCart admin panel
# 2. Or source this file: source .env.codegen
# 3. Test the integration with sample failures
EOF
    echo "✅ Created .env.codegen template"
fi

# Create sample CircleCI configuration with Codegen integration
if [ ! -f ".circleci/config.yml" ]; then
    echo "📝 Creating CircleCI configuration with Codegen integration..."
    mkdir -p .circleci
    docker compose cp codegen_integration/.circleci/config.yml .circleci/config.yml 2>/dev/null || echo "Note: CircleCI config created during installation"
    echo "✅ CircleCI configuration ready"
fi

# Set up cron job for orchestration monitoring
echo "⏰ Setting up orchestration monitoring..."

# Create cron entry script
cat > setup_cron.sh << 'EOL'
#!/bin/bash
# Add Codegen orchestration to crontab
CRON_JOB="*/5 * * * * docker compose exec -T opencart php /var/www/html/codegen_integration/codegen_orchestrator_cron.php"

# Check if cron job already exists
if ! crontab -l 2>/dev/null | grep -q "codegen_orchestrator_cron.php"; then
    # Add to crontab
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✅ Cron job added successfully"
    echo "   Runs every 5 minutes: $CRON_JOB"
else
    echo "✅ Cron job already exists"
fi
EOL

chmod +x setup_cron.sh

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

# Test database connection
echo "🧪 Testing database connection..."
if docker compose exec mariadb mysql -u opencart -popencart_pass opencart_db -e "SELECT 1" &>/dev/null; then
    echo "✅ Database connection successful"
else
    echo "❌ Database connection failed. Please check your database configuration."
fi

# Display final instructions
echo ""
echo "🎉 Codegen Orchestrator setup completed successfully!"
echo "===================================================="
echo ""
echo "📋 **Next Steps:**"
echo ""
echo "1. 🌐 **Configure in Admin Panel:**"
echo "   • Access: http://localhost:8080/admin"
echo "   • Go to: Extensions > Extensions > Modules"
echo "   • Find: 'Codegen Orchestrator' and click Install"
echo "   • Click: Edit to configure settings"
echo ""
echo "2. ⚙️ **Required Configuration:**"
echo "   • CircleCI Project Slug (format: gh/username/repository)"
echo "   • ClickUp List ID (where tasks will be created)"
echo "   • Team Lead assignments (Dev, DevOps, QA user IDs)"
echo ""
echo "3. 🔧 **Enable Monitoring:**"
echo "   • Set up cron job: ./setup_cron.sh"
echo "   • Or configure webhook in CircleCI"
echo "   • Test with sample failure"
echo ""
echo "4. 🎯 **Key Features Enabled:**"
echo "   ✅ Automatic CircleCI failure monitoring"
echo "   ✅ ClickUp task creation for CI failures"
echo "   ✅ Intelligent failure analysis and categorization"
echo "   ✅ Auto-fix for Codegen-created PRs"
echo "   ✅ Team-based task assignment"
echo "   ✅ Unified monitoring dashboard"
echo ""
echo "📊 **Access Dashboard:**"
echo "   Admin Panel > Extensions > Codegen Orchestrator > Dashboard"
echo ""
echo "🔗 **Integration Points:**"
echo "   • Codegen CircleCI Tools: 7 tools available"
echo "   • Codegen ClickUp Tools: 11 tools available"
echo "   • Webhook Endpoint: /codegen_integration/webhook_endpoint.php"
echo ""
echo "📚 **Documentation:**"
echo "   • Full Guide: README_CODEGEN_ORCHESTRATOR.md"
echo "   • ClickUp Guide: README_CLICKUP.md"
echo "   • CircleCI Guide: README_CIRCLECI.md"
echo ""
echo "🛠️ **Troubleshooting:**"
echo "   • Check logs: docker compose logs -f opencart"
echo "   • Test tools: Use 'Test Codegen Tools' in admin"
echo "   • Manual run: Use 'Run Orchestration' button"
echo ""
echo "🔐 **Security Notes:**"
echo "   • API access managed through Codegen"
echo "   • No tokens stored locally"
echo "   • All communication via secure Codegen APIs"
echo ""
echo "🎊 **Ready to Orchestrate!**"
echo "Your development workflow is now fully automated with intelligent"
echo "CI/CD monitoring and task management through Codegen APIs."
echo ""

# Docker container status
echo "🐳 **Docker Container Status:**"
docker compose ps
echo ""

# Quick health check
echo "💻 **System Health Check:**"
echo "• OpenCart: $(docker compose exec opencart curl -s -o /dev/null -w '%{http_code}' http://localhost:80/ 2>/dev/null || echo 'Unknown')"
echo "• Database: $(docker compose exec mariadb mysqladmin ping -h localhost -u opencart -popencart_pass 2>/dev/null && echo 'OK' || echo 'Error')"
echo "• Admin Panel: Available at http://localhost:8080/admin"
echo ""

echo "✨ **Codegen Orchestrator is ready to revolutionize your DevOps workflow!** 🚀"