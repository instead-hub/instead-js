var Storage = require('./storage');

var Game = {
    id: 'default',
    autosaveID: 9,
    saveSlots: 5,
    inventory_mode: 'vertical',
    path: './game/',
    themePath: './themes/',
    getSaveName: function getSaveName(i) {
        var id = i ? i : 0;
        return this.id + '-save-' + id;
    },
    getPrefsName: function getPrefsName(i) {
        var id = i ? i : 0;
        return this.id + '-prefs-' + id;
    },
    saveExists: function saveExists(id) {
        return Storage.exists(this.getSaveName(id));
    }
};

module.exports = Game;
