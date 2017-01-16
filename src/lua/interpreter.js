/* global Lua */

var Glue = require('./glue');

var Interpreter = {
    pathFunc: null,
    init: function interpreterInit() {
        Lua.initialize();
        Glue.init();
    },
    call: function interpreterCall(command) {
        var result = Lua.eval(command);
        return result[0];
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
