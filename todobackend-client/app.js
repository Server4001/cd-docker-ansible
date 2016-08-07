'use strict';

const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.static('public'));

const server = app.listen(port, (err) => {
    if (err) {
        console.log('ERROR', err);
    } else {
        console.log(`Todo Client started on port ${server.address().port}`);
    }
});
