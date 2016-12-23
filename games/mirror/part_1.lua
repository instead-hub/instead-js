i101 = room {
    nam = 'Предисловие',
    pic = 'images/movie_101.gif',
    enter = function(s)
        set_music('music/movie.ogg');
    end,
    dsc = 'Тёмное дождливое утро встретило неподвижное войско людей посреди широкого поля...',
    way = { vroom ('Назад', 'main2'),
            vroom ('Далее', 'i102') }
};


i102 = room {
    nam = 'Предисловие',
    pic = 'images/movie_102.gif',
    dsc = 'Людям предстояла решающая битва с жестоким и грозным противником.',
    way = { vroom ('Назад', 'i101'),
            vroom ('Далее', 'i103') }
};


i103 = room {
    nam = 'Предисловие',
    pic = 'images/movie_103.gif',
    dsc = 'Орды орков и гоблинов во главе с Рыцарем Тьмы и его Чёрным Магом напали на страну.',
    way = { vroom ('Назад', 'i102'),
            vroom ('Далее', 'i104') }
};


i104 = room {
    nam = 'Предисловие',
    pic = 'images/movie_104.gif',
    dsc = '— Вперёд, мои верные слуги! Я хочу, чтобы был мёртв каждый, кто осмелился восстать против меня!',
    way = { vroom ('Назад', 'i103'),
            vroom ('Далее', 'i105') }
};


i105 = room {
    nam = 'Предисловие',
    pic = 'images/movie_105.png',
    dsc = 'И разгорелась кровавая битва.',
    way = { vroom ('Назад', 'i104'),
            vroom ('Далее', 'i106') }
};


i106 = room {
    nam = 'Предисловие',
    pic = 'images/movie_106.gif',
    dsc = 'Много часов продолжалось это жестокое побоище.',
    way = { vroom ('Назад', 'i105'),
            vroom ('Далее', 'i107') }
};


i107 = room {
    nam = 'Предисловие',
    pic = 'images/movie_107.gif',
    dsc = 'Все силы были брошены в борьбу.',
    way = { vroom ('Назад', 'i106'),
            vroom ('Далее', 'i108') }
};


i108 = room {
    nam = 'Предисловие',
    pic = 'images/movie_108.png',
    dsc = 'Но слишком немногочисленно было войско людей. Близка была победа тёмных сил...',
    way = { vroom ('Назад', 'i107'),
            vroom ('Далее', 'i109') }
};


i109 = room {
    nam = 'Предисловие',
    pic = 'images/movie_109.gif',
    dsc = 'И тогда люди решили прибегнуть к последнему средству — Волшебному Зеркалу. Ценой энергии многих воинов из Зеркала был вызван Демон Войны.',
    way = { vroom ('Назад', 'i108'),
            vroom ('Далее', 'i110') }
};


i110 = room {
    nam = 'Предисловие',
    pic = 'images/movie_110.gif',
    dsc = 'Как смерч Демон пронёсся над полем битвы, сокрушая воинов зла. Был повержен и Рыцарь Тьмы.',
    way = { vroom ('Назад', 'i109'),
            vroom ('Далее', 'i111') }
};


i111 = room {
    nam = 'Предисловие',
    pic = 'images/movie_111.gif',
    dsc = 'И вот последние враги уничтожены. Много доблестных воинов полегло в этом бою. Они пали, сохранив мир и свободу живым.',
    way = { vroom ('Назад', 'i110'),
            vroom ('Далее', 'i112') }
};


i112 = room {
    nam = 'Предисловие',
    pic = 'images/movie_112.png',
    dsc = 'Но Чёрному Магу удалось бежать с поля битвы.^^Прошло два столетия, и Маг вернулся. Назвав себя Чёрным Властелином, он собрал огромные полчища гоблинов и орков. Тёмные силы быстро захватили страну, и люди не смогли противостоять им...',
    way = { vroom ('Назад', 'i111'),
            vroom ('Далее', 'Cell_entry') }
};


-- ----------------------------------------------------------------------

door = iobj {
    nam = 'дверь',
    dsc = function(s)
        return 'В темноте видна решётчатая {дверь}.';
    end,
    exam = function(s)
        if (chain._chain_on) then
            return 'Цепь не позволяла мне добраться даже до середины камеры, и в полумраке я видел только общие контуры.';
        else
            if Cell._cell_locked then
                lock:enable();
            end
            return 'Крепкая решётчатая дверь с массивным замком.';
        end
    end,
    obj = { 'lock' },
};


