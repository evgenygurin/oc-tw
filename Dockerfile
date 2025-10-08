FROM php:8.2-apache

WORKDIR /var/www/html

# Install dependencies including netcat for wait script
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev libzip-dev \
    libfreetype6-dev libjpeg62-turbo-dev libicu-dev \
    unzip wget default-mysql-client netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl opcache mbstring

# Enable Apache modules
RUN a2enmod rewrite headers

# Apache config
RUN echo '<Directory /var/www/html>\n    Options Indexes FollowSymLinks\n    AllowOverride All\n    Require all granted\n</Directory>' > /etc/apache2/conf-available/opencart.conf && a2enconf opencart

# PHP config
RUN { echo 'memory_limit = 256M'; echo 'upload_max_filesize = 32M'; echo 'post_max_size = 32M'; echo 'max_execution_time = 300'; echo 'display_errors = On'; echo 'error_reporting = E_ALL'; echo 'log_errors = On'; echo 'date.timezone = UTC'; } > /usr/local/etc/php/conf.d/opencart.ini

# Create wait-for-it script
RUN echo '#!/bin/bash\nset -e\nhost="$1"\nshift\ntimeout="${1:-60}"\nwhile ! nc -z "$host" 3306 2>/dev/null; do\n  echo "MySQL unavailable - sleeping"\n  sleep 1\n  timeout=$((timeout - 1))\n  if [ "$timeout" -le 0 ]; then\n    echo "Timeout!"\n    exit 1\n  fi\ndone\necho "MySQL is up!"' > /usr/local/bin/wait-for-it && chmod +x /usr/local/bin/wait-for-it

# Download OpenCart from GitHub master branch
RUN cd /tmp && wget -q -O oc.zip https://github.com/opencart/opencart/archive/refs/heads/master.zip && unzip -q oc.zip && cp -r opencart-master/upload/* /var/www/html/ && rm -rf oc.zip opencart-master

# Permissions
RUN chown -R www-data:www-data /var/www/html && find /var/www/html -type d -exec chmod 755 {} \; && find /var/www/html -type f -exec chmod 644 {} \;

# Create directories
RUN mkdir -p /var/www/html/image/cache /var/www/html/image/catalog /var/www/storage_data && chown -R www-data:www-data /var/www/html /var/www/storage_data

EXPOSE 80
CMD ["apache2-foreground"]
