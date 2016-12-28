i = room
{
    nam = 'Предисловие',
    hideinv = true,
    pic = 'images/intro.gif',
    way = { vroom ('Назад', 'main'),
            vroom ('ДАЛЕЕ', 'r_111') },
    exit = function (s, to)
        if (to == r_111) then
            me().obj:add(status);
            actions_init();
            lifeon(status);
            put(medallion, i101);
            take (medallion);
            status_change (1, 1, 1, 1, 1);
            set_music ('music/03_walk_on_unknown_planet.ogg');
        end
    end,
};
-- ----------------------------------------------------------------------

r_200 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/200.png',
    dsc = function (s)
        p [[Триста километров, отделявшие остров «О» от мегаполиса Пульсар,
        глайдер переодолел за несколько часов. Я стоял на палубе и смотрел на
        приближающийся берег. Большой портовый город распахнул передо мной
        свои объятия.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_241') },
};


-- ----------------------------------------------------------------------

r_212 = room
{
    nam = 'Старый район',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    _tiseller_img = false,
    _praggs_gone = false,
    north = 'r_222',
    east = 'r_213',
    south = nil,
    west = nil,
    pic = function (s)
        if seen (praggs_leader) or seen (porcupine) then
            return 'images/212_praggs.png';
        else
            return 'images/212.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/22_praggs.ogg');
        if status._clock == NIGHT then
            if status._biomask then
                walk (r_212_biomask_end);
                return;
            else
                if not s._praggs_gone then
                    put (praggs_leader, r_212);
                end
            end
        end
        if from == r_222 or from == r_213 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 3;
            end
        else
            s._just_enter = false;
        end
    end,
    dsc = function (s)
        if status._clock == NIGHT then
            if s._just_enter then
                p [[Ночью находиться в этом районе было небезопасно. Целые
                банды прэгов — местных хулиганствующих анархистов —
                разгуливали по улицам.
                ]];
            else
                p [[Я находился в старом районе. Ночью находиться здесь было
                небезопасно.
                ]];
            end
            return;
        end
        if s._visit == 1 then
            p [[Я находился в старом, грязном районе. Судя по всему, его
            населяли бедняки и отбросы общества. Неудивительно, что я не
            встретил здесь ни одного артанга. Зато иногда мне встречались
            группы прэгов — молодых хулиганов.^Прэги — дети трущоб,
            признавали только анархию. Как правило, они были детьми спившихся
            и опустившихся космических отшельников.
            ]];
        end
        if s._visit == 2 then
            p [[Я снова забрёл в старый район, который населяли отбросы
            общества. Видимо, с незапамятных времён здесь жили заблудившиеся
            космические отшельники, которые обрели покой на этой легендарной
            планете. Что искали они и что нашли?
            ]];
        end
        if s._visit == 3 then
            p [[Я находился на территории старого района города. На севере,
            в центре города возвышались небоскрёбы, на западе бушевало море,
            на востоке я видел постройки аэропорта. С юга, вплотную к району,
            подступали отвесные скалы.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            remove (praggs_leader, r_212);
            remove (porcupine, r_212);
            if seen (praggs_leader) then
                p [[Не обращая внимания на толпу прэгов, я с невозмутимым
                видом прилёг на стоящие в подворотне ящики. Прэги, видимо,
                опешили и не решились ко мне подойти. Я чувствовал сильную
                усталость, поэтому быстро заснул.^Прошло несколько часов...
                ]];
            else
                p 'Прошло несколько часов...';
            end
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-1, -1, -1, 0, 0);
                p 'Прошло несколько часов...';
            end
            return;
        end
    end,
    exit = function (s, to)
        if to == r_222 or to == r_213 then
            if seen (praggs_leader) then
                remove (porcupine, r_212);
                walk (r_212_runaway_1);
            else
                health_finish._from = deref(here());
                clock_next ();
                status_change (-2, -1, -1, 0, 0);
                check_health();
            end
        end
        return;
    end,
};


r_212_runaway_1 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_fist.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
        clock_next ();
        status_change (-13, -7, -7, 0, 0);
        if status._health <= 0 then
            status._health = 1;
        end
        remove (praggs_leader, r_212);
        remove (blaster, inv());
        remove (neurowhip, inv());
    end,
    dsc = function (s)
        p [[Я попытался убежать от банды, но это оказалось не так просто.
        Меня быстро догнали, повалили на землю и избили. На какое-то время я
        потерял сознание.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_212_runaway_2') },
};


r_212_runaway_2 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212.png',
    dsc = function (s)
        p 'Когда я очнулся, рядом уже никого не было.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_212') },
};


praggs_leader = obj
{
    nam = 'главарь прэгов',
    _talked = false,
    dsc = function (s)
        if s._talked then
            p [[Банда прэгов окружила меня. {Главарь прэгов} сжимал в руке
            тяжёлый нейрохлыст.
            ]];
        else
            p [[С одной из банд я случайно столкнулся в какой-то подворотне.
            Я сразу понял, что просто так мне уйти не дадут.^
            {Главарь прэгов} сжимал в руке тяжёлый нейрохлыст.
            ]];
        end
        return;
    end,
    exam = function (s)
        p [[Это был огромный детина человеческого происхождения. Прэг был
        закован в пластиковый бронежилет и увешан оплавленными кусочками
        металла, применяемого в космической технике. В руке прэг сжимал
        тяжёлый нейрохлыст.
        ]];
        return;
    end,
    talk = function (s)
        if s._talked then
            p 'Кажется, он не расположен к диалогу...';
        else
            walk (praggs_leader_dlg);
        end
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (praggs_attack_end);
        end
        return;
    end,
    accept = function (s, w)
        if w == blaster then
            remove (blaster, inv());
            p [[Я протянул бластер главарю прэгов. Взяв оружие, прэг осмотрел
            его и отшвырнул далеко в сторону, прошипев сквозь зубы: «Кому
            нужна эта ржавая железка»...
            ]];
            return;
        end
        if w == credit_card then
            p [[Прэг долго изучал кредитку, а после сказал: «Это ты можешь
            оставить себе. Я не такой дурак, как ты думаешь».
            ]];
            return false;
        end
        if w == porcupine_paper then
            p [[— Я достал из кармана мятую облигацию и протянул её главарю.
            Но тот не взял её, а лишь сказал: «Оставь себе — пригодится на
            природе. Ха-ха-ха».
            ]];
            return false;
        end
        if w == coin then
            remove (coin, inv());
            p [[Прэг удовлетворённо хмыкнул, схватил монету и, внимательно
            осмотрев её, сунул себе в карман. «Ещё деньги есть?» — спросил
            громила сиплым голосом.
            ]];
            return;
        end
        p [[— Меня интересуют только деньги и оружие, — сказал Прэг.]];
        return false;
    end,
};


praggs_leader_dlg = dlg
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    phr =
    {
        {
            [[Ну и что вы хотите от меня?]],
            [[— Деньги есть?]],
            [[ pjump ('p_21'); ]]
        };
        {
            [[Эй, посторонись, хватит глазеть! Дай пройти!]],
            [[— Не дёргайся, мужик! Нам нужно пощупать твой кошелёк.]],
            [[ pjump ('p_22'); ]]
        };
        {
            [[Ты, ублюдок, не смотри на меня так!]],
            nil,
            [[poff(3); walk (praggs_leader_dlg_13_1); return;]]
        };
        { };
        {
            tag = 'p_21',
            [[Да, есть кое-что.]],
            [[— Давай, выкладывай всё, что есть!]],
            [[ praggs_leader._talked = true; back (); ]]
        };
        {
            tag = 'p_21',
            [[Деньги? Чего захотел!]],
            [[— Дикобраз! Ты слышал? Ну так действуй!^]],
            [[ praggs_leader._talked = true; walk (praggs_leader_dlg_end_braz); return;]]
        };
        {
            tag = 'p_21',
            [[Может разойдёмся по-хорошему?]],
            [[— А что ты можешь мне предложить?]],
            [[ pjump ('p_31'); ]]
        };
        { };
        {
            tag = 'p_22',
            [[Ребята, отстаньте от меня, пожалуйста!]],
            [[— Деньги есть?]],
            [[ pjump ('p_21'); ]]
        };
        {
            tag = 'p_22',
            [[У меня ничего нет!]],
            [[— А это мы сейчас проверим! Дикобраз, разберись с ним!^]],
            [[ praggs_leader._talked = true; walk (praggs_leader_dlg_end_braz); return;]]
        };
        { };
        {
            tag = 'p_31',
            [[Всё, что захотите!]],
            nil,
            [[ praggs_leader._talked = true; walk (praggs_leader_dlg_end_3); return;]]
        };
        {
            tag = 'p_31',
            [[Приятную ночь и развлечения!]],
            [[— Не понял?]],
            [[ praggs_leader._talked = true; pjump ('p_41'); ]]
        };
        { };
        {
            tag = 'p_41',
            [[Я хорошо заплачу, вам хватит этого чтобы немного поразвлечься.]],
            [[— Ха-ха-ха! Мы и так у тебя всё заберём. Дикобраз, действуй!^]],
            [[ praggs_leader._talked = true; walk (praggs_leader_dlg_end_braz); return;]]
        };
        {
            tag = 'p_41',
            [[Вы возьмёте всё, что вам нужно, и даже больше!]],
            [[— А что нам нужно? Ты не знаешь?]],
            [[ praggs_leader._talked = true; pjump ('p_51'); ]]
        };
        { };
        {
            tag = 'p_51',
            [[Нет, не знаю.]],
            nil,
            [[ praggs_leader._talked = true;
            if porcupine_paper._examined then
                p '— Ха-ха-ха! Мы и так у тебя всё заберём. Дикобраз, действуй!^';
            else
                p '— Хватит жевать мне мозги. Дикобраз, разберись с ним!^';
            end
            walk (praggs_leader_dlg_end_braz);
            return;
            ]]
        };
        {
            tag = 'braz',
            false,
            [[Один вопрос — вы не знаете кто такой Браз Дик?]],
            nil,
            [[praggs_leader._talked = true; walk (praggs_leader_dlg_end_7); return;]]
        };
    },
};



