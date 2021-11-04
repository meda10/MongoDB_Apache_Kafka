#!/bin/bash

# GET cluster ID
# curl -X GET "http://localhost:8082/v3/clusters" -w "\n"

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
}' http://localhost:8082/v3/clusters/v87eqwtsS7mLGxablM3Phg/topics -w "\n"


#{"name": "min.insync.replicas", "value": "1"}
#{"name": "producer.interceptor.classes", "value": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"}'
#{"name": "replication.factor", "value": "3"},
#{"name": "kafka.topic", "value": "hlasy"},
#{"name": "log.retention.ms", "value": "-1"},
#{"name": "log.retention.bytes", "value": "-1"},
#{"name": "connector.class", "value": "io.confluent.kafka.connect.datagen.DatagenConnector"},
#{"name": "partitions", "value": "1"},
#{"name": "key.converter", "value": "org.apache.kafka.connect.json.JsonConverter"},
#{"name": "value.converter", "value": "org.apache.kafka.connect.json.JsonConverter"},
#{"name": "value.converter.schemas.enable", "value": "false"},


#echo -e "\nAdding datagen hlasy:"
#curl -X POST -H "Content-Type: application/json" --data '
#  { "name": "datagen-hlasy",
#    "config": {
#      "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
#      "kafka.topic": "hlasy",
#      "log.retention.ms": "-1",
#      "log.retention.bytes": "-1",
#      "cleanup.policy": "delete",
#      "replication.factor": "3",
#      "min.insync.replicas": "1",
#      "partitions": "1",
#      "schema.string": "{"name": "value_hlasy", "type": "record", "namespace": "", "fields": []}",
#      "key.converter": "org.apache.kafka.connect.json.JsonConverter",
#      "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#      "value.converter.schemas.enable": "false",
#      "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"
#}}' http://localhost:8083/connectors -w "\n"


#sleep 5

echo -e "\nAdding MongoDB Kafka Sink Connector for the 'hlasy' topic:"
curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-hlsy",
   "config": {
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "tasks.max":"1",
     "topics":"hlasy",
     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
     "database":"volby",
     "collection":"hlasy",
     "key.converter": "org.apache.kafka.connect.storage.StringConverter",
     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable": "false"
}}' http://localhost:8083/connectors -w "\n"