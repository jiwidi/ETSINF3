// Hello World client
// Connects REQ socket to tcp://localhost:5555
// Sends "Hello" to server.
var IP = process.argv[2];
var RequestNUM = process.argv[3];
var msg = process.argv[4];
if(process.argv.length != 5){
	console.log("Wrong number of arguments m8")
	process.exit(0);
}

var zmq = require('zmq');

// socket to talk to server
console.log("Connecting to hello world server...");
var requester = zmq.socket('req');

var x = 0;
requester.on("message", function(reply) {
  console.log("Received reply", x, ": [", reply.toString(), ']');
  x += 1;
  if (x === RequestNUM) {
    requester.close();
    process.exit(0);
  }
});

requester.connect(IP);

for (var i = 0; i < 10; i++) {
  console.log("Sending request", i, '...');
  requester.send(msg);
}

process.on('SIGINT', function() {
  requester.close();
});
