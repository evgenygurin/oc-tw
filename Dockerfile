FROM php:8.2-apache

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev libzip-dev \
    libfreetype6-dev libjpeg62-turbo-dev libicu-dev \
    unzip wget default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip intl opcache mbstring

# Enable Apache modules
RUN a2enmod rewrite headers

# Apache configuration
RUN echo '<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/opencart.conf && a2enconf opencart

# PHP configuration
RUN { \
    echo 'memory_limit = 256M'; \
    echo 'upload_max_filesize = 32M'; \
    echo 'post_max_size = 32M'; \
    echo 'max_execution_time = 300'; \
    echo 'display_errors = On'; \
    echo 'error_reporting = E_ALL'; \
    echo 'log_errors = On'; \
    echo 'date.timezone = UTC'; \
} > /usr/local/etc/php/conf.d/opencart.ini

# Download and extract OpenCart
RUN cd /tmp && \
    wget -q -O oc.zip https://github.com/opencart/opencart/archive/refs/heads/master.zip && \
    unzip -q oc.zip && \
    cp -r opencart-master/upload/* /var/www/html/ && \
    rm -rf oc.zip opencart-master

# Create storage directory
RUN mkdir -p /var/www/html/system/storage && \
    mkdir -p /var/www/html/image/cache /var/www/html/image/catalog

# Copy entrypoint script
COPY scripts/opencart-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/opencart-entrypoint.sh

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type d -exec chmod 755 {} \; && \
    find /var/www/html -type f -exec chmod 644 {} \;

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/opencart-entrypoint.sh"]
CMD ["apache2-foreground"]
