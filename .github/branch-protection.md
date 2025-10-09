# Branch Protection Rules

## Настройки для применения в GitHub Settings

Перейдите в **Settings → Branches → Add rule** и примените следующие настройки:

### Защита ветки `main`

#### Branch name pattern
```text
main
```

#### Protect matching branches

**Require a pull request before merging** ✅
- Require approvals: **1**
- Dismiss stale pull request approvals when new commits are pushed ✅
- Require review from Code Owners ❌ (если нет CODEOWNERS файла)

**Require status checks to pass before merging** ✅

Required status checks:
- `Next.js Code Quality`
- `Docker Services Health`
- `Security Vulnerabilities`
- `PR Template Validation`
- `Commit Message Validation`

Additional settings:
- Require branches to be up to date before merging ✅
- Require conversation resolution before merging ✅

**Require signed commits** ❌ (опционально, усложняет workflow)

**Require linear history** ✅ (использовать squash merge)

**Require deployments to succeed before merging** ❌

**Lock branch** ❌

**Do not allow bypassing the above settings** ✅

**Restrict who can push to matching branches** ❌ (или укажите конкретных пользователей/команды)

---

### Защита ветки `develop` (если используется)

#### Branch name pattern
```text
develop
```

#### Protect matching branches

Те же настройки, что для `main`, но:
- Require approvals: **1** (можно снизить до 0 для development)
- Require branches to be up to date: ✅

---

## Автоматическое применение через GitHub API

Если у вас есть Personal Access Token с правами `repo`, можно применить автоматически:

```bash
# Установить gh CLI
brew install gh

# Авторизоваться
gh auth login

# Применить защиту для main
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

---

## Настройки Auto-merge

### В Settings → General → Pull Requests

- ✅ Allow squash merging
  - Default to pull request title and description
- ❌ Allow merge commits (отключить для linear history)
- ❌ Allow rebase merging (отключить для упрощения)
- ✅ Always suggest updating pull request branches
- ✅ Allow auto-merge
- ✅ Automatically delete head branches

---

## Rulesets (новая функция GitHub)

Альтернативно можно использовать **Rulesets** (Settings → Rules → Rulesets):

### Create Ruleset: "Main Branch Protection"

**Target branches:** `main`

**Rules:**

1. **Require a pull request before merging**
   - Required approvals: 1
   - Dismiss stale reviews: ✅

2. **Require status checks to pass**
   - Status checks:
     - `Next.js Code Quality`
     - `Docker Services Health`
     - `Security Vulnerabilities`
     - `PR Template Validation`
     - `Commit Message Validation`
   - Require branches to be up to date: ✅

3. **Block force pushes** ✅

4. **Require linear history** ✅

5. **Require conversation resolution** ✅

**Bypass list:** (оставить пустым или добавить admin)

---

## Проверка настроек

После применения проверьте:

```bash
# Через gh CLI
gh api /repos/evgenygurin/oc-tw/branches/main/protection

# Или в браузере
https://github.com/evgenygurin/oc-tw/settings/branches
```

Должны быть видны:
- ✅ Require pull request reviews before merging (1 approval)
- ✅ Require status checks to pass before merging (5 checks)
- ✅ Require linear history
- ✅ Include administrators (enforce for admins)
