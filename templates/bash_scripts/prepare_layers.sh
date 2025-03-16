#!/bin/bash

set -e

LAYER_DIR="templates/layers"
S3_BUCKET="my-bucket-bucket"

# Iterate through all layer directories
for layer in "$LAYER_DIR"/*; do
  if [ -d "$layer" ]; then
    layer_name=$(basename "$layer")
    echo "Packaging layer: $layer_name"

    # Install dependencies and package the layer
    cd "$layer"
    pip install -r requirements.txt -t python
    zip -r "${layer_name}-layer.zip" python
    cd - > /dev/null

    # Upload the packaged layer to S3
    echo "Uploading layer: $layer_name"
    aws s3 cp "$layer/${layer_name}-layer.zip" "s3://$S3_BUCKET/layers/"
  fi
done