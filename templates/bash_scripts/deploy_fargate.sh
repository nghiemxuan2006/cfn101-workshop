FUNCTION_DIR="$1"

FOLDER_NAME=$(basename "$FUNCTION_DIR" | tr '[:upper:]' '[:lower:]')
# Define variables
S3_BUCKET="my-bucket-bucket"
STACK_NAME_PREFIX="nx-vid-ecs-td"

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

  if [ -f "$dir_path/template.yml" ]; then
    # If the current directory contains a "src" folder, process it
    local function_name=$(remove_all_braces "$parent_name")

    echo "Processing function: $function_name"
    # deploy task definition
    aws cloudformation deploy \
    --template-file "$dir_path/template.yml" \
    --stack-name "${STACK_NAME_PREFIX}-$function_name-$BRANCH_NAME-stack" \
    --parameter-overrides EnvironmentType="${{ env.BRANCH_NAME }}" \
        FolderName="$function_name" \
    --capabilities CAPABILITY_IAM
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