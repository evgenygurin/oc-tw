# GitHub Configuration for oc-tw

Эта директория содержит всю конфигурацию для автоматизации PR процесса в репозитории **oc-tw**.

## 📁 Структура файлов

```text
.github/
├── README.md                        # Этот файл - обзор конфигурации
├── AGENTS.md                        # Правила для Codegen AI agent
├── CODEOWNERS                       # Автоматическое назначение reviewers
├── CONTRIBUTING.md                  # Гайд для contributors
├── PR_EXAMPLE.md                    # Пример идеального PR
├── branch-protection.md             # Настройки защиты веток
├── pull_request_template.md        # Шаблон для новых PR
└── workflows/
    ├── pr-checks.yml               # Автоматические проверки PR
    └── auto-merge.yml              # Автоматический merge при соблюдении критериев
```

## 🚀 Quick Start

### Для Contributors

1. **Прочитайте** [CONTRIBUTING.md](CONTRIBUTING.md) - полный гайд по созданию PR
2. **Изучите** [PR_EXAMPLE.md](PR_EXAMPLE.md) - пример идеального PR
3. **Используйте** [pull_request_template.md](pull_request_template.md) - автоматически загружается при создании PR

### Для Maintainers

1. **Примените** настройки из [branch-protection.md](branch-protection.md)
2. **Проверьте** [CODEOWNERS](CODEOWNERS) - актуальны ли reviewers
3. **Настройте** Codegen используя [AGENTS.md](AGENTS.md)

## ⚙️ Применение Настроек

### Шаг 1: Branch Protection Rules (GitHub Web UI)

```bash
# Перейдите в репозиторий на GitHub:
https://github.com/evgenygurin/oc-tw/settings/branches

# Нажмите "Add rule" и примените настройки из:
cat .github/branch-protection.md
```

**Критичные настройки:**

- ✅ Require pull request reviews (1 approval)
- ✅ Require status checks to pass
  - Next.js Code Quality
  - Docker Services Health
  - Security Vulnerabilities
  - PR Template Validation
  - Commit Message Validation
- ✅ Require linear history
- ✅ Include administrators

### Шаг 2: Branch Protection Rules (через gh CLI)

```bash
# Установите gh CLI если ещё не установлен
brew install gh

# Авторизуйтесь
gh auth login

# Примените защиту для main ветки
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  /repos/evgenygurin/oc-tw/branches/main/protection \
  -f required_status_checks='{"strict":true,"contexts":["Next.js Code Quality","Docker Services Health","Security Vulnerabilities","PR Template Validation","Commit Message Validation"]}' \
  -f enforce_admins=true \
  -f required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  -f restrictions=null \
  -f required_linear_history=true \
  -f allow_force_pushes=false \
  -f allow_deletions=false
```

### Шаг 3: Codegen Integration

1. **Установите Codegen GitHub App:**
   - Перейдите на https://codegen.com
   - Connect GitHub Account
   - Select repository: `evgenygurin/oc-tw`

2. **Codegen автоматически обнаружит:**
   - `AGENTS.md` - правила для AI agent
   - `CLAUDE.md` - проектная документация
   - `.github/workflows/*.yml` - CI/CD пайплайны

3. **Настройте Codegen в веб-интерфейсе:**
   - Settings → Repo Rules → Upload `AGENTS.md`
   - Settings → PR Settings → Enable "Auto-review"
   - Settings → PR Settings → Enable "Auto-fix ESLint"

### Шаг 4: Проверка GitHub Actions Workflows

```bash
# Workflows уже закоммичены, проверьте что они активны:
gh workflow list

# Должны быть видны:
# - PR Quality Checks
# - Auto-merge PR

# Включите workflows если disabled:
gh workflow enable "PR Quality Checks"
gh workflow enable "Auto-merge PR"
```

### Шаг 5: Настройка Auto-merge

