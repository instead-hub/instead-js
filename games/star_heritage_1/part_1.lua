i101 = room
{
    nam = 'Предисловие',
    hideinv = true,
    pic = 'images/intro.gif',
    way =
    {
        vroom ('Назад', 'main'),
        vroom ('ДАЛЕЕ', 'r_111')
    },
    exit = function (s, to)
        if (to == r_111) then
            me().obj:add(status);
            put (compass, me());
            put ('n', me());
            put ('s', me());
            put ('e', me());
            put ('w', me());
            actions_init();
            lifeon(status);

            put (medallion, i101);
            take (medallion);
            status_change (1, 1, 1, 1, 1);
            set_music ('music/03_walk_on_unknown_planet.ogg');
        end
    end,
};


-- ----------------------------------------------------------------------

cocoon = obj
{
    nam = 'кокон',
    weight = 101,
    exam = function (s)
        return 'Это амортизационный кокон.';
    end,
    take = function (s)
    end,
};


life_boat = obj
{
    nam = 'шлюпка',
    weight = 101,
    _examined = false,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            battery:enable();
            computer:enable();
            if battery._locked then
                p [[В шлюпке я увидел микроаккумулятор, подключённый к
                бортовому компьютеру.
                ]];
            else
                p 'В шлюпке я увидел бортовой компьютер.';
            end
        else
            p 'В шлюпке я увидел бортовой компьютер.';
        end
        return;
    end,
    take = function (s)
    end,
    obj = { 'battery', 'computer' },
};


battery = obj
{
    nam = 'аккумулятор',
    _locked = true,
    exam = '«Артанг Великий. Универсальное зарядное устройство».',
    used = function (s, w)
        if w == glass then
            if s._locked then
                if have ('glass') then
                    s._locked = false;
                    computer._power = false;
                    p 'Я отсоединил аккумулятор от бортовой панели.';
                else
                    p 'У меня нет стекла.';
                end
            else
                p 'Я уже отсоединил аккумулятор.';
            end
        end
        return;
    end,
    take = function (s)
        if s._locked then
            p 'Аккумулятор застрял в деформированной панели.';
            return false;
        else
            p 'Я взял аккумулятор.';
            return;
        end
    end,
}: disable();


computer = obj
{
    nam = 'компьютер',
    _power = true,
    _ready = false,
    exam = function (s)
        if s._power then
            p 'Кажется, бортовой компьютер ещё функционирует.';
        else
            p 'Компьютер не работает.';
        end
        return;
    end,
    useit = function (s)
        if s._power then
            if s._ready then
                p 'Компьютер уже готов к работе.';
            else
                s._ready = true;
                p [[Я прикоснулся к чувствительным сенсорам.
                «Готов», — отозвался компьютер на артангском языке.
                ]];
            end
        else
            p 'Компьютер без аккумулятора не работает.';
        end
        return;
    end,
    talk = function (s)
        if s._power and s._ready then
            walk (computer_dlg);
        else
            p [[Не получается.]];
        end
        return;
    end,
}:disable();


computer_dlg = dlg
{
    nam = function (s)
        return call(from(),'nam');
    end,
    hideinv = true,
    pic = function (s)
        return call(from(),'pic');
    end,
    phr =
    {
        {
            always = true,
            [[Где я нахожусь?]],
            [[Планетная система в справочнике не обнаружена.]]
        };
        {
            always = true,
            [[Статус бортовой системы?]],
            [[Обнаружены фатальные неисправности в системе жизнеобеспечения.]]
        };
        {
            always = true,
            [[Пеленговать местные источники радиосигналов.]],
            [[На северо-востоке зарегистрирован неопознанный источник
            радиосигналов.
            ]]
        };
        {
            [[Прошу оказать первую помощь.]],
            [[На панели компьютера что-то щёлкнуло и распахнулись створки
            миниатюрного шкафчика, встроенного в панель. На полке лежала
            ампула.
            ]],
            [[ampoule:enable();]]
        };
        {
            always = true,
            [[Выйти.]], 
            nil,
            [[ back(); ]]
        };
    },
};


medallion = obj
{
    nam = 'медальон',
    exam = function (s)
        p [[Отец подарил мне этот медальон в день моего первого вылета.
        На медальоне изображён наш семейный герб.
        ]];
        return;
    end,
    take = function (s)
        return 'Взял.';
    end,
    drop = function (s)
        return 'Бросил.';
    end,
};


ampoule = obj
{
    nam = 'ампула',
    exam = '«Жидкий асналвил».',
    take = function (s)
        return 'Взял.';
    end,
    drop = function (s)
        return 'Бросил.';
    end,
    useit = function (s)
        status_change (23, 18, 15, 0, 0);
        drop (s);
        remove (s);
        set_music ('music/03_walk_on_unknown_planet.ogg');
        r_111._dark_mood = false;
        p [[Я отломил наконечник и выпил содержимое ампулы. Скоро я
        почувствовал себя значительно лучше.
        ]];
        return;
    end,
}:disable();


