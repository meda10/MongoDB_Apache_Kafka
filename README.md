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

## Kafka streams 
* https://kafka.apache.org/documentation/streams/

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