
This is a hosting configuration to share services with friends and family, using automatic HTTPS, private networking, and containerized services.

## Components

* **[Caddy](https://caddyserver.com/)** — Reverse proxying, automatic HTTPS via Cloudflare.
* **[Cloudflare](https://www.cloudflare.com/)** — DNS and SSL certificates with API tokens.
* **[Tailscale](https://tailscale.com/)** — Creating a private mesh network to access the server.
* **[Docker](https://www.docker.com/)** — Runs services in isolation.

## Features

* Encrypted reverse proxy using Cloudflare DNS & TLS
* Remote access via Tailscale
* Dockerized apps

## Prerequisites
- A domain managed by Cloudflare

---
# Installation
1. Clone the repo.
2. Register a domain or point Cloudflare to your existing domain.

## Install Caddy with Cloudflare

1. Install Caddy with [Cloudflare wrapper](https://caddyserver.com/docs/modules/dns.providers.cloudflare) or install caddyx with Cloudflare DNS provider plugin
```bash
sudo apt install git golang-go -y   # if Go is not installed
git clone https://github.com/caddyserver/xcaddy.git
cd xcaddy
go install

# Build Caddy with Cloudflare module
xcaddy build --with github.com/caddy-dns/cloudflare
sudo mv caddy /usr/local/bin/caddy
sudo chmod +x /usr/local/bin/caddy
```

2. Create environment file
```bash
sudo mkdir -p /etc/caddy
sudo nano /etc/caddy/env
```

3. Use service file from repo
```bash
sudo cp caddy/caddy.service /etc/systemd/system/
sudo systemctl enable --now caddy
```

4. Create a /etc/caddy/[Caddyfile](./Caddyfile)

5. Get a [CloudFlare API token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/) and place it here. 

6. Reload systemd and restart Caddy
```bash
sudo systemctl daemon-reexec
sudo systemctl restart caddy
sudo systemctl status caddy
```

Monitor Caddy with `journalctl -u caddy -f`

## Install Tailscale, Docker and Docker Compose
```bash
sudo apt update
sudo apt install -y tailscale docker.io docker-compose
```

Start Tailscale and create a tailnet
```bash
sudo systemctl enable --now tailscaled
sudo tailscale up --ssh --accept-routes
```

## Point the subdomain to the Tailnet   
1. Create a Cloudflare API token for `/etc/caddy/env`.
2. Create a DNS CNAME record and specify subdomain, the full tailnet server address and choose `DNS only`.  
