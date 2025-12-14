# Home Server

A Docker Compose-based home server setup for running self-hosted applications with a reverse proxy.

## Overview

This repository provides a simple way to manage multiple self-hosted services on a home server. All services are containerized using Docker and orchestrated via Docker Compose, with nginx serving as the reverse proxy to route traffic to each service via subdomains.

## Prerequisites

- Docker
- Docker Compose
- Make

## Getting Started

### Initial Setup

1. **Configure environment variables** (required for GitHub Container Registry):
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and set:
   - `GITHUB_USERNAME`: Your GitHub username
   - `GITHUB_TOKEN`: GitHub Personal Access Token with `read:packages` scope
   - `GITHUB_REPOSITORY`: Your repository name (e.g., `ofrymakdasy/home-server`)

2. **Start all services**:
   ```bash
   # Start all services
   make up

   # Start with rebuild
   make up-build

   # View available commands
   make help
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

## Project Structure

```
.
├── docker-compose.yml    # Main service definitions
├── Makefile              # Convenience commands
├── .env                  # Environment variables (gitignored)
├── .env.example          # Example environment variables
├── apps/                 # Service-specific configurations
│   └── <service>/        # Config files for each service
└── data/                 # Persistent data volumes (gitignored)
```

## Automatic Updates with Watchtower

This setup includes [Watchtower](https://containrrr.dev/watchtower/) to automatically update Docker images from GitHub Container Registry.

### How It Works

1. **GitHub Actions CI/CD**: On every commit to `main`, custom Docker images (`n8n`, `code-server`) are automatically built and pushed to GitHub Container Registry (GHCR)
2. **Watchtower Monitoring**: Watchtower checks for new images every 5 minutes (300 seconds)
3. **Automatic Updates**: When a new image is detected, Watchtower:
   - Pulls the new image
   - Gracefully stops the old container
   - Starts a new container with the updated image
   - Cleans up old images

### Configuration

- **Poll Interval**: 300 seconds (5 minutes) - configurable via `WATCHTOWER_POLL_INTERVAL`
- **Cleanup**: Automatically removes old images after update
- **Rolling Restart**: Updates one container at a time to minimize downtime
- **Notifications**: Optional - configure `WATCHTOWER_NOTIFICATION_URL` in `.env` for update notifications

### GitHub Container Registry

Custom images are available at:
- `ghcr.io/${GITHUB_REPOSITORY}/n8n:latest`
- `ghcr.io/${GITHUB_REPOSITORY}/code-server:latest`

To create a GitHub Personal Access Token:
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `read:packages` scope
3. Add it to your `.env` file as `GITHUB_TOKEN`

**Note**: GitHub Container Registry packages are private by default. To make them public:
1. Go to your GitHub repository → Packages
2. Select the package (n8n or code-server)
3. Package settings → Change visibility → Public

Alternatively, keep them private and ensure your `.env` has valid `GITHUB_USERNAME` and `GITHUB_TOKEN` for authentication.

## Adding a New Service

1. Add the service definition to `docker-compose.yml`
2. Create a directory under `apps/<service>` for any custom configs
3. Configure the reverse proxy to route traffic to the new service
4. Run `make up` to start the updated stack

## SSO with Authentik

This homelab includes [Authentik](https://goauthentik.io/) for centralized authentication and Single Sign-On (SSO) across services.

### First-Time Setup

1. Start the services: `make up`
2. Access Authentik at: `http://your-server/authentik/`
3. Complete the initial setup wizard and create an admin account
4. **IMPORTANT**: Generate a secure secret key and update `docker-compose.yml`:
   ```bash
   openssl rand -base64 50
   ```
   Update `AUTHENTIK_SECRET_KEY` for both `authentik-server` and `authentik-worker`

### Supported Services

Services with native OIDC/OAuth2 support:
- Nextcloud
- Jellyfin
- Portainer
- Ghostfolio
- Immich
- Home Assistant
- Uptime Kuma
- Penpot

Services requiring forward auth (Pi-hole, Code Server, Pulse) can be protected using:
- Traefik ForwardAuth middleware (recommended)
- Nginx auth_request directive

### Configuration

See `apps/authentik/README.md` for detailed setup instructions for each service.

### Local DNS Configuration

Get you device IP:
```
ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null
```

Add pi-hole as a DNS server:
```
sudo networksetup -setdnsservers Wi-Fi 192.168.1.100
```

