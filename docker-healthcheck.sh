#!/bin/bash

# Health check script for OpenCart
echo "🏥 Проверка здоровья сервисов..."

# Проверка OpenCart
if curl -f http://localhost:8080/ &>/dev/null; then
    echo "✅ OpenCart: Работает"
else
    echo "❌ OpenCart: Не отвечает"
fi

# Проверка базы данных
if docker compose exec -T mariadb mysqladmin ping -h localhost --silent 2>/dev/null; then
    echo "✅ MariaDB: Работает"  
else
    echo "❌ MariaDB: Не отвечает"
fi

# Проверка phpMyAdmin
if curl -f http://localhost:8081/ &>/dev/null; then
    echo "✅ phpMyAdmin: Работает"
else
    echo "❌ phpMyAdmin: Не отвечает" 
fi

# Проверка MailHog
if curl -f http://localhost:8025/ &>/dev/null; then
    echo "✅ MailHog: Работает"
else
    echo "❌ MailHog: Не отвечает"
fi

echo ""
echo "🐳 Статус контейнеров:"
docker compose ps