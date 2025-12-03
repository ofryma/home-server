# Home Server

A collection of self-hosted applications running via Docker Compose with nginx as a reverse proxy.

## Services

| Service | Description | URL |
|---------|-------------|-----|
| **nginx** | Reverse proxy | `localhost` |
| **n8n** | Workflow automation platform | `n8n.localhost` |
| **nextcloud** | Cloud storage & file sync | `nextcloud.localhost` |
| **uptime-kuma** | Uptime monitoring dashboard | `uptime-kuma.localhost` |
| **immich** | Photo & video backup | `immich.localhost` |
| **homeassistant** | Home automation | `homeassistant.localhost` |
| **jellyfin** | Media server | `jellyfin.localhost` |
| **pihole** | Network-wide ad blocker | `pihole.localhost` |
| **code-server** | VS Code in the browser | `code-server.localhost` |

## Getting Started

```bash
# Start all services
make up

# Start with rebuild
make up-build
```

## Commands

| Command | Description |
|---------|-------------|
| `make up` | Start all services |
| `make down` | Stop all services |
| `make restart` | Restart all services |
| `make build` | Build/rebuild services |
| `make up-build` | Build and start services |
| `make logs` | View all logs (follow mode) |
| `make logs-service SERVICE=<name>` | View logs for specific service |
| `make ps` | Show running containers |
| `make clean` | Stop and remove containers, networks, volumes |
| `make prune` | Remove unused Docker resources |
| `make nginx-reload` | Reload nginx configuration |
| `make nginx-test` | Test nginx configuration |

## Shell Access

```bash
make shell-nginx
make shell-n8n
make shell-pihole
make shell-immich
make shell-homeassistant
```
