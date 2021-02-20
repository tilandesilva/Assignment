#!/bin/bash
aws dynamodb put-item --table-name service-logs-table --item '{ "DateTime": { "S": "'$(date +%Y%m%d-%H%M%S)'" }, "LogDescription": { "S": "Server is up and Running" } }'