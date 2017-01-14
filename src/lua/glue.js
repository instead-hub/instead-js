/* global Lua */
require('script-loader!../../instead/lua.vm.js');
var stead = require('../../instead/stead.js');
var ajaxGetSync = require('../ajax');

var Game = require('../app/game');
var Storage = require('../app/storage');

// convert non latin symbols
function utf8encode(str) {
    var string = str;
    string = string.replace(/\r\n/g, '\n');
    var utftext = '';
    for (var n = 0; n < string.length; n++) {
        var c = string.charCodeAt(n);
        if (c < 128) {
            utftext += String.fromCharCode(c);
        } else if (c > 127) {
            utftext += '&#';
            utftext += c;
            utftext += ';';
        }
    }
    return utftext;
}

// synchronous ajax to get file, so code executed before function returns
function runLuaFromPath(path) {
    try {
        var luacode = stead.hasOwnProperty(path) ? stead[path] : ajaxGetSync(path);
        // check if download worked
        if ((typeof luacode) !== 'string') {
            throw String('RunLuaFromPath failed "' + path + '" :' +
                         ' type=' + (typeof luacode) +
                         ' val=' + String(luacode));
        }

        var code = utf8encode(luacode);
        Lua.cache.items = {}; // Clear cache;
        return Lua.exec(code, path);
    } catch (e) {
        console.error('Error: file ' + path + ' : ' + String(e) + ' :\n', e); // eslint-disable-line no-console
    }
    return null;
}


function luaRequire(filepath) {
    var path = filepath;
    // path transformations
    if (path.substr(-4) === '.lua') {
        path = path.slice(0, -4); // require automatically appends .lua to the filepath later, remove it here
    }
    path = path.replace(/\./g, '/');
    if (!stead.hasOwnProperty(path + '.lua')) {
        // require unknown core module, assume loading from game files
        path = Game.path + path;
    }
    if (Lua.requires[path]) {
        return null;
    }
    Lua.requires[path] = true;
    return runLuaFromPath(path + '.lua');
}

function luaDofile(filepath) {
    return runLuaFromPath(Game.path + filepath);
}

function saveFile(path, data) {
    Storage.save(path, data);
}

function loadFile(path) {
    return Storage.load(path);
}

function openFile(path) {
    var filepath = path;
    if (filepath.indexOf(Game.path) === -1) {
        filepath = Game.path + path; // add game path if it's not present already
    }
    var content = encodeURIComponent(utf8encode(ajaxGetSync(filepath)));
    return Lua.eval('instead_openfile("' + path + '","' + content + '")');
}

var Glue = {
    init: function glueInit() {
        Lua.requires = {};
        Lua.inject(luaRequire, 'require');
        Lua.inject(luaDofile, 'dofile');
        Lua.saveFile = saveFile;
        Lua.loadFile = loadFile;
        Lua.openFile = openFile;
    },
    runLuaFromPath: runLuaFromPath
};

module.exports = Glue;
