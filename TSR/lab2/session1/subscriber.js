var zmq = require('zmq')
var subscriber = zmq.socket('sub')

var endpoint = argv[2];
var desc = argv[3];
var filter = argv[4];


subscriber.on("message", function(reply) {
  console.log('Received message: ', reply.toString());
})

subscriber.subscribe(filter);
subscriber.connect(endpoint)
subscriber.subscribe("")

process.on('SIGINT', function() {
  subscriber.close()
  console.log('\nClosed')
})
