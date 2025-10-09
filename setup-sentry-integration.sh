#!/bin/bash

echo "🚀 Setting up Sentry MCP Server Integration for OpenCart"
echo "========================================================"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env and add your Sentry credentials!"
    echo ""
    echo "Get them from: https://sentry.io/settings/projects/"
    echo ""
    echo "Required values:"
    echo "  - SENTRY_DSN"
    echo "  - SENTRY_ORGANIZATION" 
    echo "  - SENTRY_PROJECT"
    echo "  - SENTRY_AUTH_TOKEN"
    echo ""
    echo "After updating .env, run this script again."
    exit 1
fi

# Check for placeholder values in .env
if grep -q "your_sentry_dsn_here\|YOUR_PUBLIC_KEY\|your-organization-slug\|your-project-slug\|YOUR_AUTH_TOKEN" .env; then
    echo "⚠️  Found placeholder values in .env!"
    echo ""
    echo "Please update these values with your actual Sentry credentials:"
    grep -E "SENTRY_" .env | grep -E "your|YOUR"
    echo ""
    echo "Get them from: https://sentry.io/settings/projects/"
    exit 1
fi

echo "✅ .env file configured"
echo ""

# Install Node dependencies if package.json exists
if [ -f package.json ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
    echo "✅ Node dependencies installed"
    echo ""
fi

# Setup MCP configuration
echo "⚙️  Setting up MCP Server configuration..."
mkdir -p .mcp
cat > .mcp/config.json << 'EOF'
{
  "mcpServers": {
    "sentry": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sentry"
      ],
      "env": {
        "SENTRY_ORG": "${SENTRY_ORGANIZATION}",
        "SENTRY_AUTH_TOKEN": "${SENTRY_AUTH_TOKEN}",
        "SENTRY_PROJECT": "${SENTRY_PROJECT}"
      }
    }
  }
}
EOF
echo "✅ MCP configuration created"
echo ""

# Make scripts executable
if [ -d scripts ]; then
    chmod +x scripts/*.js 2>/dev/null
    chmod +x scripts/*.php 2>/dev/null
fi

# Docker setup
echo "🐳 Setting up Docker environment..."
echo ""
echo "Next steps:"
echo "1. Rebuild Docker containers:"
echo "   docker compose down"
echo "   docker compose build --no-cache" 
echo "   docker compose up -d"
echo ""
echo "2. Install Composer dependencies (after containers are running):"
echo "   docker compose exec opencart composer install"
echo ""
echo "3. Run OpenCart setup script:"
echo "   docker compose exec opencart php scripts/setup-sentry-opencart.php"
echo ""
echo "4. Test the integration:"
echo "   - Visit: http://localhost:8080/test-sentry.php"
echo "   - Or run: npm run test-sentry"
echo ""
echo "5. Start MCP Server (for Codegen integration):"
echo "   npm run sentry-mcp"
echo ""
echo "📚 Full documentation: docs/SENTRY_MCP_INTEGRATION.md"
echo ""
echo "🎉 Setup script complete!"