i201 = room {
    nam = 'В это время в Трёхглавом Замке...',
    pic = 'images/movie_2.gif',
    enter = function(s)
        set_music('music/part_2.ogg');
    end,
    way = { vroom ('Назад', 'part_1_end'), vroom ('Далее', 'River_Bank') },
    exit = function (s, to)
        if to == River_Bank then
--            status._health = 100;
            me().obj:add(status);
            actions_init();
            lifeon(status);
            inv():add(flint);
            flint:enable();
--
            me():enable_all();
            status._drink_water_on_this_level = false;
            status._fatigue_death_string = '...с каждым шагом моё самочувствие ухудшалось. Внезапно острая боль пронзила всё моё тело, ноги отказывались идти; я упал на землю...';
        end
    end,
};

-- ----------------------------------------------------------------------


river = iobj {
    nam = 'река',
    dsc = function(s)
        return 'Рядом протекает быстрая {река}.';
    end,
    exam = 'Кристально чистая холодная вода.',
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                if jug._dirty then
                    jug._dirty = false;
                    return 'С трудом мне удалось очистить кувшин от покрывающей его грязи.';
                end
                if ((not jug._dirty) and (not jug._filled)) then
                    Drop (jug);
                    jug._filled = true;
                    jug._weight = 40;
                    if (status._cargo + 40 <= 100) then
                        Take (jug);
                    end
                    return 'Я наполнил кувшин прозрачной речной водой.';
                end
            end
        end
    end,
};



River_Bank = room {
    nam = 'Берег реки',
    _add_health_rest = 6,
    _del_health = 8,
    _just_arrive = false;
    _came_from_forest = false;
    _first_time_rest = true;
    pic = 'images/river_bank.png',
    enter = function(s, from)
        if from == i201 then
            s._just_arrive = true;
            status._health = status._health + River_Bank._del_health;
            return 'Я открыл глаза. Яркий солнечный луч, проникающий сквозь густую листву деревьев, играл на моём лице. Неподалёку слышалось мелодичное пение лесных птиц. На фоне такой мирной картины события прошлой ночи казались жутким сном.^Я встал и осмотрелся. Было раннее утро. Солнце, начиная свой дневной путь по небу, показалось из-за далёких гор.^Вдоль реки тянулась неширокая песчаная полоса, за которой виднелся дремучий лес.';
        else
            s._just_arrive = false;
        end
        if (from == Forest_01) or (from == Forest_02) or (from == Forest_03) or (from == Forest_04) then
            s._came_from_forest = true;
        else
            s._came_from_forest = false;
        end
    end,
    dsc = function(s)
        if s._came_from_forest then
            return 'С трудом пробравшись сквозь густые заросли папоротника, я вышел на берег реки, вдоль которой с севера на юг шла песочная полоса. Река огибала невысокую скалу и уходила на восток, откуда доносился шум водопада.';
        else
            return 'С севера, петляя, бежала быстроводная река, благодаря которой я оказался здесь. Огибая невысокую скалу, она уходила на восток, откуда доносился шум водопада.';
        end
    end,
--            Вдоль реки тянулась неширокая песчаная полоса, за которой начинался дремучий лес.]],
    rest = 'Растянувшись на мягкой траве, я отдыхал, не думая о проблемах.',
    way = { vroom ('Север', 'River_Bank_Tree'),
            vroom ('Восток', 'River_Bank_Steep'),
            vroom ('Лес', 'Forest_04'),
            vroom ('Река', 'main') },
    obj = { 'river' },
    exit = function (s, to)
        if to == main then
            p 'Здесь опасно переходить реку — слишком сильное течение.';
            return false;
        end
    end,
};


stones = iobj {
    nam = 'камни',
    _weight = 101,
    dsc = function(s)
        return 'На самом краю обрыва лежит груда неровных {камней}.';
    end,
    exam = 'Большие неровные камни с острыми краями.',
    take = function()
    end,
    used = function (s, w)
        if w == rope then
            if not have (rope) then
                return 'У меня нет верёвки.';
            else
                River_Bank_Steep._rope_is_attached = true;
                Drop(rope);
                return 'Надёжно обвязав верёвку вокруг большого камня, я сбросил другой её конец в пропасть.';
            end
        end
    end,
};


River_Bank_Steep = room {
    nam = 'Ущелье',
    _add_health_rest = 6,
    _del_health = 8,
    _rope_is_attched = false;
    _climb_up = false;
    pic = function(s)
        if s._rope_is_attached then
            return 'images/river_bank_steep_rope.png';
        else
            return 'images/river_bank_steep.png';
        end
    end,
    enter = function (s, from)
        if from == River_Bank_Fall then
            s._climb_up = true;
        else
            s._climb_up = false;
        end
    end,
    dsc = function(s)
        if s._climb_up then
            return 'Я был на крутом скалистом берегу, у глубокого ущелья. Со страшным грохотом река обрушивалась в бездонную пропасть.';
        else
            return 'Всё чаще на моём пути попадались торчащие из песка острые камни. Песчаная полоса постепенно сменилась крутым скалистым берегом.^Двигаясь на всё усиливающийся шум водопада, я вышел к глубокому ущелью. Со страшным грохотом река обрушивалась в бездонную пропасть.';
        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('Запад', 'River_Bank'),
            vroom ('Лес', 'Forest_04'),
            vroom ('Обрыв', 'River_Bank_Fall_Death') },
    obj = { 'stones' },
};


