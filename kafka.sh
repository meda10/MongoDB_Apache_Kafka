#!/bin/bash

echo "\KAFKA\n"

# GET schema ID -> replace topic name + key/value
# curl --location --request GET 'http://localhost:8081/subjects/test-value/versions/1'

# GET cluster ID
# curl -X GET "http://localhost:8082/v3/clusters" -w "\n"

# Create topic -> needs cluster ID
curl -X POST -H "Content-Type: application/json" --data '
{
    "topic_name": "hlasy",
    "partitions_count": 1,
    "replication_factor": 1,
    "configs": [
      {"name": "cleanup.policy", "value": "delete"},
      {"name": "retention.ms", "value": "-1"},
      {"name": "retention.bytes", "value": "-1"}
    ]
}' http://localhost:8082/v3/clusters/l2Lv3_yPRq2Zl-zUV6OydQ/topics -w "\n"




