#!/bin/bash

# Name and tag of your Docker image
IMAGE_NAME="riscv-tools"
IMAGE_TAG="latest"  # Change this as needed


DIRECTORY="home/xv6user/workspace"


# check if the directory exists, create it if not
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory $DIRECTORY not found. Creating..."
  mkdir -p $DIRECTORY
else
  echo "Directory $DIRECTORY already exists. Skipping creation."
fi

if [[ -z "$image" ]]; then
  # Image does not exist, so build it
  echo "Image ${IMAGE_NAME}:${IMAGE_TAG} not found. Building..."
  docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
else
  echo "Image ${IMAGE_NAME}:${IMAGE_TAG} already exists. Skipping build."
fi

# Run docker-compose up
docker compose up
