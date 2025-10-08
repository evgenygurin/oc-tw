#!/bin/bash
set -e

echo "🚀 OpenCart entrypoint starting..."

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
until mysqladmin ping -h mysql --silent 2>/dev/null; do
    echo "   MySQL not ready, waiting..."
    sleep 2
done
echo "✅ MySQL is ready!"

# Check if OpenCart is already installed
if [ ! -f "/var/www/html/config.php" ] || [ ! -f "/var/www/html/admin/config.php" ]; then
    echo "📦 Installing OpenCart..."
    
    # Create config files from dist
    cp /var/www/html/config-dist.php /var/www/html/config.php 2>/dev/null || true
    cp /var/www/html/admin/config-dist.php /var/www/html/admin/config.php 2>/dev/null || true
    
    # Run CLI installer
    php /var/www/html/install/cli_install.php install \
        --db_hostname mysql \
        --db_username "${MYSQL_USER}" \
        --db_password "${MYSQL_PASSWORD}" \
        --db_database "${MYSQL_DATABASE}" \
        --db_driver mysqli \
        --db_port 3306 \
        --db_prefix oc_ \
        --username "${OPENCART_ADMIN_USERNAME}" \
        --password "${OPENCART_ADMIN_PASSWORD}" \
        --email "${OPENCART_ADMIN_EMAIL}" \
        --http_server "${OPENCART_HTTP_SERVER}"
    
    echo "✅ OpenCart installed successfully!"
    
    # Remove install directory for security
    rm -rf /var/www/html/install
    echo "🗑️  Install directory removed"
else
    echo "✅ OpenCart already installed"
fi

# Fix permissions
chown -R www-data:www-data /var/www/html
echo "✅ Permissions set"

echo "🎉 OpenCart is ready!"
echo "📍 Access at: ${OPENCART_HTTP_SERVER}"
echo "👤 Admin: ${OPENCART_ADMIN_USERNAME} / ${OPENCART_ADMIN_PASSWORD}"

# Execute the main command
exec "$@"
