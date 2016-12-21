var $ = require('jquery');

var Menu = {
    element: {},
    init: function init(elements, steadHandler) {
        this.element = elements;
        var self = this;
        this.element.$menuButton.on('click', this.toggleMenu.bind(this));
        this.element.$menu.on('click', 'a', function handler(e) {
            e.preventDefault();
            var action = $(this).attr('data-action');
            switch (action) {
            case 'reset':
                self.toggleMenu();
                steadHandler.reset();
                break;
            case 'save':
                self.toggleMenu();
                steadHandler.save();
                break;
            case 'load':
                self.toggleMenu();
                steadHandler.load();
                break;
            case 'mute':
                if ($(this).text() === 'Mute') {
                    steadHandler.mute(true);
                    $(this).text('Unmute');
                } else {
                    steadHandler.mute(false);
                    $(this).text('Mute');
                }
                break;
            default:
                self.toggleMenu();
            }
        });
    },
    toggleMenu: function toggleMenu() {
        this.element.$menu.toggle();
        if (this.element.$menu.is(':visible')) {
            this.element.$stead.css('opacity', 0.5);
        } else {
            this.element.$stead.css('opacity', 1);
        }
    }
};

module.exports = Menu;
