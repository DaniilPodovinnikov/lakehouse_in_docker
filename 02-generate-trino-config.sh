#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -d "$SCRIPT_DIR/trino_config/worker" ]; then
    mkdir "$SCRIPT_DIR/trino_config/worker"
fi
if [ ! -d "$SCRIPT_DIR/trino_config/coordinator" ]; then
    mkdir "$SCRIPT_DIR/trino_config/coordinator"
fi

for script in create-password-db.sh generate-configs.sh create-selfsigned.sh; do
  if [ -f "$SCRIPT_DIR/trino_config/$script" ] && [ ! -x "$SCRIPT_DIR/trino_config/$script" ]; then
    chmod +x "$SCRIPT_DIR/trino_config/$script"
  fi
done

load_env() {
  if [ -f "$SCRIPT_DIR/.env" ]; then
    . "$SCRIPT_DIR/.env"
  fi
}


echo "Starting generate trino configs..."

cd "$SCRIPT_DIR"

load_env

if [ -x "./trino_config/generate-configs.sh" ]; then
./trino_config/generate-configs.sh
fi

if [ -x "./trino_config/create-password-db.sh" ]; then
./trino_config/create-password-db.sh
fi

if [ -x "./trino_config/create-selfsigned.sh" ]; then
./trino_config/create-selfsigned.sh
fi

