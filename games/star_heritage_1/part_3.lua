r_319 = room
{
    nam = '...',
    _visit = 0,
    _rested = 0,
    north = 'r_329',
    east = nil,
    south = nil,
    west = nil,
    pic = 'images/319.png',
    enter = function (s, from)
        set_music ('music/23_scent_of_wandering.ogg');
        if from == r_329 then
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
            p [[Я несколько часов шёл по Южной трассе на юг, в сторону
            странного туманного образования. По мере приближения к нему, я всё
            отчётливей видел, что по всему периметру туманного образования
            тянется высокий забор с наблюдательными вышками.^
            Дорога привела меня к высоким воротам, по обе стороны которых
            стояли две вышки. Пройти дальше я не мог.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я вновь стоял рядом с наблюдательными вышками. Вдали, за
            высокими воротами, я видел безжизненную пустыню. Раньше я что-то
            слышал про Темпор Раккслы, через который, собственно, и
            осуществлялись перелёты в Иные Вселенные. Но я не думал, что такое
            чудо света может находиться на поверхности планеты. Или всё, что я
            видел, это ещё не знаменитое Темпоральное Поле?
            ]];
            return;
        end
        if s._visit == 3 then
            p [[Я вновь вышел к наблюдательным постам артангов, которые
            охраняли подступы к Зоне. С запада и с востока, вплотную к
            пустынной трассе подступали горы. На юге, за высокими воротами,
            я видел голую, безжизненную пустыню, окутанную плотным туманным
            образованием.
            ]];
            return;
        end
    end,
    rest = function (s)
        walk (r_319_rest_end_1);
        return;
    end,
    obj = { 'r_319_towers' },
    exit = function (s, to)
        if to == r_329 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_319_towers = obj
{
    nam = 'вышки',
    exam = function (s)
        p [[Массивные наблюдательные вышки. В каждой — минимум полсотни
        вооружённых артангов.
        ]];
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (r_319_attack_end);
            return;
        end
    end,
};


r_319_rest_end_1 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/319.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p 'Я расположился вблизи пустынной трассы и немного вздремнул.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_319_rest_end_2') },
};