River_Bank_Fall_Death = room {
    nam = 'Ущелье',
    pic = function (s)
        if River_Bank_Steep._rope_is_attached then
            return 'images/river_bank_fall_rope.png';
        else
            return 'images/river_bank_fall.png';
        end
    end,
    enter = function(s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = 'Я неосторожно подошёл к самому краю обрыва. Внезапно камни заскользили у меня под ногами, я потерял равновесие...';
    obj = { vway('1', '{Далее}', 'The_End') },
};


waterfall = iobj {
    nam = 'водопад',
    _state = 0,
    _spell_is_correct = false;
    dsc = function(s)
        if (s._state == 0) then
            return 'Прямо передо мной бушевал {водопад}, разбивая воду в сверкающую пыль.';
        end
    end,
    exam = 'Сплошная стена воды, с грохотом летящая в пропасть.',
    talk = function(s)
        if s._state == 0 and s._spell_is_correct then
            waterfall._state = 6;
            ways(River_Bank_Fall):add(vroom ('Пещера', 'cave_01'));
            ways(cave_01):add(vroom ('Водопад', 'River_Bank_Fall'));
            return 'Я громко произнёс магические слова. Тут же река замедлила своё течение, становясь вязкой. Передо мной водопад замер и стал растягиваться в разные стороны. Плёнка воды разорвалась, словно приглашая войти...';
        end
        if not River_Bank_Fall._spell_is_known then
            return 'Бесполезно пытаться перекричать шум водопада...';
        else
            if (s._state == 0) then
                walk (waterfall_dlg);
                return;
            end
        end
    end,
    used = function(s, w)
        if w == jug then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                if (not jug._filled) then
                    Drop (jug);
                    jug._filled = true;
                    jug._weight = 40;
                    if (status._cargo + 40 <= 100) then
                        Take (jug);
                    end
                    return 'Я наполнил кувшин прозрачной речной водой.';
                end
            end
        end
    end,
    life = function(s)
        if (s._state == 6) then
            s._state = 5;
            return;
        end
        if (s._state == 5) then
            s._state = 0;
            ways(River_Bank_Fall):del('Пещера');
            ways(cave_01):del('Водопад');
            p '...Вскоре застывшая вода пришла в движение, постепенно заливая образовавшееся отверстие. Водопад забурлил, и через несколько мгновений река по-прежнему несла свои воды в пропасть.';
            return true;
        end
        if (s._state == 4) then
            s._state = 3;
            return;
        end
        if (s._state == 3) then
            s._state = 0;
            p 'Не в силах что-либо сделать, я смотрел на пылающий водопад. Но огонь постепенно успокаивался, и вскоре хлынувшая сверху вода уничтожила последние языки пламени.';
            return true;
        end
        if (s._state == 2) then
            s._state = 1;
            return;
        end
        if (s._state == 1) then
            s._state = 0;
            p 'Вдруг гигантская трещина прорезала застывший водопад. Каменные осколки посыпались вниз, на лету превращаясь в воду.^Через несколько мгновений река вновь бежала в ущелье.';
            return true;
        end
    end,
};


waterfall_dlg = dlg{
    nam = 'Водопад',
    pic = 'images/river_bank_fall_rope.png',
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = 'Я попытался припомнить заклинание:',
    obj = {
            [1] = phr('Идхамасам асана ихдамус!', 'Я громко произнёс заклинание. Над водопадом стал собираться туман, густой пеленой обволакивая воду.^Шум затих, сменившись лёгким потрескиванием; когда туман рассеялся, передо мной высилась огромная каменная глыба...', [[pon(1); waterfall._state = 2; walk (River_Bank_Fall);]]),
            [2] = phr('Идхамасахим асана ихдамис!', 'Я произнёс волшебные слова. Стало очень жарко, вода стала темнеть, окрашиваясь в чёрный цвет...^...и тут весь водопад занялся пламенем, словно сухая трава от случайной искры.', [[pon(2); waterfall._state = 4; walk (River_Bank_Fall);]]),
            [3] = phr('Идхамасахам асана ихдамас!', 'Я громко произнёс магические слова. Тут же река замедлила своё течение, становясь вязкой. Передо мной водопад замер и стал растягиваться в разные стороны. Плёнка воды разорвалась, словно приглашая войти...', [[pon(3); waterfall._state = 6; ways(River_Bank_Fall):add(vroom ('Пещера', 'cave_01')); waterfall._spell_is_correct=true; walk (River_Bank_Fall);]]),
            },
    exit = function (s, t)
        me():enable_all();
    end,
};


River_Bank_Fall = room {
    nam = 'Водопад',
    _add_health_rest = 6,
    _del_health = 8,
    _spell_is_known = false;
    pic = function(s)
        if (waterfall._state == 0) then
            return 'images/river_bank_fall_rope.png';
        end
        if (waterfall._state == 1) then
            return 'images/river_bank_fall_stone.png'
        end
        if (waterfall._state == 3) then
            return 'images/river_bank_fall_fire.png'
        end
        if (waterfall._state == 5) then
            return 'images/river_bank_fall_enter.png'
        end
    end,
    enter = function(s)
        lifeon(waterfall);
    end,
    rest = 'Я присел на камень и немного отдохнул.',
    way = { vroom ('Обрыв', 'The_End') },
    obj = { 'waterfall', 'rope' },
    exit = function (s, to)
        ways(River_Bank_Fall):del('Пещера');
        waterfall._state = 0;
        lifeoff(waterfall);
        if to == The_End then
            if (status._health <= 0) then
                walk (The_End);
                return;
            end
            walk (River_Bank_Fall_Death);
            return;
        end
    end,
};


cave_01 = room {
    nam = 'Пещера',
    _add_health_rest = 6,
    _del_health = 8,
    _add_progress = 4,
    _came_from_waterfall = true,
    pic = function(s)
        if (waterfall._state == 0) then
            return 'images/cave_01.png';
        end
        if (waterfall._state == 5) then
            return 'images/cave_01_enter.png'
        end
    end,
    enter = function(s, from)
        ways(cave_01):del('Водопад');
        lifeon(waterfall);
        if (from == River_Bank_Fall) then
            s._came_from_waterfall = true;
        else
            s._came_from_waterfall = false;
        end
    end,
    dsc = function(s)
        if s._came_from_waterfall then
            return 'Я прошёл сквозь водопад в пещеру. И сразу же за моей спиной река сомкнулась, ещё с большей силой устремляясь в ущелье. Вода разбивалась о камни, обдавая меня брызгами.';
        else
            return 'Я вернулся к водопаду. Солнечные лучи, проникая сквозь толщу воды, играли на влажных камнях. Быстрая река преграждала выход из пещеры.';
        end
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Коридор', 'cave_02') },
    obj = { 'waterfall' },
    exit = function (s, to)
        ways(cave_01):del('Водопад');
        lifeoff(waterfall);
    end,
};



bowl_left = iobj {
    nam = 'левая чаша',
    dsc = function(s)
        if cave_02._left_fire then
            return 'В {левой чаше} пылает огонь.';
        end
        if not cave_02._left_jug then
            return '{Левая чаша} пуста.';
        end
    end,
    exam = function (s)
        if cave_02._left_fire then
            return 'Огонь пылал в каменной чаше, составляющей, по-видимому, единое целое с полом пещеры.';
        else
            return 'Каменная чаша, по-видимому, составляет единое целое с полом пещеры.';
        end
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                if cave_02._left_fire then
                    if jug._filled then
                        cave_02._left_fire = false;
                        Drop (jug);
                        jug._filled = false;
                        jug._weight = 18;
                        Take (jug);
                        if not cave_02._right_fire then
                            bowl_left:disable();
                            bowl_right:disable();
                            return 'С тихим шипением умирающего огня темнота затопила пещеру, оставив лишь отблески далёких факелов в конце коридора.';
                        else
                            return 'С помощью воды из кувшина я потушил огонь слева.';
                        end
                    else
                        return 'Не получается...';
                    end
                end
                if not cave_02._left_fire and jug._filled then
                    cave_02._left_jug = true;
                    Drop (jug);
                    cave_03._hiding_place_closed = false;
                    hiding_place:enable();
                    return 'Я поставил кувшин с водой на левую чашу.';
                else
                    return 'Не получается...';
                end
            end
        end
        if w == flint then
            if not have (flint) then
                return 'У меня нет кремня.';
            else
                if cave_02._left_fire then
                    return 'В левой чаше уже горит огонь.';
                end
                if not cave_02._left_jug then
                    cave_02._left_fire = true;
                    return 'С помощью кремня я разжёг огонь в левой чаше.';
                else
                    return 'Развести огонь мне мешает кувшин, который стоит в левой чаше.';
                end
            end
        end
    end,
};


bowl_right = iobj {
    nam = 'правая чаша',
    dsc = function(s)
        if cave_02._right_fire then
            return 'В {правой чаше} пылает огонь.';
        end
        if not cave_02._right_jug then
            return '{Правая чаша} пуста.';
        end
    end,
    exam = function (s)
        if cave_02._right_fire then
            return 'Огонь пылал в каменной чаше, составляющей, по-видимому, единое целое с полом пещеры.';
        else
            return 'Каменная чаша, по-видимому, составляет единое целое с полом пещеры.';
        end
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                if cave_02._right_fire then
                    if jug._filled then
                        cave_02._right_fire = false;
                        Drop (jug);
                        jug._filled = false;
                        jug._weight = 18;
                        Take (jug);
                        if not cave_02._left_fire then
                            bowl_left:disable();
                            bowl_right:disable();
                            return 'С тихим шипением умирающего огня темнота затопила пещеру, оставив лишь отблески далёких факелов в конце коридора.';
                        else
                            return 'С помощью воды из кувшина я потушил огонь справа.';
                        end
                    else
                        return 'Не получается...';
                    end
                end
                if not cave_02._right_fire and jug._filled then
                    cave_02._right_jug = true;
                    Drop (jug);
                    return 'Я поставил кувшин с водой на правую чашу.';
                else
                    return 'Не получается...';
                end
            end
        end
        if w == flint then
            if not have (flint) then
                return 'У меня нет кремня.';
            else
                if cave_02._right_fire then
                    return 'В правой чаше уже горит огонь.';
                end
                if not cave_02._right_jug then
                    cave_02._right_fire = true;
                    return 'С помощью кремня я разжёг огонь в правой чаше.';
                else
                    return 'Развести огонь мне мешает кувшин, который стоит в правой чаше.';
                end
            end
        end
    end,
};


cave_02 = room {
    nam = 'Пещера',
    _add_health_rest = 6,
    _del_health = 8,
    _left_fire = true,
    _right_fire = true,
    _left_jug = false,
    _right_jug = false;
    pic = function(s)
        if (not s._left_fire) and (not s._right_fire) then
            return 'images/cave_02_empty_empty.png';
        end
        if s._left_fire and s._right_jug then
            return 'images/cave_02_fire_jug.png';
        end
        if s._left_jug and s._right_fire then
            return 'images/cave_02_jug_fire.png';
        end
        if s._left_fire and (not s._right_fire) then
            return 'images/cave_02_fire_empty.png';
        end
        if (not s._left_fire) and s._right_fire then
            return 'images/cave_02_empty_fire.png';
        end
        if s._left_fire and s._right_fire then
            return 'images/cave_02_fire_fire.png';
        end
    end,
    dsc = function(s)
        if (not s._left_fire) and (not s._right_fire) then
            return 'Эта часть пещеры была полностью погружена во мрак — я шёл, то и дело натыкаясь на стены. Ориентироваться можно было лишь по приглушённому шуму водопада, да по отблескам далёких светильников в конце коридора.';
        else
            return 'По обе стороны подземного коридора стояли вырезанные в скале колонны. Неровные камни пещеры сменялись обработанной под кирпичную кладку стеной, которая уходила вглубь коридора. Возле колонн горел огонь.';
        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('К водопаду', 'cave_01'),
            vroom ('Коридор', 'cave_03') },
    obj = { 'bowl_left', 'bowl_right' },
};


cave_03 = room {
    nam = 'Комната',
    _add_health_rest = 6,
    _del_health = 8,
    _hiding_place_closed = true,
    pic = function(s)
        if s._hiding_place_closed then
            return 'images/cave_03_closed.png';
        else
            return 'images/cave_03_opened.png';
        end
    end,
    dsc = function(s)
        return 'Узкий коридор расширился, образуя небольшую комнату. Чадящие светильники наполняли воздух едким дымом, от которого слезились глаза. С противоположной стороны стены безмолвно скалилась огромная голова тигра.';
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Коридор', 'cave_02') },
    obj = { 'hiding_place' , 'crystal'},
};


hiding_place = iobj {
    nam = 'тайник',
    _looked = false,
    _examined = false,
    dsc = function(s)
        return 'В центре противоположной стены чернел {тайник}.';
    end,
    exam = function(s)
        s._looked = true;
        return 'Тайник был пуст — кто-то побывал здесь раньше меня. В камне было высечено множество гнёзд под предметы различной формы, но теперь тут не было ничего, кроме пыли.';
    end,
    useit = function(s)
        if s._examined then
            return 'Я ещё раз внимательно осмотрел тайник, ощупывая каждую выпуклость. Больше ничего не было.';
        end
        if not s._looked then
            return 'Сначала надо осмотреть тайник.';
        else
            crystal:enable();
            s._examined = true;
            return 'Я ещё раз внимательно осмотрел тайник, ощупывая каждую выпуклость. Что-то щёлкнуло, и на пол упал небольшой кристалл, случайно забытый грабителями.';
        end
    end,
}:disable();



crystal = iobj {
    nam = 'кристалл',
    _weight = 2,
    dsc = function(s)
        return 'Я вижу {кристалл}.';
    end,
    exam = function(s)
            return 'Кристалл светился холодным голубым светом. Внутри него то и дело вспыхивали белые искры, словно стремясь вырваться на волю.';
    end,
    take = function(s)
        return 'Я взял кристалл.';
    end,
    drop = function(s)
        return 'Я бросил кристалл.';
    end,
}:disable();



tree = iobj {
    nam = 'дерево',
    _weight = 101,
    _fruit_is_present = false,
    dsc = function(s)
        return 'На берегу реки стоит {дерево}.';
    end,
    exam = 'Высокое дерево с незнакомыми плодами.',
    useit = function(s)
        if s._fruit_is_present then
            return 'Нет смысла ещё раз трясти дерево.';
        else
            s._fruit_is_present = true;
            put('fruit', River_Bank_Tree);
            return 'От сотрясения один из плодов упал на песок.';
        end
    end,
};


