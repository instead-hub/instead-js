var INSTEAD = require('./app/instead');

document.addEventListener(
    'DOMContentLoaded',
    function onLoad() {
        INSTEAD.init();
        INSTEAD.startGame();
    }
);
