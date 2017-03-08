var zmq = require('zmq');
var frontend = zmq.socket('router');
var backend  = zmq.socket('dealer');

var routerPort = 8003 //parseInt(process.argv[2]);
var brokerPort = 8004 //parseInt(process.argv[3]);

frontend.bindSync('tcp://*:' + routerPort);
backend.bindSync('tcp://*:' + brokerPort);

frontend.on('message', function() {
    var args = Array.apply(null, arguments);
	console.log("Te has conectado client")
    backend.send(args);
	console.log(args.toString())
});

backend.on('message', function() {
    var args = Array.apply(null, arguments);
    frontend.send(args);
});