lock = iobj {
    nam = 'замок',
    dsc = function(s)
        if Cell._cell_locked then
            return 'Дверь заперта на железный {замок}.';
        else
            return '{Замок} открыт.';
        end
    end,
    exam = 'Массивный железный замок. Ржавый, но крепкий...',
    used = function (s, w)
        if w == rod and Cell._cell_locked then
            if have (rod) then
                Cell._cell_locked = false;
                Drop(rod);
                rod:disable();
                lifeon(guardian);
                return 'Вставленный в замочную скважину прут зацепил скрытый механизм. Внутри что-то щёлкнуло, и дверь открылась.';
            else
                return 'У меня нет прута.';
            end
        end
    end,
}:disable();


plate = iobj {
    nam = 'тарелка',
    _weight = 6,
    dsc = function(s)
        return 'На полу стоит {тарелка}.';
    end,
    exam = function (s)
        return 'Грубая глиняная тарелка, наполненная каким-то жиром с неприятным запахом.';
    end,
    take = function(s)
        return 'Я взял тарелку.';
    end,
    drop = function(s)
        if chain._chain_on then
            p 'Она мне ещё пригодится.';
            return false;
        else
            plate:disable();
            shard:enable();
            return 'Ударившись о каменный пол, тарелка разлетелась на осколки.';
        end
    end,
    useit = function (s)
        if have (plate) then
            return 'Содержимое тарелки выглядело настолько отвратительно, что я не отважился его попробовать.';
        else
            return 'У меня нет тарелки.';
        end
    end,
};


shard = iobj {
    nam = 'осколок',
    _weight = 2,
    dsc = function(s)
        return 'На полу лежит {осколок}.';
    end,
    exam = function (s)
        return 'Острый осколок от глиняной тарелки.';
    end,
    take = function(s)
        return 'Я взял осколок.';
    end,
    drop = function(s)
        return 'Я бросил осколок на пол.';
    end,
    useit = function (s)
        return 'Острый.';
    end,
}:disable();


window = iobj {
    nam = 'окно',
    dsc = function(s)
        return 'Из маленького {окна} льётся призрачный свет.';
    end,
    exam = function(s)
        if (chain._chain_on) then
             return 'Цепь не позволяла мне добраться даже до середины камеры, и в полумраке я видел только общие контуры.';
        else
             if Cell._rod_attached then
                 rod:enable();
                 return 'Просто небольшое отверстие в стене, забранное тонкими железными прутьями, один из которых сильно расшатался.';
             else
                 return 'Просто небольшое отверстие в стене, забранное тонкими железными прутьями. Одного прута не хватает.';
             end
        end
    end,
    obj = { 'rod' },
};


rod = iobj {
    nam = 'прут',
    _weight = 20,
    dsc = function(s)
        if Cell._rod_attached then
            return 'Один из {прутьев} в оконной решётке шатается.';
        else
            return '{Прут} лежит на полу.';
        end
    end,
    exam = 'Тонкий железный прут.',
    take = function(s)
        if Cell._rod_attached then
            p 'Прут шатается, но вырвать его не получается.';
            return false;
        else
            p 'Я взял прут.';
            return;
        end
    end,
    drop = function(s)
        return 'Я бросил прут на пол.';
    end,
    used = function (s, w)
        if w == shard then
            if have (shard) then
                Cell._rod_attached = false;
                Drop(shard);
                shard:disable();
                return 'Осколком я расшатал камень, удерживающий прут, и за секунду до того, как глина рассыпалась в моих руках, прут упал на пол.';
            else
                return 'У меня нет осколка.';
            end
        end
    end,
}: disable();


