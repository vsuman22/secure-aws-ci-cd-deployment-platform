#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HEALTH_URL="http://localhost:${HOST_PORT:-5000}/health"
MAX_ATTEMPTS=10
SLEEP_SECONDS=3

cd "$PROJECT_ROOT"

echo "Starting local deployment..."
docker compose up -d --build

echo "Waiting for application health check..."

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  if curl --fail --silent --show-error "$HEALTH_URL"; then
    echo
    echo "Deployment successful: application is healthy."
    exit 0
  fi

  echo "Health check attempt $attempt/$MAX_ATTEMPTS failed. Retrying in ${SLEEP_SECONDS}s..."
  sleep "$SLEEP_SECONDS"
done

echo "Deployment failed: application did not become healthy."
docker compose ps
docker compose logs --tail=50 app || true
exit 1
