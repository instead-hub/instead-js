// virtual file system
var stead = require('../../instead/stead.js');

var vfsData = {};

var vfs = {
    load: function load(path) {
        if (stead.hasOwnProperty(path)) {
            return stead[path];
        }
        if (vfsData.hasOwnProperty(path)) {
            return vfsData[path];
        }
        return null;
    },
    save: function save(path, content) {
        vfsData[path] = content;
    },
    isStead: function isStead(path) {
        // module is a part of INSTEAD core engine
        return stead.hasOwnProperty(path);
    },
    dump: function dump() {
        return JSON.stringify(vfsData);
    }
};

module.exports = vfs;