chain = iobj {
    nam = 'цепь',
    _weight = 43,
    _chain_on = true,
    _chain_attached = true,
    dsc = function(s)
        if chain._chain_on then
            return 'Я прикован {цепью} к стене.';
        elseif chain._chain_attached then
            return '{Цепь} лежит на полу, одним концом она прикована к стене.';
        else
            if here() == Dark_Room then
                if Dark_Room._chain_on_hook then
                    return 'На балке висит {цепь}. Её конец зацеплен за крюк.';
                end
                if Dark_Room._chain_on_beam then
                    return 'На балке висит {цепь}.';
                end
            end
            return 'Я вижу {цепь}.';
        end
    end,
    exam = 'Длинная ржавая цепь с кандалами и тяжёлым железным ядром.',
    take = function(s)
        if s._chain_attached then
            p 'Это невозможно — цепь прикована к стене.';
            return false;
        else
            if here() == Dark_Room then
                if Dark_Room._chain_on_lid_opened then
                    Dark_Room._chain_on_beam = false;
                    Dark_Room._chain_on_hook = false;
                    Dark_Room._chain_on_lid_opened = false;
                    Dark_Room._chain_off_lid_opened = true;
                    return 'Я снял цепь с балки.';
                end
                if Dark_Room._chain_on_beam then
                    Dark_Room._chain_on_beam = false;
                    Dark_Room._chain_on_hook = false;
                    return 'Я снял цепь с балки.';
                end
                if Dark_Room._chain_on_hook then
                    Dark_Room._chain_on_beam = false;
                    Dark_Room._chain_on_hook = false;
                    return 'Я снял цепь с балки.';
                end
                return 'Я взял цепь.';
            end
            return 'Я взял цепь.';
        end
    end,
    drop = function(s)
        return 'Я бросил цепь.';
    end,
    useit = function(s)
        if here() == Dark_Room then
            if Dark_Room._chain_on_lid_opened then
                return 'Я уже открыл лаз.';
            end
            if Dark_Room._chain_on_hook then
                Dark_Room._chain_on_lid_opened = true;
                ways(Dark_Room):add(vroom ('Лаз', 'Tunnel'));
                return 'Буквально повиснув на цепи, я привёл в действие свой нехитрый механизм. Камень поддался, и на его месте открылся тёмный лаз.';
            end
        end
        return 'Я попытался порвать цепь. Безрезультатно.';
    end,
    used = function (s, w)
        if w == plate then
            if have (plate) then
                if s._chain_on then
                    s._chain_on = false;
                    return 'Превознемогая отвращение, я зачерпнул немного жира из тарелки и смазал им кисти рук. Плохо подогнанные кандалы с лёгкостью соскользнули на пол.';
                else
                    return 'Я уже освободился от цепи. Незачем лишний раз пачкать руки.';
                end
            else
                return 'У меня нет тарелки.';
            end
        end
        if w == rod and s._chain_attached then
            if have (rod) then
                s._chain_attached = false;
                return 'Я отогнул скобы, крепившие цепь к стене.';
            else
                return 'У меня нет прута.';
            end
        end
    end,
};


GOING = 0;
ENTER = 1;
BEAT  = 2;
DEAD  = 3;

guardian = iobj {
    nam = 'гоблин',
    _weight = 101,
    dsc = function(s)
        local st={
                  'В двери стоит {гоблин}.',
                  '{Гоблин} зол.',
                  '{Гоблин} лежит на полу.'
                 }
        return st[s._state];
    end,
    exam = 'Мерзкий грязный гоблин в старой кольчуге и рогатом шлеме.',
    life = function(s)
        if not s._state then
            s._state = GOING
            return
        end
        if s._state == GOING then
            put('guardian');
            s._state = ENTER; -- стражник зашёл
            p 'Не успел я что-либо предпринять, как передо мной возник здоровенный гоблин, грозно обнажая оружие.';
            return true;
        end
        if s._state == ENTER then
            s._state = BEAT; -- стражник бъёт
            p 'Не дожидаясь нападения с моей стороны, гоблин взмахнул мечом...';
            return true;
        end
        lifeoff(s);
        me():disable_all();
        p 'Удар был быстрый и сильный. В глазах потемнело...';
        walk (The_End);
        return;
    end,
    take = function(s)
    end,
    talk = function(s)
        if guardian._state == DEAD then
            return 'Бесполезно. Гоблин в бессознательном состоянии.';
        else
            return 'Гоблин только зарычал в ответ...';
        end
    end,
    used = function(s, w)
        if w == chain then
            if have (chain) then
                if (s._state ~= DEAD) then
                    s._state = DEAD; -- стражник в ауте
                    lifeoff(s);
                    return 'Размахнувшись, я со всей силы ударил гоблина цепью по рогатому шлему. Явно не ожидавший такого поворота событий, охранник без сознания повалился на пол.';
                else
                    return 'Незачем бить гоблина цепью ещё раз. Он больше мне не помешает.';
                end
            else
                return 'У меня нет цепи.';
            end
        end
    end
};


