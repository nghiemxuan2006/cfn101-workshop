import json
import logging
import os
from datetime import datetime, timezone

import boto3

# Set up logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")
BUCKET_NAME = os.environ["BUCKET_NAME"]


def handler(event, context):
    """
    Lambda function handler running in a private VPC.
    Writes the event to S3 (via the S3 Gateway VPC Endpoint) and lists objects.

    Parameters:
    - event: The invocation event
    - context: The Lambda context object

    Returns:
    - Dictionary with statusCode and body
    """
    logger.info("Received event: %s", json.dumps(event))

    try:
        key = f"events/{datetime.now(timezone.utc).isoformat()}.json"
        s3.put_object(Bucket=BUCKET_NAME, Key=key, Body=json.dumps(event or {}))
        logger.info(f"Wrote object s3://{BUCKET_NAME}/{key}")

        resp = s3.list_objects_v2(Bucket=BUCKET_NAME, MaxKeys=10)
        keys = [obj["Key"] for obj in resp.get("Contents", [])]

        return {
            "statusCode": 200,
            "body": json.dumps({"written": key, "objects": keys}),
        }

    except Exception as e:
        logger.error(f"Error accessing S3: {str(e)}")
        return {
            "statusCode": 500,
            "body": json.dumps({"message": f"Error accessing S3: {str(e)}"}),
        }
