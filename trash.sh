
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