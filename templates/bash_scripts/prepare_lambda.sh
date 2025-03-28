FUNCTION_DIR="templates/api-gateways"
S3_BUCKET="my-bucket-bucket"

# Function to recursively process directories
process_directory() {
  local dir_path="$1"
  local parent_name="$2"

  for item in "$dir_path"/*; do
    if [ -d "$item" ]; then
      local item_name=$(basename "$item" | tr '[:upper:]' '[:lower:]')

      # Check if the directory contains a "src" folder (indicating a Lambda function)
      if [ -d "$item/src" ]; then
        # Combine parent name and current item name for unique function identification
        local function_name="$item_name-$parent_name"

        echo "Packaging function: $function_name"

        # Package the Lambda function
        cd "$item/src"
        zip -r "${function_name}-$COMMIT_HASH.zip" .
        cd - > /dev/null

        # Upload the packaged function to S3
        echo "Uploading function: $function_name"
        aws s3 cp "$item/src/${function_name}-$COMMIT_HASH.zip" "s3://$S3_BUCKET/lambda-functions/"
      else
        # Recursively process subdirectories
        process_directory "$item" "${parent_name:+$parent_name-}$item_name"
      fi
    fi
  done
}

# Start processing from the root FUNCTION_DIR
process_directory "$FUNCTION_DIR"