#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_ROOT"

echo "Stopping local Docker Compose deployment..."
docker compose down --remove-orphans

echo "Local deployment stopped and Compose resources removed."