praggs_leader_dlg_13_1 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[За «ублюдка» ты мне ответишь! Дикобраз, разберись с ним!^
        От группы прэгов отделился огромный волосатый человек, действительно
        чем-то похожий на дикобраза и, не говоря ни слова, набросился на меня.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'praggs_leader_dlg_13_2') },
};


praggs_leader_dlg_13_2 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_fist.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[В нелёгкой схватке мне удалось победить противника.^
        Но не успел я придти в себя, как на меня набросились остальные прэги.
        Сопротивляться было бесполезно...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};



praggs_leader_dlg_end_braz = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    dsc = function (s)
        p [[От группы прэгов отделился огромный волосатый человек,
        действительно чем-то похожий на дикобраза, и, не говоря ни слова,
        набросился на меня.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'praggs_leader_dlg_end_2') },
};



praggs_leader_dlg_end_2 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_fist.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[В нелёгкой схватке мне удалось победить противника.^Но не успел я
        придти в себя, как на меня набросились остальные прэги. Сопротивляться
        было бесполезно...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


praggs_leader_dlg_end_3 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    dsc = function (s)
        p [[«О’кей! Дикобраз, забери у него всё!» — приказал главарь. От толпы
        прэгов отделился огромный детина и направился ко мне. Я ничего не
        успел сделать. Дикобраз скрутил меня, а два других прэга вывернули мне
        карманы.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'praggs_leader_dlg_end_4') },
};


praggs_leader_dlg_end_4 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_fist.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
        remove (blaster, inv());
        remove (neurowhip, inv());
        clock_next ();
        status_change (-13, -7, -7, 0, 0);
        if status._health <= 0 then
            status._health = 1;
        end
        remove (praggs_leader, r_212);
    end,
    dsc = function (s)
        p [[Забрав всё, что они сочли нужным, прэги избили меня и оставили
        лежать в грязной подворотне.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_212') },
};


praggs_leader_dlg_end_7 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    dsc = function (s)
        p [[«А откуда ты его знаешь? Дикобраз, ты слышал? Этот парень
        откуда-то тебя знает», — пробормотал главарь. Из толпы вышел огромный
        детина двухметрового роста.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_212') },
    exit = function (s)
        put (porcupine, r_212);
    end,
};


praggs_attack_end = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_fist.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[«Что он делает?» — закричал кто-то из прэгов. «Ребята, кончайте
        его!!!»^Схватка, была жаркой, но короткой. Силы были не равны.
        Последнее, что я помню — шипящая ручная граната под ногами...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};



porcupine = obj
{
    nam = 'Дикобраз',
    _talked = false,
    _happy = false,
    dsc = function (s)
        p [[Огромный детина двухметрового роста по кличке {Дикобраз} молча
        смотрел на меня.
        ]];
        return;
    end,
    exam = function (s)
        return 'Здоровенный прэг с неприветливым взглядом.';
    end,
    talk = function (s)
        if s._happy or not s._talked then
            walk (porcupine_dlg);
        else
            p 'Я уже поговорил с Дикобразом.';
        end
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (praggs_attack_end);
            return;
        end
    end,
    accept = function (s, w)
        if w == porcupine_paper then
            if not have (porcupine_paper) then
                p 'У меня нет бумажки.';
            else
                porcupine._happy = true;
                walk (porcupine_happy);
            end
        end
        return;
    end,
};


porcupine_dlg = dlg
{
    nam = 'Старый район',
    pic = 'images/212_praggs.png',
    enter = function (s, from)
        if porcupine._happy then
            -- walk (porcupine_dlg_2);
            p 'Я окликнул Браз Дика и тот согласился меня выслушать.';
            pjump ('second');
        else
            -- walk (porcupine_dlg_1);
            pjump ('first');
        end
    end,
    phr =
    {
        {
            -- 1,
            tag = 'first',
            [[У меня кое-что есть для тебя. Я думаю, что ты будешь рад.
            Только скажи своим, чтобы они угомонились.
            ]],
            [[Дикобраз молча смотрел на меня, но в глазах его уже засветились
            огоньки любопытства.
            ]],
            [[ porcupine._talked = true; back (); ]]
        };
        { },
        {
            -- 1,
            tag = 'second',
            [[Ну ладно, я пошёл, пока!]],
            [[— Будь здоров! — ответил Дикобраз и побежал догонять своих,
            которые всей толпой направились отмечать радостное событие.
            Через несколько секунд прэги растворились в темноте ночи.
            ]],
            [[ objs(r_212):del(porcupine); back (); ]]
        };
        {
            -- 2,
            tag = 'second',
            [[Вы не можете мне помочь?]],
            [[— А что я могу сделать?]],
            [[ pjump ('third'); ]]
        };
        { },
        {
            -- 1,
            tag = 'third',
            [[Мне срочно нужно в Таран.]],
            [[— Если есть деньги — тогда на рейсовом аэро. Если нет — тогда по
            северной трассе. Только там пост, без документов не пройдёшь.
            ]];
            -- [[poff(1); walk (porcupine_dlg_4); return;]]
            [[ pjump ('forth'); ]]
        };
        { },
        {
            -- 1,
            tag = 'forth',
            [[Хорошо, спасибо.]],
            [[— Будь здоров! — ответил Дикобраз и побежал догонять своих,
            которые всей толпой направились отмечать радостное событие.
            Через несколько секунд прэги растворились в темноте ночи.
            ]],
            [[ objs(r_212):del(porcupine); back (); ]]
        };
        {
            -- 2,
            tag = 'forth',
            [[А не могли бы вы помочь мне пробраться через пост?]],
            nil,
            [[ walk (porcupine_dlg_end_1); return;]]
        };
    },
};


porcupine_dlg_end_1 = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    dsc = function (s)
        p [[— Нет проблем, — сказал Дикобраз и свистнул удалявшейся толпе
        прэгов. Они вернулись, и Браз Дик что-то прошептал на ухо главарю.^
        Тот изучающе посмотрел на меня и сказал: «Ладно, поехали.
        Протащим тебя через пост», — с этими словами главарь прэгов подал знак
        своим, и из темноты подворотни выехал старый, видавший виды
        автокрафт-фургон.^
        Я и вся банда прэгов погрузились в автокрафт и уже спустя несколько
        секунд мы мчались по ночным улицам города на север.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'porcupine_dlg_end_2') },
    exit = function (s)
        r_212._praggs_gone = true;
        remove (praggs_leader, r_212);
        remove (porcupine, r_212);
    end,
};


porcupine_dlg_end_2 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/243_runaway.png',
    dsc = function (s)
        p [[У поста артанг-полицейский поднял жезл и приказал остановиться.
        Но водитель автокрафта только прибавил скорости. Столкновение с
        шлагбаумом было не из приятных: сильный удар, скрежет переднего
        бампера, сноп искр и разлетающиеся куски полосатого пластика.^
        Артанга-полицейского главарь банды снял одним выстрелом.
        Остальные открыли огонь из окон по полицейской будке.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'porcupine_dlg_end_3') },
};


