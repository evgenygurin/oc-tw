#!/usr/bin/env bash
set -euo pipefail

APACHE_CMD="apache2-foreground"
WEBROOT="/var/www/html"
SYSTEM_DIR="$WEBROOT/system"
DEFAULT_STORAGE_DIR="$SYSTEM_DIR/storage"

# Detect storage dir from config.php if possible; fallback to default
resolve_storage_dir() {
  local cfg="$WEBROOT/config.php"
  if [[ -f "$cfg" ]]; then
    # Try to parse DIR_STORAGE from config.php (simple grep/awk to avoid php execution)
    local line
    line=$(grep -E "define\('\s*DIR_STORAGE\s*'" "$cfg" || true)
    if [[ -n "$line" ]]; then
      # Extract the path between the second comma and closing parenthesis
      # define('DIR_STORAGE', '/var/www/storage/');
      local path
      path=$(echo "$line" | sed -E "s/.*define\('\s*DIR_STORAGE\s*',\s*'([^']+)'\).*/\1/")
      if [[ -n "$path" ]]; then
        echo "$path"
        return 0
      fi
    fi
  fi
  echo "$DEFAULT_STORAGE_DIR"
}

ensure_composer() {
  if command -v composer >/dev/null 2>&1; then
    return 0
  fi
  # Install a local composer to /usr/local/bin/composer using PHP only
  echo "Installing Composer..."
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer --quiet
  rm -f composer-setup.php
}

install_opencart_vendor() {
  local storage_dir="$1"
  local storage_vendor_dir="$storage_dir/vendor"
  local aws_functions="$storage_vendor_dir/aws/aws-sdk-php/src/functions.php"

  # Only proceed if OpenCart core is present
  if [[ ! -f "$SYSTEM_DIR/vendor.php" ]]; then
    echo "OpenCart system/vendor.php not found. Skipping vendor install."
    return 0
  fi

  # Create storage and vendor directories if needed
  mkdir -p "$storage_vendor_dir"
  chown -R www-data:www-data "$storage_dir"

  if [[ -f "$aws_functions" ]]; then
    echo "OpenCart vendor deps already present in $storage_vendor_dir"
    return 0
  fi

  echo "Installing OpenCart vendor deps into $storage_vendor_dir..."

  ensure_composer

  pushd "$storage_dir" >/dev/null
    # Initialize a minimal composer project in storage dir if none exists
    if [[ ! -f composer.json ]]; then
      composer init --no-interaction \
        --name="opencart/storage-deps" \
        --description="OpenCart storage vendor dependencies" \
        --quiet || true
    fi

    # Prefer dist and optimize autoloader
    composer config prefer-dist true || true
    composer config optimize-autoloader true || true

    # Require the key packages expected by system/vendor.php
    # aws/aws-sdk-php will pull guzzle, promises, psr7, jmespath, psr interfaces, etc.
    # Also include twig and scssphp which are required by vendor.php
    composer require \\
      aws/aws-sdk-php:^3 \
      aws/aws-crt-php:^1 \
      twig/twig:^3 \
      scssphp/scssphp:^1 \
      symfony/polyfill-ctype:^1 \
      symfony/polyfill-mbstring:^1 \
      --no-progress --no-ansi --no-interaction
  popd >/dev/null

  # Ensure correct permissions for Apache
  chown -R www-data:www-data "$storage_vendor_dir"
}

main() {
  # If webroot is an empty mounted volume, do nothing (user might not have installed OpenCart yet)
  if [[ ! -d "$WEBROOT" ]]; then
    echo "$WEBROOT does not exist. Creating..."
    mkdir -p "$WEBROOT"
    chown -R www-data:www-data "$WEBROOT"
  fi

  local storage_dir
  storage_dir=$(resolve_storage_dir)

  # Normalize potential relative paths
  if [[ ! "$storage_dir" = /* ]]; then
    storage_dir="$WEBROOT/$storage_dir"
  fi

  # Attempt to install vendor deps if OpenCart is present
  if [[ -d "$SYSTEM_DIR" ]]; then
    install_opencart_vendor "$storage_dir" || true
  fi

  echo "Starting Apache..."
  exec "$APACHE_CMD"
}

main "$@"
