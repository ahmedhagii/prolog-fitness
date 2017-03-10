var express          = require('express');
var app              = express();                  // create our app w/ express
var morgan           = require('morgan');          // log requests to the console (express4)
var bodyParser       = require('body-parser');     // pull information from HTML POST (express4)
var methodOverride   = require('method-override'); // simulate DELETE and PUT (express4)
var application_root = __dirname;
var request          = require("request");
var path             = require( 'path' );

// configuration =================
app.use(morgan('dev'));                                         // log every request to the console
app.use(bodyParser.urlencoded({'extended':'true'}));            // parse application/x-www-form-urlencoded
app.use(bodyParser.json());                                     // parse application/json
app.use(bodyParser.json({ type: 'application/vnd.api+json' })); // parse application/vnd.api+json as json
app.use(methodOverride());

//Where to serve static content
app.use( express.static( path.join( application_root, 'app') ) );

// listen (start app with node server.js) ======================================
app.listen(8080);
console.log("App listening on port 8080");

app.get('*', function(req, res) {
	res.send('app/index.html');
});

// api routes
app.post('/submit-info', function(req, res) {
	n = new Date();
	console.log('##### ' + n);
	console.log(req.params);
	console.log(req.body);
	console.log(req.query);

	var data = {
		"weight": req.body.weight,
		"fat": req.body.fat,
		"al": req.body.al,
		"bulking": req.body.bulking.toString(),
		"meals": req.body.meals
	};
	var options = {
		uri: 'http://localhost:5000/reply',
		method: 'POST',
		headers: {'content-type': 'application/json'},
		json: data
	};
	var counter = 0;
	makeRequest();
	function makeRequest() {
		counter++;
		request(options, function (error, response, body) {
			console.log(error, response, body);
			if(body.toString().search("Time limit") != -1) {
				if(counter < 20) {
					makeRequest();
				}else {
					res.send([]);
				}
			}else {
				if (!error && response.statusCode == 200) {
					res.send(body);
				}else {
					res.send(error);
				}	
			}
		});	
	}
	
	// var query = req.body.weight + ' ' +  + ' ' + req.body.al + ' ' + req.body.bulking + ' ' + req.body.meals;
	// var process =  require('child_process'); process.exec("ruby script.rb \'" + query+ '\'' ,function (err,stdout,stderr) {
	// if(err){
	// 	console.log(stderr);
	// 	res.send(stderr);
	// } else {
	// 	console.log(stdout);
	// 	res.send(stdout);
	// } });
});