```bash
# В Settings → General → Pull Requests
# Включите следующие опции через веб-интерфейс:

✅ Allow squash merging
   - Default to pull request title and description
❌ Allow merge commits (disable для linear history)
❌ Allow rebase merging (disable для упрощения)
✅ Always suggest updating pull request branches
✅ Allow auto-merge
✅ Automatically delete head branches
```

## 📋 Checklist для Maintainers

После применения всех настроек, проверьте:

### Branch Protection

- [ ] Main branch защищена
- [ ] Require 1 approval включено
- [ ] All status checks configured (5 checks)
- [ ] Linear history enforced
- [ ] Force push disabled

### GitHub Actions

- [ ] `pr-checks.yml` workflow активен
- [ ] `auto-merge.yml` workflow активен
- [ ] Workflows успешно запускаются на test PR
- [ ] Secrets настроены (если нужны)

### Codegen Integration

- [ ] GitHub App установлено
- [ ] Repository подключён
- [ ] `AGENTS.md` распознан
- [ ] Auto-review включён
- [ ] Auto-fix включён

### CODEOWNERS

- [ ] Файл `CODEOWNERS` присутствует
- [ ] Reviewers корректно назначаются
- [ ] Team members добавлены (если есть команда)

### PR Template

- [ ] Template автоматически загружается при создании PR
- [ ] Все секции присутствуют
- [ ] Checklist функционален

## 🔍 Тестирование Конфигурации

### Создайте Test PR

```bash
# 1. Создайте test ветку
git checkout -b test/pr-automation-check

# 2. Сделайте простое изменение
echo "# Test PR Configuration" > TEST.md
git add TEST.md
git commit -m "test: verify PR automation setup"

# 3. Пуште и создайте PR
git push origin test/pr-automation-check
gh pr create --fill

# 4. Проверьте что произошло:
```

**Ожидаемые результаты:**

- ✅ PR template автоматически загрузился
- ✅ CODEOWNERS автоматически назначил reviewers
- ✅ GitHub Actions workflows запустились
- ✅ 5 status checks появились (в процессе)
- ✅ Codegen agent оставил review comment

### Проверка Auto-merge

```bash
# Если все checks прошли и есть approval:
# 1. Approve PR
gh pr review --approve

# 2. Auto-merge workflow должен:
# - Detect approval
# - Verify all checks passed
# - Automatically merge PR
# - Delete branch
# - Post comment
```

## 🛠️ Troubleshooting

### PR Checks не запускаются

```bash
# Проверьте workflow syntax
gh workflow view "PR Quality Checks"

# Посмотрите логи последнего запуска
gh run list --workflow="PR Quality Checks"
gh run view <run-id> --log

# Проверьте permissions
# Settings → Actions → General → Workflow permissions
# Должно быть: "Read and write permissions"
```

### Auto-merge не работает

**Возможные причины:**

1. **Auto-merge не включён:**
   - Settings → General → Pull Requests → Allow auto-merge ✅

2. **Branch protection требует approval:**
   - Убедитесь что PR approved
   - Проверьте `gh pr view <number> --json reviewDecision`

3. **Checks не прошли:**
   - Проверьте `gh pr checks <number>`
   - Все 5 checks должны быть green

4. **Branch не up-to-date:**
   - Update branch через UI или `gh pr merge --auto --squash`

### Codegen Agent не работает

```bash
# Проверьте что AGENTS.md распознан:
# 1. Зайдите в Codegen dashboard
# 2. Repository Settings → Repo Rules
# 3. Должен быть виден AGENTS.md

# Проверьте логи Codegen:
# Dashboard → Runs → Latest PR runs
```

## 📊 Метрики и Мониторинг

### Отслеживание эффективности PR процесса

```bash
# PR merge rate
gh pr list --state merged --json number,createdAt | jq length

# Average time to merge
gh pr list --state merged --limit 10 --json number,createdAt,mergedAt

# Failed checks анализ
gh run list --workflow="PR Quality Checks" --status failure
```

