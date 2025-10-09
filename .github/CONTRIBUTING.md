# Contributing Guide

Спасибо за интерес к проекту **oc-tw**! Этот гайд поможет вам создать качественный Pull Request.

## 🚀 Quick Start

### 1. Форкните и склонируйте репозиторий

```bash
# Форк через GitHub UI, затем:
git clone https://github.com/YOUR_USERNAME/oc-tw.git
cd oc-tw

# Добавьте upstream
git remote add upstream https://github.com/evgenygurin/oc-tw.git
```

### 2. Создайте ветку для фичи

```bash
# Обновите main
git checkout main
git pull upstream main

# Создайте ветку по конвенции
git checkout -b feat/your-feature-name
# или
git checkout -b fix/bug-description
```

**Naming Convention:**
- `feat/` - новая функциональность
- `fix/` - исправление бага
- `refactor/` - рефакторинг без изменения поведения
- `style/` - UI/UX изменения
- `docs/` - только документация
- `chore/` - обновление зависимостей, конфигурации
- `perf/` - оптимизация производительности

### 3. Настройте окружение

```bash
# Скопируйте .env
cp .env.example .env
# Отредактируйте .env с вашими credentials

# Для Next.js
npm install

# Для OpenCart (Docker)
docker compose up -d
```

### 4. Делайте изменения

**Соблюдайте код-стайл:**
- Next.js: ESLint + Prettier
- PHP: PSR-12
- TypeScript: strict mode
- Line length: 88 символов

**Перед коммитом:**

```bash
# Next.js проверки
npm run lint
npm run build

# Docker проверки
docker compose ps  # Все сервисы должны быть healthy
```

### 5. Коммитьте по Conventional Commits

```bash
git add .
git commit -m "feat(auth): add OAuth2 Google integration"
```

**Формат:** `type(scope): description`

**Примеры:**
```bash
feat(opencart): add product comparison feature
fix(theme): resolve mobile menu overflow on iPhone
refactor(next): migrate pages to app router
style(ui): update checkout flow with shadcn dialog
perf(docker): optimize image size with multi-stage build
docs(setup): add M1 Mac troubleshooting section
chore(deps): update Next.js to 15.5.4
```

**Типы:**
- `feat` - новая фича
- `fix` - баг фикс
- `refactor` - рефакторинг
- `style` - UI изменения
- `perf` - производительность
- `docs` - документация
- `chore` - обслуживание, зависимости

**Scope (опционально):**
- `opencart` - OpenCart backend
- `theme` - oc-astro theme
- `next` - Next.js frontend
- `ui` - shadcn/ui компоненты
- `docker` - Docker конфигурация
- `auth` - аутентификация
- `api` - API endpoints

### 6. Пушьте и создавайте PR

```bash
git push origin feat/your-feature-name
```

Затем на GitHub:
1. Кликните "Compare & pull request"
2. Заполните PR template полностью
3. Убедитесь что все чекбоксы отмечены

## 📋 PR Template Checklist

Ваш PR **ДОЛЖЕН включать:**

### ✅ Description
- [ ] Краткое описание (2-3 предложения)
- [ ] **WHY** - причина изменений
- [ ] Ссылка на issue (если есть)

### ✅ Type Classification
- [ ] Выбран один тип (`feat`, `fix`, `refactor`, и т.д.)

### ✅ Testing Evidence
- [ ] Скриншоты для UI изменений
- [ ] Результаты тестов или шаги manual тестирования

### ✅ Affected Components
- [ ] Отмечены затронутые компоненты (OpenCart/Next.js/Docker/Theme/DB)

### ✅ Pre-submission Checklist
- [ ] Branch naming: `type/description`
- [ ] Commit messages: conventional format
- [ ] No secrets: `.env` excluded
- [ ] Dependencies updated
- [ ] `CLAUDE.md` updated (если архитектура изменилась)
- [ ] Backwards compatible
- [ ] Performance considered
- [ ] `npm run lint` passed
- [ ] `npm run build` successful
- [ ] `docker compose up -d` no errors
- [ ] All services healthy

## 🤖 Automated Checks

После создания PR автоматически запустятся проверки:

### 1. Next.js Code Quality
- ESLint без ошибок
- TypeScript без type errors
- Успешная сборка

### 2. Docker Services Health
- Все сервисы стартуют
- Healthchecks проходят
- Нет ошибок в логах

### 3. Security Vulnerabilities
- npm audit (moderate+)
- TruffleHog для secrets
- Dependency scanning

