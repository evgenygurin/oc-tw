# 🤖 Codegen AI Agents Configuration

This document describes the AI agents and automation setup for the OpenCart repository, providing intelligent code review, automated testing, and development assistance.

## 🎯 Overview

Our Codegen AI system includes multiple specialized agents that work together to maintain code quality, security, and performance standards across the OpenCart e-commerce platform.

## 🤖 AI Agents

### 1. Code Review Agent (`@codegen-reviewer`)

**Purpose**: Automated code review and quality assessment

**Capabilities**:
- ✅ OpenCart MVC pattern compliance checking
- ✅ PHP 8+ best practices enforcement
- ✅ Security vulnerability detection
- ✅ Performance optimization suggestions
- ✅ Documentation completeness verification
- ✅ Test coverage analysis

**Triggers**:
- Pull request opened/updated
- Manual review request via comment: `@codegen-reviewer please review`

**Configuration**:
```yaml
review_agent:
  model: "gpt-4-turbo"
  focus_areas:
    - security
    - performance
    - opencart_standards
    - code_quality
  auto_comment: true
  severity_threshold: "medium"
```

### 2. Security Agent (`@codegen-security`)

**Purpose**: Specialized security analysis and vulnerability detection

**Capabilities**:
- 🔒 SQL injection prevention verification
- 🔒 XSS vulnerability detection
- 🔒 CSRF protection validation
- 🔒 Authentication/authorization review
- 🔒 Input sanitization checking
- 🔒 Dependency vulnerability scanning

**Triggers**:
- Security-sensitive file changes
- Manual security review: `@codegen-security scan`
- Scheduled daily security audits

**Configuration**:
```yaml
security_agent:
  model: "gpt-4-turbo"
  security_rules:
    - sql_injection_prevention
    - xss_protection
    - csrf_validation
    - input_sanitization
    - secure_authentication
  alert_threshold: "low"
  create_issues: true
```

### 3. Performance Agent (`@codegen-performance`)

**Purpose**: Performance optimization and monitoring

**Capabilities**:
- ⚡ Database query optimization
- ⚡ Caching strategy recommendations
- ⚡ Asset optimization suggestions
- ⚡ Memory usage analysis
- ⚡ Load time impact assessment
- ⚡ N+1 query detection

**Triggers**:
- Performance-critical file changes
- Manual performance review: `@codegen-performance analyze`
- Performance regression detection

**Configuration**:
```yaml
performance_agent:
  model: "gpt-4-turbo"
  metrics:
    - database_queries
    - memory_usage
    - load_time
    - cache_efficiency
  thresholds:
    query_time: "100ms"
    memory_limit: "256MB"
    page_load: "2s"
```

### 4. Documentation Agent (`@codegen-docs`)

**Purpose**: Automated documentation generation and maintenance

**Capabilities**:
- 📚 API documentation generation
- 📚 Code comment quality assessment
- 📚 README and changelog updates
- 📚 Migration guide generation
- 📚 Developer guide updates

**Triggers**:
- API changes detected
- Manual documentation request: `@codegen-docs update`
- New feature additions

**Configuration**:
```yaml
documentation_agent:
  model: "gpt-4-turbo"
  output_formats:
    - markdown
    - html
    - json
  auto_update:
    - changelog
    - api_docs
    - readme
```

### 5. Test Generation Agent (`@codegen-tests`)

**Purpose**: Automated test generation and test quality improvement

**Capabilities**:
- 🧪 Unit test generation
- 🧪 Integration test suggestions
- 🧪 Test coverage analysis
- 🧪 Test case recommendations
- 🧪 Mock object generation

**Triggers**:
- New controller/model additions
- Manual test request: `@codegen-tests generate`
- Low test coverage detection

**Configuration**:
```yaml
test_agent:
  model: "gpt-4-turbo"
  test_types:
    - unit_tests
    - integration_tests
    - api_tests
  frameworks:
    - phpunit
  coverage_threshold: 80
```

### 6. Migration Agent (`@codegen-migration`)

**Purpose**: Database migration and upgrade assistance

**Capabilities**:
- 🗄️ Database schema analysis
- 🗄️ Migration script generation
- 🗄️ Compatibility checking
- 🗄️ Rollback script creation
- 🗄️ Data integrity verification

**Triggers**:
- Database schema changes
- Manual migration request: `@codegen-migration create`
- Version upgrade preparations

**Configuration**:
```yaml
migration_agent:
  model: "gpt-4-turbo"
  database_types:
    - mysql
    - mariadb
  migration_patterns:
    - opencart_schema
    - version_upgrades
```

## 🎮 Agent Commands

### Universal Commands (Work with all agents)

```bash
# Request comprehensive review
@codegen review this PR

# Get help with specific issue
@codegen help with [description]

# Explain code changes
@codegen explain changes in [file/function]

# Suggest improvements
@codegen suggest improvements

# Check compatibility
@codegen check compatibility with OpenCart 4.1
```

### Agent-Specific Commands

#### Code Review Agent
```bash
@codegen-reviewer review security
@codegen-reviewer check performance
@codegen-reviewer validate opencart standards
@codegen-reviewer assess code quality
```

#### Security Agent
```bash
@codegen-security scan vulnerabilities
@codegen-security check authentication
@codegen-security validate input sanitization
@codegen-security review permissions
```

#### Performance Agent
```bash
@codegen-performance analyze queries
@codegen-performance check memory usage
@codegen-performance optimize caching
@codegen-performance benchmark changes
```