fruit = iobj {
    nam = 'плод',
    _weight = 8,
    dsc = function(s)
        return 'Я вижу {плод}.';
    end,
    exam = function(s)
        if have (barrel) then
            return 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
        else
            return 'Крупный сочный плод.';
        end
    end,
    take = function(s)
        if here() == labyrinth_11 and labyrinth_11._eagle_is_finishing then
            p 'Я попытался взять плод, но орёл забил крыльями, не подпуская меня, и я был вынужден отступить.';
            return false;
        end
        if have (barrel) then
            p 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
            return false;
        end
        if have (fruit) then
            return 'У меня уже есть плод.';
        else
            return 'Я взял плод.';
        end
    end,
    drop = function(s)
        if here() == labyrinth_11 then
            labyrinth_11._fruit_is_dropped = true;
--            walk(labyrinth_11_fruit);
        end
        return 'Я бросил плод.';
    end,
    useit = function(s)
        if have (fruit) then
            status._health = status._health + 20;
            Drop (fruit);
            objs():del(fruit);
            tree._fruit_is_present = false;
            return 'Я съел плод, наслаждаясь необычным вкусом.';
        else
            return 'У меня нет плода.';
        end
    end,
};



River_Bank_Tree = room {
    nam = 'Дерево на берегу реки',
    _came_from_forest = false;
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/river_bank_tree.png',
    enter = function(s, from)
        if (from == Forest_01) or (from == Forest_02) or (from == Forest_03) or (from == Forest_04) then
            s._came_from_forest = true;
        else
            s._came_from_forest = false;
        end
    end,
    dsc = function(s)
        if s._came_from_forest then
            return 'С трудом пробравшись сквозь густые заросли папоротника, я вышел на берег реки, вдоль которой с севера на юг шла песочная полоса. У самой воды росло плодовое дерево. На западе чернел густой лес.';
        else
            return 'Идя по прибрежной полосе, я увидел высокое плодовое дерево, растущее у самой реки, которая несла свои воды с севера на юг. На западе чернел густой лес.';
        end
    end,
    rest = 'Устроившись под деревом поудобнее, я некоторое время лежал, закрыв глаза.',
    way = { vroom ('Север', 'River_Bank_Bridge'),
            vroom ('Юг', 'River_Bank'),
            vroom ('Лес', 'Forest_04'),
            vroom ('Река', 'main') },
    obj = { 'river', 'tree' },
    exit = function (s, to)
        if to == main then
            p 'Здесь опасно переходить реку — слишком сильное течение.';
            return false;
        end
    end,
};


River_Bank_Bridge = room {
    nam = 'Мост',
    _came_from_forest = false;
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/river_bank_bridge.png',
    enter = function(s, from)
        if (from == Forest_01) or (from == Forest_02) or (from == Forest_03) or (from == Forest_04) then
            s._came_from_forest = true;
        else
            s._came_from_forest = false;
        end
    end,
    dsc = function(s)
        if s._came_from_forest then
            return 'С трудом пробравшись сквозь густые заросли папоротника, я вышел из леса. В этом месте лес подступал вплотную к реке. К прибрежным камням крепился подвесной мост.';
        else
            return 'Песчаная полоса обрывалась, уступая место густому лесу, обступившему меня с севера и запада. Через реку, которая теряла своё начало между деревьями, был перекинут старый подвесной мост, провисающий до самой воды.';
        end
    end,
    rest = 'Растянувшись на мягкой траве, я отдыхал, не думая о проблемах.',
    way = { vroom ('Юг', 'River_Bank_Tree'),
            vroom ('Лес', 'Forest_04'),
            vroom ('Мост', 'Arc'),
            vroom ('Река', 'main') },
    obj = { 'river' },
    exit = function (s, to)
        if to == main then
            p 'Здесь опасно переходить реку — слишком сильное течение.';
            return false;
        end
    end,
};


snake = iobj {
    nam = 'змея',
    dsc = function(s)
        if Arc._snake_is_alive then
            return 'Вокруг дерева обвивается огромная {змея}.';
        else
            return 'Вокруг дерева обвивается мёртвая {змея}.';
        end
    end,
    exam = 'Гигантская змея, обвившаяся вокруг дерева.',
    useit = function(s)
        if Arc._snake_is_alive then
            walk (Snake_Strike);
            return;
        else
            return 'Змея мне больше не помешает.';
        end
    end,
    used = function (s, w)
        if w == crossbow then
            if not have (crossbow) then
                return 'У меня нет арбалета.';
            else
                if Arc._snake_is_alive then
                    Arc._snake_is_alive = false;
                    status._progress = status._progress + 2;
--                    status._cargo = status._cargo - 1;
                    crossbow._loaded = false;
                    return 'Коротко зазвенела тетива, посылая стрелу в голову рептилии. К счастью, я не промахнулся.';
                else
                    return 'Змея мне больше не помешает.';
                end
            end
        end
    end,
};


Snake_Strike = room {
    nam = 'Арка',
    pic = 'images/snake_strike.png',
    enter = function(s)
        me():disable_all();
    end,
    dsc = 'С быстротой молнии чудовище бросилось на меня. Заслоняя солнечный свет, передо мной возникла омерзительная змеиная голова, обнажая огромные изогнутые зубы...';
    obj = { vway('1', '{Next}', 'The_End') },
};



Arc = room {
    nam = 'Арка',
    _add_health_rest = 6,
    _del_health = 8,
    _snake_is_alive = true,
    pic = function (s)
        if s._snake_is_alive then
            return 'images/arc.png';
        else
            return 'images/arc_snake_dead.png';
        end
    end,
    dsc = function (s)
        if Arc._snake_is_alive then
            return 'Оказавшись на другом берегу реки, я остановился перед арочным входом, ведущим вглубь скалы. Но его загораживала огромная змея, извивающаяся вокруг стоящего рядом дерева.';
        else
            return 'Оказавшись на другом берегу реки, я остановился перед арочным входом, ведущим вглубь скалы. Вокруг дерева изввалась мёртвая змея.';
        end
    end,
    rest = 'Я присел на камень и немного отдохнул.',
    way = { vroom ('Мост', 'River_Bank_Bridge'),
            vroom ('Арка', 'part_2_end') },
    obj = { 'snake' },
    exit = function (s, to)
        if to == part_2_end then
            if Arc._snake_is_alive then
                walk (Snake_Strike);
                return;
            end
            if status._exit_hints then
                walk (part_2_end_hints_1);
                return;
            end
        end
    end,
};


jug = iobj {
    nam = function (s)
        if not s._filled then
            return 'кувшин';
        else
            return 'кувшин воды';
        end
    end,
    _weight = 18, -- 18 empty, 40 filled
    _dirty = true,
    _filled = false;
    _powder_inside = false;
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Кувшин} лежит на плите ';
            if s._on_what == 'plate_e' then
                v = v..img ('images/plate_e.png')..'.';
            end
            if s._on_what == 'plate_k' then
                v = v..img ('images/plate_k.png')..'.';
            end
            if s._on_what == 'plate_n' then
                v = v..img ('images/plate_n.png')..'.';
            end
            if s._on_what == 'plate_v' then
                v = v..img ('images/plate_v.png')..'.';
            end
            if s._on_what == 'plate_z' then
                v = v..img ('images/plate_z.png')..'.';
            end
            if s._on_what == 'plate_l' then
                v = v..img ('images/plate_l.png')..'.';
            end
            if s._on_what == 'plate_a' then
                v = v..img ('images/plate_a.png')..'.';
            end
            if s._on_what == 'plate_r' then
                v = v..img ('images/plate_r.png')..'.';
            end
            if s._on_what == 'plate_p' then
                v = v..img ('images/plate_p.png')..'.';
            end
            if s._on_what == 'plate_t' then
                v = v..img ('images/plate_t.png')..'.';
            end
            if s._on_what == 'plate_i' then
                v = v..img ('images/plate_i.png')..'.';
            end
            if s._on_what == 'plate_o' then
                v = v..img ('images/plate_o.png')..'.';
            end
            return v;
        end
        if here() == cave_02 and cave_02._left_jug then
            return 'На левой чаше стоит {кувшин}.';
        end
        if here() == cave_02 and cave_02._right_jug then
            return 'На правой чаше стоит {кувшин}.';
        end
        if not s._filled then
            return 'Я вижу {кувшин}.';
        else
            return 'Я вижу {кувшин воды}.';
        end
    end,
    exam = function(s)
        if s._powder_inside then
            return 'Глиняный кувшин, наполненный искристой водой. Вода имеет золотистый оттенок.';
        end
        if s._dirty then
            return 'Кувшин был пуст и покрыт слоем грязи. Видимо, он много лет пролежал в земле.';
        end
        if not s._dirty and not s._filled then
            return 'Пустой глиняный кувшин.';
        end
        if not s._dirty and s._filled then
            return 'Глиняный кувшин, наполненный водой.';
        end
    end,
    take = function(s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        if (here() == cave_02) and ((cave_02._left_jug) or (cave_02._right_jug)) then
            cave_02._left_jug = false;
            cave_02._right_jug = false;
            cave_03._hiding_place_closed = true;
            hiding_place:disable();
            return 'Я взял кувшин с чаши.';
        end
        return 'Я поднял кувшин.';
    end,
    drop = function(s)
        return 'Я бросил кувшин.';
    end,
    useit = function(s)
        if not have (jug) then
            return 'У меня нет кувшина.';
        else
            if not jug._filled then
                return 'Я не знаю как использовать пустой кувшин.';
            else
                if jug._powder_inside then
                    return 'Эта вода мне ещё пригодится.';
                else
                    Drop (s)
                    s._filled = false;
                    s._weight = 18;
                    Take (s);
                    if not status._drink_water_on_this_level then
                        status._health = status._health + 6;
                        status._drink_water_on_this_level = true;
                        return 'Прохладная вода немного укрепила мои силы.';
                    else
                        return 'Я выпил прозрачную речную воду.';
                    end
                end
            end
        end
    end,
    used = function(s, w)
        if w == powder and s._filled then
            jug._powder_inside = true;
            Drop (powder);
            objs():del(powder);
            return 'Порошок растворился в воде, придав ей золотистый оттенок.';
        end
    end,
    give = function(s, w)
        if w == girl then
            if have (jug) then
                if ( jug._filled and (not girl._wake) ) then
                    girl._wake = true;
                    status._progress = status._progress + 5;
                    return 'Осторожно откинув каштановые волосы, я смочил холодной водой лицо и губы девушки. От живительного действия влаги дрогнули закрытые веки. С тихим стоном девушка подняла голову. На красивом лице лежала тень печали и тревоги, большие удивительные глаза смотрели на меня сквозь пелену боли. Я поднёс с её губам кувшин с водой, и девушка жадно сделала несколько глотков. Наконец, слабым голосом она произнесла:^^— О, спасибо тебе, человек! Кажется, так долго я не видела ни одной живой души. С тех пор, как зло проникло в Лабиринт...^^Она закрыла глаза, видимо вспомнив недавние страшные события. По щеке скатилась горячая слеза. Чтобы девушка успокоилась, я дал ей выпить ещё немного воды.^^— Слишком много зла появилось в Лабиринте. Но есть ещё шанс избавиться от него.';
                end
            else
                return 'У меня нет кувшина.';
            end
        end
    end,
};


