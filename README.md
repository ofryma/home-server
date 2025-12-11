# Home Server

A Docker Compose-based home server setup for running self-hosted applications with a reverse proxy.

## Overview

This repository provides a simple way to manage multiple self-hosted services on a home server. All services are containerized using Docker and orchestrated via Docker Compose, with nginx serving as the reverse proxy to route traffic to each service via subdomains.

## Prerequisites

- Docker
- Docker Compose
- Make

## Getting Started

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
├── apps/                 # Service-specific configurations
│   └── <service>/        # Config files for each service
└── data/                 # Persistent data volumes (gitignored)
```

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

