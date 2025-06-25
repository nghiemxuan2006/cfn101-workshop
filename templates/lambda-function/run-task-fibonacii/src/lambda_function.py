import boto3
import os
import json
import time
from datetime import datetime

client = boto3.client('ecs')
subnet_ids = os.environ.get('SUBNET_ID', ["subnet-08e236114e785172b"])
cluster = os.environ.get('CLUSTER_NAME', 'nx-vid-demo')
task_definition = os.environ.get('TASK_DEFINITION', 'nx-vid-fibonaci-test')
# Create EventBridge client
eventbridge = boto3.client('events')

def put_event_to_eventbridge():
    try:
        response = eventbridge.put_events(
            Entries=[
                {
                    'DetailType': 'Run-pytest',
                    'Detail': json.dumps({
                        'orderId': '12345',
                        'customerId': 'cust-67890',
                        'amount': 99.99,
                        'timestamp': datetime.now().isoformat()
                    }),
                    'EventBusName': 'default',  # or your custom event bus name
                }
            ]
        )
        
        print(f"Event sent successfully: {response}")
        return response
        
    except Exception as e:
        print(f"Error sending event: {e}")
        raise

# def handler(event, context):
#     try:
#         for i in range(1):
#             response = client.run_task(
#                 cluster=cluster,  # Replace with your ECS cluster name
#                 launchType='FARGATE',
#                 taskDefinition=task_definition,  # Replace with your task definition and revision
#                 count=1,
#                 platformVersion='LATEST',
#                 networkConfiguration={
#                     'awsvpcConfiguration': {
#                         'subnets': subnet_ids,
#                         'assignPublicIp': 'ENABLED'
#                     }
#                 },
#                 overrides={
#                     'containerOverrides': [
#                         {
#                             'name': 'fibonaci-task',  # Replace with your container name
#                             'environment': [
#                                 {
#                                     'name': 'FIBONACCI_NUMBER',
#                                     'value': "11"
#                                 },
#                             ]
#                         },
#                     ]
#                 }
#             )
#             sleep_time = i
#             print("response: ", response)
#             # time.sleep(sleep_time)
#     except Exception as e:
#         print(e)
#         return {
#             "statusCode": 500,
#             "body": "error"
#         }
#     return {
#         "statusCode": 200,
#         "body": "success"
#     }

# Usage in Lambda function
def handler(event, context):
    # Your business logic here
    
    # Send event to EventBridge
    put_event_to_eventbridge()
    
    return {
        'statusCode': 200,
        'body': json.dumps('Event sent successfully')
    }