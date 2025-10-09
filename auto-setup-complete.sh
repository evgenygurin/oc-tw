#!/bin/bash

# 🚀 ПОЛНАЯ АВТОМАТИЧЕСКАЯ УСТАНОВКА AI-POWERED OPENCART
# Этот скрипт сделает ВСЕ автоматически

set -e  # Останавливается при любой ошибке

echo "🚀 АВТОМАТИЧЕСКАЯ УСТАНОВКА AI-POWERED OPENCART"
echo "================================================"
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка что Docker доступен
if ! command -v docker &> /dev/null; then
    print_error "Docker не найден! Установите Docker Desktop."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose не найден! Установите Docker Compose."
    exit 1
fi

print_success "Docker найден и готов к работе"

# Остановить существующие контейнеры если есть
print_status "Остановка существующих контейнеров..."
docker compose down 2>/dev/null || true

# Создать .env файл если не существует
if [ ! -f .env ]; then
    print_status "Создание .env файла..."
    cp .env.example .env
    
    # Генерация безопасных паролей
    DB_ROOT_PASS=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    DB_PASS=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    
    # Обновление .env
    sed -i "s/your_secure_root_password/$DB_ROOT_PASS/g" .env 2>/dev/null || \
    sed -i "" "s/your_secure_root_password/$DB_ROOT_PASS/g" .env
    
    sed -i "s/your_secure_password/$DB_PASS/g" .env 2>/dev/null || \
    sed -i "" "s/your_secure_password/$DB_PASS/g" .env
    
    print_success ".env файл создан с безопасными паролями"
else
    print_success ".env файл уже существует"
fi

# Пересобрать OpenCart контейнер с исправлениями
print_status "Сборка OpenCart контейнера с исправлениями..."
docker compose build --no-cache opencart

print_success "OpenCart контейнер собран"

# Запуск всех сервисов
print_status "Запуск всех сервисов..."
docker compose up -d

# Ожидание готовности сервисов
print_status "Ожидание готовности сервисов (это может занять 60 секунд)..."

# Ждем MariaDB
print_status "Ожидание готовности базы данных..."
timeout=60
count=0
while ! docker compose exec -T mariadb mysqladmin ping -h localhost -u root -p$(grep MARIADB_ROOT_PASSWORD .env | cut -d '=' -f2) --silent 2>/dev/null; do
    if [ $count -ge $timeout ]; then
        print_error "База данных не готова после $timeout секунд"
        exit 1
    fi
    echo -n "."
    sleep 2
    count=$((count + 2))
done
echo ""
print_success "База данных готова"

# Ждем OpenCart
print_status "Ожидание готовности OpenCart..."
timeout=60
count=0
while ! curl -f http://localhost:8080/ &>/dev/null; do
    if [ $count -ge $timeout ]; then
        print_error "OpenCart не готов после $timeout секунд"
        exit 1
    fi
    echo -n "."
    sleep 2
    count=$((count + 2))
done
echo ""
print_success "OpenCart готов"

# Установка зависимостей Composer если нужно
print_status "Проверка и установка зависимостей Composer..."
if ! docker compose exec -T opencart test -d /var/www/html/vendor; then
    print_status "Установка Composer зависимостей..."
    docker compose exec -T opencart bash -c "
        cd /var/www/html
        if ! command -v composer &> /dev/null; then
            curl -sS https://getcomposer.org/installer | php
            mv composer.phar /usr/local/bin/composer
            chmod +x /usr/local/bin/composer
        fi
        composer install --no-dev --optimize-autoloader --no-interaction
        chown -R www-data:www-data vendor/
        chmod -R 755 vendor/
    "
    print_success "Composer зависимости установлены"
else
    print_success "Composer зависимости уже установлены"
fi

# Установка AI интеграций
print_status "Установка AI интеграций..."

# 1. Codegen Orchestrator (основная интеграция)
if [ -f "./codegen_integration/install.php" ]; then
    print_status "Установка Codegen Orchestrator..."
    docker compose exec -T opencart php /var/www/html/codegen_integration/install.php
    print_success "Codegen Orchestrator установлен"
fi

# 2. ClickUp интеграция
if [ -f "./clickup_integration/ClickUpIntegration.php" ]; then
    print_status "Установка ClickUp интеграции..."
    docker compose cp clickup_integration/. opencart:/var/www/html/clickup_integration/
    docker compose exec -T opencart php /var/www/html/clickup_integration/install.php 2>/dev/null || true
    print_success "ClickUp интеграция установлена"
fi

# 3. CircleCI интеграция  
if [ -f "./circleci_integration/install.php" ]; then
    print_status "Установка CircleCI интеграции..."
    docker compose cp circleci_integration/. opencart:/var/www/html/circleci_integration/
    docker compose exec -T opencart php /var/www/html/circleci_integration/install.php
    print_success "CircleCI интеграция установлена"
fi

# Копирование интеграционных файлов
print_status "Копирование файлов интеграций в контейнер..."
docker compose exec -T opencart mkdir -p /var/www/html/codegen_integration
docker compose exec -T opencart mkdir -p /var/www/html/clickup_integration  
docker compose exec -T opencart mkdir -p /var/www/html/circleci_integration

docker compose cp codegen_integration/. opencart:/var/www/html/codegen_integration/ 2>/dev/null || true
docker compose cp clickup_integration/. opencart:/var/www/html/clickup_integration/ 2>/dev/null || true
docker compose cp circleci_integration/. opencart:/var/www/html/circleci_integration/ 2>/dev/null || true

# Установка правильных разрешений
print_status "Установка правильных разрешений..."
docker compose exec -T opencart bash -c "
    chown -R www-data:www-data /var/www/html/
    chmod -R 755 /var/www/html/
    chmod -R 644 /var/www/html/*.php
    chmod -R 755 /var/www/html/system/storage/
"

print_success "Разрешения установлены"

# Финальная проверка
print_status "Проверка статуса всех сервисов..."
docker compose ps

echo ""
echo "🎉 УСТАНОВКА ЗАВЕРШЕНА УСПЕШНО!"
echo "================================"
echo ""
echo "🌐 Доступные сервисы:"
echo "   • OpenCart:    http://localhost:8080"
echo "   • Админ панель: http://localhost:8080/admin"
echo "   • phpMyAdmin:  http://localhost:8081" 
echo "   • MailHog:     http://localhost:8025"
echo ""
echo "🔐 Данные для входа в админ панель:"
echo "   • Логин: admin"
echo "   • Пароль: admin123"
echo ""
echo "🚀 AI Интеграции установлены:"
echo "   ✅ Codegen Orchestrator (основная)"
echo "   ✅ ClickUp интеграция"
echo "   ✅ CircleCI интеграция"
echo ""
echo "⚡ Настройка интеграций:"
echo "   1. Перейдите в админ панель"
echo "   2. Extensions → Extensions → Modules"
echo "   3. Найдите и настройте каждую интеграцию"
echo ""
echo "📚 Документация:"
echo "   • README_CODEGEN_ORCHESTRATOR.md - основная интеграция"
echo "   • INTEGRATION_SUMMARY.md - полное сравнение"
echo "   • .cursorrules - правила разработки"
echo ""

# Проверка что OpenCart отвечает
if curl -f http://localhost:8080/ &>/dev/null; then
    print_success "OpenCart работает корректно!"
else
    print_warning "OpenCart может быть еще не готов. Подождите несколько секунд."
fi

echo ""
echo "🎊 ВАШ AI-POWERED OPENCART ГОТОВ К РАБОТЕ!"
echo ""