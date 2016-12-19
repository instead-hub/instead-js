/* global Lua */

var Glue = require('./glue');

var Interpreter = {
    pathFunc: null,
    init: function interpreterInit() {
        Lua.initialize();
        Glue.init();
    },
    call: function interpreterCall(command) {
        return Lua.eval(command);
    },
    load: function interpreterLoad(path) {
        Glue.runLuaFromPath(path);
    },
    loadgame: function loadgame(path) {
        return Lua.eval('instead_loadgame("' + Lua.loadFile(path) + '")');
    },
    clear: function interpreterClear() {
        Lua.destroy();
        Lua.initialize();
        Glue.init();
    }
};

module.exports = Interpreter;
