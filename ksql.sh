#!/bin/bash
#KSQL
echo "\nKSQL\n"

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE STREAM stream_hlasy (id_kraje STRING, strana STRING, preferencni ARRAY<STRING>) WITH (kafka_topic=\'hlasy\', key_format=\'json\', value_format=\'json\', partitions=1);",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE STREAM stream_preferencni_hlasy (id_kraje STRING, preferencni STRING) WITH (kafka_topic=\'preferencni_hlasy\', key_format=\'json\', value_format=\'json\', partitions=1);",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE TABLE table_hlasy_sum_okres WITH (kafka_topic=\'hlasy_sum_okres\',  key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT id_kraje, strana, COUNT(*) AS count FROM stream_hlasy GROUP BY id_kraje, strana EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE TABLE table_hlasy_sum_cr WITH (kafka_topic=\'hlasy_sum_cr\',  key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT strana, COUNT(*) AS count FROM stream_hlasy GROUP BY strana EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE STREAM stream_preferencni_1_sum WITH (kafka_topic=\'preferencni_hlasy\', key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT id_kraje, preferencni[1] as preferencni FROM stream_hlasy EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE STREAM stream_preferencni_2_sum WITH (kafka_topic=\'preferencni_hlasy\', key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT id_kraje, preferencni[2] as preferencni FROM stream_hlasy EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE STREAM stream_preferencni_3_sum WITH (kafka_topic=\'preferencni_hlasy\', key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT id_kraje, preferencni[3] as preferencni FROM stream_hlasy EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE STREAM stream_preferencni_4_sum WITH (kafka_topic=\'preferencni_hlasy\', key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT id_kraje, preferencni[4] as preferencni FROM stream_hlasy EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE TABLE table_preferencni_hlasy_sum_okres WITH (kafka_topic=\'preferencni_hlasy_sum_okres\',  key_format=\'json\', value_format=\'json\', partitions=1) AS SELECT id_kraje, preferencni, COUNT(*) AS count FROM stream_preferencni_hlasy GROUP BY id_kraje, preferencni EMIT CHANGES;",
  "streamsProperties": {}
}'

curl -X "POST" "http://localhost:8088/ksql" -H "Content-Type: application/json; charset=utf-8" -d $'{
  "ksql": "CREATE TABLE table_preferencni_hlasy_sum_cr WITH (KAFKA_TOPIC=\'preferencni_hlasy_sum_cr\', VALUE_FORMAT=\'JSON\', PARTITIONS=1) AS SELECT preferencni, COUNT(*) AS count FROM stream_preferencni_hlasy GROUP BY preferencni EMIT CHANGES;",
  "streamsProperties": {}
}'