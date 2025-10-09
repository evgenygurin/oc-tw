## Description

<!-- Brief summary of changes (2-3 sentences) -->

**WHY:** <!-- Explain the business/technical reason for this change -->

**Related Issue:** <!-- Link to issue/ticket if applicable -->

## Type of Change

<!-- Select one by putting an 'x' in the brackets: [x] -->

- [ ] `feat:` New feature (OpenCart module, Next.js component)
- [ ] `fix:` Bug fix
- [ ] `refactor:` Code restructuring without behavior change
- [ ] `style:` UI/UX changes (theme, CSS, components)
- [ ] `docs:` Documentation updates
- [ ] `chore:` Maintenance (dependencies, config)
- [ ] `perf:` Performance improvements

## Testing Evidence

<!-- Provide proof that changes work as expected -->

### Screenshots (for UI changes)
<!-- Drag & drop images here -->

### Test Results
<!-- Paste test output or describe manual testing steps -->

```bash
# Example:
npm run build   # ✅ Build successful
npm run lint    # ✅ No errors
docker compose ps  # ✅ All services healthy
```

## Affected Components

<!-- Check all that apply -->

- [ ] OpenCart backend (PHP/Twig)
- [ ] Next.js frontend (React/TypeScript)
- [ ] Docker configuration
- [ ] Theme (oc-astro)
- [ ] Database schema/migrations

## Pre-submission Checklist

<!-- Verify all items before submitting -->

- [ ] Branch named correctly (`feat/description` or `fix/description`)
- [ ] Commits follow conventional commits format
- [ ] No secrets committed (`.env` excluded, no hardcoded credentials)
- [ ] Dependencies updated if needed (`package.json` or `composer.json`)
- [ ] `CLAUDE.md` updated for architectural changes
- [ ] Backwards compatibility maintained (migrations provided if needed)
- [ ] Performance considerations addressed (no N+1 queries, optimized images)
- [ ] Code quality checks passed:
  - [ ] `npm run lint` (no errors)
  - [ ] `npm run build` (successful)
  - [ ] `docker compose up -d` (no errors)
  - [ ] `docker compose ps` (all healthy)

## Additional Notes

<!-- Any extra context, edge cases, or reviewer guidance -->

---

**Automated checks will verify:**

- TypeScript type safety
- ESLint compliance
- PHP PSR-12 standards
- Security vulnerabilities
- Docker services health
- Database migrations validity
