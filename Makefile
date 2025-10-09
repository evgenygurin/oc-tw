.PHONY: help build up down restart logs clean install

help:
	@echo "OpenCart Docker Management"
	@echo ""
	@echo "Available commands:"
	@echo "  make build    - Build Docker images"
	@echo "  make up       - Start all containers"
	@echo "  make down     - Stop all containers"
	@echo "  make restart  - Restart all containers"
	@echo "  make logs     - View container logs"
	@echo "  make clean    - Remove containers and volumes (WARNING: deletes all data)"
	@echo "  make install  - First-time setup (build + up)"

build:
	docker compose build

up:
	docker compose up -d
	@echo ""
	@echo "OpenCart is starting..."
	@echo "OpenCart: http://localhost:8080"
	@echo "Admin: http://localhost:8080/admin"
	@echo "phpMyAdmin: http://localhost:8081"

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

clean:
	@echo "WARNING: This will delete all containers, volumes and data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "Cleaned successfully"; \
	fi

install: build up
	@echo ""
	@echo "Installation complete!"
	@echo "Visit http://localhost:8080/install to complete OpenCart setup"
