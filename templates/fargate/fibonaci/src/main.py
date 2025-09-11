import os
import sys
import boto3
import json
import numpy as np

def fibonacci(n):
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b
    
eventbridge = boto3.client('events')

def put_event_to_eventbridge():
    try:
        response = eventbridge.put_events(
            Entries=[
                {
                    'Source': 'Run-pytest',
                    'DetailType': 'Run-pytest',
                    'Detail': json.dumps({
                        "event": "pytest:ECS event",
                        "message": "This is a test event from the ECS task",
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

if __name__ == "__main__":
    # put_event_to_eventbridge()
    # raise Exception("This is a test exception to check the error handling in the Lambda function.")
    # exit(3)
    # Example: Use numpy to calculate Fibonacci numbers efficiently
    n = 5
    # raise Exception("This is a test exception to check the error handling in the Lambda function.")
    print(f"Calculating the {n}th Fibonacci number using numpy...")
    import time
    time.sleep(60 *30)
    print("Wake up after sleep 60s")

    # # Use matrix exponentiation for fast Fibonacci calculation
    # F = np.array([[1, 1], [1, 0]], dtype=object)
    # result = np.linalg.matrix_power(F, n - 1)
    # print(result[0, 0])

    # test ecs task container out of memory
    # data = []
    # while True:
    #     data.append("X" * 10**9)  # 1GB mỗi phần tử
    # test lambda out of memory
    # try:
        # large_list = []
        # for i in range(5):
        #     large_list.append('x' * 1024 * 1024 * 1024 * 16)
    # except MemoryError:
    #     print("MemoryError caught: Lambda function ran out of memory.")
    # n = int(os.getenv("FIBONACCI_NUMBER", 2))  # Default to 2 if not provided
    # if len(sys.argv) > 1:
    #     n = int(sys.argv[1])
    
    # print(f"The {n}th Fibonacci number is: {fibonacci(n)}")