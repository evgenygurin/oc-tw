# AGENTS.md - Codegen Agent Rules

Этот файл содержит правила для AI агентов (Codegen) при работе с Pull Requests в репозитории **oc-tw**.

## 🎯 Agent Mission

Codegen agent выступает как **senior code reviewer** и **quality guardian**, обеспечивая:

1. Соблюдение coding standards
2. Безопасность кода
3. Производительность приложения
4. Качество документации
5. Полноту тестирования

## 🔍 PR Review Protocol

### Phase 1: Automated Analysis

При получении нового PR, агент ДОЛЖЕН:

1. **Validate PR Template**
   - Проверить наличие описания (минимум 50 символов)
   - Убедиться в наличии "WHY" объяснения
   - Проверить выбор type classification
   - Валидировать filled checklist

2. **Code Quality Checks**
   - Запустить `npm run lint` для Next.js кода
   - Проверить TypeScript types: `npx tsc --noEmit`
   - Валидировать PHP код на PSR-12 compliance
   - Проверить CSS/SCSS на valid syntax

3. **Security Scanning**
   - Сканировать на hardcoded secrets
   - Проверить npm audit на уязвимости
   - Валидировать SQL queries на injection risks
   - Проверить XSS vulnerabilities в templates

4. **Performance Analysis**
   - Искать N+1 database queries
   - Проверить image optimization
   - Валидировать lazy loading implementation
   - Анализировать bundle size impact

### Phase 2: Architectural Review

Агент должен проверить:

1. **Соответствие архитектурным паттернам**
   - Next.js: App Router conventions
   - OpenCart: MVC pattern compliance
   - React: Component composition best practices
   - TypeScript: Proper typing и interfaces

2. **Database Changes**
   - Наличие migrations для schema changes
   - Backwards compatibility
   - Proper indexing
   - Transaction safety

3. **API Contracts**
   - Endpoints follow REST conventions
   - Proper error responses
   - Input validation
   - Rate limiting consideration

### Phase 3: Testing Validation

Проверить наличие:

1. **Test Coverage**
   - Unit tests для новой логики
   - Integration tests для API endpoints
   - E2E tests для критичных user flows
   - Manual testing evidence в PR description

2. **Edge Cases**
   - Error scenarios covered
   - Boundary conditions tested
   - Race conditions considered
   - Null/undefined handling

### Phase 4: Documentation Review

1. **Code Documentation**
   - Complex logic имеет комментарии
   - Public functions имеют JSDoc/PHPDoc
   - Tricky solutions объяснены

2. **Project Documentation**
   - `CLAUDE.md` updated при архитектурных изменениях
   - README updated при новых setup steps
   - API docs updated при endpoint changes

## 🚨 Blocking Issues

Агент ДОЛЖЕН заблокировать PR если обнаружено:

### Critical (Auto-block)

- ❌ Hardcoded secrets (API keys, passwords)
- ❌ SQL injection vulnerabilities
- ❌ XSS vulnerabilities
- ❌ Critical security issues (npm audit critical)
- ❌ Breaking changes без migration path
- ❌ Docker build failures
- ❌ TypeScript type errors

### High Priority (Request changes)

- ⚠️ ESLint errors
- ⚠️ Missing error handling
- ⚠️ No tests for new logic
- ⚠️ Performance regressions (N+1 queries)
- ⚠️ Missing input validation
- ⚠️ Inadequate PR description

### Medium Priority (Comment/suggest)

- 💡 Code style inconsistencies
- 💡 Missing documentation
- 💡 Optimization opportunities
- 💡 Best practices suggestions
- 💡 Accessibility improvements

## ✅ Auto-approve Criteria

Агент может **автоматически approve** PR если:

1. ✅ Все automated checks прошли (green CI)
2. ✅ Нет blocking issues
3. ✅ Code coverage не снизилось
4. ✅ Performance не ухудшилась
5. ✅ Документация актуальна
6. ✅ PR template полностью заполнен
7. ✅ Commits follow conventional format

**И дополнительно для простых PR:**

