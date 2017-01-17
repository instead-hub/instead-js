var $ = require('jquery');
require('perfect-scrollbar/jquery')($);

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

        var self = this;
        this.el.on('click', 'a', function selectGame(e) {
            e.preventDefault();
            var gameid = $(this).attr('data-ref');
            Game.path = gamepath + gameid + '/';
            Game.id = gameid;
            Game.name = allGames[gameid].name;
            Game.ownTheme = allGames[gameid].theme;
            if (Game.preload) {
                self.preload(gameid);
            }
            self.hide();
            Instead.startGame(Game.autosaveID);
        });

        $.get(gameList, function listGames(data) {
            allGames = data;
            Object.keys(data).forEach(function listGame(id) {
                self.el.append('<a href="" data-ref="' + id + '">' + data[id].name + '</a>');
            });
        });
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
