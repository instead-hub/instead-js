tempor = room
{
    nam = '...',
    north = 'tempor',
    east = 'tempor',
    south = 'tempor',
    west = 'tempor',
    _visit = 0,
    _dest = 0,
    pic = function (s)
        if seen (clot) then
            return 'images/tempor_clot.png';
        end
        local p = s._visit%2;
        if s._visit == 1 then
            return 'images/tempor_fly.png';
        end
        if p == 0 then
            return 'images/tempor_desert_1.png';
        else
            return 'images/tempor_desert_2.png';
        end
    end,
    enter = function (s, from)
        local v = rnd (20);
        set_music ('music/32_tempor.ogg');
        if from == fly_fly_tempor_2 then
            s._visit = 1;
        end
        if from == tempor then
            objs():zap();
        end
        if s._dest == 5 then
            put (clot, tempor);
        end
        if from == tempor then
            s._visit = s._visit + 1;
            if v == 17 then
                walk (tempor_dwarfs);
                return;
            end
            if v == 18 then
                walk (tempor_lisa);
                return;
            end
            if v == 19 then
                walk (tempor_fly);
                return;
            end
        end
        if s._visit > 7 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вылез из шлюпки и осмотрелся. Вокруг меня простиралась
            безжизненная пустыня: потрескавшаяся земля и редкие колючие
            кустарники.
            ]];
        end
        if s._visit == 2 then
            p [[Я несколько часов шёл по мёртвой пустыне Темпора. Над
            растрескавшейся землёй, покрытой сухими колючками и лишайником, не
            было ни малейшего ветерка. Изредка я видел плотные туманные
            сгустки, которые медленно, словно призраки, перемещались над
            трещинами и сопками.
            ]];
        end
        if s._visit == 3 then
            p [[Прошло несколько часов, а я всё шёл и шёл по пустыне. Воздух
            здесь был тяжёлый, густой и горячий. Он при каждом вдохе обжигал
            мои лёгкие.
            ]];
        end
        if s._visit == 4 then
            p [[Пустыня Темпора поражала воображение своими размерами.
            Я слышал, что Зона простирается над всем южным полушарием Раккслы.
            Блуждать здеь можно было до бесконечности.
            ]];
        end
        if s._visit == 5 then
            p [[Снова и снова мимо меня проплывали странные туманные сгустки.
            Иногда казалось, что это разумные существа, которые живут здесь
            своей странной темпоральной жизнью.
            ]];
        end
        if s._visit == 6 then
            p [[Ещё несколько часов я шёл вдоль длинной глубокой трещины,
            изнутри покрытой мхом. Дышать было тяжело. Два белых сгустка
            медленно проплыли мимо меня. Один из них слегка коснулся моего
            плеча. Меня обдало холодом. Температура этих странных образований
            была много ниже нуля...
            ]];
        end
        if s._visit == 7 then
            p [[Мне показалось, что здесь нет ночей. И хотя небо над головой
            иногда темнело, Темпор светился изнутри. А может быть я, как и
            многие другие первопроходцы, так и останусь здесь навеки? Иногда я
            замечал занесённые песком человеческие кости...
            ]];
        end
        return;
    end,
    rest = function (s)
        walk (tempor_rest);
        return;
    end,
    obj =
    {
        'fly_tempor',
        'fly_hatch_tempor',
        'postsign'
    },
    exit = function (s, to)
        if to == tempor then
            if status._way == 'S' then
                if s._dest == 0 then
                    s._dest = 1;
                else
                    s._dest = 0;
                end
            end
            if status._way == 'N' then
                if s._dest == 1 then
                    s._dest = 2;
                else
                    if s._dest == 3 then
                        s._dest = 4;
                    else
                        s._dest = 0;
                    end
                end
            end
            if status._way == 'W' then
                if s._dest == 2 then
                    s._dest = 3;
                else
                    s._dest = 0;
                end
            end
            if status._way == 'E' then
                if s._dest == 4 then
                    s._dest = 5;
                else
                    s._dest = 0;
                end
            end
            remove (fly_tempor, tempor);
            remove (fly_hatch_tempor, tempor);
            remove (postsign, tempor);
            remove (clot, tempor);
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


fly_tempor = obj
{
    nam = 'шлюпка «Муха»',
    exam = function (s)
        return 'Одноместная воздушная шлюпка «Муха».';
    end,
};


