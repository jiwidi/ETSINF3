var ev= require('events');
var emitter= new ev.EventEmitter;
var e1="uno";
var e2="dos";
var e3="tres";
var dur1=3000;
var dur2=2000;
var dur3=10000;
function Listener(n1,n2,n3){
	this.count1=0;
	this.name1=n1;
	this.count2=0;
	this.name2=n2;
	this.count3=0;
	this.name3=n3;
}

Listener.prototype.ev1= function() {
	this.count1++
	console.log("Listener activo:"+this.count1+" eventos de tipo"+this.name1)
}

Listener.prototype.ev2= function() {
	this.count2=this.count2+1;
	if(this.count2>this.count1){console.log("Evento dos")}
	else console.log("Hay mas eventos de tipo uno")
}

Listener.prototype.ev3= function() {
	this.count3++
	if(dur2<7000)
	{
	dur2=dur2*3;
	}

}
var lis=new Listener(e1,e2,e3);
var emit2=function(){emitter.emit(e2)}
var emit1=function(){emitter.emit(e1)}

var emit3=function(){emitter.emit(e3)}
emitter.on(e1,function(){lis.ev1()});
emitter.on(e2,function(){lis.ev2()});
emitter.on(e3,function(){lis.ev3()});

setInterval(function(){emitter.emit(e1)},dur1)
setInterval(function(){emitter.emit(e2)},dur2) //when ev3 modifies dur2 the changes doesn't affect the interval 
setInterval(function(){emitter.emit(e3)},dur3)