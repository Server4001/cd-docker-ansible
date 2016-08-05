'use strict';

module.exports = function(app) {
    const express = require('express');
    const router = express.Router();

    router.get('/', function(req, res) {
        res.json({
            status: 'success',
            data: {}
        });
    });

    return router;
};
