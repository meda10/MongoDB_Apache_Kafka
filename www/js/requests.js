const axios = require('axios');




const data = JSON.stringify( {"records":[{"value":{"strawwwna": "test2"}}]} );

axios.post('http://localhost:8082/topics/hlasy', data, {
    headers: {
        'Content-Type': 'application/vnd.kafka.json.v2+json'
    }
}).then(function (response) {
    console.log(response);
}).catch(function (error) {
    console.log(error);
});































//const  bodyFormData = { "name":"John", "age":30, "city":"New York"};

/*const options = {
  hostname: 'localhost',
  port: 8082,
  path: '/topics/hlasy',
  method: 'POST',
  headers: {
    'Content-Type': 'application/vnd.kafka.json.v2+json',
    'Content-Length': data.length
  }
}


const req = http.request(options, res => {
  console.log(`statusCode: ${res.statusCode}`)

  res.on('data', d => {
    process.stdout.write(d)
  })
})

req.on('error', error => {
  console.error(error)
})

req.write(data)
req.end()*/

/*axios({
  method: 'post',
  url: 'http://localhost:8082/topics/hlasy',
  data: JSON.stringify(bodyFormData),
  config: { headers: {
      'Content-Type': 'application/vnd.kafka.json.v2+json'
    }}
  })
  .then((response) => {console.log(response)})
  .catch(error => {console.log( 'the error has occured: ' + error) });*/

/*var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;

var xhr = new XMLHttpRequest();
xhr.open("POST", 'http://localhost:8082/topics/hlasy', true);
xhr.setRequestHeader('Content-Type', 'application/vnd.kafka.json.v2+json');

xhr.onreadystatechange = function () {
    console.log(this.readyState);

    if (this.readyState != 4) return;


    if (this.status == 200) {
        var data = JSON.parse(this.responseText);
        console.log(data);
        // we get the returned data
    }
};

xhr.send(JSON.stringify(bodyFormData));*/











//var KafkaRest = require('kafka-rest');
//var kafka = new KafkaRest({ 'url': 'http://localhost:8082'});

/*var KafkaRestClient = require('kafka-rest-client');

var configs = {
    proxyHost: 'localhost',
    proxyPort: 8082
};

function callback(ddd) {
    console.log(ddd);
}

var kafkaRestClient = new KafkaRestClient(configs, callback);
kafkaRestClient.connect(callback);


kafkaRestClient.produce('hlasy', 'Example Kafka Message', callback);*/



/*kafka.topics.get('hlasy', function(err, topic) {
     // topic is a Topic object
     console.log(topic);
 });*/

// kafka.topic('hlasy').produce({"value":{"strawssswwna": "tesssst2"});

/*var userIdSchema = new KafkaRest.AvroSchema("int");
var userInfoSchema = new KafkaRest.AvroSchema({
    "name": "UserInfo",
    "type": "record",
    "fields": [
        //{ "name": "id", "type": "int" },
        { "name": "name", "type": "string" }]
});*/

// Avro value schema followed by messages containing only values
//kafka.topic('hlasy').produce(userInfoSchema, {'avro': 'record'}, {'avro': 'another record'}, function(err, res){console.log(err); console.log(res);});

// Avro key and value schema.

//var data = JSON.stringify(eval( {'value': {'name': 'Bob'}} ));
//var data = {"records": [{"value":{"name":"bar"}}]};
//kafka.topic('hlasy').produce(userInfoSchema, data, function(err, res){console.log(err); console.log(res);});
//kafka.topic('hlasy').produce({'key': 'key1', 'value': 'msg1', 'partition': 0}, function(err,res){console.log(err); console.log(res);});
//kafka.topic('hlasy').produce('message')


//    kafka.topic('hlasy').produce({'value': 'jo', 'partition': 0});

//kafka.topic('hlasy').produce({'value': 'jo', 'partition': 0}, function(err,res){console.log(err); console.log(res);});


/*function addVoice(party, vote1, vote2, vote3, vote4) {
    kafka.topic('hlasy').produce({'value': 'jo', 'partition': 0});
}*/


