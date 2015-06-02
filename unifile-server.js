// node modules
var unifile = require('unifile');
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var session = require('express-session');
var multipart = require('connect-multiparty');
var FSStore = require('connect-fs2')(session);

// init express
var app = express();

// gzip/deflate outgoing responses
var compression = require('compression')
app.use(compression())

// parse data for file upload
app.use('/', multipart({limit: '100mb'}));

// parse data for post and get requests
app.use('/', bodyParser.urlencoded({
    extended: true,
    limit: '10mb'
}));
app.use('/', bodyParser.json({limit: '10mb'}));
app.use('/', cookieParser());

// session management
app.use('/', session({
    secret: 'backnode default secret',
    resave: false,
    saveUninitialized: false,
    store: new FSStore({
        dir: __dirname + '/sessions'
    }),
    cookie: { maxAge: 7 * 24 * 60 * 60 * 1000 } // 1 week
}));

// ********************************
// production
// ********************************
var isDebug = false;
/**
 * catch all errors to prevent nodejs server crash
 */
function onCatchError(err) {
    console.log  ('---------------------');
    console.error('---------------------', 'Caught exception: ', err, '---------------------');
    console.log  ('---------------------');
}
// catch all errors and prevent nodejs to crash, production mode
// process.on('uncaughtException', onCatchError);

// config
var options = unifile.defaultConfig;

// change www root
options.www.ROOT = __dirname + '/dist';

// add static folders
options.staticFolders.push(
    // silex main site
    {
        path: __dirname + '/dist'
    },
    // debug silex, for js source map
    {
        name: '/src',
        path: __dirname + '/src'
    }
);

// unifile server
app.use('/api', unifile.middleware(express, app, options));

function setDebugMode(debug){
    if(debug && !isDebug){
        process.removeListener('uncaughtException', onCatchError);

        // DEBUG ONLY
        console.warn('Running server in debug mode');
        // define users (login/password) wich will be authorized to access the www folder (read and write)
        options.www.USERS = {
            'admin': 'admin'
        }
    }
    if(!debug && isDebug){
        // PRODUCTION ONLY
        console.warn('Running server in production mode');
        // catch all errors and prevent nodejs to crash, production mode
        process.on('uncaughtException', onCatchError);
        // reset debug
        options.www.USERS = {};
    }
}

// get command line args
var debug = false;
for (var i in process.argv){
    var val = process.argv[i];
    if (val == '-debug') debug = true;
}

// debug or production mode
setDebugMode(debug);

// server 'loop'
var port = process.env.PORT || 6969;
app.listen(port, function() {
    console.log('Listening on ' + port);
});
