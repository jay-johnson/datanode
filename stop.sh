#!/bin/bash

source ./properties.sh .

filetouse="./compose-local.yml"

echo "Stopping Docker image($registry/$maintainer/$imagename)"
docker-compose -f $filetouse down
docker stop $imagename &>> /dev/null
docker rm $imagename &>> /dev/null

exit 0
