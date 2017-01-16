var Game = require('./game');
var themeCSS = require('./ui/theme_css');
var ajaxGetSync = require('../ajax');
var interpreter = require('../lua/interpreter');

var Theme = {
    themeFile: 'theme.ini',
    theme: {},
    themeUrl: {},
    load: function load(elements, themePath) {
        var defaultTheme = null;
        var customTheme = null;
        var includedThemeName = null;
        var includedTheme = null;

        this.elements = elements;
        // reset styles
        themeCSS.resetStyles();

        // load default theme
        defaultTheme = ajaxGetSync(themePath + 'default/' + this.themeFile);
        this.parseTheme(defaultTheme, themePath + 'default/');

        if (Game.ownTheme) {
            // try to load custom theme
            customTheme = ajaxGetSync(Game.path + this.themeFile);
            if (customTheme) {
                interpreter.call('js_instead_theme_name(".")');
                includedThemeName = this.parseTheme(customTheme, Game.path);
            }

            // load included theme
            if (includedThemeName) {
                includedTheme = ajaxGetSync(themePath + includedThemeName + '/' + this.themeFile);
                this.parseTheme(includedTheme, themePath + includedThemeName + '/');
                this.parseTheme(customTheme, Game.path);
            }
        }
        // apply theme
        themeCSS.immediate(false); // disable auto-updating stylesheet while theme rules are generated
        this.apply();
        themeCSS.immediate(true);
        themeCSS.update();

        this.setCursor();
    },
    parseTheme: function parseTheme(data, url) {
        var self = this;
        var pair;
        var name;
        var value;
        var isInclude;
        data.split('\n').forEach(function parse(line) {
            pair = line.split('=');
            if (pair.length === 2) {
                name = pair[0].trim();
                value = (pair[1].split(';'))[0].trim();
                self.theme[name] = value;
                self.themeUrl[name] = url;
                if (name === 'include') {
                    isInclude = value;
                }
            }
        });
        return isInclude;
    },
    apply: function applyTheme() {
        var elements = this.elements;
        var theme = this.theme;
        var themeUrl = this.themeUrl;

        if (theme['scr.gfx.mode'] === 'embedded') {
            // ignore gfx size for embedded
            delete theme['scr.gfx.x'];
            delete theme['scr.gfx.y'];
            delete theme['scr.gfx.w'];
            delete theme['scr.gfx.h'];
            delete theme['win.gfx.x'];
            delete theme['win.gfx.y'];
            delete theme['win.gfx.w'];
            delete theme['win.gfx.h'];
        }
        if (!theme['win.fnt.name']) {
            theme['win.fnt.name'] = 'Tahoma';
        }
        if (!theme['inv.fnt.name']) {
            theme['inv.fnt.name'] = 'Tahoma';
        }
        Object.keys(theme).forEach(function parseParam(key) {
            themeCSS.applyParamStyle(key, elements, theme[key], themeUrl[key]);
        });
        if ('snd.click' in theme && theme['snd.click']) {
            Game.clickSound = themeUrl['snd.click'] + theme['snd.click'];
        }
    },
    setCursor: function setCursor(isAct) {
        var cursor = this.themeUrl['scr.gfx.cursor.normal'] + this.theme['scr.gfx.cursor.normal'];
        if (isAct) {
            cursor = this.themeUrl['scr.gfx.cursor.normal'] + this.theme['scr.gfx.cursor.use'];
        }
        themeCSS.applyParamStyle('CURSOR', this.elements, cursor);
    },
    setStyle: function setStyle(name, value) {
        themeCSS.applyParamStyle(name, this.elements, value, Game.path);
    }
};

// configure global handler for 'theme' module
window.insteadTheme = Theme.setStyle.bind(Theme);

module.exports = Theme;

/*

? scr.gfx.use = путь к картинке-индикатору режима использования (строка)
? scr.gfx.pad = размер отступов к скролл-барам и краям меню (число)
X scr.gfx.icon = пусть к файлу-иконке игры (ОС зависимая опция, может работать некорректно в некоторых случаях)
- scr.gfx.mode = режим расположения (строка fixed, embedded или float). Задает режим изображения.
    embedded - картинка является частью содержимого главного окна,
               параметры scr.gfx.x, scr.gfx.y, scr.gfx.w игнорируются.
    float    - картинка расположена по указанным координатам (scr.gfx.x, scr.gfx.y)
               и масштабируется к размеру scr.gfx.w x scr.gfx.h если превышает его.
    fixed    - картинка является частью сцены как в режиме embedded, но не скроллируется
               вместе с текстом а расположена непосредственно над ним.
    Доступны модификации режима float с модификаторами 'left/right/center/middle/bottom/top',
    указывающими как именно размещать картинку в области scr.gfx. Например: float-top-left;
- win.scroll.mode = [0|1|2|3] режим прокрутки области сцены.
    0 - нет автоматической прокрутки,
    1 - прокрутка на изменение в тексте,
    2 прокрутка на изменение, только если изменение не видно,
    3 - всегда в конец;
- menu.fnt.name = путь к файлу-шрифту меню (строка)
- menu.fnt.size = размер шрифта меню (размер)
- menu.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
*/
