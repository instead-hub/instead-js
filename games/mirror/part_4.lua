i401 = room {
    nam = '...',
    pic = 'images/movie_41.gif',
    dsc = '...Долго летели Хранитель и Орёл к Трёхглавому Замку. Тревожен был их путь...';
    enter = function(s)
        set_music('music/part_4.ogg');
        status._drink_water_on_this_level = false;
        status._fatigue_death_string = 'Долгие скитания по мрачным коридорам Замка отняли у меня последние силы. Теряя сознание, я упал на холодный пол...';
    end,
    way = { vroom ('Назад', 'part_3_end'), vroom ('Далее', 'i402') },
};


i402 = room {
    nam = '...',
    pic = 'images/movie_42.gif',
    dsc = '...Но вот перед ними открылись смотровые площадки высоких башен...';
    way = { vroom ('Назад', 'i401'), vroom ('Далее', 'castle_401') },
    exit = function (s, to)
        if to == castle_401 then
            Drop (fish1);
            Drop (fish2);
--            status._health = 1000;
--            me().obj:add(status);
--            actions_init();
--            lifeon(status);
--            put('flint', i402);
--            flint:enable();
--            Take(flint);
--            put('crossbow', i402);
--            crossbow:enable();
--            Take(crossbow);
--            put('jug', i402);
--            jug._dirty = false;
--            Take(jug);
--            put('sword', i402);
--            sword:enable();
--            Take(sword);
--            put('mushroom', i402);
--            mushroom:enable();
--            Take(mushroom);
        end
    end,
};


castle_401 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Площадка',
    _just_arrive = true,
    pic = 'images/castle_401.png',
    enter = function (s, from)
        if from == i402 then
            me():enable_all();
        end
    end,
    dsc = function(s)
        if s._just_arrive then
            s._just_arrive = false;
            return 'Сделав большой круг над крайней башней, орёл плавно опустился на смотровую площадку.^^— Я выполнил твою просьбу. Теперь я возвращаюсь в Лабиринт.^^И с этими словами птица поднялась в небо и вскоре исчезла вдалеке.^^Я осмотрелся. Просторная площадка была окружена высокими каменными зубьями. На камне лежал глубокий отпечаток времени, широкие трещины поросли мхом. На площадке собралось много мусора, принесённого ветром.';
        else
            return 'Просторная площадка была окружена высокими каменными зубьями. На камне лежал глубокий отпечаток времени, широкие трещины поросли мхом. На площадке собралось много мусора, принесённого ветром.';
        end
    end,
    rest = 'Я присел на каменный пол и немного отдохнул.',
--    way = { vroom ('Далее', 'labyrinth_21') },
    obj = { 'ledge' },
--    exit = function (s, to)
--    end,
};


ledge = iobj {
    nam = 'уступ',
    _ready = false;
    dsc = function (s)
        return 'Я вижу {уступ}.';
    end,
    exam = function (s)
        return 'У одного из зубьев в самом низу выступало несколько камней, образуя небольшой уступ.';
    end,
    used = function (s, w)
        if w == crossbow and here() == castle_401 then
            if not have (crossbow) then
                return 'У меня нет арбалета.';
            else
--               if s._cutted then
                Drop (crossbow);
                s._ready = true;
                return 'Я зацепил прочное оружие за камни и перекинул рукояткой наружу.';
            end
        end
    end,
};


castle_401_end = room {
    nam = 'Площадка',
    pic = 'images/castle_401.png',
    enter = function (s, from)
        objs(castle_401):del(crossbow);
        objs(castle_402):add(crossbow);
        me():disable_all();
    end,
    dsc = function(s)
        return 'Перегнувшись через край площадки, я повис на рукоятке арбалета, а затем спрыгнул на следующий этаж.';
    end,
    obj = { vway('1', '{Далее}', 'castle_402') },
    exit = function (s, from)
        me():enable_all();
    end,
};


castle_402 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Комната под площадкой',
    pic = 'images/castle_402.png',
    dsc = function(s)
        return 'Эта комната являлась продолжением смотровой площадки. Крыша и широкие зубья, уходившие наверх, были слабой защитой от ветра, но всё-таки здесь было не так холодно, как наверху.';
    end,
    way = { vroom ('Вниз', 'castle_403') },
    rest = 'Я немного отдохнул, прогоняя усталость из утомлённого тела.',
};


castle_403 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Внутри башни',
    pic = 'images/castle_403.png',
    dsc = function(s)
        return 'Высокая круглая башня внутри была пустая. Вдоль стены шла винтовая лестница, сверху заканчивающаяся площадкой перед выходом из башни. С потолка, гулко звеня от сквозняков, свисали длинные ржавые цепи.';
    end,
    way = { vroom ('Вверх', 'castle_402'), vroom ('Вниз', 'castle_404'), vroom ('Выход', 'castle_406')},
--    obj = { 'ledge' },
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
--    exit = function (s, to)
--    end,
};


castle_404 = room {
    _add_health_rest = 2,
    _del_health = 3,
--    _assailant = true,
    nam = 'Нижняя часть башни',
    pic = function (s)
        if seen (assailant) then
            return 'images/castle_404_assailant.png';
        else
            return 'images/castle_404.png';
        end
    end,
    enter = function (s, from)
        if (s == castle_404) and (from == castle_403) and (seen (assailant, s)) then
            lifeon (assailant);
        end
    end,
    dsc = function(s)
        return 'Нижняя часть башни утопала в холодном полумраке, создаваемом тусклыми факелами на стенах. На длинных цепях, тянувшихся с самого потолка башни, висело большое колесо старой люстры. Посреди комнаты находился колодец, окружённый каменной кладкой.';
    end,
    way = { vroom ('Дверь', 'castle_405'), vroom ('Вверх', 'castle_403') },
    obj = { 'assailant' },
    rest = function (s)
        if seen (assailant) then
            walk (castle_404_death);
            return;
        else
            return 'Я постарался расслабиться и прогнать все чёрные мысли.';
        end
    end,
    exit = function (s, to)
        if seen (assailant) then
            walk (castle_404_death);
            return;
        end
    end,
};


assailant = iobj {
    nam = 'нападающий',
    _attack = false,
    dsc = function(s)
--        return 'На меня надвигается закутанный в плащ {человек}, быстро вращая в руках необычной формы короткие мечи.';
        return 'Но вдруг из темноты лестницы появился закутанный в плащ {человек}, и, быстро вращая в руках необычной формы короткие мечи, двинулся ко мне.';
--        local st={
--                  'На меня надвигается закутанный в плащ {человек}, быстро вращая в руках необычной формы короткие мечи.',
--                  '{Гоблин} зол.',
--                  '{Гоблин} лежит на полу.'
--                 }
--        return st[s._state];
    end,
    exam = 'Закутанный в плащ человек с короткими мечами необычной формы.',
    life = function(s)
        if not s._attack then
            s._attack = true;
            return true;
        end
        lifeoff(s);
        me():disable_all();
--        ACTION_TEXT = nil;
        walk (castle_404_death);
        return;
    end,
    talk = function(s)
        return 'Бесполезно...';
    end,
    used = function(s, w)
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                lifeoff (s);
                objs(castle_404):del(assailant);
                return 'Я отбил атаку незнакомца, и, сделав резкий выпад, насквозь пронзил его мечом. С тихим стоном неизвестный осел на пол и рассыпался в пыль.';
            end
        end
    end
};


