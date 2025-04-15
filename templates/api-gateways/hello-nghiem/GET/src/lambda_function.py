import pandas as pd
def handler(event, context):
    # Process the incoming event and return a response
    print("event: ", event)
    print("context: ", context)
    name = event["name"]
    person = {
        "name": name,
        "nghiem": "hello",
    }
    if "age" in event:
        person["age"] = event["age"]

    return person