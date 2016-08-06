'use strict';

// Run from nodebackend project root: mocha test/integration/routes.js
// Or: mocha test/integration

const should = require('should');
const assert = require('assert');
const supertest = require('supertest');
const request = supertest.agent('http://localhost:8080/api/v1');

describe('Routing', () => {
    // If you needed to do any setup, you can use before():
    // before((done) => {
    //     mongoose.connect('mongodb://localhost/myapp');
    //     done();
    // });

    describe('List', () => {
        it('should list all todos', (done) => {
            request
                .get('/')
                .end((err, res) => {
                    if (err) {
                        throw err;
                    }

                    res.status.should.equal(200);
                    (typeof res.body).should.equal('object');
                    res.body.length.should.equal(2);

                    for (let todo of res.body) {
                        todo.should.have.property('url');
                        // todo.should.have.property('url', 'http://whatever.com/a/b/c.png');
                        todo.should.have.property('title');
                        todo.should.have.property('completed');
                        todo.should.have.property('order');
                    }

                    done();
                });
        });
    });
});
