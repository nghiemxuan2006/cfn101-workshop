# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install any needed packages specified in requirements.txt
COPY src/requirements.txt /app
RUN pip install -r requirements.txt

# Copy the current directory contents into the container
COPY src/ /app

# Define environment variable
ENV PYTHONUNBUFFERED=1

# Run app.py when the container launches
CMD ["python", "main.py"]