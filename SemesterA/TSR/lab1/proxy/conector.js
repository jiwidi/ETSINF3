var net = require('net')
console.log(process.argv[2])
var msg=JSON.stringify({"hola":"que pasa lokooo"})
console.log(msg);

var socket=net.connect({port:process.argv[2],address:process.argv[3]},
	function() {socket.write(msg)})
