var Storage = require('./storage');

var gamefsBlob = {};

var gameDefaults = {
    // === configurable options ===
    mute: true,     // Mute all sounds
    preload: true,  // Preload all images while game is starting
    autosave_on_click: false,   // Autosave after each click
    log: false,     // Enable logging
    fading: false,  // Enable fade between scenes
    // === end of configurable options ===
    id: null,
    stead: 2,
    name: 'Default Game',
    details: {
        author: '',
        version: '',
        info: ''
    },
    gJournal: [], // game event log
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
    isAct: false, // 'act' mode flag
    actObj: null  // ref to act object
};

var Game = {
    mainLua: function mainLua() {
        var fullpath = this.path + (this.stead === 2 ? 'main.lua' : 'main3.lua');
        if (gamefsBlob.hasOwnProperty(fullpath)) {
            return gamefsBlob[fullpath];
        }
        return fullpath;
    },
    reset: function reset() {
        Object.keys(gameDefaults).forEach(function resetConfig(key) {
            Game[key] = gameDefaults[key];
        });
        gamefsBlob = {};
    },
    getSaveName: function getSaveName(i) {
        var id = i ? i : 0;
        return this.id + '-save-' + id;
    },
    getPrefsName: function getPrefsName() {
        return this.id + '-prefs';
    },
    saveExists: function saveExists(id) {
        if (typeof id === 'undefined') {
            return false;
        }
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
    },
    addFile: function addFile(path, url) {
        gamefsBlob[path] = url;
    },
    fileURL: function fileURL(filename) {
        var fullpath = filename;
        Game.journal('[file: ' + filename + ']');
        // direct self-reference here, since fileURL is used as callback
        if (filename.indexOf(Game.path) === -1) {
            fullpath = Game.path + filename;
        }
        fullpath = fullpath.trim()
            .replace(/\\/g, '\/')
            .replace(/\/+/g, '\/'); // fix multiple slashes
        if (gamefsBlob.hasOwnProperty(fullpath)) {
            return gamefsBlob[fullpath];
        }
        return fullpath;
    },
    journal: function gameJournal(message) {
        Game.gJournal.push(message);
    }
};

Game.reset(); // run once to initialize

module.exports = Game;
