var $ = require('jquery');

var Theme = {
    themeFile: 'theme.ini',
    theme: {},
    load: function load(elements, themePath) {
        var self = this;
        this.elements = elements;
        this.themePath = themePath;
        var url = this.themePath + this.themeFile;
        $.get(url, function onLoad(data) {
            var themeLines = data.split('\n');
            themeLines.forEach(function parse(line) {
                var pair = line.split('=');
                if (pair.length === 2) {
                    self.theme[pair[0].trim()] = pair[1].trim();
                }
            });
            self.apply();
            self.setCursor();
        });
    },
    apply: function applyTheme() {
        var elements = this.elements;
        var theme = this.theme;
        if ('scr.gfx.bg' in theme) {
            elements.$stead.css({
                backgroundImage: 'url("' + this.themePath + theme['scr.gfx.bg'] + '")'
            });
        }
        if ('scr.w' in theme && 'scr.h' in theme) {
            elements.$stead.css({
                width: theme['scr.w'] + 'px',
                height: theme['scr.h'] + 'px'
            });
        }
        if ('win.w' in theme && 'win.h' in theme) {
            elements.$win.css({
                width: theme['win.w'] + 'px',
                height: theme['win.h'] + 'px',
                left: theme['win.x'] + 'px',
                top: theme['win.y'] + 'px'
            });
        }
        if ('inv.w' in theme && 'inv.h' in theme) {
            elements.$inventory.css({
                width: theme['inv.w'] + 'px',
                height: theme['inv.h'] + 'px',
                left: theme['inv.x'] + 'px',
                top: theme['inv.y'] + 'px'
            });
        }

        elements.$menuButton.css({
            left: theme['menu.button.x'] + 'px',
            top: theme['menu.button.y'] + 'px'
        });

        if ('menu.gfx.button' in theme) {
            elements.$menuImage.attr('src', this.themePath + theme['menu.gfx.button']);
        }

        var style = '';

        elements.$win.css('color', theme['win.col.fg']);
        style += '#win a { color: ' + theme['win.col.link'] + '}';
        style += '#win a:hover { color: ' + theme['win.col.alink'] + '}';

        elements.$inventory.css('color', theme['inv.col.fg']);
        style += '#inventory a { color: ' + theme['inv.col.link'] + '}';
        style += '#inventory a:hover { color: ' + theme['inv.col.alink'] + '}';

        $('#theme_css').text(style);
    },
    setCursor: function setCursor(isAct) {
        var cursor = this.themePath + this.theme['scr.gfx.cursor.normal'];
        if (isAct) {
            cursor = this.themePath + this.theme['scr.gfx.cursor.use'];
        }
        this.elements.$stead.css('cursor', 'url(' + cursor + '), auto');
    }
};


module.exports = Theme;