Forest_01 = room {
    nam = 'Лес',
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/forest_01.png',
    dsc = 'Густые ветви высоких деревьев переплетались, накрывая лес сплошным ковром. Сюда не проникал ни единый луч солнца, не долетал даже самый лёгкий ветерок.',
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('Север', 'Forest_03'), vroom ('Юг', 'Forest_02'), vroom ('Запад', 'River_Bank'), vroom ('Восток', 'Forest_Troll_Entry') },
    obj = { 'jug' },
};


Forest_02 = room {
    nam = 'Лес',
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/forest_02.png',
    dsc = 'Пробираясь между деревьями я заметил, что лес здесь густеет, хотя это и казалось невозможным.',
    rest = 'Устроившись под деревом поудобнее, я некоторое время лежал, закрыв глаза.',
    way = { vroom ('Север', 'River_Bank_Tree'), vroom ('Юг', 'Forest_01'), vroom ('Запад', 'Forest_Tree'), vroom ('Восток', 'Forest_03') },
};


Forest_03 = room {
    nam = 'Лес',
    _add_health_rest = 6,
    _del_health = 8,
    _escape = false;
    pic = 'images/forest_03.png',
    enter = function (s, from)
        if from == Forest_Troll_Village and (troll._state == TROLL_PATROLLING or troll._state == TROLL_PREPARING) then
            s._escape = true;
        else
            s._escape = false;
        end
    end,
    dsc = function (s)
        if s._escape then
            return 'Я рванулся в лес, под прикрытие деревьев. Раздался резкий свист летящей стрелы; но зелёная стена уже сомкнулась за моей спиной, отрезая меня от выкрикивающего проклятия тролля.^^В стене деревьев не было ни единого просвета. Во всех направлениях лес выглядел совершенно одинаково, и я не имел представления, в какую сторону мне идти.';
        else
            return 'В стене деревьев не было ни единого просвета. Во всех направлениях лес выглядел совершенно одинаково, и я не имел представления, в какую сторону мне идти.';
        end
    end,
    rest = 'Растянувшись на мягкой траве, я отдыхал, не думая о проблемах.',
    way = { vroom ('Север', 'Forest_Spirit'), vroom ('Юг', 'River_Bank_Bridge'), vroom ('Запад', 'Forest_02'), vroom ('Восток', 'Forest_01') },
};


Forest_04 = room {
    nam = 'Лес',
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/forest_04.png',
    dsc = 'Тёмный лес окружил меня со всех сторон. Деревья, похожие одно на другое как две капли воды, и царящий здесь полумрак не позволяли оценить пройденного расстояния...',
    rest = 'Я присел на камень и немного отдохнул.',
    way = { vroom ('Север', 'Forest_02'), vroom ('Юг', 'River_Bank'), vroom ('Запад', 'Forest_03'), vroom ('Восток', 'Forest_01') },
};


spirit = iobj {
    nam = 'Дух',
    dsc = function(s)
        return 'На камне сидит {призрак}.';
    end,
    exam = function(s)
        return 'Призрачный старец опирался на суковатую палку. Длинная седая борода, полный гордости и достоинства взгляд заставляли проникнуться почтением перед этим эфирным существом.';
    end,
    talk = function(s)
--        if Forest_Spirit._spirit_angry or Forest_Spirit._story_told then
        if Forest_Spirit._spirit_angry then
            return 'Бесполезно — он просто не обращает на меня внимания.';
        else
            walk (spirit_dlg);
            return;
        end
    end,
    accept = function(s, w)
        if Forest_Spirit._spirit_angry then
            return 'Бесполезно — он просто не обращает на меня внимания.';
        else
            if w == scroll then
                Drop (scroll);
                objs():del(scroll);
                walk (spirit_dlg_scroll);
                return true;
            end
            p '— Мне не нужны твои дары, Хранитель.';
            return false;
        end
    end,
};


Forest_Spirit = room {
    nam = 'Дух',
    _add_health_rest = 6,
    _del_health = 8,
    _spirit_angry = false;
    _story_told = false;
    _story_told_now = false;
    pic = 'images/forest_spirit.png',
    dsc = function(s)
        if s._story_told and s._story_told_now then
            return 'Я был на небольшой поляне, согретой лучами солнца. На одном из разбросанных по всей поляне валунов сидел призрак, неподвижно глядя в мою сторону. Лик Духа был странен и необычен в этом лесу, но не пугал, внушая благоговейное уважение.';
        else
            return 'Пробираясь сквозь сплетённые ветви старых деревьев, я наконец вышел на небольшую поляну, согретую лучами солнца. На одном из разбросанных по всей поляне валунов сидел призрак, неподвижно глядя в мою сторону. Лик Духа был странен и необычен в этом лесу, но не пугал, внушая благоговейное уважение.';
        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    obj = { 'spirit' },
    way = { vroom ('Лес', 'Forest_02') },
    exit = function (s, to)
        if s._spirit_angry then
            p 'Не стоило портить отношения с Духом. Чёрного Властелина не победить в одиночку...';
            walk (The_End);
            return;
        end
        if s._story_told_now then
            s._sory_told_now = false;
        end
    end,
};


spirit_dlg = dlg{
    nam = 'Дух',
    pic = 'images/forest_spirit.png',
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = nil,
    obj = {
            [1] = phr('Я заблудился. Не скажешь ли, добрый Дух, как выйти к реке?', '— Как только войдёшь в лес, Хранитель, поверни в сторону, откуда к нам приходит холод.', [[poff(3);pon(1);me():enable_all();back();]]),
            [2] = phr('Память моя туманна, и мне необходимо знать своё прошлое. Помоги мне, о чародей!', nil, [[poff(3); walk (spirit_dlg_tale_1); return;]]),
            [3] = phr('Мне нужна помощь... а впрочем, что может этот призрак?', 'Ничего не изменилось в облике Духа, ни единого звука не пронеслось над поляной. Но мне показалось, что я напрасно произнёс эти слова.', [[Forest_Spirit._spirit_angry = true; poff (1,2,3); me():enable_all(); return;]]),
            },
};

spirit_dlg_tale_1 = dlg{
    nam = 'Дух',
    pic = 'images/forest_spirit_tale_1.png',
    dsc = '— Я знал, Хранитель, что ты придёшь. Я расскажу тебе, что знаю.^^Меня удивило обращение Духа, но я слушал дальше. Теперь перед ним возник синий шар, в котором мелькали неясные образы.^^— Предания предупреждают о великих бедах и о человеке, который победит зло. Выбор определён: тебе суждено остановить Чёрного Властелина.',
    obj = {
            [1] = phr('Но как я могу это сделать?', nil, [[poff(1); walk (spirit_dlg_tale_2); return;]]),
          },
};


spirit_dlg_tale_2 = room {
    nam = 'Дух',
    dsc = '— Ты обладаешь силой, но ещё не готов к противоборству. ТЫ — ХРАНИТЕЛЬ ЗЕРКАЛА, ОБИТЕЛИ ДЕМОНА ВОЙНЫ. Только ты способен задействовать это мощное оружие людей.',
    pic = 'images/forest_spirit_tale_1.png',
    obj = { vway('1', '{Далее}', 'spirit_dlg_tale_3') },
};


spirit_dlg_tale_3 = room {
    nam = 'Дух',
    pic = 'images/forest_spirit_tale_2.png',
    dsc = 'В шаре появились реальные картины.^^— Полчища орков и гоблинов, подвластных Чёрному Властелину, напали на страну. Всё, что ни попадалось им на пути, обращалось в руины. Люди стали на защиту своих земель, но силы были неравны.',
    obj = { vway('1', '{Далее}', 'spirit_dlg_tale_4') },
};


spirit_dlg_tale_4 = room {
    nam = 'Дух',
    pic = 'images/forest_spirit_tale_3.png',
    dsc = 'И тогда решено было прибегнуть к последнему средству — Зеркалу.^После победы над Рыцарем Тьмы Зеркало находилось в Лабиринте, и отряд людей направился туда. Хранитель должен был вызвать Демона Войны.',
    obj = { vway('1', '{Далее}', 'spirit_dlg_tale_5') },
};


spirit_dlg_tale_5 = room {
    nam = 'Дух',
    pic = 'images/forest_spirit_tale_4.png',
    dsc = 'Но люди опоздали — отряд гоблинов ворвался в Лабиринт. Зеркало было доставлено в Трёхглавый Замок — замок Чёрного Властелина. А Хранитель был заточён в горной крепости.',
    obj = { vway('1', '{Далее}', 'spirit_dlg_tale_6') },
};


spirit_dlg_tale_6 = room {
    nam = 'Дух',
    pic = 'images/forest_spirit_tale_1.png',
    dsc = '— Без Хранителя Зеркало мертво. Чёрному Властелину нужен ТЫ.',
    obj = { vway('1', '{Далее}', 'spirit_dlg_tale_7') },
};


spirit_dlg_tale_7 = room {
    nam = 'Дух',
--    _add_progress = 10,
    pic = 'images/forest_spirit.png',
    dsc = [[— И ты должен остановить Чёрного Властелина. Проберись в Трёхглавый Замок и вызови Демона Войны.^
             Единственный путь к Замку — через Лабиринт. Я не смогу пойти с тобой, но дам тебе лист, обладающий волшебной силой. Надеюсь, он тебе поможет.^^
             Передо мной появился рой зелёных светлячков. Огоньки двигались всё быстрее и быстрее. Потом, ярко вспыхнув, рой исчез, а в воздухе возник зелёный лист, который медленно опустился мне в руки.]],
    obj = { vway('1', '{Далее}', 'Forest_Spirit') },
    exit = function (s, t)
--        put('leaf', Forest_Spirit);
        Take (leaf);
        Forest_Spirit._story_told = true;
        Forest_Spirit._story_told_now = true;
        me():enable_all();
        status._progress = status._progress + 10; -- поскольку disable_all вырубает status
    end,
};


