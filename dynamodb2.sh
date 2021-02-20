#!/bin/bash
/usr/local/bin/aws dynamodb put-item --table-name service-logs-table --item '{ "DateTime": { "S": "'$(date +%Y-%m-%d %H-%M-%S)'" }, "LogDescription": { "S": "Server is not running, Service starting has been failed" } }' --region ap-south-1