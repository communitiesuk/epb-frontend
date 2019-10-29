var connect = require('connect');
var sassMiddleware = require('node-sass-middleware');

var srcPath = __dirname + '/assets/sass';
var destPath = __dirname + '/assets/css';

var serveStatic = require('serve-static')
var http = require('http');
var port = process.env.PORT || 80;
var app = connect();
app.use('/assets/css', sassMiddleware({
  src: srcPath,
  dest: destPath,
  debug: true,
  outputStyle: 'expanded'
}));
app.use('/',
  serveStatic('./', {})
);
http.createServer(app).listen(port);
console.log('Server listening on port ' + port);
console.log('srcPath is ' + srcPath);
console.log('destPath is ' + destPath);
