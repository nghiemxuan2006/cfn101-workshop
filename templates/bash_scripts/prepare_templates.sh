#!/bin/bash

set -e

# Define variables
STACK_NAME_PREFIX="nx-vid"
API_GATEWAYS_DIR="templates/api-gateways"

echo $COMMIT_HASH
echo $BRANCH_NAME

# Deploy API Gateway stacks
if [ -d "$API_GATEWAYS_DIR" ]; then
  echo "Deploying API Gateway stacks..."
  
  # Find all template.yml files recursively
  find "$API_GATEWAYS_DIR" -type f -name "template.yml" | while read -r TEMPLATE_FILE; do
    # Extract endpoint and method names from the directory structure
    ENDPOINT_NAME=$(basename "$(dirname "$TEMPLATE_FILE")" | tr '[:upper:]' '[:lower:]')
    METHOD_NAME=$(basename "$(dirname "$(dirname "$TEMPLATE_FILE")")" | tr '[:upper:]' '[:lower:]')

    echo "Deploying API Gateway stack for endpoint '$ENDPOINT_NAME' and method '$METHOD_NAME'..."
    echo $TEMPLATE_FILE
    # Replace placeholder in the template file
    sed -i "s/|COMMIT_HASH|/$COMMIT_HASH/g" "$TEMPLATE_FILE"

    # Upload the template file to S3
    # aws s3 cp "$TEMPLATE_FILE" "s3://$S3_BUCKET_NAME/$STACK_NAME_PREFIX/$TEMPLATE_FILE"
  done
else
  echo "API Gateways directory not found: $API_GATEWAYS_DIR"
  exit 1
fi

echo "All Template files is uploaded successfully."