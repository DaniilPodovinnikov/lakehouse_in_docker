#!/bin/bash

docker compose -p lakehouse -f docker-compose-postgres.yml \
  -f docker-compose-bootstrap-db.yml \
  -f docker-compose.yml \
  -f docker-compose-spark-notebook.yml up -d

source polaris/create_catalog.sh