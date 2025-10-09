# Sentry Integration Setup for OpenCart

## Prerequisites

1. Sentry account at https://sentry.io
2. Create a new project in Sentry for your OpenCart application

## Configuration Steps

### 1. Get Sentry Credentials

1. Log into your Sentry dashboard
2. Go to Settings → Projects → [Your Project]
3. Copy your DSN from "Client Keys (DSN)" section
4. Create an Auth Token:
   - Go to Settings → Account → API → Auth Tokens
   - Create a new token with these permissions:
     - `project:read`
     - `project:write`
     - `org:read`

### 2. Update .env File

Replace the placeholder values in your `.env` file:

```env
# Sentry Configuration
SENTRY_DSN=https://YOUR_PUBLIC_KEY@o0.ingest.sentry.io/PROJECT_ID
SENTRY_ORGANIZATION=your-org-slug
SENTRY_PROJECT=opencart-tw
SENTRY_AUTH_TOKEN=your-auth-token-here
SENTRY_ENVIRONMENT=development  # or production, staging
SENTRY_TRACES_SAMPLE_RATE=1.0  # 1.0 = 100% of transactions, 0.1 = 10%
```

### 3. Using MCP Server

The MCP Server configuration is already set up in `.mcp/config.json`. To use it:

1. Install the Codegen CLI (if not already installed)
2. Run the MCP server:
   ```bash
   npx -y @sentry/mcp-server
   ```

### 4. Testing Sentry Integration

1. Rebuild and restart Docker containers:
   ```bash
   docker compose down
   docker compose build --no-cache
   docker compose up -d
   ```

2. Create a test error in OpenCart:
   - Create a file `test-sentry.php` in the OpenCart root:
   ```php
   <?php
   require_once('config.php');
   require_once(DIR_SYSTEM . 'startup.php');
   
   if (file_exists(DIR_SYSTEM . '../vendor/autoload.php')) {
       require_once(DIR_SYSTEM . '../vendor/autoload.php');
       if (function_exists('initSentry')) {
           initSentry();
       }
   }
   
   // Test error
   throw new Exception('Test Sentry Error from OpenCart');
   ```

3. Access the test file:
   ```
   http://localhost:8080/test-sentry.php
   ```

4. Check your Sentry dashboard - you should see the error

### 5. Production Recommendations

1. **Sample Rate**: In production, reduce `SENTRY_TRACES_SAMPLE_RATE` to 0.1 or 0.2
2. **Environment**: Change `SENTRY_ENVIRONMENT` to `production`
3. **Performance Monitoring**: Enable performance monitoring in Sentry dashboard
4. **Release Tracking**: Configure releases for better error tracking:
   ```env
   SENTRY_RELEASE=opencart-tw@1.0.0
   ```

### 6. Troubleshooting

If errors aren't appearing in Sentry:

1. Check Docker logs:
   ```bash
   docker compose logs opencart
   ```

2. Verify environment variables are loaded:
   ```bash
   docker compose exec opencart printenv | grep SENTRY
   ```

3. Check if Composer dependencies are installed:
   ```bash
   docker compose exec opencart ls -la vendor/
   ```

4. Manually test Sentry connection:
   ```bash
   docker compose exec opencart php -r "
   require 'vendor/autoload.php';
   \Sentry\init(['dsn' => getenv('SENTRY_DSN')]);
   \Sentry\captureMessage('Test from CLI');
   echo 'Message sent to Sentry';
   "
   ```

## Features Implemented

- **Automatic Error Capture**: All PHP exceptions are automatically sent to Sentry
- **User Context**: Logged-in customer information is attached to errors
- **Sensitive Data Filtering**: Passwords and API keys are filtered out
- **Breadcrumbs**: Navigation trail for better debugging
- **Performance Monitoring**: Track slow transactions and database queries
- **Environment Separation**: Different configurations for dev/staging/production

## MCP Server Features

The Sentry MCP Server allows you to:
- Query and analyze errors directly from your development environment
- Create issues from errors
- Mark errors as resolved
- View error trends and statistics

To interact with MCP Server, use the Codegen CLI or compatible MCP client.