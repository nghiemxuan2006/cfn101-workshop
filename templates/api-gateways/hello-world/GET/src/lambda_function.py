import numpy as np
def handler(event, context):
    # Process the incoming event and return a response
    return {
        'statusCode': 200,
        'body': 'Hello World!'
    }