#!/bin/bash

# Pull the latest code
git pull origin main

# Pull the latest Docker images
docker-compose pull

# Restart the containers
docker-compose down
docker-compose up -d 