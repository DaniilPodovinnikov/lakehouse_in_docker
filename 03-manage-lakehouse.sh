#!/usr/bin/env bash
set -euo pipefail

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    HOST_IP=$(ipconfig getifaddr $(route get default | grep interface | awk '{print $2}'))
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    HOST_IP=$(hostname -I | awk '{print $1}')
fi
echo "HOST_IP is: $HOST_IP"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

load_env() {
  if [ -f "$SCRIPT_DIR/.env" ]; then
    . "$SCRIPT_DIR/.env"
  fi
}

start_services() {
  echo "Starting lakehouse services..."

  docker compose -p lakehouse \
      -f docker-compose-postgres.yaml \
      -f docker-compose-lake.yaml \
      -f docker-compose-trino.yaml \
      -f docker-compose-spark-notebook.yaml up -d

  load_env

  echo
  echo "============================================================"
  echo " LAKEHOUSE STARTED"
  echo "============================================================"
  echo "Polaris console:"
  echo "  URL:      http://${HOST_IP}:8081"
  echo "  User:     ${POLARIS_USERNAME}"
  echo "  Password: ${POLARIS_PASSWORD}"
  echo
  echo "MinIO:"
  echo "  URL:      http://${HOST_IP}:9001"
  echo "  User:     ${MINIO_ROOT_USER}"
  echo "  Password: ${MINIO_ROOT_PASSWORD}"
  echo
  echo "Jupyter:"
  echo "  URL:      http://${HOST_IP}:8888"
  echo "  Token:    ${JUPYTER_TOKEN}"
  echo
  echo "SparkUI:"
  echo "  URL:      http://${HOST_IP}:4040"
  echo
  echo "Trino Coordinator:"
  echo "  URL:      https://${HOST_IP}:${TRINO_PORT}"
  echo "  User:     ${TRINO_ADMIN_USER}"
  echo "  Password: ${TRINO_ADMIN_PASS}"
  echo "  User:     ${TRINO_READER_USER}"
  echo "  Password: ${TRINO_READER_PASS}"
  echo
  echo "============================================================"
}

init_polaris() {
  load_env

  echo "Starting polaris-bootstrap..."

  docker compose -p lakehouse -f docker-compose-polaris-bootstrap.yaml up -d

  sleep 10
  docker logs polaris_bootstrap

  echo "Create catalog ${POLARIS_CATALOG_NAME} and roles"
  ./polaris/create_catalog.sh

  docker compose -p lakehouse -f docker-compose-polaris-bootstrap.yaml down -v
}

stop_services() {
  echo "Stopping lakehouse services..."

  cd "$SCRIPT_DIR"

  docker compose -p lakehouse \
    -f docker-compose-postgres.yaml \
    -f docker-compose-trino.yaml \
    -f docker-compose-lake.yaml \
    -f docker-compose-polaris-bootstrap.yaml \
    -f docker-compose-spark-notebook.yaml down -v

  echo "Services stopped"
}

status_services() {
  echo "Lakehouse containers:"
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" \
    | grep -E "minio|polaris|trino|postgres|spark-notebook" || true
}

case "${1:-}" in
  start)
    start_services
    ;;
  stop)
    stop_services
    ;;
  status)
    status_services
    ;;
  init)
    init_polaris
    ;;
  *)
    echo "Usage: $0 {start|stop|satus|init}"
    exit 1
    ;;
esac
