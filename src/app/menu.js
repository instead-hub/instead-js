var $ = require('jquery');
var Game = require('./game');
var Storage = require('./storage');

var Menu = {
    element: {},
    init: function init(elements, steadHandler) {
        this.element = elements;
        var self = this;
        this.element.$menuButton.on('click', this.toggleMenu.bind(this));
        this.element.$menu.on('click', 'a', function handler(e) {
            e.preventDefault();
            var action = $(this).attr('data-action');
            var id = $(this).attr('data-id');
            switch (action) {
            case 'reset':
                self.toggleMenu();
                steadHandler.reset();
                break;
            case 'menu-save':
                self.toggleSaveload('save');
                break;
            case 'menu-load':
                self.toggleSaveload('load');
                break;
            case 'save':
                self.toggleSaveload();
                self.toggleMenu();
                steadHandler.save(id);
                break;
            case 'load':
                self.toggleSaveload();
                self.toggleMenu();
                steadHandler.load(id);
                break;
            case 'cancel':
                self.toggleSaveload();
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
        $('#menu-saveload').hide();
        $('#menu-content').show();
        this.element.$menu.toggle();
        if (this.element.$menu.is(':visible')) {
            this.element.$stead.css('opacity', 0.5);
        } else {
            this.element.$stead.css('opacity', 1);
        }
    },
    toggleSaveload: function toggleSaveload(action) {
        var html = '';
        var slots = [];
        if (action) {
            $('#menu-content').hide();

            Storage.get(Game.id).forEach(function f(item) {
                var saveId = item.id.match(/save-(\d+)/);
                var timestamp = new Date(item.timestamp);
                slots[saveId[1]] = timestamp.toLocaleString('en-US', {
                    weekday: 'short',
                    year: 'numeric',
                    month: 'numeric',
                    day: 'numeric',
                    hour: 'numeric',
                    minute: 'numeric',
                    hour12: false
                });
            });
            var i;
            if (action === 'save') {
                html = html + '<h3>Save game</h3>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    html = html + '<a href="" data-action="save" data-id="' + i + '" class="slot-selector">';
                    if (slots[i]) {
                        html = html + i + ' - ' + slots[i];
                    } else {
                        html = html + i + ' - empty';
                    }
                    html = html + '</a>';
                }
            } else {
                html = html + '<h3>Load game</h3>';
                html = html + '<a href="" data-action="load" data-id="' + Game.autosaveID +
                              '" class="slot-selector">0 - Autosave</a>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    if (slots[i]) {
                        html = html + '<a href="" data-action="load" data-id="' + i + '" class="slot-selector">';
                        html = html + i + ' - ' + slots[i];
                        html = html + '</a>';
                    } else {
                        html = html + '<div class="slot-selector">' + i + ' - empty</div>';
                    }
                }
            }

            html = html + '<a href="" data-action="cancel">Cancel</a>';
            $('#menu-saveload').html(html);
            $('#menu-saveload').show();
        } else {
            $('#menu-saveload').hide();
            $('#menu-content').show();
        }
    }
};

module.exports = Menu;
