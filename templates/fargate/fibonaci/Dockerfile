FROM python:3.11-slim-buster

WORKDIR /app

# Copy requirements and install Python dependencies
# Install any needed packages specified in requirements.txt
COPY src/requirements.txt /app
RUN pip install -r requirements.txt

# Copy the current directory contents into the container
COPY src/ /app

# Make the script executable
RUN chmod +x entrypoint.sh

# Set the entrypoint
CMD ["./entrypoint.sh"]