guardians = iobj {
    nam = 'гоблины',
    life = function(s)
        if not s._state then
            s._state = GOING
            p 'Вдруг снизу донёсся топот ног, лязг оружия и грязная ругань охранников. На лестнице заиграли отблески факелов.';
            return false;
        end
        if s._state == GOING then
            walk (Entryway_Death);
            return;
        end
    end,
};


Cell_entry = room {
    nam =  '???',
    dsc = [[...Холодные каменные стены. Пронизывающий ветер жёг тело...^
             ...Яркий свет факела, поднесённого прямо к лицу, ослепил меня. Откуда-то издалека до меня донеслись обрывки речи. Кричали, видимо требуя чего-то... Я никак не мог поймать нить событий, и это сбивало с толку.^
             ...Двое гоблинов схватили меня под руки и потащили по длинным холодным коридорам...]];
    enter = function(s)
        set_music('music/part_1.ogg');
    end,
    obj = { vway('1', '{Далее}', 'Cell') },
    exit = function (s, t)
        me().obj:add(status);
        actions_init();
        lifeon(status);
        status._fatigue_death_string = 'Долгие скитания по мрачным коридорам замка отняли у меня последние силы.^Потеряв сознание, я упал на холодный пол.';
    end,
};


Cell = room {
    nam =  'Камера',
    _cell_locked = true,
    _rod_attached = true,
    _add_health_rest = 52,
    _del_health = 2,
    pic = function(s)
        if s._cell_locked then
             return 'images/cell_locked.png';
        else
             if guardian._state == GOING then
                 return 'images/cell_opened.png';
             end
             if guardian._state == ENTER then
                 return 'images/guard_enter.png';
             end
             if guardian._state == BEAT then
                 return 'images/guard_beat.png';
             end
             if guardian._state == DEAD then
                 return 'images/guard_dead.png';
             end
        end
    end,
    dsc = function (s)
        if s._cell_locked then
            return [[Голоса и шаги медленно стихали, растворяясь в полной темноте.^
                     Я открыл глаза. Благодарение небесам — это был лишь сон. Но жуткая реальность казалась продолжением ночных кошмаров.^
                     Я лежал, прикованный цепью к неровной каменной стене. Сырая камера тонула в ночном полумраке. Призрачный свет, льющийся в маленькое окошко, выхватывал из мрака тёмный силуэт двери.^
                     Разминая затёкшие руки, я отодвинул стоящую рядом тарелку и попытался вспомнить, как я здесь оказался. Странно, но прошлое было для меня загадкой.]];
        else
            return 'Я вошёл в камеру. Холодный полумрак напомнил мне о том неприятном времени, которое я провёл здесь в оковах.';
        end
    end,
    rest = function(s)
        if s._cell_locked then
            return 'Кое-как устроившись на холодном полу, я провёл несколько часов в тревожном полусне.';
        else
            p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
            walk (Guardians_Death);
            return;
        end
    end,
    rested = 'Мне больше не хотелось валяться на этом грязном и холодном полу.',
    obj = { 'door', 'plate', 'window', 'chain', 'shard' },
    way = { vroom('Дверь', 'Entryway') },
    exit = function (s, to)
        if to == The_End then
           return;
        end
        if s._cell_locked then
            p 'Дверь заперта.';
            return false;
        end
        if guardian._state ~= DEAD then
            return false;
        end
    end,
};


flint = iobj {
    nam = 'кремень',
    _weight = 2,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Кремень} лежит на плите ';
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
        return 'Я вижу {кремень}.';
    end,
    exam = 'Небольшой кремень.',
    take = function(s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        if have (barrel) then
            p 'Тяжёлая бочка сковывала движения — я ничего не мог сделать.';
            return false;
        end
        chest._flint_inside = false;
        return 'Я взял кремень.';
    end,
    drop = function(s)
        if here() == Dark_Room and not Dark_Room._light_on then
            p 'Если я брошу кремень здесь, то в темноте я не смогу его найти.';
            return false;
        end
        return 'Я бросил кремень.';
    end,
}:disable();


