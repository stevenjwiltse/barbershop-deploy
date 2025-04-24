#!/bin/bash
set -e

echo "Stopping all Docker containers..."
docker stop $(docker ps -aq) || true

echo "Removing all Docker containers..."
docker rm $(docker ps -aq) || true

echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q) || true

echo "Removing all custom Docker networks (except default ones)..."
docker network ls | grep -v "bridge\|host\|none" | awk '{print $1}' | xargs -r docker network rm || true

echo "Deleting old cloned project directories..."
rm -rf ~/ui-deploy ~/api-deploy ~/frontend-deploy ~/backend ~/frontend ~/deploy-folder

echo "Keeping barbershop-deploy folder intact."

echo "Full clean reset complete."
