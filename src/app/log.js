var $ = require('jquery');

var Logger = {
    log: function showLog() {
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
        var el = $('#log');
        el.append('<span ' + style + '>' + message + '<br/></span>');
        el.scrollTop(function h() { return this.scrollHeight; });
    }
};

module.exports = Logger;