chest = iobj {
    nam = 'сундук',
    _weight = 101,
    _flint_inside = true;
    dsc = function(s)
        return 'В углу стоял окованный железом полуоткрытый {сундук}.';
    end,
    exam = function(s)
       if s._flint_inside then
           flint:enable();
           return 'Старый оббитый железом ящик с полусгнившими досками. Внутри, как и везде в этом замке, было полно мусора, среди которого я заметил почти целый кремень.';
       else
           return 'Старый оббитый железом ящик с полусгнившими досками. Внутри, как и везде в этом замке, было полно мусора.';
       end
    end,
    take = function(s)
    end,
    useit = function(s)
        if (guardians._state ~= DEAD) then
            guardians._state = DEAD; -- стражники в ауте
            lifeoff(guardians);
            Entryway._guardians_alert = false;
            walk (Guardians_quarrel);
            return;
        else
            return 'Больше нет необходимости прятаться — опасность уже миновала.';
        end
    end,
    obj = { 'flint' }
};


Entryway = room {
    _guardians_alert = true,
    _del_health = 2,
    nam = 'Лестничная площадка',
    pic = 'images/entryway.png',
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    dsc = function(s)
        if s._guardians_alert then
            return 'За решётчатой дверью оказалась лестничная площадка, вверх и вниз от которой вела винтовая лестница.';
        else
            return 'Лестничная площадка. Извиваясь, ступени ведут вверх и вниз. Чёрная дыра — вход в камеру.';
        end
    end,
    enter = function(s)
        if s._guardians_alert then
            lifeon(guardians);
        end
    end,
    obj = { 'chest' },
    way = { vroom ('Вниз', 'Prison_Bottom'), 'Cell', vroom ('Вверх', 'Prison_Top') },
    exit = function(s, to)
        if to == Entryway_Death then
            lifeoff(guardians);
            return;
        end
        if s._guardians_alert then
            return false;  -- охранники бегут. убежать нельзя.
        end
    end,
};


Guardians_quarrel = room {
    nam =  'Лестничная площадка',
    pic = 'images/guardians_quarrel.png',
--    _add_progress = 3,
    dsc = [[Не теряя ни секунды, я бросился к старому ящику и, открыв крышку, спрятался в нём. И вовремя...^
             На лестничную площадку выбежали заспанные гоблины, размахивая оружием и факелами. По-видимому, мой побег застал их врасплох, и они заметались из стороны в сторону, не зная что предпринять.^
             — Жалкое отродье!!! Мерзкие твари!!! Вам в болотах пиявок собирать, а не служить Чёрному Властелину! — разлетался по каменным коридорам визгливый голос командира.^
             — Ну, мы... Мы ведь... Понимаете...^
             — Да вы знаете что он с вами за это сделает! Гнить вам в подземельях Трёхглавого Замка! Позволили сбежать негодяю за три часа до прибытия самого Чёрного Властелина! Немедленно перекрыть все входы и выходы!^
             Перепуганные гоблины помчались исполнять приказ командира.^
             Когда эхо тяжёлого топота охранников затихло в отдалении, я осторожно выбрался из ящика.]],
    enter = function(s)
        status._progress = status._progress + 3; -- поскольку disable_all вырубает status
        me():disable_all();
    end,
--    way = { vroom ('Далее', 'Entryway') },
    obj = { vway('1', '{Далее}', 'Entryway') },
    exit = function(s)
        me():enable_all();
    end,
};


Entryway_Death = room {
    nam = 'Лестничная площадка',
    pic = 'images/entryway_guardians.png',
    dsc = 'Я немного замешкался на лестнице и столкнулся с бегущими вверх гоблинами. Их злобный вид не обещал ничего хорошего.',
    enter = function(s)
        me():disable_all();
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
};



observe_area = iobj {
    nam = 'площадка',
    dsc = function(s)
        return 'Я стоял на просторной смотровой {площадке}.';
    end,
    exam = function(s)
        if Prison_Top._torch_present then
            torch:enable();
            return 'По-видимому, здесь уже давно никого не было: пол устлан слоем мусора и грязи, в углах чернели кучи принесённых ветром листьев. Около лестницы одиноко валялся старый факел...';
        else
            return 'По-видимому, здесь уже давно никого не было: пол устлан слоем мусора и грязи, в углах чернели кучи принесённых ветром листьев.';
        end
    end,
    obj = { 'torch' },
};


