/* global Lua */
require('script-loader!../../instead/lua.vm.js');
var stead = require('../../instead/stead.js');

var Game = require('../app/game');

var localStorage = {};

function getSource(path, callback) {
    if (stead.hasOwnProperty(path)) {
        callback(stead[path]);
    } else {
        // download code via synchronous ajax... sjax? ;)
        ajaxGet(path, callback, true);
    }
}

function logOutput() {
    console.log(arguments); // eslint-disable-line no-console
}

// see http://www.w3.org/TR/XMLHttpRequest			sQuery = "bla.php?x="+escape(x)
function ajaxGet(sQuery, callback, bSynchronous) {
    var bAsync = true;
    if (bSynchronous) {
        bAsync = false;
    }
    var client = new XMLHttpRequest();
    client.onreadystatechange = function callbackHandler() {
        if (this.readyState === this.DONE) {
            if (this.status === 200) {
                callback(this.responseText);
            } else {
                callback(null, this.status);
            }
        }
    };
    client.open('GET', sQuery, bAsync);
    // ~ client.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
    client.send();
}

function execLuaCode(path, luacode) {
    var code = utf8encode(luacode);
    Lua.cache.items = {}; // Clear cache;
    return Lua.exec(code, path);
}

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
    var gLastLoadedLuaCode = false;
    try {
        getSource(path, function loadCode(luacode) {
            gLastLoadedLuaCode = luacode;
        });
        var luacode = gLastLoadedLuaCode;

        // check if download worked
        if ((typeof luacode) !== 'string') {
            throw String('RunLuaFromPath failed "' + path + '" :' +
                         ' type=' + (typeof luacode) +
                         ' val=' + String(luacode));
        }

        return execLuaCode(path, luacode);
    } catch (e) {
        // error during run, display infos as good as possible,
        // lua-stacktrace would be cool here, but hard without line numbers
        // if (!safe)
        logOutput('Error: file ' + path + ' : ' + String(e) + ' :\n', e);
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
    // require("bla") -> bla.lua
    // ~ NOTE: replaces parser lib lua_require(G, path);
}

function luaDofile(path) {
    return runLuaFromPath(Game.path + path);
}

function saveFile(path, data) {
    localStorage[path] = data;
}

function loadFile(path) {
    return localStorage[path];
}

var Glue = {
    init: function glueInit() {
        Lua.requires = {};
        Lua.inject(luaRequire, 'require');
        Lua.inject(luaDofile, 'dofile');
        Lua.saveFile = saveFile;
        Lua.loadFile = loadFile;
    },
    runLuaFromPath: runLuaFromPath
};

module.exports = Glue;
