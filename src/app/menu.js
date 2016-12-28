var $ = require('jquery');
var Game = require('./game');
var Storage = require('./storage');

var UTFsymbol = {
    mute: '<div style="position:absolute; color: #CC0000; text-shadow: 0px 0px 2px #000000">&#10006;</div>&#128266;',
    sound: '&#128266;'
};

var Menu = {
    element: {},
    init: function init(elements, steadHandler) {
        this.element = elements;
        var self = this;

        function toggleMute() {
            if (Game.mute) {
                steadHandler.mute(false);
                $('#menu-mute').text('Mute');
                $('#toolbar-mute').html(UTFsymbol.sound);
            } else {
                steadHandler.mute(true);
                $('#menu-mute').text('Unmute');
                $('#toolbar-mute').html(UTFsymbol.mute);
            }
        }
        toggleMute();

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
                toggleMute();
                break;
            default:
                self.toggleMenu();
            }
        });

        $('#toolbar-log').on('click', function toggleLog(e) {
            e.preventDefault();
            $('#log').toggle().scrollTop(function sh() { return this.scrollHeight; });
        });
        $('#toolbar-mute').on('click', function toggleLog(e) {
            e.preventDefault();
            toggleMute();
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