Prison_Top = room {
    nam = 'Смотровая площадка',
    _del_health = 2,
    _add_progress = 5,
    _torch_present = true,
    pic = 'images/prison_top.png',
    dsc = [[Опасаясь появления гоблинов, я осторожно поднялся вверх по винтовой лестнице, которая привела меня на просторную смотровую площадку.^
             Я остановился, поражённый открывшимся видом. Передо мной на многие сотни миль раскинулась мрачная страна, опоясанная цепью далёких гор. На фоне тёмных туч грозно возвышался Трёхглавый Замок.^
             Странно, но мой взор постоянно возвращался к Замку. Он притягивал к себе, внушая непонятный страх. В памяти возник его образ, но тут же растаял, и я никак не мог вспомнить, когда видел эту чёрную крепость.]],
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    obj = { 'observe_area' },
    way = { vroom ('Вниз', 'Entryway') },
};


door_out = iobj {
    nam = 'дверь',
    dsc = function(s)
        return 'Я вижу большую деревянную {дверь}.';
    end,
    exam = function(s)
       return 'Окованная железом крепкая дубовая дверь. По-видимому, она вела к выходу из замка.';
    end,
    useit = function(s)
        p 'За дверью оказался длинный коридор, в конце которого виднелся выход из замка.^Но путь мне преградил отряд гоблинов, и лишь сейчас я вспомнил разговор, подслушанный мной на лестничной площадке.';
        walk (Guardians_Death);
        return;
    end,
    used = function(s, w)
        if w == chain then
            p 'Удар железным ядром цепи вызвал гулкое эхо в глубине коридора.^Но тут же передо мной появились гоблины-охранники, и я пожалел о содеянном...';
            walk (Guardians_Enter);
            return;
        end
    end
};



Prison_Bottom = room {
    nam = 'Коридор',
    _del_health = 2,
    pic = 'images/prison_bottom.png',
    dsc = 'Слабый свет нескольких факелов едва разгонял мрак коридора, бросая дрожащие тени на полуприкрытую дверь и уходящие вверх ступени лестницы.',
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    obj = { 'door_out' },
    way = { vroom ('Дверь', 'The_End'), vroom ('Вверх', 'Entryway'), vroom ('Тёмный ход', 'Dark_Room') },
    exit = function(s, to)
        if to == The_End then
            p 'За дверью оказался длинный коридор, в конце которого виднелся выход из замка.^Но путь мне преградил отряд гоблинов, и лишь сейчас я вспомнил разговор, подслушанный мной на лестничной площадке.';
            walk (Guardians_Enter);
            return;
        end
    end,
};


torch = iobj {
    nam = 'факел',
    _weight = 10,
    dsc = function(s)
        if here() == Dark_Room then
            return 'Старый {факел} висит на стене.';
        else
            return 'Около лестницы одиноко валялся старый {факел}.';
        end
    end,
    exam = 'Старый факел.',
    take = function(s)
        Prison_Top._torch_present = false;
        if here() == Dark_Room then
            if seen (flint) then
                p 'Если я оставлю кремень здесь, потом, в темноте я не смогу его найти.';
                return false;
            end
            if Dark_Room._chain_on_lid_opened or Dark_Room._chain_off_lid_opened then
                ways(Dark_Room):del('Лаз');
            end
            beam:disable();
            hook:disable();
            Dark_Room._light_on = false;
            ways(Prison_Bottom):del('Ход');
            ways(Prison_Bottom):add(vroom ('Тёмный ход', 'Dark_Room'));
            return 'Сняв факел со стены, я потушил его. Комната погрузилась во тьму.';
        else
            return 'Я взял факел.';
        end
    end,
    drop = function(s)
        if here() == Dark_Room and not Dark_Room._light_on then
            p 'Если я брошу здесь факел, я его потом не смогу найти.';
            return false;
        else
            p 'Я бросил факел на пол.';
            return;
        end
    end,
    used = function (s, w)
        if w == flint and have (flint) and have (torch) then
            if here() == Dark_Room then
                if Dark_Room._chain_on_lid_opened or Dark_Room._chain_off_lid_opened then
                    ways(Dark_Room):add(vroom ('Лаз', 'Tunnel'));
                end
                Dark_Room._light_on = true;
                ways(Prison_Bottom):del('Тёмный ход');
                ways(Prison_Bottom):add(vroom ('Ход', 'Dark_Room'));
                Drop (torch);
                objs():del(torch);
                beam:enable();
                hook:enable();
                p 'Ударив кремнем о неровный камень стены, я зажёг факел и укрепил его возле двери.^Комнатой давно никто не пользовался: поросшие мхом камни, свисающие с потолка паутина и сырой пол красноречиво свидетельствовали об этом.';
                walk (here());
                return;
            else
                p 'Здесь это не нужно.';
                return false;
            end
        end
    end,
}:disable();


