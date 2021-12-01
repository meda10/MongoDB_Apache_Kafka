
# Topic properties

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


# Data generator
curl -X POST -H "Content-Type: application/json" --data '
  { "name": "datagen-hlasy",
    "config": {
      "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
      "kafka.topic": "hlasy",
      "log.retention.ms": "-1",
      "log.retention.bytes": "-1",
      "cleanup.policy": "delete",
      "replication.factor": "3",
      "min.insync.replicas": "1",
      "partitions": "1",
      "schema.string": "{"name": "value_hlasy", "type": "record", "namespace": "", "fields": []}",
      "key.converter": "org.apache.kafka.connect.json.JsonConverter",
      "value.converter": "org.apache.kafka.connect.json.JsonConverter",
      "value.converter.schemas.enable": "false",
      "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"
}}' http://localhost:8083/connectors -w "\n"



# Create sink for topic OKRES_SUM
# _ID is based on Topic values | Update value + timestamps
curl -X POST -H "Content-Type: application/json" --data '
{"name": "mongo-sink-okres_sum",
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
    "document.id.strategy": "com.mongodb.kafka.connect.sink.processor.id.strategy.PartialValueStrategy",
    "document.id.strategy.partial.value.projection.list": "strana,id_kraje",
    "document.id.strategy.partial.value.projection.type": "AllowList",
    "document.id.strategy.overwrite.existing": "true",
    "writemodel.strategy": "com.mongodb.kafka.connect.sink.writemodel.strategy.UpdateOneBusinessKeyTimestampStrategy"
  }
}' http://localhost:8083/connectors -w "\n"




# working with schema
#curl --location --request POST 'http://localhost:8082/topics/test' \
#--header 'Content-Type: application/vnd.kafka.json.v2+json' \
#--data-raw '{
#  "records": [
#    {
#      "key_schema_id": 2,
#      "value_schema_id": 1,
#      "key": {
#        "_id": "W111"
#      },
#      "value": {
#      	"name": "test name2",
#      	"value": 77
#      }
#    }
#  ]
#}'



#echo -e "\nConfiguring the MongoDB ReplicaSet.\n"
#docker-compose exec mongo1 /usr/bin/mongo --eval '''if (rs.status()["ok"] == 0) {
#    rsconf = {
#      _id : "rs0",
#      members: [
#        { _id : 0, host : "mongo1:27017", priority: 1.0 },
#        { _id : 1, host : "mongo2:27017", priority: 0.5 },
#        { _id : 2, host : "mongo3:27017", priority: 0.5 }
#      ]
#    };
#    rs.initiate(rsconf);
#}
#
#rs.conf();'''

#echo -e "\nKafka Topics:"
#curl -X GET "http://localhost:8082/topics" -w "\n"
#
#echo -e "\nKafka Connectors:"
#curl -X GET "http://localhost:8083/connectors/" -w "\n"

#echo -e "\nAdding datagen pageviews:"
#curl -X POST -H "Content-Type: application/json" --data '
#  { "name": "datagen-pageviews",
#    "config": {
#      "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
#      "kafka.topic": "pageviews",
#      "quickstart": "pageviews",
#      "key.converter": "org.apache.kafka.connect.json.JsonConverter",
#      "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#      "value.converter.schemas.enable": "false",
#      "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
#      "max.interval": 200,
#      "iterations": 10000000,
#      "tasks.max": "1"
#}}' http://localhost:8083/connectors -w "\n"
#sleep 5

#echo -e "\nAdding MongoDB Kafka Sink Connector for the 'pageviews' topic into the 'test.pageviews' collection:"
#curl -X POST -H "Content-Type: application/json" --data '
#  {"name": "mongo-sink",
#   "config": {
#     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
#     "tasks.max":"1",
#     "topics":"pageviews",
#     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
#     "database":"test",
#     "collection":"pageviews",
#     "key.converter": "org.apache.kafka.connect.storage.StringConverter",
#     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#     "value.converter.schemas.enable": "false"
#}}' http://localhost:8083/connectors -w "\n"

#sleep 2
#echo -e "\nAdding MongoDB Kafka Source Connector for the 'test.pageviews' collection:"
#curl -X POST -H "Content-Type: application/json" --data '
#  {"name": "mongo-source",
#   "config": {
#     "tasks.max":"1",
#     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
#     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
#     "topic.prefix":"mongo",
#     "database":"test",
#     "collection":"pageviews"
#}}' http://localhost:8083/connectors -w "\n"

#sleep 2
#echo -e "\nKafka Connectors: \n"
#curl -X GET "http://localhost:8083/connectors/" -w "\n"

#echo "Looking at data in 'db.pageviews':"
#docker-compose exec mongo1 /usr/bin/mongo --eval 'db.pageviews.find()'

#echo -e '''
#
#==============================================================================================================
#Examine the topics in the Kafka UI: http://localhost:9021 or http://localhost:8000/
#  - The `pageviews` topic should have the generated page views.
#  - The `mongo.test.pageviews` topic should contain the change events.
#  - The `test.pageviews` collection in MongoDB should contain the sinked page views.
#
#Examine the collections:
#  - In your shell run: docker-compose exec mongo1 /usr/bin/mongo
#==============================================================================================================
#
#Use <ctrl>-c to quit'''

#read -r -d '' _ </dev/tty



#curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" --data '{"records":[{"value":{"strana": "test"}}]}' "http://46.101.116.175:8082/topics/hlasy"

#docker-compose exec rest-proxy curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" \
#          --data '{"records":[{"value":{"strana": "test"}}]}' \
#          "http://localhost:8082/topics/Hlasy"
#
#curl "http://localhost:8082/topics/Hlasy"
#
#    {
#      "name": "id_okrsku",
#      "type": "long"
#    }

#  Mongo connector
#{
#  "name": "mongo-sink",
#  "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
#  "tasks.max": "1",
#  "key.converter": "org.apache.kafka.connect.storage.StringConverter",
#  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#  "topics": ["Hlasy"],
#  "connection.uri": "mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
#  "database": "volby",
#  "collection": "hlasy"
#}

#curl -X POST -H "Content-Type: application/json" --data '
#  {"name": "mongo-sink_v2",
#   "config": {
#     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
#     "tasks.max":"1",
#     "topics":"Hlasy",
#     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
#     "database":"volby",
#     "collection":"hlasy",
#     "key.converter": "org.apache.kafka.connect.storage.StringConverter",
#     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#     "value.converter.schemas.enable": "false"
#}}' http://localhost:8083/connectors -w "\n"

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
#      "key.converter": "org.apache.kafka.connect.json.JsonConverter",
#      "value.converter": "org.apache.kafka.connect.json.JsonConverter",
#      "value.converter.schemas.enable": "false",
#      "producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"
#}}' http://localhost:8083/connectors -w "\n"

#{
#  "name": "value_hlasy",
#  "type": "record",
#  "namespace": "",
#  "fields": [
#    {"name":  "strana", "type": "string"},
#    {"name":  "preferencni_1", "type": "long"},
#    {"name":  "preferencni_2", "type": "long"},
#    {"name":  "preferencni_3", "type": "long"},
#    {"name":  "preferencni_4", "type": "long"}
#  ]
#}
