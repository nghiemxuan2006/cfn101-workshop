#!/bin/bash

# set -e

# Define variables
STACK_NAME_PREFIX="nx-vid"

FOLDER_NAME="$1"
API_GATEWAYS_DIR="templates/api-gateways/$FOLDER_NAME"

echo $COMMIT_HASH

echo $BRANCH_NAME

# Method 1: Using sed and tr
convert_to_camel_case() {
    local kebab_string="$1"
    # First capitalize each part after splitting by dash
    local camel_case=$(echo "$kebab_string" | sed -r 's/(^|-)([a-z])/\U\2/g' | tr -d '-')
    echo "$camel_case"
}

remove_all_braces() {
    local input="$1"
    local output
    output=$(echo "$input" | sed 's/{\([^}]*\)}/\1/g')
    echo "$output"
}

deploy_endpoint(){
  local dir_path="$1"
  local parent_name="$2"
  local path="$3"
  for item in "$dir_path"/*; do
    if [ -f "$item" ] && [ "$(basename "$item")" == "main_template.yml" ]; then
      TEMPLATE_FILE="$item"
      STACK_NAME="${STACK_NAME_PREFIX}-$parent_name-stack"
      echo "stack name: $STACK_NAME"
      echo "Path: $path"
      aws cloudformation deploy \
        --template-file "$TEMPLATE_FILE" \
        --stack-name "$STACK_NAME" \
        --parameter-overrides EndPoint="$path" CommitMessage="$COMMIT_MESSAGE" EnvironmentType="$BRANCH_NAME"\
        --capabilities CAPABILITY_IAM
    else
      if [ -d "$item" ]; then
        echo "Processing item: $item"
        local item_name=$(basename "$item" | tr '[:upper:]' '[:lower:]')
        # Recursively process subdirectories
        deploy_endpoint "$item" "${parent_name:+$parent_name-}$item_name" "${path:+$path/}$item_name"
      fi
    fi
  done
}

deploy_endpoint "$API_GATEWAYS_DIR" "$FOLDER_NAME" "$FOLDER_NAME"