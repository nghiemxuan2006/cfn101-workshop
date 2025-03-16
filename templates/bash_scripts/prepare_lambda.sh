FUNCTION_DIR="templates/api-gateways"
S3_BUCKET="my-bucket-bucket"

# Package and upload Lambda functions
for function in "$FUNCTION_DIR"/*; do
  if [ -d "$function" ]; then
    function_name=$(basename "$function")
    for method in "$function"/*; do
      if [ -d "$method" ]; then
        method_name=$(basename "$method" | tr '[:upper:]' '[:lower:]')
        echo "Packaging function: $function_name"
        echo "Packaging method: $method_name"

        # Package the Lambda function
        cd "$method/src"
        zip -r "${method_name}-${function_name}.zip" .
        cd - > /dev/null

        # Upload the packaged function to S3
        echo "Uploading function: $function_name"
        echo "Uploading method: $method_name"
        aws s3 cp "$method/${method_name}-${function_name}.zip" "s3://$S3_BUCKET/lambda-functions/"
      fi
    done
  fi
done