spirit_dlg_scroll = dlg{
    nam = 'Дух',
    pic = 'images/forest_spirit.png',
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = 'Я протянул Духу свиток. Выскользнув из руки, старый пергамент повис в воздухе.^^— Руны указывают на тайник, сокрытый под водопадом. Попроси реку остановить своё течение, и ты попадёшь в пещеру.',
    obj = {
            [1] = phr('Попросить реку? Каким образом?', 'Произнеси «Идхамасахам асана ихдамас», и река послушается тебя.', [[River_Bank_Fall._spell_is_known = true; me():enable_all(); poff(1)]]),
          },
};



leaf = iobj {
    nam = 'лист',
    _weight = 0,
    dsc = function(s)
        return 'Я вижу {лист}.';
    end,
    exam = function(s)
        return 'Ярко-зелёный бархатистый лист, от которого исходило слабое сияние.';
    end,
    take = function(s)
        return 'Я взял лист.';
    end,
    drop = function(s)
        return 'Я бросил лист.';
    end,
    give = function(s,w)
        if w == forest_master and Forest_Tree._tree_is_humble then
            Drop(leaf);
            objs():del(leaf);
            Forest_Tree._boulder_is_lifted = true;
            scroll:enable();
            rope:enable();
            return '— Благодарю тебя, странник, ты вернул мне утраченные силы. Возможно то, что лежит под этим камнем, поможет тебе.';
        end
    end,
};


boulder_forest = iobj {
    nam = 'валун',
    dsc = function(s)
        if Forest_Tree._boulder_is_lifted then
            return 'Огромный {валун} рядом с деревом приподнят.';
        else
            return 'Рядом с деревом лежит огромный {валун}.';
        end
    end,
    exam = function(s)
        return 'Огромный камень, покрытый мхом.';
    end,
    take = function(s)
        p 'Я попытался поднять валун, но безрезультатно.';
        return false;
    end,
};


scroll = iobj {
    nam = 'свиток',
    _weight = 0,
    _lay_under_boulder = true,
    dsc = function(s)
        if s._lay_under_boulder then
            return 'Под валуном лежит {свиток}.';
        else
            return 'Я вижу {свиток}.';
        end
    end,
    exam = function(s)
        return 'Небольшой пергаментный свиток, потрескавшийся от старости. С большим трудом можно различить древние руны.';
    end,
    take = function(s)
        s._lay_under_boulder = false;
        return 'Я поднял свиток.';
    end,
    drop = function(s)
        return 'Я бросил свиток.';
    end,
}:disable();


rope = iobj {
    nam = 'верёвка',
    _weight = 29,
    _lay_under_boulder = true,
    dsc = function(s)
        if here() == Forest_Tree and s._lay_under_boulder then
            return 'Под валуном лежит {верёвка}.';
        end
        if River_Bank_Steep._rope_is_attached then
            if here() == River_Bank_Steep then
                return '{Верёвка} надёжно привязана к камням.';
            else
                return '{Верёвка} свисает сверху.';
            end
        end
        return 'Я вижу {верёвку}.';
    end,
    exam = function(s)
        return 'Прочная длинная верёвка, свитая из волокон какого-то растения.';
    end,
    take = function(s)
        if here() == River_Bank_Fall then
            p 'Я не могу отвязать верёвку отсюда.';
            return false;
        end
        if River_Bank_Steep._rope_is_attached then
            River_Bank_Steep._rope_is_attached = false;
            return 'Я отвязал верёвку от камней.';
        end
        s._lay_under_boulder = false;
        return 'Я поднял верёвку.';
    end,
    drop = function(s)
        return 'Я бросил верёвку.';
    end,
    useit = function (s)
        if River_Bank_Steep._rope_is_attached then
            if here() == River_Bank_Steep then
                p 'По верёвке я спустился на небольшую площадку, чудом держащуюся на отвесной стене ущелья.';
                walk (River_Bank_Fall);
                return;
            end
            if here() == River_Bank_Fall then
                p 'По верёвке я взобрался наверх.';
                walk (River_Bank_Steep);
                return;
            end
        end
        return 'Каким образом?';
    end,
}:disable();


forest_master = iobj {
    nam = 'дерево',
    dsc = function(s)
        return 'Посреди поляны стоит огромное {дерево}.';
    end,
    exam = function(s)
        if Forest_Tree._tree_is_dead then
            return 'Дерево было мертво — лишь несколько сухих листьев одиноко покачивались на безжизненных ветвях.';
        else
            return 'Могучий ствол с толстой морщинистой корой, крепкие длинные ветви, суровый взгляд — всё говорило о силе и власти хозяина леса.';
        end
    end,
    used = function(s,w)
        if w == jug and jug._filled then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                Drop (jug);
                jug._filled = false;
                jug._weight = 18;
                Take (jug);
                if jug._powder_inside then
                    jug._powder_inside = false;
                    p 'Сухая древесина мгновенно впитала искрящуюся воду. Внезапно лесной гигант дрогнул; его ветви, наливаясь жизнью, потянулись к солнцу.^';
                    walk (Forest_Tree_Awake);
                    return;
                else
                    return 'Я вылил воду под дерево. Ничего не произошло.';
                end
            end
        end
    end,
    talk = function(s)
        if Forest_Tree._tree_is_dead then
            return 'Дерево мертво.';
        else
            if Forest_Tree._tree_is_angry then
                return 'Дерево не отвечает.';
            end
            if Forest_Tree._tree_is_humble then
                walk (tree_dlg_3);
                return;
            end
            walk (tree_dlg_1);
            return;
        end
    end,
};


tree_dlg_1 = dlg{
    nam = 'Исполинское дерево',
    pic = 'images/forest_tree_green.png',
    enter = function (s, t)
        me():disable_all();
    end,
    obj = {
            [1] = phr('Поляна будет куда просторнее, если выкорчевать это неуклюжее дерево.', 'Слова гулко прозвучали в застывшем воздухе. Странно, но мне показалось, что всё вокруг замерло в тревожном ожидании. Когда напряжение спало, листва огромного дерева неприятно зашумела.', [[poff(1,2); Forest_Tree._tree_is_angry = true; me():enable_all();]]),
            [2] = phr('От Чёрного Властелина пострадал и этот волшебный лес. Если бы кто-нибудь мог помочь мне остановить его злодеяния...', nil, [[poff(1,2); walk (tree_dlg_2); return;]]),
          },
};


tree_dlg_2 = room{
    nam = 'Исполинское дерево',
    pic = 'images/forest_tree_green.png',
    dsc = function(s)
        return 'Тревожная тишина была ответом на моё воззвание. Казалось, лес оценивает искренность моих слов. Но вот крона огромного дерева оживлённо зашумела, мощный ствол пришёл в движение...';
    end,
    obj = { vway('1', '{Далее}', 'Forest_Tree') },
    exit = function(s)
        Forest_Tree._tree_is_humble = true;
        me():enable_all();
        return '...и передо мной предстал сам Хозяин Волшебного Леса. По поляне разнёсся низкий голос дерева:^— Я слышал, странник, ты хочешь освободить страну от власти Чёрного Властелина? Это благородное, но очень нелёгкое дело. Я помогу тебе как смогу. Что тебе нужно?';
    end,
};


tree_dlg_3 = dlg{
    nam = 'Исполинское дерево',
    pic = function (s)
        if Forest_Tree._boulder_is_lifted then
            return 'images/forest_tree_alive_lifted.png';
        else
            return 'images/forest_tree_alive.png';
        end
    end,
    enter = function (s)
        if Forest_Tree._boulder_is_lifted then
            poff (3);
        end
    end,
    obj = {
            [1] = phr('Скажи мне, что это за лес?', '— Это самый большой и прекрасный лес. Первые деревья поселились в этих горах в незапамятные времена; наши корни проникли в плодородную почву, наши кроны стали домом для многих живых существ. Тысячелетиями мы жили в мире. Были и нелёгкие времена, но лес всегда выходил победителем. Однако сейчас... Сейчас лес близок к гибели. Орды троллей, орков и гоблинов уничтожают деревья, в лесу поселилось множество злых тварей. Отряд орков нашёл меня, и если бы не ты, странник, лес остался бы без своего хозяина.^Спаси лес! Останови Чёрного Властелина!'),
            [2] = phr('Я заблудился, как мне выйти к реке?', '— Да, мой лес огромен, но выбраться с этой поляны несложно. Как только войдёшь в лес, иди туда, куда, завершив дневной путь, уходит Солнце.', [[pon(2); back();]]),
            [3] = phr('Я должен быть готов к встрече с врагом. Не найдётся ли для меня какого-либо оружия?', '— У меня есть кое-что для тебя, странник, под этим валуном, но я ещё слишком слаб, чтобы поднять его.',[[poff(3); back();]]),
          },
};



Forest_Tree_Awake = room {
    nam = 'Исполинское дерево',
    pic = 'images/forest_tree_green.png',
    dsc = 'Через несколько секунд над поляной тихо шумела зелёная крона ожившего дерева.',
    enter = function(s)
        status._progress = status._progress + 3;
        Forest_Tree._tree_is_dead = false;
--        Forest_Tree._tree_is_just_awake = true;
        me():disable_all();
    end,
    obj = { vway('1', '{Далее}', 'Forest_Tree') },
    exit = function (s, to)
        me():enable_all();
    end,
};



