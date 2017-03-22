var $ = require('jquery');
var Game = require('./game');
var Logger = require('./log');
var vfs = require('./vfs');
var i18n = require('./i18n');

var UTFsymbol = {
    mute: '<div style="position:absolute; color: #CC0000; text-shadow: 0px 0px 2px #000000">&#10006;</div>&#128266;',
    sound: '&#128266;'
};

var Menu = {
    element: {},
    init: function init(ui, steadHandler) {
        this.element = ui;
        var self = this;

        // apply menu translations
        $('#instead--menu-back').text(i18n.t('menu_back'));
        $('#instead--menu-save').text(i18n.t('menu_save'));
        $('#instead--menu-load').text(i18n.t('menu_load'));
        $('#instead--menu-reset').text(i18n.t('menu_reset'));
        $('#instead--menu-export').text(i18n.t('menu_export'));
        $('#instead--menu-export-log').text(i18n.t('menu_export_log'));

        function toggleMute() {
            if (Game.mute) {
                steadHandler.mute(false);
                ui.$menu_mute.text(i18n.t('menu_mute'));
                ui.$toolbar_mute.html(UTFsymbol.sound);
            } else {
                steadHandler.mute(true);
                ui.$menu_mute.text(i18n.t('menu_unmute'));
                ui.$toolbar_mute.html(UTFsymbol.mute);
            }
        }
        Game.mute = !Game.mute; // set correct mute state before switching
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
            case 'export-log':
                self.exportLog();
                break;
            default:
                self.toggleMenu();
            }
        });

        if (Game.log) {
            ui.$toolbar_log.on('click', function toggleLog(e) {
                e.preventDefault();
                Logger.show();
                $('#instead--log').toggle().scrollTop(function sh() { return this.scrollHeight; });
            });
        } else {
            ui.$toolbar_log.hide();
        }
        ui.$toolbar_mute.on('click', function toggleLog(e) {
            e.preventDefault();
            toggleMute();
        });
        ui.$toolbar_menu.on('click', this.toggleMenu.bind(this));

        function importLoad(e) {
            Game.importSave(e.target.result);
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
        ui.$gameDetails.html(
            Game.name + ' - ' + Game.details.version + '<br/>'
            + Game.details.author + '<br/>'
            + '<pre>' + Game.details.info.replace(/\\n/g, '\n') + '</pre>'
            + '<hr>'
        );
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

            Game.allSaves().forEach(function f(item) {
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
                html += '<h3>' + i18n.t('menu_savegame') + '</h3>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    html += '<a href="" data-action="save" data-id="' + i + '" class="slot-selector">';
                    if (slots[i]) {
                        html += i + ' - ' + slots[i];
                    } else {
                        html += i + ' - ' + i18n.t('empty');
                    }
                    html += '</a>';
                }
            } else if (action === 'load') {
                html += '<h3>' + i18n.t('menu_loadgame') + '</h3>';
                html += '<a href="" data-action="load" data-id="' + Game.autosaveID +
                        '" class="slot-selector">0 - ' + i18n.t('menu_autosave') + '</a>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    if (slots[i]) {
                        html += '<a href="" data-action="load" data-id="' + i + '" class="slot-selector">';
                        html += i + ' - ' + slots[i];
                        html += '</a>';
                    } else {
                        html += '<div class="slot-selector">' + i + ' - ' + i18n.t('empty') + '</div>';
                    }
                }
                html += '<h3>' + i18n.t('menu_import') + '</h3>';
                html += '<input type="file" id="load-import" style="font-size: 0.8em"/>';
                html += '<br><br>';
            } else {
                html += '<h3>' + i18n.t('menu_export') + '</h3>';
                html += '<a href="" data-action="export" data-id="' + Game.autosaveID +
                        '" class="slot-selector">0 - ' + i18n.t('menu_autosave') + '</a>';
                for (i = 1; i <= Game.saveSlots; i++) {
                    if (slots[i]) {
                        html += '<a href="" data-action="export" data-id="' + i + '" class="slot-selector">';
                        html += i + ' - ' + slots[i];
                        html += '</a>';
                    } else {
                        html += '<div class="slot-selector">' + i + ' - ' + i18n.t('empty') + '</div>';
                    }
                }
            }

            html += '<a href="" data-action="cancel">' + i18n.t('menu_cancel') + '</a>';
            ui.$menu_saveload.html(html);
            ui.$menu_saveload.show();
        } else {
            ui.$menu_saveload.hide();
            ui.$menu_content.show();
        }
    },
    exportSave: function exportSave(id) {
        var savename = Game.getSaveName(id);
        var content = Game.load(id);
        vfs.exportFile(savename + '.lua', content);
    },
    exportLog: function exportLog() {
        var logContentTxt = Game.id + '\n' + Game.name + '\n\n';
        logContentTxt += Game.gJournal.join('\n');
        vfs.exportFile(Game.id + '-log.txt', logContentTxt);
    }
};

module.exports = Menu;
