var Storage = require('./storage');

var gameDefaults = {
    // === configurable options ===
    mute: true,     // Mute all sounds
    preload: true,  // Preload all images while game is starting
    autosave_on_click: false,   // Autosave after each click
    log: false,     // Enable logging
    // === end of configurable options ===
    id: null,
    name: 'Default Game',
    autosaveID: 9,
    importID: 10,
    saveSlots: 5,
    inventory_mode: 'vertical',
    scroll_mode: 'none',
    ways_mode: 'top',
    path: './game/',
    themePath: './themes/',
    ownTheme: false,
    clickSound: null
};

var Game = {
    reset: function reset() {
        Object.keys(gameDefaults).forEach(function resetConfig(key) {
            Game[key] = gameDefaults[key];
        });
    },
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
    },
    load: function load(slotId) {
        return Storage.load(Game.getSaveName(slotId));
    },
    save: function save(slotId, content) {
        var slot = this.getSaveName(slotId);
        Storage.save(slot, content);
    },
    importSave: function importSave(content) {
        this.save(this.importID, content);
    },
    allSaves: function allSaves() {
        return Storage.get(this.id);
    }
};

Game.reset(); // run once to initialize

module.exports = Game;
