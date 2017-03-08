var zmq = require('zmq');
var responder = zmq.socket('rep');

var dealerURL = "tcp://127.0.0.1:8004" //process.argv[2];
var workTime = parseInt(process.argv[3]) * 1000;
var message  = process.argv.splice(4).join(' ');

responder.connect(dealerURL);
responder.on('message', function(msg) {
    console.log('received request: ', msg.toString());
    setTimeout(function() {responder.send(message);}, workTime);
});
