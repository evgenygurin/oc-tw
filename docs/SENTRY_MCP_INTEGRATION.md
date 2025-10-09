# Sentry MCP Server Integration for OpenCart

This integration allows you to interact with Sentry through the Model Context Protocol (MCP) using Codegen.

## Quick Start

### 1. Configure Sentry Credentials

1. Sign up or log in to [Sentry.io](https://sentry.io)
2. Create a new project for your OpenCart application
3. Copy your credentials to `.env`:

```bash
# Copy from .env.example
cp .env.example .env

# Edit .env and add your Sentry credentials:
SENTRY_DSN=https://YOUR_PUBLIC_KEY@o0.ingest.sentry.io/PROJECT_ID
SENTRY_ORGANIZATION=your-org-slug
SENTRY_PROJECT=opencart-tw
SENTRY_AUTH_TOKEN=sntrys_YOUR_AUTH_TOKEN
```

### 2. Install Dependencies

```bash
# Install Node.js dependencies (for MCP Server)
npm install

# Install PHP dependencies (in Docker)
docker compose exec opencart composer install
```

### 3. Setup Sentry in OpenCart

```bash
# Run the setup script
docker compose exec opencart php scripts/setup-sentry-opencart.php

# Rebuild containers
docker compose down
docker compose build --no-cache
docker compose up -d
```

### 4. Start MCP Server

```bash
# Start Sentry MCP Server
npm run sentry-mcp

# Or test the connection
npm run test-sentry
```

## MCP Server Features

The Sentry MCP Server allows you to:

- **Query Errors**: Search and filter errors in your Sentry project
- **Manage Issues**: Mark issues as resolved, ignored, or assign to team members
- **View Statistics**: Get error trends and performance metrics
- **Create Alerts**: Set up alert rules for critical errors
- **Debug Information**: Access detailed error context and breadcrumbs

## Using with Codegen

Once the MCP Server is running, you can use Codegen to:

1. **View Recent Errors**:
   ```
   "Show me the recent errors in the OpenCart project"
   ```

2. **Analyze Error Patterns**:
   ```
   "What are the most common errors in the last 24 hours?"
   ```

3. **Resolve Issues**:
   ```
   "Mark the DatabaseConnection error as resolved"
   ```

4. **Get Error Details**:
   ```
   "Show me details about the latest 500 error"
   ```

## Configuration Files

### `.mcp/config.json`
Contains the MCP Server configuration for Codegen to connect to Sentry.

### `package.json`
Includes scripts for managing the Sentry MCP Server:
- `npm run setup-sentry`: Initial setup
- `npm run sentry-mcp`: Start MCP Server
- `npm run test-sentry`: Test the connection

### `system/helper/sentry.php`
PHP helper functions for Sentry integration:
- `initSentry()`: Initialize Sentry SDK
- `sentryException()`: Capture exceptions
- `sentryMessage()`: Log messages
- `sentryBreadcrumb()`: Add breadcrumbs

## Testing the Integration

1. **Test Page**: Visit `http://localhost:8080/test-sentry.php`
2. **Generate Test Error**: Uncomment the exception in the test file
3. **Check Sentry Dashboard**: Verify errors appear in your Sentry project

## Troubleshooting

### MCP Server not starting
- Check Node.js is installed: `node --version`
- Verify environment variables: `npm run test-sentry`
- Check MCP config: `cat .mcp/config.json`

### Errors not appearing in Sentry
- Verify DSN is correct in `.env`
- Check Docker logs: `docker compose logs opencart`
- Ensure Composer packages installed: `docker compose exec opencart ls vendor/`

### Permission Issues
- MCP config directory: `chmod 755 .mcp`
- Scripts executable: `chmod +x scripts/*.js`

## Security Best Practices

1. **Never commit `.env`**: It's in `.gitignore` for a reason
2. **Use Auth Tokens wisely**: Only grant necessary permissions
3. **Filter sensitive data**: The integration filters passwords and API keys
4. **Environment-specific config**: Use different DSNs for dev/staging/prod

## Additional Resources

- [Sentry Documentation](https://docs.sentry.io)
- [MCP Protocol Spec](https://modelcontextprotocol.org)
- [Codegen MCP Integrations](https://docs.codegen.com/integrations)