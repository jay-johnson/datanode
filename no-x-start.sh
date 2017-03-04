#!/bin/bash

source ./properties.sh .

filetouse="./compose-local.yml"

echo "Starting new Docker Compose($filetouse)"
docker-compose -f $filetouse up -d

exit 0
