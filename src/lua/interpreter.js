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
    clear: function interpreterClear() {
        Lua.destroy();
        this.init();
    }
};

module.exports = Interpreter;
