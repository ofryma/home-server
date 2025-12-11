.PHONY: up down restart build logs ps clean prune shell-nginx shell-n8n nginx-reload nginx-restart

# Get local IP address
LOCAL_IP := $(shell ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)

# Start all services
up:
	@echo "Detecting local IP: $(LOCAL_IP)"
	docker compose up -d
	@echo "Reloading nginx configuration..."
	@docker compose exec -T nginx nginx -s reload 2>/dev/null || true

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

# Reload nginx configuration (graceful, no downtime)
nginx-reload:
	@echo "Reloading nginx configuration..."
	docker compose exec nginx nginx -s reload

# Restart nginx container
nginx-restart:
	@echo "Restarting nginx container..."
	docker compose restart nginx

# Shell into nginx container
shell-nginx:
	docker compose exec nginx sh

# Shell into nginx-proxy-manager container
shell-npm:
	docker compose exec nginx-proxy-manager bash

# Shell into n8n container
shell-n8n:
	docker compose exec n8n sh

# Shell into pihole container
shell-pihole:
	docker compose exec pihole bash

# Shell into immich container
shell-immich:
	docker compose exec immich-server sh

# Shell into homeassistant container
shell-homeassistant:
	docker compose exec homeassistant bash

# Show help
help:
	@echo "Available commands:"
	@echo "  make up            - Start all services"
	@echo "  make down          - Stop all services"
	@echo "  make restart       - Restart all services"
	@echo "  make build         - Build/rebuild services"
	@echo "  make up-build      - Build and start services"
	@echo "  make logs          - View all logs (follow mode)"
	@echo "  make logs-service SERVICE=name - View logs for specific service"
	@echo "  make ps            - Show running containers"
	@echo "  make clean         - Stop and remove containers, networks, volumes"
	@echo "  make prune         - Remove unused Docker resources"
	@echo "  make nginx-reload  - Reload nginx config (no downtime)"
	@echo "  make nginx-restart - Restart nginx container"
	@echo "  make shell-nginx   - Shell into nginx container"
	@echo "  make shell-npm     - Shell into nginx-proxy-manager container"
	@echo "  make shell-n8n     - Shell into n8n container"
	@echo "  make shell-pihole  - Shell into pihole container"
	@echo "  make shell-immich  - Shell into immich container"
	@echo "  make shell-homeassistant - Shell into homeassistant container"
