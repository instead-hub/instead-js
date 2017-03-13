var $ = require('jquery');
var interpreter = require('../../lua/interpreter');
var Game = require('../game');
var Theme = require('./theme_css');

var sprites = {};
var spriteCounter = 0;
var spriteUniqueID = 0;
var fonts = {};
var fontNames = {};
var fontCounter = 0;
var nextCopy = {
    clear: false,
    x: null,
    y: null,
    width: null,
    height: null
};

function getFontSize(font, text) {
    var o = $('<div>' + text + '</div>')
            .css({
                position: 'absolute', float: 'left', 'white-space': 'nowrap',
                visibility: 'hidden', font: font
            })
            .appendTo($('body'));
    var w = o.width();
    var h = o.height();
    o.remove();
    return {width: w, height: h};
}


function luaToNumber(val) {
    if (typeof val === 'undefined' || val === 'nil') {
        return 0;
    }
    return +val;
}

function makeBlankCanvas(sprite) {
    var parsed = sprite.name.match(/(box|blank):(.+)/);
    sprite.replaceCopy = true;
    var d = parsed[2].split(',');
    var imgSize = d[0].match(/(\d+)x(\d+)/);

    var ctx = sprite.ctx;
    sprite.canvas.width = imgSize[1];
    sprite.canvas.height = imgSize[2];
    if (d[2]) {
        ctx.globalAlpha = d[2];
    }
    if (d[1]) {
        ctx.fillStyle = d[1];
        ctx.fillRect(0, 0, imgSize[1], imgSize[2]);
    }
    if (d[2]) {
        ctx.globalAlpha = 1;
    }
}

function copySprite(srcID, fx, fy, fw, fh, dstID, x, y, alpha, mode) {
    var srcSprite = sprites[srcID];
    var dstSprite = sprites[dstID];
    srcSprite.waitOp = true;
    dstSprite.waitOp = true;
    if (srcSprite.unavailable || dstSprite.unavailable) {
        setTimeout(function deferredCopy() {
            copySprite(srcID, fx, fy, fw, fh, dstID, x, y, alpha, mode);
        }, 100);
        return;
    }
    var width = luaToNumber(fw);
    var height = luaToNumber(fh);
    var srcX = luaToNumber(fx);
    var srcY = luaToNumber(fy);
    var trgX = luaToNumber(x);
    var trgY = luaToNumber(y);

    if (width < 0) {
        width = srcSprite.canvas.width;
    }
    if (height < 0) {
        height = srcSprite.canvas.height;
    }
    var ctx = dstSprite.ctx;
    if (mode === 'copy' && srcSprite.replaceCopy) {
        // cut out target canvas area on next copy operation
        nextCopy = {
            clear: true,
            x: trgX,
            y: trgY,
            width: width,
            height: height,
            dstID: dstID
        };
    } else {
        if (nextCopy.clear && nextCopy.dstID === dstID) {
            nextCopy.clear = false;
            ctx.clearRect(nextCopy.x, nextCopy.y, nextCopy.width, nextCopy.height);
        }
        if (alpha && alpha !== 'nil') {
            ctx.globalAlpha = +alpha;
        }
        ctx.drawImage(srcSprite.canvas, srcX, srcY, width, height,
                      trgX, trgY, width, height);
        if (alpha && alpha !== 'nil') {
            ctx.globalAlpha = 1;
        }
    }
    srcSprite.waitOp = false;
    dstSprite.waitOp = false;
}