castle_404_death = room {
    nam = 'Нижняя часть башни',
    pic = function (s)
        return 'images/castle_404_assailant.png';
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        return 'Подбежав ко мне, нападающий взмахнул мечами. Последнее, что я увидел — холодный блеск кривых лезвий у меня перед глазами...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};



castle_405 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Склеп',
    pic = 'images/castle_405a.png',
    dsc = function(s)
        return 'Комната оказалась склепом: два огромных каменных саркофага с бронзовыми крышками стояли вдоль стен. Между ними расположилась старая надгробная плита. Но то, что находилось за плитой, было самым жутким. Протягивая руку к вошедшим, как бы приглашая войти в свой мир, стояла статуя Смерти. Мрачность обстановки дополняли неприятно потрескивающие светильники.';
    end,
    way = { vroom ('Дверь', 'castle_404') },
    obj = { 'castle_405_inscription', 'death_statue', 'sarcophagus' },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};


castle_405_inscription = iobj {
    nam = 'надпись',
--    _ready = false;
    dsc = function (s)
        return 'Я вижу {надпись} на старой надгробной плите.';
    end,
    exam = function (s)
        walk (castle_405_inscription_room);
        return;
    end,
    useit = function (s, w)
        walk (castle_405_inscription_room);
        return;
    end,
};


castle_405_inscription_room = room {
    nam = 'Надпись на старой надгробной плите',
    pic = 'images/castle_405b.png',
    enter = function (s, from)
        me():disable_all();
    end,
    dsc = function(s)
        return 'На плите была надпись на неизвестном мне языке. Нижняя часть плиты была отбита.';
    end,
    obj = { vway('1', '{Далее}', 'castle_405') },
    exit = function (s, from)
        me():enable_all();
    end
};


sarcophagus = iobj {
    nam = 'саркофаг',
    _weight = 101,
    _examined_final = false,
--    _ready = false;
    dsc = function (s)
        return 'Около стены стоит огромный {саркофаг}.';
    end,
    exam = function (s)
        if sarcophagus_lid._dropped then
--            return 'Большой каменный саркофаг.';
            if s._examined_final then
                return 'В саркофаге лежало существо, облачённое в латы, с полным боевым снаряжением. Но это не был человек, не был гоблин или тролль. Необычной формы голова, многосуставные конечности указывали на принадлежность к иной расе. Время сильно изменило тело, испортило доспехи.';
            else
                shield:enable();
                rope_4:enable();
                s._examined_final = true;
                return 'В саркофаге лежало существо, облачённое в латы, с полным боевым снаряжением. Но это не был человек, не был гоблин или тролль. Необычной формы голова, многосуставные конечности указывали на принадлежность к иной расе. Время сильно изменило тело, испортило доспехи; сохранился только щит, на котором можно было различить древний герб, да моток верёвки.';
            end
        else
            sarcophagus_lid:enable();
            return 'Большой каменный саркофаг, закрытый плотно прилегающей тяжёлой крышкой.';
        end
    end,
    take = function (s)
    end,
    useit = function (s, w)
        walk (castle_405_inscription_room);
        return;
    end,
    obj = { 'sarcophagus_lid', 'shield', 'rope_4' },
};


sarcophagus_lid = iobj {
    nam = 'крышка',
    _weight = 98,
    _moved = false,
    _dropped = false,
--    _ready = false;
    dsc = function (s)
        if s._dropped then
            return 'Рядом с саркофагом лежит тяжёлая бронзовая {крышка}.';
        else
            return 'Саркофаг закрыт тяжёлой бронзовой {крышкой}.';
        end
    end,
    exam = function (s)
        return 'Тяжёлая бронзовая плита.';
    end,
    take = function (s)
        if status._cargo > 2 then
            p 'Слишком тяжело!';
            return false;
        else
            if s._moved then
                p 'Я уже подвинул крышку.';
                return false;
            else
                s._moved = true;
                p 'Собрав все силы, я приподнял тяжёлую крышку и немного сдвинул её в сторону, но на большее у меня не хватило сил.';
                return false;
            end
        end
    end,
    useit = function (s, w)
        if not s._moved then
            return 'Я попытался столкнуть крышку, но тяжёлая плита даже не шелохнулась.';
        else
            if s._dropped then
                return 'Я уже подвинул крышку.';
            else
                if status._cargo > 2 then
                    return 'Не получается.';
                else
                    s._dropped = true;
                    status._progress = status._progress + 3;
                    return 'Действуя изо всех сил, я столкнул крышку на пол. Она упала, разнося гулкое эхо по башне.';
                end
            end
        end
    end,
}:disable();


death_statue = iobj {
    nam = 'статуя',
--    _ready = false;
    _talked = false,
    dsc = function (s)
        return '{Статуя Смерти} протягивает руку к вошедшим.';
    end,
    exam = function (s)
        return 'Облачённый в доспехи человеческий скелет протягивал руку к входящему в комнату, держа в другой руке короткий меч. Изображение было сделано так искусно, что в первый момент я принял статую за реальное существо.';
    end,
    talk = function (s)
        if not s._talked then
            s._talked = true;
            status._progress = status._progress + 5;
        end
        walk (death_statue_dlg_1);
        return;
    end,
};


death_statue_dlg_1 = dlg{
    nam = 'Склеп',
    pic = function(s)
        return 'images/castle_405a.png';
    end,
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = 'Впечатление реальности было настолько велико, что я даже попытался заговорить со статуей. И каково же было моё удивление, когда изображение Смерти ответило мне скрипучим голосом:^— Ты первый человек, который попал в эту комнату с тех пор, как в замке поселилось зло. Я лишь стерегу покой мёртвых, но слуги зла мешают мне. Возьми здесь всё, что тебе нужно, и останови их.',
    obj = {
            [1] = phr('Скажи, кто лежит в этих саркофагах?', 'Я не знаю. Меня создали уже после того, как лежащие здесь были мертвы. Но это было очень давно. Эти саркофаги стояли в скале далеко отсюда, и дабы не тревожить покой павших, древние создали меня. Затем, через много лет был построен этот Трёхглавый Замок, и саркофаги вместе со мной перенесли сюда.', [[pon(1);]]),
            [2] = phr('Не знаешь ли ты, как найти мне Чёрного Властелина?', 'Я знаю от гоблинов, заходивших сюда, что Чёрный Властелин чаще всего проводит своё время в Тронной Зале.', [[pon(2);]]),
            [3] = phr('Есть ли какой-нибудь секрет у этого Замка?', 'Древние не зря построили этот Замок. Он содержит великую силу, которую нельзя отдавать злу. Даже я не знаю обо всём, но если ты встретишь пылающий цветок, не бойся его.', [[pon(3)]]),
            [4] = phr('Закончить диалог.', nil, [[pon(4); walk (castle_405); return;]]),
          },
    exit = function (s, t)
--        boulder._talked = true;
        me():enable_all();
    end,
};


