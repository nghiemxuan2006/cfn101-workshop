FUNCTION_DIR="$1"

FOLDER_NAME=$(basename "$FUNCTION_DIR" | tr '[:upper:]' '[:lower:]')
S3_BUCKET="my-bucket-bucket"

remove_all_braces() {
    local input="$1"
    local output
    output=$(echo "$input" | sed 's/{\([^}]*\)}/\1/g')
    echo "$output"
}


# Function to recursively process directories
process_directory() {
  local dir_path="$1"
  local parent_name="$2"

  if [ -d "$dir_path/src" ]; then
    # If the current directory contains a "src" folder, process it
    local function_name=$(remove_all_braces "$parent_name")

    echo "Processing function: $function_name"

    # Package the Lambda function
    cd "$dir_path/src"
    zip -r "${function_name}-$COMMIT_HASH.zip" .
    cd - > /dev/null

    # Upload the packaged function to S3
    echo "Uploading function: $function_name"
    aws s3 cp "$dir_path/src/${function_name}-$COMMIT_HASH.zip" "s3://$S3_BUCKET/lambda-functions/"
  else
    for item in "$dir_path"/*; do
      if [ -d "$item" ]; then
        local item_name=$(basename "$item" | tr '[:upper:]' '[:lower:]')
        # Recursively process subdirectories
        process_directory "$item" "${parent_name:+$parent_name-}$item_name"
      fi
    done
  fi
}

# Start processing from the root FUNCTION_DIR
process_directory "$FUNCTION_DIR" "$FOLDER_NAME"