r_319_rest_end_2 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/artangs.png',
    dsc = function (s)
        p [[Когда я проснулся, то увидел, что вокруг меня стоит дюжина
        артангов. «Ну что, шпеон? Дапригался?» — с ухмылкой произнёс один из
        артангов.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_319_attack_end = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/319.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Едва я схватился за оружие, как с вышек на меня обрушился шквал
        огня. Я рухнул на дорогу...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_322 = room
{
    nam = 'КПП',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_332',
    east = nil,
    south = nil,
    west = nil,
    pic = 'images/322.png',
    enter = function (s, from)
        set_music ('music/27_artangs_theme.ogg');
        if from == r_332 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 1;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я несколько часов шёл по обочине дороги. Прямо по ходу, на юге
            я заметил контрольно-пропускной пункт. Возле будки со шлагбаумом
            стоял артанг с гравимётом. Он останавливал и проверял все
            автокрафты.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я стоял неподалёку от контрольно-пропускного пункта.
            Артанг-полицейский останавливал и проверял все въезжающие в город
            автокрафты. Кажется, просто так пройти через пункт мне не дадут.
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
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    obj = { 'r_322_policeman' },
    exit = function (s, to)
        if to == r_341 or to == r_332 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_322_policeman = obj
{
    nam = 'полицейский',
    exam = function (s)
        p [[Это был высокий жирный артанг. На груди у него висел гравимёт.]];
        return;
    end,
    talk = function (s)
        p [[Похоже, что артанг не был расположен к разговорам.]];
        return;
    end,
};


r_322_biomask_end = room
{
    nam = 'КПП',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Артанг-полицейский заметил моё перевоплащение и, что-то крикнув
        своим напарникам, направился ко мне. Из будки выскочило ещё несколько
        артангов с гравимётами наперевес.^Уйти мне не удалось. Артанги открыли
        огонь из гравимётов. Я рухнул на пыльную дорогу.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_327 = room
{
    nam = 'Аэропорт',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    _walk = false,
    north = 'r_337',
    east = 'r_328',
    south = nil,
    west = nil,
    pic = function (s)
        if seen (r_327_shuttle) then
            if r_327_shuttle_cabin._open then
                return 'images/327_shuttle_open.png';
            else
                return 'images/327_shuttle.png';
            end
        else
            return 'images/327_no_shuttle.png';
        end
    end,
    enter = function (s, from)
        if from == r_213_lucky_end_2t then
            s._visit = 1;
            set_music ('music/16_escape_2.ogg');
        else
            set_music ('music/24_roads.ogg');
        end
        if from == r_337 or from == r_328 then
            s._rested = 0;
            s._visit = s._visit + 1;
            s._just_enter = true;
            if s._visit > 3 then
                s._visit = 2;
            end
        end
        if (from == r_337 or from == r_328) and (s._visit == 1) then
            s._visit = 3;
        end
        remove (r_327_shuttle, r_327);
        remove (r_327_shuttle_lever, r_327);
        remove (r_327_shuttle_cabin, r_327);
        remove (r_327_shuttle_ladder, r_327);
        r_327_shuttle_cabin._open = false;
        if (s._visit == 1) or (s._visit == 3) then
            put (r_327_shuttle, r_327);
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Когда мы приземлились в аэропорту Тарана, я вышел из аэро
            последним, спустился по трапу и осмотрелся. Аэропорт с юга и с
            запада окружали горы. На востоке и севере я видел жилые кварталы
            города. Моё внимание привлекли стоящие в аэропорту лёгкие
            космические челноки типа «Плот».
            ]];
        end
        if s._visit == 2 then
            p [[Я снова стоял на взлётном поле местного аэропорта. Здесь всё
            было по-прежнему. Правда, челноков, которых я видел в прошлый раз,
            здесь уже не было.
            ]];
        end
        if s._visit == 3 then
            p [[Спустя несколько часов я вышел к местному аэропорту. Аэропорт
            с юга и с запада окружали горы. На востоке и севере распростёрлись
            жилые кварталы города. На взлётном поле я заметил несколько лёгких
            космических челноков типа «Плот». Вокруг не было ни души.
            ]];
        end
        return;
    end,
    rest = function (s)
        walk (r_327_rest_end);
        return;
    end,
    exit = function (s, to)
        if to == r_337 or to == r_328 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_327_shuttle = obj
{
    nam = 'челнок',
    exam = function (s)
        put (r_327_shuttle_cabin, r_327);
        p [[Одноместный грузовой космический челнок «Плот-МС» класса
        «поверхность-орбита» с прозрачным колпаком.
        ]];
        return;
    end,
};


r_327_shuttle_cabin = obj
{
    nam = 'кабина',
    _open = false,
    exam = function (s)
        put (r_327_shuttle_lever, r_327);
        p [[Я осмотрел кабину снаружи. На фюзеляже, под откидной крышкой был
        небольшой рычаг.
        ]];
        return;
    end,
};


r_327_shuttle_lever = obj
{
    nam = 'рычаг',
    exam = function (s)
        return 'Небольшой рычаг.';
    end,
    useit = function (s)
        if status._clock == NIGHT then
            if r_327_shuttle_cabin._open then
                r_327_shuttle_cabin._open = false;
                remove (r_327_shuttle_ladder, r_327);
                p [[Я дёрнул за рычаг, крышка кабины медленно закрылась,
                лестница втянулась в едва заметные углубления.
                ]];
            else
                r_327_shuttle_cabin._open = true;
                put (r_327_shuttle_ladder, r_327);
                p [[Я дёрнул рычаг, откинулась крышка кабины и выдвинулась
                лестница.
                ]];
            end
        else
            walk (r_327_open_1_end);
        end
        return;
    end,
};


r_327_shuttle_ladder = obj
{
    nam = 'лестница',
    exam = function (s)
        return 'Выдвижная лестница.';
    end,
    useit = function (s)
        if here() == r_327 then
            walk (r_327_cabin);
        else
            p 'Я вылез из челнока.';
            walk (r_327);
        end
        return;
    end,
};


r_327_cabin = room
{
    nam = 'Кабина',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    pic = 'images/327_cabin.png',
    dsc = function (s)
        return 'Я забрался в челнок и разместился за пультом управления.';
    end,
    obj = { 'shuttle_console', 'r_327_shuttle_ladder' },
    rest = function (s)
        walk (r_327_rest_end);
        return;
    end,
};


shuttle_console = obj
{
    nam = 'пульт',
    exam = function (s)
        put (shuttle_button, r_327_cabin);
        put (shuttle_hole, r_327_cabin);
        put (shuttle_handle, r_327_cabin);
        put (shuttle_panel, r_327_cabin);
        p [[Я внимательно осмотрел пульт управления. Этот челнок практически
        не нуждался в пилоте. На пульте была лишь рукоятка закрывания крышки,
        щель для карточки электронного навигатора, кнопка запуска и панель
        установки машрута.
        ]];
        return;
    end,
};


shuttle_button = obj
{
    nam = 'кнопка запуска',
    exam = function (s)
        return 'Кнопка запуска челнока.';
    end,
    useit = function (s)
        if shuttle_panel._destination < 3 then
            return 'Безрезультатно.';
        else
            if not (shuttle_handle._cabin_closed) then
                walk (r_327_fly_open_1_end);
                return;
            else
                if shuttle_panel._destination == 3 then
                    walk (r_327_fly_tempor_1);
                    return;
                else
                    walk (r_327_fly_arkan_1);
                    return;
                end
            end
        end
    end,
};


shuttle_hole = obj
{
    nam = 'щель',
    _navigator = false,
    exam = function (s)
        return 'Щель для карточки электронного навигатора.';
    end,
    used = function (s, w)
        if w == enavigator then
            if have (enavigator) then
                s._navigator = true;
                remove (enavigator, inv());
                p 'Я вставил э-навигатор в щель на панели управления.';
            else
                p 'У меня нет э-навигатора.';
            end
        end
        return;
    end,
};


shuttle_handle = obj
{
    nam = 'рукоятка',
    _cabin_closed = false,
    exam = function (s)
        return 'Рукоятка закрывания крышки.';
    end,
    useit = function (s)
        if s._cabin_closed then
            s._cabin_closed = false;
            put (r_327_shuttle_ladder, r_327_cabin);
            p 'Я дёрнул рукоятку и колпак кабины медленно открылся.';
        else
            s._cabin_closed = true;
            remove (r_327_shuttle_ladder, r_327_cabin);
            p 'Я дёрнул рукоятку и колпак кабины медленно закрылся.';
        end
        return;
    end,
};


shuttle_panel = obj
{
    nam = 'панель',
    _destination = 0,
    exam = function (s)
        return 'Панель установки маршрута.';
    end,
    useit = function (s)
        if shuttle_hole._navigator then
            walk (shuttle_dlg_tempor);
        else
            walk (shuttle_dlg_usual);
        end
        return;
    end,
};


shuttle_dlg_usual = dlg
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    dsc = 'Выберите цель полёта:';
    phr =
    {
        {
            always = true,
            [[Кориолис «Альфа».]],
            [[Цель полёта выбрана.]],
            [[ shuttle_panel._destination = 1; back(); ]]
        };
        {
            always = true,
            [[Додо «Омега».]],
            [[Цель полёта выбрана.]],
            [[ shuttle_panel._destination = 2; back(); ]]
        };
    },
};


shuttle_dlg_tempor = dlg
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    dsc = 'Выберите цель полёта:';
    phr =
    {
        {
            always = true,
            [[Темпоральная зона. Квадрат А.]],
            [[Цель полёта выбрана.]],
            [[ shuttle_panel._destination = 3; back(); ]]
        };
        {
            always = true,
            [[Город Аркан.]],
            [[Цель полёта выбрана.]],
            [[ shuttle_panel._destination = 4; back(); ]]
        };
    },
};


r_327_fly_open_1_end = room
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    enter = function (s, from)
        set_music ('music/16_escape_2.ogg');
    end,
    dsc = function (s)
        p [[Я нажал на кнопку. Едва слышно загудели двигатели и челнок стал
        сначала медленно, а потом всё быстрее и быстрее набирать высоту.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_fly_open_2_end') },
};


r_327_fly_open_2_end = room
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    dsc = function (s)
        p [[Меня обдало ледяным ветром. Ещё через несколько секунд я
        почувствовал, что теряю сознание...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_327_open_1_end = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/327_shuttle_open.png',
    dsc = function (s)
        p 'Я дёрнул рычаг, откинулась крышка кабины и выдвинулась лестница.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_open_2_end') },
};


r_327_open_2_end = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Но не успел я ничего сделать, как словно из-под земли появился
        целый взвод артанговских солдат-охранников. Спустя несколько минут
        меня уже вели на допрос в Следственное управление СОПЭ...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_327_rest_end = room
{
    nam = 'Аэропорт',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я разместился неподалёку от взлётного поля и немного расслабился.
        Несколько часов пронеслось незаметно.^Когда я открыл глаза, то увидел
        рядом с собой целый взвод вооружённых артангов-охранников.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_327_fly_tempor_1 = room
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    enter = function (s, from)
        set_music ('music/16_escape_2.ogg');
    end,
    dsc = function (s)
        p [[Загудели двигатели и челнок начал медленно отрываться от земли.
        Через несколько секунд я уже находился высоко над землёй. Челнок
        держал курс к Темпоральной Зоне, которая находилась южнее Тарана.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_fly_tempor_2') },
};


r_327_fly_tempor_2 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/327_fly.png',
    dsc = function (s)
        p [[Скоро я заметил, что за мной погоня. Три иглообразных истрибителя
        быстро догоняли мой тихоходный корабль. Но челноку удалось уйти от
        преследователей — истребители повернули назад возле границы Темпора.
        Я же летел дальше. Сквозь плотный туман я ничего не мог разглядеть.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_fly_tempor_3') },
};


r_327_fly_tempor_3 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/327_fly.png',
    dsc = function (s)
        p [[Неожиданно, прямо по курсу что-то вспыхнуло и прогремел гром.
        Челнок резко накренился и вошёл в штопор. Последнее, что я помню —
        быстро приближающаяся поверхность безжизненной пустыни...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_327_fly_arkan_1 = room
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    enter = function (s, from)
        set_music ('music/16_escape_2.ogg');
    end,
    dsc = function (s)
        p [[Я не знаю зачем я выбрал целью этот город. По слухам, в нём жили
        современные нимфы — женщины, обладающие мощными гипнотическими
        способностями. На что я надеялся?
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_fly_arkan_2') },
};


r_327_fly_arkan_2 = room
{
    nam = 'Кабина',
    hideinv = true,
    pic = 'images/327_cabin.png',
    dsc = function (s)
        p [[Но у меня не было другого выбора — лететь в Темпоральную Зону на
        челноке, использующем аннигиляционное горючее было смертельно.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_fly_arkan_3') },
};


r_327_fly_arkan_3 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/327_fly.png',
    dsc = function (s)
        p [[Когда челнок поднялся в воздух, я сразу заметил, что меня
        преследуют три иглообразных военных истрибителя. Мне оставалось
        надеяться только на прочность обшивки челнока. Когда истребители
        открыли огонь, челнок уже находился над океаном. Спустя несколько
        секунд я почувствовал запах гари. Один из двигателей челнока горел.
        В этот момент я подумал, что всё кончено.^То же самое, наверное,
        подумали и преследовавшие меня пилоты — они повернули назад.
        Пролетев несколько километров, челнок стал разваливаться.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_327_fly_arkan_4') },
};


r_327_fly_arkan_4 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/327_fly_catapult.png',
    dsc = function (s)
        p [[Но тут сработала система катапультирования — измученная
        электроника корабля выполнила свой последний долг...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_436') },
};


r_328 = room
{
    nam = 'Южная окраина',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_338',
    east = 'r_329',
    south = nil,
    west = 'r_327',
    pic = 'images/328.png',
    enter = function (s, from)
        set_music ('music/23_scent_of_wandering.ogg');
        if from == r_327 or from == r_329 or from == r_338 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 1 then
                if status._clock == NIGHT then
                    s._visit = 3;
                else
                    s._visit = 2;
                end
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я стоял на южной окраине города Таран. Здесь было много
            маленьких одноэтажных строений. Люди, которые жили здесь, по всей
            видимости занимались сельским хозяйством. На юге, в долине реки,
            я видел большие сельскохозяйственные угодья.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я вновь вышел на южную окраину города. Здесь было довольно
            тихо и спокойно. Жизнь текла своим чередом. Мужчины и женщины
            работали на полях. На узких пыльных улицах играли дети.
            ]];
            return;
        end
        if s._visit == 3 then
            p [[Этот район города Тарана ночью словно вымирал. И, не смотря
            на то, что ночи здесь были довольно светлые, я не встретил на
            узких улочках ни души.
            ]];
            return;
        end
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Отдохнуть здесь можно было без особых проблем. Я расположился
            на мягкой траве в диком саду на окраине района и немного
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
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_327 or to == r_329 or to == r_338 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_329 = room
{
    nam = 'Трасса',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_339',
    east = nil,
    south = 'r_319',
    west = 'r_328',
    pic = 'images/329.png',
    enter = function (s, from)
        set_music ('music/23_scent_of_wandering.ogg');
        if from == r_328 or from == r_339 or from == r_319 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вышел на большую, но пустынную трассу, которая уходила на
            юг. Здесь я не встретил ни одного автокрафта, ни одного человека
            или артанга. Трасса петляла меж заросших лесами холмов.^
            На севере и на западе я видел жилые кварталы Тарана. На юге,
            почти у самого горизонта, висело очень плотное белое облако.
            Странное образование распростёрлось над большой площадью.
            Отсюда казалось, что туман покрывает половину планеты.
            ]];
        end
        if s._visit == 2 then
            p [[Я снова стоял на трассе, которая, судя по указателям,
            называлась Южной. На юге, у самого горизонта, по-прежнему висело
            гигантское туманное образование. Складывалось впечатление, что
            целая туманность Андромеды пожаловала в гости на загадочную
            планету Ракксла.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Расположившись в зарослях кустарника возле обочины дороги,
            я немного вздремнул...
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_328 or to == r_339 or to == r_319 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_331 = room
{
    nam = 'Шоссе',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_341',
    east = 'r_332',
    south = nil,
    west = nil,
    pic = 'images/331.png',
    enter = function (s, from)
        set_music ('music/24_roads.ogg');
        if from == r_341 or from == r_332 then
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
            p [[Я несколько часов шёл по шоссе. За всё это время мимо меня не
            проехало ни одного автокрафта. Спустя некоторое время я заметил на
            западе берег моря. На юге я видел высокие горы. Дорога вела на
            север вдоль берега моря. Там, на пологом холме, стояла большая
            добротная вилла.
            ]];
        end
        if s._visit == 2 then
            p [[Я стоял на шоссе, недалеко от берега моря. На юге я видел
            высокие горы. На востоке шоссе исчезало в лесах. Далеко на севере
            я видел большую виллу, построенную на пологом холме.
            ]];
        end
        if s._visit == 3 then
            p [[Несколько часов по шоссе — и я вышел к берегу моря. На востоке
            я видел знакомую мне лесополосу, сквозь которую проходило шоссе.
            На юге поднимались горы. На севере, на холме, стояла одинокая
            вилла.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Выбрав удобное место для отдыха на берегу моря, я сначала с
            удовольствием искупался, а потом немного поспал.
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p [[Выбрав удобное место для отдыха на берегу моря, я немного
                поспал.
                ]];
                return;
            end
        end
    end,
    exit = function (s, to)
        if to == r_341 or to == r_332 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_332 = room
{
    nam = 'Развилка',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = nil,
    east = 'r_333',
    south = 'r_322',
    west = 'r_331',
    pic = 'images/332.png',
    enter = function (s, from)
        if from == porcupine_dlg_end_3 then
            set_music ('music/16_escape_2.ogg');
        else
            set_music ('music/24_roads.ogg');
        end
        if from == r_333 or from == r_322 or from == r_331 or from == porcupine_dlg_end_3 then
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
            p [[Я стоял на обочине дороги, к которой с севера вплотную
            подступали горы. Дорога шла с юга и, огибая маленькое озерцо,
            поворачивала на восток. На западе я заметил узкое двустороннее
            шоссе, ответвляющееся от главной дороги.
            ]];
        end
        if s._visit == 2 then
            p 'Я вышел на знакомую мне развилку.';
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Я разместился в зарослях кустарника на обочине дороги и
            немного вздремнул.
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p [[Я разместился в зарослях кустарника на обочине дороги и
                немного вздремнул.
                ]];
                return;
            end
        end
    end,
    exit = function (s, to)
        if to == r_333 or to == r_322 or to == r_331 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_333 = room
{
    nam = 'Трасса',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = nil,
    east = 'r_334',
    south = nil,
    west = 'r_332',
    pic = function (s)
        return 'images/333.png';
    end,
    enter = function (s, from)
        set_music ('music/24_roads.ogg');
        if from == r_332 or from == r_334 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 1 then
                s._visit = 1;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я шёл по обочине скоростной трассы. Изредка мимо меня с
            резким свистом проносились автокрафты. Трасса проходила с запада
            на восток между высокими отвесными скалами. Почти вплотную к
            обочине подступали заросли кустарника.
            ]];
            return;
        end
    end,
    obj = { 'r_333_bushes' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Выбрав удобное место для отдыха, я расположился в зарослях
            кустарника.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-1, -1, -1, 0, 0);
                p 'Прошло несколько часов...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_332 or to == r_334 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_333_bushes = obj
{
    nam = 'кусты',
    exam = function (s)
        r_333_berries:enable();
        p 'На многих кустах я заметил целые гроздья крупных красных ягод.';
        return;
    end,
    obj = { 'r_333_berries' },
};


r_333_berries = obj
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


r_334 = room
{
    nam = 'Дорога',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = nil,
    east = 'r_335',
    south = nil,
    west = 'r_333',
    pic = 'images/334.png',
    enter = function (s, from)
        set_music ('music/24_roads.ogg');
        if status._clock == NIGHT and s._just_enter then
            status_change (-24, -15, -13, 2, 0);
            if status._health <= 0 then
                status._health = 1;
            end
        end
        if from == r_333 or from == r_335 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if status._clock == NIGHT and s._rested == 0 then
           p [[Ночью идти здесь было довольно опасно. Я не заметил, как
           совершенно неожиданно из туннеля, который находился на юге,
           выскочил автокрафт. Я не успел отскочить в сторону. Сильный
           касательный удар опрокинул меня на спину, и я свалился в
           придорожную канаву.
           ]];
           return;
        end
        if s._visit == 1 then
            p [[Дорога казалась бесконечной. С юга и севера вплотную к трассе
            подступали скалы. Иногда в небе надо мной с низким гулом
            проносились аэро. На востоке я видел туннель, который уходил
            вглубь отвесных скал.
            ]];
        end
        if s._visit == 2 then
            p [[Я стоял на обочине пустынной дороги. Изредка мимо меня
            проносились автокрафты. На востоке я увидел начало туннеля,
            который уходил вглубь отвесных скал.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Я расположился возле обочины дороги и решил немного отдохнуть.
            Я чувствовал себя неважно. Но впереди был ещё длинный путь.
            Сумею ли я когда-нибудь выбраться отсюда?
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_333 or to == r_335 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_335 = room
{
    nam = 'Туннель',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = nil,
    east = 'r_336',
    south = nil,
    west = 'r_334',
    pic = function (s)
        return 'images/335.png';
    end,
    enter = function (s, from)
        set_music ('music/24_roads.ogg');
        if from == r_334 or from == r_336 then
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
            p [[Я стоял внутри длинного туннеля, который уходил на восток.
            Здесь было светло: стенки туннеля были отделаны самосветящимся
            материалом. По обе стороны туннеля располагались узкие пешеходные
            дорожки.
            ]];
        end
        if s._visit == 2 then
            p [[Я находился в знакомом уже мне туннеле. Здесь было всё
            по-прежнему: тихо и безлюдно. Лишь изредка мимо меня с лёгким
            шелестом проносились автокрафты. Туннель тянулся с востока на
            запад.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Отдыхать здесь было не очень удобно. Но я как-то умудрился
            пристроиться на узкой пешеходной дорожке, и, прислонившись спиной
            к холодной стене, немного вздремнул.
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_334 or to == r_336 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_336 = room
{
    nam = 'АПП',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = nil,
    east = nil,
    south = nil,
    west = 'r_335',
    pic = 'images/336.png',
    enter = function (s, from)
        set_music ('music/24_roads.ogg');
        if from == r_335 then
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
            p [[Я стоял возле автоматического пропускного пункта. Здесь никого
            не было. Мощный автоматический шлагбаум поднимался и опускался
            специальными механизмами, управляемыми электроникой. Со всех
            сторон на меня смотрели видеокамеры.
            ]];
        end
        if s._visit == 2 then
            p [[Возле АПП не было ни души. Изредка около шлагбаума появлялись
            автокрафты и на несколько секунд останавливались, пока электроника
            проверяла пропуска.
            ]];
        end
        if s._visit == 3 then
            p [[Я вновь вышел к АПП.]];
        end
        return;
    end,
    obj = { 'app_device' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов...';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_335 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


app_device = obj
{
    nam = 'аппарат',
    exam = function (s)
        return 'Большой металлический аппарат с прорезью для пропуска.';
    end,
    used = function (s, w)
        if w == oneway_ticket then
            if have (w) then
                remove (oneway_ticket, inv());
                p [[Я сунул карточку в прорезь аппарата, шлагбаум поднялся и я
                прошёл через АПП.
                ]];
                walk (r_337);
            else
                p 'У меня нет карточки.';
            end
            return;
        end
        if w == autocraft_pass then
            if have (w) then
                remove (w, inv());
                p [[Я сунул пропуск в прорезь аппарата, шлагбаум поднялся и я
                прошёл через АПП.
                ]];
                walk (r_336);
            else
                p 'У меня нет пропуска.';
            end
            return;
        end
    end,
};


r_337 = room
{
    nam = 'АПП',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    north = 'r_347',
    east = 'r_338',
    south = 'r_327',
    west = nil,
    pic = 'images/337.png',
    enter = function (s, from)
        set_music ('music/24_roads.ogg');
        if from == r_327 or from == r_347 or from == r_338 or from == r_336 then
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
            p [[Я стоял возле автоматического пропускного пункта. Здесь никого
            не было. Мощный автоматический шлагбаум поднимался и опускался
            специальными механизмами, управляемыми электроникой. Со всех
            сторон на меня смотрели видеокамеры.
            ]];
        end
        if s._visit == 2 then
            p [[Возле автоматического пропускного пункта не было ни души.
            Изредка возле шлагбаума появлялись автокрафты и на несколько
            секунд останавливались, пока электроника проверяла пропуска.
            ]];
        end
        if s._visit == 3 then
            p [[Я вновь вышел к АПП.]];
        end
        return;
    end,
    obj = { 'app_device' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов...';
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_327 or to == r_338 or to == r_347 or to == r_336 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_338 = room
{
    nam = 'Центр Тарана',
    _visit = 0,
    _rested = 0,
    north = 'r_348',
    east = 'r_339',
    south = 'r_328',
    west = 'r_337',
    pic = 'images/338.png',
    enter = function (s, from)
        set_music ('music/28_taran_city.ogg');
        if from == r_348 or from == r_339 or from == r_328 or from == r_337 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 3;
            end
        end
        if status._clock == NIGHT and not (from == r_338_artangs_3) then
            walk (r_338_artangs_1);
            return;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вышел в центр города Таран. Здесь было много
            правительственных зданий, окружённых глухими высокими заборами.
            Изредка по узким улочкам проносились глянцево-чёрные автокрафты
            новых правителей Раккслы. Казалось, ничто не могло нарушить
            идиллию артанговского рая.
            ]];
        end
        if s._visit == 2 then
            p [[Я вновь оказался в центральной, старинной части города.
            Случайные прохожие, встречавшиеся мне по пути, были угрюмы и
            необщительны. Люди, жившие здесь, уже давно смирились со своей
            судьбой. Двести лет артанговского правления — это, конечно,
            большой срок.
            ]];
        end
        if s._visit == 3 then
            p [[Я вышел в знакомую мне центральную часть города. Здесь всё
            было по-прежнему. Артанговский правительственный центр жил своей
            привычной, размеренной жизнью. Разглядывая внушительные
            правительственные здания, я думал о том, что может быть скоро
            этому будет положен конец.
            ]];
        end
        return;
    end,
    rest = function (s)
        if status._clock == NIGHT then
            walk (r_338_artangs_1);
            return;
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Отдохнуть здесь можно было без особых проблем. Я разместился
            на скамейке в уютном скверике и немного расслабился...
            ]];
            return;
        end
        if s._rested == 1 then
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
        if to == r_348 or to == r_339 or to == r_328 or to == r_337 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_338_artangs_1 = room
{
    nam = 'Центр Тарана',
    hideinv = true,
    pic = 'images/338.png',
    enter = function (s, from)
        set_music ('music/27_artangs_theme.ogg');
    end,
    dsc = function (s)
        p [[Ночью в центре было небезопасно. Здесь свирепствовал артанговский
        патруль. Всех редких прохожих, оказавшихся случайно на улице, избивали
        и забирали артанги-полицейские.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_338_artangs_2') },
};


r_338_artangs_2 = room
{
    nam = 'Центр Тарана',
    hideinv = true,
    pic = 'images/artangs.png',
    dsc = function (s)
        p 'С одной патрульной группой пришлось встретиться и мне...';
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_338_artangs_3') },
};


r_338_artangs_3 = room
{
    nam = 'Центр Тарана',
    hideinv = true,
    pic = 'images/338.png',
    enter = function (s, from)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Сегодня звёзды были на моей стороне. Мне удалось положить двух
        артангов из патрульной службы. Оставшиеся в живых артанги бросились
        бежать. Я не стал догонять их, мне нужно было уходить.
        ]];
        return;
--        p [[После отчаянного сопротивления я был тяжело ранен.
--        Истекая кровью, я упал на дорогу. Последнее, что я услышал,
--        были слова: "Добей его, Ахид"...';
    end,
    obj = { vway('1', '{Далее}', 'r_338') },
};


r_339 = room
{
    nam = 'Торговый квартал',
    _visit = 0,
    _rested = 0,
    north = 'r_349',
    east = nil,
    south = 'r_329',
    west = 'r_338',
    pic = function (s)
        if status._clock == NIGHT then
            return 'images/339_night.png';
        else
            return 'images/339_day.png';
        end
    end,
    enter = function (s, from)
        remove (beggar, r_339);
        remove (leftovers, r_339);
        if not (status._clock == NIGHT) then
            put (beggar, r_339);
            put (leftovers, r_339);
        end
        set_music ('music/28_taran_city.ogg');
        if from == r_329 or from == r_338 or from == r_349 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if status._clock == NIGHT then
            p [[Я вышел к местному торговому центру. Здесь никого не было.
            Повсюду валялись обрывки бумаги, обёртки и пустые коробки.
            На севере и на юге я видел огни жилых кварталов, на западе —
            строения центральной части города. На востоке — высокие горы.
            ]];
        end
        if s._visit == 1 then
            p [[Я вышел к большому торговому центру. Здесь было довольно много
            людей и представителей других рас. За порядком следили усиленные
            группы артангов-полицейских. Возле одного магазинчика я увидел
            одетого в лохмотья нищего, который торговал пакетиками с каким-то
            порошком.
            ]];
        end
        if s._visit == 2 then
            p [[Я стоял на территории большого торгового центра. Как всегда,
            здесь было полно народу и артангов-полицейских. Возле небольшого
            магазинчика стоял мой старый знакомый нищий.
            ]];
        end
        return;
    end,
    rest = function (s)
        remove (beggar, r_339);
        remove (leftovers, r_339);
        if not (status._clock == NIGHT) then
            put (beggar, r_339);
            put (leftovers, r_339);
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            drop (neurowhip);
            remove (neurowhip);
            drop (credit_card);
            remove (credit_card);
            drop (blaster);
            remove (blaster);
            drop (medallion);
            remove (medallion);
            drop (black_case);
            remove (black_case);
            drop (electronic_key);
            remove (electronic_key);
            drop (biomask);
            remove (biomask);
            drop (r_341_clock);
            remove (r_341_clock);
            drop (veres_documents);
            remove (veres_documents);
            drop (pills);
            remove (pills);
            p [[Я расположился на облезлой лавке возле магазинчика. Сколько я
            проспал не помню. Когда я проснулся, то понял, что меня подчистую
            обокрали...
            ]];
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_329 or to == r_338 or to == r_349 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


beggar = obj
{
    nam = 'нищий',
    exam = function (s)
        p [[Типичный представитель дна общества. Таких можно встретить на
        любой цивилизованой планете вселенной.
        ]];
        return;
    end,
    talk = function (s)
        p 'Похоже, что этот парень был глухонемым.';
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (beggar_attack);
            return;
        end
    end,
    accept = function (s, w)
        if w == r_341_clock or w == coin then
            drop (w);
            remove (w, r_339);
            take (package);
            p [[У нищего засветились глаза.]];
            if w == r_341_clock then
                p [[Он взял часы и быстро сунул их в свою потрёпанную сумку.
                ]];
            else
                p [[Он взял монету и быстро сунул её в свою потрёпанную сумку.
                ]];
            end
            p [[Взамен он дал мне один пакетик.]];
            return;
        else
            p [[Нищий резко помотал головой, давая понять, что это ему не
            нужно.
            ]];
            return false;
        end
    end,
};


beggar_attack = room
{
    nam = 'Торговый квартал',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Убить нищего я не успел. Словно из под земли выросли
        артанги-полицейские и, быстро скрутив меня, поволокли к своей машине.
        Я пытался сопротивляться, но несколько сильных ударов прикладом
        гравимёта по голове лишили меня чувств.
        Это было последнее, что я помню...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


leftovers = obj
{
    nam = 'объедки',
    exam = function (s)
        return 'Кажется, это что-то съедобное.';
    end,
    take = function (s)
        return 'Я взял объедки.';
    end,
    drop = function (s)
        return 'Я бросил объедки.';
    end,
    useit = function (s)
        drop (s);
        remove (s);
        status_change (6, 2, 0, 0, 0);
        return 'Я с отвращением проглотил объедки.';
    end,
};


r_341 = room
{
    nam = 'Вилла',
    _visit = 0,
    _rested = 0,
    _just_enter = true,
    _from_villa = false,
    north = nil,
    east = nil,
    south = 'r_331',
    west = nil,
    pic = function (s)
        if seen (r_341_owner) then
            if r_341_owner._alive then
                return 'images/341_owner.png';
            else
                return 'images/341_owner_is_dead.png';
            end
        else
            return 'images/341.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/26_villa.ogg');
        if from == r_341_villa_a then
            s._from_villa = true;
        else
            s._from_villa = false;
        end
        if from == r_331 or from == r_341_villa_a then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._from_villa then
            p [[Хороший добротный дом утопал в густой растительности
            ухоженного сада. Здесь было тихо и уютно. Судя по всему, вилла
            принадлежала зажиточному торговцу.
            ]];
        end
        if s._visit == 1 then
            p [[Я прошёл по дороге, ведущей к вилле, и поднялся на холм.
            Хороший добротный дом утопал в густой растительности ухоженного
            сада. Здесь было тихо и уютно. Судя по всему, вилла принадлежала
            зажиточному торговцу. Плиточная дорожка привела меня к парадной
            двери виллы.
            ]];
        end
        if s._visit == 2 then
            p [[Пройдя по пустынному шоссе на север, я взобрался на холм и
            вышел к одинокой вилле. Здесь было по прежнему тихо. Вилла утопала
            в густой растительности большого ухоженного сада. В воздухе пахло
            экзотическими цветами.
            ]];
        end
        return;
    end,
    obj = { 'r_341_bushes', 'r_341_door' },
    rest = function (s)
        if r_341_owner._alive then
            if not seen (r_341_owner) then
                if not r_341_door_lock._locked then
                    walk (r_341_rest_end);
                    return;
                end
                if not r_341_bushes._inside then
                    walk (r_341_rest_end);
                    return;
                else
                    s._rested = 1;
                    put (r_341_owner, r_341);
                    status_change (2, 1, 1, 0, 0);
                    set_music ('music/25_arbes_veres_theme.ogg');
                    p [[Через некоторое время на дорожке, ведущей к вилле,
                    появился небольшого роста человек. Я сразу понял, что это
                    хозяин виллы. Он долго стоял возле запертой двери,
                    обыскивая свои карманы. Видимо, ключа от двери у него не
                    было.
                    ]];
                    return;
                end
            else
                walk (r_341_rest_end);
                return;
            end
        else
            if s._rested == 0 then
                s._rested = 1;
                status_change (2, 1, 1, 0, 0);
                return 'Прошло несколько часов...';
            end
            if s._rested == 1 then
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                    return;
                else
                    status_change (-1, -1, -1, 0, 0);
                    return 'Прошло несколько часов...';
                end
            end
        end
    end,
    exit = function (s, to)
        if to == r_331 then
            if r_341_owner._is_left then
                walk (r_341_owner_left_end);
                return;
            end
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_341_rest_end = room
{
    nam = 'Вилла',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я немного вздремнул. Когда я открыл глаза, вокруг меня стояло
        несколько артангов с гравимётами наперевес. Из-за спин артангов
        выглядывал небольшого роста человек и, указывая на меня пальцем,
        говорил: «Да-да, это он, он! Я точно знаю! Арестуйте его!»
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_341_owner_left_end = room
{
    nam = 'Шоссе',
    hideinv = true,
    pic = 'images/artangs.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я вышел к берегу моря. Здесь, как оказалось, меня ждали. Дорога
        была перекрыта. Целый взвод вооружённых артангов поджидал меня в
        засаде. «Бросить орюжие, рюки за гольову!» — услышал я. Мне ничего не
        оставалось делать...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_341_bushes = obj
{
    nam = 'кусты',
    _inside = false,
    exam = function (s)
        return 'Хорошо ухоженные густые декоративные кусты.';
    end,
    useit = function (s)
        if s._inside then
            s._inside = false;
            if (seen (r_341_owner)) and (r_341_owner._alive) then
                remove (r_341_owner, r_341);
                r_341_owner._is_left = true;
                set_music ('music/26_villa.ogg');
                p [[Я вылез из кустов и попытался заговорить с человеком.
                Едва услышав мой голос, человек обернулся, бросил на меня
                мимолётный взгляд, и, не говоря ни слова, бросился бежать.
                Через несколько секунд я потерял его из виду.
                ]];
            else
                p 'Я вылез из кустов.';
            end
        else
            s._inside = true;
            p [[Я спрятался в зарослях декоративных кустов. Отсюда я мог
            прекрасно наблюдать за входной дверью.
            ]];
        end
        return;
    end,
};


r_341_door = obj
{
    nam = 'входная дверь',
    _examined_outside = false,
    _examined_inside = false,
    exam = function (s)
        r_341_villa_a._painting = false;
        if here() == r_341 then
            if not s._examined_outside then
                s._examined_outside = true;
                put (r_341_door_lock, r_341);
            end
        else
            if not s._examined_inside then
                s._examined_inside = true;
                put (r_341_door_lock, r_341_villa_a);
            end
        end
        p [[Тяжёлая массивная дверь, сделанная из особо прочных пород
        «каменных» деревьев. Внизу, под инкрустированной ручкой, прорезь
        электронного замка.
        ]];
        return;
    end,
    useit = function (s)
        if r_341_door_lock._locked then
            p 'Дверь заперта.';
        else
            if here() == r_341 then
                p 'Я открыл дверь и вошёл внутрь.';
                walk (r_341_villa_a);
            else
                p 'Я вышел на улицу.';
                walk (r_341);
            end
        end
        return;
    end,
};


r_341_door_lock = obj
{
    nam = 'замок',
    _examined = false,
    _locked = true,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            put (r_341_door_note, r_341);
        end
        if r_341_door_note._in_lock then
            p [[Обыкновенный электронный замок. В прорезь замка вставлена
            записка.
            ]];
        else
            p [[Обыкновенный электронный замок.]];
        end
        return;
    end,
    used = function (s, w)
        if w == electronic_key then
            if not have (w) then
                return 'У меня нет ключа.';
            else
                if r_341_door_note._in_lock then
                    return 'Не получается.';
                else
                    if s._locked then
                        s._locked = false;
                        return 'Замок открылся.';
                    else
                        s._locked = true;
                        return 'Замок закрылся.';
                    end
                end
            end
        end
    end,
};


r_341_door_note = obj
{
    nam = 'записка',
    _in_lock = true,
    exam = function (s)
        if s._in_lock then
            p 'Не получается.';
        else
            p '«Уехал по делам на остров «О». Арбес».';
        end
        return;
    end,
    take = function (s)
        s._in_lock = false;
        return 'Я взял записку.';
    end,
    drop = function (s)
        return 'Я бросил записку.';
    end,
};


r_341_owner = obj
{
    _alive = true,
    _is_left = false,
    _examined= false,
    nam = function (s)
        if s._alive then
            return 'человек';
        else
            return 'труп';
        end
    end,
    exam = function (s)
        if s._alive then
            p [[Мужчина среднего роста. Его лицо показалось мне знакомым.
            Кажется, я видел этого человека на глайдере.
            ]];
        else
            if not s._examined then
                s._examined = true;
                put (black_case, r_341);
                put (veres_documents, r_341);
                p [[Убитый был одет в дорогой костюм. Во внутреннем кармане
                его пиджака я обнаружил знакомый мне футляр и документы.
                ]];
            else
                p [[Я ещё раз обыскал труп, но больше ничего не нашёл.]];
            end
        end
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            if s._alive then
                s._alive = false;
                set_music ('music/26_villa.ogg');
                p [[Я выскочил из кустов и бросился на хозяина виллы. Он
                ничего не успел сделать. Через секунду у моих ног лежал труп.
                ]];
            else
                p 'Нейрохлыст здесь больше не нужен.';
            end
            return;
        end
    end,
};


veres_documents = obj
{
    nam = 'документы',
    exam = function (s)
        p [[Арбес Верес. Год рождения — 3700. Место рождения — Пульсар,
        Ракксла. Холост. С 3721 года зачислен в штат 3-го Отдела
        контрразведки СОПЭ. Имеет отличия и награды.
        ]];
        return;
    end,
    take = function (s)
        return 'Я взял документы.';
    end,
    drop = function (s)
        return 'Я бросил документы.';
    end,

};


r_341_villa_a = room
{
    nam = 'Гостиная',
    _visit = 0,
    _just_enter = true,
    _painting = false,
    _clock = true,
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    pic = function (s)
        if s._painting then
            return 'images/341_painting.png';
        else
            return 'images/341_villa_a.png';
        end
    end,
    enter = function (s, from)
        set_music ('music/26_villa.ogg');
        if from == r_341 or from == r_341_villa_b then
            s._just_enter = true;
        end
    end,
    dsc = function (s)
        p [[Я оказался в довольно большой и просторной гостиной современного
        типа. Хозяин виллы любил уют.
        ]];
        if s._clock then
            p [[На стене над старинным камином висели дисплейные часы.
            ]];
        end
        p [[Напротив камина стояло несколько мягких кресел и маленький столик.
        Напротив входной двери я заметил ещё одну, проходную дверь, которая
        вела в кабинет.
        ]];
--        if s._visit == 2 then
--            return 'Я снова вышел в гостиную.';
--        end
    end,
    obj =
    {
        'r_341_door',
        'r_341_villa_door',
        'r_341_clock',
        'r_341_painting'
    },
    rest = function (s)
        if r_341_owner._alive then
            walk (r_341_rest_end);
            return;
        else
            if r_341._rested == 0 then
                r_341._rested = 1;
                status_change (2, 1, 1, 0, 0);
                return 'Прошло несколько часов...';
            end
            if r_341._rested == 1 then
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                    return;
                else
                    status_change (-1, -1, -1, 0, 0);
                    return 'Прошло несколько часов...';
                end
            end
        end
    end,
    exit = function (s, to)
        r_341_villa_a._painting = false;
        if to == r_341 and r_341_door_lock._locked then
            p 'Дверь заперта.';
            return false;
        end
--        if to == r_341 then
--            health_finish._from = deref(here());
--            clock_next ();
--            status_change (-2, -1, -1, 0, 0);
--            return check_health();
--        end
    end,
};


r_341_villa_door = obj
{
    nam = 'дверь в кабинет',
    exam = function (s)
        r_341_villa_a._painting = false;
        return 'Обычная дверь.';
    end,
    useit = function (s)
        if here() == r_341_villa_a then
            walk (r_341_villa_b);
        else
            walk (r_341_villa_a);
        end
        return;
    end,
};


r_341_clock = obj
{
    nam = 'часы',
    _state = 1,
    exam = function (s)
        r_341_villa_a._painting = false;
        p [[Оригинальные плоские электронные часы. Внизу, под цифровым индикатором — голографическое изображение 
        ]];
        if s._state == 1 then
            p 'рака.';
        end
        if s._state == 2 then
            p 'паука.';
        end
        if s._state == 3 then
            p 'кита.';
        end
        if s._state == 4 then
            p 'быка.';
        end
        if s._state == 5 then
            p 'змеи.';
        end
        if s._state == 6 then
            p 'пчелы.';
        end
        if s._state == 7 then
            p 'гриба.';
        end
        if s._state == 8 then
            p 'клеща.';
        end
        if s._state == 9 then
            p 'комара.';
        end
        if s._state == 10 then
            p 'пиявки.';
        end
        if s._state == 11 then
            p 'кошки.';
        end
        if s._state == 12 then
            p 'рыбы.';
        end
        if r_341_safe_hole._clock_inside then
            p '^Часы вставлены в прорезь сейфа.';
        end
        return;
    end,
    used = function (s, w)
        if w == electronic_key then
            s._state = s._state + 1;
            if s._state > 12 then
                s._state = 1;
            end
            p 'Я приложил ключ к дисплею. Кажется, ничего не произошло.';
            return;
        end
    end,
    take = function (s)
        r_341_safe_hole._clock_inside = false;
        r_341_villa_a._clock = false;
        if r_341_villa_a._visit == 1 then
            r_341_villa_a._visit = 2;
        end
        p 'Я взял часы.';
        return;
    end,
    drop = function (s)
        return 'Я бросил часы.';
    end,
};


r_341_painting = obj
{
    nam = 'картина',
    exam = function (s)
        r_341_villa_a._painting = true;
        p [[В нижнем углу очень мелкая надпись: «Грет Кан. 29 век. Врата
        Темпора».
        ]];
        return;
    end,
};


r_341_villa_b = room
{
    nam = 'Кабинет',
    _visit = 0,
    _just_enter = true,
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    pic = function (s)
        if r_341_safe._locked then
            return 'images/341_villa_b.png';
        else
            return 'images/341_villa_c.png';
        end
    end,
    enter = function (s, from)
        if from == r_341_villa_a then
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я прошёл в кабинет. Здесь у окна стоял массивный стол,
            сделанный из особых пород так называемой «вечной» древесины.
            У одной из стен стоял внушительный сейф.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я снова оказался в кабинете. У окна стоял массивный стол.
            У одной из стен стоял внушительный сейф.
            ]];
            return;
        end
    end,
    obj =
    {
        'r_341_villa_door',
        'r_341_safe'
    },
    rest = function (s)
        if r_341_owner._alive then
            walk (r_341_rest_end);
            return;
        else
            if r_341._rested == 0 then
                r_341._rested = 1;
                status_change (2, 1, 1, 0, 0);
                return 'Прошло несколько часов...';
            end
            if r_341._rested == 1 then
                if status._health == 1 then
                    health_finish._from = deref(here());
                    walk (health_finish);
                    return;
                else
                    status_change (-1, -1, -1, 0, 0);
                    return 'Прошло несколько часов...';
                end
            end
        end
    end,
};


r_341_safe = obj
{
    nam = 'сейф',
    _examined = false,
    _locked = true,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            put (r_341_safe_hole, r_341_villa_b);
            put (r_341_safe_codelock, r_341_villa_b);
        end
        p [[Большой прочный сейф. На дверце прорезь, видимо для ключа,
        и шифронаборник.
        ]];
        return;
    end,
};


r_341_safe_hole = obj
{
    nam = 'прорезь',
    _clock_inside = false,
    exam = function (s)
        p [[Прорезь на двери сейфа, по видимому, была предназначена для ключа.
        ]];
        return;
    end,
    used = function (s, w)
        if w == electronic_key then
            return 'Электронный ключ не подходил к прорези.';
        end
        if w == r_341_clock then
            if s._clock_inside then
                p 'Я уже вставил часы в прорезь.';
            else
                drop (r_341_clock);
                s._clock_inside = true;
                p 'Я вставил часы в прорезь сейфа.';
            end
            return;
        end
    end,
};


r_341_safe_codelock = obj
{
    nam = 'шифронаборник',
    exam = function (s)
        return 'Сейф открывался комбинацией букв.';
    end,
    useit = function (s)
        if r_341_safe._locked then
            walk (r_341_terminal);
        else
            p 'Я уже открыл сейф.';
        end
        return;
    end,
};


r_341_terminal = room
{
    nam = 'Кабинет',
    hideinv = true,
    _key_pressed = 0,
    _passwd = 0,
    pic = 'images/341_villa_b.png',
--    dsc = function (s)
--        return 'Через мгновение вспыхнула надпись «Введите пароль:».';
--    end,
    act = function (s, w)
        s._key_pressed = s._key_pressed + 1;
        if s._key_pressed == 5 then
            walk (r_341_terminal_end);
            return;
        end
        if w == "1" then
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
            if s._passwd == 0 then
                s._passwd = s._passwd + 1;
            end
            return 'Я нажал клавишу К.';
        end
        if w == "13" then
            return 'Я нажал клавишу Л.';
        end
        if w == "14" then
            return 'Я нажал клавишу М.';
        end
        if w == "15" then
            if s._passwd == 2 then
                s._passwd = s._passwd + 1;
            end
            return 'Я нажал клавишу Н.';
        end
        if w == "16" then
            if s._passwd == 1 then
                s._passwd = s._passwd + 1;
            end
            return 'Я нажал клавишу О.';
        end
        if w == "17" then
            return 'Я нажал клавишу П.';
        end
        if w == "18" then
            return 'Я нажал клавишу Р.';
        end
        if w == "19" then
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
                if (r_341_clock._state == 6) and (r_341_safe_hole._clock_inside) then
                    if r_341_door_lock._locked then
                        walk (r_341_terminal_success);
                        return;
                    else
                        walk (r_341_terminal_almost_success);
                        return;
                    end
                else
                    walk (r_341_terminal_end);
                    return;
                end
            else
                walk (r_341_terminal_end);
                return;
            end
            return 'Я нажал клавишу [ввод].';
        end
    end,
    obj =
    {
        vobj ( "1",  "{А}"),
        vobj ( "2", " {Б}"),
        vobj ( "3", " {В}"),
        vobj ( "4", " {Г}"),
        vobj ( "5", " {Д}"),
        vobj ( "6", " {Е}"),
        vobj ( "7", " {Ё}"),
        vobj ( "8", " {Ж}"),
        vobj ( "9", " {З}"),
        vobj ("10", " {И}"),
        vobj ("11", " {Й}"),
        vobj ("12", " {К}"),
        vobj ("13", " {Л}"),
        vobj ("14", " {М}"),
        vobj ("15", " {Н}"),
        vobj ("16", " {О}"),
        vobj ("17", " {П}"),
        vobj ("18", " {Р}^"),
        vobj ("19", " {С}"),
        vobj ("20", " {Т}"),
        vobj ("21", " {У}"),
        vobj ("22", " {Ф}"),
        vobj ("23", " {Х}"),
        vobj ("24", " {Ц}"),
        vobj ("25", " {Ч}"),
        vobj ("26", " {Ш}"),
        vobj ("27", " {Щ}"),
        vobj ("28", " {Ъ}"),
        vobj ("29", " {Ь}"),
        vobj ("30", " {Э}"),
        vobj ("31", " {Ю}"),
        vobj ("32", " {Я}"),
        vobj ("33", " {[ввод]}")
    },
};


r_341_terminal_end = room
{
    nam = 'Кабинет',
    hideinv = true,
    pic = 'images/341_villa_b.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я не успел отдёрнуть руку, как мощнейший удар электрического тока
        свалил меня наповал...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_341_terminal_almost_success = room
{
    nam = 'Кабинет',
    hideinv = true,
    pic = 'images/341_villa_c.png',
    enter = function (s, from)
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Я набрал комбинацию. Сейф открылся, но мощнейший удар
        электрического тока свлил меня наповал...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


r_341_terminal_success = room
{
    nam = 'Кабинет',
    hideinv = true,
    pic = 'images/341_villa_c.png',
    enter = function (s, from)
        r_341_safe._locked = false;
        put (oneway_ticket, r_341_villa_b);
    end,
    dsc = function (s)
        p [[Сейф распахнулся и я увидел, что он пуст. То есть практически
        пуст. На одной из полок лежала пластиковая карточка. Больше в сейфе
        ничего не было.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_341_villa_b') },
};


oneway_ticket = obj
{
    nam = 'карточка',
    exam = function (s)
        return 'Одноразовый пропуск в мегаполис Таран.';
    end,
    take = function (s)
        return 'Я взял карточку.';
    end,
    drop = function (s)
        return 'Я бросил карточку.';
    end,
};



r_347 = room
{
    nam = 'Северо-западная окраина',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = 'r_348',
    south = 'r_337',
    west = nil,
    pic = function (s)
        if seen (autocraft) then
            return 'images/347_autocraft.png';
        else
            return 'images/347.png';
        end
    end,
    enter = function (s, from)
        remove (autocraft, r_347);
        remove (autocraft_door, r_347);
        if status._clock == DAY then
            put (autocraft, r_347);
        end
        set_music ('music/24_roads.ogg');
        if from == r_337 or from == r_348 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я находился на северо-западной окраине Тарана. С севера и с
            запада к городу вплотную подступали высокие горы. На востоке я
            видел жилые кварталы. На юге, в туманной дымке я разглядел трассу,
            которая скрывалась в туннеле, прорубленном в одной из скал.
            ]];
        end
        if s._visit == 2 then
            p [[Я вновь вышел на северо-западную окраину города.
            ]];
        end
        if s._visit == 3 then
            p [[Я стоял неподалёку от знакомой мне строительной площадки.
            Вокруг не было ни души. С севера и с запада к городу вплотную
            подступали высокие горы. На юге и востоке я видел жилые кварталы.
            ]];
        end
        if seen (autocraft) then
            p [[Неподалёку от меня, возле строительной площадки остановился
            пассажирский автокрафт. Из него вышли несколько человек, похоже
            рабочих, и направились к стройплощадке.
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            if seen (autocraft) then
                remove (autocraft, r_347);
                remove (autocraft_door, r_347);
                p [[Я разместился на поляне неподалёку от строительной
                площадки, чтобы немного передохнуть. Когда я проснулся,
                автокрафта на площадке уже не было.
                ]];
            else
                if status._clock == DAY then
                    put (autocraft, r_347);
                    p [[Я разместился на поляне неподалёку от строительной
                    площадки, чтобы немного передохнуть.^Пока я спал,
                    неподалёку от меня, возле строительной площадки
                    остановился пассажирский автокрафт. Из него вышли
                    несколько человек, похоже рабочих, и направились к
                    стройплощадке.
                    ]];
                else
                    p [[Я разместился на поляне неподалёку от строительной
                    площадки, чтобы немного передохнуть.
                    ]];
                end
            end
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                if status._clock == DAY then
                    put (autocraft, r_347);
                    p [[Прошло несколько часов.^Пока я спал, неподалёку от
                    меня, возле строительной площадки остановился пассажирский
                    автокрафт. Из него вышли несколько человек, похоже
                    рабочих, и направились к стройплощадке.
                    ]];
                else
                    p 'Прошло несколько часов...';
                end
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_348 or to == r_337 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


autocraft = obj
{
    nam = 'автокрафт',
    exam = function (s)
        put (autocraft_door, r_347);
        p [[Я подошёл к автокрафту. Через стекло кабины водителя я заметил,
        что внутри никого нет. Дверца в автокрафт прикрыта, но не заперта.
        ]];
        return;
    end,
};


autocraft_door = obj
{
    nam = 'дверца',
    exam = function (s)
        return 'Дверца в автокрафт была прикрыта, но не заперта.';
    end,
    useit = function (s, w)
        if here() == r_347 then
            walk (r_347_autocraft_a);
        else
            p [[Я вышел из автокрафта. По-моему, никто не заметил, что я
            заходил в автокрафт. Рабочие занимались своими делами.
            ]];
            walk (r_347);
        end
        return;
    end,
};


r_347_autocraft_a = room
{
    nam = 'Автокрафт',
    _visit = 1,
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    pic = 'images/347_autocraft_a.png',
    enter = function (s, from)
        if from == r_347 then
            s._visit = 1;
        else
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p 'Я открыл дверцу и вошёл внутрь автокрафта.';
        else
            p 'Я вернулся в салон автокрафта.';
        end
        return;
    end,
    obj =
    {
        'autocraft_door',
        'autocraft_door_b'
    },
    rest = function (s)
        walk (r_347_autocraft_rest);
        return;
    end,
};


r_347_autocraft_rest = room
{
    nam = 'Автокрафт',
    hideinv = true,
    pic = 'images/artangs.png',
    dsc = function (s)
        p [[Я сел в кресло и меня стало клонить в сон. Проснулся я от того,
        что кто-то настойчиво тряс меня за плечо. Я открыл глаза. Рядом стояли
        артанги.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


autocraft_door_b = obj
{
    nam = 'дверь в кабину',
    _locked = true,
    exam = function (s)
        if s._locked then
            p 'Дверь в кабину автокрафта была заперта.';
        else
            p 'Дверь в кабину автокрафта была открыта.';
        end
        return;
    end,
    useit = function (s, w)
        if s._locked then
            p 'Дверь в кабину автокрафта была заперта.';
        else
            if here() == r_347_autocraft_a then
                walk (r_347_autocraft_b);
            else
                walk (r_347_autocraft_a);
            end
        end
        return;
    end,
    used = function (s, w)
        if w == wire then
            if not s._locked then
                p 'Я уже открыл дверь в кабину.';
            else
                s._locked = false;
                p [[С помощью куска проволоки мне удалось открыть простой
                замок, который запирал дверь в кабину автокрафта.
                ]];
            end
            return;
        end
    end,
};


r_347_autocraft_b = room
{
    nam = 'Кабина автокрафта',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    pic = 'images/347_autocraft_b.png',
    dsc = function (s)
          p [[Я вошёл внутрь. Пульт управления автокрафтом был под
          сигнализацией. Я вряд ли мог угнать эту машину.
          ]];
          if seen (autocraft_pass) then
             p [[На пульте управления я заметил специальный пропуск,
             оставленный водителем.
             ]];
          end
          return;
    end,
    obj =
    {
        'autocraft_door_b',
        'autocraft_pass'
    },
    rest = function (s)
        walk (r_347_autocraft_rest);
        return;
    end,
};


autocraft_pass = obj
{
    nam = 'пропуск',
    exam = function (s)
        return '«Восточный АПП города Тарана».';
    end,
    take = function (s)
        return 'Я взял пропуск.';
    end,
    drop = function (s)
        return 'Я бросил пропуск.';
    end,
};


r_348 = room
{
    nam = 'Квартал 323',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = 'r_349',
    south = 'r_338',
    west = 'r_347',
    pic = function (s)
        if seen (oldman) then
            if oldman._alive then
                return 'images/348_oldman.png';
            else
                return 'images/348_oldman_corpse.png';
            end
        else
            return 'images/348.png';
        end
    end,
    enter = function (s, from)
        if seen (oldman) then
            remove (oldman);
        end
        if not (status._clock == NIGHT) then
            if not oldman._killed then
                put (oldman);
            end
        end
        set_music ('music/28_taran_city.ogg');
        if from == r_347 or from == r_338 or from == r_349 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            if seen (oldman) then
                if oldman._alive then
                    p [[Я прошёл несколько жилых кварталов и оказался на улице
                    имени Плуда Врожера. На углу перекрёстка, под указателем
                    с надписью «Квартал 323» я заметил облезлого волосатого
                    старика.
                    ]];
                else
                    p [[Я был на улице имени Плуда Врожера. На углу
                    перекрёстка, под указателем с надписью «Квартал 323» лежал
                    облезлый волосатый старик.
                    ]];
                end
            else
                p [[Я прошёл несколько жилых кварталов и оказался на улице
                имени Плуда Врожера.
                ]];
            end
        end
        if s._visit == 2 then
            p [[Я стоял на улице имени Плуда Врожера под вывеской «Квартал
            323». Здесь всё было по-прежнему. Город жил привычной жизнью.
            ]];
        end
        return;
    end,
    rest = function (s)
        if seen (oldman) and oldman._killed then
--            status_change (2, 1, 1, 0, 0);
            walk (r_348_dead_body_remove_1);
            return;
        end
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Я зашёл в сквер, который находился на противоположной стороне
            улицы и, присев на скамейку, немного вздремнул.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_347 or to == r_338 or to == r_349 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


oldman = obj
{
    _alive = true,
    _killed = false,
    _examined = false,
    _talked = false,
    nam = 'старик',
    exam = function (s)
        if s._alive then
            p [[Старик был одет в засаленную одежду с тёмными разводами
            масляных пятен. На ногах — стоптанные ботинки. Грязная борода
            свисала клочьями. Помутневшие глаза смотрели на меня с полным
            безразличием.
            ]];
        else
            if not s._examined then
                s._examined = true;
                put (package, r_348);
                p [[Я обыскал труп. У старика в кармане лежал пакетик с
                каким-то порошком.
                ]];
            else
                p [[Я ещё раз обыскал труп, но больше ничего не нашёл.
                ]];
            end
        end
        return;
    end,
    talk = function (s)
        if not s._alive then
            return 'Старик был мёртв.';
        end
        if status._biomask then
            remove (oldman, r_348);
            p [[Едва увидев меня, старик свернул в подворотню и бросился
            бежать. Вскоре он скрылся из виду.
            ]];
        else
            if not s._talked then
                s._talked = true;
                walk (oldman_dlg_1);
            else
                p [[Старик, казалось, не слышал меня. Он смотрел прямо перед
                собой и что-то шептал про себя.
                ]];
            end
        end
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            if s._alive then
                s._alive = false;
                s._killed = true;
                p [[Я выхватил оружие. Старик не сопротивлялся, и я убил его.
                ]];
            end
            p [[Труп лежал возле моих ног.
            ]];
        end
        return;
    end,
    accept = function (s, w)
        if not s._alive then
            p 'Старик мёртв.';
            return false;
        else
            drop(w);
            remove (w, r_348);
            s._killed = true;
            take (package);
            remove (oldman, r_348);
            p [[Старик взял мой подарок и, повертев в руках, сунул его за
            пазуху. «Может быть пригодится,» — сказал он. Взамен этого он
            что-то сунул мне в руку и, озираясь по сторонам, повернул за угол
            и скрылся из виду.
            ]];
            return;
        end
    end,
};


oldman_dlg_1 = dlg
{
    nam = 'Квартал 323',
    hideinv = true,
    pic = 'images/348_oldman.png',
    dsc = function (s)
        p [[Заметив, что я проявил к нему интерес, старик сразу начал
        говорить, оборвав меня на полуслове.^— Дорогой, мне наплевать кто ты.
        Мне плевать кого ты любишь или не любишь в этом дерьмовом мире. Я хочу
        только одного — денег. Дай мне немного. Да пусть тебя хранит Молчание
        Темпора.
        ]];
        return;
    end,
    phr =
    {
        {
            -- 1,
            [[У меня ничего нет, дай пройти.]],
            [[— Подожди, не горячись. Вижу, что ты богат, но стоишь не на том
            пути. Вспомнишь меня потом, когда попробуешь кое-что. Я не жадный.
            Я-то всем помогаю. Возьми вот это. А меня, если чего будет нужно,
            сможешь найти всегда, если захочешь. Счастливо. — Сказав это,
            старик развернулся и медленно пошёл прочь.
            ]],
            [[ take (package); oldman._killed = true; objs(r_348):del(oldman); back();]]
        };
        {
            -- 2,
            [[Что такое? О чём ты говоришь? Какой Темпор?]],
            nil,
            [[ walk (oldman_dlg_21); return; ]]
        };
        {
            -- 3,
            [[Подожди, может сейчас что-нибудь дам.]],
            [[— О, ты добрый человек! дай что-нибудь, а я тебе дам взамен
            кое-что.
            ]],
            [[ back(); ]]
        };
    },
};


oldman_dlg_21 = room
{
    nam = 'Квартал 323',
    hideinv = true,
    pic = 'images/348_oldman.png',
    dsc = function (s)
        p [[— А, ты оказывается, не местный. Неужели ты ничего не слышал про
        Темпор Раксслы? Конечно, наверное, слышал. Другие миры, вселенные,
        богатства неисследованных планет... Только вот вся эта куча дерьма
        обернулась для нас, жителей Раккслы, страшной напастью.^Посмотри на
        этих монстров — артангов. Они ведь все оттуда, из тех вселенных...
        Мы жили в раю, а теперь? Теперь рай превратился в ад!^Хо-хо-хо...
        Но все ждут чуда, которого нет! Все ждут, что Темпор закроется. Кукиш!
        Теперь артанги — хозяева этой жизни. И Темпор подчиняется только им.
        Артангов — тьма. Они превратят в пыль любую галактику. Их владения —
        миллион парсек пространства.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'oldman_dlg_22') },
};


oldman_dlg_22 = room
{
    nam = 'Квартал 323',
    hideinv = true,
    pic = 'images/348_oldman_corpse.png',
    enter = function (s, from)
        oldman._alive = false;
    end,
    dsc = function (s)
        p [[Ха-ха-ха! — у старика закатились глаза, он повалился на землю и
        забился в конвульсиях.^Через минуту он скончался. Труп старика лежал
        возле стены дома, прямо под вывеской «Ул. им. Плуда Врожера. Квартал
        323».
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_348') },
};


package = obj
{
    nam = 'пакетик',
    exam = function (s)
        return 'Препарат «Брейк», одна порция.';
    end,
    take = function (s)
        return 'Я взял пакетик.';
    end,
    drop = function (s)
        return 'Я бросил пакетик.';
    end,
};


r_348_dead_body_remove_1 = room
{
    nam = 'Квартал 323',
    hideinv = true,
    pic = 'images/police.png',
    dsc = function (s)
        p [[Пока я отдыхал, подъехал полицейский автокрафт и подобрал труп
        старика.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_348_dead_body_remove_2') },
};


r_348_dead_body_remove_2 = room
{
    nam = 'Квартал 323',
    hideinv = true,
    pic = 'images/348.png',
    dsc = function (s)
        return 'На меня никто не обратил внимания.';
    end,
    obj = { vway('1', '{Далее}', 'r_348') },
};


r_349 = room
{
    nam = 'Квартал 324',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = nil,
    south = 'r_339',
    west = 'r_348',
    pic = 'images/349.png',
    enter = function (s, from)
        set_music ('music/28_taran_city.ogg');
        if from == r_339 or from == r_348 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 3 then
                s._visit = 3;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вышел к 324 кварталу города. Дома здесь были небольшие,
            одно- и двухэтажные. Похоже, что звёздные волки, осевшие на
            Ракксле, строили тут временные пристанища, которые в конце концов
            стали постоянными.
            ]];
        end
        if s._visit == 2 then
            p [[Я находился в районе 324 квартала. На улицах не было ни души.
            Потомки первых колонизаторов Раккслы уединились в своих
            домах-крепостях и редко выходили в свет.
            ]];
        end
        if s._visit == 3 then
            p [[Здесь было тихо и безлюдно. Как ни странно, но за время своего
            путешествия я не встретил в этом районе ни одного артанга. Похоже,
            что они не очень любили захаживать в район, где жили потомки
            первых колонизаторов Раккслы.
            ]];
        end
        return;
    end,
    obj = { 'box_12' },
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Выбрав удобное место под развесистым деревом, я немного
            вздремнул.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
        return;
    end,
    exit = function (s, to)
        if to == r_339 or to == r_348 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


box_12 = obj
{
    nam = 'квартал',
    exam = function (s)
        p 'Я прошёлся по улице и, наконец, нашёл дом с табличкой «Бокс 12».';
        walk (r_349_12);
        return;
    end,
    useit = function (s)
        p 'Я прошёлся по улице и, наконец, нашёл дом с табличкой «Бокс 12».';
        walk (r_349_12);
        return;
    end,
};


quarter_324 = obj
{
    nam = 'квартал 324',
    exam = function (s)
        p 'Я вернулся в 324 квартал.';
        walk (r_349);
        return;
    end,
    useit = function (s)
        p 'Я вернулся в 324 квартал.';
        walk (r_349);
        return;
    end,
};



r_349_12 = room
{
    nam = 'Бокс 12',
    _visit = 0,
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    pic = function (s)
        if seen (box_12_guardian) then
            return 'images/349_12_guardian.png';
        else
            return 'images/349_12.png';
        end
    end,
    dsc = function (s)
        p 'Большой двухэтажный дом с роскошным крыльцом и массивной дверью.';
        return;
    end,
    obj =
    {
        'quarter_324',
        'box_12_door'
    },
    rest = function (s)
        if seen (box_12_guardian) then
            return 'Сейчас было не самое подходящее время, чтобы отдыхать.';
        end
        if r_349._rested == 0 then
            r_349._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p [[Выбрав удобное место под развесистым деревом, я немного
            вздремнул.
            ]];
        else
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                return 'Прошло несколько часов...';
            end
        end
    end,
    exit = function (s, to)
        if to == r_349 and (seen (box_12_guardian)) then
            p 'Мне не следовало уходить сейчас.';
            return false;
        end
    end,
};


box_12_door = obj
{
    nam = 'дверь',
    _examined = false,
    exam = function (s)
        if not s._examined then
            s._exmined = true;
            put (box_12_eye, r_349_12);
            put (box_12_bell, r_349_12);
        end
        p [[Дверь с видеоглазком, сделанная из прочного материала. На двери я
        заметил кнопку звонка.
        ]];
        return;
    end,
};


box_12_eye = obj
{
    nam = 'глазок',
    _seen_case = false,
    _seen_medallion = false,
    exam = function (s)
        return 'Видеоглазок.';
    end,
    used = function (s, w)
        if w == black_case then
            if not have (black_case) then
                p 'У меня нет футляра.';
            else
                p 'Я приставил к глазку футляр.';
                s._seen_case = true;
                if box_12_bell._belled and s._seen_case and s._seen_medallion then
                    box_12_bell._belled = false;
                    put (box_12_guardian, r_349_box_12);
                    p [[За дверью послышалось какое-то движение и через минуту
                    она распахнулась. На пороге стоял мужчина средних лет с
                    гравимётом в руках.
                    ]];
                    return;
                end
            end
            return;
        end
        if w == medallion then
            if not have (medallion) then
                p 'У меня нет медальона.';
            else
                p 'Я приставил к глазку свой медальон.';
                s._seen_medallion = true;
                if box_12_bell._belled and s._seen_case and s._seen_medallion then
                    box_12_bell._belled = false;
                    put (box_12_guardian, r_349_box_12);
                    p [[За дверью послышалось какое-то движение и через минуту
                    она распахнулась. На пороге стоял мужчина средних лет с
                    гравимётом в руках.
                    ]];
                end
            end
            return;
        end
    end,
};


box_12_bell = obj
{
    nam = 'звонок',
    _belled = false,
    exam = function (s)
        return 'Кнопка звонка.';
    end,
    useit = function (s)
        if seen (box_12_guardian) then
            p 'Дверь уже открыта. Звонить ещё раз не было смысла.';
        else
            s._belled = true;
            box_12_eye._seen_case = false;
            box_12_eye._seen_medallion = false;
            p [[Я позвонил в дверь, но мне никто не открыл. За дверью — ни
            шороха.
            ]];
        end
        return;
    end,
};


box_12_guardian = obj
{
    nam = 'мужчина',
    exam = function (s)
        p [[Мужчина был одет в лётный комбинезон. На рукаве комбинезона я
        разглядел нашивку с каким-то гербом и надписью «Каменный рыцарь».
        В руках мужчина сжимал многозарядный гравимёт модели «Плазма-666».
        ]];
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (box_12_attack);
            return;
        end
    end,
    talk = function (s)
        if here() == r_349_12 then
            walk (box_12_prelude);
        else
            p 'Я обратился к охраннику, но он не стал со мной разговаривать.';
        end
        return;
     end,
};


box_12_attack = room
{
    nam = 'Бокс 12',
    hideinv = true,
    _outside = true,
    pic = function (s)
        if s._outside then
            return 'images/349_12_guardian.png';
        else
            return 'images/349_12_inside.png';
        end
    end,
    enter = function (s, from)
        if from == r_349_12 then
            s._outside = true;
        else
            s._outside = false;
        end
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Я не успел ничего сделать. Поняв мои намерения, мужчина выстрелил
        навскидку из гравимёта. Моё сознание растворилось во тьме
        мироздания...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};


box_12_prelude = room
{
    nam = 'Бокс 12',
    hideinv = true,
    pic = 'images/349_12_guardian.png',
    enter = function (s, from)
        set_music ('music/15_searching_case.ogg');
        remove (box_12_guardian, r_349_12);
    end,
    dsc = function (s)
        p [[Едва я открыл рот, чтобы поприветствовать хозяина дома, как тот
        остановил меня:^— Следуй за мной.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'box_12_inside') },
};


box_12_inside = room
{
    nam = '...',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _just_enter = true,
    pic = 'images/349_12_inside.png',
    enter = function (s, from)
        if from == r_349_12 then
            s._just_enter = true;
        else
            s._just_enter = false;
        end
        me():enable_all();
    end,
    dsc = function (s)
        if s._just_enter then
            p [[Мы вошли в дом, пересекли прихожую и поднялись на второй этаж.
            Человек с гравимётом провёл меня в гостиную, где меня встретил
            высокий мужчина.^— Здравстуйте, — сказал он. — Присаживайтесь.
            Меня зовут Эдуард Скол. Чем могу служить? Судя по всему, Вы пришли
            ко мне не с пустыми руками?
            ]];
        else
            p [[Я находился в гостиной. Передо мной стоял Эдуард Скол и его
            охранник.
            ]];
        end
        return;
    end,
    obj =
    {
        'box_12_guardian',
        'edward'
    },
    rest = function (s)
        return 'Мне некогда было отдыхать.';
    end,
};


edward = obj
{
    nam = 'Эдуард Скол',
    _wait_case = false,
    exam = function (s)
        p [[Высокий мужчина с крепкими сильными руками. Одет в обыкновенный
        гражданский костюм.
        ]];
        return;
    end,
    used = function (s, w)
        if w == neurowhip then
            walk (box_12_attack);
            return;
        end
    end,
    talk = function (s)
        if s._wait_case then
            p [[Я начал что-то объяснять Эдуарду Сколу, но он ждал пока я ему
            отдам футляр.
            ]];
        else
            walk (edward_dlg);
        end
        return;
    end,
    accept = function (s, w)
        if w == black_case then
            remove (black_case, inv());
            walk (edward_story_1);
            return;
        else
            p 'Эдуард Скол покачал головой:^— Это мне не нужно.';
            return false;
        end
    end,
};


edward_dlg = dlg
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    phr =
    {
        { tag = 'first' },
        {
            [[Я кое-что принёс для Вас.]],
            [[— Я видел в видеоглазок какой-то чёрный футляр. Если это то,
            что я думаю... Я так понял, что ты, парень, пошёл по стопам своего
            отца?
            ]];
            [[ poff ('first'); pjump ('second'); ]]
        };
        {
            [[Я из Военного Совещания ЦСЧК, служебный позывной «Неустрашимый».
            ]],
            [[— Наслышан, наслышан... Как же тебе удалось... Невероятно!
            Ну так что ты принёс?
            ]],
            [[ poff ('first'); edward._wait_case = true; back (); ]]
        };
        { tag = 'second' },
        {
            [[Я выполнял последнюю просьбу отца — он велел передать это Вам.
            ]],
            [[— Хорошо. Я знал твоего отца, парень. Это был очень смелый
            человек.
            ]],
            [[ poff ('second'); edward._wait_case = true; back (); ]]
        };
        {
            [[Я бы хотел кое-что получить взамен этого.]],
            [[— И что же ты хотел бы?]],
            [[ poff ('second'); pjump ('third'); ]]
        };
        { tag = 'third' },
        {
            [[Денег!]],
            nil,
            [[ poff ('third'); walk (box_12_money_1); return; ]]
        };
        {
            [[Мне нужно выбраться отсюда хоть к чёртовой бабушке!
            ]],
            [[— Подожди, не горячись. Горячая голова твоего отца его и
            погубила. Что ты принёс?
            ]],
            [[ poff ('third'); edward._wait_case = true; back ();]]
        };
    },
};


box_12_money_1 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[— О-о-о, твой отец не был таким жадным до денег. Впрочем, Биг, дай
        ему денег и пусть убирается. И забери у него футляр!
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'box_12_money_2') },
};


box_12_money_2 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_guardian.png',
    enter = function (s, from)
        remove (black_case, inv());
    end,
    dsc = function (s)
        p [[Человек с гравимётом забрал у меня футляр и проводил вниз.]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_349_12') },
    exit = function (s)
        p [[Когда захлопнулась дверь, я вдруг понял, что они не заплатили мне
        ни креда!
        ]];
        return;
    end,
};


edward_story_1 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[Скол взял футляр и несколько секунд внимательно рассматривал его.
        Затем, не говоря ни слова, он прошёл к книжному шкафу, достал из него
        какой-то приборчик с кнопкой, и, приложив его к футляру, нажал на
        кнопку. Послышалось лёгкое шипение и треск. В воздухе запахло озоном.
        Потом я услышал хлопок и увидел, что футляр раскрылся. Из него Эдуард
        Скол достал что-то похожее на бинокль и обрывок старинной карты.
        Какое-то время он крутил обрывок в руках, изучая рукописные пометки,
        сделанные на полях. Затем стал рассматривать бинокль. Я внимательно
        наблюдал за Сколом. Похоже, что он был слегка разочарован. И, видимо,
        разочаровал его обрывок карты.^— Здесь нет самого главного — места,
        где спрятаны сокровища! — с сожалением сказал Скол.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_2') },
};


edward_story_2 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[Опомнившись, он посмотрел на меня.^— Но, коли ты принёс это мне,
        думаю, кое-что придётся тебе объяснить. Дело в том, что около двухсот
        лет назад на Ракксле исчезла знаменитая «Чёрная Кобра», пожалуй, самый
        дорогой корабль Вселенной. На его борту находилось гигантское
        состояние. Сначала все думали, что «Чёрная Кобра» ушла через Темпор к
        другим мирам и потерялась там, но, неожиданно, стали появляться
        косвенные сведения о том, что она всё-таки осталась на Ракксле. Или
        вернулась на неё.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_3') },
};


edward_story_3 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[— Дело в том, что командир «Чёрной Кобры», Артур Кинг возглавлял в
        то время лигу «Тёмное Колесо». И часть ценностей, которые находились
        на борту «Чёрной Кобры» принадлежали Лиге. Лишившись целого состояния,
        Лига распалась на несколько независимых враждующих групп.^Наша группа,
        «Каменный Рыцарь», как впрочем и другие группы, до сих пор активно
        ищет сокровища. Нам нужны деньги, много денег. Без них мы не сможем
        серьёзно противостоять артангам. И дело теперь не в «Чёрной Кобре» —
        её нашёл твой отец. Правда, эту тайну он скрывал до последних своих
        дней. Я сам только что узнал об этом...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_4') },
};


edward_story_4 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[— Посмотри на карту. Видишь, здесь крестиком отмечено место, где
        лежит «Чёрная Кобра» — северо-западная часть острова «О»...^Что с
        тобой? Тебе плохо? Что ты говоришь???
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_5') },
};


edward_story_5 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[Я рассказал Сколу о своих похождениях. Внимательно выслушав меня,
        Скол подумал и сказал:^— В винтолёте не могло быть Артура Кинга. Твой
        отец нашёл «Чёрную Кобру» в законсервированном состоянии. На карте это
        указано. То есть «Чёрная Кобра» вернулась на Раккслу без экипажа...^
        Я так думаю, что в винтолёте ты встретился со своим отцом...
        Понимаешь, эта история такова, что «Чёрная Кобра» исчезла в 3551 году.
        А нашествие началось в 3550. То есть битва за Раккслу, в которой
        «Тёмное Колесо» потерпело поражение, была за год до исчезновения
        «Чёрной Кобры». После этой битвы Лига и снарядила корабль, чтобы
        закупить вооружение, технологии и прочее для ведения войны.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_6') },
};


edward_story_6 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[— И ещё. Никто не видел тела твоего отца. Никто... Я не знаю
        откуда у него браслет, но знаю точно — «Чёрная Кобра» вернулась на
        Раккслу намного позже нашествия артангов. Да и не мог винтолёт с
        «Чёрной Кобры» участвовать в битве за Раккслу — в то время «Кобры» в
        этих краях не было. Кстати, твой отец написал на этом обрывке всё
        достаточно подробно. Вот, читай:^«Чёрная Кобра. Найдена в режиме
        полной консервации. По данным внутренних часов, время возвращения —
        первая половина 3690 года. Грузовые отсеки корабля пусты. Сведений об
        экипаже нет.^Капитан разведки «Тёмного Колеса» — «Сыщик».^Твой отец
        исполнил свой долг до конца. Только удивительно как он сумел
        предвидеть твоё появление на Ракксле?
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_7') },
};


edward_story_7 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[— Ладно, теперь о главном. На юге от Тарана находится та самая
        Темпоральная Зона. Её ещё называют Темпоральным Полем. Двести лет
        назад Темпор использовали для перелёта в другие Вселенные, из него же
        пришли к нам артанги. Теперь Темпор закрыт и охраняется этими тварями.
        Никто, кроме артангов, не может им воспользоваться. И это понятно —
        артанги никого не допустят к колыбели своей цивилизации. Но их
        колыбель ещё надо найти среди миллиардов чужих звёзд. Кто они,
        откуда — это неизвестно никому. Зато все знают, какими возможностями
        они располагают. Найти ключ к разгадке тайны артангов — значит найти
        ключ к наше общей победе. И Лига «Каменный Рыцарь» готова сотрудничать
        с Военным Совещанием, таргонами и даже с самим дьяволом, лишь бы
        убрать этих тварей из нашей Вселенной.^Мы много раз пытались
        проникнуть в Темпоральную Зону, но безрезультатно. Те, которым удалось
        преодолеть охрану, погибали в Темпоральных бурях, которые там бушуют.
        То, что передал нам твой отец, поможет нам в Темпоре. Этот бинокль
        позволяет найти выход. Только вот... Мне кажется, будет справедливее,
        если я отдам его тебе. Ведь так завещал твой отец.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_8') },
};


edward_story_8 = room
{
    nam = '...',
    hideinv = true,
    pic = 'images/349_12_inside.png',
    dsc = function (s)
        p [[— Помни: в Темпор нельзя влететь на современных кораблях с
        аннигиляционным горючим — это чревато гибелью. Винтолёты, не
        использующие такое горючее, более подходят для этой цели.^И знай,
        артанги полностью контролируют всё воздушное пространство Раккслы.^
        Возьми вот этот электронный навигатор — он поможет тебе в полёте.
        Больше, пожалуй, мы ничем тебе не сможем помочь. Понимаем, что тебе
        нужно связаться со своими, но... У нас ещё очень много дел здесь, на
        Ракксле... Мы готовим восстание и не хотелось бы пока лишний раз
        общаться с артангами...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'edward_story_9') },
};


edward_story_9 = room
{
    nam = 'Бокс 12',
    hideinv = true,
    pic = 'images/349_12.png',
    dsc = function (s)
        p [[...Когда я вышел из дома Эдуарда Скола, я некоторое время
        осмысливал шкал информации, обрушившийся на меня. Мне многое
        предстояло сделать.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_349_12') },
    exit = function (s)
        take (enavigator);
        take (binoculars);
    end,
};


enavigator = obj
{
    nam = 'э-навигатор',
    exam = function (s)
        return 'Карточка электронного навигатора.';
    end,
    take = function (s)
        return 'Я взял Э-навигатор.';
    end,
    drop = function (s)
        return 'Я бросил Э-навигатор.';
    end,
};


binoculars = obj
{
    nam = 'бинокль',
    exam = function (s)
        return 'Анализатор темпорального поля.';
    end,
    take = function (s)
        return 'Я взял бинокль';
    end,
    drop = function (s)
        return 'Я бросил бинокль';
    end,
    useit = function (s)
        if objs(tempor):look(clot) then
            clot:enable();
            p [[Я посмотрел в бинокль. Удивительно... Я видел огромный, просто
            гигантский сгусток, скорее похожий на торнадо. Странно, но без
            анализатора я не видел этого гигантского образования.
            ]];
        else
            p 'Я посмотрел в бинокль.';
        end
        return;
    end,
};