shield = iobj {
    nam = 'щит',
    _weight = 23,
    _on_what = false,
--    _ready = false;
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Щит} лежит на плите ';
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
        return 'Я вижу {щит}.';
    end,
    exam = function (s)
        return 'Лёгкий круглый щит, на котором с трудом можно было различить древний герб.';
    end,
    take = function (s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        return 'Я взял щит.';
    end,
    drop = function (s)
        return 'Я бросил щит.';
    end,
}:disable();


rope_4 = iobj {
    nam = 'верёвка',
    _weight = 9,
--    _ready = false;
    dsc = function (s)
        if castle_413._rope then
            return 'К кольям привязана тонкая {верёвка}.';
        end
        return 'Я вижу {верёвку}.';
    end,
    exam = function (s)
        return 'Длинная верёвка из странного материала, тонкая, но необычайно прочная.';
    end,
    take = function (s)
        if castle_413._rope then
            p 'Верёвка привязана к кольям.';
            return false;
        end
        return 'Я взял верёвку.';
    end,
    drop = function (s)
        return 'Я бросил верёвку.';
    end,
    used = function (s, w)
        if w == hook_4 then
            Drop (rope_4);
            Drop (hook_4);
            objs():del(rope_4);
            objs():del(hook_4);
            objs():add(rope_hook);
            return 'Я привязал верёвку к крюку.';
        end
    end,
}:disable();


funicular_413 = iobj {
    nam = 'верёвка',
    dsc = function (s)
        return 'Между башнями висит тонкая {верёвка}.';
    end,
    exam = function (s)
        return 'Длинная верёвка из странного материала, тонкая, но необычайно прочная.';
    end,
--    take = function (s)
--        return 'Я взял верёвку.';
--    end,
--    drop = function (s)
--        return 'Я бросил верёвку.';
--    end,
    useit = function (s, w)
        walk (castle_420);
        return;
    end,
};


castle_406 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Мост',
    pic = 'images/castle_406.png',
    enter = function (s, from)
        if from == i402 then
            me():enable_all();
        end
    end,
    dsc = function(s)
        return 'Пройдя в дверь, я вышел на мост, который перекинулся между башнями над бездонной пропастью. Тяжёлые красные тучи нависли прямо над Замком. Холодный ветер гудел под арками.';
    end,
    way = { vroom ('Башня', 'castle_403'), vroom ('Центральная башня', 'castle_410') },
    rest = 'Я немного отдохнул, прогоняя усталость из утомлённого тела.',
};


castle_410 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Центральная башня',
    pic = function (s)
        if seen (monster) then
            if seen (monster_ball) then
                return 'images/castle_410b.png';
            else
                return 'images/castle_410c.png';
            end
        else
            return 'images/castle_410.png';
        end
    end,
    enter = function (s, from)
        if (s == castle_410) and (from == castle_406) and (seen (monster, s)) then
            lifeon (monster);
        end
    end,
    dsc = function(s)
--        return 'По периметру круглой башни шёл широкий карниз, от которого вниз бежала лестница. С противоположных концов карниза на мосты между башнями вели одинаковые двери. Снизу лился яркий свет факела.
--        Тут я заметил, что вдоль карниза ко мне движется странное существо. Оно словно возникало из воздуха и плавно плыло над полом.
--        Вдруг, широко расставив лапы, оно выпустило огненный шар, который полетел в моём направлении.';
        return 'По периметру круглой башни шёл широкий карниз, от которого вниз бежала лестница. С противоположных концов карниза на мосты между башнями вели одинаковые двери. Снизу лился яркий свет факела.';
    end,
    way = { vroom ('Налево', 'castle_406'), vroom ('Вверх', 'castle_412'), vroom ('Вниз', 'castle_414'), vroom ('Направо', 'castle_411') },
    obj = { 'monster' },
    rest = 'Я присел на каменный пол и немного отдохнул.',
    exit = function (s)
        if seen (monster) then
            walk (castle_410_death_run);
            return;
        end
    end,
};


monster = iobj {
    nam = 'чудовище',
    _attack = true,
    _wait = false,
    dsc = function(s)
        return 'Тут я заметил, что вдоль карниза ко мне движется странное {существо}. Оно словно возникало из воздуха и плавно плыло над полом.';
    end,
    exam = 'Странное существо.',
    life = function(s)
        if s._wait then
            s._attack = true;
            s._wait = false;
            return true;
--            return 'W-A';
        end
        if s._attack then
            if seen (monster_ball) then
                lifeoff(s);
                me():disable_all();
--                return 'DEATH';
                walk (castle_410_death);
                return;
            else
                objs(castle_410):add(monster_ball);
--                return 'A';
                return true;
            end
        end
    end,
    talk = function(s)
        return 'Бесполезно...';
    end,
    used = function(s, w)
        if w == sword and not seen (monster_ball) then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                lifeoff(s);
                objs(castle_410):del(monster);
                Drop (sword);
                return 'Не дожидаясь следующего нападения, я изо всех сил метнул меч в чудовище. Лезвие глубоко вошло в тело монстра, существо испустило предсмертный вопль и растаяло в воздухе.';
            end
            return true;
        end
        return true;
    end
};


monster_ball = iobj {
    nam = 'шар',
--    _ready = false;
    dsc = function (s)
        return 'Вдруг, широко расставив лапы, оно выпустило огненный {шар}, который полетел в моём направлении.';
    end,
    exam = function (s)
        return true;
    end,
    used = function (s, w)
        if w == shield then
            if not have (shield) then
                return 'У меня нет щита.';
            else
                monster._attack = false;
                monster._wait = true;
                objs(castle_410):del(monster_ball);
                return 'Подняв щит, я отразил шар, от мощного удара которого я еле устоял на ногах.';
            end
        end
        return true;
    end,
};


castle_410_death = room {
    nam = 'Нижняя часть башни',
    pic = function (s)
        return 'images/castle_410b.png';
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        return 'Огненный шар налетел на меня, облачая в пламя. Огонь разорвал моё тело, уничтожил сознание...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};


castle_410_death_run = room {
    nam = 'Нижняя часть башни',
    pic = function (s)
        return 'images/castle_410b.png';
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        return 'Я попытался убежать, но чудовище выпустило мне в след огненный шар. Шар налетел на меня, облачая в пламя. Огонь разорвал моё тело, уничтожил сознание...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};



castle_411 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Мост между башнями',
    pic = function (s)
        return 'images/castle_411.png';
    end,
    dsc = function(s)
        return 'Этот мост между башнями был полностью разрушен; от противоположной двери меня отделяла бездонная пропасть.';
    end,
    way = { vroom ('Центральная башня', 'castle_410'), },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};


castle_412 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Помещение над башней',
    pic = function (s)
        return 'images/castle_412.png';
    end,
    dsc = function(s)
        return 'Пол смотровой площадки и продолжения окружающих её зубьев образовывали небольшое открытое помещение над башней. Наверх вёл люк, а в полу начиналась лестница, ведущая вниз.';
    end,
    way = { vroom ('Вверх', 'castle_413'), vroom ('Вниз', 'castle_410') },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};



