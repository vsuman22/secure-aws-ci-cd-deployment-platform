#!/usr/bin/env bash
set -Eeuo pipefail

IMAGE_TAG="${1:-}"

if [[ -z "$IMAGE_TAG" ]]; then
  echo "ERROR: Usage: $0 <image-tag>"
  exit 1
fi

if [[ ! "$IMAGE_TAG" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
  echo "ERROR: Invalid image tag: $IMAGE_TAG"
  exit 1
fi

DEPLOY_DIR="/opt/secure-devops-platform/app"
COMPOSE_FILE="compose.production.yaml"
HEALTH_URL="http://127.0.0.1/health"
MAX_ATTEMPTS=12
SLEEP_SECONDS=5

cd "$DEPLOY_DIR"

export APP_VERSION="$IMAGE_TAG"

echo "Deploying image version: $APP_VERSION"

docker compose -f "$COMPOSE_FILE" pull app
docker compose -f "$COMPOSE_FILE" up -d --remove-orphans app

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  if curl --fail --silent --show-error "$HEALTH_URL" > /dev/null; then
    echo "SUCCESS: Deployment healthy for image version $APP_VERSION"
    docker compose -f "$COMPOSE_FILE" ps
    exit 0
  fi

  echo "Health check attempt $attempt/$MAX_ATTEMPTS failed. Retrying in $SLEEP_SECONDS seconds..."
  sleep "$SLEEP_SECONDS"
done

echo "ERROR: Deployment failed health checks for image version $APP_VERSION"
docker compose -f "$COMPOSE_FILE" ps || true
docker compose -f "$COMPOSE_FILE" logs --tail=100 app || true
exit 1
