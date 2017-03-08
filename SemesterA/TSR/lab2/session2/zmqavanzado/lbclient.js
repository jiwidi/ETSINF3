var zmq = require('zmq');
var requester = zmq.socket('req');

var routerURL = "tcp://127.0.0.1:8003" //process.argv[2];
var identity  = process.argv[2];
var requests  = parseInt(process.argv[3]);
var bomb   = "messa"//process.argv[1];

requester.identity = identity;

requester.connect(routerURL);
var replyNbr = 0;
requester.on('message', function(msg) {
    console.log('got reply ', replyNbr++, '\n', msg.toString());
    if (replyNbr == requests) {
        console.log('Process completed!');
        process.exit(0);
    }
});

for (var i = 0; i < requests; i++) {
    requester.send(bomb);
}
