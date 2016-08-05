'use strict';

const cluster = require('cluster');
const fs = require('fs');
const pidHandler = require('./lib/file_handling/pid_handler');
const pidFile = '/var/nodebackend/nodebackend.pid';

pidHandler.deletePidFile(fs, pidFile);

console.log('[' + new Date().toString() + '] Creating new Node.js master process PID file.');
fs.writeFileSync(pidFile, process.pid, {
    mode: 0o644
});

cluster.fork();

process.on('SIGHUP', () => {
    console.log('[' + new Date().toString() + '] Reloading...');
    const new_worker = cluster.fork();

    new_worker.once('listening',  () => {
        for(let id in cluster.workers) {
            if (id === new_worker.id.toString()) {
                continue;
            }

            cluster.workers[id].kill('SIGTERM');
        }
    });
});

process.on('SIGTERM', () => {
    pidHandler.pidCleanup(fs, pidFile);
});

process.on('SIGINT', () => {
    pidHandler.pidCleanup(fs, pidFile);
});
