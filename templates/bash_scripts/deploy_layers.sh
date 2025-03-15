#!/bin/bash

# filepath: d:\my_study\cfn101-workshop\templates\layers\deploy_layers.sh

set -e

# Define variables
LAYERS_DIR="templates/layers"
S3_BUCKET="my-bucket-bucket"

echo "Deploying all Lambda layers in the layers folder..."

# Iterate through each subdirectory in the layers folder
for layer_dir in "$LAYERS_DIR"/*; do
  if [ -d "$layer_dir" ]; then
    TEMPLATE_FILE="$layer_dir/layer.yml"
    LAYER_NAME=$(basename "$layer_dir")
    STACK_NAME="${LAYER_NAME}-layer-stack"

    if [ -f "$TEMPLATE_FILE" ]; then
      echo "Deploying Lambda Layer: $LAYER_NAME"

      # Validate the CloudFormation template
      echo "Validating template for $LAYER_NAME..."
      aws cloudformation validate-template --template-body file://"$TEMPLATE_FILE"

      # Deploy the CloudFormation stack
      echo "Deploying stack for $LAYER_NAME..."
      aws cloudformation deploy \
        --template-file "$TEMPLATE_FILE" \
        --stack-name "$STACK_NAME" \
        --capabilities CAPABILITY_NAMED_IAM

      echo "Lambda Layer $LAYER_NAME deployed successfully."
    else
      echo "No layer.yml found in $layer_dir. Skipping..."
    fi
  fi
done

echo "All Lambda layers deployed successfully."