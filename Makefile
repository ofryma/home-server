.PHONY: up down restart build logs ps clean prune shell-nginx shell-n8n

# Start all services (restarts nginx if already running to reload config)
up:
	@if docker ps -q -f name=nginx | grep -q .; then \
		docker compose up -d && docker restart nginx; \
	else \
		docker compose up -d; \
	fi

# Stop all services
down:
	docker compose down

# Restart all services
restart:
	docker compose restart

# Build/rebuild services
build:
	docker compose build

# Build and start services
up-build:
	docker compose up -d --build

# View logs (follow mode)
logs:
	docker compose logs -f

# View logs for specific service (usage: make logs-service SERVICE=nginx)
logs-service:
	docker compose logs -f $(SERVICE)

# Show running containers
ps:
	docker compose ps

# Stop and remove containers, networks, volumes
clean:
	docker compose down -v

# Remove unused Docker resources
prune:
	docker system prune -f

# Shell into nginx container
shell-nginx:
	docker compose exec nginx sh

# Shell into n8n container
shell-n8n:
	docker compose exec n8n sh

# Reload nginx configuration
nginx-reload:
	docker compose exec nginx nginx -s reload

# Test nginx configuration
nginx-test:
	docker compose exec nginx nginx -t

# Show help
help:
	@echo "Available commands:"
	@echo "  make up            - Start all services (restarts nginx if exists)"
	@echo "  make down          - Stop all services"
	@echo "  make restart       - Restart all services"
	@echo "  make build         - Build/rebuild services"
	@echo "  make up-build      - Build and start services"
	@echo "  make logs          - View all logs (follow mode)"
	@echo "  make logs-service SERVICE=name - View logs for specific service"
	@echo "  make ps            - Show running containers"
	@echo "  make clean         - Stop and remove containers, networks, volumes"
	@echo "  make prune         - Remove unused Docker resources"
	@echo "  make shell-nginx   - Shell into nginx container"
	@echo "  make shell-n8n     - Shell into n8n container"
	@echo "  make nginx-reload  - Reload nginx configuration"
	@echo "  make nginx-test    - Test nginx configuration"

