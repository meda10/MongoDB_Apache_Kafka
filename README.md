# PDB

## Tutorial
* https://docs.confluent.io/platform/current/quickstart/ce-docker-quickstart.html
* https://stackoverflow.com/questions/57544201/implement-dockerized-kafka-sink-connector-to-mongo
* https://docs.mongodb.com/kafka-connector/current/

## Monfo DB connector
* https://github.com/mongodb/mongo-kafka

## Rest API
* https://docs.confluent.io/platform/current/kafka-rest/index.html#kafkarest-intro
* https://hub.docker.com/r/confluentinc/cp-kafka-rest
* https://github.com/nodefluent/kafka-rest-ui
* https://github.com/confluentinc/kafka-rest
* https://github.com/confluentinc/kafka-rest-node

## KSQL
* https://ksqldb.io/quickstart-platform.html#quickstart-content
* https://docs.confluent.io/platform/6.2.0/ksqldb/pull-queries-in-ccloud.html
* https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/streaming-endpoint/
* https://docs.ksqldb.io/en/latest/how-to-guides/query-structured-data/
* https://docs.confluent.io/5.4.2/ksql/docs/tutorials/examples.html#aggregating-windowing-and-sessionization
* https://kafka-tutorials.confluent.io/create-stateful-aggregation-count/ksql.html

## Volby.cz
* https://volby.cz/opendata/ps2021/ps2021_opendata_seznam.htm
* https://volby.cz/pls/ps2021/ps?xjazyk=CZ
* https://volby.cz/pls/ps2021/ps4?xjazyk=CZ

#Inspirace 
* https://www.novinky.cz/p/vysledky-voleb/2021/parlamentni-volby#utm_content=utility&utm_term=V%C3%BDsledky%20voleb&utm_medium=hint&utm_source=search.seznam.cz

## Setup
```
./run.sh -s
```

## How to run
```
./run.sh
```

## Generate data
```
./generate.sh
./generate_5000.sh
```

## Compile and run GUI
```
cd www
npm run start
```

```
localhost:1234
```


### Browser
```
localhost:9021
localhost:8000
```

###  REST API
```
http://localhost:5000/hlasy
```

### All events in topic
```
docker-compose exec broker bash
kafka-console-consumer --bootstrap-server localhost:9092 --topic NAME --from-beginning
```

### Delete topic
```
docker-compose exec broker bash
kafka-topics --delete --zookeeper zookeeper:2181 --topic NAME
```

### Test Message
```
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" \
--data '{"records": [{"value": {"id_kraje": "K2", "strana": "NE", "preferencni": ["P802", "P802", "P102", "P802"]}}]}' \
"http://localhost:8082/topics/hlasy"
```

## KSQL
### Create streams and tables
```
docker exec -it ksql-server ksql http://127.0.0.1:8088

CREATE STREAM stream_hlasy (id_kraje STRING, strana STRING, preferencni ARRAY<STRING>) WITH (kafka_topic='hlasy', key_format='json', value_format='json', partitions=1);
CREATE STREAM stream_preferencni_hlasy (id_kraje STRING, preferencni STRING) WITH (kafka_topic='preferencni_hlasy', key_format='json', value_format='json', partitions=1);

CREATE TABLE table_hlasy_sum_kraj WITH (kafka_topic='hlasy_sum_kraj',  key_format='json', value_format='json', partitions=1) AS
SELECT id_kraje, strana, COUNT(*) AS count
FROM stream_hlasy
GROUP BY id_kraje, strana
EMIT CHANGES;

CREATE TABLE table_hlasy_sum_cr WITH (kafka_topic='hlasy_sum_cr',  key_format='json', value_format='json', partitions=1) AS
SELECT strana, COUNT(*) AS count
FROM stream_hlasy
GROUP BY strana
EMIT CHANGES;

CREATE STREAM stream_preferencni_1_sum WITH (kafka_topic='preferencni_hlasy', key_format='json', value_format='json', partitions=1) AS
SELECT id_kraje, preferencni[1] as preferencni
FROM stream_hlasy
EMIT CHANGES;

CREATE STREAM stream_preferencni_2_sum WITH (kafka_topic='preferencni_hlasy', key_format='json', value_format='json', partitions=1) AS
SELECT id_kraje, preferencni[2] as preferencni
FROM stream_hlasy
EMIT CHANGES;

CREATE STREAM stream_preferencni_3_sum WITH (kafka_topic='preferencni_hlasy', key_format='json', value_format='json', partitions=1) AS
SELECT id_kraje, preferencni[3] as preferencni
FROM stream_hlasy
EMIT CHANGES;

CREATE STREAM stream_preferencni_4_sum WITH (kafka_topic='preferencni_hlasy', key_format='json', value_format='json', partitions=1) AS
SELECT id_kraje, preferencni[4] as preferencni
FROM stream_hlasy
EMIT CHANGES;

CREATE TABLE table_preferencni_hlasy_sum_kraj WITH (kafka_topic='preferencni_hlasy_sum_kraj',  key_format='json', value_format='json', partitions=1) AS
SELECT id_kraje, preferencni, COUNT(*) AS count
FROM stream_preferencni_hlasy
GROUP BY id_kraje, preferencni
EMIT CHANGES;

CREATE TABLE table_preferencni_hlasy_sum_cr WITH (KAFKA_TOPIC='preferencni_hlasy_sum_cr', VALUE_FORMAT='JSON', PARTITIONS=1) AS
SELECT preferencni, COUNT(*) AS count
FROM stream_preferencni_hlasy
GROUP BY preferencni
EMIT CHANGES;
```

### Run Query
```
SELECT * FROM stream_hlasy_sum WHERE strana = 'ff';

curl --http2 -X "POST" "http://localhost:8088/query-stream" \
-d $'{
"sql": "SELECT * FROM stream_hlasy_sum WHERE strana = \'ff\';"
}'

# stream query
curl -X "POST" "http://localhost:8088/query" \
     -H "Content-Type: application/vnd.ksql.v1+json; charset=utf-8" \
     -d $'{
  "ksql": "SELECT * FROM SUM WHERE strana = \'XXX\';",
  "streamsProperties": {}
}'
```

[comment]: <> (CREATE STREAM CDCORACLE &#40;I DECIMAL&#40;20,0&#41;, NAME varchar, LASTNAME varchar, op_type VARCHAR&#41; WITH &#40; kafka_topic='ORCLCDB-EMP', PARTITIONS=1, REPLICAS=1, value_format='AVRO'&#41;;)

[comment]: <> (CREATE STREAM SUM AS)

[comment]: <> (  SELECT CAST&#40;I AS BIGINT&#41; as "_id",  NAME ,  LASTNAME , OP_TYPE  from CDCORACLE WHERE OP_TYPE!='D' EMIT CHANGES;)

[comment]: <> (CREATE STREAM DELETEOP AS)

[comment]: <> (  SELECT CAST&#40;I AS BIGINT&#41; as "_id",  NAME ,  LASTNAME , OP_TYPE  from CDCORACLE WHERE OP_TYPE='D' EMIT CHANGES;)


[comment]: <> (CREATE TABLE pageviews_per_region_per_minute AS)

[comment]: <> (  SELECT regionid,)

[comment]: <> (         count&#40;*&#41;)

[comment]: <> (  FROM pageviews_enriched)

[comment]: <> (  WINDOW TUMBLING &#40;SIZE 1 MINUTE&#41;)

[comment]: <> (  GROUP BY regionid)

[comment]: <> (  EMIT CHANGES;)
