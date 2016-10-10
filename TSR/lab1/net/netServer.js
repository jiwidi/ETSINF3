var net = require('net');

var server = net.createServer(
    function (c) {
        console.log('server: client connected');
        c.on('end', function () {console.log('server: client disconnected');});
        c.on('data', function (data) {c.write('Hello\r\n' + data.toString()); c.end();});
    }
);

server.listen(8000, function() {console.log('server bound');});
