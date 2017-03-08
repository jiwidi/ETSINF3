var http = require('http');
var url = require('url');
var qs = require('querystring');
var fs=require('fs')
http.createServer( function(request,response) {
 var query = url.parse(request.url).query;
 var opt = qs.parse(query).query;
 var x = '2015';
 var y = '1492';
 
 switch( opt ) {
 case 'time':  response.writeHead(200, {'Content-Type':'text/plain'}); response.end('fecha'); break;
 case 'dir':  response.writeHead(200, {'Content-Type':'text/plain'}); response.end('dir:'+__dirname); break;
 default : fs.readFile(opt,function(error,content){
 	if(error){response.writheHead(404) }
 	else response.writeHead(200, {'Content-Type':'text/plain'}); response.end('content')
	}
	) break;
 }
}).listen('1337');