castle_413 = room {
    _add_health_rest = 2,
    _del_health = 3,
    _rope = false,
--    _funicular = false,
    nam = 'Смотровая площадка',
    pic = function (s)
        if seen (funicular_413) then
            return 'images/castle_413c.png';
        end
        if s._rope then
            return 'images/castle_413b.png';
        end
        return 'images/castle_413.png';
    end,
    enter = function (s, from)
        if from == castle_420 then
            return 'Крепко взявшись за верёвку, я оторвался от смотровой площадки. Порывы ветра раскачивали верёвку, затрудняя движения. Основание высокого Замка терялось далеко внизу, разрушенный мост разделял башни.^Но вот, наконец, я достиг цели своего воздушного путешествия.';
        end
    end,
    dsc = function(s)
        return 'Со смотровой площадки центральной башни открывался обширный вид на всю страну, но сейчас он был почти полностью скрыт туманом. Грозные тучи нависли над Замком. В воздухе чувствовалась какая-то скрытая тревога.^Отсюда были видны соседние башни, а со стороны одной из них старый материал зубьев площади раскрошился, и из них торчали металлические колья.';
    end,
    obj = { 'tower' },
    way = { vroom ('Вниз', 'castle_412') },
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    exit = function (s, to)
        if to == castle_412 and crossbow._charged then
            crossbow._charged = false;
            return 'Разрядив арбалет, я спустился вниз.';
        end
    end,
};


tower = iobj {
    nam = 'башня',
--    _ready = false;
    dsc = function (s)
        return 'Отсюда были видны соседние {башни}, ';
    end,
    exam = function (s)
        return 'Я вижу соседнюю башню Замка.';
    end,
    obj = { 'stakes' },
    used = function (s, w)
        if w == crossbow and crossbow._charged then
            if not castle_413._rope then
                return 'Если я выстрелю, верёвка с крюком улетит, и я не смогу достать её.';
            else
                crossbow._charged = false;
                objs(castle_413):add(funicular_413);
                objs(castle_413):del(rope_hook);
                return 'Описав в воздухе широкую дугу, крюк с резким звоном ударился о камни далёкой башни, и, скользнув по площадке, прочно зацепился за каменные зубья.';
            end
        end
    end,
};


stakes = iobj {
    nam = 'колья',
    _examined = false;
    dsc = function (s)
        return 'а со стороны одной из них старый материал зубьев площади раскрошился, и из них торчали металлические {колья}.';
    end,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            objs (castle_413):add(shank);
            return 'Я осмотрел металлические колья. Один из них я мог бы выдернуть.';
        else
            return 'Я осмотрел металлические колья, но ничего интересного не обнаружил.';
        end
    end,
    used = function (s, w)
        if w == rope_4 or w == rope_hook then
            if not castle_413._rope then
                castle_413._rope = true;
                Drop (rope_4);
                Drop (rope_hook);
                return 'Я привязал верёвку к торчащим из камня кольям.';
            else
                return 'Я уже привязал верёвку к кольям.';
            end
        end
    end,
};


shank = iobj {
    nam = 'стержень',
    _weight = 5,
    dsc = function (s)
        return 'Я вижу {стержень}.';
    end,
    exam = function (s)
        return 'Короткий железный прут.';
    end,
    take = function (s)
        return 'Я взял стержень.';
    end,
    drop = function (s)
        return 'Я бросил стержень.';
    end,
};


hook_4 = iobj {
    nam = 'крюк',
    _weight = 5,
    dsc = function (s)
        return 'Я вижу {крюк}.';
    end,
    exam = function (s)
        return 'Небольшой крюк.';
    end,
    used = function (s, w)
        if w == rope_4 then
            Drop (rope_4);
            Drop (hook_4);
            objs():del(rope_4);
            objs():del(hook_4);
            objs():add(rope_hook);
            return 'Я привязал верёвку к крюку.';
        end
    end,
    take = function (s)
        return 'Я взял крюк.';
    end,
    drop = function (s)
        return 'Я бросил крюк.';
    end,
};


rope_hook = iobj {
    nam = 'верёвка+крюк',
    _weight = 14,
    dsc = function (s)
        if castle_413._rope then
            p 'К кольям привязана {верёвка с крюком}.';
            return false;
        end
        return 'Я вижу {верёвку с привязанным к ней крюком}.';
    end,
    exam = function (s)
        return 'Длинная тонкая верёвка, прочно привязанная к железному крюку.';
    end,
    take = function (s)
        if castle_413._rope then
            p 'Верёвка привязана к кольям.';
            return false;
        end
        return 'Я взял верёвку с крюком.';
    end,
    drop = function (s)
        return 'Я бросил верёвку с крюком.';
    end,
};



castle_414 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Комната',
    pic = function (s)
        if castle_414_door._closed then
            return 'images/castle_414a.png';
        else
            return 'images/castle_414b.png';
        end
    end,
    dsc = function(s)
        return 'Яркий свет укреплённого в стене факела освещал всю комнату, отражаясь от бронзовых птиц на высоких постаментах.';
    end,
    obj = { 'castle_414_door' },
    way = { vroom ('Вверх', 'castle_410'), vroom ('Дверь', 'castle_415') },
    rest = 'Я немного отдохнул, прогоняя усталость из утомлённого тела.',
    exit = function (s, to)
        if to == The_End then
            return;
        end
        if to == castle_410 then
            return;
        end
        if to == castle_415 and castle_414_door._closed then
            p 'Я всем телом налёг на дверь, но массивные створки даже не дрогнули.';
            return false;
        end
        if not castle_415._knight then
            walk (castle_415);
            return;
        end
        if have (sword) then
            walk (castle_415);
            return;
        else
            walk (castle_415_empty);
            return;
        end
    end,
};


castle_414_door = iobj {
    nam = 'дверь',
    _closed = true;
    dsc = function (s)
        if s._closed then
            return 'Напротив лестницы была большая {дверь}, закрытая массивными каменными створками.';
        else
            return 'Напротив лестницы была большая {дверь} с массивными каменными створками.';
        end
    end,
    exam = function (s)
        return 'Массивная каменная дверь.';
    end,
    useit = function (s)
        if s._closed then
            return 'Я всем телом налёг на дверь, но массивные створки даже не дрогнули.';
        else
            return 'Дверь уже открыта.';
        end
    end,
    used = function (s, w)
        if w == shank then
            if have (shank) then
                Drop (shank);
                objs():del(shank);
                objs():add(hook_4);
                Take (hook_4);
                return 'Стержнем я попытался открыть запертые двери, но металл не выдержал, согнулся, и в моих руках оказался железный крюк.';
            else
                return 'У меня нет стержня.';
            end
        end
    end,
};


