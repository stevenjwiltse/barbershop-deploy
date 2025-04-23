#!/bin/bash
set -e

FRONTEND_DIR=~/frontend-deploy

echo "Rebuilding frontend containers..."
docker compose -f "$FRONTEND_DIR/docker-compose.yaml" down || true
docker compose -f "$FRONTEND_DIR/docker-compose.yaml" up -d --build
