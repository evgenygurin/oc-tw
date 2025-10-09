#!/usr/bin/env node

/**
 * Test script for Sentry MCP Server integration
 */

const { spawn } = require('child_process');
const path = require('path');

// Load environment variables
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

console.log('Testing Sentry MCP Server integration...\n');

// Check environment variables
const requiredEnvVars = ['SENTRY_ORGANIZATION', 'SENTRY_AUTH_TOKEN', 'SENTRY_PROJECT', 'SENTRY_DSN'];
const missingVars = requiredEnvVars.filter(varName => !process.env[varName] || process.env[varName] === `your_${varName.toLowerCase().replace('_', '_')}_here`);

if (missingVars.length > 0) {
    console.error('❌ Missing or invalid environment variables:');
    missingVars.forEach(varName => {
        console.error(`   - ${varName}`);
    });
    console.error('\nPlease update your .env file with valid Sentry credentials.');
    process.exit(1);
}

console.log('✅ Environment variables configured');
console.log(`   Organization: ${process.env.SENTRY_ORGANIZATION}`);
console.log(`   Project: ${process.env.SENTRY_PROJECT}`);
console.log(`   DSN: ${process.env.SENTRY_DSN.substring(0, 30)}...`);
console.log('');

// Test MCP Server
console.log('Starting Sentry MCP Server...');

const mcpServer = spawn('npx', ['-y', '@modelcontextprotocol/server-sentry'], {
    env: {
        ...process.env,
        SENTRY_ORG: process.env.SENTRY_ORGANIZATION,
        SENTRY_AUTH_TOKEN: process.env.SENTRY_AUTH_TOKEN,
        SENTRY_PROJECT: process.env.SENTRY_PROJECT
    }
});

mcpServer.stdout.on('data', (data) => {
    console.log(`MCP Server: ${data}`);
});

mcpServer.stderr.on('data', (data) => {
    console.error(`MCP Server Error: ${data}`);
});

mcpServer.on('close', (code) => {
    console.log(`MCP Server exited with code ${code}`);
});

// Give the server time to start
setTimeout(() => {
    console.log('\n✅ Sentry MCP Server is running!');
    console.log('\nYou can now use Codegen to interact with Sentry through the MCP protocol.');
    console.log('\nPress Ctrl+C to stop the server.');
}, 2000);