Forest_Tree = room {
    nam = 'Исполинское дерево',
    _add_health_rest = 6,
    _del_health = 8,
    _tree_is_dead = true;
--    _tree_is_just_awake = false;
    _boulder_is_lifted = false;
    _tree_is_angry = false;
    _tree_is_humble = false;
    _came_from_forest = true;
    pic = function(s)
        if s._boulder_is_lifted then
            return 'images/forest_tree_alive_lifted.png';
        end
        if s._tree_is_dead then
            return 'images/forest_tree_dead.png';
        end
        if s._tree_is_humble then
            return 'images/forest_tree_alive.png';
        else
            return 'images/forest_tree_green.png';
        end
    end,
    enter = function(s, from)
        if from == Forest_02 then
            s._came_from_forest = true;
        else
            s._came_from_forest = false;
        end
    end,
    dsc = function(s)
        if s._tree_is_dead then
            return 'Сплошная стена деревьев расступилась, и я вышел на небольшую поляну. Посреди поляны, возле огромного, покрытого мхом валуна, высилось исполинское дерево, раскинув свои сухие ветви над всей поляной.^Казалось, что это сам хозяин леса — так величественен был его вид.';
        else
            if s._tree_is_humble then
                if s._came_from_forest then
                    return 'Пробравшись сквозь густую стену деревьев, я вышел на небольшую поляну, посредине которой высился хозяин этого волшебного леса. Густая крона дерева приятно шумела, успокаивая после давления мрачной чащи.';
                else
                    return 'Я был на небольшой поляне, посредине которой высился хозяин этого волшебного леса. Густая крона дерева приятно шумела, успокаивая после давления мрачной чащи.';
                end
            else
                if s._came_from_forest then
                    return 'Наконец тёмная стена леса расступилась, и я вышел на небольшую поляну, посредине которой, возле одинокого валуна, высилось исполинское дерево. Густая крона величественного хозяина леса приятно шумела, создавая впечатление, что дерево разговаривает.';
                else
--                    return 'Исполинское дерево, раскинуло свои зелёные ветви над всей поляной.^Казалось, что это сам хозяин леса — так величественен был его вид.';
                    return 'Я был на небольшой поляне, посредине которой, возле одинокого валуна, высилось исполинское дерево. Густая крона величественного хозяина леса приятно шумела, создавая впечатление, что дерево разговаривает.';
                end
            end
        end
    end,
    rest = 'Устроившись под деревом поудобнее, я некоторое время лежал, закрыв глаза.',
    way = { vroom ('Лес', 'Forest_01') },
    obj = { 'forest_master', 'boulder_forest', 'scroll', 'rope' },
    exit = function (s, to)
--        if s._tree_is_just_awake then
--            s._tree_is_just_awake = false;
--        end
        if s._tree_is_angry then
            p 'Не стоило портить отношения с Хозяином Леса. Чёрного Властелина не победить в одиночку...';
            walk (The_End);
            return;
        end
    end,
};


Forest_Troll_Entry = room {
    nam = 'Лес',
    pic = 'images/forest_01.png',
    enter = function(s)
        me():disable_all();
    end,
    dsc = 'Я уже потерял надежду выбраться из этого глухого леса, как вдруг заметил мощёную битым камнем дорожку.^Надеясь, что мне помогут отсюда выбраться, я пошёл вдоль дорожки.',
    obj = { vway('1', '{Далее}', 'Forest_Troll_Village') },
    exit = function(s)
        me():enable_all();
        lifeon(troll_daemon);
    end,
};


TROLL_NONE = 0;
TROLL_SEATING = 1;
TROLL_HIDING = 2;
TROLL_PREPARING = 3;
TROLL_FIRING = 4;
TROLL_PATROLLING = 5;

TROLL_SHED_ENTER = 6;
TROLL_SHED_FIRING = 7;
TROLL_SHED_DISABLED = 8;
TROLL_SHED_RECOVERED = 9;

TROLL_FROZEN = 10;
TROLL_SMASHED = 11;


troll_daemon = iobj {
    nam = 'daemon',
    life = function(s)
        if here() == Forest_Troll_Village then
            if Forest_Troll_Village._just_entered then
                Forest_Troll_Village._just_entered = false;
                if troll._state == TROLL_SEATING then
                    p 'На пороге сидел тролль.';
                    return true;
                end
                if troll._state == TROLL_PATROLLING then
                    p 'Хозяин дома бродил неподалёку. Заметив меня, он навёл заряженный арбалет.';
                    return true;
                end
            end
            if troll._state == TROLL_SEATING then
                troll._state = TROLL_HIDING;
                troll:disable();
                p 'Заметив меня, тролль вскочил и с воплем скрылся в доме.';
                return true;
            end
            if troll._state == TROLL_HIDING then
                troll._state = TROLL_PREPARING;
                troll:enable();
                p 'На несколько мгновений я задумался, пытаясь понять, что означал этот крик. Внезапно дверь дома распахнулась, и тролль, на ходу заряжая арбалет, побежал ко мне.';
                return true;
            end
            if troll._state == TROLL_PREPARING or troll._state == TROLL_PATROLLING then
                troll._state = TROLL_FIRING;
                me():disable_all();
                ACTION_TEXT = nil;
                walk (Forest_Troll_Village_Death);
                return true;
            end
            if troll._state == TROLL_SHED_DISABLED then
                troll._state = TROLL_HIDING;
                p 'Осторожно перешагнув через лежащего на полу тролля, я выбежал из сарая и остановился, чтобы перевести дух.^^Вдруг в сарае что-то загремело, раздался почти звериный рёв...';
                return true;
            end
        end
        if here() == Forest_Troll_Shed then
            if troll._state == TROLL_HIDING then
                troll._state = TROLL_PATROLLING;
                return true;
            end
            if Forest_Troll_Shed._troll_enter then
                Forest_Troll_Shed._troll_enter = false;
                troll._state = TROLL_SHED_ENTER;
                put ('troll', Forest_Troll_Shed);
                troll:enable();
                p 'Снаружи послышались быстрые шаги. Дверь резко распахнулась: на пороге стоял тролль, ошеломлённо глядя на меня.';
                return true;
            end
            if troll._state == TROLL_SHED_ENTER then
                if Forest_Troll_Shed._box_is_broken then
                    troll._state = TROLL_SHED_DISABLED;
                    p 'С силой, подогреваемой злостью, я опустил ящик на голову троллю. Тот камнем рухнул на земляной пол.';
                    return true;
                else
                    troll._state = TROLL_SHED_FIRING;
                    ACTION_TEXT = nil;
                    walk (Forest_Troll_Shed_Death);
                    return true;
                end
            end
            if troll._state == TROLL_SHED_DISABLED then
                troll._state = TROLL_SHED_RECOVERED;
                ACTION_TEXT = nil;
                walk (Forest_Troll_Shed_Death);
                return true;
            end
        end
    end,
};



troll = iobj {
    nam = 'тролль',
    _weight = 101,
    _state = TROLL_SEATING,
    dsc = function(s)
--        local st={
--                  '01На пороге сидел {тролль}.',
--                  '02Заметив меня тролль вскочил и с воплем скрылся в доме.',
--                  '03На несколько мгновений я задумался, пытаясь понять, что означал этот крик. Внезапно дверь распахнулась, и {тролль}, на ходу заряжая арбалет, побежал ко мне.',
--                  '04',
--                  '05Хозяин дома бродил неподалёку. Заметив меня, он навёл заряженный арбалет.',
--                  '06 Снаружи послышались быстрые шаги. Дверь резко распахнулась: на пороге стоял {тролль}, ошеломлённо глядя на меня.',
--                  '07 Глухо зарычав, тролль навёл на меня арбалет. Я попытался увернуться, но в тесноте четырёх стен это было непросто...',
--                  '08 На поляне стояла ледяная статуя {тролля}, всё ещё сжимающая в руках арбалет.',
--                  '09',
--                  '10',
--                 }
--        return st[s._state];
        return 'Я вижу {тролля}.';
    end,
    exam = function(s)
        if s._state == TROLL_FROZEN then
            return 'Тролль выглядел искусно обработанной глыбой льда, каким-то чудом сохранившейся под лучами солнца.';
        else
            return 'Это тролль.';
        end
    end,
    take = function(s)
    end,
    talk = function(s)
        if s._state == TROLL_SEATING then
            return true;
        end
        if s._state == TROLL_FROZEN then
            return 'Бесполезно говорить с ледяной статуей тролля...';
        end
        return 'Тролль только зарычал в ответ...';
    end,
    used = function(s, w)
        if w == box then
            if have (box) then
                if troll._state == TROLL_SHED_ENTER then
                    Drop(box);
                    objs():del(box);
                    Forest_Troll_Shed._box_is_broken = true;
                    return true;
                end
            else
                return 'У меня нет ящика.';
            end
        end
        if w == crystal then
            if have (crystal) then
                if troll._state == TROLL_PATROLLING then
                    Drop(crystal);
                    objs():del(crystal);
                    troll._state = TROLL_FROZEN;
                    return 'Кристалл взорвался синим облаком, моментально окутавшим тролля с головы до ног. Обжигающе ледяной ветер пронёсся над поляной...^^Миг спустя облако исчезло. На поляне стояла ледяная статуя, всё ещё сжимающая в руках арбалет.';
                end
            else
                return 'У меня нет кристалла.';
            end
        end
    end,
    useit = function(s)
        if troll._state == TROLL_FROZEN then
            troll._state = TROLL_SMASHED;
            troll:disable();
            crossbow:enable();
            return 'От удара хрупкий лёд раскололся и осыпался на землю бесформенной грудой.';
        end
    end
};


