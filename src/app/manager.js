var $ = require('jquery');

var i18n = require('./i18n');
var Game = require('./game');
var Instead = require('./instead');
var UI = require('./ui');
var Preloader = require('./ui/preloader');

var gamepath = './games/';
var gameList = gamepath + 'games_list.json';
var allGames;

var Manager = {
    init: function init() {
        this.container = $('#manager');
        this.el = $('#manager-gamelist');
        this.el.perfectScrollbar({wheelSpeed: 1});
        this.el.append('<div id="loading">' + i18n.t('loading') + '</div>');

        var self = this;
        this.el.on('click', 'a', function selectGame(e) {
            e.preventDefault();
            var gameid = $(this).attr('data-ref');
            self.startGame(gameid);
        });

        var gameListURL = gameList + '?' + Math.random().toString(36).substring(7); // avoid cached response
        $.get(gameListURL, function listGames(data) {
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
                gameIds
                    .sort(function gameListSorter(a, b) {
                        if (allGames[a].name > allGames[b].name) {
                            return 1;
                        }
                        if (allGames[a].name < allGames[b].name) {
                            return -1;
                        }
                        return 0;
                    })
                    .forEach(function listGame(id) {
                        self.el.append('<a href="#/' + id + '" data-ref="' + id + '">' + allGames[id].name + '</a>');
                    });
            }
        });
    },
    startGame: function startGame(gameid) {
        window.location.hash = '#/' + gameid;
        Instead.initGame({
            id: gameid,
            path: allGames[gameid].path || gamepath + gameid + '/',
            name: allGames[gameid].name,
            details: allGames[gameid].details,
            ownTheme: allGames[gameid].theme,
            stead: allGames[gameid].stead
        });
        if (Game.preload) {
            this.preload(gameid);
        } else {
            $('#stead-toolbar-info').html('<b>' + Game.name + '</b>');
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
                $('#stead-toolbar-info').html(i18n.t('preload') + ': ' + percent + '%');
            },
            function preloadSuccess() {
                $('#stead-toolbar-info').html('<b>' + Game.name + '</b>');
            }
        );
    },
    hide: function hide() {
        this.container.hide();
        UI.show();
        $('#stead-toolbar').show();
    }
};

module.exports = Manager;
