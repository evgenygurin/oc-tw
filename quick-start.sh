#!/bin/bash

# 🚀 БЫСТРЫЙ ЗАПУСК (1 КОМАНДА)
echo "🚀 Запуск AI-powered OpenCart..."

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не найден! Установите Docker Desktop сначала."
    exit 1
fi

# Запуск полной установки
./auto-setup-complete.sh

echo ""
echo "✨ ГОТОВО! Откройте http://localhost:8080 в браузере"