porcupine_dlg_end_3 = room
{
    nam = 'Развилка',
    hideinv = true,
    pic = 'images/332.png',
    enter = function (s)
        set_music ('music/16_escape_2.ogg');
    end,
    dsc = function (s)
        p [[Мы проскочили пост и затормозили только через несколько
        километров.^
        «Выходи. Быстро», — сказал главарь, открыл дверь и буквально вытолкал
        меня из фургона.^
        Взревели двигатели автокрафта, машина развернулась и на огромной
        скорости помчалась обратно в город.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_332') },
};


porcupine_happy = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_praggs.png',
    dsc = function (s)
        p [[Я достал из кармана мятую облигацию и протянул её Дикобразу.
        Тот переменился в лице и его широкая улыбка обнажила беззубый рот.^
        «О, ты нашёл её!» — радостно закричал Дикобраз.^
        Он показал облигацию главарю и тот, дружески похлопав его по плечу,
        повернулся ко мне:^
        «Где ты нашёл её?».^
        Я рассказал историю с облигацией. Прэги долго хохотали.^
        «Дикобраз, ну ты напился тогда!» — закатываясь, выдавил главарь
        прэгов.^
        «А помнишь, как ты валялся под скамейкой в той беседке?»^
        «Помню. Ха-ха-ха».^
        «А потом хотел переплыть на ту сторону моря! Хо-хо-хо».^
        Казалось, прэги забыли про меня, но когда волна веселья немного
        поутихла, главарь прэгов повернулся ко мне: «Ты ещё здесь? Иди гуляй,
        парень. Ты свободен. Ха-ха-ха».
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_212') },
    exit = function (s)
        r_212._praggs_gone = true;
        remove (praggs_leader, r_212);
        remove (porcupine_paper, inv());
    end,
};



r_212_biomask_end = room
{
    nam = 'Старый район',
    hideinv = true,
    pic = 'images/212_fist.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Блуждая по городу, я забрёл в грязный бедный район, который
        населяли отбросы общества. Целые банды прэгов — местных анархистов —
        разгуливали по улицам. С одной из банд я случайно столкнулся в
        какой-то подворотне. Прэги набросились на меня неожиданно, я ничего
        не успел предпринять...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};



r_213 = room
{
    nam = 'Аэропорт',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    _tiseller_img = false,
    north = 'r_223',
    east = nil,
    south = nil,
    west = 'r_212',
    pic = function (s)
        if s._tiseller_img then
            return 'images/213_tiseller.png';
        else
            return 'images/213.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/18_harbour.ogg');
        if from == r_223 or from == r_212 then
            s._tiseller_img = false;
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 3;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[После долгого пути я оказался внутри большого и светлого
            здания аэропорта. Сквозь высокие и толстые стеклянные стены я мог
            наблюдать за типичной пассажирской суетой. Изредка со взлётных
            площадок в небо взмывали лёгкие аэро, грузовые трейлеры,
            туристические винтолёты.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я находился в вестибюле аэропорта. Сквозь стеклянные двери я
            видел как взлетали и прилетали воздушные суда. На инфотабло помимо
            расписания и новостей светилась реклама каких-то авиакомпаний.
            Здесь было довольно людно и никто не обращал на меня внимания.
            ]];
            return;
        end
        if s._visit == 3 then
            p [[Здесь всё было по-прежнему. Аэропорт мегаполиса Пульсар жил
            своей обычной суетливой жизнью.
            ]];
            return;
        end
    end,
    obj =
    {
        'infoboard',
        'roboturnstile'
    },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Здесь было много свободных кресел. Я сел в кресло и немного
            вздремнул.
            ]];
            return;
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p [[Здесь было много свободных кресел. Я сел в кресло и
                немного вздремнул.
                ]];
                return;
            end
        end
    end,
    exit = function (s, to)
        if to == r_223 or to == r_212 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


infoboard = obj
{
    nam = 'инфотабло',
    _examined = false,
    dsc = function (s)
        if s._examined then
            p [[На противоположной глухой стене вестибюля висело {инфотабло},
            разделённое на 
            ]];
        else
            p 'На противоположной глухой стене вестибюля висело {инфотабло}.';
        end
        return;
    end,
    exam = function (s)
        r_213._tiseller_img = false;
        if not s._examined then
            s._examined = true;
            infozone_1:enable();
            infozone_2:enable();
        end
        p [[Огромное информационное табло, разделённое на несколько
        независимых друг от друга инфозон.
        ]];
        return;
    end,
    obj =
    {
        'infozone_1',
        'infozone_2',
        'tiseller'
    },
};


infozone_1 = obj
{
    nam = '1-ая инфозона',
    dsc = function (s)
        return '{1-ую} и';
    end,
    exam = function (s)
        r_213._tiseller_img = false;
        p [[В этой инфозоне было написано:^
        Пульсар — Таран: Регулярные рейсы. Каждые два часа. Билеты продаются
        в любом тисейлере. Красивый город Таран ждёт Вас!^
        Пульсар — Аркан: Регулярные рейсы. Каждый час. Дешёвые билеты в любом
        тисейлере. Прекрасный Аркан — город невест — ждёт Вас!
        ]];
        return;
    end,
}:disable();


infozone_2 = obj
{
    nam = '2-ая инфозона',
    _index = 0,
    dsc = function (s)
        return '{2-ую} инфозоны.';
    end,
    exam = function (s)
        r_213._tiseller_img = false;
        s._index = s._index + 1;
        if s._index > 15 then
            s._index = 2;
        end
        if s._index == 1 then
            p [[В этой инфозоне шли новости. Симпатичная дикторша приятным
            голосом зачитывала сообщение военного правительства планеты:^
            «...Сегодня на пресс-конференции после встречи Ан Гияда и Плуда
            Врожера были опровергнуты слухи о гибели космического патрульного
            крейсера «Артанг Великий».^
            Напоминаем, речь идёт о недавнем событии, после которого
            заговорили о некоем вторгшемся в пределы Охраняемой Зоны агенте
            ЦСЧК, который якобы уничтожил корабль. Министр Сил Обороны и
            Поддержки Экспансии Плуд Врожер пригласил на конференцию пилота
            «Артанга Великого».^
            Пилот подтвердил, что распускаемые слухи — провокация руководства
            ЦСЧК. Руководство СОПЭ в жёсткой форме заявило протест ЦСЧК,
            требуя неукоснительного соблюдения Лейвского Договора о Мире 3551
            года».
            ]];
            return;
        end
        if s._index == 2 then
            p [[Голографическая мультисистема «Фантом» позволит Вам побывать
            на любой обитаемой и необитаемой планете вселенной. Купите и Вы
            не пожалеете! Компания «Голос» ждёт ВАС!
            ]];
            return;
        end
        if s._index == 3 then
            p 'Банк «Золотая Галактика»: у нас всё в порядке. А у Вас?';
            return;
        end
        if s._index == 4 then
            p [[Лучшие биопирожки «Смол-Натурал» от фирмы «У Фрода на
            обочине» — мы накормим всю вселенную!
            ]];
            return;
        end
        if s._index == 5 then
            p [[Чёрный коньяк «Фонтаны Раккслы» — это то, что Вам нужно в
            жаркий вечер после утомительной работы. Попробуйте наши фонтаны.
            Компания «АлкоМетео».
            ]];
            return;
        end
        if s._index == 6 then
            p [[«Смол-Натурал» — компания «У Фрода на обочине» предлагает
            воздушные пирожки! Оболочка сделана из лучших злаковых растений,
            собранных на полях Ретоуна, начинки любые — от мясных из мяса
            птицы Кошера, до сладких из мякоти великолепных плодов гигантских
            Пальских деревьев. Фирма «У Фрода на обочине» — мы накормим всю
            вселенную!
            ]];
            return;
        end
        if s._index == 7 then
            p [[Только для настоящих мужчин — гражданское оружие самообороны —
            плазменный электрошок с синхроимпульсным излучателем! И Вы никого
            не боитесь! Разрешено министерством СОПЭ. Фирма «Армед Ган».
            ]];
            return;
        end
        if s._index == 8 then
            p [[«Дорогая, как я выгляжу?» — спросил ОН. «Отвратительно,
            дорогой,» — ответила ОНА. Вы НИКОГДА не услышите таких слов,
            если будете пользоваться микролазерной вибробритвой «СимплТрэк».
            «Теперь у меня никаких проблем!» Фирма «УльтраЛав».
            ]];
            return;
        end
        if s._index == 9 then
            p [[Новости культуры. Сегодня в Центре Культуры прошла
            конференция, посвящённая творчеству выдающегося художника и
            математика прошлого тысячелетия — легендарного Грет Кана.
            Как известно, большую часть своих картин он посвятил уникальному
            природному явлению — Темпору Раккслы.^
            В его картинах отражены такие вечные категории как Пространство и
            Время. На конференции присутствовал мэр Пульсара — Ан Гияд.
            ]];
            return;
        end
        if s._index == 10 then
            p [[Из последних сообщений. На Раккслу прибыл корабль «ФФФ» с
            делегацией дружественной нам цивилизации клоредов. На борту «ФФФ»
            сорок пять дипломатов. На переговорах в Великой Башне будут
            обсуждаться дальнейшие пути развития сотрудничества.
            ]];
            return;
        end
        if s._index == 11 then
            p [[Фирма «Сторож» предлагает уникальные сейфы для хранения ценных
            бумаг и денег. Выполненные из особо прочных материалов и
            оформленные в старинном стиле, наши сейфы помогут Вам сохранить
            Тайну.
            ]];
            return;
        end
        if s._index == 12 then
            p [[Ценителям естественной пищи — Заячьи Ягоды. Специалисты
            рекомендуют диету из Заячьих Ягод от всех болезней.
            ]];
            return;
        end
        if s._index == 13 then
            p [[«Таран-Пресс» сообщает. Продолжаются строительные работы в
            северо-западном районе города. В связи с этим будет перекрыто
            движение по прилегающим к району трассам. Управление Движения СОПЭ
            предлагает пользоваться объездными путями.
            ]];
            return;
        end
        if s._index == 14 then
            p [[Фирма «Сторож» предлагает многофункциональные настенные часы
            «ЭкстраТайм». Отличительная особенность этой модели — в огромном
            наборе дополнительных возможностей. Наши часы умеют ВСЁ!
            ]];
            return;
        end
        if s._index == 15 then
            p [[Пока Ваш дом — проходной двор, в наш сейф не залезет вор!!!
            Фирма «Сторож». Сохрани себя сам!
            ]];
            return;
        end
    end,
}:disable();


