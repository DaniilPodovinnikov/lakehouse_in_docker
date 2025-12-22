#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

. "$ROOT_DIR/.env"

POLARIS_USERNAME=$POLARIS_USERNAME
POLARIS_PASSWORD=$POLARIS_PASSWORD
POLARIS_CATALOG_NAME=$POLARIS_CATALOG_NAME


ACCESS_TOKEN=$(curl -X POST \
  http://localhost:8181/api/catalog/v1/oauth/tokens \
  -d "grant_type=client_credentials&client_id=${POLARIS_USERNAME}&client_secret=${POLARIS_PASSWORD}&scope=PRINCIPAL_ROLE:ALL" \
  | jq -r '.access_token')


curl -i -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  http://localhost:8181/api/management/v1/catalogs \
  --json '{
    "name": "'$POLARIS_CATALOG_NAME'",
    "type": "INTERNAL",
    "properties": {
      "default-base-location": "s3://warehouse"
    },
    "storageConfigInfo": {
      "roleArn": "arn:aws:iam::000000000000:role/minio-polaris-role",
        "storageType": "S3",
        "allowedLocations": ["s3://warehouse/*"],
        "region": "us-east-1",
        "endpoint": "http://minio:9000",
        "pathStyleAccess": true,
        "stsUnavailable": true
    }
  }'

  # Create a catalog admin role
curl -X PUT http://localhost:8181/api/management/v1/catalogs/$POLARIS_CATALOG_NAME/catalog-roles/catalog_admin/grants \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"grant":{"type":"catalog", "privilege":"CATALOG_MANAGE_CONTENT"}}'

# Create a data engineer role
curl -X POST http://localhost:8181/api/management/v1/principal-roles \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"principalRole":{"name":"data_engineer"}}'

# Connect the roles
curl -X PUT http://localhost:8181/api/management/v1/principal-roles/data_engineer/catalog-roles/$POLARIS_CATALOG_NAME \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"catalogRole":{"name":"catalog_admin"}}'

# Give root the data engineer role
curl -X PUT http://localhost:8181/api/management/v1/principals/root/principal-roles \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  --json '{"principalRole": {"name":"data_engineer"}}'


echo "Done."