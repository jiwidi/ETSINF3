var net = require('net');

var msg = JSON.stringify({
    "ip":process.argv[4],
    "port":process.argv[5]
});

console.log(msg);

var socket = net.connect({port:process.argv[3], address:process.argv[4]},
    function() {socket.write(msg);});
