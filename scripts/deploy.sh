#!/bin/bash

ACCOUNT_ID=824267125510
REGION=us-east-1
REPO=aws/mern-app

echo "Logging into ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

echo "Pulling latest images..."
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:backend
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:frontend

echo "Stopping old containers..."
docker stop backend || true
docker stop frontend || true
docker rm backend || true
docker rm frontend || true

echo "Starting new containers..."
docker run -d -p 5000:5000 --name backend $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:backend
docker run -d -p 80:80 --name frontend $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO:frontend

echo "Deployment complete."
