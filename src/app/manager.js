var $ = require('jquery');

var Game = require('./game');
var Instead = require('./instead');
var UI = require('./ui');
var Preloader = require('./ui/preloader');

var gamepath = './games/';
var gameList = gamepath + 'games_list.json';
var allGames;

var Manager = {
    init: function init() {
        this.el = $('#manager');
        this.el.perfectScrollbar({wheelSpeed: 1});
        this.el.append('<a href="" id="loading">Loading...</a>');

        var self = this;
        this.el.on('click', 'a', function selectGame(e) {
            e.preventDefault();
            var gameid = $(this).attr('data-ref');
            self.startGame(gameid);
        });

        $.get(gameList, function listGames(data) {
            allGames = typeof data === 'object' ? data : JSON.parse(data);
            var chosenGame = null;
            var gameIds = Object.keys(allGames);
            if (gameIds.length === 1) {
                // If there is only one game, start it immediately
                chosenGame = gameIds[0];
            } else {
                var gameUrl = window.location.hash.replace('#/', '');
                var gid = gameIds.indexOf(gameUrl);
                if (gid !== -1) {
                    chosenGame = gameIds[gid];
                }
            }

            if (chosenGame) {
                self.startGame(chosenGame);
            } else {
                $('#loading').remove();
                gameIds.forEach(function listGame(id) {
                    self.el.append('<a href="#/' + id + '" data-ref="' + id + '">' + allGames[id].name + '</a>');
                });
            }
        });
    },
    startGame: function startGame(gameid) {
        window.location.hash = '#/' + gameid;
        Game.path = gamepath + gameid + '/';
        Game.id = gameid;
        Game.name = allGames[gameid].name;
        Game.ownTheme = allGames[gameid].theme;
        if (Game.preload) {
            this.preload(gameid);
        }
        this.hide();
        Instead.startGame(Game.autosaveID);
    },
    /* TODO: return to game selection menu
    show: function show() {
        this.el.show();
        UI.hide();
    },
    */
    preload: function preload(gameid) {
        Preloader.load(
            allGames[gameid].preload,
            function preloadProgress(percent) {
                $('#stead-toolbar-info').html('Preloading images: ' + percent + '%');
            },
            function preloadSuccess() {
                $('#stead-toolbar-info').html('<b>' + Game.name + '</b>');
            }
        );
    },
    hide: function hide() {
        this.el.hide();
        UI.show();
        $('#stead-toolbar').show();
    }
};

module.exports = Manager;
