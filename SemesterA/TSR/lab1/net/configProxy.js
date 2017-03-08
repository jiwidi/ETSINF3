var net = require('net');

var LOCAL_PORT = 8000;
var LOCAL_IP = '127.0.0.1';
var REMOTE_PORT = process.argv[2];
var REMOTE_IP = process.argv[3]; //www.iti.es

var server = net.createServer(function(socket) {
    socket.on('data', function(msg) {
        var serviceSocket = new net.Socket();
        serviceSocket.connect(parseInt(REMOTE_PORT), REMOTE_IP, function() {serviceSocket.write(msg);});
        serviceSocket.on('data', function(data){socket.write(data);});
    });
}).listen(LOCAL_PORT, LOCAL_IP);

console.log("Redirecting connections to " + REMOTE_IP + ":" + REMOTE_PORT);
console.log("TCP server accepting connection on port: " + LOCAL_PORT);
