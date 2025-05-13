#!/bin/bash

# Login to Docker Hub
username=$1
password=$2
path=$3

name=$(basename "$path")

echo "Building Docker image for $name..."

docker login -u $username -p $password
if [ $? -ne 0 ]; then
  echo "Docker login failed. Please check your credentials."
  exit 1
fi

# Build your Docker image
docker build -t $username/$name:latest $path


# Push the image to Docker Hub
docker push $username/$name:latest