var Sprite = {
    id: function id(n) {
        return '_INSTEAD_sprite' + n;
    },
    is: function is(name) {
        return name.indexOf('_INSTEAD_sprite') === 0;
    },
    initCanvas: function initCanvas(parentElement, spriteID) {
        parentElement.append(sprites[spriteID].canvas);
    },
    asImage: function spriteAsImage(spriteID) {
        spriteUniqueID++;
        var sprite = spriteID + '__' + spriteUniqueID;
        setTimeout(function populateSprite() {
            var sp = sprites[spriteID].canvas;
            var sc = document.getElementById(sprite);
            sc.width = sp.width;
            sc.height = sp.height;
            var ctx = sc.getContext('2d');
            ctx.drawImage(sp, 0, 0, sp.width, sp.height, 0, 0, sp.width, sp.height);
        }, 50);
        return '<canvas id="' + sprite + '"></canvas>';
    },
    load: function spriteLoad(fileName) {
        spriteCounter++;
        var spriteID = this.id(spriteCounter);
        var sprite = {
            id: spriteID,
            name: fileName,
            canvas: document.createElement('canvas'),
            unavailable: true,
            waitOp: true
        };
        sprite.ctx = sprite.canvas.getContext('2d');

        sprites[spriteID] = sprite;
        interpreter.call('js_instead_sprite_load("' + fileName + '", "' + spriteID + '")');

        if (sprite.name.indexOf('box') === 0 || sprite.name.indexOf('blank') === 0) {
            makeBlankCanvas(sprite);
            sprite.unavailable = false;
        } else {
            var img = new Image();
            img.addEventListener('load', function loadImage() {
                sprite.canvas.width = img.width;
                sprite.canvas.height = img.height;
                sprite.canvas.getContext('2d').drawImage(img, 0, 0);
                sprite.unavailable = false;
            }, false);
            img.src = Game.fileURL(sprite.name);
        }
    },
    copy: function spriteCopy() {
        var args = Array.prototype.slice.call(arguments);
        args[9] = 'copy';
        return copySprite.apply(this, args);
    },
    compose: function spriteCompose() {
        var args = Array.prototype.slice.call(arguments);
        args[9] = 'compose';
        return copySprite.apply(this, args);
    },
    draw: function spriteDraw() {
        var args = Array.prototype.slice.call(arguments);
        args[9] = 'draw';
        return copySprite.apply(this, args);
    },
    free: function spriteFree(spriteID) {
        if (typeof sprites[spriteID] === 'object' && sprites[spriteID].waitOp) {
            setTimeout(function deferredFree() {
                Sprite.free(spriteID);
            }, 511);
            return;
        }
        setTimeout(function delayedFree() {
            delete sprites[spriteID];
        }, 300);
    },
    pixel: function spritePixel(spriteID, x, y, color, alpha) {
        sprites[spriteID].waitOp = true;
        var ctx = sprites[spriteID].ctx;
        if (alpha && alpha !== 'nil') {
            ctx.globalAlpha = alpha;
        }
        ctx.fillStyle = color;
        ctx.fillRect(x, y, 1, 1);
        if (alpha && alpha !== 'nil') {
            ctx.globalAlpha = 1;
        }
        sprites[spriteID].waitOp = false;
    },
    fill: function spriteFill(spriteID, x, y, width, height, color) {
        var sprite = sprites[spriteID];
        sprite.waitOp = true;
        var w = width;
        var h = height;
        if (width < 0) {
            w = sprite.canvas.width;
        }
        if (height < 0) {
            h = sprite.canvas.height;
        }
        sprite.ctx.fillStyle = color;
        sprite.ctx.fillRect(x, y, w, h);
        sprite.waitOp = false;
    },
    font: function spriteFont(fileName, size) {
        fontCounter++;
        var fontID = 'sprite_font_' + fontCounter;
        var font = {
            id: fontID,
            name: fileName,
            size: +size
        };

        fonts[fontID] = font;
        if (!fontNames.hasOwnProperty(fileName)) {
            Theme.applyParamStyle('SPRITE.FNT', fontID, fileName, Game.fileURL);
        }
        fontNames[fileName] = true;
        interpreter.call('js_instead_font_load("' + fileName + size + '", "' + fontID + '")');
    },
    text: function spriteText(fontID, text, color) {
        spriteCounter++;
        var spriteID = this.id(spriteCounter);
        interpreter.call('js_instead_sprite_text("' + fontID + '", "' + spriteID + '")');

        var sprite = {
            id: spriteID,
            canvas: document.createElement('canvas'),
            unavailable: true,
            waitOp: true
        };
        sprite.ctx = sprite.canvas.getContext('2d');
        sprites[spriteID] = sprite;

        var fontName = fonts[fontID].size + 'px ' + fontID;
        var fontSize = getFontSize(fontName, text);
        sprite.canvas.width = fontSize.width;
        sprite.canvas.height = fontSize.height;
        sprite.ctx.font = fontName;
        sprite.ctx.textBaseline = 'top';
        if (color && color !== 'nil') {
            sprite.ctx.fillStyle = color;
        } else {
            sprite.ctx.fillStyle = '#FFFFFF'; // white font by default
        }
        sprite.ctx.fillText(text, 0, 0);
        sprite.unavailable = false;
    }
};

window.Sprite = Sprite;
module.exports = Sprite;
