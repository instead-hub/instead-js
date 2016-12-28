var $ = require('jquery');

var Logger = {
    log: function showLog() {
        var message = Array.prototype.join.call(arguments, ', ');
        var style = '';
        if (message.indexOf('>') === 0) {
            style = 'style="color: #333399"';
        }
        message = message.replace(/</g, '&lt;');
        message = message.replace(/>/g, '&gt;');
        var el = $('#log');
        el.append('<span ' + style + '>' + message + '<br/></span>');
        el.scrollTop(function h() { return this.scrollHeight; });
    }
};

module.exports = Logger;
