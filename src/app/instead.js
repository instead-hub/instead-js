var interpreter = require('../lua/interpreter');
var UI = require('./ui');
var Game = require('./game');

var Logger = require('./log');

var Instead = {
    track: null,
    saveSlot: 'SAVE_GAME_SLOT',

    init: function init() {
        // initialize UI
        var self = this;
        var handler = {
            click: self.click.bind(self),
            reset: self.resetGame.bind(self),
            save: self.saveGame.bind(self),
            load: self.loadGame.bind(self)
        };
        UI.init(handler);

        interpreter.init();

        // this.track.autoplay = true;
        // this.track.loop = true;
        // this.track.muted = MenuDispatcher.Instance().muted;

        // MenuDispatcher.Instance().save.onclick = OnSaveClick;
        // MenuDispatcher.Instance().load.onclick = OnLoadClick;
    },

    startGame: function startGame(savedGame) {
        this.initGame();
        if (savedGame) {
            interpreter.loadgame(savedGame);
        }
        this.ifaceCmd('look');
        this.refreshInterface();
    },

    resetGame: function resetGame() {
        interpreter.clear();
        this.startGame();
    },

    initGame: function initGame() {
        // preloader
        interpreter.load('instead_js.lua');
        interpreter.call('instead_gamepath("' + Game.path + '")');
        // load game
        interpreter.load(Game.path + 'main.lua');
        interpreter.call('stead.game_ini(game)');
    },

    saveGame: function saveGame() {
        this.ifaceCmd('save ' + this.saveSlot);
    },

    loadGame: function loadGame() {
        interpreter.clear();
        this.startGame(this.saveSlot);
    },

    refreshInterface: function refreshInterface() {
        this.getTitle();
        this.getWays();
        this.getInv();
        this.getPicture();
        // this.getMusic();
        UI.refresh();
    },

    click: function click(uiref, field, onStead) {
        var ref = uiref;
        // if (MenuDispatcher.Instance().visible) return;
        if (!onStead && (UI.isAct || field === 'Inv')) {
            ref = ref.substr(1);
            if (ref.substr(0, 3) === 'act') {
                ref = 'use ' + ref.substr(4);
                this.ifaceCmd(ref);
                this.refreshInterface();
                return;
            }

            if (UI.isAct) {
                if (field !== 'Ways' && field !== 'Title') {
                    if (ref === UI.actObj) {
                        this.ifaceCmd('use ' + ref);
                    } else {
                        this.ifaceCmd('use ' + UI.actObj + ',' + ref);
                    }
                    UI.setAct(false);
                    UI.setActObj('');
                    this.refreshInterface();
                }
            } else {
                UI.setAct(true);
                UI.setActObj(ref);
            }
        } else {
            if (UI.isAct) {
                UI.setAct(false);
                UI.setActObj('');
            }
            this.ifaceCmd(ref);
            this.refreshInterface();
        }
    },

    getInv: function getInv() {
        var horizontalInventory = false;
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
        var title = interpreter.call('instead.get_title()');
        UI.setTitle(title);
    },

    getPicture: function getPicture() {
        var picturePath;
        var retVal = interpreter.call('instead.get_picture()');
        if (retVal[0] !== null) {
            picturePath = retVal[0];
        }
        UI.setPicture(picturePath);
    },
/*
    getMusic: function getMusic() {
        var retVal = interpreter.call('instead.get_music()');
        if (retVal[0] !== null) {
            var music_path = retVal[0];
            playMusic(music_path);
        }
    },
    */
/*
    playMusic: function playMusic(path) {
        if(track.src.indexOf(path) == -1) {
            track.src = _dofile_path + path;
            var i = 1;
        }
    },
*/
    ifaceCmd: function ifaceCmd(command) {
        var cmd = 'iface.cmd(iface, "' + command + '")';
        var retVal = interpreter.call(cmd);
        Logger.log('IFACE ' + command + '> ' + JSON.stringify(retVal));
        if (retVal && retVal[0] !== null) {
            var cmdAnswer = retVal[0];
            // var rc = retVal[1];
            if (cmdAnswer !== '') {
                UI.setText(cmdAnswer);
            }
        }
    }
};

module.exports = Instead;
