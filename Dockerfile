FROM php:8.2-apache

# Install required extensions and tools
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    gd \
    zip \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy OpenCart files
COPY . /var/www/html/

# Install Composer dependencies
RUN if [ -f composer.json ]; then \
        composer install --no-dev --optimize-autoloader; \
    fi

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create storage directory with correct permissions
RUN mkdir -p /var/www/html/system/storage \
    && chown -R www-data:www-data /var/www/html/system/storage \
    && chmod -R 755 /var/www/html/system/storage

EXPOSE 80

CMD ["apache2-foreground"]
