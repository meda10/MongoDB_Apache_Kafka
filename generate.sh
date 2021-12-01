#!/bin/bash

curl -X POST -H "Content-Type: application/json" --data '
  { "name": "datagen-hlasy",
    "config": {
      "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
      "kafka.topic": "hlasy",
      "schema.filename": "/usr/share/confluent-hub-components/kafka-connect-mongodb/schemas/hlasy.avro",
      "key.converter": "org.apache.kafka.connect.storage.StringConverter",
      "value.converter": "org.apache.kafka.connect.json.JsonConverter",
      "value.converter.schemas.enable": "false",
      "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
      "max.interval": 200,
      "tasks.max": "1"
}}' http://localhost:8083/connectors -w "\n"


#    "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
#    "kafka.topic": "topicx",
#    "schema.filename": "myschema.avro",
#    "schema.keyfield": "userid",
#    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
#    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#    "value.converter.schemas.enable": "false",
#    "tasks.max": "1"
