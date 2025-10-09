#!/bin/bash

# OpenCart Currency Fix Application Script
# This script applies the currency fix to the thumb.php controller

set -e

echo "=== OpenCart Currency Fix Application ==="
echo "This script will fix the 'Undefined array key currency' error"
echo ""

# Check if we're running inside the OpenCart container
if [ ! -f "/var/www/html/catalog/controller/product/thumb.php" ]; then
    echo "❌ Error: This script must be run inside the OpenCart container"
    echo "Run this command first: docker compose exec opencart bash"
    echo "Then execute this script inside the container"
    exit 1
fi

THUMB_FILE="/var/www/html/catalog/controller/product/thumb.php"
BACKUP_FILE="/var/www/html/catalog/controller/product/thumb.php.backup"

echo "📁 Target file: $THUMB_FILE"

# Create backup
if [ ! -f "$BACKUP_FILE" ]; then
    echo "💾 Creating backup..."
    cp "$THUMB_FILE" "$BACKUP_FILE"
    echo "✅ Backup created: $BACKUP_FILE"
else
    echo "ℹ️  Backup already exists: $BACKUP_FILE"
fi

# Check if fix is already applied
if grep -q "Currency fix: Ensure currency is always available" "$THUMB_FILE"; then
    echo "✅ Fix already applied to $THUMB_FILE"
    exit 0
fi

echo "🔧 Applying currency fix..."

# Create the fix code
cat > /tmp/currency_fix.txt << 'EOF'
        // Currency fix: Ensure currency is always available
        if (!isset($this->session->data['currency'])) {
            // Get default currency from configuration
            $default_currency = $this->config->get('config_currency');
            
            if ($default_currency) {
                $this->session->data['currency'] = $default_currency;
            } else {
                // Load currency model to get available currencies
                $this->load->model('localisation/currency');
                $currencies = $this->model_localisation_currency->getCurrencies();
                
                if (!empty($currencies)) {
                    // Set the first available currency
                    $currency_codes = array_keys($currencies);
                    $this->session->data['currency'] = $currency_codes[0];
                } else {
                    // Ultimate fallback to USD
                    $this->session->data['currency'] = 'USD';
                }
            }
        }

EOF

# Find the line number where we should insert the fix (before currency usage)
INSERT_LINE=$(grep -n "session->data\['currency'\]" "$THUMB_FILE" | head -1 | cut -d: -f1)

if [ -z "$INSERT_LINE" ]; then
    echo "❌ Error: Could not find currency usage in the file"
    echo "Please apply the fix manually"
    exit 1
fi

# Insert the fix before the problematic line
INSERT_LINE=$((INSERT_LINE - 1))

echo "📍 Inserting fix at line $INSERT_LINE"

# Create temporary file with the fix
head -n "$INSERT_LINE" "$THUMB_FILE" > /tmp/thumb_fixed.php
cat /tmp/currency_fix.txt >> /tmp/thumb_fixed.php
tail -n +$((INSERT_LINE + 1)) "$THUMB_FILE" >> /tmp/thumb_fixed.php

# Replace the original file
mv /tmp/thumb_fixed.php "$THUMB_FILE"

# Cleanup
rm -f /tmp/currency_fix.txt

echo "✅ Currency fix applied successfully!"
echo ""
echo "🔍 Verification:"
echo "- Original file backed up to: $BACKUP_FILE"
echo "- Fix applied to: $THUMB_FILE"
echo ""
echo "🧪 Next steps:"
echo "1. Test the product thumbnail functionality"
echo "2. Check error logs to ensure the issue is resolved"
echo "3. If issues persist, restore from backup: cp $BACKUP_FILE $THUMB_FILE"
echo ""
echo "✨ Fix complete!"