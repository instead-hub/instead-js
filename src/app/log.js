var $ = require('jquery');
var Game = require('./game');

var Logger = {
    log: function saveLog() {
        var message = Array.prototype.join.call(arguments, ', ');
        Game.journal(message);
    },
    show: function showLog() {
        var logContent = '';
        Game.gJournal.forEach(function handleMsg(item) {
            var message = item;
            var style = '';
            if (message.indexOf('>') === 0) {
                style = 'class="command"';
            }
            if (message.indexOf('[') === 0) {
                style = 'class="event"';
            }
            if (message.indexOf('{') === 0) {
                style = 'class="error"';
            }
            message = message.replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/:(title|ways|text|inv|picture):/g, '<span class="block">$1</span>');
            logContent += '<span ' + style + '>' + message + '<br/></span>';
        });
        var el = $('#instead--log');
        el.html(logContent);
        el.scrollTop(function h() { return this.scrollHeight; });
        return;
    }
};

module.exports = Logger;
