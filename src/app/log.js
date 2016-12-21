var $ = require('jquery');

var Logger = {
    log: function showLog() {
        var message = Array.prototype.join.call(arguments, ', ');
        message = message.replace(/</g, '&lt;');
        message = message.replace(/>/g, '&gt;');
        $('#log').append('<span>' + message + '<br/></span>');
    }
};

module.exports = Logger;
