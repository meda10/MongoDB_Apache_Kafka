var KafkaRest = require('kafka-rest');
var kafka = new KafkaRest({ 'url': 'http://localhost:8082' });

// kafka.topics.get('hlasy', function(err, topic) {
//     // topic is a Topic object
//     console.log(topic)
// });

// kafka.topic('hlasy').produce({"value":{"strawssswwna": "tesssst2"});
kafka.topic('hlasy').produce({'key': 'key1', 'value': 'msg1', 'partition': 0});