castle_415 = room {
    _add_health_rest = 2,
    _del_health = 3,
    _knight = true,
    nam = 'Тронный зал',
    pic = function (s)
        if seen (knight) then
            return 'images/castle_415_knight.png';
        else
            return 'images/castle_415_final.png';
        end
    end,
    enter = function (s, from)
--        if here() == castle_415 then
--        return '415';
--        end
        if here() == castle_415 and (seen (knight, s)) then
            lifeon (knight);
        end
    end,
    dsc = function(s)
        if seen (knight) then
            return 'Яркий луч света, проникавший в залу через дверь, выхватывал из тьмы высокий каменный трон и бронзовых рыцарей, охранявшего его. Зала была совершенно пуста.';
        else
            return 'Яркий луч света, проникавший в залу через дверь, выхватывал из тьмы высокий каменный трон и бронзового рыцаря, охранявшего его. Зала была совершенно пуста.';
        end
    end,
    way = { vroom ('Дверь', 'castle_414') },
    obj = { 'knight' },
    rest = function (s)
        if seen (knight) then
            walk (castle_415_death);
            return;
        else
            return 'Я присел на каменный пол и немного отдохнул.';
        end
    end,
    exit = function (s, to)
        if to == The_End then
            return;
        end
        if to == knight_dlg then
            return true;
        end
        if seen (knight) then
            walk (castle_415_death);
            return;
        end
    end,
};


castle_415_death = room {
    nam = 'Тронный зал',
    pic = function (s)
        return 'images/castle_415_knight.png';
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function (s)
        return '...и тяжёлое оружие в железной руке обрушилось на меня...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};


castle_415_death_2 = room {
    nam = 'Тронный зал',
    pic = function (s)
        return 'images/castle_415_knight.png';
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function (s)
        return '— Нет пощады тому, кто посмел ворваться в Тронный Зал!^...и тяжёлое оружие в железной руке обрушилось на меня...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};


castle_415_knight_end_1 = room {
    nam = 'Тронный зал',
    pic = function (s)
        return 'images/castle_415_knight.png';
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function (s)
        return 'Рыцарь остановился:^— Я должен убить его! — как будто разговаривая с кем-то, произнесли доспехи. — Но... но ведь противник сдался, и по законам чести я должен оставить его в живых!^Наступила долгая пауза. Казалось, рыцарь обдумывает положение.^И, наконец, он произнёс:^— Я пощажу его!';
    end,
    obj = { vway('1', '{Далее}', 'castle_415_knight_end_2') },
};


castle_415_knight_end_2 = room {
    nam = 'Тронный зал',
    pic = function (s)
        return 'images/castle_415_final.png';
    end,
    dsc = function (s)
        return 'И с этими словами рыцарь растаял в воздухе.';
    end,
    obj = { vway('1', '{Далее}', 'castle_415') },
    exit = function (s, to)
        castle_415._knight = false;
        objs(castle_415):del(knight);
        ways(castle_415):add(vroom ('Потайной ход', 'castle_416'));
        me():enable_all();
    end,
};


knight = iobj {
    nam = 'рыцарь',
    _attack = false,
    _ready_to_talk = false,
    dsc = function (s)
        if not s._ready_to_talk then
            return 'Вдруг {один из рыцарей} пришёл в движение и с молниеносной быстротой оказался около меня. Со словами:^— Умри же, с оружием сюда пришедший! — он занёс меч над моей головой..';
        else
            return 'В ответ на слова {рыцаря} я бросил меч к его ногам. Бронзовые латы на мгновение застыли, как будто в замешательстве, но затем меч поднялся ещё уверенее.';
        end
    end,
    exam = function (s)
        return 'Рыцарь.';
    end,
    useit = function (s, w)
        walk (castle_413);
        return;
    end,
    life = function (s)
        if not s._attack then
            s._attack = true;
            return true;
        end
        lifeoff(s);
        me():disable_all();
--        ACTION_TEXT = nil;
        walk (castle_415_death);
        return;
    end,
    talk = function (s)
        if not s._ready_to_talk then
            return true;
        else
            lifeoff (s);
--            return 'A';
            walk (knight_dlg);
            return;
        end
    end,
};


knight_dlg = dlg{
    nam = 'Тронный зал',
    pic = function(s)
        return 'images/castle_415_knight.png';
    end,
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = 'Воспользовавшись замешательством рыцаря, я успел крикнуть ему:';
    obj = {
            [1] = phr('Я же безоружный. Как ты можешь убить меня?!', nil, [[poff(1,2,3); walk (castle_415_death_2); return;]]),
            [2] = phr('Пощади меня! Оставь мне жизнь!', nil, [[poff(1,2,3); walk (castle_415_death_2); return;]]),
            [3] = phr('Я отдаюсь на твою волю, Стражник!', nil, [[poff(1,2,3); lifeoff (knight); walk (castle_415_knight_end_1); return;]]),
          },
    exit = function (s, t)
        me():enable_all();
    end,
};


castle_415_empty = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Тронный зал',
    pic = function (s)
        return 'images/castle_415_empty.png';
    end,
    dsc = function(s)
        return 'Яркий луч света, проникавший в залу через дверь, выхватывал из тьмы высокий каменный трон и двух бронзовых рыцарей, охранявших его. Зала была совершенно пуста.';
    end,
    way = { vroom ('Дверь', 'castle_414') },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};



castle_416 = room {
    _add_health_rest = 2,
    _del_health = 3,
    _knight = true,
    nam = 'Маленькая комната',
    pic = function (s)
        return 'images/castle_416.png';
    end,
    dsc = function(s)
        return 'Я попал в маленькую комнату, посреди которой на небольшом возвышении находилось нечто странное, похожее одновременно на огонь и на диковинный цветок. Оно находилось в движении, изменяя свои формы, и заливало комнатку удивительным светом.';
    end,
    way = { vroom ('Ход', 'castle_415') },
    obj = { 'fire_416' },
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
};


fire_416 = iobj {
    nam = 'пламя',
    dsc = function (s)
        return 'Я вижу {пламя}.';
    end,
    exam = function (s)
        return 'Холодное белое пламя не усиливалось и не ослабевало, распространяя вокруг себя неяркое ровное свечение.';
    end,
    useit = function (s, w)
        walk (castle_417);
        return;
    end,
};


castle_417 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Узкая пещера',
    pic = function (s)
        return 'images/castle_417.png';
    end,
    dsc = function(s)
        return 'Я находился в узкой пещере, стены которой были покрыты мхом и паутиной. На неровных камнях играли блики от похожего на цветок холодного пламени. В темноту уходил низкий ход.';
    end,
    way = { vroom ('Тоннель', 'castle_418') },
    rest = 'Я немного отдохнул, прогоняя усталость из утомлённого тела.',
};



