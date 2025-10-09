# Branch Protection Rules Configuration

This document outlines the recommended branch protection rules for the OpenCart repository to ensure code quality, security, and stability.

## 🛡️ Branch Protection Overview

Branch protection rules help maintain code quality by requiring certain conditions to be met before code can be merged into protected branches.

## 📋 Protection Rules by Branch

### Main Branch (`master` or `main`)

#### Required Status Checks
- **Require status checks to pass before merging**: ✅ Enabled
- **Require branches to be up to date before merging**: ✅ Enabled

**Required Checks:**
- `ci/lint` - Code linting and style checks
- `ci/tests` - Unit and integration tests
- `ci/security-scan` - Security vulnerability scanning
- `ci/performance-check` - Performance regression tests
- `ai/code-review` - AI-powered code review
- `build/docker` - Docker build verification

#### Pull Request Requirements
- **Require pull request reviews before merging**: ✅ Enabled
- **Required number of reviewers**: `2`
- **Dismiss stale reviews when new commits are pushed**: ✅ Enabled
- **Require review from code owners**: ✅ Enabled
- **Restrict reviews to users with write access**: ✅ Enabled

#### Additional Restrictions
- **Restrict pushes that create files**: ❌ Disabled
- **Require signed commits**: ✅ Enabled (recommended)
- **Require linear history**: ✅ Enabled
- **Include administrators**: ✅ Enabled

#### Force Push and Deletion Protection
- **Allow force pushes**: ❌ Disabled
- **Allow deletions**: ❌ Disabled

### Development Branch (`develop`)

#### Required Status Checks
- **Require status checks to pass before merging**: ✅ Enabled
- **Require branches to be up to date before merging**: ✅ Enabled

**Required Checks:**
- `ci/lint` - Code linting and style checks
- `ci/tests` - Unit and integration tests
- `ci/security-scan` - Security vulnerability scanning
- `ai/code-review` - AI-powered code review

#### Pull Request Requirements
- **Require pull request reviews before merging**: ✅ Enabled
- **Required number of reviewers**: `1`
- **Dismiss stale reviews when new commits are pushed**: ✅ Enabled
- **Require review from code owners**: ✅ Enabled

#### Additional Restrictions
- **Require signed commits**: ✅ Enabled (recommended)
- **Include administrators**: ✅ Enabled

#### Force Push and Deletion Protection
- **Allow force pushes**: ❌ Disabled
- **Allow deletions**: ❌ Disabled

### Release Branches (`release/*`)

#### Required Status Checks
- **Require status checks to pass before merging**: ✅ Enabled
- **Require branches to be up to date before merging**: ✅ Enabled

**Required Checks:**
- `ci/lint` - Code linting and style checks
- `ci/tests` - Full test suite
- `ci/security-scan` - Comprehensive security scan
- `ci/performance-check` - Performance benchmarks
- `ci/integration-tests` - End-to-end tests
- `ai/code-review` - AI-powered code review

#### Pull Request Requirements
- **Require pull request reviews before merging**: ✅ Enabled
- **Required number of reviewers**: `3`
- **Dismiss stale reviews when new commits are pushed**: ✅ Enabled
- **Require review from code owners**: ✅ Enabled
- **Restrict reviews to users with write access**: ✅ Enabled

#### Additional Restrictions
- **Require signed commits**: ✅ Enabled
- **Require linear history**: ✅ Enabled
- **Include administrators**: ✅ Enabled

#### Force Push and Deletion Protection
- **Allow force pushes**: ❌ Disabled
- **Allow deletions**: ❌ Disabled

## 🔧 GitHub CLI Configuration Script

Use this script to automatically configure branch protection rules:

```bash
#!/bin/bash

# Configure branch protection for OpenCart repository
# Run this script with appropriate GitHub permissions

REPO="your-org/opencart"  # Replace with your repository

echo "🛡️  Configuring branch protection rules for $REPO..."

# Main branch protection
gh api repos/$REPO/branches/master/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/lint","ci/tests","ci/security-scan","ci/performance-check","ai/code-review","build/docker"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":2,"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"restrict_reviews_to_collaborators":true}' \
  --field restrictions=null \
  --field required_linear_history=true \
  --field allow_force_pushes=false \
  --field allow_deletions=false

# Development branch protection
gh api repos/$REPO/branches/develop/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["ci/lint","ci/tests","ci/security-scan","ai/code-review"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true,"require_code_owner_reviews":true}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false

echo "✅ Branch protection rules configured successfully!"
```

## 🏷️ Required Labels

Create these labels in your repository for proper PR categorization:

### Priority Labels
- `priority/critical` - #D93F0B (Red)
- `priority/high` - #FF9500 (Orange)
- `priority/medium` - #FBCA04 (Yellow)
- `priority/low` - #0E8A16 (Green)

### Type Labels
- `type/bug` - #D93F0B (Red)
- `type/feature` - #0052CC (Blue)
- `type/enhancement` - #7057FF (Purple)
- `type/documentation` - #0E8A16 (Green)
- `type/security` - #B60205 (Dark Red)
- `type/performance` - #FBCA04 (Yellow)