tiseller = obj
{
    nam = 'тисейлер',
    _to_taran = true,
    dsc = function (s)
        p [[Под табло стояли будки {тисейлеров} — автоматов по продаже
        билетов.
        ]];
        return;
    end,
    exam = function (s)
        r_213._tiseller_img = true;
        p 'Обыкновенный интеллектуальный автомат по продаже билетов.';
        return;
    end,
    obj = { 'coin_receiver' },
    useit = function (s)
        coin_receiver:enable();
        walk (tiseller_dlg);
        return;
    end,
};


coin_receiver = obj
{
    nam = 'монетоприёмник',
    dsc = function (s)
        p 'В каждом тисейлере располагался {монетоприёмник}.';
        return;
    end,
    exam = function (s)
        r_213._tiseller_img = true;
        p 'Обычный монетоприёмник.';
        return;
    end,
    used = function (s, w)
        if w == credit_card then
            walk (r_213_end_1);
            return;
        end
        if w == coin then
            drop (coin);
            remove (coin);
            take (sky_kiss_ticket);
            r_213._tiseller_img = true;
            sky_kiss_ticket._to_taran = tiseller._to_taran;
            p [[Я положил деньги в монетоприёмник и через некоторое время из
            прорези автомата выполз билет.
            ]];
            return;
        end
    end,
}:disable();


sky_kiss_ticket = obj
{
    nam = 'билет',
    _to_taran = true,
    exam = function (s)
        p [[Компания «Воздушный поцелуй». На любой рейс: ]];
        if s._to_taran then
            p [[Пульсар — Таран.]];
        else
            p [[Пульсар — Аркан.]];
        end
        return;
    end,
};


r_213_end_1 = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/213_tiseller_woman.png',
    dsc = function (s)
        p [[Я положил кредитку в монетоприёмник. Через несколько секунд
        женский голос произнёс: «Подождите секундочку, пожалуйста».
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_213_end_2') },
};


r_213_end_2 = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Не прошло и минуты, как сзади кто-то грубо толкнул меня, заломил
        мне руки и прижал лицом к холодному экрану тисейлера. На запястьях
        щёлкнули наручники. «Ну вот ти и попалься, с-сволочь. Тьипер ти будут
        расстрелят!» — сказал артанг-полицейский.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


tiseller_dlg = dlg
{
    nam = 'Тисейлер',
    hideinv = true,
    pic = 'images/213_tiseller_woman.png',
    enter = function (s, t)
        r_213._tiseller_img = true;
    end,
    dsc = function (s)
        p [[Я прикоснулся к экрану. Сработали чувствительные сенсоры и на
        экране появилось лицо миловидной девушки.^
        «Здравствуйте! Компания «Воздушный поцелуй» приветствует Вас!
        Какой рейс желаете заказать?» — произнесла она и на некоторое время
        застыла в ожидании ответа.
        ]];
        return;
    end,
    phr =
    {
        {
            -- 1,
            always = true,
            [[Мне нужен один билет до Тарана.]],
            [[— Вы выбрали рейс до Тарана. Оплатите билет, пожалуйста.]],
            [[ tiseller._to_taran = true; back(); ]]
        };
        {
            -- 2,
            always = true,
            [[Мне нужен один билет до Аркана.]],
            [[— Вы выбрали рейс до Аркана. Оплатите билет, пожалуйста.]],
            [[ tiseller._to_taran = false; back(); ]]
        };
    },
};




roboturnstile = obj
{
    nam = 'роботурникет',
    dsc = function (s)
        p 'У выхода к взлётным площадкам стояли {роботурникеты}.';
        return;
    end,
    exam = function (s)
        r_213._tiseller_img = false;
        p 'Индивидуальный автоматизированный пропускной пункт.';
        return;
    end,
    used = function (s, w)
        if w == sky_kiss_ticket then
            if sky_kiss_ticket._to_taran then
                walk (r_213_lucky_end_1t);
            else
                walk (r_213_lucky_end_1a);
            end
            return;
        end
    end,
};


r_213_lucky_end_1a = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/213.png',
    enter = function (s, from)
        set_music ('music/01_intro.ogg');
    end,
    dsc = function (s)
        p [[Я вставил билет в щель приёмника и встал на самодвижущуюся
        дорожку, которая буквально за минуту доставила меня на взлётную
        площадку, к одному из аэро.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_213_lucky_end_2a') },
};


r_213_lucky_end_2a = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/213_aero.png',
    dsc = function (s)
        p [[Я прошёл внутрь и сел в первое свободное кресло. Кроме меня в
        салоне находилось ещё пять человек. Через несколько минут мы взлетели.
        Испытывая знакомые с детства лёгкие перегрузки, я вдруг подумал,
        что впервые за последнее время нахожусь высоко в небе.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_213_lucky_end_3a') },
};


r_213_lucky_end_3a = room
{
    nam = '...',
    _f = '2',
    hideinv = true,
    pic = 'images/213_final.png',
    enter = function (s, from)
        if from == r_213_lucky_end_2a then
            s._f = '2';
        else
            s._f = '3';
        end
    end,
    dsc = function (s)
        if s._f == '2' then
            p 'Ночью я уже был на Аркане.';
        end
        p [[В местном аэропорту я случайно познакомился с красивой девушкой.
        Она была так хороша, что я забыл обо всём на свете. Я считаю, что
        сделал правильный выбор. Сбылась моя заветная мечта — найти Раккслу,
        любовь и удалиться на покой.^ Сейчас я не жалею ни о чём. Проблемы
        войны с артангами уже давно не волнуют меня. Впрочем, в нашем городе
        это никого не волнует. Отец моей любимой оказался старым богатым
        торговцем.^У него шикарный трёхэтажный дом на берегу океана,
        собственный винтолёт, глайдер и всё, что нужно для спокойной жизни.
        Так что у моей невесты отличное приданое.^После свадьбы мы живём
        вместе с её отцом. У нас всё прекрасно, скоро у неё будет ребёнок.
        Мы любим друг друга, и я больше не хочу в космос...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_213_lucky_end_4a') },
};


r_213_lucky_end_4a = room
{
    nam = 'КОНЕЦ',
    hideinv = true,
    dsc = function (s)
        p [[ПОЗДРАВЛЯЮ! Вы только что прошли игру «Звёздное Наследие» и
        наградой Вам станет любовь девушки, которая так долго ждала Вас.
        ]];
        return;
    end,
};


r_213_lucky_end_1t = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/213.png',
    enter = function (s, from)
        remove (sky_kiss_ticket, inv());
        set_music ('music/16_escape_2.ogg');
    end,
    dsc = function (s)
        p [[Я вставил билет в щель приёмника и встал на самодвижущуюся
        дорожку, которая буквально за минуту доставила меня на взлётную
        площадку, к одному из аэро.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_213_lucky_end_2t') },
};


r_213_lucky_end_2t = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/213_aero.png',
    dsc = function (s)
        p [[Я прошёл внутрь и сел в первое свободное кресло. Кроме меня в
        салоне находилось ещё пять человек. Через несколько минут мы взлетели.
        Испытывая знакомые с детства лёгкие перегрузки, я вдруг подумал,
        что впервые за последнее время нахожусь высоко в небе.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327') },
};


-- ----------------------------------------------------------------------

r_221 = room
{
    nam = 'Набережная',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_231',
    east = 'r_222',
    south = nil,
    west = nil,
    pic = 'images/221.png',
    enter = function (s, from)
        set_music ('music/21_poulsar_city.ogg');
        if from == r_231 or from == r_222 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 3;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я шёл на юг по набережной вдоль берега моря. Мегаполис Пульсар
            был большим современным городом. На востоке я видел огромные
            небоскрёбы, которые закрывали половину неба. На западе
            распростёрлась морская гладь.^
            Как ни странно, на набережной практически никого не было.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я стоял на набережной. На западе, до самого горизонта,
            простиралось море. На севере я видел постройки морского порта.
            На востоке, сразу за широкой дорогой, по которой проносились
            автокрафты на воздушных подушках, возвышались гигантские
            небоскрёбы.
            ]];
            return;
        end
        if s._visit == 3 then
            p [[Эта набережная была мне знакома. На севере я видел постройки
            морского порта, на востоке — великолепные современные небоскрёбы.
            ]];
            return;
        end
    end,
    obj = { 'pavillon' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Я прилёг на скамейку и немного вздремнул.';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Я прилёг на скамейку и немного вздремнул.';
            end
        end
    end,
    exit = function (s, to)
        if to == r_231 or to == r_222 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


pavillon = obj
{
    nam = 'беседка',
    _examined = 0,
    dsc = function (s)
        p [[На набережной стояла небольшая {беседка}.]];
        return;
    end,
    exam = function (s)
        trash_heap:enable();
        p [[Небольшая беседка из белого камня. Внутри по периметру — каменные
        скамейки. Под скамейками большие кучи мусора.
        ]];
        return;
    end,
    obj = { 'trash_heap' },
};


trash_heap = obj
{
    nam = 'куча мусора',
    _examined = 0,
    dsc = function (s)
        p 'Под скамейками беседки лежали большие {кучи мусора}.';
        return;
    end,
    exam = function (s)
        s._examined = s._examined + 1;
        if s._examined == 7 then
            s._examined = 6;
        end
        if s._examined == 1 then
            p [[Вероятно что здесь недавно здорово отдохнули какие-то
            некультурные личности. Под скамейками разбросаны кучи пробок,
            огрызков, очистков и пустые банки.
            ]];
        end
        if s._examined == 2 then
            p [[Копаться в этой куче этого дерьма было неприятным занятием.
            Ничего, что могло бы заинтересовать меня.
            ]];
        end
        if s._examined == 3 then
            put (porcupine_paper, r_221);
            p [[Я ещё раз с отвращением перевернул весь мусор и заметил в
            углу измятую бумажку с какой-то надписью.
            ]];
        end
        if s._examined == 4 then
            p [[Копаться в этой куче этого дерьма было неприятным занятием.
            Ничего, что могло бы заинтересовать меня.
            ]];
        end
        if s._examined == 5 then
            put (wire, r_221);
            p [[Я ещё раз заглянул за скамейку и заметил в куче мусора
            причудливо изогнутый кусок проволоки.
            ]];
        end
        if s._examined == 6 then
            p [[Копаться в этой куче этого дерьма было неприятным занятием.
            Ничего, что могло бы заинтересовать меня.
            ]];
        end
        return;
    end,
}:disable();


porcupine_paper = obj
{
    nam = 'бумажка',
    _examined = false,
    exam = function (s)
        s._examined = true;
        praggs_leader_dlg:pon('braz');
        p [[Ценная именная пятитысячная облигация банка «Золотая галактика»
        на имя Браз Дика.
        ]];
        return;
    end,
    take = function (s)
        return 'Я взял бумажку.';
    end,
    drop = function (s)
        return 'Я бросил бумажку.';
    end,
};


wire = obj
{
    nam = 'проволока',
    exam = function (s)
        return 'Причудливо изогнутый кусок проволоки.';
    end,
    take = function (s)
        return 'Я взял проволоку.';
    end,
    drop = function (s)
        return 'Я бросил проволоку.';
    end,
};


r_222 = room
{
    nam = 'Центр города',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_232',
    east = 'r_223',
    south = 'r_212',
    west = 'r_221',
    pic = function (s)
        if status._clock == NIGHT then
            return 'images/222_night.png';
        else
            return 'images/222_day.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/21_poulsar_city.ogg');
        if from == r_221 or from == r_232 or from == r_223 or from == r_212 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я находился в центральной части города. Ориентироваться здесь
            было трудно: огромные небоскрёбы закрывали большую часть неба.
            По многоярусным автострадам неслись потоки автокрафтов.
            В воздухе с низким гулом изредка пролетали тяжёлые аэротрейлеры.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Центральный район города жил своей привычной суетливой жизнью.
            Высокие многоярусные автострады были заполнены потоком автокрафтов
            самых разных марок. Здесь было довольно душно и неуютно.
            ]];
            return;
        end
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[В центре города можно было отдохнуть без особых проблем.
            Я зашёл в небольшой скверик, прилёг на свободную скамейку и
            немного вздремнул.
            ]];
            return;
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-1, -1, -1, 0, 0);
                p [[В центре города можно было отдохнуть без особых проблем.
                Я зашёл в небольшой скверик, прилёг на свободную скамейку и
                немного вздремнул.
                ]];
            end
            return;
        end
    end,
    exit = function (s, to)
        if to == r_221 or to == r_232 or to == r_223 or to == r_212 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};



r_223 = room
{
    nam = 'Жилой район',
    _visit = 0,
    _rested = 0,
    _from_north = false,
    north = 'r_233',
    east = nil,
    south = 'r_213',
    west = 'r_222',
    pic = function (s)
        if s._from_north then
            return 'images/223b.png';
        else
            return 'images/223a.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/21_poulsar_city.ogg');
        if from == r_233 or from == r_213 or from == r_222 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
        if from == r_233 then
            s._from_north = true;
        else
            s._from_north = false;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я зашёл в обыкновенный жилой район, который находился на
            восточной окраине города.^С востока к району прилегали высокие
            горы. На юге, в долине реки я видел взлётные площадки аэропорта.
            На западе виднелись коробки гигантских небоскрёбов.
            На север вела широкая многоярусная магистраль.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Этот район вплотную прилегал к горам, которые находились на
            востоке. Обыкновенный жилой район обыкновенного города,
            построенного человеческими колонистами ещё на заре освоения
            Дальнего Космоса.
            ]];
            return;
        end
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Выбрав удобное место для отдыха, я прилёг на траву и
            погрузился в сон. Прошло несколько часов, прежде чем я проснулся и
            окинул взглядом местный пейзаж. Здесь всё было по-прежнему.
            ]];
            return;
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p [[Выбрав удобное место для отдыха, я прилёг на траву и
                погрузился в сон. Прошло несколько часов, прежде чем я
                проснулся и окинул взглядом местный пейзаж. Здесь всё было
                по-прежнему.
                ]];
                return;
            end
        end
    end,
    exit = function (s, to)
        if to == r_222 or to == r_233 or to == r_213 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};