castle_418 = room {
    _add_health_rest = 2,
    _del_health = 3,
    _just_arrive = true,
    nam = 'Тоннель',
    pic = function (s)
        return 'images/castle_418.png';
    end,
    enter = function (s, from)
        if from == castle_417 and s._just_arrive then
            status._health = 103;
        end
    end,
    dsc = function(s)
        if s._just_arrive then
            s._just_arrive = false;
            return 'Слабое чувство начало проникать в моё сознание. Сначала я не понял, что это и что оно несёт с собой. Но ощущение становилось всё сильнее и сильнее, пока не заполнило всего меня.^Мощные потоки энергии охватили меня, я полностью ощутил близость Священного Огня.^И вместе с чувством силы пришло осознание себя цельной личностью, я был един со своим прошлым. Память полностью вернулась ко мне.^Я чувствовал энергию, исходившую от Священного источника так сильно, что она казалась мне почти материальной. Ко мне вернулась вся сила Хранителя Волшебного Зеркала, мудрость всех поколений Хранителей.^Я был готов встретиться лицом к лицу с сильным противником.';
        else
            return 'Долго тянулась тёмная пещера, пока, наконец, не показался мерцающий красный свет. Он проникал сквозь сети паутины, создавая причудливые тени.';
        end
    end,
    way = { vroom ('Тоннель', 'castle_417'), vroom ('На свет', 'castle_419') },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};


castle_419 = room {
    nam = 'Огромная пещера',
    pic = function (s)
        return 'images/castle_419.png';
    end,
    enter = function (s, from)
        status._progress = 100;
        lifeon (dark_mage);
    end,
    dsc = function(s)
--        return 'Следуя на свет, я вышел в огромную пещеру, потолок и дальние стены которой утопали во мраке. В центре пылал Священный Огонь, испуская волны живительной силы.^И вместе с потоками энергии я ощутил то, что сопутствовало мне всю жизнь и память о чём вернулась только что. Я чувствовал неразрывную связь между Хранителем и Зеркалом, я был уверен, что оно здесь.^И тут мой взгляд упал на Чёрного Властелина. Маг стоял в стороне, напряжённо глядя в мою сторону. Рядом с ним стояло Зеркало. По-видимому, опасаясь Демона Войны, он пришёл сюда получить новые силы и скрыть от меня Зеркало. Предстояла последняя решающая битва.';
        return 'Следуя на свет, я вышел в огромную пещеру, потолок и дальние стены которой утопали во мраке. В центре пылал Священный Огонь, испуская волны живительной силы.^И вместе с потоками энергии я ощутил то, что сопутствовало мне всю жизнь и память о чём вернулась только что. Я чувствовал неразрывную связь между Хранителем и Зеркалом, я был уверен, что оно здесь.';
    end,
    obj = { 'dark_mage', 'mirror' },
    rest = function (s)
        walk (castle_419_bad_end);
        return;
    end,
};


dark_mage = iobj {
    nam = 'чёрный маг',
    _attack = false;
    dsc = function (s)
        return 'И тут мой взгляд упал на {Чёрного Властелина}. Маг стоял в стороне, напряжённо глядя в мою сторону.';
    end,
    life = function(s)
        if not s._attack then
            s._attack = true;
            return true;
        end
        lifeoff (s);
        me():disable_all();
        walk (castle_419_bad_end);
        return;
    end,
};


mirror = iobj {
    nam = 'зеркало',
    dsc = function (s)
        return 'Рядом с ним стояло {Зеркало}. По-видимому, опасаясь Демона Войны, он пришёл сюда получить новые силы и скрыть от меня Зеркало. Предстояла последняя решающая битва.';
    end,
    useit = function (s)
        lifeoff (dark_mage);
        walk (final_01);
        return;
    end,
};



castle_419_bad_end = room {
    nam = 'Огромная пещера',
    pic = function (s)
        return 'images/castle_419_bad.png';
    end,
    enter = function (s, from)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        return 'Но вдруг я почувствовал, как поток энергии накрывает чёрная сила. Маг направил действие своих чар на меня, усиливая их Священным Огнём. Зло ворвалось в моё сознание, заполняя и поглощая его. И через некоторое время я был полностью во власти тёмных сил...^...Но почему зло? Истинное зло — то, которое кроется в каждом человеке, а не то, которое люди называют «злом»! Чтобы уничтожить его, необходимо уничтожить его, необходимо уничтожить всех людей. Я властен над Демоном Войны! Я сделаю это!!!';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
--    way = { vroom ('Тоннель', 'castle_417'), vroom ('На свет', 'castle_419') },
};


final_01 = room {
    nam = '...',
    pic = function (s)
        return 'images/castle_419.png';
    end,
    enter = function (s, from)
        set_music('music/final.ogg');
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        return 'Я сконцентрировал всю энергию, полученную от Священного Огня, и обратился к Зеркалу. И тут же из глубины серебряного стекла, из глубины царства теней до меня донёсся боевой клич Демона Войны. Он, как и я, был готов к сражению.^В этот момент я остро ощутил, что ответственен за судьбу всего человечества, что в моих руках мир. И с этим чувством пришла последняя уверенность. Я вызвал Демона...';
    end,
    obj = { vway('1', '{Далее}', 'final_02') },
};


final_02 = room {
    nam = '...',
    pic = function (s)
        return 'images/movie_43.png';
    end,
    dsc = function(s)
--        return '';
        return true;
    end,
    obj = { vway('1', '{Далее}', 'final_03') },
};


final_03 = room {
    nam = '...',
    pic = function (s)
        return 'images/movie_44.png';
    end,
    dsc = function(s)
--        return '';
        return true;
    end,
    obj = { vway('1', '{Далее}', 'final_04') },
};


final_04 = room {
    nam = '...',
    pic = function (s)
        return 'images/movie_45.png';
    end,
    dsc = function(s)
--        return '';
        return true;
    end,
    obj = { vway('1', '{Далее}', 'final_05') },
};


final_05 = room {
    nam = '...',
    pic = function (s)
        return 'images/movie_46.png';
    end,
    dsc = function(s)
--        return '';
        return true;
    end,
    obj = { vway('1', '{Далее}', 'final_06') },
};


final_06 = room {
    nam = '...',
    pic = function (s)
        return 'images/movie_47.png';
    end,
    dsc = function(s)
        return 'Блеснув молнией, Демон исчез с Чёрным Властелином в Священном Огне.';
--        return true;
    end,
    obj = { vway('1', '{Далее}', 'final_07') },
};


final_07 = room {
    nam = '...',
    pic = function (s)
        return 'images/movie_48.gif';
    end,
    dsc = function(s)
        return 'Могущественный маг Тёмных Сил повержен — Хранитель выполнил свою миссию. Гоблины и орки, бывшие под командованием Чёрного Властелина, не смогут сражаться без своего повелителя, и люди быстро восстановят мир.^Но вместе с магом в Священном Огне исчез и Демон Войны. Зеркало утратило волшебную силу. Теперь в борьбе против зла люди должны рассчитывать только на себя.';
--        return true;
    end,
    obj = { vway('1', '{Далее}', 'final_08') },
};


