import boto3
import os

client = boto3.client('ecs')
subnet_ids = os.environ.get('SUBNET_ID', ["subnet-08e236114e785172b"])
cluster = os.environ.get('CLUSTER_NAME', 'nx-vid-demo')
task_definition = os.environ.get('TASK_DEFINITION', 'ecs-fargate-td-test')

def handler(event, context):
    response = client.run_task(
        cluster=cluster,  # Replace with your ECS cluster name
        launchType='FARGATE',
        taskDefinition=task_definition,  # Replace with your task definition and revision
        count=1,
        platformVersion='LATEST',
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': subnet_ids,
                'assignPublicIp': 'ENABLED'
            }
        },
        overrides={
            'containerOverrides': [
                {
                    'name': 'fibonacii-task',  # Replace with your container name
                    'environment': [
                        {
                            'name': 'FIBONACCI_NUMBER',
                            'value': 8
                        },
                    ]
                },
            ]
        }
    )
    return response