var fs = require('fs');
fs.writeFile('/tmp/f', 'contenido del nuevo fichero', 'utf8', function(err, data) {
	if (err) {
		return console.log(err);
	}
	console.log('se ha completado la escritura');
});