final_08 = room {
    nam = '...',
--    pic = function (s)
--        return 'images/movie_49.png';
--    end,
    dsc = function(s)
--        return 'Авторы оригинальной игры^Творческая группа Art Work, 1998 год^^Сценарий и графика — Степанов В. Ю.^^Коды и музыка — Пасечник И. А.^^Адаптация для INSTEAD — Вадим В. Балашов.^vvb.backup@rambler.ru^^Автор выражает огромную признательность Петру Косых за INSTEAD и неоценимую помощь, оказанную при разработке кода.';
        return 'Авторы оригинальной игры —^Творческая группа Art Work, 1998 год^^Сценарий и графика — Степанов В. Ю.^^Коды и музыка — Пасечник И. А.^^^Адаптация для INSTEAD — Вадим В. Балашов.^vvb.backup@rambler.ru^^Автор выражает огромную признательность Петру Косых за INSTEAD и неоценимую помощь, оказанную при разработке кода.';
    end,
    obj = { vway('1', '{Далее}', 'final_09') },
};


final_09 = room {
    nam = 'КОНЕЦ',
    pic = function (s)
        return 'images/movie_49.png';
    end,
    dsc = function(s)
        return true;
    end,
--    obj = { vway('1', '{Далее}', 'final_07') },
};



castle_420 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Смотровая площадка',
    pic = function (s)
        return 'images/castle_420.png';
    end,
    enter = function (s, from)
        if from == castle_413 then
            return 'Крепко взявшись за верёвку, я оторвался от смотровой площадки. Порывы ветра раскачивали верёвку, затрудняя движения. Основание высокого Замка терялось далеко внизу, разрушенный мост разделял башни.^Но вот, наконец, я достиг цели своего воздушного путешествия.';
        end
    end,
    dsc = function(s)
        return 'Я оказался на смотровой площадке, окружённой высокими каменными зубьями. Низкое небо в зловещих красных тучах казалось крышей этому месту.';
    end,
    obj = { 'funicular_420' },
    way = { vroom ('Вниз', 'castle_421') },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};


funicular_420 = iobj {
    nam = 'верёвка',
    dsc = function (s)
        return 'Между башнями висит тонкая {верёвка}.';
    end,
    exam = function (s)
        return 'Длинная верёвка из странного материала, тонкая, но необычайно прочная.';
    end,
    useit = function (s, w)
        walk (castle_413);
        return;
    end,
};



castle_421 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Комната под смотровой площадкой',
    pic = function (s)
        return 'images/castle_421.png';
    end,
    dsc = function(s)
        return 'Я оказался на смотровой площадке, окружённой высокими каменными зубьями. Низкое небо в зловещих красных тучах казалось крышей этому месту.';
    end,
    way = { vroom ('Вверх', 'castle_420'), vroom ('Вниз', 'castle_422') },
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
};


castle_422 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Внутри башни',
    pic = function (s)
        return 'images/castle_422.png';
    end,
    dsc = function(s)
        return 'Лестница с крыши башни переходила в карниз, а затем вилась вдоль круглой стены. Из башни вела дверь, выделявшаяся светлым пятном в полумраке помещения. С потолка, слабо звеня, свешивались обрывки старых цепей.';
    end,
    way = { vroom ('Вверх', 'castle_421'), vroom ('Выход', 'castle_423'), vroom ('Вниз', 'castle_424') },
    rest = 'Я немного отдохнул, прогоняя усталость из утомлённого тела.',
};


castle_423 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Мост к средней башне',
    pic = function (s)
        return 'images/castle_423.png';
    end,
    dsc = function(s)
        return 'Передо мной открылся длинный мост, ведущий к средней башне. Далеко внизу, у самого основания башен, бежала мелкая горная река.';
    end,
    way = { vroom ('Центральная башня', 'castle_423_end'), vroom ('Башня', 'castle_422') },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};


castle_423_end = room {
    nam = 'Мост к средней башне',
    pic = function (s)
        return 'images/castle_423_end.png';
    end,
    enter = function (s)
        me():disable_all();
    end,
    dsc = function(s)
        return 'Внезапно мост, казавшийся абсолютно целым, исчез, открывая огромную пропасть. На какое-то мгновение я повис над бездной, но затем, не удержавшись, полетел вниз...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
};


castle_424 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Комната со светильниками',
    pic = function (s)
        return 'images/castle_424.png';
    end,
    dsc = function(s)
        return 'Мерцающий свет нескольких светильников выделял на полу комнаты чёткие линии, вырисовывая непонятные знаки. Свет создавал за лестницей густую тень, проникал в узкую дверь.';
    end,
    obj = { 'matrix' },
    way = { vroom ('Вверх', 'castle_422'), vroom ('Дверь', 'castle_425') },
    rest = 'Я присел на каменный пол и немного отдохнул.',
};


matrix = iobj {
    nam = 'пол',
    _plates = false,
    dsc = function (s)
        return 'На {полу} комнаты видны чёткие линии, образующие непонятные знаки.';
    end,
    exam = function (s)
        walk (castle_424_matrix_view);
        return;
    end,
};


castle_424_matrix_view = room {
    nam = 'Двенадцать плит',
    pic = function (s)
        return 'images/castle_424_matrix.png';
    end,
    enter = function (s)
        me():disable_all();
        if not matrix._plates then
            matrix._plates = true;
            objs(castle_424):add(plate_e);
            objs(castle_424):add(plate_k);
            objs(castle_424):add(plate_n);
            objs(castle_424):add(plate_v);
            objs(castle_424):add(plate_z);
            objs(castle_424):add(plate_l);
            objs(castle_424):add(plate_a);
            objs(castle_424):add(plate_r);
            objs(castle_424):add(plate_p);
            objs(castle_424):add(plate_i);
            objs(castle_424):add(plate_t);
            objs(castle_424):add(plate_o);
        end
    end,
    dsc = function(s)
        return 'Я поднялся немного по лестнице и посмотрел сверху на пол. Ровные линии образовывали двенадцать плит, на каждой из которых были изображены непонятные знаки.';
    end,
    exit = function (s)
        me():enable_all();
    end,
    obj = { vway('1', '{Далее}', 'castle_424') },
};


plate_e = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_e.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_e.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_e.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_k = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_k.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_k.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_k.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_n = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_n.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_n.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_n.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_v = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_v.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_v.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_v.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_z = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_z.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_z.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_z.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_l = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_l.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_l.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_l.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_a = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_a.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_a.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_a.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_r = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_r.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_r.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_r.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_p = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_p.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_p.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_p.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_i = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_i.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_i.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_i.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_t = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_t.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_t.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_t.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


plate_o = iobj {
    _occupied = false,
    nam = function(s)
        local v = 'плита '..img ('images/plate_o.png');
        return v;
    end,
    dsc = function (s)
        return true;
    end,
    useit = function (s, w)
        return 'Я наступил на плиту. Она плавно ушла в пол. Но как только я убрал ногу, плита тут же вернулась обратно.';
    end,
    used = function (s, w)
        if s._occupied then
            local v = 'Плита '..img ('images/plate_o.png')..' уже занята.';
            return v;
        end
        if not have (w) then
            return 'Чтобы положить предмет на плиту, надо держать его в руках.';
        else
            ref(w)._on_what = deref(s);
            Drop ( ref(w) );
            s._occupied = true;
            local v = 'Я положил '..nameof(w)..' на плиту '..img ('images/plate_o.png')..'.';
            local r = check_floor ();
            if r then
                return v..r;
            else
                return v;
            end
        end
    end,
};


