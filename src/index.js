// load styles
require('perfect-scrollbar/dist/css/perfect-scrollbar.css');
require('./style.css');

var Manager = require('./app/manager');

var Instead = require('./app/instead');
var UI = require('./app/ui');
var Menu = require('./app/menu');

document.addEventListener(
    'DOMContentLoaded',
    function onLoad() {
        Manager.init();
        // initialization of INSTEAD components
        Instead.init();
        Menu.init(UI.element, Instead.handlers);
        UI.init(Instead.handlers);
    }
);
