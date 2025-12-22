#!/usr/bin/env bash
set -euo pipefail

REPO="$PWD"
ENV_FILE="${REPO}/.env"

if [ ! -d "$REPO" ]; then
  echo "ERROR: Lakehouse repo not found at: $REPO"
  echo "Set LAKEHOUSE_HOME or run clone script first."
  exit 1
fi

cd "$REPO"

random_hex() {
  openssl rand -hex 4
}

echo "Generating new .env at ${ENV_FILE}..."

cat > "$ENV_FILE" <<EOF
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=$(random_hex)
MINIO_BUCKET=warehouse

TRINO_USERNAME=trino
TRINO_PASSWORD=$(random_hex)
TRINO_PORT=443
TRINO_INTERNAL_SECRET=$(random_hex)

POLARIS_USERNAME=polaris
POLARIS_PASSWORD=$(random_hex)
POLARIS_CATALOG_NAME=demo_catalog

JUPYTER_TOKEN=$(random_hex)

QUARKUS_DATASOURCE_JDBC_URL=jdbc:postgresql://postgres:5432/POLARIS
QUARKUS_DATASOURCE_USERNAME=postgres
QUARKUS_DATASOURCE_PASSWORD=$(random_hex)
EOF

echo ".env created at ${ENV_FILE}"