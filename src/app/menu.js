var $ = require('jquery');
var Game = require('./game');
var Storage = require('./storage');

var UTFsymbol = {
    mute: '<div style="position:absolute; color: #CC0000; text-shadow: 0px 0px 2px #000000">&#10006;</div>&#128266;',
    sound: '&#128266;'
};

var Menu = {
    element: {},
    init: function init(ui, steadHandler) {
        this.element = ui;
        var self = this;

        function toggleMute() {
            if (Game.mute) {
                steadHandler.mute(false);
                ui.$menu_mute.text('Mute');
                ui.$toolbar_mute.html(UTFsymbol.sound);
            } else {
                steadHandler.mute(true);
                ui.$menu_mute.text('Unmute');
                ui.$toolbar_mute.html(UTFsymbol.mute);
            }
        }
        toggleMute();

        ui.$menuButton.on('click', this.toggleMenu.bind(this));
        ui.$menu.on('click', 'a', function handler(e) {
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
            case 'menu-export':
                self.toggleSaveload('export');
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
            case 'export':
                self.exportSave(id);
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

        ui.$toolbar_log.on('click', function toggleLog(e) {
            e.preventDefault();
            $('#log').toggle().scrollTop(function sh() { return this.scrollHeight; });
        });
        ui.$toolbar_mute.on('click', function toggleLog(e) {
            e.preventDefault();
            toggleMute();
        });

        function importLoad(e) {
            var gameId = Game.getSaveName(Game.importID);
            Storage.save(gameId, e.target.result);
            self.toggleSaveload();
            self.toggleMenu();
            steadHandler.load(Game.importID);
        }

        ui.$menu.on('change', '#load-import',  function fileCtrl() {
            var reader = new FileReader();
            reader.onload = importLoad;
            reader.readAsText(this.files[0]);
        });
    },
    toggleMenu: function toggleMenu() {
        var ui = this.element;
        ui.$menu_saveload.hide();
        ui.$menu_content.show();
        ui.$menu.toggle();
        if (ui.$menu.is(':visible')) {
            ui.$stead.css('opacity', 0.5);
        } else {
            ui.$stead.css('opacity', 1);
        }
    },
    toggleSaveload: function toggleSaveload(action) {
        var ui = this.element;
        var html = '';
        var slots = [];
        if (action) {
            ui.$menu_content.hide();

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
                html += '<h3>Save game</h3>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    html += '<a href="" data-action="save" data-id="' + i + '" class="slot-selector">';
                    if (slots[i]) {
                        html += i + ' - ' + slots[i];
                    } else {
                        html += i + ' - empty';
                    }
                    html += '</a>';
                }
            } else if (action === 'load') {
                html += '<h3>Load game</h3>';
                html += '<a href="" data-action="load" data-id="' + Game.autosaveID +
                        '" class="slot-selector">0 - Autosave</a>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    if (slots[i]) {
                        html += '<a href="" data-action="load" data-id="' + i + '" class="slot-selector">';
                        html += i + ' - ' + slots[i];
                        html += '</a>';
                    } else {
                        html += '<div class="slot-selector">' + i + ' - empty</div>';
                    }
                }
                html += '<h3>Import</h3>';
                html += '<input type="file" id="load-import" style="font-size: 0.8em"/>';
                html += '<br><br>';
            } else {
                html += '<h3>Export saved game</h3>';
                html += '<a href="" data-action="export" data-id="' + Game.autosaveID +
                        '" class="slot-selector">0 - Autosave</a>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    if (slots[i]) {
                        html += '<a href="" data-action="export" data-id="' + i + '" class="slot-selector">';
                        html += i + ' - ' + slots[i];
                        html += '</a>';
                    } else {
                        html += '<div class="slot-selector">' + i + ' - empty</div>';
                    }
                }
            }

            html += '<a href="" data-action="cancel">Cancel</a>';
            ui.$menu_saveload.html(html);
            ui.$menu_saveload.show();
        } else {
            ui.$menu_saveload.hide();
            ui.$menu_content.show();
        }
    },
    exportSave: function exportSave(id) {
        var savename = Game.getSaveName(id);
        var content = Storage.load(savename);
        var data = new Blob([content], {type: 'octet/stream'});
        var dataUrl = window.URL.createObjectURL(data);
        var ref = document.createElement('a');
        document.body.appendChild(ref);
        ref.style = 'display: none';
        ref.href = dataUrl;
        ref.download = savename + '.lua';
        ref.click();
        window.URL.revokeObjectURL(dataUrl);
        ref.remove();
    }
};

module.exports = Menu;
