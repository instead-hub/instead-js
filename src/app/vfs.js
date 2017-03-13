// virtual file system
var stead = require('../../instead/stead.js');
var ajaxGetSync = require('../ajax');

var vfsData = {};

var vfs = {
    readfile: function readfile(path) {
        if (stead.hasOwnProperty(path)) {
            return stead[path];
        }
        if (vfsData.hasOwnProperty(path)) {
            return vfsData[path];
        }
        return ajaxGetSync(path);
    },
    save: function save(path, content) {
        vfsData[path] = content;
    },
    isStead: function isStead(path) {
        // module is a part of INSTEAD core engine
        return stead.hasOwnProperty(path);
    },
    updateStead: function updateStead(steadJson) {
        Object.keys(steadJson).forEach(function upd(filename) {
            stead[filename] = steadJson[filename];
        });
    },
    dump: function dump() {
        return JSON.stringify(vfsData);
    }
};

module.exports = vfs;