-- ---------------------------------------------------------------------------

r_231 = room
{
    nam = 'Парк',
    _visit = 0,
    _rested = 0,
    north = 'r_241',
    east = 'r_232',
    south = 'r_221',
    west = nil,
    pic = function (s)
        if seen (r_231_man) then
            return 'images/231_man.png';
        else
            return 'images/231_nobody.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/19_city_park.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 3 then
            s._visit = 3;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Вскоре я оказался в большом городском парке, расположенном на
            пологом холме за зданием порта. Здесь было не многолюдно.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я находился в большом зелёном парке. Хотя парк и не казался
            заброшенным, я здесь не встретил ни души.
            ]];
            return;
        end
        if s._visit == 3 then
            p 'Я снова вернулся в парк.';
            return;
        end
    end,
    rest = function (s)
        if r_232_bar._captain_left_turns > 0 then
            r_232_bar._captain_left_turns = r_232_bar._captain_left_turns - 1;
        end
        if seen (r_231_man) then
            remove (r_231_man, r_231);
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Я нашёл свободную скамейку, прилёг и немного вздремнул.
            Проснулся я лишь через несколько часов.
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p [[Я нашёл свободную скамейку, прилёг и немного вздремнул.
                Проснулся я лишь через несколько часов.
                ]];
                return;
            end
        end
    end,
    obj = { 'r_231_man' },
    exit = function (s, to)
        if to == r_232 or to == r_221 then
            if r_232_bar._captain_left_turns > 0 then
                r_232_bar._captain_left_turns = r_232_bar._captain_left_turns - 1;
            end
        end
        if seen (r_231_man) then
            remove (r_231_man, r_231);
        end
        if to == r_241 or to == r_232 or to == r_221 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_231_man = obj
{
    nam = 'человек',
    dsc = function (s)
        p [[Около старого фонтана я заметил {человека}, который сидел на
        лавочке и читал газету.
        ]];
        return;
    end,
    exam = function (s)
        p 'Похоже, что этот толстяк — коренной житель города.';
        return;
    end,
    talk = function (s)
        walk (r_231_man_dlg);
        return;
    end,
};


