#!/bin/sh

curl -s -X POST http://volleyball:3000/scheduler > /dev/null
echo "Successfully pinged the endpoint"