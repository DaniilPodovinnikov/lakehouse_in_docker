#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$ROOT_DIR/.env"


if [ -f "$ENV_FILE" ]; then
. "$ENV_FILE"
fi

TRINO_ADMIN_USER="${TRINO_ADMIN_USER}"
TRINO_ADMIN_PASS="${TRINO_ADMIN_PASS}"

TRINO_READER_USER="${TRINO_READER_USER}"
TRINO_READER_PASS="${TRINO_READER_PASS}"


PASSWORD_DB="$SCRIPT_DIR/password.db"

echo "Generating bcrypt password hash for users: $TRINO_ADMIN_USER, $TRINO_READER_USER"
echo "Output file: $PASSWORD_DB"

htpasswd -B -C 10 -b -c "$PASSWORD_DB" "$TRINO_ADMIN_USER" "$TRINO_ADMIN_PASS"
htpasswd -B -C 10 -b "$PASSWORD_DB" "$TRINO_READER_USER" "$TRINO_READER_PASS"

chmod 600 "$PASSWORD_DB"
echo "password.db created successfully."