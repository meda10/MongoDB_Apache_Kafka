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

#Spuštění
```
./run.sh
./mongo.sh
./kafka.sh
```

Browser
```
localhost:9021
localhost:8000
```

REST API
```
http://localhost:5000/hlasy
```

All events in topic
```
docker-compose exec broker bash
kafka-console-consumer --bootstrap-server localhost:9092 --topic NAME --from-beginning
```

Delete topic
```
docker-compose exec broker bash
kafka-topics --delete --zookeeper zookeeper:2181 --topic NAME
```

Test Message
```
docker-compose exec rest-proxy curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" \
          --data '{"records":[{"value":{"strana": "test"}}]}' \
          "http://localhost:8082/topics/hlasy"
```

# KSQL
## Create stream and table
```
docker exec -it ksql-server ksql http://127.0.0.1:8088

CREATE STREAM stream_hlasy (strana varchar) WITH (kafka_topic='hlasy', value_format='json', partitions=1);

CREATE TABLE stream_hlasy_sum AS
SELECT strana, COUNT(*) AS count
FROM stream_hlasy
GROUP BY strana
EMIT CHANGES;
```

## Run Query
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

CREATE STREAM CDCORACLE (I DECIMAL(20,0), NAME varchar, LASTNAME varchar, op_type VARCHAR) WITH ( kafka_topic='ORCLCDB-EMP', PARTITIONS=1, REPLICAS=1, value_format='AVRO');

CREATE STREAM SUM AS
  SELECT CAST(I AS BIGINT) as "_id",  NAME ,  LASTNAME , OP_TYPE  from CDCORACLE WHERE OP_TYPE!='D' EMIT CHANGES;

CREATE STREAM DELETEOP AS
  SELECT CAST(I AS BIGINT) as "_id",  NAME ,  LASTNAME , OP_TYPE  from CDCORACLE WHERE OP_TYPE='D' EMIT CHANGES;


CREATE TABLE pageviews_per_region_per_minute AS
  SELECT regionid,
         count(*)
  FROM pageviews_enriched
  WINDOW TUMBLING (SIZE 1 MINUTE)
  GROUP BY regionid
  EMIT CHANGES;