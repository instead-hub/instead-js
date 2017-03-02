/* global Lua */
require('script-loader!../../instead/lua.vm.js');
var ajaxGetSync = require('../ajax');
var Game = require('../app/game');
var vfs = require('../app/vfs');
var Storage = require('../app/storage');

// synchronous ajax to get file, so code executed before function returns
function runLuaFromPath(path) {
    try {
        var luacode = vfs.load(path);
        if (!luacode) {
            luacode = ajaxGetSync(path);
        }
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

function luaRequire(filepath) {
    var path = filepath;
    // path transformations
    if (path.substr(-4) === '.lua') {
        path = path.slice(0, -4); // require automatically appends .lua to the filepath later, remove it here
    }
    path = path.replace(/\./g, '/');
    if (!vfs.isStead(path + '.lua')) {
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


function saveFile(path) {
    var filepath = path;
    if (path.search(/prefs\.tmp/) !== -1) {
        filepath = 'PREFS';
    }
    var data = Lua.eval('instead_file_get_content("' + path + '")');
    Storage.save(filepath, data[1]);
}

function loadFile(path) {
    var filepath = path;
    if (path.search(/prefs/) !== -1) {
        filepath = 'PREFS';
    }
    return Storage.load(filepath);
}

function openFile(path) {
    var filepath = path;
    if (filepath.indexOf(Game.path) === -1) {
        filepath = Game.path + path; // add game path if it's not present already
    }
    return ajaxGetSync(filepath);
}

var Interpreter = {
    init: function interpreterInit() {
        Lua.initialize();
        Lua.requires = {};
        Lua.inject(luaRequire, 'require');
        Lua.inject(luaDofile, 'dofile');
        Lua.saveFile = saveFile;
        Lua.loadFile = loadFile;
        Lua.openFile = openFile;
    },
    loadStead: function loadStead(version) {
        var path = (version === 3) ? './stead3.json' : './stead2.json';
        var stead = JSON.parse(ajaxGetSync(path));
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