crossbow = iobj {
    nam = 'арбалет',
    _weight = 36,
    _loaded = true,
    _charged = false,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Арбалет} лежит на плите ';
            if s._on_what == 'plate_e' then
                v = v..img ('images/plate_e.png')..'.';
            end
            if s._on_what == 'plate_k' then
                v = v..img ('images/plate_k.png')..'.';
            end
            if s._on_what == 'plate_n' then
                v = v..img ('images/plate_n.png')..'.';
            end
            if s._on_what == 'plate_v' then
                v = v..img ('images/plate_v.png')..'.';
            end
            if s._on_what == 'plate_z' then
                v = v..img ('images/plate_z.png')..'.';
            end
            if s._on_what == 'plate_l' then
                v = v..img ('images/plate_l.png')..'.';
            end
            if s._on_what == 'plate_a' then
                v = v..img ('images/plate_a.png')..'.';
            end
            if s._on_what == 'plate_r' then
                v = v..img ('images/plate_r.png')..'.';
            end
            if s._on_what == 'plate_p' then
                v = v..img ('images/plate_p.png')..'.';
            end
            if s._on_what == 'plate_t' then
                v = v..img ('images/plate_t.png')..'.';
            end
            if s._on_what == 'plate_i' then
                v = v..img ('images/plate_i.png')..'.';
            end
            if s._on_what == 'plate_o' then
                v = v..img ('images/plate_o.png')..'.';
            end
            return v;
        end
        if here() == castle_401 and ledge._ready then
            return '{Арбалет} зацеплен за камни и перекинут рукояткой наружу.';
        end
        if here() == castle_402 and ledge._ready then
            return '{Арбалет} зацеплен за камни верхнего уровня.';
        end
        return 'Я вижу {арбалет}.';
    end,
    exam = function(s)
        if s._charged then
            return 'Мощный арбалет, заряженный верёвкой с крюком.';
        end
        if s._loaded then
            return 'Мощный арбалет, заряженный короткой стрелой.';
        else
            return 'Мощный арбалет с удобным прикладом. Разряженный. Без стрелы он ни на что не годится.';
        end
    end,
    take = function(s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        if here() == castle_401 or here() == castle_402 then
            ledge._ready = false;
        end
        return 'Я взял арбалет.';
    end,
    drop = function(s)
        return 'Я бросил арбалет.';
    end,
    used = function (s, w)
        if w == arrow then
            if have (arrow) then
                if s._loaded then
                    return 'Арбалет уже заряжен.';
                else
                    Drop(arrow);
                    objs():del(arrow);
                    s._loaded = true;
                    return 'Я зарядил арбалет стрелой.';
                end
            else
                return 'У меня нет стрелы.';
            end
        end
        if w == rope_hook then
            if s._charged then
                return 'Я уже зарядил арбалет железным крюком.';
            else
                if here() == castle_413 then
                    s._charged = true;
                    return 'Я зарядил арбалет железным крюком.';
                else
                    return 'Я мог бы зарядить арбалет железным крюком, но сейчас в этом не было необходимости. Я должен был найти для этого более подходящее место.';
                end
            end
        end
    end,
    useit = function (s)
        if here() == castle_401 and ledge._ready then
            walk (castle_401_end);
            return;
        else
            return 'Не получается.';
        end
    end,
}:disable();



Forest_Troll_Village = room {
    nam = 'Дом тролля',
    _add_health_rest = 6,
    _del_health = 8,
    _came_from_forest = true;
    _just_entered = false;
    _window_smashed = false;
    pic = function(s)
        if troll._state == TROLL_SEATING then
            return 'images/forest_village_troll_seating.png';
        end
        if troll._state == TROLL_HIDING then
            return 'images/forest_village_troll_hiding.png';
        end
--        if troll._state == TROLL_PREPARING then
        if troll._state == TROLL_PREPARING or troll._state == TROLL_PATROLLING then
            return 'images/forest_village_troll_preparing.png';
        end
        if troll._state == TROLL_FIRING then
            return 'images/forest_village_troll_firing.png';
        end
        if troll._state == TROLL_SHED_DISABLED then
            return 'images/forest_village_troll_hiding.png';
        end
        if troll._state == TROLL_FROZEN then
            if s._window_smashed then
                return 'images/forest_village_troll_frozen_window_smashed.png';
            else
                return 'images/forest_village_troll_frozen_window_normal.png';
            end
        end
        if troll._state == TROLL_SMASHED then
            if s._window_smashed then
                return 'images/forest_village_troll_smashed_window_smashed.png';
            else
                return 'images/forest_village_troll_smashed_window_normal.png';
            end
        end
    end,
    enter = function(s, from)
        if (from == Forest_Troll_Entry) or (from == Forest_Troll_Shed) then
            s._just_entered = true;
        else
            s._just_entered = false;
        end
        if from == Forest_Troll_Entry then
            s._came_from_forest = true;
        else
            s._came_from_forest = false;
        end
--        if from == Forest_Troll_Shed and (troll._state == TROLL_SHED_DISABLED or troll._state == TROLL_SMASHED) then
        if troll._state == TROLL_SHED_DISABLED or troll._state == TROLL_SMASHED then
            troll:disable();
        else
            troll:enable();
        end
    end,
    dsc = function(s)
        if s._came_from_forest then
            return 'Через некоторое время из-за деревьев показался небольшой дом, окружённый хозяйственными постройками.';
        else
            if troll._state == TROLL_FROZEN or troll._state == TROLL_SMASHED then
                return 'Я вышел во двор, залитый солнечным светом.';
            else
                return 'Я был около небольшого дома, окружённого хозяйственными постройками.';
            end
        end
    end,
    rest = 'Растянувшись на мягкой траве, я отдыхал, не думая о проблемах.',
    way = { vroom ('Лес', 'Forest_03'), vroom ('Сарай', 'Forest_Troll_Shed')  },
    obj = { 'troll', 'troll_house', 'crossbow' },
    exit = function(s, to)
        if to == Forest_Troll_Shed then
            if (troll._state == TROLL_SEATING or troll._state == TROLL_PREPARING or troll._state == TROLL_PATROLLING or troll._state == TROLL_SHED_DISABLED) then
                return false;
            end
            if (troll._state == TROLL_HIDING and Forest_Troll_Shed._box_is_broken) then
                return false;
            end
        end
        if to == Forest_03 then
            if (troll._state == TROLL_PREPARING or troll._state == TROLL_PATROLLING) then
                return false;
            end
            if troll._state == TROLL_HIDING or troll._state == TROLL_SHED_DISABLED then
                troll._state = TROLL_PATROLLING;
            end
            lifeoff (troll_daemon);
        end
        if to == Forest_Troll_Village_Death then
            lifeoff (troll_daemon);
        end
    end,
};


troll_house = iobj {
    nam = 'дом',
    dsc = function(s)
        return 'На поляне стоит {дом}, окружённый хозяйственными постройками.';
    end,
    exam = function (s)
        troll_house_window:enable();
        return 'Одноэтажный дом из светлого кирпича, с крепкой дубовой дверью и небольшим застеклённым окном.';
    end,
    useit = function (s, w)
        return 'У меня не было желания входить в дом тролля.';
    end,
    obj = { 'troll_house_window' },
};


troll_house_window = iobj {
    nam = 'окно',
    _arrow_present = true,
    dsc = function(s)
        if Forest_Troll_Village._window_smashed then
            return 'В доме тролля есть небольшое {окно}. Оно разбито.';
        else
            return 'В доме тролля есть небольшое застеклённое {окно}.';
        end
    end,
    exam = function (s)
        if Forest_Troll_Village._window_smashed then
            arrow:enable();
            if troll_house_window._arrow_present then
                return 'На месте окна зияла дыра с острыми краями, сквозь которую смутно виднелись предметы домашней обстановки. На самом подоконнике лежала короткая стрела.';
            else
                return 'На месте окна зияла дыра с острыми краями, сквозь которую смутно виднелись предметы домашней обстановки.';
            end
        else
            return 'Окно с мутными стёклами, не позволяющими заглянуть внутрь.';
        end
    end,
    useit = function (s)
        if troll._state == TROLL_HIDING then
            return true;
        end
        Forest_Troll_Village._window_smashed = true;
        return 'Осколки стекла брызнули в разные стороны, открывая чёрную дыру на месте окна.';
    end,
    used = function (s, w)
        if w == fruit then
            if troll._state == TROLL_HIDING then
                return true;
            end
            if have (fruit) then
                  Forest_Troll_Village._window_smashed = true;
                  Drop (fruit);
                  return 'Осколки стекла брызнули в разные стороны, открывая чёрную дыру на месте окна.';
            else
                return 'У меня нет плода.';
            end
        end
        if w == crossbow then
            if not have (crossbow) then
                return 'У меня нет арбалета.';
            else
                Forest_Troll_Village._window_smashed = true;
                return 'Размахнувшись, я ударил прикладом по стеклу. Осколки брызнули в разные стороны, открывая чёрную дыру на месте окна.';
            end
        end
    end,
    obj = { 'arrow' },
}:disable();


arrow = iobj {
    nam = 'стрела',
    _weight = 0,
    dsc = function(s)
        return 'Я вижу {стрелу}.';
    end,
    exam = function(s)
        return 'Острая стрела для арбалета.';
    end,
    take = function (s)
        troll_house_window._arrow_present = false;
        return 'Я взял стрелу.';
    end,
    drop = function (s)
        return 'Я бросил стрелу.';
    end
}:disable();



Forest_Troll_Village_Death = room {
    nam = 'Дом тролля',
    pic = function(s)
        return 'images/forest_village_troll_firing.png';
    end,
    enter = function(s)
--        ACTION_TEXT = nil;
    end,
    dsc = function(s)
        return '...Тролль вскинул арбалет, коротко свистнула летящая стрела...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
};


hole = iobj {
    nam = 'нора',
    dsc = function(s)
        return 'В стене, у самого пола, видна небольшая {нора}.';
    end,
    exam = function(s)
        if have (barrel) then
            return 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
        end
        if Forest_Troll_Shed._powder_in_a_hole then
            powder:enable();
            return 'В норе было полно мусора, среди которого я заметил небольшой кожаный мешочек, наполненный каким-то порошком.';
        else
            return 'В норе не было ничего, кроме мусора.';
        end
    end,
    obj = { 'powder' },
}:disable();


powder = iobj {
    nam = 'порошок',
    _weight = 8,
    dsc = function(s)
        if Forest_Troll_Shed._powder_in_a_hole then
            return 'В норе лежит небольшой {мешочек с порошком}.';
        end
        return 'Я вижу {мешочек с порошком}.';
    end,
    exam = function(s)
        return 'Мешочек с порошком золотистого цвета.';
    end,
    take = function(s)
        if Forest_Troll_Shed._powder_in_a_hole then
            Forest_Troll_Shed._powder_in_a_hole = false;
            return 'Я вынул из норы мешочек.';
        else
            return 'Я поднял мешочек.';
        end
    end,
    drop = function(s)
        return 'Я бросил мешочек.';
    end,
}:disable();


