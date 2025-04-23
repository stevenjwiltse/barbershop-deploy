#!/bin/bash
set -e

FRONTEND_DIR=~/frontend-deploy
BACKEND_DIR=~/api-deploy
NETWORK_NAME=barber-shop-network

echo "Cleaning up previous containers..."
docker compose -f "$FRONTEND_DIR/docker-compose.yaml" down || true
docker compose -f "$BACKEND_DIR/docker-compose.yaml" down || true

echo "Recreating Docker network: $NETWORK_NAME"
docker network rm $NETWORK_NAME || true
docker network create --driver bridge $NETWORK_NAME

echo "Starting backend..."
docker compose -f "$BACKEND_DIR/docker-compose.yaml" up -d --build

echo "Starting frontend..."
docker compose -f "$FRONTEND_DIR/docker-compose.yaml" up -d --build

docker ps --format "table {{.Names}}\t{{.Status}}"
