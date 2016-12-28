-- $Name:Звёздное Наследие [без музыки]$
-- $Version:0.5$
instead_version '1.7.0'
require 'object'
require 'para'
require 'xact'
require 'dash'
require 'hideinv'
require 'proxymenu'
--require 'dbg'

game.use = 'Не получается...';
--dofile ('actions.lua');
dofile('menu_actions.lua');
dofile ('compass.lua');
dofile ('about.lua');
dofile ('part_0.lua');
dofile ('part_1.lua');
dofile ('part_2.lua');
dofile ('part_3.lua');
dofile ('part_4.lua');
dofile ('part_5.lua');
dofile ('bar.lua');

game.codepage="UTF-8"
game.dsc = [[Команды:^
    look(или просто ввод), act <на что> (или просто на что), use <что> [на что], go <куда>,^
    back, inv, way, obj, quit, save <fname>, load <fname>. Работает автодополнение по табуляции.^^]];

set_music ('music/01_intro.ogg');

main = room
{
--    nam = 'Звёздное Наследие',
    nam = '',
    pic = 'images/title.png',
--    dsc = function (s)
--       return 'Звёздное Наследие. Часть 1. «Чёрная кобра»';
--    end,
    obj = { vway('1', '{Далее}', 'main_2'), },
};


main_2 = room
{
    nam = '«Звёздное Наследие»',
--    pic = 'images/title.png',
    dsc = function (s)
        local v = txtc (txtb('Часть 1. «Чёрная кобра»^v 0.5 beta (24.07.2012)'))..[[^^Авторы оригинальной игры «Звёздное Наследие» для ZX Spectrum — творческая группа STEP, 1995 год.^^Адаптация для INSTEAD — Вадим В. Балашов.^   vvb.backup@rambler.ru^^]];
        return v;
    end,
    obj =
    {
        vway('1', '{Об авторах}^', 'about'),
--            vway('2', '{Музыка}^^', 'amusic'),
        vway('3', '{Вступительная новелла}^', 'p01'),
        vway('4', '{НАЧАТЬ ИГРУ}', 'i101')
    },
};



MORNING = 1;
DAY = 2;
EVENING = 3;
NIGHT = 4;


status = stat
{
    _where = 'r_111',
    _way = 'N',
    _dead = false,
    _health = 0,
    _strength = 0,
    _endurance = 0,
    _experience = 0,
    _level = 0,
    _MAX_H = 24,
    _MAX_S = 24,
    _MAX_E = 24,
    _clock = DAY,
    _biomask = false,
    nam = function (s)
--        local v =    'З: '..s._health..'^';
--              v = v..'С: '..s._strength..'^';
--              v = v..'В: '..s._endurance..'^';
--              v = v..'О: '..s._experience..'^';
--              v = v..'У: '..s._level..'^^';
        local v =    'З: '..bar(s._health)..'^';
              v = v..'С: '..bar(s._strength)..'^';
              v = v..'В: '..bar(s._endurance)..'^';
--              v = v..'О: '..bar(s._experience)..'^';
--              v = v..'У: '..bar(s._level)..'^';
        if s._clock == MORNING then
            v = v..'Время:  УТРО';
        end
        if s._clock == DAY then
            v = v..'Время:  ДЕНЬ';
        end
        if s._clock == EVENING then
            v = v..'Время: ВЕЧЕР';
        end
        if s._clock == NIGHT then
            v = v..'Время:  НОЧЬ';
        end
--        v = v..'Время:  '..s._clock..'^';
--        if s._biomask then
--            v = v..imgl('images/icon_artang_small.png');
--        else
--            v = v..imgl('images/icon_man_small.png');
--        end
--        if s._biomask then
--            v = v..img 'images/icon_artang_small.png\\|left';
--        else
--            v = v..img 'images/icon_man_small.png\\|left';
--        end
--        return v..'^';
        return v;
    end,
--    life = function (s)
--        if s._where ~= me().where then
--           s._where = me().where;
--           if here().Del_Life then
--               status._health = status._health - here().Del_Life;
--           end
--        end
--    end
};



function clock_next ()
    status._clock = status._clock + 1;
    if status._clock > 4 then
        status._clock = 1;
    end
end


function status_change (h, s, e, x, l)
    if (status._health == 2) and (h == -2) then
        status._health = 1;
    else
        status._health = status._health + h;
    end
    if status._health < 0 then
        status._health = 0;
    end
    if status._health > status._MAX_H then
        status._health = status._MAX_H;
    end

    status._strength = status._strength + s;
    if status._strength < 0 then
        status._strength = 0;
    end
    if status._strength > status._MAX_S then
        status._strength = status._MAX_S;
    end

    status._endurance = status._endurance + e;
    if status._endurance < 0 then
        status._endurance = 0;
    end
    if status._endurance > status._MAX_E then
        status._endurance = status._MAX_E;
    end

    status._experience = status._experience + x;
--    if status._experience > MAX_X then
--        status._experience = MAX_X;
--    end

    status._level = status._level + l;
--    if status._level > MAX_L then
--        status._level = MAX_L;
--    end

--    local r = check_health ();
--    if r then return r;
--    end
end


function check_health ()
    if status._health <=0 then
        status._dead = true;
        walk (health_finish);
        return;
    end
end


health_finish = room
{
    nam = function (s)
        if s._from == nil then
           return 'the_end';
        end
        return call(ref(s._from),'nam');
    end,
    hideinv = true,
    pic = function (s)
        return call(ref(s._from),'pic');
    end,
    entered = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[С каждым часом я чувствовал себя всё хуже. Давали знать о себе старые
        раны. Моё сознание помутилось...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};
