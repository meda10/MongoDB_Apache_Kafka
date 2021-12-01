#!/bin/bash

echo "\nMONGO_CONNECT\n"

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

# todo create index on mongo db ID_KRAJE,STRANA
# Create sink for topic HLASY_SUM_KRAJ
# _ID is based on Topic keys | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo_sink_hlasy_sum_kraj",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false",
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topics": "hlasy_sum_kraj",
    "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
    "database": "volby",
    "collection": "hlasy_sum_kraj",
    "key.projection.type": "none",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.PartialKeyStrategy",
    "document.id.strategy.partial.key.projection.list": "ID_KRAJE,STRANA",
    "document.id.strategy.partial.key.projection.type": "AllowList",
    "document.id.strategy.overwrite.existing": "true",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy"
  }
}' http://localhost:8083/connectors -w "\n"

# todo create index on mongo db ID_KRAJE,PREFERENCNI
# Create sink for topic PREFERENCNI_HLASY_SUM_KRAJ
# _ID is based on Topic keys | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo_sink_preferencni_hlasy_sum_kraj",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false",
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topics": "preferencni_hlasy_sum_kraj",
    "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
    "database": "volby",
    "collection": "preferencni_hlasy_sum_kraj",
    "key.projection.type": "none",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.PartialKeyStrategy",
    "document.id.strategy.partial.key.projection.list": "ID_KRAJE,PREFERENCNI",
    "document.id.strategy.partial.key.projection.type": "AllowList",
    "document.id.strategy.overwrite.existing": "true",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy"
  }
}' http://localhost:8083/connectors -w "\n"


# todo create index on mongo db STRANA
# Create sink for topic HLASY_SUM_CR
# _ID is based on Topic keys | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo_sink_hlasy_sum_cr",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false",
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topics": "hlasy_sum_cr",
    "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
    "database": "volby",
    "collection": "hlasy_sum_cr",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.ProvidedInKeyStrategy",
    "transforms": "hk",
    "transforms.hk.type": "org.apache.kafka.connect.transforms.HoistField$Key",
    "transforms.hk.field": "_id",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneTimestampsStrategy"
  }
}' http://localhost:8083/connectors -w "\n"

# todo create index on mongo db PREFERENCNI
# Create sink for topic PREFERENCNI_HLASY_SUM_cr
# _ID is based on Topic keys | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo_sink_preferencni_hlasy_sum_cr",
  "config": {
    "key.converter.schemas.enable": "false",
    "value.converter.schemas.enable": "false",
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "topics": "preferencni_hlasy_sum_cr",
    "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
    "database": "volby",
    "collection": "preferencni_hlasy_sum_cr",
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.ProvidedInKeyStrategy",
    "transforms": "hk",
    "transforms.hk.type": "org.apache.kafka.connect.transforms.HoistField$Key",
    "transforms.hk.field": "_id",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneTimestampsStrategy"
  }
}' http://localhost:8083/connectors -w "\n"