barrel = iobj {
    nam = 'бочка',
    _weight = 97,
    dsc = function(s)
        return 'На полу стоит {бочка}.';
    end,
    exam = function(s)
        return 'Огромная деревянная бочка, судя по всему, пустая.';
    end,
    take = function(s)
        if Forest_Troll_Shed._barrel_is_moved then
            p 'Я больше не хочу таскать тяжёлую бочку.';
            return false;
        end
        if Forest_Troll_Shed._box_is_on_barrel then
            p 'Слишком тяжело!';
            return false;
        else
            if status._cargo + 97 <= 100 then
                Forest_Troll_Shed._barrel_is_moved = true;
                hole:enable();
                return 'Я поднял бочку.';
            else
                p 'Слишком тяжело!';
                return false;
            end
        end
    end,
    drop = function(s)
        return 'Я бросил бочку на пол.';
    end,
    useit = function (s)
        if have (barrel) then
            return 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
        end
        if troll._state == TROLL_SHED_DISABLED then
            return true;
        end
        if troll._state == TROLL_FROZEN or troll._state == TROLL_SMASHED then
            return 'Что было сил я ударил по бочке: глухой гул, от которого, казалось, задрожали стены, наполнил тесную комнату.';
        end
        if troll._state == TROLL_SHED_ENTER then
            return 'Что было сил я ударил по бочке: глухой гул, от которого, казалось, задрожали стены, наполнил тесную комнату.';
        else
            Forest_Troll_Shed._troll_enter = true;
            return 'Что было сил я ударил по бочке: глухой гул, от которого, казалось, задрожали стены, наполнил тесную комнату.';
        end
    end,
};


box = iobj {
    nam = 'ящик',
    _weight = 48,
    dsc = function(s)
        if Forest_Troll_Shed._box_is_on_barrel then
            return 'На бочке лежит {ящик}.';
        else
            return 'На полу лежит {ящик}.';
        end
    end,
    exam = function(s)
        if have (barrel) then
            return 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
        else
            return 'Крепко сбитый тяжёлый ящик.';
        end
    end,
    take = function(s)
        if have (barrel) then
            p 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
            return false;
        end
        if Forest_Troll_Shed._box_is_on_barrel then
            if status._cargo + 48 <= 100 then
                Forest_Troll_Shed._box_is_on_barrel = false;
                return 'Я снял ящик с бочки.';
            else
                p 'Слишком тяжело!';
                return false;
            end
        else
            return 'Я поднял ящик с пола.';
        end
    end,
    drop = function(s)
        return 'Я бросил ящик на пол.';
    end,
};


Forest_Troll_Shed = room {
    nam = 'Сарай',
    _add_progress = 1,
    _box_is_on_barrel = true,
    _box_is_broken = false,
    _barrel_is_moved = false,
    _powder_in_a_hole = true,
    _first_time_enter = true,
--    _troll_disabled = false,
    _troll_enter = false;
    _add_health_rest = 6,
    _del_health = 8,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    pic = function(s)
        if troll._state == TROLL_FROZEN or troll._state == TROLL_SMASHED then
            return 'images/shed_final.png';
        end
        if s._box_is_on_barrel then
            if troll._state == TROLL_SHED_ENTER then
                return 'images/shed_initial_troll_enter.png';
            end
            return 'images/shed_initial.png';
        end
        if not seen (barrel) then
            return 'images/shed_barrel_taken.png';
        end
        if seen (box) then
            if not s._barrel_is_moved then
                if troll._state == TROLL_SHED_ENTER then
                    return 'images/shed_barrel_not_moved_box_dropped_troll_enter.png';
                end
                return 'images/shed_barrel_not_moved_box_dropped.png';
            end
            if s._barrel_is_moved then
                if troll._state == TROLL_SHED_ENTER then
                    return 'images/shed_barrel_moved_box_dropped_troll_enter.png';
                end
                return 'images/shed_barrel_moved_box_dropped.png';
            end
        end
        if not seen (box) then
            if not s._barrel_is_moved then
                if troll._state == TROLL_SHED_DISABLED then
                    return 'images/shed_initial_troll_disabled.png';
                end
                if troll._state == TROLL_SHED_ENTER then
                    return 'images/shed_barrel_not_moved_no_box_troll_enter.png';
                end
                return 'images/shed_barrel_not_moved_no_box.png';
            end
            if s._barrel_is_moved then
                if troll._state == TROLL_SHED_DISABLED then
                    return 'images/shed_barrel_moved_troll_disabled.png';
                end
                if troll._state == TROLL_SHED_ENTER then
                    return 'images/shed_barrel_moved_no_box_troll_enter.png';
                end
                return 'images/shed_barrel_moved_no_box.png';
            end
        end
    end,
    dsc = function(s)
        if s._first_time_enter then
            s._first_time_enter = false;
            return 'Пользуясь отсутствием хозяина дома, я быстро проскочил внутрь ветхого строения, и, аккуратно прикрыв дверь, выглянул в небольшое, прорубленное под самым потолком, окошко.^Через несколько секунд во дворе показался тролль, на ходу заряжая арбалет. По-видимому, он был разъярён моим исчезновением, и, побродив немного по двору, уселся на крыльцо, напряжённо вглядываясь в лес.^Я огляделся. Лучи солнца, проникающие сквозь зарешечённое окошко, едва освещали тесную комнатку, бросая длинные тени от немногочисленных предметов.^В углу стояла огромная бочка, на которой лежал тяжёлый на вид ящик. Над дверью висела широкая полка. Всё было покрыто густым слоем пыли; с потолка свисала паутина.';
        else
            return 'Я находился в сарае. Лучи солнца, проникающие сквозь зарешечённое окошко, едва освещали тесную комнатку, бросая длинные тени от немногочисленных предметов. Всё было покрыто густым слоем пыли; с потолка свисала паутина.';
        end
    end,
    way = { vroom ('Выйти', 'Forest_Troll_Village') },
    obj = { 'barrel', 'box', 'hole', 'troll' },
    exit = function (s, to)
        if troll._state == TROLL_SHED_ENTER then
            p 'Тролль мешает выйти...';
            return false;
        end
        if have (barrel) then
            p 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
            return false;
        end
        if not (to == Forest_Troll_Shed_Death) then
            if have (box) then
                p 'Ящик мне не понадобится. Надо оставить его здесь.';
                return false;
            end
        end
        if to == Forest_Troll_Shed_Death then
            lifeoff(Forest_Troll_Shed);
        end
        objs():del(troll);
    end,
};


Forest_Troll_Shed_Death = room {
    nam = 'Сарай',
    pic = function(s)
        if Forest_Troll_Shed._box_is_on_barrel then
            return 'images/shed_initial_troll_firing.png';
        end
        if Forest_Troll_Shed._barrel_is_moved then
            if troll._state == TROLL_SHED_RECOVERED then
                return 'images/shed_barrel_moved_troll_recovered.png';
            end
            if have (box) then
                return 'images/shed_barrel_moved_no_box_troll_firing.png';
            else
                return 'images/shed_barrel_moved_box_dropped_troll_firing.png';
            end
        end
        if troll._state == TROLL_SHED_RECOVERED then
            return 'images/shed_initial_troll_recovered.png';
        end
        if have (box) then
            return 'images/shed_barrel_not_moved_no_box_troll_firing.png';
        else
            return 'images/shed_barrel_not_moved_box_dropped_troll_firing.png';
        end
    end,
    enter = function(s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        if troll._state == TROLL_SHED_RECOVERED then
            return 'Глухо зарычав, тролль вскочил, наводя на меня арбалет. Я попытался увернуться, но в тесноте четырёх стен это было непросто...';
        else
            return '...Тролль вскинул арбалет. Я попытался увернуться, но в тесноте четырёх стен это было непросто...';
        end
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
};


part_2_end_hints_1 = room {
    nam =  'Арка',
    pic = 'images/arc_snake_dead.png',
    _all_items = true,
    enter = function (s)
        me():disable_all();
        s._all_items = true;
        if have (crossbow) then
            if (not (have (arrow))) and (not crossbow._loaded) then
                s._all_items = false;
            end
        else
            s._all_items = false;
        end
        if not have (flint) then
            s._all_items = false;
        end
        if not have (jug) then
            s._all_items = false;
        end
        if not have (rope) then
            s._all_items = false;
        end
        if not have (fruit) then
            s._all_items = false;
        end
    end,
    dsc = function (s)
        if s._all_items then
             return 'У Вас есть все необходимые предметы для дальнейшего прохождения игры. Вы можете переходить на другой уровень.';
        else
             return 'ВНИМАНИЕ!^У Вас отсутствуют некоторые предметы, необходимые для дальнейшего прохождения игры! Если Вы сейчас покинете уровень, Вы не сможете пройти игру до конца!';
        end
    end,
    obj = { vway('1', '{Назад}^', 'Arc'), vway('2', '{Показать список необходимых предметов}^', 'part_2_end_hints_2'), vway('3', '{Перейти на следующий уровень}', 'part_2_end'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_2_end_hints_2 = room {
    nam =  'Арка',
    pic = 'images/arc_snake_dead.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Вы АБСОЛЮТНО уверены, что хотите увидеть перечень предметов, необходимых для дальнейшего прохождения игры?^Отвечайте «Да» только в случае если Вы безнадёжно застряли!';
    end,
    obj = { vway('1', '{Назад}^', 'Arc'), vway('2', '{Показать список необходимых предметов}', 'part_2_end_hints_3'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_2_end_hints_3 = room {
    nam =  'Арка',
    pic = 'images/arc_snake_dead.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Перечень предметов, которые Вам потребуются в дальнейших частях игры:^- арбалет;^- стрела (в случае, если арбалет разряжен);^- кремень;^- кувшин;^- верёвка;^- плод.';
    end,
    obj = { vway('1', '{Назад}', 'Arc') },
    exit = function(s)
        me():enable_all();
    end,
};



part_2_end = room {
    nam =  'Арка',
    pic = 'images/arc_snake_dead.png',
    dsc = 'Я прошёл мимо убитой змеи и вошёл в пещеру...',
    obj = { vway('1', '{Далее}', 'i301') },
    enter = function(s)
        me():disable_all();
    end,
};