#### Documentation Agent
```bash
@codegen-docs update api documentation
@codegen-docs generate changelog entry
@codegen-docs create migration guide
@codegen-docs update readme
```

#### Test Generation Agent
```bash
@codegen-tests generate unit tests
@codegen-tests create integration tests
@codegen-tests suggest test cases
@codegen-tests analyze coverage
```

#### Migration Agent
```bash
@codegen-migration create schema migration
@codegen-migration generate rollback script
@codegen-migration check data integrity
@codegen-migration validate compatibility
```

## 🔧 Configuration Files

### Main Configuration (`.github/codegen.yml`)
Central configuration file for all AI agents and automation rules.

### Agent-Specific Configurations

#### Security Rules (`.github/codegen-security.yml`)
```yaml
security_rules:
  php:
    forbidden_functions:
      - eval
      - exec
      - system
      - shell_exec
    required_validation:
      - input_sanitization
      - output_escaping
      - csrf_protection
  
  opencart:
    authentication:
      - session_validation
      - permission_checks
      - secure_cookies
    
    database:
      - prepared_statements
      - parameter_binding
      - query_validation
```

#### Performance Rules (`.github/codegen-performance.yml`)
```yaml
performance_rules:
  database:
    max_queries_per_page: 20
    query_timeout: 5000ms
    avoid_select_star: true
    require_indexes: true
  
  caching:
    cache_expensive_operations: true
    cache_ttl_minimum: 300
    use_appropriate_cache_levels: true
  
  assets:
    minify_css: true
    minify_js: true
    optimize_images: true
    use_cdn: recommended
```

## 📊 Monitoring and Analytics

### Agent Performance Metrics

- **Review Accuracy**: Percentage of accurate code review comments
- **Security Detection Rate**: Vulnerabilities caught vs. missed
- **Performance Impact**: Improvements suggested vs. implemented
- **Documentation Quality**: Completeness and accuracy scores
- **Test Coverage**: Coverage improvement from generated tests

### Dashboard Integration

```yaml
monitoring:
  dashboard_url: "https://dashboard.codegen.ai/opencart"
  metrics:
    - agent_performance
    - code_quality_trends
    - security_vulnerability_trends
    - performance_improvements
    - documentation_completeness
  
  alerts:
    critical_security_issues: immediate
    performance_regressions: 1_hour
    test_failures: 30_minutes
```

## 🚀 Getting Started

### 1. Enable AI Agents

Add this to your repository settings:

```yaml
# .github/settings.yml
repository:
  features:
    codegen_ai: true
    auto_review: true
    security_scanning: true
    performance_monitoring: true
```

### 2. Configure Team Permissions

```yaml
teams:
  ai_agents:
    permissions: write
    members:
      - codegen-reviewer
      - codegen-security
      - codegen-performance
      - codegen-docs
      - codegen-tests
      - codegen-migration
```

### 3. Set Up Webhooks

Configure webhooks for real-time AI agent responses:

```bash
# GitHub webhook configuration
curl -X POST \
  https://api.github.com/repos/your-org/opencart/hooks \
  -H 'Authorization: token YOUR_TOKEN' \
  -d '{
    "name": "web",
    "active": true,
    "events": ["pull_request", "push", "issue_comment"],
    "config": {
      "url": "https://api.codegen.ai/webhook/github",
      "content_type": "json"
    }
  }'
```

## 🎓 Training and Learning

### Continuous Learning

The AI agents continuously learn from:
- Code review feedback
- Merged PR patterns
- Issue resolution outcomes
- Performance improvements
- Security incident responses

### Custom Training Data

```yaml
training:
  opencart_specific:
    - mvc_patterns
    - extension_architecture
    - theme_development
    - api_conventions
  
  project_specific:
    - coding_standards
    - security_requirements
    - performance_targets
    - documentation_style
```

## 🔒 Privacy and Security

### Data Protection
- No sensitive data stored in AI models
- Code analysis performed in secure environments
- Compliance with GDPR and privacy regulations
- Audit logs for all AI agent activities

### Access Control
- Agent permissions limited to necessary scopes
- Encrypted communication channels
- Regular security audits of AI systems
- Incident response procedures

## 📚 Best Practices

### Effective AI Agent Usage

1. **Be Specific**: Use detailed commands for better results
2. **Provide Context**: Include relevant background information
3. **Review Suggestions**: Always validate AI recommendations
4. **Iterate**: Use follow-up commands to refine results
5. **Learn Patterns**: Understand how agents interpret your codebase

### Team Collaboration

1. **Agent Etiquette**: Use `@codegen` mentions appropriately
2. **Review AI Comments**: Treat AI feedback as peer review
3. **Provide Feedback**: Help improve agent accuracy
4. **Share Knowledge**: Document successful AI interactions
5. **Stay Updated**: Keep up with new agent capabilities

## 🆘 Troubleshooting

### Common Issues

**Agent Not Responding**
- Check webhook configuration
- Verify repository permissions
- Review rate limits

**Inaccurate Reviews**
- Provide more context in PR descriptions
- Use specific agent commands
- Report issues to improve training

**Performance Issues**
- Monitor API rate limits
- Optimize agent configurations
- Use caching where appropriate

### Support Channels

- **GitHub Issues**: Report bugs and feature requests
- **Documentation**: Comprehensive guides and examples
- **Community Forum**: Peer support and discussions
- **Direct Support**: Enterprise support for critical issues

---

**🎉 Welcome to the future of automated development with Codegen AI! These agents are here to help you build better, more secure, and more performant OpenCart applications.**