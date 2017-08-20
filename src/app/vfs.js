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
        if (path.indexOf('blob') === 0) {
            // normal query when load from ZIP file
            return ajaxGetSync(path);
        }
        var avoidCache = Math.random().toString(36).substring(7);
        return ajaxGetSync(path + '?' + avoidCache);  // avoid cached response
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
    },
    exportFile: function exportFile(filename, content) {
        var data = new Blob([content], {type: 'octet/stream'});
        var dataUrl = window.URL.createObjectURL(data);
        var ref = document.createElement('a');
        document.body.appendChild(ref);
        ref.style = 'display: none';
        ref.href = dataUrl;
        ref.download = filename;
        ref.click();
        window.URL.revokeObjectURL(dataUrl);
        ref.remove();
    }
};

module.exports = vfs;