Dark_Room = room {
    nam = 'Комната',
    _del_health = 2,
    _light_on = false,
    _chain_on_beam = false,
    _chain_on_hook = false,
    _chain_on_lid_opened = false,
    _chain_off_lid_opened = false;
    pic = function(s)
        if not s._light_on then
             return 'images/dark_room_dark.png';
        else
             if s._chain_off_lid_opened then
                 return 'images/dark_room_empty_opened.png';
             end
             if s._chain_on_lid_opened then
                 return 'images/dark_room_chain_on_lid_opened.png';
             end
             if s._chain_on_hook then
                 return 'images/dark_room_chain_on_hook.png';
             end
             if s._chain_on_beam then
                 return 'images/dark_room_chain_on_beam.png';
             end
             return 'images/dark_room_empty_closed.png';
        end
    end,
    enter = function (s)
        lifeon (s);
    end,
    dsc = function(s)
        if not s._light_on then
             return 'Пройдя несколько шагов, я очутился в полной темноте. Всё, что можно было различить — только узкую полоску слабого света, пробивавшегося из коридора.';
        else
            if Dark_Room._chain_on_lid_opened then
                return 'Пройдя несколько шагов, я снова оказался в заброшенной комнате, ярко освещённой светом факела. В углу чернел открытый лаз.';
            else
                return 'Пройдя несколько шагов, я снова оказался в заброшенной комнате, ярко освещённой светом факела.';
            end
        end
    end,
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    obj = { 'beam', 'hook' },
    way = { vroom ('Коридор', 'Prison_Bottom') },
    life = function (s)
        if objs():look(chain) then
            if s._light_on then
                chain:enable();
            else
                chain:disable();
            end
        end
    end,
    exit = function (s)
        lifeoff (s);
    end,
};


beam = iobj {
    nam = 'балка',
    dsc = function(s)
        if Dark_Room._light_on then
            return ' Комната была практически пуста — однообразие голых стен нарушали лишь {балка} в углу';
        end
    end,
    exam = 'Грубо отёсанное бревно, вбитое в стену.',
    used = function (s, w)
        if w == chain then
            if Dark_Room._chain_off_lid_opened then
                return 'Нет смысла делать это повторно. Я уже открыл лаз.';
            end
            if not Dark_Room._chain_on_beam then
                Dark_Room._chain_on_beam = true;
                Drop (chain);
                return 'Как следует размахнувшись, я перекинул цепь через деревянную балку.';
            else
                return 'Цепь уже висит на балке.';
            end
        end
    end,
}:disable();


hook = iobj {
    nam = 'крюк',
    dsc = function(s)
        if Dark_Room._light_on then
            return ' и железный {крюк}, вбитый в пол.';
        end
    end,
    exam = 'Ржавый железный крюк торчит из пола.',
    take = function(s)
        p 'Ухватившись обеими руками за крюк я попытался вырвать его из пола, но у меня ничего не получилось — я лишь немного приподнял камень, в который крюк был вбит.';
        return false;
    end,
    used = function (s, w)
        if w == chain then
            if Dark_Room._chain_off_lid_opened then
                return 'Нет смысла делать это повторно. Я уже открыл лаз.';
            end
            if Dark_Room._chain_on_hook then
                return 'Я уже зацепил цепь за крюк.';
            end
            if Dark_Room._chain_on_beam then
                Dark_Room._chain_on_hook = true;
                return 'Я зацепил за крюк конец свисающей с балки цепи.';
            else
                return 'При помощи цепи я попытался вытащить камень с крюком из пола, но он был слишком тяжёл, и мои усилия пропали даром.';
            end
        end
    end,
}:disable();


Tunnel = room {
    nam = 'Туннель',
    pic = 'images/tunnel.png',
    _del_health = 2,
    enter = function (s, from)
        if from == Dark_Room then
            status._health = status._health - 10;
            return 'Я несколько необдуманно бросился в тёмный лаз, так как лететь пришлось довольно долго. При падении я больно ушиб локоть, но в остальном всё было нормально.^Передо мной в темноту уходил узкий коридор, завешанный сетями паутины. Его стены кое-где обвалились, и на полу виднелись груды битых камней. По-видимому, коридором уже давно не пользовались.';
        else
            return 'Я вернулся к началу подземного хода. Позади меня в темноту уходил узкий коридор, завешанный сетями паутины. Его стены кое-где обвалились, и на полу виднелись груды битых камней.';
        end
    end,
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    way = { vroom ('Туннель', 'Tunnel_End') },
};


