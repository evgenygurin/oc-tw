FROM php:8.2-apache

# Install required extensions and tools in a single layer for better caching
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    unzip \
    git \
    curl \
    wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    mysqli \
    pdo \
    pdo_mysql \
    gd \
    zip \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Download and install OpenCart in optimized steps
RUN curl -L https://github.com/opencart/opencart/releases/download/4.0.2.3/opencart-4.0.2.3.zip -o opencart.zip \
    && unzip -q opencart.zip \
    && cp -r opencart-4.0.2.3/upload/* /var/www/html/ \
    && rm -rf opencart.zip opencart-4.0.2.3

# Create temporary directory for project metadata (optional)
RUN mkdir -p /tmp/project-files

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create storage directory with correct permissions
RUN mkdir -p /var/www/html/system/storage \
    && chown -R www-data:www-data /var/www/html/system/storage \
    && chmod -R 755 /var/www/html/system/storage

EXPOSE 80

CMD ["apache2-foreground"]
