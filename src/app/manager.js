var $ = require('jquery');
require('perfect-scrollbar/jquery')($);

var Game = require('./game');
var Instead = require('./instead');
var UI = require('./ui');

var gamepath = './games/';

var Manager = {
    init: function init() {
        this.el = $('#manager');
        this.el.perfectScrollbar({wheelSpeed: 1});

        var self = this;
        this.el.on('click', 'a', function selectGame(e) {
            e.preventDefault();
            var gameid = $(this).attr('data-ref');
            Game.path = gamepath + gameid + '/';
            self.hide();
            Instead.startGame();
        });

        $('#show-log').on('click', function toggleLog() {
            if ($('#log').is(':visible')) {
                $('#log').hide();
                $(this).html('Game log &#9658;');
            } else {
                $('#log').show();
                $(this).html('Game log &#9660;');
            }
        });

        $.get(gamepath + 'games_list.json', function gameList(data) {
            Object.keys(data).forEach(function listGame(id) {
                self.el.append('<a href="" data-ref="' + id + '">' + data[id] + '</a>');
            });
        });
    },
    /* TODO: return to game selection menu
    show: function show() {
        this.el.show();
        UI.hide();
    },
    */
    hide: function hide() {
        this.el.hide();
        UI.show();
        $('#log-window').show();
    }
};

module.exports = Manager;
