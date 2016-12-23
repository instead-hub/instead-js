require 'object'
require 'para'
require 'xact'
require 'dash'

--require 'dbg'

game.use = 'Не получается...';
dofile('actions.lua');
dofile('part_1.lua');
dofile('part_2.lua');
dofile('part_3.lua');
dofile('part_4.lua');

game.codepage='UTF-8'
game.dsc = [[Команды:^
    look(или просто ввод), act <на что> (или просто на что), use <что> [на что], go <куда>,^
    back, inv, way, obj, quit, save <fname>, load <fname>. Работает автодополнение по табуляции.^^]];

set_music('music/title1.ogg', 1);

main = room {
    nam = 'ЗЕРКАЛО',
    pic = 'images/title.png',
    obj = { vway('1', txtc('{Перейти в главное меню}'), 'main2'), 
--            vway('3', '^^{chapter 2}', 'part_1_end'),
--            vway('3', '^^{chapter 4}', 'part_3_end'),
    },
};

main2 = room {
    nam = 'ЗЕРКАЛО',
    pic = 'images/title_small.png',
    enter = function (s)
        set_music('music/title2.ogg');
    end,
    dsc = function(s)
        local v = txtc (txtb('«Зеркало»^ v 0.9 beta (23.02.2012)'))..[[^^ Авторы оригинальной игры «ЗЕРКАЛО» для ZX Spectrum — творческая группа Art Work:^Коды и музыка — Пасечник И. А.^Сценарий и графика — Степанов В. Ю.^^Адаптация для INSTEAD — Вадим В. Балашов.^vvb.backup@rambler.ru^^Автор выражает огромную признательность Петру Косых за INSTEAD и неоценимую помощь, оказанную при разработке кода.]];
        return v;
    end,
    obj = { vway('1', '{Об авторах оригинальной игры}^', 'about'),
            vway('2', '{Прочитать правила}^', 'p01'), -- r000
            vway('3', '{Настройка уровня сложности}^', 'settings_01'),
            vway('4', '{НАЧАТЬ ИГРУ}', 'i101') },
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
        local v = 'Здоровье: '..s._health..'%^';
        v = v..'Нагрузка:  '..s._cargo..'%^';
        v = v..'Прогресс:  '..s._progress..'%^';
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
    nam = 'Об авторах',
    pic = 'images/art_work.png',
    enter = function (s)
        set_music('music/instructions.ogg');
    end,
    dsc = [[ Авторы оригинальной игры «ЗЕРКАЛО» для ZX Spectrum — творческая группа Art Work:^^
             Коды и музыка — Пасечник И. А.^
             Сценарий и графика — Степанов В. Ю.]],
    obj = { vway('1', ' {Вернуться в главное меню}', 'main2') },
};


p01 = room {
    nam = 'Инструкция',
    pic = 'images/instructions.png',
    enter = function (s)
        set_music('music/instructions.ogg');
    end,
    dsc = function(s)
        local v = txtc(txtu(txtb('Параметры игрока:')))..txtb('^Здоровье')..[[ — показывает общее физическое состояние героя.]]..txtb('^Нагрузка')..[[ — суммарный вес несомых объектов.]]..txtb('^Прогресс')..[[ — общий прогресс по игре (процент прохождения игры).^^]]..txtc(txtu(txtb('Действия игрока:')))..txtb('^С СОБОЙ')..[[ — позволяет осмотреть несомые предметы.]]..txtb('^ВЗЯТЬ')..[[ — если это возможно, герой возьмёт указанный предмет.]]..txtb('^БРОСИТЬ')..[[ — лишние предметы можно оставить.]]..txtb('^ИСПОЛЬЗОВАТЬ')..[[ — для достижения цели игры герою придётся работать с окружающими его объектами. Для этого Вы должны указать КАКИМ (первый клик) предметом нужно действовать на КАКОЙ (второй клик) предмет. Чтобы использовать объект сам по себе, его нужно выбрать ДВАЖДЫ.]]..txtb('^ГОВОРИТЬ')..[[ — с некоторыми персонажами герой может разговаривать.]]..txtb('^ОТДАТЬ')..[[ — здесь Вы должны выбрать КАКОЙ (первый клик) предмет, из имеющихся у Вас, надо отдать КОМУ (второй клик).]]..txtb('^ОТДЫХАТЬ')..[[ — поможет восстановить утраченную жизненную энергию, но отдыхать нужно осторожно.]]..txtb('^^Примечание^')..[[В меню ИСПОЛЬЗОВАТЬ и ОТДАТЬ курсивом отмечаются те предметы, которые у Вас с собой.]];
        return v;
    end,
    obj = { vway('1', '{Вернуться в главное меню}', 'main2') },
};


