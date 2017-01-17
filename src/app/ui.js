var $ = require('jquery');

var Game = require('./game');
var Theme = require('./theme');
var Logger = require('./log');

var parseImg = require('./ui/parse_image');
var Sprite = require('./ui/sprite');

function normalizeContent(input, field) {
    var output = input;
    if (!output) {
        // do not process empty outputs
        return '';
    }
    output = output.replace(
        /<a(:)([^>]+)>(<i>|)((&#160;)+)/g,
        '$4<a href="" data-ref="#$2" data-type="' + field + '">$3'
    ).replace(
        /<a(:)([^>]+)/g,
        '<a href="" data-ref="#$2", data-type="' + field + '"'
    ).replace(
        /<w:([^>]+)>/g,
        '<span class="nowrap">$1</span>'
    ).replace(
        /<g:([^>]+)>/g,
        parseImg
    );
    /* TODO: txttab support
    r = /<x:([^>,]+),?([^>]+)?>/g;
    output = output.replace(r, '[x : $1 : $2]');
    */
    return output;
}

function setContent(element, content, field) {
    element.html('<pre>' + normalizeContent(content, field) + '</pre>');
}

var currentUI = {
    title: null,
    ways: null,
    text: null,
    inventory: null,
    picture: null,
    winContent: null
};

function isUnchangedUI(type, content) {
    if (currentUI[type] === content) {
        return true;
    }
    currentUI[type] = content;
    return false;
}

function isUnchangedWin() {
    var winContent = currentUI.title + currentUI.ways + currentUI.text + currentUI.picture;
    if (currentUI.winContent === winContent) {
        return true;
    }
    currentUI.winContent = winContent;
    return false;
}

var UI = {
    element: {
        $title: $('#title'),
        $ways: $('#ways-top'),
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
            self.clickHandlerLink(steadHandler.click, e, obj);
        });
        this.element.$picture.on('click', function handler(e) {
            var obj = $(this);
            self.clickHandler(steadHandler.click, e, obj);
        });
        this.element.$stead.on('click', function handler(e) {
            self.clickHandler(steadHandler.click, e);
        });

        this.element.$win.perfectScrollbar({wheelSpeed: 1});
        this.element.$inventory.perfectScrollbar({wheelSpeed: 1});
    },

    show: function show() {
        this.element.$stead.show();
    },

    hide: function hide() {
        this.element.$stead.hide();
    },

    loadTheme: function loadTheme() {
        Theme.load(this.element, Game.themePath);
        if (Game.ways_mode === 'bottom') {
            this.element.$ways = $('#ways-bottom');
        }
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
        if (isUnchangedUI('title', content)) {
            return;
        }
        Logger.log(':title: ' + content);
        var title = (!content || content === true) ? '' : content;
        setContent(
            this.element.$title,
            '<a href="" data-ref="#look" data-type="Title">' + title + '</a>',
            'Title'
        );
    },

    setWays: function setWays(content) {
        if (isUnchangedUI('ways', content)) {
            return;
        }
        Logger.log(':ways: ' + content);
        setContent(this.element.$ways, content, 'Ways');
    },

    setText: function setText(content) {
        if (isUnchangedUI('text', content)) {
            return;
        }
        Logger.log(':text: ' + content);
        setContent(this.element.$text, content, 'Text');
    },

    setInventory: function setInventory(content) {
        if (isUnchangedUI('inventory', content)) {
            return;
        }
        Logger.log(':inv: ' + content);
        setContent(this.element.$inventory, content, 'Inv');
        this.element.$inventory.perfectScrollbar('update');
    },

    setPicture: function setPicture(content) {
        if (isUnchangedUI('picture', content)) {
            return;
        }
        Logger.log(':picture: ' + content);
        if (content === null) {
            this.element.$picture.html('');
        } else if (Sprite.is(content)) {
            this.element.$picture.html('');
            Sprite.initCanvas(this.element.$picture, content);
        } else {
            this.element.$picture.html(parseImg(null, content));
        }
    },

    refresh: function refresh() {
        if (isUnchangedWin()) {
            return;
        }
        if (Game.scroll_mode === 'bottom') {
            this.element.$win.scrollTop(function h() { return this.scrollHeight; });
        } else {
            this.element.$win.scrollTop(0);
        }
        this.element.$win.perfectScrollbar('update');
    },

    clickHandlerLink: function clickHandlerLink(clickCallback, e, obj) {
        e.preventDefault();
        e.stopPropagation();
        var ref = obj.attr('data-ref');
        var type = obj.attr('data-type');
        Logger.log('[click] ' + obj.attr('data-ref') + ':' + obj.attr('data-type') + ' "' + obj.text() + '"');
        clickCallback(ref, type);
    },

    clickHandler: function clickHandler(clickCallback, e, obj) {
        e.preventDefault();
        if (this.isAct) {
            Logger.log('[click] reset onAct');
            clickCallback('', 0, true);
        }
        if (obj) {
            clickCallback({x: e.offsetX, y: e.offsetY}); // clicked on picture
        }
    }
};

module.exports = UI;