Tunnel_End = room {
    nam = 'Туннель',
    _del_health = 2,
    pic = 'images/tunnel_end.png',
    dsc = 'Небольшая комнатка в конце подземного коридора. Полуразрушенные стены и сети паутины резко очерчены слабым светом, пробивающимся сквозь полузасыпанный выход.',
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    way = { vroom ('Туннель', 'Tunnel'), vroom ('Вверх', 'Tunnel_Out') },
};


Tunnel_Out = room {
    nam = 'Выход из туннеля',
    pic = 'images/tunnel_out.png',
    _del_health = 2,
    _add_progress = 2,
    dsc = 'Выбравшись из мрачного коридора, я остановился, наслаждаясь порывами свежего ветра.^Туннель выходил на берег быстрой горной реки. С шумом разбивая свои волны об огромные валуны, она, извиваясь, исчезала в тёмном лесу. Позади виднелся замок, освещённый кровавым рассветом.',
    way = { vroom ('Вниз', 'Tunnel_End'), vroom ('Река', 'part_1_end') },
    rest = function(s)
        p '...Наверное не стоило терять бдительность в этом полном опасностей месте, но усталость взяла верх, обезоружив меня перед опасным противником...';
        walk (Guardians_Death);
        return;
    end,
    exit = function(s, to)
        if to == The_End then
           return
        end
        if status._health == 0 then
            ACTION_TEXT = nil;
            return
        end
        if to == part_1_end then
            if have (chain) then
                p 'Желая поскорее покинуть это мрачное и небезопасное место, я бросился в бурную реку. Тяжёлая цепь сковывала мои движения, тянула на дно. У меня не было сил бороться со стремительным потоком...';
                walk (The_End);
                return;
            end
            if status._exit_hints then
                walk (part_1_end_hints_1);
                return;
            end
        return
        end
    end,
};


part_1_end_hints_1 = room {
    nam = 'Выход из туннеля',
    pic = 'images/tunnel_out.png',
    _all_items = true,
    enter = function (s)
        me():disable_all();
        s._all_items = true;
        if not have (flint) then
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
    obj = { vway('1', '{Назад}^', 'Tunnel_Out'), vway('2', '{Показать список необходимых предметов}^', 'part_1_end_hints_2'), vway('3', '{Перейти на следующий уровень}', 'part_1_end'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_1_end_hints_2 = room {
    nam = 'Выход из туннеля',
    pic = 'images/tunnel_out.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Вы АБСОЛЮТНО уверены, что хотите увидеть перечень предметов, необходимых для дальнейшего прохождения игры?^Отвечайте «Да» только в случае если Вы безнадёжно застряли!';
    end,
    obj = { vway('1', '{Назад}^', 'Tunnel_Out'), vway('2', '{Показать список необходимых предметов}', 'part_1_end_hints_3'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_1_end_hints_3 = room {
    nam = 'Выход из туннеля',
    pic = 'images/tunnel_out.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Перечень предметов, которые Вам потребуются в дальнейших частях игры:^- кремень.';
    end,
    obj = { vway('1', '{Назад}', 'Tunnel_Out') },
    exit = function(s)
        me():enable_all();
    end,
};



Guardians_Death = room {
    nam =  '???',
    pic = 'images/guardians_black.png',
    enter = function (s)
        me():disable_all();
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
};


Guardians_Enter = room {
    nam =  'Коридор',
    pic = 'images/guardians_enter.png',
    enter = function (s)
        me():disable_all();
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
};


The_End = room {
    nam = 'Вы проиграли',
    pic = 'images/death.gif',
    enter = function (s)
       set_music('music/game_over.ogg');
       me():disable_all();
    end,
    exit = function (s)
       me():enable_all();
    end,
};


part_1_end = room {
    nam =  'Выход из туннеля',
    pic = 'images/tunnel_out.png',
    dsc = 'Желая поскорее покинуть это мрачное и небезопасное место, я бросился в бурную реку, отдавая свою судьбу в руки провидения...',
    obj = { vway('1', '{Далее}', 'i201') },
    enter = function(s)
        me():disable_all();
    end,
};