### 4. PR Template Validation
- Описание не менее 50 символов
- Наличие "WHY" объяснения
- Выбран тип изменения

### 5. Commit Message Validation
- Conventional commits формат
- Правильный type и scope

## ✨ Auto-merge Criteria

PR будет **автоматически смержен** если:

- ✅ Получен 1+ approval от reviewer
- ✅ Все automated checks прошли
- ✅ Нет merge conflicts
- ✅ Ветка up-to-date с main

## 🚫 PR будет заблокирован если:

- ❌ ESLint errors
- ❌ Docker build fails
- ❌ Security vulnerabilities
- ❌ Неполный PR template
- ❌ Нет описания

## 🔍 Review Process

### Что проверяют reviewers:

1. **Code Quality**
   - Следование архитектурным паттернам
   - Нет излишней сложности
   - Правильная обработка ошибок
   - Безопасность (SQL injection, XSS, CSRF)

2. **Performance**
   - Нет N+1 запросов
   - Оптимизированные изображения
   - Lazy loading где применимо
   - Эффективные database queries

3. **Testing**
   - Manual testing выполнен
   - Edge cases покрыты
   - Error scenarios обработаны

4. **Documentation**
   - Код понятен и читаем
   - Комплексная логика прокомментирована
   - `CLAUDE.md` актуален

## 🛠️ Local Development Tips

### Горячие команды

```bash
# Next.js development
npm run dev              # Dev server с Turbopack
npm run lint             # ESLint проверка
npm run build            # Production build
npm run start            # Production server

# Docker services
docker compose up -d     # Старт всех сервисов
docker compose logs -f opencart    # Логи OpenCart
docker compose restart opencart    # Рестарт после изменений
docker compose down -v   # Полная очистка

# Полезные проверки
fd "*.tsx" src/          # Найти все TSX файлы
rg "TODO" --type ts      # Найти все TODO в TypeScript
ast-grep --pattern 'function $NAME() { $$$ }'  # Найти функции
```

### Debugging

**Next.js:**
```bash
# В браузере
http://localhost:3000

# Логи в консоли
npm run dev
```

**OpenCart:**
```bash
# В браузере
http://localhost:8080

# Логи Docker
docker compose logs -f opencart

# PHP errors
docker compose exec opencart tail -f /var/www/html/system/storage/logs/error.log
```

**Database:**
```bash
# phpMyAdmin
http://localhost:8081

# MariaDB CLI
docker compose exec mariadb mysql -u bn_opencart -p bitnami_opencart
```

## 📚 Resources

- [CLAUDE.md](/CLAUDE.md) - Полная документация проекта
- [OpenCart Docs](https://docs.opencart.com/)
- [Next.js 15 Docs](https://nextjs.org/docs)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [shadcn/ui](https://ui.shadcn.com/)

## ❓ Getting Help

- **Issues**: [GitHub Issues](https://github.com/evgenygurin/oc-tw/issues)
- **Discussions**: [GitHub Discussions](https://github.com/evgenygurin/oc-tw/discussions)
- **Code Owner**: @evgenygurin

## 🎯 Good PR Examples

### Хороший PR ✅

```markdown
## Description

Add Google OAuth2 authentication for faster user signup.

**WHY:** Current email/password flow has 40% drop-off rate. OAuth2
reduces friction and improves conversion by 25% (based on A/B tests).

**Related Issue:** #123

## Type of Change

- [x] `feat:` New feature (OpenCart module, Next.js component)

## Testing Evidence

### Screenshots
![OAuth2 Flow](https://...)

### Test Results
- ✅ OAuth2 redirect works
- ✅ User profile auto-populated
- ✅ Session persists correctly

## Affected Components

- [x] Next.js frontend (React/TypeScript)
- [ ] OpenCart backend (PHP/Twig)

## Pre-submission Checklist

- [x] Branch named correctly: `feat/oauth2-google`
- [x] Commits follow conventional format
- [x] No secrets committed
- [x] `npm run lint` passed
- [x] `npm run build` successful
...
```

### Плохой PR ❌

```markdown
## Description

Added OAuth

## Type of Change

- [ ] ...

## Testing Evidence

Works on my machine
```

**Проблемы:**
- ❌ Нет объяснения WHY
- ❌ Неполное описание
- ❌ Нет type classification
- ❌ Нет доказательств тестирования
- ❌ Чеклист не заполнен

---

**Happy coding!** 🚀

При возникновении вопросов - создавайте issue или тегайте @evgenygurin
