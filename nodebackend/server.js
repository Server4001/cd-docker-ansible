'use strict';

const cluster = require('cluster');

if (cluster.isMaster) {
    require('./master');

    return;
}

const express = require('express');
const morgan = require('morgan');

const app = express();
app.set('port', process.env.NODE_SERVER_PORT || 8080);
app.set('env', process.env.NODE_SERVER_ENVIRONMENT || 'dev');

const apiV1Router = require('./routes/api/v1')(app);

let skip = null;
let logFormat = 'dev';
if (app.get('env') !== 'dev') {
    skip = (req, res) => res.statusCode < 400;
    logFormat = 'combined';
}

app.use(morgan(logFormat, {
    skip
}));

app.use('/api/v1', apiV1Router);

const server = app.listen(app.get('port'), function(err) {
    if (err) {
        console.log(`ERROR: ${err}`);
    } else {
        console.log(`TODO Backend started on port ${server.address().port}`);
    }
});
