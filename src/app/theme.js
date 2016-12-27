var $ = require('jquery');
var Game = require('./game');
var ajaxGetSync = require('../ajax');
var interpreter = require('../lua/interpreter');
var HTMLAudio = require('./audio');

var dynamicStyles = {};
var scrollerWidth = 15;

var updateCSS = true;

function setCSS() {
    if (!updateCSS) {
        return;
    }
    var css = '';
    for (var property in dynamicStyles) {
        if (dynamicStyles.hasOwnProperty(property)) {
            css = css + dynamicStyles[property];
        }
    }
    $('#theme_css').text(css);
}

function setFontCSS(selector, fontName, v, p) {
    var fntCSS = '';

    function setFont(name, file, type) {
        var fnt = '';
        switch (type) {
        case 'b':
            fnt = '@font-face{font-family:"' + name + '";src:url("' + file +
                  '") format("truetype");font-weight:bold;}';
            break;
        case 'i':
            fnt = '@font-face{font-family:"' + name + '";src:url("' + file +
                  '") format("truetype");font-style:italic;}';
            break;
        case 'bi':
            fnt = '@font-face{font-family:"' + name + '";src:url("' + file +
                  '") format("truetype");font-weight:bold;font-style:italic;}';
            break;
        default:
            fnt = '@font-face{font-family:"' + name + '";src:url("' + file +
                  '") format("truetype");}';
        }
        return fnt;
    }

    var fonts = v.match(/(.*?){(.*?),(.*?),(.*?),(.*?)}(\.\w+)/);
    if (fonts) {
        if (fonts[2]) {
            fntCSS = fntCSS + setFont(fontName, p + fonts[1] + fonts[2] + fonts[6]);
        }
        if (fonts[3]) {
            fntCSS = fntCSS + setFont(fontName, p + fonts[1] + fonts[3] + fonts[6], 'b');
        }
        if (fonts[4]) {
            fntCSS = fntCSS + setFont(fontName, p + fonts[1] + fonts[4] + fonts[6], 'i');
        }
        if (fonts[5]) {
            fntCSS = fntCSS + setFont(fontName, p + fonts[1] + fonts[5] + fonts[6], 'bi');
        }
    }
    if (fntCSS === '' && v) {
        fntCSS = setFont(fontName, p + v); // one font for all types
    }
    fntCSS = fntCSS + selector + ' * {font-family:' + fontName + ',Arial,Helvetica,sans-serif;}';
    return fntCSS;
}

