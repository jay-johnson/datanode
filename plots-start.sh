#!/bin/bash

source ./properties.sh .

filetouse="./compose-x11-local.yml"

echo "Starting new Docker Compose($filetouse)"
docker-compose -f $filetouse up -d

exit 0
