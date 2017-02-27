var $ = require('jquery');
var Game = require('./game');

var Logger = {
    log: function showLog() {
        if (!Game.log) {
            return; // if log is disabled
        }
        var message = Array.prototype.join.call(arguments, ', ');
        var style = '';
        if (message.indexOf('>') === 0) {
            style = 'class="command"';
        }
        if (message.indexOf('[') === 0) {
            style = 'class="event"';
        }
        message = message.replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/:(title|ways|text|inv|picture):/g, '<span class="block">$1</span>');
        var el = $('#instead--log');
        el.append('<span ' + style + '>' + message + '<br/></span>');
        el.scrollTop(function h() { return this.scrollHeight; });
        return;
    }
};

module.exports = Logger;
