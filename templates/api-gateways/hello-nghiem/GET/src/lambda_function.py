import pandas as pd
def handler(event, context):
    # Process the incoming event and return a response
    print("event: ", event)
    return {
        'statusCode': 200,
        'body': 'Hello from Xuan nghiem thongminh!'
    }