r_231_man_dlg = dlg
{
    nam = 'Парк',
    hideinv = true,
    pic = 'images/231_man.png',
    entered = function (s, from)
        if status._biomask then
            pstart ('mask_on');
        else
            pstart ('mask_off');
        end
    end,
    phr =
    {
        {
            tag = 'mask_on',
            [[Уважаемый, не подскажете как мне добраться до Тарана?]],
            [[Толстяк долго пытался что-то из себя выжать, но так ничего и не
            сказал. В конце концов он поднялся со скамейки и чуть ли не бегом
            помчался прочь.
            ]],
            [[ objs(r_231):del(r_231_man); back (); ]]
        };
        {
            tag = 'mask_on',
            [[Здравствуйте, мне нужно с Вами поговорить (произнести на языке
            артангов).
            ]],
            [[— Только не убивайте, я прошу Вас! — завопил толстяк на ломаном
            языке артангов. — Я сделаю всё, что Вы скажете.
            ]],
            [[ pjump ('mask_on_2'); ]]
        };
        { },
        {
            tag = 'mask_on_2',
            [[А вот это Вы зря — я же ничего не собирался с Вами делать
            (произнести на языке артангов).
            ]],
            [[— Тогда я пойду, ладно? — с этими словами толстяк выскочил и,
            с неестественной полным людям скоростью, помчался прочь.
            ]],
            [[ objs(r_231):del(r_231_man); back (); ]]
        };
        {
            tag = 'mask_on_2',
            [[Тебя, свинья, никто не просит на меня работать!!! Как мне
            добраться до Тарана?!
            ]],
            [[Я ещё только договаривал эту фразу, а запуганный толстяк уже
            мчался куда-то в сторону порта. Через несколько секунд он скрылся
            из виду.
            ]],
            [[ objs(r_231):del(r_231_man); back (); ]]
        };
        { },
        {
            tag = 'mask_off',
            [[Уважаемый, не подскажете как мне добраться до Тарана?]],
            [[— Лучше на аэро. Конечно, можно и пешком или на автокрафте, но
            это гораздо дольше. Если полетите на аэро, то Вам нужно идти в ту
            сторону. — Он показал рукой на юго-восток. — Там аэропорт...
            ]],
            [[ pjump ('mask_off_2'); ]]
        };
        { },
        {
            tag = 'mask_off_2',
            [[Спасибо.]],
            [[— Не за что. Ну ладно, засиделся я здесь. Мне пора. — С этими
            словами мой собеседник поднялся и направился в сторону морского
            порта.
            ]],
            [[ objs(r_231):del(r_231_man); back ();]]
        };
        {
            tag = 'mask_off_2',
            [[А если я пойду пешком?]],
            [[— Тогда Вам туда, — мой собеседник махнул рукой на восток,
            поднялся и, попрощавшись, направился в сторону морского порта.
            ]],
            [[ objs(r_231):del(r_231_man); back ();]]
        };
    },
};


r_232 = room
{
    nam = 'Улица',
    _visit = 0,
    _rested = 0,
    _from_bar = false;
    north = nil,
    east = 'r_233',
    south = 'r_222',
    west = 'r_231',
    pic = function (s)
        if seen (kloreds) then
            if kloreds._dead then
                return 'images/232_kloreds_dead.png';
            else
                return 'images/232_kloreds.png';
            end
        else
            return 'images/232.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/20_blues.ogg');
        if from == r_231 or from == r_222 or from == r_233 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 4 then
                s._visit = 4;
            end
        end
        if from == r_232_bar or from == r_232_kloreds_killed_good then
            s._from_bar = true;
        else
            s._from_bar = false;
        end
    end,
    dsc = function (s)
        if s._from_bar then
            if seen (kloreds) then
                p 'Я вышел из бара.';
            else
                p 'Я вышел из бара. Поблизости никого не было.';
            end
            return;
        end
        if s._visit == 1 then
            p [[Я прошёл по длинной зелёной аллее и оказался возле невысокого
            здания, утопающего в неоновых вывесках.
            ]];
        end
        if s._visit == 2 then
            p [[Я стоял возле знакомого бара. Поблизости никого не было.]];
        end
        if s._visit == 3 then
            put (kloreds);
            p [[Через несколько часов я подошёл к большому бару. Возле входа в
            бар стояли два подвыпивших клореда, судя по всему, пилоты. Они
            что-то живо обсуждали, не обращая на меня внимания.
            ]];
        end
        if s._visit == 4 then
            if seen (kloreds) then
                if kloreds._dead then
                    p [[Я находился около большого бара. Возле входа в бар
                    лежали трупы клоредов.
                    ]];
                else
                    p [[Через несколько часов я подошёл к большому бару.
                    Возле входа в бар стояли два подвыпивших клореда, судя по
                    всему, пилоты. Они что-то живо обсуждали, не обращая на
                    меня внимания.
                    ]];
                end
            else
                p 'Через несколько часов я подошёл к большому бару.';
            end
        end
        return;
    end,
    obj = { 'r_232_bar_door' },
    rest = function (s)
        if seen (kloreds) and kloreds._dead then
            if kloreds._just_killed then
                walk (r_232_kloreds_killed_bad);
            else
                walk (r_232_kloreds_killed_good);
            end
            return;
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Перед баром находилось небольшое пустующее кафе под открытым
            небом. Я присел за пустой столик и немного отдохнул.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-1, -1, -1, 0, 0);
                p [[Перед баром находилось небольшое пустующее кафе под
                открытым небом. Я присел за пустой столик и немного отдохнул.
                ]];
            end
        end
        return;
    end,
    exit = function (s, to)
        if not (to == r_232_bar) then
            r_232_bar._captain_left_turns = 0;
        end
        if to == r_232_kloreds_killed_search then
            return;
        end
        if kloreds._just_killed then
            walk (r_232_kloreds_killed_search);
            return;
        end
        if to == r_231 or to == r_222 or to == r_233 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_232_bar = room
{
    nam = 'Бар',
    _captain_left_turns = 3;
    _from_street = true,
    pic = 'images/232_bar.png',
    enter = function (s, from)
        if s._captain_left_turns == 1 then
            s._captain_left_turns = 0;
            put (captain_in_bar, r_232_bar);
        end
        if from == r_232 then
            s._from_street = true;
        else
            s._from_street = false;
        end
    end,
    dsc = function (s)
        if s._from_street then
            p [[Я вошёл внутрь. Народу здесь было немного.]];
        else
            p [[Народу в баре было немного.]];
        end
        p [[Играла тихая музыка, все мирно отдыхали.]];
        if seen (captain_in_bar) then
            p [[За одним из столиков я увидел капитана того самого
            глайдера, на котором я приплыл в Пульсар.
            ]];
        end
        return;
    end,
    rest = function (s)
        if kloreds._just_killed then
            walk (r_232_kloreds_killed);
            return;
        end
        if kloreds._dead then
            remove (kloreds, r_232);
        end
        if r_232._rested == 0 then
            r_232._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Я немного посидел в баре и послушал тихую приятную музыку.';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p 'Я немного посидел в баре и послушал тихую приятную музыку.';
            end
        end
    end,
    obj = { 'r_232_bar_door' },
};


r_232_bar_door = obj
{
    nam = 'дверь бара',
    exam = function (s)
        return 'Дверь из особо прочных кварцелитов.';
    end,
    useit = function (s)
        if here () == r_232 then
            walk (r_232_bar);
        else
            walk (r_232);
        end
        return;
    end,
};


captain_in_bar = obj
{
    nam = 'капитан',
    dsc = function (s)
        p [[За одним из столиков я увидел {капитана} того самого глайдера,
        на котором я приплыл в Пульсар.
        ]];
        return;
    end,
    exam = function (s)
        p [[Капитану было не более сорока. Он выглядел опытным, закалённым в
        передрягах морским волком.
        ]];
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (r_232_bar_captain_end_1);
        end
        return;
    end,
    talk = function (s)
        walk (captain_in_bar_dlg);
    end,
};