var applyStyle = {
    'scr.gfx.bg': function s(e, v, p) {
        e.$stead.css('backgroundImage', 'url("' + p + v + '")');
    },
    'scr.col.bg': function s(e, v) {
        e.$stead.css('background-color', v);
    },
    'scr.w': function s(e, v) { e.$stead.css('width', v + 'px'); },
    'scr.h': function s(e, v) { e.$stead.css('height', v + 'px'); },

    'scr.gfx.w': function s(e, v) {
        if (v > 0) {
            dynamicStyles['scr.gfx.w'] = '#picture img {max-width:' + v + 'px}';
            setCSS();
        }
    },
    'scr.gfx.h': function s(e, v) {
        if (v > 0) {
            dynamicStyles['scr.gfx.h'] = '#picture img {max-height:' + v + 'px}';
            setCSS();
        }
    },
    'scr.gfx.x': function s(e, v) { e.$picture.css('left', v + 'px'); },
    'scr.gfx.y': function s(e, v) { e.$picture.css('top', v + 'px'); },
    'scr.gfx.mode': function s(e, v) {
        if (v === 'float') {
            e.$picture.appendTo('#stead').css('position', 'absolute');
        }
    },

    'win.gfx.w': function s() { this['scr.gfx.w'](arguments); },
    'win.gfx.h': function s() { this['scr.gfx.h'](arguments); },
    'win.gfx.x': function s() { this['scr.gfx.x'](arguments); },
    'win.gfx.y': function s() { this['scr.gfx.w'](arguments); },

    'win.w': function s(e, v) {
        e.$win.css('width', v + 'px');
        e.$win.css('padding-right', scrollerWidth + 'px');
    },
    'win.h': function s(e, v) { e.$win.css('height', v + 'px'); },
    'win.x': function s(e, v) { e.$win.css('left', v + 'px'); },
    'win.y': function s(e, v) { e.$win.css('top', v + 'px'); },
    'win.col.fg': function s(e, v) { e.$win.css('color', v); },
    'win.align': function s(e, v) { e.$win.css('text-align', v); },
    'win.scroll.mode': function s(e, v) {
        if (+v === 3) {
            Game.scroll_mode = 'bottom';
        } else if (+v > 0) {
            Game.scroll_mode = 'change';
        }
    },
    'win.ways.mode': function s(e, v) {
        Game.ways_mode = v;
    },
    'win.fnt.name': function s(e, v, p) {
        dynamicStyles['win.fnt.name'] = setFontCSS('#win', 'insteadWin', v, p);
        setCSS();
    },
    'win.fnt.size': function s(e, v) {
        e.$win.css('font-size', v + 'px');
    },
    'win.fnt.height': function s(e, v) {
        e.$win.css('line-height', v);
    },

    'inv.w': function s(e, v) {
        e.$inventory.css('width', v + 'px');
        e.$inventory.css('padding-right', scrollerWidth + 'px');
    },
    'inv.h': function s(e, v) { e.$inventory.css('height', v + 'px'); },
    'inv.x': function s(e, v) { e.$inventory.css('left', v + 'px'); },
    'inv.y': function s(e, v) { e.$inventory.css('top', v + 'px'); },
    'inv.col.fg': function s(e, v) { e.$inventory.css('color', v); },
    'inv.mode': function s(e, v) {
        if (v === 'disabled') {
            e.$inventory.hide();
        } else {
            var p = v.split('-');
            Game.inventory_mode = p[0];
            if (p[1]) {
                e.$inventory.css('text-align', p[1]);
            }
        }
    },
    'inv.fnt.name': function s(e, v, p) {
        dynamicStyles['inv.fnt.name'] = setFontCSS('#inventory', 'insteadInv', v, p);
        setCSS();
    },
    'inv.fnt.size': function s(e, v) {
        e.$inventory.css('font-size', v + 'px');
    },
    'inv.fnt.height': function s(e, v) {
        e.$inventory.css('line-height', v);
    },

    'menu.col.bg': function s(e, v) { e.$menu.css('background-color', v); },
    'menu.col.fg': function s(e, v) { e.$menu.css('color', v); },
    'menu.col.link': function s(e, v) {
        dynamicStyles['menu.col.link'] = '#menu a {color:' + v + '}';
        setCSS();
    },
    'menu.col.alink': function s(e, v) {
        dynamicStyles['menu.col.alink'] = '#menu a:hover {color:' + v + '}';
        setCSS();
    },
    'menu.col.alpha': function s(e, v) { e.$menu.css('opacity', (v / 255)); },
    'menu.col.border': function s(e, v) { e.$menu.css('border', v + 'px'); },
    'menu.bw': function s(e, v) { e.$menu.css('border-width', v + 'px'); },

    'menu.button.x': function s(e, v) { e.$menuButton.css('left', v + 'px'); },
    'menu.button.y': function s(e, v) { e.$menuButton.css('top', v + 'px'); },

    'menu.gfx.button': function s(e, v, p) {
        e.$menuImage.attr('src', p + v);
    },
    'win.col.link': function s(e, v) {
        dynamicStyles['win.col.link'] = '#win a {color:' + v + '}';
        setCSS();
    },
    'win.col.alink': function s(e, v) {
        dynamicStyles['win.col.alink'] = '#win a:hover {color:' + v + '}';
        setCSS();
    },
    'inv.col.link': function s(e, v) {
        dynamicStyles['inv.col.link'] = '#inventory a {color:' + v + '}';
        setCSS();
    },
    'inv.col.alink': function s(e, v) {
        dynamicStyles['inv.col.alink'] = '#inventory a:hover {color:' + v + '}';
        setCSS();
    }
};


var Theme = {
    themeFile: 'theme.ini',
    theme: {},
    themeUrl: {},
    load: function load(elements, themePath) {
        this.elements = elements;
        // reset styles
        dynamicStyles = {};
        setCSS();

        // load default theme
        var defaultTheme = ajaxGetSync(themePath + 'default/' + this.themeFile);
        this.parseTheme(defaultTheme, themePath + 'default/');

        // try to load custom theme
        var customTheme = ajaxGetSync(Game.path + this.themeFile);
        if (customTheme) {
            interpreter.call('js_instead_theme_name(".")');
            var include = this.parseTheme(customTheme, Game.path);
        }

        // load included theme
        if (include) {
            var includedTheme = ajaxGetSync(themePath + include + '/' + this.themeFile);
            this.parseTheme(includedTheme, themePath + include + '/');
            this.parseTheme(customTheme, Game.path);
        }
        // apply theme
        updateCSS = false; // disable auto-updating stylesheet while theme rules are generated
        this.apply();
        updateCSS = true;
        setCSS();

        this.setCursor();
        this.click(true); // preload click sound
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
            theme['win.fnt.name'] = '#win * {font-family:Tahoma,Arial,Helvetica,sans-serif;}';
        }
        if (!theme['inv.fnt.name']) {
            theme['inv.fnt.name'] = '#inventory * {font-family:Tahoma,Arial,Helvetica,sans-serif;}';
        }
        Object.keys(theme).forEach(function parseParam(key) {
            if (key in applyStyle) {
                applyStyle[key](elements, theme[key], themeUrl[key]);
            }
        });
    },
    setCursor: function setCursor(isAct) {
        var cursor = this.themeUrl['scr.gfx.cursor.normal'] + this.theme['scr.gfx.cursor.normal'];
        if (isAct) {
            cursor = this.themeUrl['scr.gfx.cursor.normal'] + this.theme['scr.gfx.cursor.use'];
        }
        this.elements.$stead.css('cursor', 'url(' + cursor + '), auto');
    },
    setStyle: function setStyle(name, value) {
        if (name in applyStyle && value !== 'nil') {
            applyStyle[name](this.elements, value, Game.path);
        }
    },
    click: function click(isCache) {
        if ('snd.click' in this.theme && this.theme['snd.click']) {
            HTMLAudio.playSound(this.themeUrl['snd.click'] + this.theme['snd.click'], null, isCache);
        }
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
