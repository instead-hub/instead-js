var $ = require('jquery');
var Game = require('../game');

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

function setFontCSS(selector, fontName, v, getURL) {
    var fntCSS = '';

    function setFont(name, file, type) {
        var fnt = '@font-face{font-family:"' + name + '";src:url("' + file + '") format("truetype");';
        switch (type) {
        case 'b':
            fnt += 'font-weight:bold;';
            break;
        case 'i':
            fnt += 'font-style:italic;';
            break;
        case 'bi':
            fnt += 'font-weight:bold;font-style:italic;';
            break;
        default:
            // unknown style/weight, do nothing
        }
        fnt += '}';
        return fnt;
    }

    var fonts = v.match(/(.*?){(.*?)(?:,(.*?)(?:,(.*?)(?:,(.*?))?)?)?}(\.\w+)/);
    if (fonts) {
        if (fonts[2]) {
            fntCSS += setFont(fontName, getURL(fonts[1] + fonts[2] + fonts[6]));
        }
        if (fonts[3]) {
            fntCSS += setFont(fontName, getURL(fonts[1] + fonts[3] + fonts[6]), 'b');
        }
        if (fonts[4]) {
            fntCSS += setFont(fontName, getURL(fonts[1] + fonts[4] + fonts[6]), 'i');
        }
        if (fonts[5]) {
            fntCSS += setFont(fontName, getURL(fonts[1] + fonts[5] + fonts[6]), 'bi');
        }
    }
    fonts = v.match(/(.*?){([\d\w]+)}(\.\w+)/);
    if (fntCSS === '' && fonts && fonts[2]) {
        fntCSS += setFont(fontName, getURL(fonts[1] + fonts[2] + fonts[3]));
    }
    if (fntCSS === '' && v) {
        fntCSS += setFont(fontName, getURL(v)); // one font for all types
    }
    if (selector) {
        fntCSS += selector + ' * {font-family:' + fontName + ',Arial,Helvetica,sans-serif;}';
    }
    return fntCSS;
}

var applyStyle = {
    'scr.gfx.bg': function s(e, v, getURL) {
        e.$stead.css('backgroundImage', 'url("' + getURL(v) + '")');
    },
    'scr.col.bg': function s(e, v) {
        e.$stead.css('background-color', v);
    },
    'scr.w': function s(e, v) {
        e.$stead.css('width', v + 'px');
        e.$container.css('width', v + 'px'); // change width of the INSTEAD container with toolbar
    },
    'scr.h': function s(e, v) { e.$stead.css('height', v + 'px'); },

    'scr.gfx.w': function s(e, v) {
        if (v > 0) {
            dynamicStyles['scr.gfx.w'] = '#picture img {max-width:' + v + 'px}\n#picture {width:' + v + 'px}';
            setCSS();
        }
    },
    'scr.gfx.h': function s(e, v) {
        if (v > 0) {
            dynamicStyles['scr.gfx.h'] = '#picture img {max-height:' + v + 'px}\n#picture {height:' + v + 'px}';
            setCSS();
        }
    },
    'scr.gfx.x': function s(e, v) { e.$picture.css('left', v + 'px'); },
    'scr.gfx.y': function s(e, v) { e.$picture.css('top', v + 'px'); },
    'scr.gfx.mode': function s(e, v) {
        if (v.search('float') !== -1) {
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
        } else {
            Game.scroll_mode = 'top';
        }
    },
    'win.ways.mode': function s(e, v) {
        Game.ways_mode = v;
    },
    'win.fnt.name': function s(e, v, getURL) {
        dynamicStyles['win.fnt.name'] = setFontCSS('#win', 'insteadWin', v, getURL);
        setCSS();
    },
    'win.fnt.size': function s(e, v) {
        e.$win.css('font-size', v + 'px');
    },
    'win.fnt.height': function s(e, v) {
        // default line height for browsers: 1.2
        e.$win.css('line-height', +v * 1.2);
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
            if (p[0] === 'horizontal') {
                // default text align for 'horizontal' mode
                e.$inventory.css('text-align', 'center');
            }
            if (p[1]) {
                e.$inventory.css('text-align', p[1]);
            }
        }
    },
    'inv.fnt.name': function s(e, v, getURL) {
        dynamicStyles['inv.fnt.name'] = setFontCSS('#inventory', 'insteadInv', v, getURL);
        setCSS();
    },
    'inv.fnt.size': function s(e, v) {
        e.$inventory.css('font-size', v + 'px');
    },
    'inv.fnt.height': function s(e, v) {
        // default line height for browsers: 1.2
        e.$inventory.css('line-height', +v * 1.2);
    },

    'menu.col.bg': function s(e, v) { e.$menu.css('background-color', v); },
    'menu.col.fg': function s(e, v) { e.$menu.css('color', v); },
    'menu.col.link': function s(e, v) {
        dynamicStyles['menu.col.link'] = '#instead--menu a {color:' + v + '}';
        setCSS();
    },
    'menu.col.alink': function s(e, v) {
        dynamicStyles['menu.col.alink'] = '#instead--menu a:hover {color:' + v + '}';
        setCSS();
    },
    'menu.col.alpha': function s(e, v) { e.$menu.css('opacity', (v / 255)); },
    'menu.col.border': function s(e, v) { e.$menu.css('border', v + 'px'); },
    'menu.bw': function s(e, v) { e.$menu.css('border-width', v + 'px'); },

    'menu.button.x': function s(e, v) { e.$menuButton.css('left', v + 'px'); },
    'menu.button.y': function s(e, v) { e.$menuButton.css('top', v + 'px'); },

    'menu.gfx.button': function s(e, v, getURL) {
        e.$menuImage.attr('src', getURL(v));
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
    },

    'SPRITE.FNT': function s(fontID, v, getURL) {
        dynamicStyles[fontID] = setFontCSS(null, fontID, v, getURL);
        setCSS();
    },

    'CURSOR': function s(e, v, getURL) {
        e.$stead.css('cursor', 'url(' + getURL(v) + '), auto');
    }
};

var controller = {
    resetStyles: function resetStyles() {
        dynamicStyles = {};
        this.update();
    },
    update: function update() {
        setCSS();
    },
    immediate: function immediate(v) {
        updateCSS = v;
    },
    applyParamStyle: function applyParamStyle(key, elements, value, urlGetter) {
        if (key in applyStyle && value !== 'nil') {
            applyStyle[key](elements, value, urlGetter);
        }
    }
};

module.exports = controller;
