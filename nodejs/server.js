var express = require('express');
var app = express();

var morgan  = require('morgan')
app.use(morgan('combined'))

app.get('/', function (req, res) {
res.send('Hello World! (Version 2)');
});

app.listen(3000, function () {
console.log('Example app listening on port 3000!');
});
