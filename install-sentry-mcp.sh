#!/bin/bash

# Install Sentry MCP Server for Codegen
echo "Installing Sentry MCP Server..."

# Create .codegen directory structure
mkdir -p ~/.codegen/servers/dist/sentry

# Install Sentry MCP server package
npm install -g @modelcontextprotocol/server-sentry

# Alternative: Install via npx for local development
echo "Setting up Sentry MCP Server..."

# Create a proper MCP configuration
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
        "SENTRY_PROJECT": "${SENTRY_PROJECT}",
        "NODE_ENV": "production"
      }
    }
  },
  "globalShortcut": "cmd+shift+g"
}
EOF

echo "Sentry MCP Server configuration created!"
echo ""
echo "Next steps:"
echo "1. Update your .env file with Sentry credentials:"
echo "   - SENTRY_ORGANIZATION=your-org-slug"
echo "   - SENTRY_AUTH_TOKEN=your-auth-token"
echo "   - SENTRY_PROJECT=your-project-slug"
echo "   - SENTRY_DSN=your-dsn"
echo ""
echo "2. Start the MCP server:"
echo "   npx -y @modelcontextprotocol/server-sentry"
echo ""
echo "3. Or use Codegen to interact with Sentry through MCP"