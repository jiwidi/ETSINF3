function fib(n) {
    return (n < 2) ? 1 : fib(n - 2) + fib(n - 1);
}

console.log("iniciando ejecucion");

setTimeout(
    function() {
        console.log('m1: quiero escribit...');
    }, 10);

var j = fib(40);

function otherMsg(m,u) {
    console.log(m + ": el resultado es" + u);
}

otherMsg("M2", j);

setTimeout(function() {otherMsg("M3", j);}, 1);