captain_in_bar_dlg = dlg
{
    nam = 'Бар',
    hideinv = true,
    pic = 'images/232_bar_captain.png',
    entered = function (s, from)
       if status._biomask then
           pjump ('mask_on');
       else
           pjump ('mask_off');
       end
       return;
    end,
    dsc = function (s)
        p 'Я прошёл через зал и сел за столик капитана.';
        return;
    end,
    phr =
    {
        {
            -- 1,
            tag = 'mask_off',
            [[Я очень хотел найти Вас, нам нужно поговорить.]],
            [[— Извините, я Вас не знаю. — сказал капитан, посмотрел на часы,
            поднялся из-за стола и вышел из бара.
            ]],
            -- [[objs(r_232_bar):del(captain_in_bar); poff(1, 2); back();]]
            [[ objs(r_232_bar):del(captain_in_bar); back(); ]]
        };
        {
            -- 2,
            tag = 'mask_off',
            [[Приветствую, как дела?]],
            [[— Спасибо, хорошо, дружище, — ответил капитан. Он встал из-за
            стола и направился к выходу. Я остался один.
            ]],
            -- [[objs(r_232_bar):del(captain_in_bar); poff(1, 2); back();]]
            [[ objs(r_232_bar):del(captain_in_bar); back(); ]]
        };
        { },
        {
            -- 1,
            tag = 'mask_on',
            [[Я очень хотел найти Вас, нам нужно поговорить.]],
            [[Капитан некоторое время молчал, разглядывая моё «артанговское»
            лицо. Поняв в чём дело, он посмотрел по сторонам и, наклонившись
            ко мне, сказал: «Я, конечно, извиняюсь, но, по-моему, Вы — тот,
            кого искали артанги на острове?
            ]];
            -- [[poff(1, 2); walk (captain_in_bar_dlg_on_21); return;]]
            [[ psub ('mask_on_21'); ]]
        };
        {
            -- 2,
            tag = 'mask_on',
            [[Приветствую, как дела? (произнести на языке артангов).]],
            [[— Нам не о чем разговаривать. — Капитан поморщился, встал из-за
            стола, пересёк зал и вышел на улицу.
            ]],
            [[ objs(r_232_bar):del(captain_in_bar); back (); ]]
        };
        { },
        {
            -- 1,
            tag = 'mask_on_21',
            [[Нет.]],
            [[— Тогда извините. До свидания. — Сказал капитан, поднялся из-за
            стола и вышел из бара.
            ]],
            [[ objs(r_232_bar):del(captain_in_bar); back (); ]]
        };
        {
            -- 2,
            tag = 'mask_on_21',
            [[Да.]],
            [[— Я чувствовал, что Вы — наш человек. Ходят слухи, что Вы
            уничтожили патруль Службы Обороны артангов, — тихо произнёс
            капитан. — Но... Постойте, у Вас ничего не пропало, когда мы были
            в море?
            ]];
            -- [[ poff(1, 2); walk (captain_in_bar_dlg_on_32); return;]]
            [[ pjump ('mask_on_32'); ]]
        };
        { },
        {
            -- 1,
            tag = 'mask_on_32',
            [[Нет, ничего.]],
            [[Странно, я сам лично видел, как один из пассажиров вытаскивал у
            Вас из поясной сумки какой-то небольшой чёрный футляр. Вы ничего
            не заметили, а я не стал говорить. Сами понимаете — артанги
            это... — он не договорил.
            ]];
            -- [[poff(1, 2); walk (captain_in_bar_dlg_on_41); return;]]
            [[ pjump ('mask_on_4'); ]]
        };
        {
            -- 2,
            tag = 'mask_on_32',
            [[Да, одна важная вещь.]],
            [[Я видел, как один из пассажиров вытащил у Вас из поясной сумки
            какой-то небольшой чёрный футляр. Вы даже ничего не заметили.
            А я, к сожалению, был уверен, что Вы – артанг.
            ]];
            -- [[poff(1, 2); walk (captain_in_bar_dlg_on_42); return;]]
            [[ pjump ('mask_on_4'); ]]
        };
        { },
        {
            -- 1,
            tag = 'mask_on_4',
            [[Кто этот человек? Вы запомнили его?]],
            [[— Не очень хорошо. Судя по одежде и внешности — этот человек
            местный. Конечно, в таком большом городе найти его практически
            невозможно, но у меня кое-что есть для Вас. — Капитан хитро
            подмигнул и вытащил из нагрудного кармана пластиковый ключ.^
            — Это я нашёл в его каюте. Не знаю от чего этот ключик, но, может
            быть, он пригодится Вам. — Капитан отдал ключ мне.^
            Мы плотно поели и мой собеседник, посмотрев на часы, встал из-за
            стола.^
            — Ну, мне пора. Желаю удачи. — Сказал капитан и вышел из бара.
            ]];
            [[ remove (captain_in_bar, r_232_bar); take (electronic_key); me():enable_all(); status_change (7, 4, 3, 0, 0); back (); ]]
        };
    },
};


electronic_key = obj
{
    nam = 'электр. ключ',
    exam = function (s)
        p [[На обратной стороне ключа надпись:^Когда останемся наедине:
        первые и вторые.
        ]];
        return;
    end,
    take = function (s)
        return 'Я взял электронный ключ.';
    end,
    drop = function (s)
        return 'Я бросил электронный ключ.';
    end,
};



r_232_bar_captain_end_1 = room
{
    nam = 'Бар',
    hideinv = true,
    pic = 'images/232_bar.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Меня раздражал этот артанговский прихвостень и я решил
        расправиться с ним... Через секунду капитан лежал на полу.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_232_bar_captain_end_2') },
};


r_232_bar_captain_end_2 = room
{
    nam = 'Бар',
    hideinv = true,
    pic = 'images/artangs.png',
    dsc = function (s)
        p 'Однако кто-то вызвал охрану, и через минуту меня арестовали...';
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};



r_232_bar_mask_off_1 = room
{
    nam = 'Бар',
    hideinv = true,
    pic = 'images/232_bar.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p 'Я быстро снял маску и огляделся. Вокруг всё было тихо.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_232_bar_mask_off_2') },
};


