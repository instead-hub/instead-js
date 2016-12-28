var interpreter = require('../lua/interpreter');
var UI = require('./ui');
var Game = require('./game');
var HTMLAudio = require('./audio');

var Logger = require('./log');

var Instead = {
    init: function init() {
        this.handlers = {
            click: this.click.bind(this),
            reset: this.resetGame.bind(this),
            save: this.saveGame.bind(this),
            load: this.loadGame.bind(this),
            mute: this.soundMute.bind(this)
        };

        // preloader
        interpreter.init();
        interpreter.load('instead_js.lua');
    },

    startGame: function startGame(savedGameID) {
        interpreter.load('instead_js.lua');
        interpreter.call('js_instead_gamepath("' + Game.path + '")');
        setTimer(0);

        UI.loadTheme();
        this.initGame();
        if (savedGameID) {
            interpreter.loadgame(Game.getSaveName(savedGameID));
        }
        this.ifaceCmd('look');
        this.refreshInterface();
    },

    initGame: function initGame() {
        interpreter.load(Game.path + 'main.lua');
        interpreter.call('stead.game_ini(game)');
    },

    resetGame: function resetGame() {
        HTMLAudio.stopMusic();
        interpreter.clear();
        this.startGame();
    },

    saveGame: function saveGame(id) {
        this.ifaceCmd('save ' + Game.getSaveName(id));
    },

    loadGame: function loadGame(id) {
        var self = this;
        if (Game.saveExists(id)) {
            HTMLAudio.stopMusic();
            interpreter.clear();
            setTimeout(function t() {
                self.startGame(id);
            }, 100);
        }
    },

    refreshInterface: function refreshInterface() {
        this.getTitle();
        this.getWays();
        this.getInv();
        this.getPicture();
        this.getMusic();
        UI.refresh();
    },

    click: function click(uiref, field, onStead) {
        var ref = uiref;
        if (!onStead && (UI.isAct || field === 'Inv')) {
            ref = ref.substr(1);
            if (ref.substr(0, 3) === 'act') {
                ref = 'use ' + ref.substr(4);
                this.ifaceCmd(ref);
                this.refreshInterface();
                this.autoSave();
                return;
            }

            if (UI.isAct) {
                if (field !== 'Ways' && field !== 'Title') {
                    if (ref === UI.actObj) {
                        this.ifaceCmd('use ' + ref);
                    } else {
                        this.ifaceCmd('use ' + UI.actObj + ',' + ref);
                    }
                    UI.setAct(false, '');
                    this.refreshInterface();
                    this.autoSave();
                }
            } else {
                UI.setAct(true, ref);
            }
        } else {
            if (UI.isAct) {
                UI.setAct(false, '');
            }
            this.ifaceCmd(ref);
            this.refreshInterface();
            this.autoSave();
        }
    },

    getInv: function getInv() {
        var horizontalInventory = (Game.inventory_mode === 'horizontal');
        var retVal = interpreter.call('instead.get_inv(' + horizontalInventory + ')');
        if (retVal[0] === null) {
            UI.setInventory('');
        } else {
            UI.setInventory(retVal[0]);
        }
    },

    getWays: function getWays()    {
        var waysAnswer = interpreter.call('instead.get_ways()');
        UI.setWays(waysAnswer[0]);
    },

    getTitle: function getTitle() {
        var retVal = interpreter.call('instead.get_title()');
        UI.setTitle(retVal[0]);
    },

    getPicture: function getPicture() {
        var picturePath;
        var retVal = interpreter.call('instead.get_picture()');
        if (retVal[0] !== null) {
            picturePath = retVal[0];
        }
        UI.setPicture(picturePath);
    },

    getMusic: function getMusic() {
        var retVal = interpreter.call('instead.get_music()');
        if (retVal[0] !== null) {
            var musicPath = retVal[0];
            if (musicPath.indexOf(Game.path) === -1) {
                musicPath = Game.path + musicPath;
            }
            HTMLAudio.playMusic(musicPath, 0);
        }
    },

    ifaceCmd: function ifaceCmd(command) {
        var cmd = 'iface.cmd(iface, "' + command + '")';
        var retVal = interpreter.call(cmd);
        Logger.log('');
        Logger.log('> ' + command);
        Logger.log(JSON.stringify(retVal));
        if (retVal && retVal[0] !== null) {
            var cmdAnswer = retVal[0];
            if (cmdAnswer !== '') {
                UI.setText(cmdAnswer);
            }
        }
    },

    soundMute: function soundMute(value) {
        Game.mute = value;
        HTMLAudio.mute(value);
    },

    autoSave: function autoSave(force) {
        if (Game.autosave_on_click || force) {
            this.saveGame(Game.autosaveID); // autosave
        }
    }
};

var LuaTimer; // eslint-disable-line no-unused-vars

function setTimer(t) {
    var time = parseInt(t, 10);
    if (time === 0) {
        LuaTimer = null;
    } else {
        LuaTimer = window.setTimeout(
            function LuaTimeout() {
                Instead.ifaceCmd('user_timer');
                Instead.refreshInterface();
            }, time);
    }
}

window.instead_settimer = setTimer;

window.onbeforeunload = function autoSaveOnClose() {
    if (Game.id) {
        Instead.autoSave(true); // force autosave
    }
};

module.exports = Instead;
