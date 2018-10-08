/* global Lua */
require('script-loader!../../instead/lua.vm.js');
var Game = require('../app/game');
var vfs = require('../app/vfs');
var Storage = require('../app/storage');
var Logger = require('../app/log');

// synchronous ajax to get file, so code executed before function returns
function runLuaFromPath(path) {
    try {
        var luacode = vfs.readfile(path);
        // check if download worked
        if ((typeof luacode) !== 'string') {
            throw String('RunLuaFromPath failed "' + path + '" :' +
                         ' type=' + (typeof luacode) +
                         ' val=' + String(luacode));
        }

        Lua.cache.items = {}; // Clear cache;
        return Lua.exec(luacode, path);
    } catch (e) {
        console.error('Error: file ' + path + ' : ' + String(e) + ' :\n', e); // eslint-disable-line no-console
    }
    return null;
}

function requireContent(filepath) {
    var path = filepath;
    // path transformations
    if (path.substr(-4) === '.lua') {
        path = path.slice(0, -4); // require automatically appends .lua to the filepath later, remove it here
    }
    path = path.replace(/\./g, '/');
    if (!vfs.isStead(path + '.lua')) {
        // require unknown core module, assume loading from game files
        path = Game.fileURL(path + '.lua');
    } else {
        path = path + '.lua';
    }
    return vfs.readfile(path);
}

function luaDofile(filepath) {
    return runLuaFromPath(Game.fileURL(filepath));
}


function saveFile(path) {
    var filepath = path;
    if (path.search(/prefs\.tmp/) !== -1) {
        filepath = Game.getPrefsName();
    }
    var data = Lua.eval('instead_file_get_content("' + path + '")');
    Storage.save(filepath, data[1]);
}

function loadFile(path) {
    var filepath = path;
    if (path.search(/prefs/) !== -1) {
        filepath = Game.getPrefsName();
    }
    return Storage.load(filepath);
}

function openFile(path) {
    var filepath = Game.fileURL(path);
    return vfs.readfile(filepath);
}

function gameInfo() {
    return {
        id: Game.id,
        name: Game.name,
        stead: Game.stead
    };
}

var Interpreter = {
    init: function interpreterInit() {
        Lua.initialize();
        Lua.requires = {};
        Lua.inject(luaDofile, 'dofile');
        Lua.requireContent = requireContent
        Lua.saveFile = saveFile;
        Lua.loadFile = loadFile;
        Lua.openFile = openFile;
        Lua.gameinfo = gameInfo; // to be used by external handlers
        Lua.logWarning = function logWarning(msg) {
            Logger.log('{warning} ' + msg);
        };
        Lua.set_error_callback(function errCb(errorMsg) {
            Logger.log('{error} ' + errorMsg);
        });
    },
    loadStead: function loadStead(version) {
        var path = (version === 3) ? './stead3.json' : './stead2.json';
        var stead = JSON.parse(vfs.readfile(path));
        vfs.updateStead(stead);
    },
    call: function interpreterCall(command) {
        var result = Lua.eval(command);
        if (result) {
            return result[0];
        }
        return null;
    },
    load: function interpreterLoad(path) {
        return runLuaFromPath(path);
    },
    clear: function interpreterClear() {
        Lua.destroy();
        this.init();
    }
};

module.exports = Interpreter;
