var Game = require('../game');
var Sprite = require('./sprite');

function parseCompositeImage(image) {
    var parsedImg = image.split(';');
    var images = '<img src="' + Game.path + parsedImg[0] + '">';
    for (var i = 1; i < parsedImg.length; i++) {
        images += parseCompositePart(parsedImg[i]);
    }
    return '<div class="compositeImage">' + images + '</div>';
}

function parseCompositePart(image) {
    if (!image) {
        return '';
    }
    var pImg = image;
    var imageParts = [];
    var pStyle = '';
    var pMargins;
    if (image.indexOf('@') !== -1 ) {
        imageParts = image.split('@');
        pImg = imageParts[0];
        pMargins = imageParts[1].match(/(\d+),(\d+)/);
        pStyle = 'left:' + pMargins[1] + 'px;top:' + pMargins[2] + 'px;';
    }
    return '<img style="position:absolute;' + pStyle + '" src="' + Game.path + pImg + '"/>';
}


function parseImg(fullString, img) {
    var image = img;
    var style = 'max-width: 100%;';
    var parsedImg = '';

    function parseEmptyImage(fullReplaceString, box, params) {
        var d = params.split(',');
        var imgSize = d[0].match(/(\d+)x(\d+)/);
        var eStyle = style + 'width:' + imgSize[1] + 'px;' +
                'height:' + imgSize[2] + 'px;';
        if (d[1]) {
            eStyle += 'background-color:' + d[1] + ';';
        }
        if (d[2]) {
            eStyle += 'opacity:' + (d[2] / 256) + ';';
        }
        eStyle += 'display:inline-block;';
        return '<div style="' + eStyle + '"></div>';
    }

    if (Sprite.is(img)) {
        return Sprite.asImage(img);
    }
    // Parse pseudo-images (box, blank)
    if (img.indexOf('box') === 0 || img.indexOf('blank') === 0) {
        return img.replace(/(box|blank):(.+)/, parseEmptyImage);
    }
    // parse padded images
    if (image.indexOf('pad') === 0) {
        parsedImg = image.match(/pad:(.+?),(.+)/);
        style += 'margin:' + parsedImg[1].replace(/(\d+)/g, '$1px') + ';';
        image = parsedImg[2];
        if (image.indexOf('box') === 0 || image.indexOf('blank') === 0) {
            return image.replace(/(box|blank):(.+)/, parseEmptyImage);
        }
    }
    // parse aligned images
    if (image.indexOf('\|') !== -1) {
        parsedImg = image.match(/(.+)\\\|(.+)/);
        image = parsedImg[1];
        style += 'float:' + parsedImg[2] + ';';
    }
    // composite image
    if (image.indexOf(';') !== -1) {
        return parseCompositeImage(image);
    }
    return '<img ' + (style ? 'style="' + style + '" ' : '') + 'src="' + Game.path + image + '">';
}

module.exports = parseImg;
