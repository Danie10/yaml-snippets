#!/bin/bash
set -euo pipefail

PROJECT_DIR="/opt/docker/zer0"

echo "Moving into project directory..."
cd "$PROJECT_DIR"

echo "Pulling latest code from GitHub (main)..."
git pull origin main

echo "Rebuilding and restarting the stack..."
docker compose up -d --build

echo "Pruning dangling images..."
docker image prune -f

echo "zer0 stack updated and running."
