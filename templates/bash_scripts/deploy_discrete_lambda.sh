#!/bin/bash

# set -e

# Define variables
STACK_NAME_PREFIX="nx-vid"

FOLDER_NAME="$1"
API_GATEWAYS_DIR="templates/lambda_function/$FOLDER_NAME"

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

deploy_lambda_alias(){
  local dir_path="$1"
  local parent_name="$2"
  local path="$3"
  if [ -f "$dir_path/lambda_function.yml" ]; then
    echo "Processing item: $dir_path"
    local function_name=$(basename "$dir_path" | tr '[:upper:]' '[:lower:]')
    echo "Function name: $function_name"
    echo "Path: $path"
    # Check if the directory contains a "src" folder (indicating a Lambda function)"
      
    # # deploy lambda alias, versioning
    # aws cloudformation deploy \
    # --template-file "$dir_path/lambda_function.yml" \
    # --stack-name "${STACK_NAME_PREFIX}-$function_name-alias-stack-$BRANCH_NAME" \
    # --parameter-overrides CommitMessage="$COMMIT_MESSAGE" EnvironmentType="$BRANCH_NAME" \
    #     LambdaFunctionFileName="$function_name" \
    # --capabilities CAPABILITY_IAM   
        
  else
      # Recursively process subdirectories
      for item in "$dir_path"/*; do
        if [ -d "$item" ]; then
            echo "Processing item: $item"
            local item_name=$(basename "$item" | tr '[:upper:]' '[:lower:]')
            # Recursively process subdirectories
            deploy_lambda_alias "$item" "${parent_name:+$parent_name-}$item_name" "${path:+$path/}$item_name"
        fi
      done
  fi
}

deploy_lambda_alias "$API_GATEWAYS_DIR" "$FOLDER_NAME" "$FOLDER_NAME"