'use strict';

module.exports = (function() {
    /**
     * Object with methods that assists with handling PID files.
     */
    return {

        /**
         * Delete the PID file from disk, if it exists.
         *
         * @param {object} fs - The file system module in Node.
         * @param {string} pidFile - File path to the file containing an old process's PID.
         *
         * @returns {boolean} - Did we actually delete a file?
         */
        deletePidFile(fs, pidFile) {
            let fileExists = false;

            try {
                // Check if the PID file exists.
                fs.accessSync(pidFile, fs.F_OK);
                fileExists = true;
            } catch (e) {
                console.log('[' + new Date().toString() + '] Node.js master process PID file does not exist.');
            }

            if (!fileExists) {
                return false;
            }

            console.log('[' + new Date().toString() + '] Deleting old Node.js master process PID file.');
            fs.unlinkSync(pidFile);

            return true;
        },

        /**
         * Delete the PID file from disk and exit out of the current process.
         *
         * @param {object} fs - The file system module in Node.
         * @param {string} pidFile - File path to the file containing the current process's PID.
         */
        pidCleanup(fs, pidFile) {
            try {
                console.log('[' + new Date().toString() + '] Deleting current Node.js master process PID file.');
                fs.unlinkSync(pidFile);
            } catch (e) {
                console.log('[' + new Date().toString() + '] Unable to clean up current Node.js master process PID file. Exception message: ' + e.message);
            }

            process.exit();
        }
    };
})();