/*

+ scr.w = ширина игрового пространства в пикселях (число)
+ scr.h = высота игрового пространства в пикселях (число)
    scr.col.bg = цвет фона
X scr.gfx.scalable = [0|1|2|4|5|6]
+ scr.gfx.bg = путь к картинке фонового изображения (строка)
    scr.gfx.cursor.x = x координата центра курсора (число)
    scr.gfx.cursor.y = y координата центра курсора (число)
+ scr.gfx.cursor.normal = путь к картинке-курсору (строка)
+ scr.gfx.cursor.use = путь к картинке-курсору режима использования (строка)
    scr.gfx.use = путь к картинке-индикатору режима использования (строка)
    scr.gfx.pad = размер отступов к скролл-барам и краям меню (число)
    scr.gfx.x, scr.gfx.y, scr.gfx.w, scr.gfx.h = координаты, ширина и высота окна изображений. Области в которой располагается картинка сцены. Интерпретация зависит от режима расположения (числа)
    win.gfx.h - синоним scr.gfx.h (для совместимости)
X scr.gfx.icon = пусть к файлу-иконке игры (ОС зависимая опция, может работать некорректно в некоторых случаях)
    scr.gfx.mode = режим расположения (строка fixed, embedded или float). Задает режим изображения. embedded – картинка является частью содержимого главного окна, параметры scr.gfx.x, scr.gfx.y, scr.gfx.w игнорируются. float – картинка расположена по указанным координатам (scr.gfx.x, scr.gfx.y) и масштабируется к размеру scr.gfx.w x scr.gfx.h если превышает его. fixed – картинка является частью сцены как в режиме embedded, но не скроллируется вместе с текстом а расположена непосредственно над ним. Доступны модификации режима float с модификаторами 'left/right/center/middle/bottom/top', указывающими как именно размещать картинку в области scr.gfx. Например: float-top-left;
    win.scroll.mode = [0|1|2|3] режим прокрутки области сцены. 0 - нет автоматической прокрутки, 1 - прокрутка на изменение в тексте, 2 прокрутка на изменение, только если изменение не видно, 3 - всегда в конец;
+ win.x, win.y, win.w, win.h = координаты, ширина и высота главного окна. Области в которой располагается описание сцены (числа)
    win.fnt.name = путь к файлу-шрифту (строка). Здесь и далее, шрифт может содержать описание всех начертаний, например: {sans,sans-b,sans-i,sans-bi}.ttf (заданы начертания для regular, bold, italic и bold-italic). Вы можете опускать какие-то начертания, и движок сам сгенерирует их на основе обычного начертания, например: {sans,,sans-i}.ttf (заданы только regular и italic);
    win.align = center/left/right/justify (выравнивание текста в окне сцены);
    win.fnt.size = размер шрифта главного окна (размер)
    win.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
    win.gfx.up, win.gfx.down = пути к файлам-изображениям скорллеров вверх/вниз для главного окна (строка)
    win.up.x, win.up.y, win.down.x, win.down.y = координаты скроллеров (координата или -1)
+ win.col.fg = цвет текста главного окна (цвет)
+ win.col.link = цвет ссылок главного окна (цвет)
+ win.col.alink = цвет активных ссылок главного окна (цвет)
    win.ways.mode = top/bottom (задать расположение списка переходов, по умолчанию top – сверху сцены)
+ inv.x, inv.y, inv.w, inv.h = координаты, высота и ширина области инвентаря. (числа)
    inv.mode = строка режима инвентаря (horizontal или vertical). В горизонтальном режиме инвентаря в одной строке могут быть несколько предметов. В вертикальном режиме, в каждой строке инвентаря содержится только один предмет. (число) Существует модификации (-left/right/center). Вы можете задать режим disabled если в вашей игре не нужен инвентарь;
+ inv.col.fg = цвет текста инвентаря (цвет)
+ inv.col.link = цвет ссылок инвентаря (цвет)
+ inv.col.alink = цвет активных ссылок инвентаря (цвет)
    inv.fnt.name = путь к файлу-шрифту инвентаря (строка)
    inv.fnt.size = размер шрифта инвентаря (размер)
    inv.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
    inv.gfx.up, inv.gfx.down = пути к файлам-изображениям скорллеров вверх/вниз для инвентаря (строка)
    inv.up.x, inv.up.y, inv.down.x, inv.down.y = координаты скроллеров (координата или -1)
    menu.col.bg = фон меню (цвет)
    menu.col.fg = цвет текста меню (цвет)
    menu.col.link = цвет ссылок меню (цвет)
    menu.col.alink = цвет активных ссылок меню (цвет)
    menu.col.alpha = прозрачность меню 0-255 (число)
    menu.col.border = цвет бордюра меню (цвет)
    menu.bw = толщина бордюра меню (число)
    menu.fnt.name = путь к файлу-шрифту меню (строка)
    menu.fnt.size = размер шрифта меню (размер)
    menu.fnt.height = междустрочный интервал как число с плавающей запятой (1.0 по умолчанию)
+ menu.gfx.button = путь к файлу изображению значка меню (строка)
+ menu.button.x, menu.button.y = координаты кнопки меню (числа)
    snd.click = путь к звуковому файлу щелчка (строка)
    include = имя темы (последний компонент в пути каталога) (строка)
*/
