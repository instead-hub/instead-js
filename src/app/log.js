var $ = require('jquery');

var Logger = {
    log: function showLog() {
        var message = Array.prototype.join.call(arguments, ', ');
        $('#log').append('<span>' + message + '\n</span>');
    }
};

module.exports = Logger;