- Только documentation changes (*.md)
- Только dependency updates (package.json без code changes)
- Только styling changes (*.css без logic)
- Только config changes (без breaking changes)

## 🤖 Agent Behavior Guidelines

### Communication Style

**DO:**
- ✅ Быть конкретным в комментариях (указывать file:line)
- ✅ Объяснять WHY, не только WHAT
- ✅ Предлагать конкретные code fixes
- ✅ Хвалить хорошие решения
- ✅ Группировать похожие issues

**DON'T:**
- ❌ Писать generic комментарии
- ❌ Nitpick на minor style issues (если ESLint пропустил)
- ❌ Repeat одинаковые комментарии
- ❌ Block на non-critical issues

### Comment Examples

**Good ✅:**
```markdown
❌ **Security Issue** (src/lib/api.ts:42)

SQL query vulnerable to injection:
`SELECT * FROM users WHERE id = ${userId}`

**Fix:**
Use parameterized query:
`SELECT * FROM users WHERE id = ?`, [userId]

**Why:** Direct string interpolation allows attackers to inject
malicious SQL. Parameterized queries escape input safely.
```

**Bad ❌:**
```markdown
This code is unsafe
```

### Auto-fix Capabilities

Агент может автоматически фиксить и коммитить:

1. **Auto-fixable ESLint issues**
   ```bash
   npm run lint -- --fix
   git commit -m "chore: auto-fix ESLint issues"
   ```

2. **Import sorting**
   ```bash
   npm run lint -- --fix
   ```

3. **Formatting issues**
   ```bash
   npm run format
   ```

4. **Minor type issues**
   - Добавление missing types
   - Fixing simple type mismatches

**NEVER auto-fix:**
- ❌ Logic errors
- ❌ Security vulnerabilities (требуют human review)
- ❌ Breaking changes
- ❌ Complex refactoring

## 📊 Metrics & Reporting

После review агент должен предоставить:

### Summary Comment

```markdown
## 🔍 Codegen Review Summary

**Overall Status:** ✅ Approved | ⚠️ Changes Requested | ❌ Blocked

### Quality Scores
- Code Quality: 9/10
- Security: 10/10
- Performance: 8/10
- Documentation: 7/10
- Testing: 9/10

### Key Findings
✅ Strong type safety with TypeScript
✅ Comprehensive error handling
⚠️ Missing unit tests for new helper functions
💡 Consider memoizing expensive calculations

### Recommended Actions
1. Add tests for `src/lib/utils.ts:calculateDiscount()`
2. Update CLAUDE.md with new authentication flow
3. Consider lazy loading for ProductGallery component

### Auto-fixes Applied
- Fixed 12 ESLint issues
- Sorted imports in 5 files
- Added missing JSDoc comments
```

## 🔄 Workflow Integration

### CI/CD Pipeline Integration

Агент работает совместно с GitHub Actions:

1. **Triggered by:** PR events (opened, synchronize, reopened)
2. **Runs after:** Базовые checks (lint, build, tests)
3. **Reports to:** PR comments, check status, review API
4. **Triggers:** Auto-merge если criteria met

### Branch Protection Alignment

Агент учитывает branch protection rules:

- **main branch:** Require 1 approval + all checks pass
- **develop branch:** Same rules (или более relaxed)
- **Auto-merge:** Enabled если agent approves + criteria met

## 🎯 Special Rules for Different File Types

### Next.js/React Files (*.tsx, *.ts)

```typescript
// MUST: Type all props
interface Props {
  userId: string;
  onComplete: () => void;
}

// MUST: Handle errors
try {
  await fetchData();
} catch (error) {
  logger.error('Failed to fetch', error);
  showToast('error', 'Failed to load data');
}

// PREFER: Async/await over promises
const data = await fetch(url); // ✅
fetch(url).then(data => ...);  // ⚠️

// PREFER: Named exports
export function MyComponent() {} // ✅
export default function() {}     // ⚠️
```

### OpenCart Files (*.php)

