var interpreter = require('../../lua/interpreter');
var Game = require('../game');

var sprites = {};
var spriteCounter = 0;
var nextCopy = {
    clear: false,
    x: null,
    y: null,
    width: null,
    height: null
};

function luaToNumber(val) {
    if (val === 'nil') {
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
            height: height
        };
    } else {
        if (nextCopy.clear) {
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
            img.src = Game.path + sprite.name;
        }
    },
    copy: function spriteCopy() {
        var args = Array.prototype.slice.call(arguments);
        args.push('copy');
        return copySprite.apply(this, args);
    },
    compose: function spriteCompose() {
        var args = Array.prototype.slice.call(arguments);
        args.push('compose');
        return copySprite.apply(this, args);
    },
    draw: function spriteDraw() {
        var args = Array.prototype.slice.call(arguments);
        args.push('draw');
        return copySprite.apply(this, args);
    },
    free: function spriteFree(spriteID) {
        if (sprites[spriteID].waitOp) {
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
    }
};

window.Sprite = Sprite;
module.exports = Sprite;
