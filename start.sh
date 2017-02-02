#!/bin/bash

source ./properties.sh .

filetouse="./compose-local.yml"

localdirs=$(cat properties.sh | grep "_DIR=\"" | sed -e 's/"/ /g' | sed -e 's/=/ /g' | awk '{printf "%s\n", $NF}')
for lcd in $localdirs; do
    if [ ! -d $lcd ]; then
        echo "Creating Dir($lcd)"
        mkdir -p -m 777 $lcd
    fi
done

echo "Starting new Docker Compose($filetouse)"
docker-compose -f $filetouse up -d

exit 0
