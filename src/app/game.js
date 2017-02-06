var Storage = require('./storage');

var Game = {
    id: null,
    name: 'Default Game',
    // === configurable options ===
    mute: true,     // Mute all sounds
    preload: true,  // Preload all images while game is starting
    autosave_on_click: false,   // Autosave after each click
    log: false,     // Enable logging
    // === end of configurable options ===
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
    },
    loadConfig: function loadConfig(cfg) {
        Object.keys(cfg).forEach(function applyConfig(key) {
            Game[key] = cfg[key];
        });
    }
};

module.exports = Game;