settings_01 = room {
    nam = 'Настройки игры',
    pic = 'images/instructions.png',
    enter = function (s)
        me():disable_all();
        set_music('music/instructions.ogg');
    end,
    dsc = function(s)
            return 'ВНИМАНИЕ!^Уровень сложности оригинальной ZX-версии игры очень высок. В частности, в игре постоянно встречаются ситуации, когда неправильный порядок использования предметов приводит к невозможности прохождения последующих уровней игры. При этом не выдаётся никаких предупреждений. Игрок, забывший предмет (или неправильно использовавший его), часто не может догадаться, что этот предмет потребуется не на следующем уровне, а, скажем, через один. При разработке этой версии игры по возможности я пытался обойти эти сложные ситуации, но это оказалось не везде возможно.^Другая сложность связана с постоянно уменьшающимся уровнем здоровья. В оригинальной игре пополнить здоровье можно только в некоторых местах и ограниченное число раз (!!!). В связи с этим, прохождение оригинальной ZX-версии игры больше напоминает шахматы, когда малейшая ошибка приводит к проигрышу всей партии. В этой версии игры я дал возможность игроку пополнять здоровье бесконечное число раз на всех уровнях игры. Но, по многочисленным отзывам, и этого оказалось мало для современных игроков, не привыкших к подобному уровню сложности игр.^Поэтому в текущей версии игры была добавлена возможность упрощения некоторых параметров.^Вы можете отменить автоматическое уменьшение уровня жизни, которое в оригинальной игре происходит после каждой смены локации. Это позволит не обращать внимание на постоянно уменьшающийся уровень здоровья.^Также Вы можете установить режим, когда перед переходом в новую часть игры будет выводиться предупреждение в том случае, если какие-то важные предметы игрок забыл на уровне. Это позволит предупредить игрока о ситуации, когда пройти уровень невозможно из-за того, что необходимый предмет был оставлен на предыдущем уровне.';
    end,
    obj = { vway('1', '{Перейти к настройке параметров}', 'settings_02') },
};


settings_02 = dlg{
    nam = 'Настройки игры',
    pic = 'images/instructions.png',
    forcedsc = true,
    dsc = function (s)
        local ld;
        local eh;
        if status._health_decrease then
            ld = 'ДА';
        else
            ld = 'НЕТ';
        end
        if status._exit_hints then
            le = 'ДА';
        else
            le = 'НЕТ';
        end
        v = (txtu(txtb(txtc('Текущие значения параметров:'))))..('^Уменьшение здоровья: '..ld..'^Сообщение о забытых предметах: '..le..'^^Выберите соответствующий пункт для изменения настройки.');
        return v;
    end,
    obj = {
            [1] = phr('Уменьшение здоровья', nil, [[pon(1); if (status._health_decrease) then status._health_decrease = false; else status._health_decrease = true; end; walk (settings_02);]]),
            [2] = phr('Сообщение о забытых предметах', nil, [[pon(2); if (status._exit_hints) then status._exit_hints = false; else status._exit_hints = true; end; walk (settings_02);]]),
            [3] = phr('Вернуться в главное меню', nil, [[pon(1,2,3); walk (main2);]]),
          },
    exit = function (s, t)
        me():enable_all();
    end,
};
