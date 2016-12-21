var $ = require('jquery');
require('perfect-scrollbar/jquery')($);

var Game = require('./game');
var Theme = require('./theme');
var Logger = require('./log');

var parseImg = require('./ui/parse_image');

function normalizeContent(input, field) {
    var output = input;
    if (!output) {
        // do not process empty outputs
        return '';
    }
    var r = /<a(:)([^>]+)>(<i>|)((&#160;)+)/g;
    output = output.replace(r, '$4<a href="" data-ref="#$2" data-type="' + field + '">$3');
    r = /<a(:)([^>]+)/g;
    output = output.replace(r, '<a href="" data-ref="#$2", data-type="' + field + '"');
    r = /<w:([^>]+)>/g;
    output = output.replace(r, '<span class="nowrap">$1</span>');
    r = /<g:([^>]+)>/g;
    output = output.replace(r, parseImg);
    /* TODO: txttab support
    r = /<x:([^>,]+),?([^>]+)?>/g;
    output = output.replace(r, '[x : $1 : $2]');
    */
    return output;
}

function setContent(element, content, field) {
    element.html('<pre>' + normalizeContent(content, field) + '</pre>');
}

var UI = {
    element: {
        $title: $('#title'),
        $ways: $('#ways'),
        $text: $('#text'),
        $picture: $('#picture'),
        $canvas: $('#canvas'),
        $win: $('#win'),
        $stead: $('#stead'),
        $inventory: $('#inventory'),
        $use: $('#cog'),
        $menuButton: $('#menu_button'),
        $menuImage: $('#menu_image'),
        $menu: $('#menu')
    },
    isAct: false,
    actObj: null,

    init: function init(steadHandler) {
        var self = this;

        this.element.$stead.on('click', 'a', function handler(e) {
            var obj = $(this);
            Theme.click(); // play click sound, if defined
            self.clickHandlerLink(steadHandler.click, e, obj);
        });
        this.element.$stead.on('click', function handler(e) {
            var obj = $(this);
            self.clickHandler(steadHandler.click, e, obj);
        });

        Theme.load(this.element, Game.themePath);
        this.element.$win.perfectScrollbar({wheelSpeed: 1});
        this.element.$inventory.perfectScrollbar({wheelSpeed: 1});
    },

    setAct: function setAct(act, obj) {
        this.isAct = act;
        this.actObj = obj;
        this.updateUse();
    },
    updateUse: function updateUse() {
        Theme.setCursor(this.isAct);
    },
    setTitle: function setTitle(content) {
        Logger.log('TITLE: ' + content);
        setContent(
            this.element.$title,
            '<a href="" data-ref="#look" data-type="Title">' + content + '</a>',
            'Title'
        );
    },
    setWays: function setWays(content) {
        Logger.log('WAYS: ' + content);
        setContent(this.element.$ways, content, 'Ways');
    },
    setText: function setText(content) {
        setContent(this.element.$text, content, 'Text');
    },
    setInventory: function setInventory(content) {
        Logger.log('INV: ' + content);
        setContent(this.element.$inventory, content, 'Inv');
    },
    setPicture: function setPicture(content) {
        Logger.log('PICTURE: ' + content);
        if (content) {
            this.element.$picture.html(parseImg(null, content));
        } else {
            this.element.$picture.html('');
        }
    },
    refresh: function refresh() {
        this.element.$win.css('scrollTop', 0);
        this.element.$win.perfectScrollbar('update');
        this.element.$inventory.perfectScrollbar('update');
    },

    clickHandlerLink: function clickHandlerLink(clickCallback, e, obj) {
        e.preventDefault();
        e.stopPropagation();
        var ref = obj.attr('data-ref');
        var type = obj.attr('data-type');
        Logger.log('CLICK ' + obj.attr('data-ref') + ':' + obj.attr('data-type') + '> "' + obj.text() + '"');
        clickCallback(ref, type);
    },

    clickHandler: function clickHandler(clickCallback, e) {
        e.preventDefault();
        if (this.isAct) {
            Logger.log('CLICK - reset onAct');
            clickCallback('', 0, true);
        }
    }
};

module.exports = UI;
