var ev = require("events");
var emitter = new ev.EventEmitter;
var e1 = "print", e2 = "read";
var n1 = 0, n2 = 0;

// register listener functions on the event emitter
emitter.on(e1,
    function() {
        console.log('event ' + e1 + ' ' + n1 + ' times')})
emitter.on(e2,
    function() {
        console.log('event ' + e2 + ' ' + n1 + ' times')})

emitter.on(e1,
    function () {
        console.log('something has been printed')})

setInterval(function() {emitter.emit(e1);}, 2000);

setInterval(function() {emitter.emit(e2);}, 8000);
