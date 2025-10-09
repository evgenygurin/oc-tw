#!/usr/bin/env bash
set -e

echo "=== OpenCart Local Setup (without Docker) ==="
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install PHP
echo "📦 Installing PHP 8.2..."
brew install php@8.2
brew link php@8.2 --force

# Install required PHP extensions
echo "📦 Installing PHP extensions..."
pecl install zip

# Install MySQL
echo "📦 Installing MySQL..."
brew install mysql
brew services start mysql

# Wait for MySQL to start
echo "⏳ Waiting for MySQL to start..."
sleep 5

# Create database and user
echo "🗄️  Setting up database..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS opencart_db;
CREATE USER IF NOT EXISTS 'opencart'@'localhost' IDENTIFIED BY 'opencart_pass';
GRANT ALL PRIVILEGES ON opencart_db.* TO 'opencart'@'localhost';
FLUSH PRIVILEGES;
EOF

# Configure OpenCart
echo "⚙️  Configuring OpenCart..."
if [ ! -f "config.php" ]; then
    cp config-dist.php config.php
fi

if [ ! -f "admin/config.php" ]; then
    cp admin/config-dist.php admin/config.php
fi

# Set permissions
echo "🔒 Setting permissions..."
chmod 755 config.php admin/config.php
chmod -R 755 system/storage
chmod -R 755 image

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Start PHP built-in server: php -S localhost:8080"
echo "2. Open: http://localhost:8080/install"
echo "3. Follow installation wizard with these credentials:"
echo "   - Database: opencart_db"
echo "   - Username: opencart"
echo "   - Password: opencart_pass"
echo "   - Hostname: localhost"
echo ""