r_232_bar_mask_off_2 = room
{
    nam = 'Бар',
    hideinv = true,
    pic = 'images/artangs.png',
    dsc = function (s)
        p [[Однако, похоже кто-то в баре заметил моё перевоплощение и вызвал
        охрану. Через несколько минут меня арестовали...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_232_biomask_off_end = room
{
    nam = 'Улица',
    hideinv = true,
    pic = function (s)
        if seen (kloreds) then
            if r_232._kloreds_dead then
                return 'images/232_kloreds_dead.png';
            else
                return 'images/232_kloreds.png';
            end
        else
            return 'images/232.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я быстро снял маску и огляделся вокруг. По-моему, никто не заметил
        моего перевоплощения.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_232_biomask_off_end_2') },
};


r_232_biomask_off_end_2 = room
{
    nam = 'Улица',
    hideinv = true,
    pic = 'images/police.png',
    dsc = function (s)
        p [[Внезапно за углом завизжала сирена. Из подлетевшего автокрафта
        выскочили полицейские-артанги и без объяснения бросили меня в свою
        машину...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_232_kloreds_killed_bad = room
{
    nam = 'Улица',
    hideinv = true,
    pic = 'images/police.png',
    dsc = function (s)
        p [[Далеко уйти мне не удалось. Внезапно завизжала полицейская сирена,
        раздались выстрелы...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_232_kloreds_killed_good = room
{
    nam = 'Улица',
    hideinv = true,
    pic = 'images/police.png',
    enter = function (s)
        remove (kloreds, r_232);
    end,
    dsc = function (s)
        p [[Я вошёл в небольшое пустующее кафе, находившееся рядом с баром и
        сел за первый попавшийся столик. Пока я отдыхал, к бару подъехал
        полицейский автокрафт. Из него вышли артанги и, погрузив трупы
        клоредов в машину, уехали. На меня артанги не обратили никакого
        внимания.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_232') },
};



r_232_kloreds_killed_search = room
{
    nam = 'Улица',
    hideinv = true,
    pic = 'images/police.png',
    dsc = function (s)
        p [[Внезапно за углом завизжала сирена. Из подлетевшего автокрафта
        выскочили полицейские-артанги и без объяснения бросили меня в свою
        машину...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


kloreds = obj
{
    nam = 'клореды',
    _dead = false,
    _just_killed = false,
    _searched = false,
    exam = function (s)
        if not s._dead then
            p [[Эти двое были типичными представителями расы клоредов.
            Цивилизация насекомообразных клоредов одна из первых перешла на
            сторону артангов.
            ]];
        else
            if status._biomask then
                if s._searched then
                    p [[Я обыскал карманы убитых, но не нашёл ничего
                    интересного.
                    ]];
                else
                    s._searched = true;
                    coin:enable();
                    p [[У меня было всего несколько секунд на то, чтобы
                    осмотреть трупы. В кармане у одного из убитых я обнаружил
                    трёхкредовую монету.
                    ]];
                end
            else
                walk (r_232_kloreds_killed_search);
            end
        end
        return;
    end,
    talk = function (s)
        return 'Кажется, они меня не понимают.';
    end,
    used = function (s, w)
        if w == neurowhip then
            s._dead = true;
            s._just_killed = true;
            p [[Улучив момент, я выхватил нейрохлыст и открыл огонь по
            клоредам. Через секунду с несчастными тварями было покончено.
            ]];
            return;
        end
    end,
    obj = { 'coin' },
};


coin = obj
{
    nam = 'монета',
    exam = function (s)
        return 'Трёхкредовая монета.';
    end,
    take = function (s)
        return 'Я взял монету.';
    end,
    drop = function (s)
        return 'Я бросил монету.';
    end,
}:disable();


r_233 = room
{
    nam = 'Северная окраина',
    _visit = 0,
    _rested = 0,
    _from_north = false,
    north = 'r_243',
    east = nil,
    south = 'r_223',
    west = 'r_232',
    pic = function (s)
        if not s._from_north then
            return 'images/233a.png';
        else
            return 'images/233b.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/20_blues.ogg');
        if from == r_243 then
            s._from_north = true;
        else
            s._from_north = false;
        end
        s._rested = 0;
        s._visit = s._visit + 1;
        if s._visit > 3 then
            s._visit = 3;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Прошло несколько часов. Блуждая по городу, я вышел на его
            северную окраину. На юге и западе я видел кварталы Пульсара.
            На востоке тянулась горная гряда.
            ]];
        end
        if s._visit == 2 then
            p [[Я стоял на обочине широкой дороги. Изредка по дороге
            проносились автокрафты.
            ]];
        end
        if s._visit == 3 then
            p [[Я вышел на северную окраину города.]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Я нашёл свободную скамейку, прилёг и немного вздремнул.
            Проснулся я лишь через несколько часов.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p [[Я нашёл свободную скамейку, прилёг и немного вздремнул.
                Проснулся я лишь через несколько часов.
                ]];
            end
        end
    end,
    exit = function (s, to)
        if to == r_243 or to == r_232 or to == r_223 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


-- ---------------------------------------------------------------------------

r_241 = room
{
    nam = 'Порт',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = nil,
    east = nil,
    south = 'r_231',
    west = nil,
    pic = 'images/241.png',
    enter = function (s, from)
        set_music ('music/18_harbour.ogg');
        remove (black_case, inv());
        if from == r_200 or from == r_231 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 3;
            end
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = fasle;
            if s._visit == 1 then
                p [[Когда глайдер прибыл в порт, я вышел на пристань и
                осмотрелся.
                ]];
            end
            if s._visit == 2 then
                p [[В порту как всегда царила пассажирская суета.]];
            end
            if s._visit == 3 then
                p [[Я снова вернулся в порт.]];
            end
        end
        p [[Прямо напротив причала я увидел современное здание порта.
        Пассажиры прибывших глайдеров направлялись к зданию и скрывались
        за высокими стеклянными дверьми.
        ]];
    end,
    obj = { 'r_241_glider', 'r_241_port', 'r_241_doors' },
    rest = function (s)
        if s._rested == 0 then
            remove (r_241_glider, r_241);
            s._rested = 1;
            status_change (-18, -12, -10, 0, 0);
            if status._health == 0 then
                status_change (1, 0, 0, 0, 0);
            end
            p [[Я разместился на газоне перед входом в зал ожидания. Сколько
            прошло времени я не знаю, но проснулся я от того, что меня
            довольно грубо тряс за плечо артанг-полицейский.^
            «Ты, вставай! Здесь нельзя лежать!» — сказал он и чувствительно
            ударил меня по голове. Тут его кто-то окликнул, и он отошёл в
            сторону.
            ]];
            return;
        end
        if s._rested == 1 then
            walk (r_241_rest_end);
            return;
        end
    end,
    exit = function (s, to)
        if to == r_231 then
            if r_232_bar._captain_left_turns > 0 then
                r_232_bar._captain_left_turns = r_232_bar._captain_left_turns - 1;
            end
            if seen (r_241_glider) then
                remove (r_241_glider, r_241);
            end
            r_241_waiting_room._rested = 0;
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_241_biomask_off_end = room
{
    nam = 'Порт',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Как только я принял человеческий облик, ко мне сразу бросились
        несколько артангов-полицейских...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_241_glider = obj
{
    nam = 'глайдер',
    _examined = false,
    dsc = function (s)
        p 'В порту стоит {глайдер} на котором я прибыл в Пульсар.';
        return;
    end,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            p [[Пассажиры уже покинули глайдер. Последним вышел капитан и
            подошёл к служащему порта. «Отгоняйте глайдер в док», — сказал ему
            капитан.^После чего добавил: «А я с сегодняшнего дня в отпуске.
            Только отдохну немного в своём любимом баре и всё. Завтра лечу
            отдыхать на Пальские спутники». Капитан развернулся и пошёл к
            служебной стоянке автокрафтов.
            ]];
        else
            p [[Глайдер, на котором я прибыл в Пульсар.]];
        end
        return;
    end,
};


r_241_port = obj
{
    nam = 'здание порта',
    dsc = function (s)
        p 'Современное {здание порта} стоит напротив причала.';
        return;
    end,
    exam = function (s)
        r_241_doors:enable();
        p [[Большой современный порт. Сквозь стеклянные двери видна обычная
        пассажирская суета.
        ]];
        return;
    end,
};


r_241_doors = obj
{
    nam = 'двери',
    dsc = function (s)
        p [[Сквозь {стеклянные двери} здания порта видна обычная пассажирская
        суета.
        ]];
        return;
    end,
    exam = function (s)
        return 'Высокие стеклянные двери.';
    end,
    useit = function (s)
        walk (r_241_waiting_room);
        return;
    end,
}:disable();


r_241_waiting_room = room
{
    nam = 'Зал ожидания',
    _from_dream = false;
    pic = 'images/241_w_room.png',
    _rested = 0,
    _seen_dream = false,
    enter = function (s, from)
        if from == r_241_dream_3 then
            s._from_dream = true;
        else
            s._from_dream = false;
        end
    end,
    dsc = function (s)
        if not s._from_dream then
            p [[Я вошёл в зал ожидания. Здесь было полно народу. Кроме людей я
            заметил нескольких представителей инопланетных рас. Никто не
            обращал на меня внимания.
            ]];
        else
            p [[Вокруг всё было по-прежнему: суетились пассажиры, важно
            прохаживались артанги-полицейские.
            ]];
        end
        return;
    end,
    obj = { 'r_241_room_doors' },
    rest = function (s)
        if r_232_bar._captain_left_turns > 0 then
            r_232_bar._captain_left_turns = r_232_bar._captain_left_turns - 1;
        end
        if s._rested == 0 then
            if s._seen_dream then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Я решил немного отдохнуть, нашёл свободное кресло и
                немного вздремнул. 
                ]];
                return;
            else
                remove (r_241_glider, r_241);
                s._rested = 1;
                s._seen_dream = true;
                status_change (2, 1, 1, 0, 0);
                walk (r_241_dream_1);
                return;
            end
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p [[Я решил немного отдохнуть, нашёл свободное кресло и
                немного вздремнул.
                ]];
                return;
            end
        end
    end,
};


r_241_room_doors = obj
{
    nam = 'двери',
    dsc = function (s)
        p [[Сквозь {стеклянные двери} здания порта видна обычная пассажирская
        суета.
        ]];
        return;
    end,
    exam = function (s)
        return 'Высокие стеклянные двери.';
    end,
    useit = function (s)
        walk (r_241);
        return;
    end,
};


r_241_dream_1 = room
{
    nam = 'Зал ожидания',
    hideinv = true,
    pic = 'images/241_w_room.png',
    dsc = function (s)
        p [[Я почувствовал, что страшно устал. Буквально свалившись в
        свободное мягкое кресло, я сразу же погрузился в глубокий сон...^
        Мне снилось, что я сижу за пультом истребителя «Сириус» и пытаюсь
        поймать в перекрестие прицела грузовой контейнер. Но пальцы плохо меня
        слушаются. В самый последний момент контейнер уплывает в сторону.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_241_dream_2') },
};


r_241_dream_2 = room
{
    nam = 'Зал ожидания',
    hideinv = true,
    pic = 'images/241_dream.png',
    dsc = function (s)
        p [[А рядом сидит мой отец и смеётся каким-то неприятным,
        демоническим смехом. Я поворачиваюсь к нему, чтобы что-то спросить,
        но он медленно растворяется в туманной пелене, заполнившей тесную
        кабину. Когда я снова смотрю на экран, то с ужасом вижу, что он пуст.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_241_dream_3') },
};


r_241_dream_3 = room
{
    nam = 'Зал ожидания',
    hideinv = true,
    pic = 'images/241_w_room.png',
    dsc = function (s)
        p 'Ледяные, колючие звёзды и пустота... Я проснулся в холодном поту.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_241_waiting_room') },
};



r_241_rest_end = room
{
    nam = 'Порт',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я прилёг на газон возле здания порта и задремал. Когда я открыл
        глаза, то обнаружил, что мои руки закованы в наручники. Рядом стояли
        артанги-полицейские...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_243 = room
{
    nam = 'КПП',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = nil,
    south = 'r_233',
    west = nil,
    pic = 'images/243.png',
    enter = function (s, from)
        s._rested = 0;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я несколько часов шёл по обочине дороги. Мегаполис Пульсар
            остался позади. Прямо по ходу, на севере я заметил
            контрольно-пропускной пункт. Возле будки с шлагбаумом стоял артанг
            с гравимётом. Он останавливал и проверял все автокрафты.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я стоял неподалёку от контрольно-пропускного пункта.
            Артанг-полицейский останавливал и проверял все выезжающие из
            города автокрафты.
            ]];
            return;
        end
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Расположившись на траве неподалёку от дороги, я немного
            вздремнул.
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p [[Расположившись на траве неподалёку от дороги, я немного
                вздремнул.
                ]];
                return;
            end
        end
    end,
    obj = { 'r_243_policeman' },
    exit = function (s, to)
        if to == r_233 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_243_policeman = obj
{
    nam = 'полицейский',
    dsc = function (s)
        p 'Возле будки с шлагбаумом стоял {артанг} с гравимётом.';
        return;
    end,
    exam = function (s)
        p 'Это был высокий жирный артанг. На груди у него висел гравимёт.';
        return;
    end,
    talk = function (s)
        p 'Похоже, что артанг не был расположен к разговорам.';
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (r_243_end);
            return;
        end
    end,
};


r_243_end = room
{
    nam = 'КПП',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я выхватил нейрохлыст и бросился к полицейскому. Тот среагировал
        быстро — волна узконаправленной гравитационной струи ударила мне прямо
        в лицо...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};

