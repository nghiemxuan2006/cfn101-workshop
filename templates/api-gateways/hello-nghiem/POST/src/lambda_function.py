def handler(event, context):
    # Process the incoming event and return a response
    print("event: ", event)
    print("context: ", context)
    name = event["name"]
    person = {
        "name": name,
    }
    person["age"] = event["age"] *2

    return person