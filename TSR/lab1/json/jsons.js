var net = require('net');

var server = net.createServer(
    function(c) {
        c.on('data',
        function(data) {
            var person = JSON.parse(data);

            console.log(person.name);
            console.log(person.address.street);
            console.log(person.address.city);
            console.log(person.phone[0].number);
            console.log(person.phone[1].type);
        }
            )});


server.listen(8000, function(){console.log('server');});
