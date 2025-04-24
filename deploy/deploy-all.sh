#!/bin/bash
set -e

# Config
FRONTEND_REPO="https://github.com/stevenjwiltse/ui-deploy.git"
BACKEND_REPO="https://github.com/stevenjwiltse/api-deploy.git"
DEPLOY_REPO="https://github.com/stevenjwiltse/barbershop-deploy.git"
FRONTEND_DIR=~/ui-deploy
BACKEND_DIR=~/api-deploy
DEPLOY_DIR=~/barbershop-deploy
NETWORK_NAME=barber-shop-network
DUCKDNS_DOMAIN="barbershop-app"
DUCKDNS_TOKEN="482f5ea2-70c4-43fc-8609-dbfa1ad09bd2" 

echo "Updating DuckDNS..."
curl "https://www.duckdns.org/update?domains=${DUCKDNS_DOMAIN}&token=${DUCKDNS_TOKEN}&ip="

echo "Ensuring Docker network exists: $NETWORK_NAME"
docker network inspect $NETWORK_NAME >/dev/null 2>&1 || docker network create $NETWORK_NAME

echo "Cleaning previous backend..."
rm -rf "$BACKEND_DIR"
git clone "$BACKEND_REPO" "$BACKEND_DIR"
docker compose -f "$BACKEND_DIR/docker-compose.yaml" down -v --remove-orphans || true

echo "Cleaning previous frontend..."
rm -rf "$FRONTEND_DIR"
git clone "$FRONTEND_REPO" "$FRONTEND_DIR"
docker compose -f "$FRONTEND_DIR/docker-compose.yaml" down -v --remove-orphans || true

echo "Pruning unused Docker images..."
docker image prune -f

echo "Building and starting backend..."
docker compose -f "$BACKEND_DIR/docker-compose.yaml" up -d --build

echo "Waiting for Keycloak to start..."
sleep 20

echo "Building frontend..."
cd "$FRONTEND_DIR"
npm install
npm run build
mkdir -p frontend-dist
cp -r dist/* frontend-dist/

echo "Deploying frontend..."
docker compose -f "$FRONTEND_DIR/docker-compose.yaml" up -d --build

echo "Deployment complete. Active containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"
