#!/usr/bin/env bash

set -euo pipefail

HOST_PORT="${HOST_PORT:-5000}"
HEALTH_URL="http://localhost:${HOST_PORT}/health"

echo "Checking application health at: $HEALTH_URL"

if curl --fail --silent --show-error "$HEALTH_URL"; then
  echo
  echo "Health check passed."
else
  echo
  echo "Health check failed."
  exit 1
fi