r_111 = room
{
    nam = 'Место крушения шлюпки',
    north = 'r_121',
    east = 'r_112',
    south = nil,
    west = nil,
    pic = 'images/111.png',
    _dark_mood = true,
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    _beginning = true,
    enter = function (s, from)
        if s._dark_mood then
            set_music ('music/10_island_o.ogg');
        else
            set_music ('music/03_walk_on_unknown_planet.ogg');
        end
        if from == i101 then
            s._beginning = true;
        else
            s._beginning = false;
        end
        if from == i101 or from == r_121 or from == r_112 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Посадка была жёсткой, спасательная шлюпка врезалась в
                отвесный склон скалы и раскололась. Укутанный в
                амортизационный кокон, я скатился по склону в заросли
                колючего кустарника.^
                Несколько минут я лежал неподвижно. Всё тело ныло. Дышать
                было тяжело. С трудом освободившись от кокона, я поднялся на
                ноги. Меня мутило и шатало, но, как ни странно, руки и ноги
                были целы.^
                Я смотрелся. С запада и с юга половину неба закрывали отвесные
                серо-зелёные скалы. На востоке простирались болота.
                Далеко на севере темнела полоска леса.
                ]];
            end
            if s._visit == 2 then
                p [[Прошло несколько часов. Я вновь оказался на том самом
                месте, где упала моя шлюпка.
                ]];
            end
        else
            p [[С запада и с юга половину неба закрывали отвесные серо-зелёные
            скалы. На востоке простирались болота. Далеко на севере темнела
            полоска леса.
            ]];
        end
        return;
    end,
    obj =
    {
        'cocoon',
        'life_boat',
        'ampoule'
    },
    rest = function (s)
        if s._beginning then
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Ещё несколько часов я отлёживался на огромном плоском
                валуне, нагретом местным солнцем.
                ]];
                return;
            end
            if s._rested == 1 then
                s._rested = 2;
                status_change (-2, -1, -1, 0, 0);
                p [[Я не заметил как стемнело. Стало холодно и я закутался в
                остатки своего амортизационного кокона. Где-то громко
                прокричала ночная птица и гулкое эхо её крика прокатилось
                над скалами.
                ]];
                return;
            end
            if s._rested == 2 then
                walk (r_111_rest_end);
            end
            return;
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Я расположился на знакомом мне валуне. Время летело
                незаметно...
                ]];
                return;
            end
            if s._rested == 1 or s._rested == 2 then
                s._rested = 2;
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                else
                    status_change (-2, -1, -1, 0, 0);
                    p [[Прошло несколько часов. Я отдыхал и ни о чём не
                    думал...
                    ]];
                end
                return;
            end
        end
    end,
    exit = function (s, to)
        if to == r_121 or to == r_112 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_111_rest_end = room
{
    nam = 'Болото',
    hideinv = true,
    pic = 'images/111.png',
    dsc = function (s)
        p [[Ночь пролетела незаметно. К утру я окончательно замёрз.
        Совсем рядом, прямо у моего уха, прорычал какой-то хищник.
        Обернуться я уже не успел...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_112 = room
{
    nam = 'Болото',
    north = nil,
    east = 'r_113',
    south = nil,
    west = 'r_111',
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/112.png',
    enter = function (s, from)
        set_music ('music/05_rays_of_rising_sun.ogg');
        s._rested = 0;
        if not status._dead then
            if status._clock == NIGHT then
                walk (r_112_113_end);
            end
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
        return;
    end,
    dsc = function (s)
        if s._just_enter then
            s._jsut_enter = false;
            if s._visit == 1 then
                p [[Болото, к которому я направился, простиралось далеко на
                восток. Севернее, в туманной дымке, до самого горизонта
                распростёрлись мутные воды умирающего озера. На юге всё так
                же тянулась гряда отвесных скал.
                ]];
            end
            if s._visit == 2 then
                p [[Я шёл по болоту, которое распростёрлось с востока на
                запад. С юга, почти вплотную к болоту подступали скалы.
                На севере блестело и переливалось в солнечных лучах умирающее
                озеро.
                ]];
            end
        else
            p [[Болото простиралось далеко на восток. Севернее, в туманной
            дымке, до самого горизонта распростёрлись мутные воды умирающего
            озера. На юге всё так же тянулась гряда отвесных скал.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Я выбрал место посуше и решил немного отдохнуть.';
        else
            status_change (-1, -1, -1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        return;
    end,
    exit = function (s, to)
        if to == r_111 or to == r_113 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_112_113_end = room
{
    nam = 'Болото',
    _f = '112',
    hideinv = true,
    enter = function (s, from)
        if from == r_112 then
            s._f = '112';
        else
            s._f = '113';
        end
    end,
    pic = function (s)
        if s._f == '112' then
            return 'images/112.png';
        else
            return 'images/113.png';
        end
    end,
    dsc = function (s)
        p [[Идти ночью приходилось очень осторожно. Внезапно я провалился в
        глубокую яму, до краёв заполненную вонючей водой. Холодные волны
        сомкнулись над моей головой...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_113 = room
{
    nam = 'Болото',
    north = nil,
    east = 'r_114',
    south = nil,
    west = 'r_112',
    _monster = true,
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/113.png',
    enter = function (s, from)
        set_music ('music/05_rays_of_rising_sun.ogg');
        if from == r_112 or from == r_114 then
            s._rested = 0;
        end
        if not status._dead then
            if s._monster then
                s._monster = false;
                walk (r_113_attack);
                return;
            end
            if status._clock == NIGHT then
                walk (r_112_113_end);
                return;
            end
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
        return;
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[После битвы с чудищем я долго не мог придти в себя.
                Слава Богу, что всё закончилось благополучно. Я огляделся по
                сторонам.
                ]];
            end
            if s._visit == 2 then
                p [[Болото поражало своими размерами. Но я здесь уже хорошо
                ориентировался.
                ]];
            end
        else
            p [[Местный пейзаж не отличался разнообразием. Но на востоке,
            кажется, я заметил какие-то постройки.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Я выбрал место посуше и решил немного отдохнуть.';
        else
            status_change (-1, -1, -1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        return;
    end,
    exit = function (s, to)
        if to == r_112 or to == r_114 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_113_attack = room
{
    nam = 'Болото',
    hideinv = true,
    pic = 'images/113_attack.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Неожиданно из мутных вод появилось какое-то странное существо.
        Я однажды уже видел на одной планете нечто похожее.
        Клыкастый водяной с рыбьим хвостом сразу атаковал меня.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_113') },
};


r_114 = room
{
    nam = 'Тропинка',
    north = 'r_124',
    east = 'r_115',
    south = nil,
    west = 'r_113',
    _monster = true;
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/114.png',
    enter = function (s, from)
        set_music ('music/05_rays_of_rising_sun.ogg');
        if from == r_124 or from == r_113 or from == r_115 then
            s._rested = 0;
        end
        if not status._dead then
            if status._clock == NIGHT then
                if s._monster then
                    s._monster = false;
                    walk (r_114_attack);
                    return;
                end
            end
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Болото осталось позади. Я вышел на заросшее травой поле.
                Теперь я отчётливо видел на востоке непонятные металлические
                конструкции. На юге по-прежнему тянулась гряда отвесных скал.
                На севере я с удивлением обнаружил невзрачную тропинку,
                пролегавшую сквозь болотные топи.
                ]];
            end
            if s._visit == 2 then
                p [[Мне показалось, что я здесь уже проходил однажды.
                С юга меня окружали скалы, на западе распростёрлись болота,
                а на севере куда-то вдаль уходила еле заметная тропинка.
                ]];
            end
        else
            p [[На востоке были видны непонятные металлические конструкции.
            На юге по-прежнему тянулась гряда отвесных скал. На севере я
            обнаружил невзрачную тропинку, пролегавшую сквозь болотные топи.
            ]];
        end
        return;
    end,
    rest = function (s)
        if status._clock == NIGHT then
            if s._monster then
                s._monster = false;
                walk (r_114_attack);
            end
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Отдохнуть здесь можно было без проблем. Тёплый ветер с
                востока приносил запахи моря. Я был уверен, что море совсем
                рядом.
                ]];
            else
                status_change (-1, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_124 or to == r_113 or to == r_115 then
            s._monster = true;
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_114_attack = room
{
    nam = 'Тропинка',
    hideinv = true,
    pic = 'images/114_attack.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Ночь выдалась на редкость тёмной. Я слишком поздно заметил, что
        надо мной кружит целая стая ночных птиц. Едва я поднял свой взор к
        небу, как крылатые хищники набросились на меня...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_114') },
    exit = function (s, to)
        p [[Кое-как мне удалось отбиться от крылатых хищников. Пара огромных
        птиц после битвы осталась лежать на траве. Быстро рассветало.
        Я чувствовал себя разбитым и уставшим. Начинался новый день.
        ]];
        return;
    end,
};


r_115 = room
{
    nam = 'Заброшенный завод',
    north = nil,
    east = 'r_116',
    south = nil,
    west = 'r_114',
    _visit = 0,
    _just_enter = true,
    _rested = 0;
    pic = 'images/115.png',
    enter = function (s, from)
        set_music ('music/10_island_o.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 3 then
            s._visit = 3;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я стоял на территории какого-то древнего заброшенного
                завода. Здесь всё заросло травой. Часть построек была
                разрушена. Повсюду валялись ржавые трубы, прогнившие
                деревянные ящики и осколки битого стекла.
                ]];
            end
            if s._visit == 2 then
                p [[Проходя мимо завода, я ещё раз внимательно осмотрел
                немногочисленные остатки металлических сооружений. Очень
                похоже, что на этом заводе в своё время производили оружие.
                Об этом говорили разбросанные повсюду ржавые детали древних
                лазерных установок и ракетниц.
                ]];
            end
            if s._visit == 3 then
                p [[Я прошёл мимо старого военного завода. Здесь было тихо и
                неуютно. Лёгкий ветер гонял по земле обрывки бумаги и
                пожелтевшего пластика.
                ]];
            end
        else
            p [[С севера завод окружали скалы, на юг тянулись болота.]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Я прилёг на траву и немного вздремнул.';
        else
            status_change (-1, -1, -1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
    end,
    exit = function (s, to)
        if to == r_114 or to == r_116 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_116 = room
{
    nam = 'Тупик',
    north = nil,
    east = nil,
    south = nil,
    west = 'r_115',
    _visit = 0,
    _just_enter = true,
    _rested = 0;
    pic = function (s)
        if plate._moved then
            return 'images/116_moved.png';
        end
        if plate._burned then
            return 'images/116_burned.png';
        end
        return 'images/116.png';
    end,
    enter = function (s, from)
        set_music ('music/10_island_o.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я вплотную приблизился к скалам, окружающим заброшенный
                завод. Ни на восток, ни на юг я пройти уже не мог. На севере
                отвесной стеной также стояли неприступные скалы. У подножия
                одной из скал лежал лист железа, видимо занесённый сюда
                сильным ветром с территории завода.
                ]];
            end
            if s._visit == 2 then
                p [[Ничего не изменилось здесь со времени моего последнего
                посещения. Серые скалы нависали надо мной со всех сторон.
                На западе я видел ангары заброшенного завода.
                ]];
            end
        else
            p [[Серые скалы нависали надо мной со всех сторон. На западе я
            видел ангары заброшенного завода.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Это место было хорошо защищено со всех сторон скалами,
            и я решил немного расслабиться и отдохнуть.
            ]];
        else
            status_change (-1, -1, -1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        return;
    end,
    obj = { 'plate' },
    exit = function (s, to)
        if to == r_115 or to == r_128 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


plate = obj
{
    nam = 'лист железа',
    _burned = false,
    _moved = false,
    weight = 100,
    exam = function (s)
        if s._burned then
            p 'Лист металла с большой дырой.';
        else
            p 'Большой лист металла.';
        end
        return;
    end,
    take = function (s)
        if ( have(blaster) or have(neurowhip) ) then
            p 'Слишком тяжело!';
            return false;
        else
            if s._moved or s._burned then
                p 'Лист железа мне больше не мешает.';
                return false;
            else
                s._moved = true;
                put (plate_enter, r116);
                p [[Немного приподняв и отодвинув в сторону тяжёлую железяку,
                я с удивлением обнаружил под ней вход в подземелье.
                Загадочный туннель уходил под скалу...
                ]];
                return false;
            end
        end
    end,
    used = function (s, w)
        if w == blaster then
            if not have (blaster) then
                p 'У меня нет бластера.';
            else
                if s._moved or s._burned then
                    p 'Лист железа мне больше не мешает.';
                else
                    s._burned = true;
                    blaster._charged = false;
                    put (plate_enter, r116);
                    p [[Мне удалось вырезать в железяке большую дыру.
                    За ней я с удивлением обнаружил вход в подземелье.
                    Загадочный туннель уходил под скалу на север...
                    ]];
                end
            end
            return;
        end
    end,
    useit = function (s)
        return 'Каким образом?';
    end,
};


plate_enter = obj
{
    nam = 'вход в туннель',
    exam = function (s)
        return 'Загадочный туннель уходил под скалу.';
    end,
    useit = function (s)
        clock_next ();
        if status._health == 1 then
            health_finish._from = deref(here());
            status_change (-2, -1, -1, 0, 0);
            walk (health_finish);
        else
            walk (r_128);
        end
        return;
    end,
};


r_117 = room
{
    nam = 'Причал',
    north = 'r_127',
    east = nil,
    south = nil,
    west = nil,
    _just_enter = true,
    _talked = false,
    pic = 'images/117.png',
    enter = function (s, from)
        set_music ('music/10_island_o.ogg');
        if not status._biomask then
            walk (r_117_end);
            return;
        end
        s._just_enter = true;
    end,
    dsc = function (s)
        p [[Я спокойно прошёл мимо патрульного автомобиля артангов.
        Один из артангов даже поприветствовал меня, приняв за своего.
        У причала порта стоял глайдер.
        У входа глайдера капитан проверял пропуска у пассажиров.
        ]];
        return;
    end,
    rest = function (s)
        walk (r_117_rest);
        return;
    end,
    obj =
    {
        'r_117_minimobile',
        'r_117_glider',
        'r_117_captain'
    },
    exit = function (s, to)
        if to == r_127 or to == r_198 then
            clock_next ();
        end
    end,
};


r_117_minimobile = obj
{
    nam = 'автомобиль',
    exam = function (s)
        return 'Военный минимобиль с дюжиной артангов.';
    end,
};


r_117_glider = obj
{
    nam = 'глайдер',
    exam = function (s)
        return 'Современный скоростной морской глайдер.';
    end,
};


r_117_captain = obj
{
    nam = 'капитан',
    exam = function (s)
        p [[Капитану было не больше сорока. Но несмотря на свой возраст,
        он выглядел опытным, закалённым в передрягах морским волком.
        Странно, что такой человек работал на артангов.
        ]];
        return;
    end,
    talk = function (s)
        if r_117._talked then
            p 'Я уже поговорил с капитаном.';
        else
            walk (r_117_captain_dlg);
        end
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (r_117_neurowhip);
            return;
        end
    end,
    accept = function (s, w)
        if w == glider_ticket then
            if r_117._talked then
                walk (r_198);
            else
                p 'Сначала необходимо поговорить с капитаном.';
            end
            return;
        end
    end,
};


r_117_captain_dlg = dlg
{
    nam = 'Причал',
    hideinv = true;
    pic = 'images/117.png',
    phr =
    {
        {
            1,
            [[Куда следует этот глайдер? (Произнести на языке артангов).]],
            [[Я заметил как капитан поморщился и нехотя ответил: «До
            Пульсара».]],
            [[poff (1,2);]]
        };
        {
            2,
            [[Куда идёт глайдер?]],
            nil,
            [[
            poff (1,2);
            walk (r_117_biomask_off_end);
            return;
            ]]
        };
    },
    exit = function (s, t)
        r_117._talked = true;
    end,
};


r_117_rest = room
{
    nam = 'Причал',
    hideinv = true,
    pic = 'images/minimobile.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я почувствовал себя неважно и решил немного вздремнуть. Через
        какое-то время я проснулся и увидел, что рядом стоит минимобиль
        артангов. «Предъявите документы!» — сказал офицер. Я попытался
        выхватить оружие, но было поздно: гравимёты артангов уже успели
        сказать своё веское слово...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_117_end = room
{
    nam = 'Причал',
    hideinv = true,
    pic = 'images/minimobile.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Меня здесь уже ждали. У самого причала стояла патрульная машина
        артангов. Они сразу заметили меня.^
        Сопротивляться было бесполезно. Последнее, что я помню — яркая вспышка
        света прямо передо мной. Острая боль сковала всё тело.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_117_biomask_off_end = room
{
    nam = 'Причал',
    pic = 'images/minimobile.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Капитан удивлённо посмотрел на меня, и хотел было что-то сказать,
        как сзади я услышал: «Сюда, сюда! Это он! Он в биомаске!»...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_117_neurowhip = room
{
    nam = 'Причал',
    hideinv = true,
    pic = 'images/minimobile.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я выхватил оружие, но воспользоваться им не успел.
        Сзади прогремел выстрел. Стреляли из минимобиля артангов.
        Я рухнул к ногам капитана...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


-- ---------------------------------------------------------------------------

r_121 = room
{
    nam = 'Болото',
    north = 'r_131',
    east = nil,
    south = 'r_111',
    west = nil,
    _just_enter = true,
    _visit = 0,
    pic = 'images/121.png',
    enter = function (s, from)
        set_music ('music/04_eternity.ogg');
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 3 then
            s._visit = 3;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я пробирался сквозь кустарник на север. Жёсткие колючие
                ветки хлестали по лицу, но я не обращал на это внимания.
                Я торопился добраться до леса, который был уже недалеко.
                ]];
            end
            if s._visit == 2 then
                p [[На этот раз заросли кустарника я преодолевал довольно
                легко. По-моему, эти растения питались мясом местных мелких
                животных. На ветвях одного куста я заметил обглоданные кости
                мелкой птицы, запутавшейся в ветвях.
                ]];
            end
            if s._visit == 3 then
                p [[Эта местность мне была уже знакома. Заросли кустарника я
                проходил быстро и без осложнений.
                ]];
            end
        else
            p [[На севере был виден лес. К югу отсюда потерпела крушение
            моя шлюпка.
            ]];
        end
        return;
    end,
    rest = function (s)
        walk (r_121_rest);
        return;
    end,
    exit = function (s, to)
        if to == r_131 or to == r_111 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_121_rest = room
{
    nam = 'Болото',
    hideinv = true,
    pic = 'images/121.png',
    enter = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я выбрал небольшую полянку, чтобы немного перевести дух.
        Воздух здесь был наполнен дурманящими запахами цветов,
        растущих неподалёку. Меня стало клонить ко сну.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_121_rest2') },
};


r_121_rest2 = room
{
    nam = 'Болото',
    hideinv = true,
    pic = 'images/121_rest.png',
    dsc = function (s)
        p [[Когда я пришёл в себя, всё мое тело обволакивали длинные колючие
        ветви куста, возле которого я прилёг. Я не мог пошевелить даже
        пальцем. Куст-кровопиец, присосавшись ветвями к моему телу, пил мою
        кровь...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_122 = room
{
    nam = 'Скала',
    north = nil,
    east = 'r_123',
    south = nil,
    west = nil,
    _just_enter = true,
    _visit = 0,
    _rested = 0,
    pic = 'images/122.png',
    enter = function (s, from)
        set_music ('music/12_dreams_about_planet_laiv.ogg');
        if from == r_123 then
            s._rested = 0;
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я стоял возле небольшой одинокой скалы, окружённой
                болотными топями. Здесь было тихо и, кажется, безопасно.
                ]];
            end
            if s._visit == 2 then
                p [[Я стоял возле знакомой уже мне одинокой скалы. Вокруг
                простирались болота. Единственная дорога, по которой я сюда
                пришёл, вела на восток.
                ]];
            end
        else
            p [[Я стоял возле знакомой уже мне одинокой скалы. Вокруг
            простирались болота. Единственная дорога, по которой я сюда
            пришёл, вела на восток.
            ]];
        end
        return;
    end,
    obj = { 'rock' },
    rest = function (s)
        rock_enter:disable();
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_123 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


rock = obj
{
    nam = 'скала',
    exam = function (s)
        if status._clock == DAY then
            rock_enter:enable();
            p 'У самого подножия скалы я заметил вход в пещеру.';
        else
            rock_enter:disable();
            p 'Осмотрев скалу, я не заметил ничего необычного.';
        end
        return;
    end,
    obj = { 'rock_enter' },
};


rock_enter = obj
{
    nam = 'вход в пещеру',
    exam = function (s)
        return 'Вход вёл в пещеру.';
    end,
    useit = function (s)
        walk (r_122_inside);
        return;
    end,
}:disable();


r_122_inside = room
{
    nam = 'Пещера',
    _just_enter = true,
    _passwd = false,
    pic = function (s)
        if s._passwd then
            return 'images/122d.png';
        else
            return 'images/122b.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/12_dreams_about_planet_laiv.ogg');
        if from == r_122 then
            put (cave_exit, r_122_inside);
        end
        if from == r_122_terminal_3 then
            s._just_enter = false;
        else
            s._just_enter = true;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s.just_enter = false;
            p [[Я вошёл в пещеру. Здесь было довольно сухо.]];
        else
            p [[В пещере было довольно сухо.]];
        end
        p [[Видимо раньше здесь кто-то жил. Но теперь от следов бывшего жилища
        не осталось и следа. Однако в глубине пещеры я увидел встроенный в
        стену терминал.
        ]];
        return;
    end,
    rest = function (s)
        if status._clock == DAY then
            put (cave_exit, r_122_inside);
        else
            remove (cave_exit, r_122_inside);
        end
        if r_122._rested == 0 then
            r_122._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    obj = { 'terminal' },
    exit = function (s, to)
        if to == r_122 then
            remove (cave_exit, r_122_inside);
        end
    end,
};


terminal = obj
{
    nam = 'терминал',
    exam = function (s)
        p [[Терминал с борта устаревшей модели «Кобра-МК3». На панели под
        терминалом была узкая щель.
        ]];
        return;
    end,
    useit = function (s)
        return '???';
    end,
    used = function (s, w)
        if w == jamesons_plastic then
            walk (r_122_terminal);
            return;
        end
    end,
};


cave_exit = obj
{
    nam = 'выход из пещеры',
    exam = function (s)
        p [[Похоже, что вход в пещеру открывается какими-то странными
        механизмами.
        ]];
        return;
    end,
    useit = function (s)
        walk (r_122);
        return;
    end,
};


r_122_terminal = room
{
    nam = 'Пещера',
    hideinv = true,
    pic = 'images/122c.png',
    dsc = function (s)
        p [[Я вставил кусок пластика в щель под терминалом. Экран засветился
        мягким зеленоватым светом.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_122_terminal_1') },
};


r_122_terminal_1 = room
{
    nam = 'Пещера',
    hideinv = true,
    _key_pressed = 0,
    _passwd = 0,
    pic = 'images/122c.png',
    dsc = function (s)
        return 'Через мгновение вспыхнула надпись «Введите пароль:».';
    end,
    act = function (s, w)
        s._key_pressed = s._key_pressed + 1;
        if s._key_pressed == 5 then
            walk (r_122_terminal_end);
            return;
        end
        if w == "1" then
            if s._passwd == 1 then
                s._passwd = s._passwd + 1;
            end
            return 'Я нажал клавишу А.';
        end
        if w == "2" then
            return 'Я нажал клавишу Б.';
        end
        if w == "3" then
            return 'Я нажал клавишу В.';
        end
        if w == "4" then
            return 'Я нажал клавишу Г.';
        end
        if w == "5" then
            return 'Я нажал клавишу Д.';
        end
        if w == "6" then
            return 'Я нажал клавишу Е.';
        end
        if w == "7" then
            return 'Я нажал клавишу Ё.';
        end
        if w == "8" then
            return 'Я нажал клавишу Ж.';
        end
        if w == "9" then
            return 'Я нажал клавишу З.';
        end
        if w == "10" then
            return 'Я нажал клавишу И.';
        end
        if w == "11" then
            return 'Я нажал клавишу Й.';
        end
        if w == "12" then
            return 'Я нажал клавишу К.';
        end
        if w == "13" then
            return 'Я нажал клавишу Л.';
        end
        if w == "14" then
            if s._passwd == 2 then
                s._passwd = s._passwd + 1;
            end
            return 'Я нажал клавишу М.';
        end
        if w == "15" then
            return 'Я нажал клавишу Н.';
        end
        if w == "16" then
            return 'Я нажал клавишу О.';
        end
        if w == "17" then
            return 'Я нажал клавишу П.';
        end
        if w == "18" then
            return 'Я нажал клавишу Р.';
        end
        if w == "19" then
            if s._passwd == 0 then
                s._passwd = s._passwd + 1;
            end
            return 'Я нажал клавишу С.';
        end
        if w == "20" then
            return 'Я нажал клавишу Т.';
        end
        if w == "21" then
            return 'Я нажал клавишу У.';
        end
        if w == "22" then
            return 'Я нажал клавишу Ф.';
        end
        if w == "23" then
            return 'Я нажал клавишу Х.';
        end
        if w == "24" then
            return 'Я нажал клавишу Ц.';
        end
        if w == "25" then
            return 'Я нажал клавишу Ч.';
        end
        if w == "26" then
            return 'Я нажал клавишу Ш.';
        end
        if w == "27" then
            return 'Я нажал клавишу Щ.';
        end
        if w == "28" then
            return 'Я нажал клавишу Ъ.';
        end
        if w == "29" then
            return 'Я нажал клавишу Ь.';
        end
        if w == "30" then
            return 'Я нажал клавишу Э.';
        end
        if w == "31" then
            return 'Я нажал клавишу Ю.';
        end
        if w == "32" then
            return 'Я нажал клавишу Я.';
        end
        if w == "33" then
            if s._passwd == 3 then
                walk (r_122_terminal_2);
                return;
            else
                walk (r_122_terminal_end);
                return;
            end
            p 'Я нажал клавишу [ввод].';
            return;
        end
    end,
    obj =
    {
        vobj ( "1",  "{А}"), vobj ( "2", " {Б}"), vobj ( "3", " {В}"),
        vobj ( "4", " {Г}"), vobj ( "5", " {Д}"), vobj ( "6", " {Е}"),
        vobj ( "7", " {Ё}"), vobj ( "8", " {Ж}"), vobj ( "9", " {З}"),
        vobj ("10", " {И}"), vobj ("11", " {Й}"), vobj ("12", " {К}"),
        vobj ("13", " {Л}"), vobj ("14", " {М}"), vobj ("15", " {Н}"),
        vobj ("16", " {О}"), vobj ("17", " {П}"), vobj ("18", " {Р}^"),
        vobj ("19", " {С}"), vobj ("20", " {Т}"), vobj ("21", " {У}"),
        vobj ("22", " {Ф}"), vobj ("23", " {Х}"), vobj ("24", " {Ц}"),
        vobj ("25", " {Ч}"), vobj ("26", " {Ш}"), vobj ("27", " {Щ}"),
        vobj ("28", " {Ъ}"), vobj ("29", " {Ь}"), vobj ("30", " {Э}"),
        vobj ("31", " {Ю}"), vobj ("32", " {Я}"), vobj ("33", " {[ввод]}")
    },
};


r_122_terminal_2 = room
{
    nam = 'Пещера',
    hideinv = true,
    pic = 'images/122c.png',
    dsc = function (s)
        p [[Я ввёл пароль. Экран на секунду погас, а когда засветился вновь,
        я прочитал:^
        «Незнакомец, здесь для тебя есть кое-что. Лига «Тёмного Колеса»
        надеется, что ты поможешь довести великое дело до конца. Футляр не
        открывай. Доставь его на материк по адресу: Мегаполис Таран, квартал
        324, бокс 12, Эдуард Скол. Удачи тебе!».
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_122_terminal_3') },
};


r_122_terminal_3 = room
{
    nam = 'Пещера',
    hideinv = true,
    pic = 'images/122d.png',
    dsc = function (s)
        r_122_inside._passwd = true;
        put (niche, r_122_inside);
        p 'Через минуту терминал отъехал в сторону, освободив нишу в стене.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_122_inside') },
};


r_122_terminal_end = room
{
    nam = 'Пещера',
    hideinv= true,
    pic = 'images/122b.png',
    dsc = function (s)
        p [[Я ввёл пароль. Экран погас. И когда мне показалось, что ничего
        особенного не произошло, вдруг послышался нарастающий гул.
        В следующую секунду пол ушёл из под ног, и я провалился в пропасть...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


niche = obj
{
    nam = 'ниша',
    weight = 0,
    exam = function (s)
        put (black_case, r_122_inside);
        put (biomask, r_122_inside);
        p 'В нише лежал небольшой чёрный футляр и биомаска.';
        return;
    end,
    useit = function (s)
        return 'Каким образом?';
    end,
};


biomask = obj
{
    nam = function (s)
        if status._biomask then
            p 'биомаска (*)';
        else
            p 'биомаска';
        end
        return;
    end,
    weight = 0,
    exam = function (s)
        p [[Великолепная биомаска, сделанная на высочайшем уровне по самым
        современным технологиям.
        ]];
        if status._biomask then
            p [[^Теперь, когда она одета, ни один артанг не мог бы сказать,
            что я — человек.
            ]];
        end
        return;
    end,
    take = function (s)
        return 'Я взял биомаску.';
    end,
    drop = function (s)
        if status._biomask then
            p 'Я должен сначала снять биомаску чтобы бросить её.';
            return false;
        else
            return 'Я бросил биомаску.';
        end
    end,
    useit = function (s)
        if here() == r_322 then
            walk (r_322_biomask_end);
            return;
        end
        if status._biomask then
            status._biomask = false;
            if here() == r_117 then
                walk (r_117_biomask_off_end);
                return;
            end
            if here() == r_147 then
                walk (r_147_biomask_off_end);
                return;
            end
            if here() == r_232 then
                walk (r_232_biomask_off_end);
                return;
            end
            if here() == r_232_bar then
                walk (r_232_bar_mask_off_1);
                return;
            end
            if here() == r_241 then
                walk (r_241_biomask_off_end);
                return;
            end
            return 'Я снял биомаску.';
        else
            status._biomask = true;
            if here() == r_241 or here() == r_232 then
                if here() == r_232 and kloreds._just_killed then
                    kloreds._just_killed = false;
                end
                p [[Улучив подходящий момент, я быстро одел биомаску. Никто,
                кажется, не обратил на меня внимания.
                ]];
            else
                p [[Я одел биомаску. Теперь ни один артанг не мог бы сказать,
                что я — человек.
                ]];
            end
            return;
        end
    end,
};


black_case = obj
{
    nam = 'футляр',
    weight = 0,
    exam = function (s)
        return 'Небольшой чёрный футляр.';
    end,
    take = function (s)
        return 'Я взял футляр.';
    end,
    drop = function (s)
        return 'Я бросил футляр.';
    end,
    useit = function (s)
        return 'Каким образом?';
    end,
};



r_123 = room
{
    nam = 'Дорога',
    north = nil,
    east = 'r_124',
    south = nil,
    west = 'r_122',
    _rested = 0,
    pic = 'images/123.png',
    enter = function (s, from)
        set_music ('music/12_dreams_about_planet_laiv.ogg');
        s._rested = 0;
    end,
    dsc = function (s)
        p [[Разбитая дорога петляла меж болотных топей. На западе, прямо из
        болота поднималась одинокая скала.
        ]];
        return;
    end,
    rest = function (s)
        if not status._biomask then
            walk (r_124_rest);
            return;
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
            if s._rested == 1 then
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                    return;
                else
                    status_change (-2, -1, -1, 0, 0);
                    p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
                end
            end
        end
    end,
    exit = function (s, to)
        if to == r_122 or to == r_124 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_124 = room
{
    nam = 'Дорога',
    north = nil,
    east = 'r_125',
    south = 'r_114',
    west = 'r_123',
    _just_enter = true,
    _visit = 0,
    _monster = true,
    _rested = 0,
    pic = 'images/124.png',
    enter = function (s, from)
        set_music ('music/12_dreams_about_planet_laiv.ogg');
        if not status._dead then
            if s._monster then
                s._monster = false;
                walk (r_124_attack);
                return;
            end
        end
        if from == r_124_attack_2 then
            s._visit = 0;
        end
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Враг был повержен. Мёртвое тело лежало возле моих ног.
                Я огляделся по сторонам. Севернее извилистой дороги тянулись
                непроходимые топи, на юг уходила тропинка, по которой я сюда
                пришёл.
                ]];
            end
            if s._visit == 2 then
                p [[Проходя мимо валявшегося у дороги трупа, изрядно
                обглоданного хищниками, я вновь вспомнил свою схватку с
                первым человеком, которого я встретил на этой планете.
                ]];
            end
        else
            p [[Севернее извилистой дороги тянулись непроходимые топи,
            на юг уходила тропинка, по которой я сюда пришёл.
            ]];
        end
        return;
    end,
    rest = function (s)
        if (not status._biomask) and status._clock == NIGHT then
            walk (r_124_rest);
            return;
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Расположившись в кустарнике у дороги, я решил немного
                отдохнуть.
                ]];
            else
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                else
                    status_change (-2, -1, -1, 0, 0);
                    p [[Прошло несколько часов. Я отдыхал и ни о чём не
                    думал...
                    ]];
                end
            end
            return;
        end
    end,
    obj = { 'stranger_corpse' },
    exit = function (s, to)
        if to == r_123 or to == r_114 or to == r_125 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_124_attack = room
{
    nam = 'Дорога',
    hideinv = true,
    pic = 'images/124_attack.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Не помню, сколько мне пришлось идти по заросшей тропинке сквозь
        болотные топи. Я вышел на дорогу, тянущуюся с запада на восток.
        Вдруг из зарослей кустарника вылез человек в военной форме и
        направился ко мне.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_124_attack_2') },
};


r_124_attack_2 = room
{
    nam = 'Дорога',
    hideinv = true,
    pic = 'images/124_attack_2.png',
    dsc = function (s)
        if have(neurowhip) and neurowhip._charged then
            p [[Я выхватил нейрохлыст и бросился на незнакомца.
            ]];
        else
            p [[Едва я открыл рот, чтобы поприветствовать первого человека,
            встретившегося мне на этой планете, как тот, не говоря ни слова,
            выхватил из кобуры бластер и выстрелил. Смертоносный луч ударил в
            мою грудь, и я рухнул на пыльную дорогу.
            ]];
        end
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_124') },
    exit = function (s, to)
        if have(neurowhip) and neurowhip._charged then
            walk (r_124);
        else
            walk (the_end);
        end
        return;
    end,
};


stranger_corpse = obj
{
    nam = 'труп',
    _examined = false,
    weight = 101,
    exam = function (s)
        if s._examined then
            p [[Ещё раз осмотрев труп незнакомца, я не нашёл ничего нового.
            ]];
        else
            s._examined = true;
            blaster:enable();
            credit_card:enable();
            p [[Убитый сжимал в руке бластер. Осмотрев незнакомца, я заметил
            у него в кармане кредитную карточку.
            ]];
        end
        return;
    end,
    take = function (s)
    end,
    obj =
    {
        'blaster',
        'credit_card'
    },
};


blaster = obj
{
    nam = 'бластер',
    _charged = true,
    weight = 0,
    exam = function (s)
        p [[Бластер многозарядный, с микроизлучателем системы Джонса.]];
        if not s._charged then
            p [[^Бластер разряжен.]];
        end
        return;
    end,
    take = function (s)
        return 'Я взял бластер.';
    end,
    drop = function (s)
        return 'Я бросил бластер.';
    end,
}:disable();


credit_card = obj
{
    nam = 'кредитка',
    weight = 0,
    exam = function (s)
        return '«Всепланетный коммерческий банк «Золотая Галактика»».';
    end,
    take = function (s)
        return 'Я взял кредитку.';
    end,
    drop = function (s)
        return 'Я бросил кредитку.';
    end,
}:disable();



r_124_rest = room
{
    nam = 'Дорога',
    hideinv = true,
    pic = 'images/minimobile.png',
    enter = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Силы были на исходе, и я, расположившись в кустарнике у дороги,
        решил немного отдохнуть.^Военный минимобиль появился так внезапно,
        что я ничего не успел предпринять. Связанного по рукам и ногам, меня
        затолкали в минимобиль.^«Тьипер ми ты расстрелят», — ухмыльнулся один
        из артангов.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_125 = room
{
    nam = 'Дорога',
    north = 'r_125_end',
    east = 'r_126',
    south = nil,
    west = 'r_124',
    _from_west = true,
    _rested = 0,
    pic = function (s)
        if s._from_west then
            return 'images/125a.png';
        else
            return 'images/125b.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/08_loneliness.ogg');
        s._rested = 0;
        if from == r_124 then
            s._from_west = true;
        else
            s._from_west = false;
        end
    end,
    dsc = function (s)
        p [[Дорога проходила возле самого берега озера, которое находилось
        на севере. На юге я по-прежнему видел бесконечные болотные топи.
        ]];
        return;
    end,
    rest = function (s)
        if (not status._biomask) then
            walk (r_124_rest);
            return;
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Расположившись в кустарнике у дороги, я решил немного
                отдохнуть.
                ]];
            else
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                else
                    status_change (-2, -1, -1, 0, 0);
                    p [[Прошло несколько часов. Я отдыхал и ни о чём не думал...
                    ]];
                end
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_124 or to == r_126 or to == r_125_end then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_125_end = room
{
    nam = 'Дорога',
    hideinv = true,
    pic = function (s)
        if r_125._from_west then
            return 'images/125a.png';
        else
            return 'images/125b.png';
        end
    end,
    dsc = function (s)
        p [[Мне показалось, что я смогу переплыть это озеро. Тем более,
        что полоска противоположного берега была хорошо видна.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_135_end') },
};


r_126 = room
{
    nam = 'Магистраль',
    north = 'r_136',
    east = 'r_127',
    south = nil,
    west = 'r_125',
    _just_enter = true,
    _visit = 0,
    _rested = 0,
    pic = 'images/126.png',
    enter = function (s, from)
        set_music ('music/08_loneliness.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            if s._just_enter then
                s._just_enter = false;
                p [[Дорога казалась бесконечной. Спустя какое-то время я
                заметил на востоке небольшой посёлок, к которому вела узкая
                просёлочная дорога.
                ]];
            else
                p [[На востоке я заметил небольшой посёлок, к которому вела
                узкая просёлочная дорога.
                ]];
            end
            p [[На юге, вплотную к дороге подступали непроходимые болота.
            На север уходила широкая, заросшая травой магистраль.
            ]];
        end
        if s._visit == 2 then
            if s._just_enter then
                s._just_enter = false;
                p [[Я стоял на знакомой уже мне развилке.
                ]];
            end
            p [[Широкая магистраль уходила на север. На востоке, у берега моря
            находился посёлок. На запад, в недра болот вела небольшая
            заброшенная дорога.
            ]];
        end
        return;
    end,
    rest = function (s)
        if (not status._biomask) then
            walk (r_126_rest);
            return;
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                p [[Расположившись в кустарнике у дороги, я решил немного
                отдохнуть.
                ]];
            else
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                else
                    status_change (-2, -1, -1, 0, 0);
                    p [[Прошло несколько часов. Я отдыхал и ни о чём не думал...
                    ]];
                end
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_125 or to == r_136 or to == r_127 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_126_rest = room
{
    nam = 'Магистраль',
    hideinv = true,
    pic = 'images/minimobile.png',
    enter = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Силы были на исходе, и я, расположившись в кустарнике у дороги,
        решил немного отдохнуть.^Военный минимобиль появился так внезапно,
        что я ничего не успел предпринять. Связанного по рукам и ногам,
        меня затолкали в минимобиль.^«Тьипер ми ты расстрелят», — ухмыльнулся
        один из артангов.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_127 = room
{
    nam = 'Посёлок',
    north = 'r_137',
    east = nil,
    south = 'r_117',
    west = 'r_126',
    _just_enter = true,
    _rested = 0,
    pic = function (s)
        if seen (lisa) then
            return 'images/127a.png';
        else
            return 'images/127b.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/09_lisa_taylor_theme.ogg');
        if status._clock == NIGHT then
            remove (lisa, r_127);
        else
            if not lisa._angry then
                put (lisa, r_127);
            end
        end
        if from == r_127c or from == r_127f then
            remove (lisa, r_127);
        end
        if r_122_inside._passwd then
        end
        s._just_enter = true;
        s._rested = 0;
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if status._clock == NIGHT then
                p [[Посёлок словно вымер. Я несколько минут бродил между
                домов, но так никого и не встретил.^
                ]];
            else
                if lisa._angry then
                    p [[Я в одиночестве стоял возле старого дома у дороги.^
                    ]];
                else
                    p [[Я подошёл к дому у дороги.]];
                    if seen (lisa) then
                        p [[У крыльца сидела старуха.]];
                    end
                    p [[^]];
                end
            end
        end
        p [[На востоке, сразу за посёлком, я видел берег моря, который
        тянулся с юга на север. На юге, у самых гор, я разглядел небольшой
        залив и причал.
        ]];
        return;
    end,
    rest = function (s)
        if not lisa._angry then
            put (lisa, r_127);
        end
        if status._clock == NIGHT then
            remove (lisa, r_127);
        end
        if r_122_inside._passwd then
--            objs(r_127):del(lisa);
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
    end,
    obj = { 'lisa_house' },
    exit = function (s, to)
        if to == r_126 or to == r_137 or to == r_117 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


lisa_house = obj
{
    nam = 'дом',
    weight = 101,
    exam = function (s)
        return 'Это дом.';
    end,
};


lisa = obj
{
    nam = 'старуха',
    _rest = false,
    _angry = false,
    exam = function (s)
        return 'Это старуха.';
    end,
    talk = function (s)
        if not s._rest then
            s._rest = true;
            walk (lisa_dlg_1);
            return;
        else
            if not status._biomask then
                p [[Я вежливо поздоровался с Лизой Тейлор.
                Старушка поприветствовала меня лёгким кивком головы и ничего
                не сказала.
                ]];
            else
                p [[Я попытался заговорить с Лизой, но она отвернулась.
                ]];
            end
            return;
        end
    end,
    accept = function (s, w)
        if w == bracelet then
            if not status._biomask then
                walk (r_127d);
                return;
            else
                p 'Я пытался заговорить с Лизой, но она отвернулась.';
                return false;
            end
        end
        p '— Я уже стара, мне ничего не нужно.';
        return false;
    end,
};


lisa_dlg_1 = dlg
{
    nam = 'Посёлок',
    hideinv = true,
    pic = 'images/127a.png',
    dsc = function (s)
        p [[Я подошёл к крыльцу. Старуха внимательно посмотрела на меня и
        ничего не сказала.]];
        return;
    end,
    phr =
    {
        {
            [[Здравствуйте! Вы не могли бы мне помочь?]], 
            [[Старуха ещё раз окинула меня изучающим взглядом и тихо спросила:^
            — А Вы откуда?
            ]];
            [[ pjump ('where_from'); ]]
        };
        {
            -- 2,
            [[Простите, как называется этот посёлок?]], 
            [[Старуха ещё раз окинула меня изучающим взглядом и тихо спросила:^
            — А Вы откуда?
            ]];
            [[ pjump ('where_from'); ]]
        };
        {
            -- 3,
            [[Скажите, где ближайший центр связи?]], 
            [[Старуха ещё раз окинула меня изучающим взглядом и тихо спросила:^
            — А Вы откуда?
            ]];
            [[ pjump ('where_from'); ]]
        };
        { },
        {
            tag = 'where_from',
            [[С неба!]],
            [[Старуха подняла морщинистое лицо к небу и что-то прошептала.
            Затем, не говоря ни слова, она развернулась и ушла в дом.
            Щёлкнул замок и воцарилась тишина.
            ]],
            [[poff (1,2,3); lisa._angry = true; objs(r_127):del(lisa); walk (r_127); return;]]
        };
        {
            [[С планеты Лейв. Понимаете, мой корабль потерпел крушение
            недалеко от вашей планеты.
            ]],
            [[Старушка при слове «Лейв» вздрогнула и с любопытством посмотрела
            на меня.^— У нас тут живёт один. — Сказала она. — Тоже с этой
            планеты. Он, наверное, будет очень рад Вас увидеть.^Знаете что,
            зайдите ко мне, отдохните, а потом я Вам покажу куда идти.
            ]],
            [[ pjump ('rest'); ]]
        };
        {
            [[Какая разница... Мне нужно выбраться отсюда.]],
            [[Старуха подняла морщинистое лицо к небу и что-то прошептала.
            Затем, не говоря ни слова, она развернулась и ушла в дом.
            Щёлкнул замок и воцарилась тишина.
            ]],
            [[poff(1,2,3); lisa._angry = true; objs(r_127):del(lisa); walk (r_127); return;]]
        };
        { },
        {
            tag = 'rest',
            [[Спасибо, я очень устал и рад буду отдохнуть у Вас.]],
            nil,
            [[ walk (r_127c); return; ]]
        };
        {
            [[Нет, спасибо, я пойду.]],
            [[Старуха подняла морщинистое лицо к небу и что-то прошептала.
            Затем, не говоря ни слова, она развернулась и ушла в дом.
            Щёлкнул замок и воцарилась тишина.
            ]],
            [[ lisa._angry = true; objs(r_127):del(lisa); back (); ]]
        };
    },
};



r_127c = room
{
    nam = 'Дом',
    hideinv = true,
    pic = 'images/127c.png',
    dsc = function (s)
        p [[Мы вошли в дом. Старушка накормила меня вкусным обедом. Пока я ел,
        она рассказала трагическую историю своей жизни.^
        Её звали Лиза Тейлор. Она родилась на планете Дисо. Мать и отец
        погибли в схватке с армадой кораблей таргонов когда она была ещё
        маленькой девочкой. После гибели родителей её взял к себе на корабль
        дед — Крис Тейлор. Он был знаменитым и очень богатым торговцем.^
        Лиза Тейлор двадцать два года летала вместе с ним, пока не открыла
        собственное дело. Потом они виделись очень редко. Однажды, в одну из
        таких встреч, незадолго до своей смерти, дед открыл ей семейную тайну:
        его отец — её прадед — был членом лиги «Тёмного Колеса».^
        Он пропал без вести в то время, когда первая волна кораблей артангов
        вторглась в пределы Центрального Союза. По некоторым данным, во время
        последнего вылета прадеда, на его корабле находились тонны золота,
        платины и драгоценных камней.^
        Целое состояние, на которое можно было купить половину галактики.
        Оставалось загадкой, кому и зачем предназначалось это богатство.
        Крис долго пытался найти хоть какие-то следы своего отца,
        но безрезультатно.^
        В память о великом предке, Крис Тейлор подарил Лизе семейную
        реликвию — лётный комбинезон своего отца. С тех пор Лиза и занялась
        поисками. Ей не давало покоя загадочное исчезновение прадеда. В своих
        догадках она связывала его возможную гибель с вторжением артангов.^
        Она предполагала, что следы прадеда надо искать на легендарной планете
        Ракксла. После долгих лет поисков она смогла выйти на людей, которые
        согласились переправить её на Раккслу. Но их корабль был арестован
        патрулём артангов.^
        Потом была одиночная камера, а когда исполнилось сто десять лет,
        артанги выслали её на этот остров... Рассказывая свою историю,
        старушка с опаской поглядывала в окно. С её слов артанги и здесь не
        дают покоя.^
        Поэтому она очень боится, что у неё могут найти постороннего
        человека.^
        На следующий день я покинул дом Лизы Тейлор. Перед этим старушка
        предложила мне выйти на магистраль и идти на север мимо озера,
        в лавку Джеймсона. За моей спиной быстро захлопнулась дверь.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_127') },
    exit = function (s, to)
        remove (lisa, r_127);
        lisa._rest = true;
        put (lisa_note, r_127c);
        take (lisa_note);
    end,
};


lisa_note = obj
{
    nam = 'записка',
    exam = function (s)
        p [[«Дорогой Джеймсон. Тот, кто передаст тебе эту записку — наш
        человек, помоги ему.^^Лиза Т.».
        ]];
        return;
    end,
    take = function (s)
        return 'Я взял записку.';
    end,
    drop = function (s)
        return 'Я бросил записку.';
    end,
};


glider_ticket = obj
{
    nam = 'пропуск',
    exam = function (s)
        return '«Пропуск на пассажирский глайдер до мегаполиса Пульсар».';
    end,
    take = function (s)
        return 'Я взял пропуск.';
    end,
    drop = function (s)
        return 'Я бросил пропуск.';
    end,
};


r_127d = room
{
    nam = 'Посёлок',
    hideinv = true,
    pic = 'images/127a.png',
    dsc = function (s)
        p [[Я отдал браслет старушке. Она повертела его в руках и тихо
        прошептала:^— Это браслет моего прадеда. Неужели ты нашёл его?...
        Спасибо тебе, странник. Подожди, я сейчас.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_127e') },
};


r_127e = room
{
    nam = 'Посёлок',
    hideinv = true,
    pic = 'images/127b.png',
    dsc = 'Она ушла в дом.',
    obj = { vway('1', '{Далее}', 'r_127f') },
};


r_127f = room
{
    nam = 'Посёлок',
    hideinv = true,
    pic = 'images/127a.png',
    dsc = function (s)
        p [[Через минуту старушка вернулась.^— Возьми это. Пригодится.
        — Сказала она и молча ушла в дом.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_127') },
    exit = function (s, to)
        drop (bracelet);
        remove (bracelet);
        put (glider_ticket, r_127f);
        take (glider_ticket);
        remove (lisa, r_127);
    end,
};



r_128 = room
{
    nam = 'Туннель',
    north = 'r_138',
    east = nil,
    south = 'r_116',
    west = nil,
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/128.png',
    enter = function (s, from)
        set_music ('music/06_sticky_fear.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я спустился вниз. Похоже, что этим туннелем уже давно
                никто не пользовался. Гигантскими сосульками с потолка
                свешивались сталактиты. Навстречу им поднимались огромные
                сталагмиты. Туннель тянулся с юга на север.
                ]];
            end
            if s._visit == 2 then
                p 'Мёртвую тишину туннеля нарушал лишь отзвук моих шагов.';
            end
        else
            p 'Туннель тянулся с юга на север.';
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Отдохнуть здесь можно было без проблем. Я расположился между
            двух сталагмитов и немного вздремнул.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_138 or to == r_116 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};



-- ---------------------------------------------------------------------------

r_131 = room
{
    nam = 'Лес',
    north = 'r_141',
    east = 'r_132',
    south = 'r_121',
    west = nil,
    _monster = true,
    _just_enter = true,
    _visit = 0,
    _rested = 0,
    pic = 'images/131.png',
    enter = function (s, from)
        set_music ('music/04_eternity.ogg');
        if from == r_141 or from == r_132 or from == r_121 then
            s._rested = 0;
        end
        if not status._dead then
            if s._monster then
                s._monster = false;
                walk (r_131_attack);
                return;
            end
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            -- if s._just_enter then
                -- s._just_enter = false;
                p [[Мой противник издал предсмертный крик и повалился на бок.
                Только теперь я мог внимательно рассмотреть его. Это была
                пантера невероятных размеров. Чёрная шерсть покрывала её
                сильное мускулистое тело. Я никак не мог поверить, что
                выиграл нелёгкую схватку.
                ]];
            -- end
        end
        if s._visit == 2 then
            -- if s._just_enter then
                -- s._just_enter = false;
                p [[Здесь всё было по-прежнему. Лесные обитатели вели свою,
                спрятанную от посторонних глаз жизнь. Мне приходилось обходить
                гигантские муравейники и поваленные ветром сухие деревья.
                ]];
            -- end
        end
    end,
    obj = { 'panther' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Выбрав безопасное место, я решил отдохнуть.';
        end
        if s._rested == 1 then
            status_change (-1, -1, -1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
    end,
    exit = function (s, to)
        if s._just_enter then
            s._just_enter = false;
        end
        if to == r_141 or to == r_132 or to == r_121 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


panther = obj
{
    nam = 'труп пантеры',
    weight = 101,
    exam = function (s)
        p [[Это была пантера невероятных размеров. Чёрная шерсть покрывала её
        сильное мускулистое тело. Я никак не мог поверить, что выиграл
        нелёгкую схватку.
        ]];
        return;
    end,
    take = function (s)
    end,
};


r_131_attack = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/131_attack.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Лес встретил меня шелестом листвы деревьев, клёкотом птиц и
        криками животных. Не успел я пройти и нескольких метров, как откуда-то
        сверху на меня прыгнула огромная чёрная кошка и впилась когтями в шею.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_131') },
};


r_132 = room
{
    nam = 'Лес',
    north = nil,
    east = 'r_133',
    south = nil,
    west = 'r_131',
    _just_enter = true,
    _visit = 0,
    _rested = 0;
    pic = function (s)
        if status._clock == NIGHT then
            return 'images/132_night.png';
        else
            return 'images/132.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/04_eternity.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[В этой части лес слегка поредел. Я мог идти здесь уже без
                особого труда.
                ]];
            end
            if s._visit == 2 then
                p [[В лесу было тихо. Воздух был наполнен необыкновенными
                сладкими запахами каких-то растений.
                ]];
            end
        else
            p [[На севере отвесной стеной стояли серые скалы. На юге
            вплотную к лесу подбирались непроходимые болота.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Я решил немного передохнуть. Несколько часов прошли незаметно...';
        end
        if s._rested == 1 then
            status_change (-1, -1, -1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
    end,
    exit = function (s, to)
        if to == r_131 or to == r_133 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_133 = room
{
    nam = 'Лес',
    north = nil,
    east = 'r_134',
    south = nil,
    west = 'r_132',
    _monster = true,
    _just_enter = true,
    _visit = 0,
    _after_fight = true,
    _rested = 0,
    pic = 'images/133.png',
    enter = function (s, from)
        set_music ('music/04_eternity.ogg');
        if from == r_132 or from == r_134 then
            s._rested = 0;
        end
        if not status._dead then
            if s._monster then
                s._monster = false;
                if status._clock == NIGHT then
                    walk (r_133_attack_end);
                    return;
                else
                    walk (r_133_attack);
                    return;
                end
            end
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if status._clock == NIGHT then
            p [[Я практически ничего не видел. Пробираться ночью по лесу было
            очень трудно.
            ]];
        end
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я не ожидал встретить здесь артанга. В нелёгкой схватке
                мне удалось задушить противника. Откуда и куда шёл он? Судя по
                его форме, этот артанг так же, как и я, уцелел после нашей
                звёздной битвы.
                ]];
            end
            if s._visit == 2 then
                p [[Я вышел на небольшую поляну. На севере всё так же тянулась
                гряда скал, на юге лес утопал в непроходимых болотах.
                ]];
            end
        else
            p [[На севере всё так же тянулась гряда скал, на юге лес
            утопал в непроходимых болотах.
            ]];
        end
        return;
    end,
    obj = { 'artang_corpse', 'glass' },
    rest = function (s)
        if s._after_fight then
            s._after_fight = false;
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'После битвы с артангом я долго не мог придти в себя.';
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        if s._rested == 1 then
            status_change (-1, -1, -1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
    end,
    exit = function (s, to)
        s._after_fight = false;
        if to == r_132 or to == r_134 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


artang_corpse = obj
{
    nam = 'труп артанга',
    weight = 101,
    exam = function (s)
        glass:enable();
        p 'Осмотрев труп артанга, я обнаружил у него в руке осколок стекла.';
        return;
    end,
    take = function (s)
    end,
};


glass = obj
{
    nam = 'осколок стекла',
    weight = 0,
    exam = function (s)
        return 'Осколок тугоплавкого стекла.';
    end,
    take = function (s)
        return 'Я взял осколок стекла.';
    end,
    drop = function (s)
        return 'Я бросил осколок стекла.';
    end,
}:disable();



r_133_attack = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/133_attack.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Быстро темнело. Пробираться вперёд приходилось почти на ощупь.
        Едва я вышел на небольшую поляну, как сзади на меня бросилось какое-то
        существо.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_133') },
};


r_133_attack_end = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/133_attack.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Я практически ничего не видел. Пробираться ночью по лесу было
        очень трудно. Я и оглянуться не успел, как кто-то выскочил из кустов
        и бросился на меня. Страшная боль сковала всё тело. Сопротивляться я
        уже не мог...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_134 = room
{
    nam = 'Берег лесного озера',
    north = nil,
    east = 'r_135',
    south = nil,
    west = 'r_133',
    _just_enter = true,
    _visit = 0,
    _rested = 0;
    pic = 'images/134.png',
    enter = function (s, from)
        set_music ('music/04_eternity.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            if s._just_enter then
                s._just_enter = false;
                p [[Едва я вышел на берег огромного лесного озера, как сразу
                увидел брошенный артангом амортизационный кокон. Теперь было
                ясно, что в лесу я снова встретился со своим недавним
                противником.
                ]];
            else
                p [[На берегу огромного лесного озера находился брошенный
                артангом амортизационный кокон.
                ]];
            end
        end
        if s._visit == 2 then
            if s._just_enter then
                s._just_enter = false;
                p 'Я снова вышел на берег лесного озера.';
            else
                p 'Я находился на берегу лесного озера.';
            end
        end
        return;
    end,
    obj = { 'artang_cocoon' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Я несколько часов отдыхал на берегу озера...';
        end
        if s._rested == 1 then
            status_change (-1, -1, -1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
    end,
    exit = function (s, to)
        if to == r_133 or to == r_135 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};



artang_cocoon = obj
{
    nam = 'кокон',
    _examined = false,
    weight = 101,
    exam = function (s)
        if not s._examined then
            neurowhip:enable();
            pills:enable();
            s._examined = true;
            p [[В небольшом пластиковом кармане я заметил лёгкий нейрохлыст и
            упаковку таблеточной пищи.
            ]];
        else
            p 'Я ещё раз обыскал кокон, но не нашёл ничего интересного.';
        end
        return;
    end,
    obj = { 'neurowhip', 'pills' },
    take = function (s)
    end,
};


neurowhip = obj
{
    nam = 'нейрохлыст',
    weight = 0,
    _charged = false,
    exam = function (s)
        if s._charged then
            p [[Индикатор на рукоятке показывал, что нейрохлыст готов к
            использованию.
            ]];
        else
            p [[Осмотрев нейрохлыст, я заметил, что он не заряжен.
            ]];
        end
        return;
    end,
    take = function (s)
        return 'Я взял нейрохлыст.';
    end,
    drop = function (s)
        return 'Я бросил нейрохлыст.';
    end,
    used = function (s, w)
        if w == battery then
            if not battery._locked then
                s._charged = true;
                if have (battery) then
                    drop (battery);
                end
                battery:disable();
                return 'Я зарядил нейрохлыст аккумулятором.';
            else
                return 'Аккумулятор застрял в деформированной панели.';
            end
        end
    end,
}:disable();


pills = obj
{
    nam = 'таблетки',
    weight = 0,
    _number = 10,
    exam = function (s)
        p [[Упаковка с надписью «Синтезированная пища типа А-37, 10 шт.».
        В упаковке было ]];
        p (s._number);
        if s._number > 4 then
            p [[ таблеток.]];
        end
        if s._number > 1 then
            p [[ таблетки.]];
        end
        if s._number == 1 then
            p [[ В упаковке осталась одна последняя таблетка.]];
        end
        if s._number == 0 then
            p [[Упаковка была пуста.]];
        end
        return;
    end,
    take = function (s)
        return 'Я взял таблетки.';
    end,
    drop = function (s)
        return 'Я бросил таблетки.';
    end,
    useit = function (s)
        if s._number > 0 then
            status_change (6, 3, 2, 0, 0);
            s._number = s._number - 1;
            if s._number == 0 then
                p 'Я съел последнюю таблетку.';
            else
                p 'Я съел таблетку.';
            end
        else
            p 'В упаковке не осталось ни одной таблетки.';
        end
        return;
    end,
}:disable();


r_135 = room
{
    nam = 'Берег лесного озера',
    hideinv = true,
    pic = 'images/134.png',
    dsc = function (s)
        p [[Мне показалось, что я смогу переплыть это озеро. Тем более, что
        полоска противоположного берега была хорошо видна.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_135_end') },
};


r_135_end = room
{
    nam = 'Лесное озеро',
    hideinv = true,
    pic = 'images/135.png',
    dsc = function (s)
        p [[Но едва я вошёл в воду, как что-то холодное и скользкое коснулось
        моих ног, а потом я почувствовал нестерпимую боль. Холодная вода
        окрасилась красным...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_136 = room
{
    nam = 'Магистраль',
    north = 'r_146',
    east = 'r_137',
    south = 'r_126',
    west = 'r_136_end',
    _from_s = true,
    _rested = 0,
    pic = function (s)
        if s._from_s then
            return 'images/136a.png';
        else
            return 'images/136b.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/08_loneliness.ogg');
        s._rested = 0;
        if from == r_126 or from == r_137 then
            s._from_s = true;
        else
            s._from_s = false;
        end
    end,
    dsc = function (s)
        p [[Магистраль проходила с севера на юг вдоль берега огромного озера,
        которое находилось на западе. На востоке я разглядел неприметную
        тропинку, ведущую к морю.
        ]];
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_146 or to == r_137 or to == r_126 or to == r_136_end then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_136_end = room
{
    nam = 'Магистраль',
    pic = function (s)
        if r_136._from_s then
            return 'images/136a.png';
        else
            return 'images/136b.png';
        end
    end,
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        p [[Мне показалось, что я смогу переплыть это озеро. Тем более,
        что полоска противоположного берега была хорошо видна.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_135_end') },
};


r_137 = room
{
    nam = 'Берег моря',
    north = 'r_147',
    east = nil,
    south = 'r_127',
    west = 'r_136',
    _from_s = true,
    _rested = 0,
    pic = function (s)
        if s._from_s then
            return 'images/137a.png';
        else
            return 'images/137b.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/08_loneliness.ogg');
        s._rested = 0;
        if from == r_136 or from == r_127 then
            s._from_s = true;
        else
            s._from_s = false;
        end
    end,
    dsc = function (s)
        p [[Спустившись по тропинке к морю, я вышел на берег и огляделся.
        На юге я видел посёлок, на севере — какие-то современные сооружения.
        ]];
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_136 or to == r_147 or to == r_127 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};



r_138 = room
{
    nam = 'Туннель',
    north = 'r_148',
    east = nil,
    south = 'r_128',
    west = nil,
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/138.png',
    enter = function (s, from)
        set_music ('music/06_sticky_fear.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Прошло несколько часов. Впрочем, здесь трудно было
                ориентироваться во времени. Вполне вероятно, что я мог
                ошибаться и в определении сторон света.
                ]];
            end
            if s._visit == 2 then
                p [[Я шёл по туннелю уже несколько часов. Воздух здесь был
                влажный и тяжёлый. Я торопился как можно быстрее выйти на
                поверхность.
                ]];
            end
        else
            p 'Туннель тянулся с юга на север.';
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Отдохнуть здесь можно было без проблем. Я расположился между
            двух сталагмитов и немного вздремнул.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_148 or to == r_128 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};

-- ---------------------------------------------------------------------------

r_141 = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/141.png',
    enter = function (s)
        set_music ('music/10_island_o.ogg');
    end,
    dsc = function (s)
        p [[Я всё шёл и шёл вглубь недружелюбного леса. Вдруг несколько
        каких-то мохнатых карликов выскочили из-за деревьев и бросились на
        меня с копьями наперевес. Лучники, засевшие на деревьях, осыпали меня
        градом стрел. Глаза затянуло кровавой пеленой...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_142 = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/141.png',
    enter = function (s)
        set_music ('music/10_island_o.ogg');
    end,
    dsc = function (s)
        p [[Я всё шёл и шёл вглубь недружелюбного леса. Вдруг несколько
        каких-то мохнатых карликов выскочили из-за деревьев и бросились на
        меня с копьями наперевес. Лучники, засевшие на деревьях, осыпали меня
        градом стрел. Глаза затянуло кровавой пеленой...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_143 = room
{
    nam = 'Лес',
    north = nil,
    east = 'r_144',
    south = nil,
    west = 'r_142',
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/143.png',
    enter = function (s, from)
        s._rested = 0;
        set_music ('music/11_helicopter.ogg');
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Спустя несколько часов я вышел к лесу. Далеко на севере
                по-прежнему бушевало море. С юга лес окружали скалы. С запада
                до меня доносились крики лесных обитателей.
                ]];
            end
            if s._visit == 2 then
                p [[Я вошёл в лес. Позади, на востоке, остался пустынный берег
                моря. По-моему, дальше идти было небезопасно. Лёгкий ветер
                доносил до меня крики лесных обитателей.
                ]];
            end
        else
            p [[Далеко на севере по-прежнему бушевало море. С юга лес
            окружали скалы. С запада до меня доносились крики лесных
            обитателей.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    obj = { 'bushes' },
    exit = function (s, to)
        if to == r_142 or to == r_144 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


bushes = obj
{
    nam = 'кусты',
    exam = function (s)
        berries:enable();
        p 'На многих кустах я заметил целые гроздья крупных красных ягод.';
        return;
    end,
    obj = { 'berries' },
};


berries = obj
{
    nam = 'ягоды',
    exam = function (s)
        return 'Большие сочные красные ягоды.';
    end,
    useit = function (s)
        status_change (5, 5, 5, 0, 0);
        return 'Я съел несколько ягод.';
    end,
    take = function (s)
        p [[Ягоды были так нежны, что через несколько секунд буквально
        вытекали сквозь пальцы.
        ]];
        return false;
    end,
}:disable();


r_144 = room
{
    nam = 'Винтолёт',
    north = nil,
    east = 'r_145',
    south = nil,
    west = 'r_143',
    _visit = 0,
    _just_enter = true,
    _from_heli = false,
    _rested = 0;
    pic = function (s)
        if helicopter_enter._closed then
            return 'images/144.png';
        else
            return 'images/144_burned.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/11_helicopter.ogg');
        if from == r_144_helicopter then
            s._from_heli = true;
        else
            s._from_heli = false;
            s._rested = 0;
--            r_144_inside._rested = 0;
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
    end,
    dsc = function (s)
        if s._from_heli then
            p [[Я выбрался из винтолёта.^]];
        end
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Прошло несколько часов. Местный пейзаж не отличался
                разнообразием. Похоже, что битва была глобальной. Я обратил
                внимание на разбитый двухместный винтолёт. Тем, кто находился
                в нём во время битвы, я мог только посочувствовать. Винт этой
                посудины был начисто срезан лазером.
                ]];
            end
            if s._visit == 2 then
                p [[Я шёл вдоль берега, усеянного костями. С юга, почти
                вплотную к морю, подступали неприступные скалы. Над унылым
                пейзажем величественным надгробием возвышался овал
                разбившегося винтолёта.
                ]];
            end
        else
            p [[Берег моря тянулся с востока на запад. С юга, почти
            вплотную к морю, подступали неприступные скалы.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
--            r_144_inside._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    obj = { 'helicopter' },
    exit = function (s, to)
        if to == r_143 or to == r_145 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


helicopter = obj
{
    nam = 'винтолёт',
    exam = function (s)
        helicopter_enter:enable();
        p [[Судя по форме, этому винтолёту было лет двести. Такие летательные
        аппараты уже давно не выпускались ни на одной цивилизованной планете
        Центрального Союза.
        ]];
        return;
    end,
    obj = { 'helicopter_enter' },
};


helicopter_enter = obj
{
    nam = 'люк винтолёта',
    _closed = true,
    exam = function (s)
        if s._closed then
            p [[Люк был сделан на совесть. Он плотно закрывал вход в винтолёт.
            На люке я заметил надпись: «Чёрная Кобра».
            ]];
        else
            p 'В люке была вырезана большая дыра.';
        end
        return;
    end,
    useit = function (s)
        if not s._closed then
            if here () == r_144 then
                walk (r_144_helicopter);
                return;
            else
                walk (r_144);
                return;
            end
        else
            return 'Я попытался открыть люк, но безрезультатно.';
        end
    end,
    used = function (s, w)
        if w == blaster then
            if have(blaster) then
                if blaster._charged then
                    s._closed = false;
                    blaster._charged = false;
                    p [[Мне удалось вырезать бластером в люке большую дыру.
                    Увы, на этом заряд бластера закончился.
                    ]];
                else
                    p 'Бластер не заряжен.';
                end
            else
                p 'У меня нет бластера.';
            end
        end
        return;
    end,
}:disable();


r_144_helicopter = room
{
    nam = 'Винтолёт',
    pic = 'images/144_helicopter.png',
    dsc = function (s)
        p [[Внутри было темно и пахло плесенью. За искорёженным пультом
        управления я увидел человеческий скелет. Из разбитого шлема на меня
        смотрели пустые глазницы погибшего пилота.
        ]];
        return;
    end,
    rest = function (s)
        if r_144._rested == 0 then
            r_144._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    obj = { 'skeleton', 'helicopter_enter' },
};


skeleton = obj
{
    nam = 'скелет',
    _examined = false,
    exam = function (s)
        if s._examined then
            p 'Похоже, что скелет находился тут уже много лет.';
        else
            bracelet:enable();
            s._examined = true;
            p [[На левом запястье скелета я заметил потускневший серебряный
            браслет.
            ]];
        end
        return;
    end,
    obj = { 'bracelet' },
};


bracelet = obj
{
    nam = 'браслет',
    weight = 0,
    _on_skeleton = true,
    exam = function (s)
        p 'На браслете я прочитал: «Командир «Чёрной Кобры» Артур Кинг».';
        return;
    end,
    take = function (s)
        if s._on_skeleton then
            s._on_skeleton = false;
            p 'Я снял браслет со скелета.';
        else
            p 'Я взял браслет.';
        end
        return;
    end,
    drop = function (s)
        return 'Я бросил браслет.';
    end,
}:disable();


r_145 = room
{
    nam = 'Берег моря',
    north = nil,
    east = 'r_148',
    south = nil,
    west = 'r_144',
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/145.png',
    enter = function (s, from)
        set_music ('music/14_raxxla_breathing.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я вышел на берег моря. Здесь всё было усеяно человеческими
                костями. Повсюду я замечал следы какого-то сражения. По всему
                берегу валялись оплавленные куски металла, запчасти от
                лазерных установок и пустые коробки из под энергетических
                зарядов.^Берег моря тянулся с востока на запад. С юга к берегу
                подступали отвесные скалы.
                ]];
            end
            if s._visit == 2 then
                p [[Здесь было по-прежнему тихо и неуютно. Белые кости
                погибших в жестокой схватке на берегу моря, пустые ящики из
                под боеприпасов и изуродованные ракетные установки оставляли
                гнетущее впечатление.
                ]];
            end
        else
            p [[Берег моря тянулся с востока на запад. С юга к берегу
            подступали отвесные скалы.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_144 or to == r_148 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};



r_146 = room
{
    nam = 'Развалины замка',
    north = nil,
    east = 'r_147',
    south = 'r_136',
    west = nil,
    _visit = 0,
    _just_enter = true,
    _may_enter = false,
    _second_dlg = false,
    _rested = 0,
    pic = 'images/146.png',
    enter = function (s, from)
        set_music ('music/13_jameson_theme.ogg');
        if from == r_147 or from == r_136 then
            s._rested = 0;
        end
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
        if from == jameson_outside_dlg then
            s._visit = 0;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            if s._just_enter then
                s._just_enter = false;
                p [[Я находился у развалин старинного замка, построенного в
                незапамятные времена. Магистраль, которая привела меня сюда,
                уходила на восток. С запада и с севера замок окружали
                неприступные скалы.^Возле развалин я заметил небольшой дом.
                Над дверью дома висела выцветшая вывеска «Лавка Джеймсона».
                ]];
            else
                p [[Магистраль, которая привела меня сюда, уходила на восток.
                С запада и с севера замок окружали неприступные скалы.^
                Возле развалин я заметил небольшой дом. Над дверью дома висела
                выцветшая вывеска «Лавка Джеймсона».
                ]];
            end
        end
        if s._visit == 2 then
            if s._just_enter then
                s._just_enter = false;
                p [[Я вышел из лавки Джеймсона и осмотрелся. На востоке я
                видел постройки базы артангов. Магистраль, по которой я сюда
                пришёл, вела на юг. На западе виднелись развалины старинного
                замка.
                ]];
            else
                p [[На востоке я видел постройки базы артангов. Магистраль,
                по которой я сюда пришёл, вела на юг. На западе виднелись
                развалины старинного замка.^Возле развалин стоял небольшой дом.
                Над дверью дома висела выцветшая вывеска «Лавка Джеймсона».
                ]];
            end
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    obj =
    {
        'castle_ruins',
        'jamesons_house'
    },
    exit = function (s, to)
        if to == r_136 or to == r_147 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


castle_ruins = obj
{
    nam = 'развалины',
    exam = function (s)
        p [[Судя по всему, это были остатки большого старинного замка,
        построенного очень и очень давно. Быть может даже до появления первых
        колонистов на этой земле. Кто жил в этом замке? Это осталось для меня
        загадкой. Теперь же над руинами кружили лишь хищные птицы...
        ]];
        return;
    end,
};


jamesons_house = obj
{
    nam = 'дом',
    exam = function (s)
        jamesons_house_door:enable();
        p [[Я осмотрел дом. Над дверью висела выцветшая вывеска «Лавка
        Джеймсона».
        ]];
        return;
    end,
    obj = { 'jamesons_house_door' },
};


jamesons_house_door = obj
{
    nam = 'дверь',
    exam = function (s)
        jamesons_house_bell:enable();
        p 'Осмотрев дверь, я обнаружил кнопку звонка.';
        return;
    end,
    obj = { 'jamesons_house_bell' },
    useit = function (s)
        if r_122_inside._passwd then
            p 'Дверь была заперта изнутри.';
            return;
        end
        if r_146._may_enter then
            walk (r_146_inside);
            return;
        else
            p 'Дверь заперта изнутри.';
        end
        return;
    end,
}:disable();


jamesons_house_bell = obj
{
    nam = 'звонок',
    exam = function (s)
        return 'Обычная кнопка.';
    end,
    useit = function (s)
        if r_122_inside._passwd then
            p 'Я долго звонил, но никто не ответил. Похоже хозяина не было дома.';
            return;
        end
        if r_146._may_enter then
            p 'Нет смысла звонить ещё раз. Дверь открыта.';
            return;
        end
        walk (jameson_outside_dlg);
        return;
    end,
}:disable();


jameson_outside_dlg = dlg
{
    nam = 'Развалины замка',
    hideinv = true,
    pic = 'images/146.png',
    entered = function (s, from)
        if pseen ('first_dlg') then
            p 'Я позвонил в дверь.^— Кто там? — хрипло спросили за дверью.';
        else
            p [[Я позвонил в дверь.^— Эй, ну сколько можно звонить? —
            проворчали за дверью.
            ]];
        end
    end,
    phr =
    {
        {
            tag = 'first_dlg',
            [[Свои.]],
            [[Тут много таких ходит. Что Вам нужно?]],
            [[ poff ('first_dlg'); pjump ('d21'); ]]
        },
        {
            tag = 'first_dlg',
            [[Откройте, я из Военного Совещания ЦСЧК.]],
            [[— Из Военного Совещания? Какие у Вас могут быть ко мне дела?
            Ну, а вообще-то, заходи...
            ]],
            [[ r_146._may_enter = true; back ();]]
        },
        {
            tag = 'first_dlg',
            [[Я хотел бы что-нибудь купить у Вас.]],
            [[— Ну Вас к чёрту! Мне сейчас не до этого, убирайтесь!]],
            [[ poff ('first_dlg'); pjump ('second_dlg'); back ();]]
        },
        { },
        {
            tag = 'second_dlg',
            [[Откройте, мой корабль потерпел крушение, и мне нужна Ваша
            помощь.
            ]],
            [[— Крушение, говоришь? Ну так и быть... Заходи...]],
            [[ r_146._may_enter = true; back (); ]]
        },
        {
            tag = 'second_dlg',
            always = true;
            [[Немедленно откройте, иначе я разнесу в щепки Вашу хибару!]],
            [[— Эй, а ты кто такой? Не тот ли ублюдок, которому я вчера набил
            морду на причале?
            ]];
            [[ psub ('d22'); ]]
        },
        {
            tag = 'second_dlg',
            always = true;
            [[Мне нужно поговорить с Вами.]],
            [[— Все дела потом, завтра.]],
            [[ back (); ]]
        },
        { },
        {
            tag = 'd21',
            [[Я хотел бы что-нибудь купить у Вас.]],
            [[— Ну Вас к чёрту! Мне сейчас не до этого, убирайтесь!]],
            [[ poff ('d21'); pstart ('second_dlg'); back (); ]]
        },
        {
            tag = 'd21',
            [[Мне нужно поговорить с Вами.]],
            [[— О чём, парень? Если ты на службе у этих жаб, то я уже давно
            заплатил все налоги. А вести душещипательные беседы мне некогда.
            ]],
            [[ poff ('d21'); pstart ('second_dlg'); back (); ]]
        },
        { },
        {
            tag = 'd22',
            always = true,
            [[Ты слишком много говоришь, открывай!]],
            [[— Проваливай отсюда подобру-поздорову, парень.]],
            [[ pret (); back (); ]]
        },
        {
            tag = 'd22',
            always = true,
            [[Нельзя ли повежливей?]],
            [[— Проваливай отсюда подобру-поздорову, парень.]],
            [[ pret (); back (); ]]
        },
    },
};


r_146_inside = room
{
    nam = 'Лавка Джеймсона',
    _visit = 0,
    _just_enter = true,
    _may_enter = false,
    _second_dlg = false,
    pic = function (s)
        return 'images/146b.png';
    end,
    dsc = function (s)
        p [[Здесь было довольно тесно и, как во всех подобных лавках, пахло
        прокисшим вином. На полках красовались бутылки с различными марками
        ликёров и вин.
        ]];
        return;
    end,
    rest = function (s)
        if r_146._rested == 0 then
            r_146._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
    end,
    obj =
    {
        'jamesons_sofa',
        'jamesons_painting',
        'jameson',
        'jamesons_door'
    },
};


r_146_inside_end = room
{
    nam = 'Лавка Джеймсона',
    hideinv = true,
    pic = 'images/146c.png',
    enter = function (s, from)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[— Ах ты щенок! — крикнул Джеймсон и, нырнув под прилавок, затих.^
        Я обстрелял прилавок, и когда мне показалось, что с Джеймсоном
        покончено, раздался выстрел. Теряя сознание, я повалился на пол...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


jamesons_sofa = obj
{
    nam = 'диван',
    exam = function (s)
        p 'Обыкновенный кожаный диван, изрядно потёртый завсегдатаями лавки.';
        return;
    end,
};


jamesons_painting = obj
{
    nam = 'картина',
    _taked = false,
    _used = false,
    exam = function (s)
        if not s._used then
            p [[По-моему, на картине был изображён вечерний пейзаж планеты
            Лейв. Во всяком случае, это было очень похоже на Лейв.
            ]];
        else
            p [[Я ещё раз осмотрел картину и заметил, что на обороте
            написано:^^
            Славься наше звёздное братство^
            Друг мой, пируй, всё уже позади^
            Перед нами вселенной богатство,^
            Ты его для других сохрани.^
            Как хотел ты узнать эту тайну^
            Пробил час, наши души в раю^
            Этот мир, словно кубок хрустальный,^
            Я тебе по наследству дарю.
            ]];
        end
        return;
    end,
    take = function (s)
        s._taked = true;
        p [[Я попытался снять со стены картину, но она была крепко прикреплена
        к стене цепочкой.
        ]];
        return false;
    end,
    useit = function (s)
        s._used = true;
        p 'Я перевернул картину.';
        return;
    end,
};


jameson = obj
{
    nam = 'Джеймсон',
    _angry = true,
    _talked = false,
    _bottle = true,
    exam = function (s)
        p [[Это был человек преклонных лет, но ещё достаточно крепкий и плотно
        сбитый. Похоже, что когда-то он был настоящим космическим волком.
        ]];
        return;
    end,
    talk = function (s)
        if s._talked then
            p [[Я попытался что-то сказать Джеймсону, но он меня остановил:^
            — Больше ничем помочь не могу.
            ]];
            return;
        end
        if s._angry then
            p [[Я попытался что-то сказать Джеймсону, но тот не захотел меня
            слушать. Он с усмешкой посмотрел на меня и сказал:^— Я не верю
            тебе, друг мой. Иди-ка ты шпионь где-нибудь в другом месте.
            ]];
        else
            walk (jameson_inside_dlg);
        end
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (r_146_inside_end);
            return;
        end
    end,
    accept = function (s, w)
        if w == lisa_note then
            drop (lisa_note);
            remove (lisa_note);
            jameson._angry = false;
            p [[Я отдал Джеймсону записку Лизы Тейлор. Он долго изучал её,
            а потом сказал:^— Понятно. Видимо ты дал понюхать пороха этим жабам.
            Одобряю. Чем я могу тебе помочь?
            ]];
            return;
        end
        if jameson._angry then
            p [[Я попытался что-то сказать Джеймсону, но тот не захотел
            меня слушать. Он с усмешкой посмотрел на меня и сказал:^
            — Я не верю тебе, друг мой. Иди-ка ты шпионь где-нибудь в
            другом месте.
            ]];
            return false;
        end
        if w == medallion then
            if not jameson._bottle then
                p 'Я уже показывал медальон Джеймсону';
            else
                put (jamesons_paper, r_146_inside);
                put (jamesons_bottle, r_146_inside);
                jameson._bottle = false;
                p [[Я снял с шеи медальон и дал его Джеймсону. У старого
                торговца расширились глаза. Он внимательно рассмотрел его и
                вернул мне:^
                — По-моему, я теперь знаю кто ты, парень. Я очень хорошо знал
                твоего отца. К сожалению, он погиб здесь. Его убили артанги.
                Он входил в состав лиги «Тёмное Колесо». Ты наверняка слышал
                о ней. Так вот, сейчас те, кто остался в лиге, пытаются
                противостоять наступлению артангов, но пока безуспешно...
                Ну да ладно, речь не об этом. Твой отец тут оставил кое-что.
                Это всё предназначалось для того, кто продолжит его дело.
                Я думаю, что сын не откажется от дела отца? А?
                    Как ты думаешь?^
                С этими словами Джемсон залез под прилавок и вытащил оттуда
                клочок бумаги с какими-то знаками. Потом из под прилавка
                появилась бутылка ликёра.^
                — Это всё. — сказал Джеймсон и ухмыльнувшись, добавил:^
                — А этот отличный ликёр он оставил, чтобы его помянули.
                ]];
            end
            return false;
        end
        if w == bracelet then
            p '— Оставь себе. Пригодится. Я взяток не беру.';
            return false;
        end
    end,
};


jamesons_door = obj
{
    nam = 'дверь',
    exam = function (s)
        return 'Обычная дверь.';
    end,
    useit = function (s)
        walk (r_146);
        return;
    end,
};


jamesons_paper = obj
{
    nam = 'клочок бумаги',
    exam = function (s)
        p [[На клочке бумаги написано:^5(4), 6(2), 7(3), 10(4), 11(1), 14(2),
        17(2), 18(1), 21(4), 23(3, 6).
        ]];
        return;
    end,
    take = function (s)
        return 'Я взял клочок бумаги.';
    end,
    drop = function (s)
        return 'Я бросил клочок бумаги.';
    end,
};


jamesons_bottle = obj
{
    nam = 'бутылка',
    _empty = false,
    exam = function (s)
        p [[На этикетке написано: «Лучшие старинные ликёры и вина от фирмы
        Майкл & К. Ликёр «Песчаные бури Энсореуса».
        ]];
        if s._empty then
            jamesons_plastic:enable();
            p [[На дне бутылки я заметил кусок пластика.
            ]];
        end
        return;
    end,
    take = function (s)
        return 'Я взял бутылку.';
    end,
    drop = function (s)
        remove (jamesons_bottle, inv());
        put (jamesons_bottle_glass);
        put (jamesons_plastic);
        p 'Я бросил бутылку и она разбилась.';
        return false;
    end,
    useit = function (s)
        if s._empty then
            p 'Бутылка пуста.';
        else
            s._empty = true;
            p 'Я открыл бутылку и залпом осушил её.';
        end
        return;
    end,
};


jamesons_bottle_glass = obj
{
    nam = 'осколки',
    exam = function (s)
        return 'Острые осколки.';
    end,
    take = function (s)
        p 'Слишком острые.';
        return false;
    end,
};


jamesons_plastic = obj
{
    nam = 'кусок пластика',
    exam = function (s)
        p [[На куске пластика написано:^1 (1, 2), 3 (7), 4 (7, 8), 8 (2), 10
        (4), 12 (3).
        ]];
        return;
    end,
    take = function (s)
        return 'Я взял кусок пластика.';
    end,
    drop = function (s)
        return 'Я бросил кусок пластика.';
    end,
};


jameson_inside_dlg = dlg
{
    nam = 'Лавка Джеймсона',
    hideinv = true,
    pic = 'images/146b.png',
    dsc = '— Чем я могу тебе помочь?',
    phr =
    {
        {
            tag = 'inside',
            [[Где я нахожусь?]],
            [[ — Ты ещё не понял, парень? Это — Ракксла, чёртова планета,
            самое тухлое место во Вселенной, с тех пор как здесь появились
            артанги. Я сам так долго искал её, что теперь чувствую себя полным
            идиотом. Я поздно нашёл её, слишком поздно...^
            Здесь уже вовсю хозяйничали артанги. Получилось так, что я сам
            себе вырыл могилу. И будь проклят тот день, когда последний из
            династии Джеймсонов оказался в плену у этих тварей. А этот гнилой
            остров называется «О», он для ссыльных.^
            База артангов отсюда буквально в двух шагах на восток.
            И я не советую приближаться к ней.
            ]],
            [[ pjump ('how'); ]]
        },
        { },
        {
            tag = 'how',
            [[Как мне выбраться отсюда?]],
            [[ — На юго-востоке есть порт. Морской глайдер курсирует между
            островом и материком. Если сумеешь пробраться на глайдер — считай
            что тебе повезло. На материке найдутся добрые люди. Желаю удачи.
            Смерть артангам!
            ]];
            [[ jameson._talked = true; back (); ]]
        },
    },
};



r_147 = room
{
    nam = 'База артангов',
    _rested = 0,
    north = nil,
    east = nil,
    south = 'r_137',
    west = 'r_146',
    pic = 'images/147.png',
    enter = function (s, from)
        set_music ('music/27_artangs_theme.ogg');
        s._rested = 0;
        if not status._biomask then
            walk (r_147_end);
            return;
        end
    end,
    dsc = function (s)
        p [[У ворот базы артангов стоял часовой. Внутрь он меня не пустил, так
        как у меня не было пропуска. Вежливо извинившись, я отошёл в сторону.
        ]];
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
        return;
    end,
    obj = { 'r_147_guardian' },
    exit = function (s, to)
        if to == r_146 or to == r_137 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_147_guardian = obj
{
    nam = 'часовой',
    exam = function (s)
        p [[Это был довольно грозного вида артанг. На плече у него висел
        гравимёт. На поясе болтались гранаты.
        ]];
        return;
    end,
    talk = function (s)
        p [[Едва я открыл рот, артанг остановил меня жестом руки, давая
        понять, что разговаривать с посторонними не собирается.
        ]];
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (r_147_neuro);
            return;
        end
    end,
};


r_147_end = room
{
    nam = 'База артангов',
    hideinv = true,
    pic = 'images/147.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Несколько часов я шёл к морю. У самого берега я увидел современные
        сооружения. Похоже, что это была чья-то база. Но едва я приблизился к
        забору, как неожиданно оказался в окружении дюжины артангов.
        Дула гравимётов смотрели мне прямо в лицо.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_147_neuro = room
{
    nam = 'База артангов',
    hideinv = true,
    pic = 'images/147.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Силы были не равны. Последнее, что я помню — дуло гравимёта,
        смотрящее мне в лицо.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_147_biomask_off_end = room
{
    nam = 'База артангов',
    hideinv = true,
    pic = 'images/147.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Едва я снял биомаску, часовой с ужасом посмотрел на меня и открыл
        огонь из гравимёта.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_148 = room
{
    nam = 'Карьер',
    north = nil,
    east = nil,
    south = nil,
    west = 'r_145',
    _visit = 0,
    _just_enter = true,
    _rested = 0,
    pic = 'images/148.png',
    enter = function (s, from)
        set_music ('music/14_raxxla_breathing.ogg');
        s._rested = 0;
        s._just_enter = true;
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s._visit = 1;
        end
    end,
    dsc = function (s)
        if s._just_enter then
            s._just_enter = false;
            if s._visit == 1 then
                p [[Я стоял на дне огромного карьера, который тянулся с
                востока на запад. На юге отвесной стеной поднимались скалы.
                С севера ветер доносил звуки бушующего моря.
                В одной из скал был прорублен вход в туннель.
                ]];
            end
            if s._visit == 2 then
                p [[Я стоял на дне древнего карьера. Вероятно, что когда-то
                здесь добывали полезные ископаемые для военного завода,
                который находился по ту сторону туннеля.
                ]];
            end
        else
            p [[Огромный карьер тянулся с востока на запад. На юге
            отвесной стеной поднимались скалы. С севера ветер доносил
            звуки бушующего моря. В одной из скал был прорублен вход в
            туннель.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            end
        end
    end,
    obj = { 'mine_enter' },
    exit = function (s, to)
        if to == r_145 or to == r_138 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


mine_enter = obj
{
    nam = 'вход в туннель',
    exam = function (s)
        return 'Туннель уходил под скалу и шёл в южном направлении.';
    end,
    useit = function (s)
        clock_next ();
        if status._health == 1 then
            health_finish._from = deref(here());
            status_change (-2, -1, -1, 0, 0);
            walk (health_finish);
        else
            walk (r_138);
        end
        return;
    end,
};


r_198 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/198.png',
    enter = function (s, from)
        set_music ('music/17_escape.ogg');
        remove (glider_ticket, inv());
    end,
    dsc = function (s)
        p [[Через несколько минут глайдер отчалил. Я стоял на верхней палубе и
        смотрел на удаляющийся остров. Я до сих пор не верил, что мне удалось
        вырваться отсюда. С юга дул тёплый ветер. Глайдер набирал скорость.
        Впереди меня ждало неизведанное...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_200') },
};


-- ---------------------------------------------------------------------------

the_end = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/end.png',
    enter = function (s)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Спустя некоторое время по всем каналам связи Центрального Союза
        Человеческих Колоний было передано следующее сообщение:^
        «Военное совещание Центрального Союза с глубоким прискорбием сообщает,
        что при выполнении важного задания пал смертью храбрых секретный агент
        Военного Совещания «Неустрашимый». Об этом стало известно после того,
        как агент не вышел на связь в назначенное время.
        Президент ЦСЧК и руководство ВС приносят глубокие соболезнования
        родным и близким покойного».
        ]];
        return;
    end,
};

