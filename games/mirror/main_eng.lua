require 'object'
require 'para'
require 'xact'
require 'dash'

--require 'dbg'

game.use = 'I can’t do this...';
dofile('actions_eng.lua');
dofile('part_1_eng.lua');
dofile('part_2_eng.lua');
dofile('part_3_eng.lua');
dofile('part_4.lua');

game.codepage='UTF-8'
game.dsc = [[Команды:^
    look(или просто ввод), act <на что> (или просто на что), use <что> [на что], go <куда>,^
    back, inv, way, obj, quit, save <fname>, load <fname>. Работает автодополнение по табуляции.^^]];

set_music('music/title1.ogg', 1);

main = room {
    nam = 'MIRROR',
    pic = 'images/title.png',
    obj = { vway('1', txtc('{To the Main Menu}'), 'main2'), 
--            vway('3', '^^{chapter 2}', 'part_1_end'),
--            vway('3', '^^{chapter 3}', 'part_2_end'),
    },
};

main2 = room {
    nam = 'MIRROR',
    pic = 'images/title_small.png',
    enter = function (s)
        set_music('music/title2.ogg');
    end,
    dsc = function(s)
        local v = txtc (txtb('«Mirror»^v 0.9 beta (23.02.2012)'))..[[^^The authors of the original ZX Spectrum game «Зеркало» («Mirror») — Art Work creative group:^Programming and music — Пасечник И. А. (Pasechnik I. A.)^Script and graphics — Степанов В. Ю. (Stepanov V. U.)^^Remake for INSTEAD — Вадим В. Балашов (Vadim V. Balashoff).^vvb.backup@rambler.ru^^I’d like to thank Peter Kosyh (an author of INSTEAD) for invaluable help.^^ATTENTION! The current translation is very lame. Please contact to me if you could improve it! And in fourth part there are some rhymes need to be translated to complete the english version of the game.]];
        return v;
    end,
    obj = { vway('1', '{About the authors of the original game}^', 'about'), -- i001
            vway('2', '{Read game rules}^', 'p01'), -- r000
            vway('3', '{Game settings}^', 'settings_01'),
            vway('4', '{Start game}', 'i101') }, -- i01
};


status = stat {
    _where = 'Cell',
    _health = 26,
    _cargo = 0,
    _progress = 0,
    _fatigue_death_string = '',
    _drink_water_on_this_level = false;
    _health_decrease = true;
    _exit_hints = false;
    nam = function(s)
        local v = 'Health: '..s._health..'%^';
        v = v..'Cargo:  '..s._cargo..'%^';
        v = v..'Progress:  '..s._progress..'%^';
        return v..'^';
    end,
    life = function(s)
        if here()._add_progress ~= nil then
            status._progress = status._progress + here()._add_progress;
            here()._add_progress = 0;
        end
        if s._where ~= me().where then
           s._where = me().where;
           if here()._del_health then
               if status._health_decrease then 
                   status._health = status._health - here()._del_health;
               end
           end
           here()._rested = nil;
        end
        if s._health <= 0 then
           ACTION_TEXT = nil;
           p (s._fatigue_death_string);
           walk (The_End);
           return;
        end
        if status._health > 100 then
            status._health = 100; -- high limit
        end
    end
};


about = room {
    nam = 'About authors of the original ZX Spectrum game',
    pic = 'images/art_work.png',
    enter = function (s)
        set_music('music/instructions.ogg');
    end,
    dsc = [[The authors of the original ZX Spectrum game «Зеркало» («Mirror») — Art Work creative group:^^
            Programming and music — Пасечник И. А. (Pasechnik I. A.)^
            Script and graphics — Степанов В. Ю. (Stepanov V. U.)]],
    obj = { vway('1', '{Return to main menu}', 'main2') },
};