postsign = obj
{
    nam = 'столб',
    exam = function (s)
        p [[На выцветшей табличке надпись: «Точка входа. Напряжённость поля —
        ноль.^Джон Мак^2467 год».^И чуть ниже дописано:^«Мы будем первыми!»
        ]];
        return;
    end,
};


fly_hatch_tempor = obj
{
    nam = 'люк «Мухи»',
    exam = function (s)
        return 'Люк одноместной воздушной шлюпки «Муха».';
    end,
    useit = function (s)
        if here() == tempor then
            walk (fly_cabin_tempor);
        else
            walk (tempor);
        end
        return;
    end,
};


tempor_rest = room
{
    nam = '...',
    hideinv = true,
    pic = function (s)
        return call(ref(from(s)),'pic');
    end,
    dsc = function (s)
        p [[Я разместился прямо на земле и решил немного отдохнуть. Меня стало
        клонить ко сну. Мне снился какой-то страшный сон, как будто я стою в
        окружении стаи сгустков, обжигающих меня своими ледяными
        прикосновениями. Я чувствовал, что замерзаю...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


clot = obj
{
    nam = 'сгусток',
    exam = function (s)
        p 'Огромный, просто гигантский сгусток, скорее похожий на торнадо.';
        return;
    end,
    useit = function (s)
        walk (tempor_final_1);
        return;
    end,
}:disable();



tempor_dwarfs = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/141.png',
    dsc = function (s)
        p [[Спустя какое-то время мимо меня прошли несколько карликов,
        вооружённых копьями и луками. Я проводил их взглядом, пока они не
        растворились в туманной пелене Темпора...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'tempor') },
};


tempor_lisa = room
{
    nam = '...',
    hideinv =true,
    pic = 'images/127a.png',
    dsc = function (s)
        p [[Неожиданно из тумана появился знакомый мне пейзаж. Посёлок для
        ссыльных, дом Лизы Тейлор, а у крыльца — сама старуха. Старая женщина
        смотрела на меня безучастно, казалось, она была погружена в свои
        мысли...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'tempor') },
};


tempor_fly = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/tempor_fly.png',
    dsc = function (s)
        p [[Через несколько часов я увидел перед собой свою шлюпку. Но как
        только я подошёл к ней ближе, она растаяла...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'tempor') },
};



fly_cabin_tempor = room
{
    nam = '«Муха»',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _rested = 0,
    pic = 'images/fly_cabin.png',
    dsc = function (s)
        return 'Я снова залез внутрь «Мухи».';
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов.';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                return 'Прошло несколько часов.';
            end
        end
    end,
    obj = { 'fly_hatch_tempor', 'fly_console_tempor' },
};


fly_console_tempor = obj
{
    nam = 'пульт',
    exam = function (s)
        put (fly_hole_tempor, fly_cabin_tempor);
        p [[На передней панели была щель для карточки электронного навигатора.
        ]];
        return;
    end,
    useit = function (s)
        p 'Система ориентации неисправна. Полёт невозможен.';
        return;
    end,
};


fly_hole_tempor = obj
{
    nam = 'щель',
    exam = function (s)
        return 'Щель для карточки электронного навигатора.';
    end,
};



tempor_final_1 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/tempor_clot.png',
    enter = function (s)
        set_music ('music/01_intro.ogg');
    end,
    dsc = function (s)
        p 'Пожелав себе удачи, я шагнул в неизведанное...';
        return;
    end,
    obj = { vway('1', '{Далее}', 'tempor_final_2') },
};


tempor_final_2 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/final.png',
    obj = { vway('1', '{Далее}', 'tempor_final_3') },
};


tempor_final_3 = room
{
    nam = '...',
    hideinv = true,
    dsc = function (s)
        p [[Поздравляю!!! Вы только что с блеском прошли игру «Звёздное
        Наследие. Часть 1. «Чёрная Кобра»».^Главный герой под вашим
        руководством прошёл все испытания и теперь направляется в Иную
        Вселенную.^О том, что же было дальше, можно было бы узнать из игры
        «Звёздное Наследие. Часть 2. По ту сторону Вселенной». Однако, к
        сожалению, вторая часть игры до сих пор не была выпущена.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'tempor_final_4') },
};


tempor_final_4 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/146b.png',
    dsc = function (s)
        p [[Перенос игры на платформу INSTEAD (2009-2012 годы) —
        Вадим В. Балашов^vvb.backup@rambler.ru^^
        Надеюсь, Вам понравилось играть в «Звёздное Наследие».
        ]];
        return;
    end,
};

