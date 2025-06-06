#!/bin/bash

# filepath: d:\my_study\cfn101-workshop\templates\bash_scripts\deploy_apigateways.sh

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

deploy_api_gateways() {
  local dir_path="$1"
  local parent_name="$2"
  local path="$3"

  for item in "$dir_path"/*; do
    if [ -d "$item" ]; then
      echo "Processing item: $item"
      local item_name=$(basename "$item" | tr '[:upper:]' '[:lower:]')

      # Check if the directory contains a "src" folder (indicating a Lambda function)
      if [ -d "$item/src" ]; then
        # Combine parent name and current item name for unique function identification
        local function_name="$item_name-$parent_name"
        function_name=$(remove_all_braces "$function_name")
        Method="$item_name"

        echo "Path: $path"
        echo "Function name: $function_name"
        echo "Method: $Method"
        sed -i "s/|COMMIT_HASH|/$COMMIT_HASH/g" "$item/template.yml"
        aws cloudformation deploy \
          --template-file "$item/template.yml" \
          --stack-name "${STACK_NAME_PREFIX}-$function_name-stack" \
          --parameter-overrides MethodAPI="$Method" CommitMessage="$COMMIT_MESSAGE" EnvironmentType="$BRANCH_NAME" \
            LambdaFunctionFileName="$function_name" \
          --capabilities CAPABILITY_IAM 
          
      else
        # Recursively process subdirectories
        deploy_api_gateways "$item" "${parent_name:+$parent_name-}$item_name" "${path:+$path/}$item_name"
      fi
    fi
  done
}

deploy_api_gateways "$API_GATEWAYS_DIR" "$FOLDER_NAME" "$FOLDER_NAME"

# echo "All API Gateway stacks deployed successfully."