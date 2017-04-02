var $ = require('jquery');

var appHTML = require('./app.html');

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
    var delim = '#';
    if (Game.stead !== 2) {
        delim = '';
    }
    output = output.replace(
        /<x:([^>]+)>([^<$]+)/g,
        function parseTxttab(fullString, param, text) {
            var s = param.split(',');
            var margin = s[0] + 'px';
            if (margin.search('%') !== -1) {
                margin = s[0];
            }
            var align = s[1] || 'left';
            return '<div style="padding-left:' + margin + '; text-align: ' + align + '">' + text + '</div>';
        }
    ).replace(
        /<a:#>/g,
        '<a name="instead--scroll-anchor"> </a>'
    ).replace(
        /<a(:)([^>]+)>(<i>|)((&#160;)+)/g,
        '$4<a href="" data-ref="' + delim + '$2" data-type="' + field + '">$3'
    ).replace(
        /<a(:)([^>]+)/g,
        '<a href="" data-ref="' + delim + '$2", data-type="' + field + '"'
    ).replace(
        /<w:([^>]+)>/g,
        '<span class="nowrap">$1</span>'
    ).replace(
        /<y:([^>]+)>/g,
        function parseTxty(fullString, tab) {
            var margin = tab + 'px';
            if (tab.search('%') !== -1) {
                margin = tab;
            }
            return '<div style="margin-top: ' + margin + '" />';
        }
    ).replace(
        /<g:([^>]+)>/g,
        parseImg
    );

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
    winContent: null,
    updatedTextContent: true
};

function isUnchangedUI(type, content) {
    if (type === 'text') {
        if (content.indexOf(currentUI[type]) !== -1) {
            currentUI.updatedTextContent = true;
        } else {
            currentUI.updatedTextContent = false;
        }
    }
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
    init: function init(rootElement, steadHandler) {
        var self = this;
        $(rootElement).html(appHTML);
        // initialize JQuery selectors
        this.element = {
            $container: $('#stead-container'),
            $title: $('#title'),
            $ways: $('#ways-top'),
            $text: $('#instead--text'),
            $picture: $('#picture'),
            $win: $('#win'),
            $stead: $('#stead'),
            $inventory: $('#inventory'),
            $menuButton: $('#menu_button'),
            $menuImage: $('#menu_image'),
            $menu: $('#instead--menu'),
            $menu_saveload: $('#instead--menu-saveload'),
            $menu_content: $('#instead--menu-content'),
            $toolbar_mute: $('#toolbar-mute'),
            $toolbar_log: $('#toolbar-log'),
            $toolbar_menu: $('#toolbar-menu'),
            $menu_mute: $('#instead--menu-mute'),
            $gameDetails: $('#instead--game-details')
        };

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
        Game.isAct = act;
        Game.actObj = obj;
        Theme.setCursor(Game.isAct);
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
        var scrollTarget = 0;
        if (Game.scroll_mode === 'bottom' ||
           (Game.scroll_mode === 'change' && currentUI.updatedTextContent)
           ) {
            scrollTarget = function h() { return this.scrollHeight; };
        }

        this.element.$win.scrollTop(scrollTarget);
        this.element.$win.perfectScrollbar('update');
    },

    fadeOut: function fadeOut(callback) {
        this.element.$stead.fadeOut('fast', callback);
    },

    fadeIn: function fadeIn() {
        this.element.$stead.fadeIn('fast');
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
        if (Game.isAct) {
            Logger.log('[click] reset onAct');
            clickCallback(null, null, true);
        }
        if (obj) {
            clickCallback({x: e.offsetX, y: e.offsetY}); // clicked on picture
        }
    }
};

module.exports = UI;
