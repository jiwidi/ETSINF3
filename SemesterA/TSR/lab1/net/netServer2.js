var net = require('net');
var fs  = require('fs');

var server = net.createServer(
    function (c) {
        console.log('server: client connected');
        c.on('end', function () {console.log('server: client disconnected');});
        c.on('data', function (data) {c.write(getLoad().toString()); c.end();});
    }
);

function getLoad() {
    data = fs.readFileSync("/proc/loadavg");
    var tokens = data.toString().split(' ');
    var min1 = parseFloat(tokens[0]) + 0.01;
    var min5 = parseFloat(tokens[1]) + 0.01;
    var min15 = parseFloat(tokens[2]) + 0.01;
    return min1 * 10 + min5 * 2 + min15;
};

server.listen(8000, function() {console.log('server bound');});
