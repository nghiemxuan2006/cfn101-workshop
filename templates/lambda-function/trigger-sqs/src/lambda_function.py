import json
import logging

# Set up logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Lambda function handler that processes messages from SQS trigger.
    
    Parameters:
    - event: The event object from SQS containing message details
    - context: The Lambda context object
    
    Returns:
    - Dictionary with statusCode and processed message details
    """
    logger.info("Received SQS event: %s", json.dumps(event))
    
    try:
        # SQS events come in as a list of Records
        for record in event['Records']:
            # Extract message body
            message_body = record['body']
            logger.info(f"Processing message: {message_body}")
            
            # Parse the message if it's in JSON format
            try:
                message_json = json.loads(message_body)
                logger.info(f"Parsed message JSON: {json.dumps(message_json)}") 
                
                # Process your message here
                # Example: Do something with the message data
                process_message(message_json)
                
            except json.JSONDecodeError:
                logger.info("Message is not in JSON format, processing as plain text")
                # Process non-JSON message
                process_plain_text_message(message_body)
            
            # Get additional SQS metadata if needed
            message_id = record['messageId']
            receipt_handle = record['receiptHandle']
            attributes = record.get('attributes', {})
            
            logger.info(f"Successfully processed message ID: {message_id}")
            
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Successfully processed {len(event["Records"])} messages',
                'processedCount': len(event["Records"])
            })
        }
        
    except Exception as e:
        logger.error(f"Error processing SQS message: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': f'Error processing SQS message: {str(e)}'
            })
        }

def process_message(message_data):
    """
    Process the message data from SQS.
    Implement your business logic here.
    
    Parameters:
    - message_data: The parsed JSON data from the message
    """
    # Example processing
    logger.info("Processing message data...")
    
    # Your business logic here
    if 'action' in message_data:
        action = message_data['action']
        logger.info(f"Performing action: {action}")
        
        # Example conditional processing based on message content
        if action == 'create':
            # Handle create action
            logger.info("Handling create action")
        elif action == 'update':
            # Handle update action
            logger.info("Handling update action")
        elif action == 'delete':
            # Handle delete action
            logger.info("Handling delete action")
    
    logger.info("Message processing complete")

def process_plain_text_message(message_text):
    """
    Process plain text messages that aren't in JSON format
    
    Parameters:
    - message_text: The plain text message body
    """
    logger.info(f"Processing plain text message: {message_text}")
    # Implement plain text processing logic here