### Codegen Analytics

Проверяйте в Codegen Dashboard:

- **Review Coverage**: % PR проверенных агентом
- **Auto-fix Rate**: Сколько issues исправлено автоматически
- **Approval Rate**: % PR автоматически approved
- **Time Saved**: Оценка сэкономленного времени reviewers

## 🔄 Обновление Конфигурации

### При изменении workflow'ов

```bash
# После редактирования .github/workflows/*.yml
git add .github/workflows/
git commit -m "chore(ci): update PR checks workflow"
git push

# Workflow обновится автоматически на следующем PR
```

### При изменении AGENTS.md

```bash
# После редактирования AGENTS.md
git add .github/AGENTS.md
git commit -m "docs(agents): update AI review rules"
git push

# Codegen подхватит изменения в течение 5 минут
# Или принудительно: Codegen Dashboard → Sync Rules
```

### При изменении Branch Protection

```bash
# Через gh CLI (рекомендуется - версионируется)
gh api --method PUT /repos/evgenygurin/oc-tw/branches/main/protection \
  -f required_status_checks=@.github/branch-protection-config.json

# Или через веб UI (быстрее для одноразовых изменений)
https://github.com/evgenygurin/oc-tw/settings/branches
```

## 📚 Дополнительные Ресурсы

### Официальная Документация

- [GitHub Branch Protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Actions Workflows](https://docs.github.com/en/actions/using-workflows/about-workflows)
- [CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Codegen Documentation](https://docs.codegen.com)

### Проектная Документация

- [CLAUDE.md](/CLAUDE.md) - Основная документация проекта
- [CONTRIBUTING.md](.github/CONTRIBUTING.md) - Гайд для contributors
- [PR_EXAMPLE.md](.github/PR_EXAMPLE.md) - Пример PR

### Полезные Команды

```bash
# Проверка PR локально
gh pr checkout <number>
npm run lint
npm run build
docker compose up -d

# Review PR через CLI
gh pr review <number> --approve
gh pr review <number> --request-changes --body "Please fix..."
gh pr review <number> --comment --body "LGTM but minor suggestion..."

# Merge PR
gh pr merge <number> --squash --delete-branch

# Мониторинг Actions
gh run watch  # Follow текущий run
gh run list --limit 10  # Последние 10 runs
```

## ✅ Финальная Проверка

После применения всей конфигурации:

```bash
# 1. Создайте test PR (как описано выше)
# 2. Убедитесь что всё работает:

✅ PR template загружается автоматически
✅ CODEOWNERS назначает reviewers
✅ 5 GitHub Actions checks запускаются
✅ Codegen agent оставляет review
✅ При approval + green checks → auto-merge
✅ Branch удаляется после merge

# 3. Если всё OK, закройте test PR:
gh pr close <number> --delete-branch
```

## 🎯 Следующие Шаги

1. **Обучите команду:**
   - Проведите walkthrough по [CONTRIBUTING.md](.github/CONTRIBUTING.md)
   - Покажите [PR_EXAMPLE.md](.github/PR_EXAMPLE.md)
   - Объясните почему каждое правило важно

2. **Мониторьте и адаптируйте:**
   - Первые 2 недели: активно следите за PR процессом
   - Собирайте feedback от команды
   - Adjustайте rules в `AGENTS.md` при необходимости

3. **Оптимизируйте:**
   - Если checks слишком строгие → ослабьте
   - Если много false positives → уточните rules
   - Если auto-merge редко срабатывает → пересмотрите критерии

---

**Статус конфигурации:** ✅ Ready for Production

**Версия:** 1.0.0
**Последнее обновление:** 2025-01-08
**Maintainer:** @evgenygurin

_Эта конфигурация создаёт полностью автоматизированный PR процесс с AI-powered code review, automatic quality checks, и intelligent auto-merge. Enjoy your streamlined workflow! 🚀_
