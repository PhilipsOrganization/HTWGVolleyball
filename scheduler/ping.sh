#!/bin/sh

while true
do
    curl -s http://volleyball:3000/scheduler > /dev/null
    echo "Successfully pinged the endpoint"
    sleep 120
done