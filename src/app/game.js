var Storage = require('./storage');

var Game = {
    id: null,
    name: 'Default Game',
    mute: true,
    preload: true,
    autosave_on_click: false,
    autosaveID: 9,
    importID: 10,
    saveSlots: 5,
    inventory_mode: 'vertical',
    scroll_mode: 'none',
    ways_mode: 'top',
    path: './game/',
    themePath: './themes/',
    ownTheme: false,
    clickSound: null,
    getSaveName: function getSaveName(i) {
        var id = i ? i : 0;
        return this.id + '-save-' + id;
    },
    saveExists: function saveExists(id) {
        return Storage.exists(this.getSaveName(id));
    }
};

module.exports = Game;
