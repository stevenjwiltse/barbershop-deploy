#!/bin/bash
set -e

BACKEND_DIR=~/api-deploy

echo "Rebuilding backend containers..."
docker compose -f "$BACKEND_DIR/docker-compose.yaml" down || true
docker compose -f "$BACKEND_DIR/docker-compose.yaml" up -d --build
