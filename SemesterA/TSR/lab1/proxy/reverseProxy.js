var net = require('net');
var LOCAL_PORT = [8001,8002,8003,8004,8005];
var LOCAL_IP = '127.0.0.1';
var IP =['158.42.184.5','158.42.4.23','216.58.210.163','158.42.156.2','147.156.222.65']
var remotePort = [80,80,443,80,80]

function createServer(value,index,ar){
var port=index
var server = net.createServer(function(socket) {
    socket.on('data', function(msg) {
        var serviceSocket = new net.Socket();
        serviceSocket.connect(parseInt(remotePort[port]),IP[port], function() {serviceSocket.write(msg);});
        serviceSocket.on('data', function(data){socket.write(data);});
    });
}).listen(LOCAL_PORT[port], LOCAL_IP);

console.log("Redirecting connections to " + IP[port] + ":" + remotePort[port]);
console.log("TCP server accepting connection on port: " + LOCAL_PORT[port]);

}

LOCAL_PORT.forEach(createServer);



