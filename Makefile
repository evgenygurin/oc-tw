.PHONY: help build up down restart logs clean install reset theme

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Show this help message
	@echo "$(BLUE)OpenCart Taiwan - Available Commands$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

build: ## Build Docker containers
	@echo "$(BLUE)🔨 Building containers...$(NC)"
	docker compose build --no-cache

up: ## Start all services
	@echo "$(BLUE)🚀 Starting services...$(NC)"
	docker compose up -d
	@echo "$(GREEN)✅ Services started!$(NC)"
	@echo "$(YELLOW)📍 OpenCart: http://localhost:8080$(NC)"
	@echo "$(YELLOW)👤 Admin: http://localhost:8080/admin$(NC)"
	@echo "$(YELLOW)💾 Adminer: http://localhost:8081$(NC)"
	@echo "$(YELLOW)📧 MailHog: http://localhost:8025$(NC)"

down: ## Stop all services
	@echo "$(BLUE)🛑 Stopping services...$(NC)"
	docker compose down
	@echo "$(GREEN)✅ Services stopped$(NC)"

restart: down up ## Restart all services

logs: ## Show logs (use 'make logs s=opencart' for specific service)
	@if [ -z "$(s)" ]; then \
		docker compose logs -f; \
	else \
		docker compose logs -f $(s); \
	fi

logs-opencart: ## Show OpenCart logs
	docker compose logs -f opencart

logs-mysql: ## Show MySQL logs
	docker compose logs -f mysql

status: ## Show service status
	@echo "$(BLUE)📊 Service Status:$(NC)"
	@docker compose ps

clean: ## Remove containers and volumes (WARNING: deletes all data!)
	@echo "$(RED)⚠️  This will delete all containers and volumes!$(NC)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(BLUE)🗑️  Cleaning...$(NC)"; \
		docker compose down -v; \
		echo "$(GREEN)✅ Cleanup complete$(NC)"; \
	else \
		echo "$(YELLOW)Cancelled$(NC)"; \
	fi

install: build up ## Fresh install (build + start)
	@echo "$(GREEN)🎉 Installation complete!$(NC)"
	@echo ""
	@echo "$(BLUE)Access your OpenCart installation:$(NC)"
	@echo "  Frontend: http://localhost:8080"
	@echo "  Admin:    http://localhost:8080/admin"
	@echo "  Username: admin"
	@echo "  Password: admin123"
	@echo ""
	@echo "$(BLUE)Database Management:$(NC)"
	@echo "  Adminer:  http://localhost:8081"
	@echo "  Server:   mysql"
	@echo "  Database: opencart_db"
	@echo "  Username: opencart"
	@echo "  Password: opencart_pass"

reset: clean install ## Complete reset (clean + install)

shell-opencart: ## Shell into OpenCart container
	docker compose exec opencart bash

shell-mysql: ## Shell into MySQL container  
	docker compose exec mysql bash

db-shell: ## MySQL CLI
	docker compose exec mysql mysql -u opencart -popencart_pass opencart_db

theme: ## Watch theme changes
	@echo "$(BLUE)👀 Watching theme directory: theme/oc-astro/$(NC)"
	@echo "$(YELLOW)Changes will be reflected immediately (no restart needed)$(NC)"
	@echo "Press Ctrl+C to stop"
	@while true; do \
		inotifywait -r -e modify,create,delete theme/oc-astro/ 2>/dev/null || fswatch -o theme/oc-astro/ | read; \
		echo "$(GREEN)✅ Theme updated$(NC)"; \
	done

backup-db: ## Backup database
	@mkdir -p backups
	@echo "$(BLUE)💾 Creating database backup...$(NC)"
	docker compose exec -T mysql mysqldump -u opencart -popencart_pass opencart_db > backups/opencart_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Backup created in backups/$(NC)"

restore-db: ## Restore database (use 'make restore-db file=backup.sql')
	@if [ -z "$(file)" ]; then \
		echo "$(RED)❌ Please specify file: make restore-db file=backups/opencart_20250108.sql$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)📥 Restoring database from $(file)...$(NC)"
	docker compose exec -T mysql mysql -u opencart -popencart_pass opencart_db < $(file)
	@echo "$(GREEN)✅ Database restored$(NC)"

health: ## Check service health
	@echo "$(BLUE)🏥 Health Check:$(NC)"
	@echo ""
	@echo "$(YELLOW)OpenCart:$(NC)"
	@curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:8080 || echo "  $(RED)❌ Not accessible$(NC)"
	@echo ""
	@echo "$(YELLOW)Adminer:$(NC)"
	@curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:8081 || echo "  $(RED)❌ Not accessible$(NC)"
	@echo ""
	@echo "$(YELLOW)MailHog:$(NC)"
	@curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:8025 || echo "  $(RED)❌ Not accessible$(NC)"
	@echo ""
	@echo "$(YELLOW)MySQL:$(NC)"
	@docker compose exec mysql mysqladmin ping -h localhost --silent && echo "  $(GREEN)✅ Healthy$(NC)" || echo "  $(RED)❌ Not healthy$(NC)"

prune: ## Prune Docker system (free up space)
	@echo "$(BLUE)🧹 Pruning Docker system...$(NC)"
	docker system prune -af --volumes
	@echo "$(GREEN)✅ System pruned$(NC)"
