# 🤝 Contributing to OpenCart

Thank you for your interest in contributing to OpenCart! This guide will help you get started with contributing to our e-commerce platform.

## 📋 Table of Contents

- [🎯 Getting Started](#-getting-started)
- [🔧 Development Setup](#-development-setup)
- [📝 Contribution Types](#-contribution-types)
- [🚀 Pull Request Process](#-pull-request-process)
- [🧪 Testing Guidelines](#-testing-guidelines)
- [📚 Documentation Standards](#-documentation-standards)
- [🔒 Security Guidelines](#-security-guidelines)
- [🎨 Code Style Guide](#-code-style-guide)
- [🤖 AI-Powered Development](#-ai-powered-development)
- [🏆 Recognition](#-recognition)

## 🎯 Getting Started

### Prerequisites

Before contributing, ensure you have:

- **PHP 8.0+** installed
- **Composer** for dependency management
- **Docker** and **Docker Compose** for development environment
- **Git** for version control
- **Node.js** (for frontend asset compilation)
- Basic understanding of **OpenCart architecture**

### First-Time Contributors

1. **Read the Documentation**
   - [OpenCart Documentation](https://docs.opencart.com/)
   - [Developer Guide](https://docs.opencart.com/developer/)
   - [Extension Development](https://docs.opencart.com/extension/)

2. **Explore the Codebase**
   - Browse the repository structure
   - Understand the MVC pattern used
   - Review existing extensions and themes

3. **Join the Community**
   - [OpenCart Forum](https://forum.opencart.com/)
   - [GitHub Discussions](https://github.com/opencart/opencart/discussions)
   - [Discord Server](https://discord.gg/opencart) (if available)

## 🔧 Development Setup

### Local Development Environment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/opencart/opencart.git
   cd opencart
   ```

2. **Set Up Docker Environment**
   ```bash
   # Initialize environment
   make init
   
   # Start services
   make up
   
   # Check status
   make ps
   ```

3. **Install Dependencies**
   ```bash
   # Enter PHP container
   make php
   
   # Install Composer dependencies
   composer install
   
   # Install development tools
   composer install --dev
   ```

4. **Configure Environment**
   ```bash
   # Copy environment file
   cp docker/.env.docker.example docker/.env.docker
   
   # Edit configuration as needed
   nano docker/.env.docker
   ```

5. **Access the Application**
   - **Frontend**: http://localhost:80
   - **Admin Panel**: http://localhost:80/admin
   - **Database Admin**: http://localhost:8080 (if Adminer profile enabled)

### Development Tools

- **PHPStan**: Static analysis tool
  ```bash
  php tools/phpstan.phar analyze
  ```

- **PHP-CS-Fixer**: Code style fixer
  ```bash
  php tools/php-cs-fixer.phar fix
  ```

- **Docker Commands**: Use Makefile for common tasks
  ```bash
  make help  # See all available commands
  ```

## 📝 Contribution Types

### 🐛 Bug Fixes

**When to contribute bug fixes:**
- You've identified a reproducible bug
- The bug affects functionality or user experience
- You have a clear solution

**Bug fix process:**
1. Search existing issues to avoid duplicates
2. Create a detailed bug report using our template
3. Fork the repository and create a bug fix branch
4. Implement the fix with appropriate tests
5. Submit a pull request with clear description

### ✨ New Features

**Feature contribution guidelines:**
- Discuss major features in GitHub Discussions first
- Ensure the feature aligns with OpenCart's roadmap
- Consider backward compatibility
- Include comprehensive documentation

**Feature development process:**
1. Create a feature request issue
2. Wait for maintainer approval
3. Design the feature architecture
4. Implement with tests and documentation
5. Submit PR with detailed description

### 📚 Documentation

**Documentation contributions:**
- API documentation improvements
- User guide enhancements
- Developer tutorials
- Code comment improvements
- Translation updates

### 🎨 UI/UX Improvements

**Design contribution guidelines:**
- Follow OpenCart's design principles
- Ensure accessibility compliance
- Test on multiple devices and browsers
- Consider internationalization (i18n)

### 🔒 Security Enhancements

**Security contribution process:**
- **DO NOT** report security vulnerabilities publicly
- Use our [Security Policy](.github/ISSUE_TEMPLATE/security_vulnerability.md)
- Follow responsible disclosure practices
- Work with maintainers on fixes

## 🚀 Pull Request Process

### Before Creating a PR

1. **Check Existing Work**
   - Search for existing PRs addressing the same issue
   - Review related issues and discussions
   - Ensure your contribution is needed

2. **Create a Branch**
   ```bash
   # Create feature branch from develop
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   
   # Or for bug fixes
   git checkout -b bugfix/issue-description
   ```

3. **Follow Naming Conventions**
   - `feature/feature-name` - New features
   - `bugfix/bug-description` - Bug fixes
   - `hotfix/critical-issue` - Critical fixes
   - `docs/documentation-update` - Documentation
   - `refactor/code-improvement` - Code refactoring

### Creating the Pull Request

1. **Use Our PR Template**
   - Fill out all relevant sections
   - Provide clear description of changes
   - Link related issues
   - Include screenshots for UI changes

2. **Ensure Quality**
   - All tests pass locally
   - Code follows style guidelines
   - No debugging code left behind
   - Proper error handling implemented

3. **Request Reviews**
   - Add appropriate reviewers
   - Use draft PRs for work in progress
   - Respond to feedback promptly

### PR Review Process

1. **Automated Checks**
   - ✅ Linting and code style
   - ✅ Unit and integration tests
   - ✅ Security vulnerability scan
   - ✅ Performance impact analysis
   - ✅ AI-powered code review

2. **Human Review**
   - Code quality assessment
   - Architecture review
   - Security evaluation
   - Documentation review
   - Testing verification

3. **Approval and Merge**
   - Requires approval from code owners
   - All checks must pass
   - Squash and merge for clean history

## 🧪 Testing Guidelines

### Test Types

1. **Unit Tests**
   - Test individual methods and classes
   - Use PHPUnit framework
   - Aim for 80%+ code coverage
   - Mock external dependencies

2. **Integration Tests**
   - Test component interactions
   - Database integration tests
   - API endpoint tests
   - Extension compatibility tests

3. **End-to-End Tests**
   - User workflow testing
   - Browser automation tests
   - Performance benchmarks
   - Accessibility testing

### Writing Tests

```php
<?php
namespace Tests\Unit\Catalog\Model;

use PHPUnit\Framework\TestCase;
use Opencart\Catalog\Model\Catalog\Product;

class ProductTest extends TestCase
{
    private $product;
    
    protected function setUp(): void
    {
        $this->product = new Product($this->createMockRegistry());
    }
    
    public function testGetProduct(): void
    {
        $result = $this->product->getProduct(1);
        
        $this->assertIsArray($result);
        $this->assertArrayHasKey('product_id', $result);
        $this->assertEquals(1, $result['product_id']);
    }
    
    public function testGetProductWithInvalidId(): void
    {
        $result = $this->product->getProduct(999999);
        
        $this->assertEmpty($result);
    }
    
    private function createMockRegistry(): Registry
    {
        // Mock registry setup
        return $mockRegistry;
    }
}
```

### Running Tests

```bash
# Run all tests
make test

# Run specific test suite
vendor/bin/phpunit tests/Unit/

# Run with coverage
vendor/bin/phpunit --coverage-html coverage/

# Run performance tests
make test-performance
```

## 📚 Documentation Standards

### Code Documentation

1. **PHP DocBlocks**
   ```php
   /**
    * Retrieves product information by ID
    *
    * @param int $product_id The product identifier
    * @param bool $include_images Whether to include product images
    * @return array Product data array or empty array if not found
    * @throws InvalidArgumentException When product_id is invalid
    * @since 4.1.0
    */
   public function getProduct(int $product_id, bool $include_images = false): array
   {
       // Implementation
   }
   ```

2. **Inline Comments**
   - Explain complex business logic
   - Document workarounds and hacks
   - Provide context for non-obvious code
   - Use clear, concise language

### API Documentation

- Use OpenAPI/Swagger specifications
- Include request/response examples
- Document authentication requirements
- Provide error code explanations

### User Documentation

- Step-by-step instructions
- Screenshots and videos
- Troubleshooting sections
- FAQ entries

## 🔒 Security Guidelines

### Secure Coding Practices

1. **Input Validation**
   ```php
   // Always validate and sanitize input
   $product_id = filter_input(INPUT_GET, 'product_id', FILTER_VALIDATE_INT);
   if ($product_id === false || $product_id <= 0) {
       throw new InvalidArgumentException('Invalid product ID');
   }
   ```

2. **Output Encoding**
   ```php
   // Escape output to prevent XSS
   echo htmlspecialchars($user_input, ENT_QUOTES, 'UTF-8');
   
   // In Twig templates
   {{ user_input|escape }}
   ```

3. **Database Security**
   ```php
   // Use prepared statements
   $stmt = $this->db->prepare("SELECT * FROM products WHERE product_id = ?");
   $stmt->execute([$product_id]);
   ```

4. **Authentication & Authorization**
   ```php
   // Check user permissions
   if (!$this->user->hasPermission('modify', 'catalog/product')) {
       throw new UnauthorizedException('Insufficient permissions');
   }
   ```

### Security Checklist

- [ ] Input validation implemented
- [ ] Output encoding applied
- [ ] SQL injection prevention verified
- [ ] XSS protection in place
- [ ] CSRF tokens validated
- [ ] Authentication checks implemented
- [ ] Authorization verified
- [ ] Sensitive data protected
- [ ] Error messages don't leak information
- [ ] File upload security measures applied

## 🎨 Code Style Guide

### PHP Standards

Follow **PSR-12** coding standards with OpenCart-specific conventions:

1. **File Structure**
   ```php
   <?php
   declare(strict_types=1);
   
   namespace Opencart\Catalog\Controller\Product;
   
   use Opencart\System\Engine\Controller;
   use InvalidArgumentException;
   
   /**
    * Product Controller
    * 
    * Handles product-related frontend operations
    */
   class Product extends Controller
   {
       // Class implementation
   }
   ```

2. **Naming Conventions**
   - **Classes**: PascalCase (`ProductController`)
   - **Methods**: camelCase (`getProduct`)
   - **Variables**: camelCase (`$productId`)
   - **Constants**: UPPER_CASE (`MAX_PRODUCTS`)
   - **Files**: PascalCase matching class name

3. **Method Structure**
   ```php
   public function getProduct(int $productId): array
   {
       // Validate input
       if ($productId <= 0) {
           throw new InvalidArgumentException('Product ID must be positive');
       }
       
       // Business logic
       $product = $this->model_catalog_product->getProduct($productId);
       
       // Return result
       return $product ?: [];
   }
   ```

### Frontend Standards

1. **CSS/SCSS**
   - Use BEM methodology
   - Mobile-first responsive design
   - Consistent spacing and typography
   - Accessibility considerations

2. **JavaScript**
   - ES6+ features where supported
   - Consistent formatting with Prettier
   - JSDoc comments for functions
   - Error handling and validation

3. **Twig Templates**
   - Semantic HTML structure
   - Proper escaping of variables
   - Consistent indentation
   - Accessibility attributes

### Code Formatting

Use automated tools for consistent formatting:

```bash
# Fix PHP code style
php tools/php-cs-fixer.phar fix

# Check code style
php tools/php-cs-fixer.phar fix --dry-run --diff

# Analyze code quality
php tools/phpstan.phar analyze
```

## 🤖 AI-Powered Development

### Using Codegen AI Agents

Our repository includes AI agents to assist with development:

1. **Code Review Agent** (`@codegen-reviewer`)
   ```bash
   # Request AI code review
   @codegen-reviewer please review this PR
   
   # Check specific aspects
   @codegen-reviewer check security and performance
   ```

2. **Security Agent** (`@codegen-security`)
   ```bash
   # Security scan
   @codegen-security scan for vulnerabilities
   
   # Validate authentication
   @codegen-security check authentication logic
   ```

3. **Performance Agent** (`@codegen-performance`)
   ```bash
   # Performance analysis
   @codegen-performance analyze database queries
   
   # Optimization suggestions
   @codegen-performance suggest optimizations
   ```

### AI-Assisted Development

- Use AI suggestions as starting points, not final solutions
- Always review and test AI-generated code
- Provide context for better AI assistance
- Report issues with AI suggestions to improve the system

## 🏆 Recognition

### Contributor Levels

1. **First-time Contributor**
   - Welcome package and mentorship
   - Recognition in contributor list
   - Special "first contribution" badge

2. **Regular Contributor**
   - Listed in project credits
   - Access to contributor Discord channel
   - Early access to new features

3. **Core Contributor**
   - Commit access to specific areas
   - Voting rights on technical decisions
   - OpenCart conference speaking opportunities

4. **Maintainer**
   - Full repository access
   - Release management participation
   - Technical steering committee membership

### Contribution Rewards

- **GitHub Achievements**: Badges and profile highlights
- **Swag**: OpenCart t-shirts, stickers, and merchandise
- **Conference Tickets**: Free tickets to OpenCart events
- **Professional Recognition**: LinkedIn recommendations
- **Career Opportunities**: Job referrals and networking

## 📞 Getting Help

### Support Channels

1. **GitHub Discussions**
   - General questions and discussions
   - Feature proposals and feedback
   - Community support

2. **OpenCart Forum**
   - User support and tutorials
   - Extension development help
   - Business and marketing discussions

3. **Documentation**
   - Official OpenCart docs
   - Developer guides and tutorials
   - API reference documentation

4. **Direct Contact**
   - Maintainer email for urgent issues
   - Security team for vulnerability reports
   - Business inquiries for partnerships

### Mentorship Program

New contributors can request mentorship:
- Pair programming sessions
- Code review guidance
- Architecture discussions
- Career development advice

## 📋 Contribution Checklist

Before submitting your contribution:

### Pre-submission Checklist

- [ ] I have read and understood the contributing guidelines
- [ ] My code follows the project's coding standards
- [ ] I have tested my changes thoroughly
- [ ] I have added appropriate documentation
- [ ] I have included relevant tests
- [ ] My commit messages are clear and descriptive
- [ ] I have linked related issues in my PR
- [ ] I have requested appropriate reviewers

### Security Checklist

- [ ] I have not included sensitive information
- [ ] Input validation is implemented
- [ ] Output is properly escaped
- [ ] Authentication/authorization is verified
- [ ] No security vulnerabilities introduced

### Quality Checklist

- [ ] Code is readable and maintainable
- [ ] Error handling is appropriate
- [ ] Performance impact is acceptable
- [ ] Backward compatibility is maintained
- [ ] Documentation is complete and accurate

## 🎉 Thank You!

Thank you for contributing to OpenCart! Your efforts help make e-commerce better for millions of users worldwide. Every contribution, no matter how small, makes a difference.

**Happy coding!** 🚀

---

*For questions about this guide, please open an issue or start a discussion in our GitHub repository.*