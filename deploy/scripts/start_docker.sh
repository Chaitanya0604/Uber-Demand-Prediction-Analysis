#!/bin/bash
# Log everything to start_docker.log
exec > /home/ubuntu/start_docker.log 2>&1

echo "Logging in to ECR..."
aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 114354607243.dkr.ecr.ap-southeast-2.amazonaws.com

echo "Pulling Docker image..."
docker pull 114354607243.dkr.ecr.ap-southeast-2.amazonaws.com/uber-demand-prediction:latest

echo "Checking for existing container..."
if [ "$(docker ps -q -f name=uber-demand-prediction)" ]; then
    echo "Stopping existing container..."
    docker stop uber-demand-prediction
fi

if [ "$(docker ps -aq -f name=uber-demand-prediction)" ]; then
    echo "Removing existing container..."
    docker rm uber-demand-prediction
fi

echo "Starting new container..."
docker run --name uber-demand-prediction -d -p 80:8000 -e DAGSHUB_USER_TOKEN=b7152d2cc6082f4bd19d02d708ba7d494551a845 114354607243.dkr.ecr.ap-southeast-2.amazonaws.com/uber-demand-prediction:latest

echo "Container started successfully."
