var $ = require('jquery');
var Game = require('./game');
var ajaxGetSync = require('../ajax');

var dynamicStyles = {};

function setCSS() {
    $('#theme_css').text(Object.values(dynamicStyles).join(''));
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

    'scr.gfx.w': function s(e, v) { if (v > 0) { e.$picture.css('width', v + 'px'); }},
    'scr.gfx.h': function s(e, v) { if (v > 0) { e.$picture.css('height', v + 'px'); }},
    'scr.gfx.x': function s(e, v) { e.$picture.css('left', v + 'px'); },
    'scr.gfx.y': function s(e, v) { e.$picture.css('top', v + 'px'); },
    'scr.gfx.mode': function s(e, v) {
        if (v === 'float') {
            e.$picture.appendTo('#stead').css('position', 'absolute');
        }
    },

    'win.gfx.w': function s(e, v) { if (v > 0) { e.$picture.css('width', v + 'px'); }},
    'win.gfx.h': function s(e, v) { if (v > 0) { e.$picture.css('height', v + 'px'); }},
    'win.gfx.x': function s(e, v) { e.$picture.css('left', v + 'px'); },
    'win.gfx.y': function s(e, v) { e.$picture.css('top', v + 'px'); },

    'win.w': function s(e, v) { e.$win.css('width', v + 'px'); },
    'win.h': function s(e, v) { e.$win.css('height', v + 'px'); },
    'win.x': function s(e, v) { e.$win.css('left', v + 'px'); },
    'win.y': function s(e, v) { e.$win.css('top', v + 'px'); },
    'win.col.fg': function s(e, v) { e.$win.css('color', v); },
    'win.align': function s(e, v) { e.$win.css('text-align', v); },

    'inv.w': function s(e, v) { e.$inventory.css('width', v + 'px'); },
    'inv.h': function s(e, v) { e.$inventory.css('height', v + 'px'); },
    'inv.x': function s(e, v) { e.$inventory.css('left', v + 'px'); },
    'inv.y': function s(e, v) { e.$inventory.css('top', v + 'px'); },
    'inv.col.fg': function s(e, v) { e.$inventory.css('color', v); },

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
        dynamicStyles = {};

        // load default theme
        var defaultTheme = ajaxGetSync(themePath + 'default/' + this.themeFile);
        this.parseTheme(defaultTheme, themePath + 'default/');

        // try to load custom theme
        var customTheme = ajaxGetSync(Game.path + this.themeFile);
        if (customTheme) {
            var include = this.parseTheme(customTheme, Game.path);
        }

        // load included theme
        if (include) {
            var includedTheme = ajaxGetSync(themePath + include + '/' + this.themeFile);
            this.parseTheme(includedTheme, themePath + include + '/');
            this.parseTheme(customTheme, Game.path);
        }

        // apply theme
        this.apply();
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
    }
};

// configure global handler for 'theme' module
window.insteadTheme = Theme.setStyle.bind(Theme);

module.exports = Theme;

/*

? scr.gfx.use = путь к картинке-индикатору режима использования (строка)
? scr.gfx.pad = размер отступов к скролл-барам и краям меню (число)
X scr.gfx.icon = пусть к файлу-иконке игры (ОС зависимая опция, может работать некорректно в некоторых случаях)
- scr.gfx.mode = режим расположения (строка fixed, embedded или float). Задает режим изображения. embedded – картинка является частью содержимого главного окна, параметры scr.gfx.x, scr.gfx.y, scr.gfx.w игнорируются. float – картинка расположена по указанным координатам (scr.gfx.x, scr.gfx.y) и масштабируется к размеру scr.gfx.w x scr.gfx.h если превышает его. fixed – картинка является частью сцены как в режиме embedded, но не скроллируется вместе с текстом а расположена непосредственно над ним. Доступны модификации режима float с модификаторами 'left/right/center/middle/bottom/top', указывающими как именно размещать картинку в области scr.gfx. Например: float-top-left;
- win.scroll.mode = [0|1|2|3] режим прокрутки области сцены. 0 - нет автоматической прокрутки, 1 - прокрутка на изменение в тексте, 2 прокрутка на изменение, только если изменение не видно, 3 - всегда в конец;
- win.fnt.name = путь к файлу-шрифту (строка). Здесь и далее, шрифт может содержать описание всех начертаний, например: {sans,sans-b,sans-i,sans-bi}.ttf (заданы начертания для regular, bold, italic и bold-italic). Вы можете опускать какие-то начертания, и движок сам сгенерирует их на основе обычного начертания, например: {sans,,sans-i}.ttf (заданы только regular и italic);
- win.fnt.size = размер шрифта главного окна (размер)
- win.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
- win.ways.mode = top/bottom (задать расположение списка переходов, по умолчанию top – сверху сцены)
- inv.mode = строка режима инвентаря (horizontal или vertical). В горизонтальном режиме инвентаря в одной строке могут быть несколько предметов. В вертикальном режиме, в каждой строке инвентаря содержится только один предмет. (число) Существует модификации (-left/right/center). Вы можете задать режим disabled если в вашей игре не нужен инвентарь;
- inv.fnt.name = путь к файлу-шрифту инвентаря (строка)
- inv.fnt.size = размер шрифта инвентаря (размер)
- inv.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
- menu.fnt.name = путь к файлу-шрифту меню (строка)
- menu.fnt.size = размер шрифта меню (размер)
- menu.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
- snd.click = путь к звуковому файлу щелчка (строка)
- include = имя темы (последний компонент в пути каталога) (строка)
*/