castle_425 = room {
    _add_health_rest = 2,
    _del_health = 3,
    nam = 'Огромное растение',
    pic = function (s)
        if plant._flower_1 then
            return 'images/castle_425a.png';
        end
        if plant._flower_2 then
            return 'images/castle_425b.png';
        end
        return 'images/castle_425c.png';
    end,
    enter = function (s)
        if plant._flower_2 then
            lifeon (plant);
        end
    end,
    dsc = function(s)
        return 'Большая комната, в которую вела узкая дверь, была совершенно пустой. К дальней стене поднимались широкие ступени.';
    end,
    obj = { 'plant', 'wall' },
--    way = { vroom ('Центральная башня', 'castle_423_end'), vroom ('Башня', 'castle_422') },
    way = { vroom ('Дверь', 'castle_424') },
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной каменной стене.',
};


castle_425_death = room {
    nam = 'Огромное растение',
    pic = function (s)
        if plant._flower_2 then
            return 'images/castle_425a.png';
        else
            return 'images/castle_425b.png';
        end
    end,
    enter = function (s)
        ACTION_TEXT = nil;
        me():disable_all();
    end,
    dsc = function(s)
        return 'Один из стеблей приблизился ко мне. Вдруг, выпустив шипы, он быстрым движением обвил мою шею. Резкая боль пронзила тело...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};



plant = iobj {
    nam = 'растение',
    _flower_1 = true,
    _flower_2 = true,
    _attack = false,
    _empty = false,
    dsc = function (s)
        if s._flower_2 then
            return 'Посреди комнаты, пробив могучим стеблем пол, росло огромное {растение}. Его красивые цветки, раскачиваясь, как живые тянулись ко мне.';
        else
            return 'Посреди комнаты, пробив могучим стеблем пол, росло огромное {растение}. Его красивый цветок, раскачиваясь, как живой тянулся ко мне.';
        end
        return 'Посреди комнаты, пробив могучим стеблем пол, росло огромное {растение}.';
    end,
    exam = function (s)
        if not s._flower_2 then
            return 'Огромное растение с обрубленными стеблями.';
        end
        return 'Огромное растение.';
    end,
    useit = function (s, w)
        if s._flower_1 or s._fower_2 then
            return true;
        else
            if s._empty then
                return 'Я уже выпил весь сок из растения.';
            else
                s._empty = true;
                status._health = status._health + 20;
                return 'Пересиливая отвращение, я отпил немного густой жидкости, сочившейся из разрубленных стеблей. Жидкость оказалась питательной, хотя я не почувствовал никакого вкуса.';
            end
        end
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                if s._flower_1 then
                    s._attack = false;
                    s._flower_1 = false;
                    objs(castle_425):add(flower);
                    return 'Огромные цветки тянулись всё ближе и ближе. Не дожидаясь, когда растение коснётся меня, я взмахнул мечом, и цветок упал на пол.';
                end
                if s._flower_2 then
                    s._attack = false;
                    s._flower_2 = false;
                    lifeoff (plant);
                    return 'Огромные цветки тянулись всё ближе и ближе. Не дожидаясь, когда растение коснётся меня, я взмахнул мечом, и цветок упал на пол.';
                end
            end
        end
    end,
    life = function(s)
        if not s._attack then
            s._attack = true;
            return true;
--            return 'now Attack!';
        end
        lifeoff (s);
        me():disable_all();
--        ACTION_TEXT = nil;
        walk (castle_425_death);
        return;
    end,
};


wall = iobj {
    nam = 'стена',
    _examined = false,
    dsc = function (s)
        if not s._examined then
            return 'На {стене} я заметил что-то интересное.';
        else
            return 'На {стене} были вырезаны три таблицы с письменами: ';
        end
    end,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            table_1:enable();
            table_2:enable();
            table_3:enable();
        end
        return 'На стене были вырезаны три таблицы с письменами.';
    end,
    obj = { 'table_1', 'table_2', 'table_3' },
--    useit = function (s, w)
--    end,
};


flower = iobj {
    nam = 'цветок',
    _weight = 15,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Цветок} лежит на плите ';
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
        return 'Я вижу {цветок}.';
    end,
    exam = function (s)
        return 'Крупный красивый цветок.';
    end,
    take = function (s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        return 'Я взял цветок.';
    end,
    drop = function (s)
        return 'Я бросил цветок.';
    end,
--    useit = function (s, w)
--    end,
};



table_1 = iobj {
    nam = 'таблица 1',
    dsc = function (s)
        return '{первая}, ';
    end,
    exam = function (s)
        walk (castle_425_table_1);
        return;
    end,
}:disable();


table_2 = iobj {
    nam = 'таблица 2',
    dsc = function (s)
        return '{вторая} и';
    end,
    exam = function (s)
        walk (castle_425_table_2);
        return;
    end,
}:disable();


table_3 = iobj {
    nam = 'таблица 3',
    dsc = function (s)
        return '{третья}.';
    end,
    exam = function (s)
        walk (castle_425_table_3);
        return;
    end,
}:disable();


castle_425_table_1 = room {
    nam = 'Надпись на первой таблице',
    pic = 'images/castle_425d.png',
    enter = function (s, from)
        me():disable_all();
    end,
    dsc = function(s)
        return 'На таблице была высечена странная надпись.';
    end,
    obj = { vway('1', '{Далее}', 'castle_425') },
    exit = function (s, from)
        me():enable_all();
    end
};


castle_425_table_2 = room {
    nam = 'Надпись на второй таблице',
    pic = 'images/castle_425e.png',
    enter = function (s, from)
        me():disable_all();
    end,
    dsc = function(s)
        return 'На таблице была высечена странная надпись на незнакомом языке.';
    end,
    obj = { vway('1', '{Далее}', 'castle_425') },
    exit = function (s, from)
        me():enable_all();
    end
};


castle_425_table_3 = room {
    nam = 'Надпись на третьей таблице',
    pic = 'images/castle_425f.png',
    enter = function (s, from)
        me():disable_all();
    end,
    dsc = function(s)
        return 'На таблице была высечена странная надпись.';
    end,
    obj = { vway('1', '{Далее}', 'castle_425') },
    exit = function (s, from)
        me():enable_all();
    end
};


check_floor = function (s)
    if castle_414_door._closed and plate_z._occupied and plate_e._occupied and plate_r._occupied and plate_k._occupied and plate_a._occupied and plate_l._occupied and plate_o._occupied then
        castle_414_door._closed = false;
        local v = ' Как только я положил последний предмет, я услышал гул. Плиты '..img ('images/plate_z.png')..', '..img ('images/plate_e.png')..', '..img ('images/plate_r.png')..', '..img ('images/plate_k.png')..', '..img ('images/plate_a.png')..', '..img ('images/plate_l.png')..' и '..img ('images/plate_o.png')..' вспыхнули красным пламенем и потом погасли.';
        return v;
    end
    return;
end
