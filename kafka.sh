#!/bin/bash

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

# Create sink for topic HLASY
curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo_sink_hlasy",
   "config": {
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "tasks.max":"1",
     "topics":"hlasy",
     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
     "database":"volby",
     "collection":"hlasy",
     "key.converter": "org.apache.kafka.connect.json.JsonConverter",
     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable": "false",
     "key.converter.schemas.enable": "false"
}}' http://localhost:8083/connectors -w "\n"

# todo create index on mongo db ID_OKRESU,STRANA
# Create sink for topic OKRES_SUM
# _ID is based on Topic keys | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo_sink_okres_hlasy_sum",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false",
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topics": "okres_sum",
    "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
    "database": "volby",
    "collection": "okres_sum",
    "key.projection.type": "none",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.PartialKeyStrategy",
    "document.id.strategy.partial.key.projection.list": "ID_OKRESU,STRANA",
    "document.id.strategy.partial.key.projection.type": "AllowList",
    "document.id.strategy.overwrite.existing": "true",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy"
  }
}' http://localhost:8083/connectors -w "\n"

# todo create index on mongo db ID_OKRESU,PREFERENCNI
# Create sink for topic PREFERENCNI_HLASY_SUM
# _ID is based on Topic keys | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo_sink_preferencni_hlasy_sum",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false",
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topics": "preferencni_hlasy_sum",
    "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
    "database": "volby",
    "collection": "preferencni_hlasy_sum",
    "key.projection.type": "none",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.PartialKeyStrategy",
    "document.id.strategy.partial.key.projection.list": "ID_OKRESU,PREFERENCNI",
    "document.id.strategy.partial.key.projection.type": "AllowList",
    "document.id.strategy.overwrite.existing": "true",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy"
  }
}' http://localhost:8083/connectors -w "\n"