p01 = room {
    nam = 'Instructions',
    pic = 'images/instructions.png',
    enter = function (s)
        set_music('music/instructions.ogg');
    end,
    dsc = function(s)
        local v = txtc(txtu(txtb('Player parameters:')))..txtb('^Health')..[[ — displays general physical condition of the hero]]..txtb('^Cargo')..[[ — total load of carried objects]]..txtb('^Progress')..[[ — indication of progress through the game (percentage)^^]]..txtc(txtu(txtb('Player actions:')))..txtb('^INVENTORY')..[[ — examine carried objects]]..txtb('^TAKE')..[[ — take an object, when possible]]..txtb('^DROP')..[[ — drop unwanted objects]]..txtb('^USE')..[[ — interact with an object: you choose WHAT object (first click) to use on WHICH object (second click). If you want to use an object by itself, just click on it TWICE.]]..txtb('^TALK')..[[ — talk with another character]]..txtb('^GIVE')..[[ — choose WHICH object (first click) from your inventory you will give to WHOM (second click)]]..txtb('^REST')..[[ — you can restore lost life energy by resting, but you should be careful which place to choose...]]..txtb('^^Note^')..[[In the menu, USE and GIVE will display object which you carrying in italic font.]];
        return v;
    end,
    obj = { vway('1', '{Return to main menu}', 'main2') },
};


settings_01 = room {
    nam = 'Game settings',
    pic = 'images/instructions.png',
    enter = function (s)
        me():disable_all();
        set_music('music/instructions.ogg');
    end,
    dsc = function(s)
            return 'ATTENTION!^Original ZX Spectrum game is VERY hard. In particular, throughout the game there are a lots of situations, when if you use objects in incorrect order, you’ll cannot finish next levels of the game. More than this. Original ZX Spectrum game is not warning you about this. Player who forgot an object (or just incorrect used him), in many cases have no idea that this item is needed on next level (or on a over). Creating this version of game, I’d try to avoid this cases, where it is possible. But I was unable to avoid them all.^Another complication is that your life level is decreasing constantly. In original game you can replenish you life level only in several places and only a few times (!!!). In this case, playing original ZX Spectrum game is similar to playing chess, where small mistake is leading to defeat entire game. In this version of game I’ve give a player possibility to reinforce a life level infinitely on every level of a game. However, in many opinions, the game still remain too hard for modern players. They just don’t get used to such hard games nowdays.^Therefore, in this version of game was added a possibility to simplify some parameters.^Now you can cancel automatical life level decrease, which in original ZX Spectrum game had take place after every changing locations. This allows player to not a pay attention to constantly decreasing life level.^Aslo you can set a following option. In case when you leaving current level and you did not possess all needed objects, the game will warn you about that. This allow you to avoid a situation, when you will be unable to finish some level because you forgot some objects on previous one.';
    end,
    obj = { vway('1', '{To the game settings}', 'settings_02') },
};


settings_02 = dlg{
    nam = 'Game settings',
    pic = 'images/instructions.png',
    forcedsc = true,
    dsc = function (s)
        local ld;
        local eh;
        if status._health_decrease then
            ld = 'YES';
        else
            ld = 'NO';
        end
        if status._exit_hints then
            le = 'YES';
        else
            le = 'NO';
        end
        v = (txtu(txtb(txtc('Current values:'))))..('^Life level decrease: '..ld..'^Warning about forgotten objects: '..le..'^^Choose a corresponding line to change value.');
        return v;
    end,
    obj = {
            [1] = phr('Life level decrease', nil, [[pon(1); if (status._health_decrease) then status._health_decrease = false; else status._health_decrease = true; end; walk (settings_02);]]),
            [2] = phr('Warning about forgotten objects', nil, [[pon(2); if (status._exit_hints) then status._exit_hints = false; else status._exit_hints = true; end; walk (settings_02);]]),
            [3] = phr('Back to main menu', nil, [[pon(1,2,3); walk (main2);]]),
          },
    exit = function (s, t)
        me():enable_all();
    end,
};
