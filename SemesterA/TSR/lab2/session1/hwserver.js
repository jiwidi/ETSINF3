// Hello World server
// Binds REP socket to tcp://*:5555
// Expects "Hello" from client, replies with "world"



var zmq = require('zmq');
var port = process.argv[2];
var time = process.argv[3];
var msg = process.argv[4];

// socket to talk to clients
var responder = zmq.socket('rep');
if(process.argv.length != 5){
	console.log("Wrong number of arguments m8")
	process.exit(0);
}

responder.on('message', function(request) {
  console.log("Received request: [", request.toString(), "]");

  // do some 'work'
  setTimeout(function() {

    // send reply back to client.
    responder.send(request.toString()+" "+msg);
  }, time*1000);
});

responder.bind('tcp://*:'+port, function(err) {
  if (err) {
    console.log(err);
  } else {
    console.log("Listening on "+port+"...");
  }
});

process.on('SIGINT', function() {
  responder.close();
});
