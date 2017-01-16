var interpreter = require('../lua/interpreter');
var UI = require('./ui');
var Game = require('./game');
var HTMLAudio = require('./audio');
var Keyboard = require('./ui/keyboard');

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
        document.body.addEventListener('keydown', kbdEvent);
        document.body.addEventListener('keyup', kbdEvent);

        // preloader
        interpreter.init();
        interpreter.load('instead_js.lua');
    },

    startGame: function startGame(savedGameID) {
        interpreter.load('instead_js.lua');
        interpreter.call('js_instead_gamepath("' + Game.path + '")');
        setTimer(0);

        UI.loadTheme();
        this.clickSound(true); // preload click sound
        this.initGame();
        if (savedGameID) {
            this.ifaceCmd('load ' + Game.getSaveName(savedGameID));
        }
        this.ifaceCmd('look');
        this.refreshInterface();
    },

    initGame: function initGame() {
        interpreter.load(Game.path + 'main.lua');
        interpreter.call('instead_define_keyboard_hooks()');
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

    click: function click(uiref, field, onStead) {
        var ref = uiref;
        this.clickSound(); // play click sound

        if (typeof ref === 'object') {
            var text = interpreter.call('instead_click(' + ref.x + ', ' + ref.y + ')');
            if (text !== null) {
                UI.setText(text);
                this.refreshInterface();
            }
            return;
        }

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

    kbd: function keyboardHandler(ev) {
        if (ev) {
            interpreter.call('instead.input("kbd", ' + ev.down +  ', "' + ev.key + '")');
            this.ifaceCmd('user_kbd');
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

    getTitle: function getTitle() {
        UI.setTitle(interpreter.call('instead.get_title()'));
    },

    getWays: function getWays()    {
        UI.setWays(interpreter.call('instead.get_ways()'));
    },

    getInv: function getInv() {
        var horizontalInventory = (Game.inventory_mode === 'horizontal');
        var inventory = interpreter.call('instead.get_inv(' + horizontalInventory + ')');
        if (inventory === null) {
            UI.setInventory('');
        } else {
            UI.setInventory(inventory);
        }
    },

    getPicture: function getPicture() {
        UI.setPicture(interpreter.call('instead.get_picture()'));
    },

    getMusic: function getMusic() {
        var musicPath = interpreter.call('instead.get_music()');
        if (musicPath !== null) {
            if (musicPath.indexOf(Game.path) === -1) {
                musicPath = Game.path + musicPath;
            }
            HTMLAudio.playMusic(musicPath, 0);
        }
    },

    ifaceCmd: function ifaceCmd(command) {
        var cmd = 'iface.cmd(iface, "' + command + '")';
        var text = interpreter.call(cmd);
        if (command !== 'user_timer') {
            Logger.log('> ' + command);
        }
        if (text !== null && command.indexOf('save') !== 0) {
            UI.setText(text);
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
    },

    clickSound: function clickSound(isCache) {
        if (Game.clickSound) {
            HTMLAudio.playSound(Game.clickSound, null, isCache);
        }
    }
};

function kbdEvent(event) {
    Instead.kbd(Keyboard.handler(event));
}


var LuaTimer; // eslint-disable-line no-unused-vars

function setTimer(t) {
    var time = parseInt(t, 10);
    if (time === 0) {
        window.clearInterval(LuaTimer);
    } else {
        LuaTimer = window.setInterval(
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
