#!/bin/bash

# filepath: d:\my_study\cfn101-workshop\templates\bash_scripts\deploy_apigateways.sh

set -e

# Define variables
STACK_NAME_PREFIX="nx-vid"

API_GATEWAYS_DIR="templates/api-gateways"

echo $COMMIT_HASH

echo $BRANCH_NAME

# Deploy API Gateway stacks
if [ -d "$API_GATEWAYS_DIR" ]; then
  echo "Deploying API Gateway stacks..."
  if [ -f "$API_GATEWAYS_DIR/main_template.yml" ]; then
    STACK_NAME="${STACK_NAME_PREFIX}-api-gateway"
    TEMPLATE_FILE="$API_GATEWAYS_DIR/main_template.yml"
    aws cloudformation deploy \
      --template-file "$TEMPLATE_FILE" \
      --stack-name "$STACK_NAME" \
      --parameter-overrides EnvironmentType="$BRANCH_NAME"\
      --capabilities CAPABILITY_IAM
  else
    echo "No commit message file found in $API_GATEWAYS_DIR"
    exit 1
  fi
  for endpoint_dir in "$API_GATEWAYS_DIR"/*; do
    if [ -d "$endpoint_dir" ]; then
      ENDPOINT_NAME=$(basename "$endpoint_dir" | tr '[:upper:]' '[:lower:]')
      echo "Processing endpoint: $ENDPOINT_NAME"
      TEMPLATE_FILE="$endpoint_dir/main_template.yml"
      if [ -f "$TEMPLATE_FILE" ]; then
        sed -i "s/|COMMIT_HASH|/$COMMIT_HASH/g" $TEMPLATE_FILE
        STACK_NAME="${STACK_NAME_PREFIX}-${ENDPOINT_NAME}"
        aws cloudformation deploy \
          --template-file "$TEMPLATE_FILE" \
          --stack-name "$STACK_NAME" \
          --parameter-overrides EndPoint="$ENDPOINT_NAME" CommitMessage="$COMMIT_MESSAGE" EnvironmentType="$BRANCH_NAME"\
          --capabilities CAPABILITY_IAM
      else
        echo "No main_template.yml found in $endpoint_dir"
        exit 1
      fi
    fi
  done
else
  echo "API Gateways directory not found: $API_GATEWAYS_DIR"
  exit 1
fi

echo "All API Gateway stacks deployed successfully."