```php
// MUST: Follow PSR-12
class ProductController {
    // MUST: Type hints
    public function index(int $productId): void

    // MUST: Prepared statements
    $stmt = $this->db->prepare("SELECT * FROM products WHERE id = ?");
    $stmt->execute([$productId]);

    // MUST: Error handling
    if (!$result) {
        $this->log->error('Product not found', ['id' => $productId]);
        return;
    }
}
```

### Twig Templates (*.twig)

```twig
{# MUST: Escape output #}
{{ product.name|e }}

{# MUST: Check existence #}
{% if product is defined %}
  {{ product.price }}
{% endif %}

{# PREFER: Filters over raw output #}
{{ description|raw|striptags }}
```

### Docker Files

```dockerfile
# MUST: Multi-stage builds
FROM node:20 AS builder
# build steps...
FROM node:20-alpine
# production steps...

# MUST: Non-root user
USER node

# MUST: Health checks
HEALTHCHECK --interval=30s CMD wget -q --spider http://localhost:3000/api/health
```

## 🛡️ Security Rules

### MUST Check

1. **Authentication & Authorization**
   - Proper auth checks на protected routes
   - Role-based access control
   - Session management

2. **Input Validation**
   - Валидация всех user inputs
   - Санитизация перед database queries
   - Type checking на API endpoints

3. **Data Protection**
   - Sensitive data encrypted
   - No passwords в логах
   - Secure cookie settings

4. **Dependencies**
   - Нет known vulnerabilities
   - Regular updates
   - Minimal dependency tree

### MUST NOT Allow

- ❌ `eval()` или `exec()` без веской причины
- ❌ `dangerouslySetInnerHTML` без sanitization
- ❌ Hardcoded credentials anywhere
- ❌ Disabled CSRF protection
- ❌ SQL concatenation (use prepared statements)
- ❌ File uploads без validation
- ❌ Open redirects

## 📈 Performance Rules

### MUST Optimize

1. **Database Queries**
   - Используй indexes
   - Избегай N+1 queries
   - Используй pagination для large datasets
   - Cache expensive queries

2. **Frontend Performance**
   - Lazy load images
   - Code splitting для large pages
   - Memoize expensive calculations
   - Optimize bundle size

3. **Docker Images**
   - Multi-stage builds
   - Minimal base images (alpine)
   - .dockerignore для exclude unnecessary files

### Performance Budgets

- Bundle size: < 200KB (First Load JS)
- Lighthouse score: > 90
- Docker image: < 500MB (OpenCart), < 200MB (Next.js)
- API response: < 200ms (p95)

## 🔧 Tech Stack Specific Rules

### Next.js 15 (App Router)

- ✅ Используй Server Components by default
- ✅ Client Components только когда нужен interactivity
- ✅ `loading.tsx` для Suspense boundaries
- ✅ `error.tsx` для Error boundaries
- ✅ Metadata API для SEO

### TypeScript

- ✅ `strict: true` в tsconfig.json
- ✅ Нет `any` types (используй `unknown` если нужен escape hatch)
- ✅ Interfaces для object shapes
- ✅ Enums для fixed values

### Tailwind CSS v4

- ✅ Используй theme variables
- ✅ Группируй utilities логически
- ✅ Избегай arbitrary values без причины
- ✅ Используй @apply для repeated patterns

### shadcn/ui

- ✅ Следуй component conventions
- ✅ Кастомизируй через CSS variables
- ✅ Не модифицируй components напрямую

## 🎓 Learning & Improvement

Агент должен:

1. **Собирать паттерны**
   - Tracking часто повторяющихся issues
   - Identifying best practices из approved PRs
   - Building knowledge base

2. **Suggest improvements**
   - Предлагать refactoring opportunities
   - Identifying technical debt
   - Recommending modern approaches

3. **Update rules**
   - Адаптироваться к team feedback
   - Evolve с изменениями в codebase
   - Stay current с framework updates

---

**Agent Version:** 1.0.0
**Last Updated:** 2025-01-08
**Maintained by:** @evgenygurin

_Эти правила должны эволюционировать вместе с проектом. Предложения по улучшению приветствуются через PR к этому файлу._