### Component Labels
- `component/frontend` - #0052CC (Blue)
- `component/backend` - #5319E7 (Purple)
- `component/api` - #FF6B6B (Pink)
- `component/database` - #FFA500 (Orange)
- `component/docker` - #2496ED (Docker Blue)
- `component/extension` - #7057FF (Purple)

### Size Labels
- `size/XS` - #C2E0C6 (Light Green)
- `size/S` - #7057FF (Purple)
- `size/M` - #FBCA04 (Yellow)
- `size/L` - #FF9500 (Orange)
- `size/XL` - #D93F0B (Red)

### Status Labels
- `status/needs-review` - #FBCA04 (Yellow)
- `status/needs-changes` - #FF9500 (Orange)
- `status/ready-to-merge` - #0E8A16 (Green)
- `status/blocked` - #D93F0B (Red)
- `status/work-in-progress` - #C2E0C6 (Light Green)

### Special Labels
- `good-first-issue` - #7057FF (Purple)
- `help-wanted` - #0052CC (Blue)
- `breaking-change` - #B60205 (Dark Red)
- `needs-documentation` - #0E8A16 (Green)
- `ai-generated` - #F9D0C4 (Light Pink)

## 🤖 Automated Label Creation Script

```bash
#!/bin/bash

# Create labels for OpenCart repository
REPO="your-org/opencart"  # Replace with your repository

echo "🏷️  Creating labels for $REPO..."

# Priority labels
gh label create "priority/critical" --color "D93F0B" --description "Critical priority issue" --repo $REPO
gh label create "priority/high" --color "FF9500" --description "High priority issue" --repo $REPO
gh label create "priority/medium" --color "FBCA04" --description "Medium priority issue" --repo $REPO
gh label create "priority/low" --color "0E8A16" --description "Low priority issue" --repo $REPO

# Type labels
gh label create "type/bug" --color "D93F0B" --description "Bug report" --repo $REPO
gh label create "type/feature" --color "0052CC" --description "New feature request" --repo $REPO
gh label create "type/enhancement" --color "7057FF" --description "Enhancement to existing feature" --repo $REPO
gh label create "type/documentation" --color "0E8A16" --description "Documentation update" --repo $REPO
gh label create "type/security" --color "B60205" --description "Security-related issue" --repo $REPO
gh label create "type/performance" --color "FBCA04" --description "Performance improvement" --repo $REPO

# Component labels
gh label create "component/frontend" --color "0052CC" --description "Frontend/customer-facing changes" --repo $REPO
gh label create "component/backend" --color "5319E7" --description "Backend/admin panel changes" --repo $REPO
gh label create "component/api" --color "FF6B6B" --description "API-related changes" --repo $REPO
gh label create "component/database" --color "FFA500" --description "Database-related changes" --repo $REPO
gh label create "component/docker" --color "2496ED" --description "Docker configuration changes" --repo $REPO
gh label create "component/extension" --color "7057FF" --description "Extension system changes" --repo $REPO

echo "✅ Labels created successfully!"
```

## 🔐 Security Considerations

### Signed Commits
Require signed commits to ensure authenticity:
1. Enable "Require signed commits" in branch protection
2. Team members must set up GPG signing
3. Configure Git to sign commits by default

### Sensitive File Protection
Use `.gitignore` and additional rules to prevent sensitive data:
```gitignore
# Sensitive configuration files
.env
.env.local
.env.production
config.php
admin/config.php

# Security keys and certificates
*.pem
*.key
*.crt
*.p12

# Database dumps with sensitive data
*.sql
!install/opencart-*.sql
```

### Access Control
1. **Repository access**: Limit write access to core team members
2. **Branch permissions**: Use branch-specific permissions
3. **Secret management**: Use GitHub Secrets for sensitive data
4. **Audit logging**: Enable security audit logs

## 📊 Monitoring and Compliance

### Required Integrations
- **Dependabot**: Automated dependency updates
- **CodeQL**: Security vulnerability scanning
- **Secret scanning**: Prevent credential leaks
- **Dependency review**: Review dependency changes

### Compliance Checks
- All PRs must pass security scans
- License compatibility verification
- GDPR compliance for data handling
- PCI DSS compliance for payment processing

## 🚀 Implementation Steps

1. **Create GitHub Teams**: Set up teams mentioned in CODEOWNERS
2. **Configure Branch Protection**: Apply rules using GitHub UI or CLI
3. **Create Labels**: Use the provided script
4. **Set up Integrations**: Enable security and quality tools
5. **Train Team**: Educate team on new processes
6. **Monitor Compliance**: Regular audits of protection effectiveness

## 📚 Additional Resources

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [GitHub Security Features](https://docs.github.com/en/code-security)
- [OpenCart Security Guidelines](https://docs.opencart.com/security/)

---

**Note**: Adjust these rules based on your team size, workflow, and security requirements. Start with stricter rules and relax them as needed rather than the opposite.