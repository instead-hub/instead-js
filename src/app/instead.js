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
        // interpreter.load('instead_js.lua');
    },

    initGame: function initGame(gameData) {
        // Allowed properties: path, id, name, details, ownTheme, stead
        for (var property in gameData) {
            if (gameData.hasOwnProperty(property)) {
                Game[property] = gameData[property];
            }
        }
    },

    startGame: function startGame(savedGameID) {
        // load corresponding STEAD lua files
        interpreter.loadStead(Game.stead);
        // initialize INSTEAD
        interpreter.load('instead_init.lua');
        setTimer(0);            // reset game timers
        UI.loadTheme();         // load theme
        this.clickSound(true);  // preload click sound

        // init game
        interpreter.call('js_instead_gamepath("' + Game.path + '")');
        interpreter.load(Game.mainLua());
        interpreter.call('game:ini()');
        // load game, if required
        if (Game.saveExists(savedGameID)) {
            this.ifaceCmd('load ' + Game.getSaveName(savedGameID), true, true);
        } else {
            // start game
            this.ifaceCmd('look', true, true);
        }
    },

    resetGame: function resetGame() {
        var self = this;
        HTMLAudio.stopMusic();
        interpreter.clear();
        setTimeout(function t() {
            self.startGame();
        }, 100);
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
        var refID;

        if (uiref !== null && typeof ref === 'object') {
            var text = interpreter.call('instead_click(' + ref.x + ', ' + ref.y + ')');
            if (text !== null) {
                this.clickSound();
                this.refreshInterface(text);
            }
            return;
        }

        if (!onStead && (Game.isAct || field === 'Inv')) {
            refID = ref.match(/([\d]+)/)[0];
            if (ref.search('act') === 0 || ref.search('act') === 1 ) {
                this.clickSound();
                this.ifaceCmd('use ' + refID, true);
                this.autoSave();
                return;
            }
            if (Game.isAct) {
                if (field !== 'Ways' && field !== 'Title') {
                    this.clickSound();
                    if (refID === Game.actObj) {
                        this.ifaceCmd('use ' + refID, true);
                    } else {
                        this.ifaceCmd('use ' + Game.actObj + ',' + refID, true);
                    }
                    UI.setAct(false, '');
                    this.autoSave();
                }
            } else {
                UI.setAct(true, refID);
            }
        } else {
            if (Game.isAct) {
                UI.setAct(false, '');
            }
            if (ref) {
                this.clickSound();
                this.ifaceCmd(ref, true);
                this.autoSave();
            }
        }
    },

    kbd: function keyboardHandler(ev) {
        if (ev) {
            var kbdHandler = interpreter.call('iface:input("kbd", ' + ev.down +  ', "' + ev.key + '")');
            if (kbdHandler && kbdHandler !== 'nil') {
                this.ifaceCmd(kbdHandler, true);
            }
            if (ev.text) {
                var textHandler = interpreter.call('iface:input("text", "' + ev.text + '")');
                if (textHandler && textHandler !== 'nil') {
                    this.ifaceCmd(textHandler, true);
                }
            }
        }
    },

    // do not use fade effect, if the game just started
    refreshInterface: function refreshInterface(text, isStart) {
        var isFading = interpreter.call('instead.get_fading()');
        if (isFading && Game.fading && !isStart) {
            UI.fadeOut(function fadeCallback() {
                Instead.updateUI(text);
                UI.fadeIn();
            });
        } else {
            this.updateUI(text);
        }
        // check if restart required
        var isRestart = interpreter.call('instead.get_restart()');
        if (isRestart) {
            this.resetGame();
        }
    },

    updateUI: function updateUI(text) {
        var inventory;
        var horizontalInventory;
        var musicPath;
        var soundPath;
        // sound
        soundPath = interpreter.call('instead.get_sound()');
        if (soundPath !== null) {
            soundPath.split(';').forEach(function parseSound(item) {
                var soundFile = (item.split('@'))[0];
                if (soundFile !== '') {
                    HTMLAudio.playSound(Game.fileURL(soundFile));
                }
            });
        }
        // music
        musicPath = interpreter.call('instead.get_music()');
        if (musicPath === null) {
            HTMLAudio.stopMusic();
        } else {
            HTMLAudio.playMusic(Game.fileURL(musicPath), 0, function cbOnEnd() {
                // call when music is finished
                interpreter.call('instead.finish_music()');
            });
        }
        // title
        UI.setTitle(interpreter.call('instead.get_title()'));
        // ways
        UI.setWays(interpreter.call('instead.get_ways()'));
        // inventory
        horizontalInventory = (Game.inventory_mode === 'horizontal');
        inventory = interpreter.call('instead.get_inv(' + horizontalInventory + ')');
        if (inventory === null) {
            UI.setInventory('');
        } else {
            UI.setInventory(inventory);
        }
        // picture
        UI.setPicture(interpreter.call('instead.get_picture()'));
        // text
        if (text) {
            UI.setText(text);
        }
        // refresh
        UI.refresh();
    },

    ifaceCmd: function ifaceCmd(ifacecmd, refreshUI, isStart) {
        var ifaceOutput = null;
        // remove part of command before slash
        var command = ifacecmd;
        if (command[0] !== '#') {
            command = ifacecmd.replace(/^([^\/]+\/)/, '');
        }
        var cmd = 'iface:cmd("' + command + '")';
        var text = interpreter.call(cmd);
        if (command !== 'user_timer') {
            Logger.log('> ' + command);
        }
        if (text !== null && command.indexOf('save') !== 0) {
            ifaceOutput = text;
        }
        if (refreshUI) {
            this.refreshInterface(ifaceOutput, isStart);
        }
    },

    timerCmd: function timerCmd() {
        var timerHandler = interpreter.call('stead.timer()');
        if (timerHandler && timerHandler !== 'nil') {
            Instead.ifaceCmd(timerHandler, true); // use direct reference, since context is lost
        }
    },

    soundMute: function soundMute(value) {
        Game.mute = value;
        HTMLAudio.mute(value);
    },

    autoSave: function autoSave(force) {
        if (Game.autosave_on_click || force) {
            interpreter.call('instead.autosave(' + Game.autosaveID + ')'); // enable autosave
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
    if (!Game.id) {
        // do not handle keyboard events
        // if game is not loaded yet
        return;
    }
    Instead.kbd(Keyboard.handler(event));
}


var LuaTimer; // eslint-disable-line no-unused-vars

function setTimer(t) {
    window.clearInterval(LuaTimer); // clear previous timer
    var time = parseInt(t, 10);
    if (time > 0) {
        LuaTimer = window.setInterval(
            Instead.timerCmd,
            time
        );
    }
}

window.instead_settimer = setTimer;

window.onbeforeunload = function autoSaveOnClose() {
    if (Game.id) {
        Instead.autoSave(true); // force autosave
    }
};

document.onblur = function onBlur() {
    // reset Alt modifier
    Instead.kbd({key: 'alt', down: 'false'});
};

module.exports = Instead;
