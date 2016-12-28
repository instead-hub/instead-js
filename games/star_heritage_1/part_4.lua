r_412 = room
{
    nam = 'Ангар',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _visit = 0,
    pic = 'images/412.png',
    enter = function (s, from)
        if from == r_422 then
            s._visit = 1;
        end
        if from == fly_cabin then
            s._visit = 2;
        end
        if from == r_412_attack_2 then
            s._visit = 3;
            set_music ('music/31_black_cobra.ogg');
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[ оказался в просторном ангаре «Чёрной Кобры». Посреди ангара я
            увидел затянутую огромной паутиной одноместную воздушную шлюпку
            «Муха».
            ]];
        end
        if s._visit == 2 then
            p [[Я вылез из «Мухи».]];
        end
        if s._visit == 3 then
            p [[Мне удалось одолеть гигантского паука. Его мёртвое тело лежало
            возле забрызганной кровью стены ангара.
            ]];
        end
        return;
    end,
    rest = function (s)
        if r_432._rested == 0 then
            r_432._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов.';
        end
        if r_432._rested == 1 then
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
    obj =
    {
        'cobra_hatch',
        'fly'
    },
};


fly = obj
{
    nam = 'шлюпка «Муха»',
    exam = function (s)
        if spider._alive then
            walk (r_412_attack_1);
        else
            p 'Одноместная воздушная шлюпка «Муха».';
        end
        return;
    end,
};


fly_hatch = obj
{
    nam = 'люк «Мухи»',
    exam = function (s)
        return 'Люк одноместной воздушной шлюпки «Муха».';
    end,
    useit = function (s)
        if here() == r_412 then
            walk (fly_cabin);
        else
            walk (r_412);
        end
        return;
    end,
};


spider = obj
{
    nam = 'труп паука',
    _alive = true,
    exam = function (s)
        return 'Паук был мёртв.';
    end,
};


r_412_attack_1 = room
{
    nam = 'Ангар',
    hideinv = true,
    pic = 'images/412.png',
    dsc = function (s)
        p [[Я подошёл к шлюпке и осмотрел её. Кажется, она ещё способна
        летать. Когда я обходил шлюпку вокруг, моя нога зацепилась за паутину,
        и я чуть не упал.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_412_attack_2') },
};


r_412_attack_2 = room
{
    nam = 'Ангар',
    hideinv = true,
    pic = 'images/412_spider.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Спустя мгновение рядом возник гигантский чёрный паук и с тихим
        причмокиванием бросился на меня.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_412') },
    exit = function (s)
        spider._alive = false;
        put (spider, r_412);
        put (fly_hatch, r_412);
    end,
};


fly_cabin = room
{
    nam = '«Муха»',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _visit = 0,
    pic = 'images/fly_cabin.png',
    enter = function (s, from)
        s._visit = s._visit + 1;
        if s._visit > 2 then
            s_visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Кое-как освободив шлюпку от паутины, я залез внутрь. Пульт
            «Мухи» был похож на пульт челнока, на котором мне уже доводилось
            летать.
            ]];
        else
            p [[Я снова залез внутрь. Пульт «Мухи» был похож на пульт челнока,
            на котором мне уже доводилось летать.
            ]];
        end
        return;
    end,
    rest = function (s)
        if r_432._rested == 0 then
            r_432._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов.';
        end
        if r_432._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов.';
            end
            return;
        end
    end,
    obj =
    {
        'fly_hatch',
        'fly_console'
    },
};


fly_console = obj
{
    nam = 'пульт',
    _destination = 0,
    exam = function (s)
        put (fly_hole, fly_cabin);
        p [[На передней панели была щель для карточки электронного навигатора.
        ]];
        return;
    end,
    useit = function (s)
        if not fly_hole._navigator then
            p 'Безрезультатно.';
        else
            walk (fly_dlg);
        end
        return;
    end,
};


fly_hole = obj
{
    nam = 'щель',
    _navigator = false,
    exam = function (s)
        p 'Щель для карточки электронного навигатора.';
        return;
    end,
    used = function (s, w)
        if w == enavigator then
            if have (enavigator) then
                s._navigator = true;
                remove (enavigator, inv());
                p [[Я вставил карточку в щель. Автоматически захлопнулся люк
                кабины и на пульте вспыхнула надпись: «Введите цель».
                ]];
            else
                p 'У меня нет э-навигатора.';
            end
            return;
        end
    end,
};


fly_dlg = dlg
{
    nam = '«Муха»',
    hideinv = true,
    pic = 'images/fly_cabin.png',
    dsc = 'Выберите цель полёта:';
    phr =
    {
        {
            1,
            [[Темпоральная зона. Квадрат А.]],
            nil,
            [[poff(1,2); walk (fly_fly_tempor_1); return;]]
        };
        {
            2,
            [[Город Аркан.]],
            nil,
            [[poff(1,2); walk (fly_fly_arkan_1); return;]]
        };
    },
};


fly_fly_arkan_1 = room
{
    nam = '«Муха»',
    hideinv = true,
    pic = 'images/fly_cabin.png',
    enter = function (s, from)
        set_music ('music/01_intro.ogg');
    end,
    dsc = function (s)
        p [[Медленно, со скрежетом, распахнулись створки грузового шлюза, и
        шлюпка взмыла ввысь...^Через несколько часов я уже стоял на взлётном
        поле города Аркана.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_213_lucky_end_3a') },
};


fly_fly_tempor_1 = room
{
    nam = '«Муха»',
    hideinv = true,
    pic = 'images/fly_cabin.png',
    dsc = function (s)
        p [[С борта моей «Мухи» электронный навигатор послал сигнал створкам
        грузового шлюза. Медленно, со скрежетом они распахнулись, и шлюпка
        взмыла ввысь...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'fly_fly_tempor_2') },
};


fly_fly_tempor_2 = room
{
    nam = '«Муха»',
    hideinv = true,
    pic = 'images/fly_cabin.png',
    dsc = function (s)
        p 'Шлюпка приземлилась через час полёта.';
        return;
    end,
    obj = { vway('1', '{Далее}', 'tempor') },
};


r_421 = room
{
    nam = 'Рубка',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _visit = 0,
    pic = 'images/421.png',
    dsc = function (s)
        p [[Я вошёл в рубку. Сквозь помутневшее стекло сюда едва добирались
        лучи солнца. Пульт корабля был затянут паутиной.
        ]];
        return;
    end,
    rest = function (s)
        if r_432._rested == 0 then
            r_432._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов.';
            return;
        end
        if r_432._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов.';
            end
            return;
        end
    end,
    obj =
    {
        'cobra_cabin_door',
        'cobra_console'
    },
};


cobra_console = obj
{
    nam = 'пульт',
    exam = function (s)
        return 'Системы управления неисправны.';
    end,
};


r_422 = room
{
    nam = 'Центральный отсек',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _visit = 0,
    _rested = 0,
    pic = 'images/422.png',
    enter = function (s, from)
        set_music ('music/31_black_cobra.ogg');
        if from == r_432 then
            s._visit = 1;
        else
            s._visit = 2;
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вошёл внутрь. Здесь было темно и довольно сыро. В полутьме я
            заметил люк и две двери, которые вели в разные отсеки корабля.
            ]];
            return;
        end
        if s._visit == 2 then
            p [[Я снова вышел в центральный отсек. Здесь было темно и довольно
            сыро. Я видел люк и две двери, которые вели в разные отсеки
            корабля.
            ]];
            return;
        end
    end,
    rest = function (s)
        if r_432._rested == 0 then
            r_432._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            return;
        end
        if r_432._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов.';
            end
            return;
        end
    end,
    obj =
    {
        'cobra_lock',
        'cobra_cabin_door',
        'cobra_cargo_door',
        'cobra_hatch'
    },
};


cobra_cabin_door = obj
{
    nam = 'дверь рубки',
    exam = function (s)
        return 'Это дверь рубки.';
    end,
    useit = function (s)
        if here() == r_422 then
            walk (r_421);
        else
            walk (r_422);
        end
        return;
    end,
};


cobra_cargo_door = obj
{
    nam = 'дверь карго',
    exam = function (s)
        return 'Это дверь грузового отсека.';
    end,
    useit = function (s)
        if here() == r_422 then
            walk (r_423);
        else
            walk (r_422)
        end
        return;
    end,
};


cobra_hatch = obj
{
    nam = 'люк',
    exam = function (s)
        return 'Обычный люк.';
    end,
    useit = function (s)
        if here() == r_422 then
            walk (r_412);
        else
            walk (r_422)
        end
        return;
    end,
};


r_423_forest = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/433.png',
    enter = function (s)
        lifeoff(ghost7);
        set_music ('music/02_invasion.ogg');
    end,
    dsc = function (s)
        p [[Здесь находились сразу несколько отрядов карликов. Едва увидев
        незванного гостя, один из карликов бросил боевой клич и на меня
        обрушился целый град камней и стрел. Теряя сознание я рухнул на
        землю...
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};



r_423 = room
{
    nam = 'Грузовой отсек',
    north = nil,
    east = nil,
    south = nil,
    west = nil,
    _visit = 0,
    _rested = 0,
    pic = 'images/423.png',
    enter = function (s, from)
        if from == r_422 then
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вошёл в грузовой отсек. Здесь было пусто. Толстый слой пыли
            покрывал пол и стеллажи.
            ]];
        end
        if s._visit == 2 then
            p [[Я вошёл внутрь. Здесь было темно и довольно сыро. В полутьме я
            заметил люк и две двери, которые вели в разные отсеки корабля.
            ]];
        end
        return;
    end,
    rest = function (s)
        if r_432._rested == 0 then
            r_432._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            return;
        end
        if r_432._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов.';
            end
            return;
        end
    end,
    obj = { 'cobra_cargo_door' },
};



r_432 = room
{
    nam = 'Поле',
    north = nil,
    east = 'r_433',
    south = nil,
    west = nil,
    _visit = 0,
    _rested = 0,
    pic = 'images/432.png',
    enter = function (s, from)
        if from == r_433 then
            s._rested = 0;
            set_music ('music/29_mystery_of_island_o.ogg');
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Пройдя мимо поселения лесных карликов, я вышел на заросшее
            высокой травой поле. С севера, юга и запада поле окружали
            неприступные скалы. Прямо передо мной, утопая в высокой траве и
            заросший мхом, лежал космический корабль «Кобра МК-3».
            ]];
        end
        if s._visit == 2 then
            p 'Я вышел наружу.';
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
            else
                status_change (-2, -1, -1, 0, 0);
                p 'Прошло несколько часов.';
            end
            return;
        end
    end,
    obj = { 'cobra' },
    exit = function (s, to)
        if to == r_433 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


cobra = obj
{
    nam = '«Кобра МК-3»',
    exam = function (s)
        put (cobra_lock, r_432);
        p [[На заросшем мхом фюзеляже была еле заметная надпись: «Чёрная
        Кобра». На правом борту корабля — распахнутые створки наполовину
        засыпанного землёй шлюзового отсека.
        ]];
        return;
    end,
};


cobra_lock = obj
{
    nam = 'шлюзовой отсек',
    exam = function (s)
        p 'Засыпанный землёй и заросший мхом шлюзовой отсек.';
        return;
    end,
    useit = function (s)
        if here() == r_432 then
            walk (r_422);
        else
            walk (r_432);
        end
        return;
    end,
};



r_433 = room
{
    nam = 'Лес',
    north = nil,
    east = 'r_434',
    south = 'r_423_forest',
    west = 'r_432',
    _visit = 0,
    _rested = 0,
    pic = 'images/433.png',
    enter = function (s, from)
        if from == r_432 or from == r_434 then
            if not (ghost7._active and ghost7._state > 1) then
                lifeoff (ghost7);
                walk (r_141);
                return;
            end
            s._rested = 0;
            set_music ('music/29_mystery_of_island_o.ogg');
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Я вошёл в лес. Мимо, не замечая меня, прошёл целый отряд
            вооружённых луками и копьями мохнатых карликов. На каждом дереве,
            в больших гнёздах сидели лучники. На меня никто не обратил
            внимания.
            ]];
        end
        if s._visit == 2 then
            p 'bug!';
        end
        return;
    end,
    rest = function (s)
        walk (r_433_rest_end);
        return;
    end,
    exit = function (s, to)
        if to == r_432 or to == r_434 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_433_rest_end = room
{
    nam = 'Лес',
    hideinv = true,
    pic = 'images/433.png',
    enter = function (s)
        lifeoff(ghost7);
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Прошло несколько часов. Внезапно один из карликов бросил боевой
        клич, и на меня обрушился целый град камней и стрел. Теряя сознание,
        я рухнул на землю.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'the_end') },
};



r_434 = room
{
    nam = 'Лес',
    north = nil,
    east = 'r_435',
    south = nil,
    west = 'r_433',
    _visit = 0,
    _rested = 0,
    pic = 'images/434.png',
    enter = function (s, from)
        if from == r_433 or from == r_435 then
            s._rested = 0;
            set_music ('music/30_returning_to_island_o.ogg');
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Спустя несколько часов я вышел к лесу. Далеко на севере
            по-прежнему бушевало море. С юга лес окружали скалы. С запада до
            меня доносились крики лесных обитателей.
            ]];
        end
        if s._visit == 2 then
            p [[Я вошёл в лес. Позади, на востоке, остался пустынный берег
            моря. По-моему, идти дальше было небезопасно. Лёгкий ветер
            доносил до меня крики лесных обитателей.
            ]];
        end
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
                return 'Прошло несколько часов.';
            end
        end
    end,
    obj = { 'bushes' },
    exit = function (s, to)
        if to == r_433 or to == r_435 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_435 = room
{
    nam = 'Берег моря',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = 'r_436',
    south = nil,
    west = 'r_434',
    pic = 'images/435.png',
    enter = function (s, from)
        set_music ('music/30_returning_to_island_o.ogg');
        if from == r_434 or from == r_436 then
            s._rested = 0;
            s._visit = s._visit + 1;
            if s._visit > 4 then
                s._visit = 4;
            end
        end
        if from == r_435_attack then
            s._visit = 2;
        end
        if s._visit == 1 then
            walk (r_435_attack);
            return;
        end
    end,
    dsc = function (s)
        if s._visit == 2 then
            p [[Бой был короткий, но жаркий. С карликами я разделался без
            особого труда. Два окровавленных трупа лежали возле моих ног.
            ]];
        end
        if s._visit == 3 then
            p [[Рядом с разбившимся винтолётом бушевало море. На берегу лежали
            два трупа агрессивных лесных жителей. Что искали эти
            доисторические существа в винтолёте? Или это было просто
            любопытством каменного века?
            ]];
        end
        if s._visit == 4 then
            p [[Я стоял возле разбившегося винтолёта. Теперь я мог с
            уверенностью сказать, что этот винтолёт стал могилой моего отца.
            Тайна обстоятельств его гибели до сих пор оставалась для меня за
            семью печатями.
            ]];
        end
        return;
    end,
    obj =
    {
        'helicopter_435',
        'furry_dwarfs_corpses'
    },
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
        if to == r_434 or to == r_436 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


helicopter_435 = obj
{
    nam = 'винтолёт',
    exam = function (s)
        helicopter_enter_435:enable();
        p [[Судя по форме, этому винтолёту было лет двести. Такие летательные
        аппараты уже давно не выпускались ни на одной цивилизованной планете
        Центрального Союза.
        ]];
        return;
    end,
    obj = { 'helicopter_enter_435' },
};


helicopter_enter_435 = obj
{
    nam = 'дыра в люке',
    exam = function (s)
        if here() == r_435 then
            walk (helicopter_435_inside);
        else
            walk (r_435);
        end
        return;
    end,
}:disable();


helicopter_435_inside = room
{
    nam = 'Винтолёт',
    pic = 'images/435_helicopter.png',
    dsc = function (s)
        p [[Я заглянул внутрь. Здесь пахло плесенью. На полу возле
        развороченного кресла лежали человеческие кости. Под креслом я
        обнаружил потайную нишу. Она была пуста. Судя по всему, эти карлики
        нашли тайник.
        ]];
        return;
    end,
    rest = function (s)
        if r_435._rested == 0 then
            r_435._rested = 1;
            status_change (2, 1, 1, 0, 0);
            return 'Прошло несколько часов. Я отдыхал и ни о чём не думал...';
        end
        if r_435._rested == 1 then
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
    obj = { 'helicopter_enter_435' },
};


furry_dwarfs_corpses = obj
{
    nam = 'трупы карликов',
    _examined = false,
    exam = function (s)
        if not s._examined then
            s._examined = true;
            put (spear, r_435);
            put (boulder, r_435);
            put (metal_box, r_435);
            p [[Я осмотрел трупы. У одного в руке было острое копьё.
            У другого — булыжник и небольшая металлическая коробка.
            ]];
        else
            p 'Я осмотрел трупы, но больше ничего не нашёл.';
        end
        return;
    end,
};


spear = obj
{
    nam = 'копьё',
    exam = function (s)
        return 'Острое короткое копьё.';
    end,
    take = function (s)
        return 'Я взял копьё.';
    end,
    drop = function (s)
        return 'Я бросил копьё.';
    end,
};


boulder = obj
{
    nam = 'булыжник',
    exam = function (s)
        return 'Обычный камень.';
    end,
    take = function (s)
        return 'Я взял булыжник.';
    end,
    drop = function (s)
        return 'Я бросил булыжник.';
    end,
};


metal_box = obj
{
    nam = 'коробка',
    _closed = true,
    exam = function (s)
        p [[«Косморазведка Лиги Тёмное Колесо. Прибор «Призрак-7»».
        ]];
        if s._closed then
            p [[Крышка коробки закрыта на миниатюрный замок.
            ]];
        end
        return;
    end,
    used = function (s, w)
        if w == boulder then
            if not (have (boulder)) then
                return 'У меня нет булыжника.';
            else
                s._closed = false;
                put (ghost7);
                drop (s);
                remove (s);
                p [[С помощью булыжника мне удалось сбить замок. В коробке я
                заметил небольшой прибор.
                ]];
                return;
            end
        end
    end,
    take = function (s)
        return 'Я взял коробку.';
    end,
    drop = function (s)
        return 'Я бросил коробку.';
    end,
};


ghost7 = obj
{
    nam = 'прибор',
    _active = false,
    _state = 3,
    exam = function (s)
        p 'Небольшой приборчик с маленькой красной кнопкой.';
        if s._active then
            p 'Изнутри раздётся тихое жужжание.';
        end
        return;
    end,
    take = function (s)
        return 'Я взял прибор.';
    end,
    drop = function (s)
        return 'Я бросил прибор.';
    end,
    useit = function (s)
        if s._active then
            p 'Прибор уже активирован.';
        else
            if s._state == 0 then
                p 'Я нажал на кнопку, но ничего не произошло.';
            else
                s._active = true;
                lifeon (s);
                p 'Я нажал на кнопку. Прибор тихо зажжужал.';
            end
        end
        return;
    end,
    life = function (s)
        s._state = s._state - 1;
        if s._state == 0 then
            s._active = false;
            lifeoff (s);
            return 'Прибор перестал жужжать.';
        end
    end,
};



r_435_attack = room
{
    nam = 'Берег моря',
    hideinv = true,
    pic = 'images/435_furry_dwarfs.png',
    enter = function (s)
        set_music ('music/07_battle.ogg');
    end,
    dsc = function (s)
        p [[Несколько часов я пробирался на запад. Едва я приблизился к
        знакомому мне винтолёту, как сразу увидел двух каких-то мохнатых
        карликов, которые возились возле открытого люка. Услышав шорох моих
        шагов, карлики обернулись и бросились на меня.
        ]];
        return;
    end,
    obj = { vway('1', '{Далее}', 'r_435') },
};



r_436 = room
{
    nam = 'Берег моря',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = 'r_437',
    south = nil,
    west = 'r_435',
    pic = 'images/436.png',
    enter = function (s, from)
        set_music ('music/30_returning_to_island_o.ogg');
        if from == r_327_fly_arkan_4 or from == r_435 or from == r_437 then
            s._rested = 0;
            s._just_enter = true;
            s._visit = s._visit + 1;
            if s._visit > 2 then
                s._visit = 2;
            end
        end
        if from == r_327_fly_arkan_4 then
            berries:disable();
        end
    end,
    dsc = function (s)
        if s._visit == 1 then
            p [[Когда я очнулся, то заметил, что нахожусь в местах, до боли
            знакомых. Это была северная часть острова О. На юге неприступной
            стеной стояли высокие скалы. На севере бушевало море. Вокруг меня
            белели в песке человеческие кости, рядом лежали остатки моей
            катапульты.
            ]];
        end
        if s._visit == 2 then
            p [[Здесь было по-прежнему тихо и неуютно. Белые кости погибших в
            жестокой схватке на берегу моря, пустые ящики из под боеприпасов и
            изуродованные ракетные установки оставляли гнетущее впечатление.
            ]];
        end
        return;
    end,
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
        if to == r_435 or to == r_437 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


r_437 = room
{
    nam = 'Карьер',
    _visit = 0,
    _rested = 0,
    north = nil,
    east = nil,
    south = nil,
    west = 'r_436',
    pic = 'images/437.png',
    enter = function (s, from)
        set_music ('music/30_returning_to_island_o.ogg');
        if from == r_436 then
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
            p [[Некоторое время я шёл на восток. Через несколько часов я вышел
            к уже знакомому мне туннелю. Каково же было моё удивление, когда я
            увидел, что часть скалы, в которой был прорублен ход, обвалилась,
            полностью закрыв вход в туннель. Причиной этому был мой челнок,
            который врезался в скалу. Среди горы камней я заметил дымящиеся
            обломки челнока.
            ]];
        end
        if s._visit == 2 then
            p [[Я стоял в карьере перед обрушившимся входом в туннель. Рядом
            лежали обломки моего челнока. Я понимал, что теперь пройти сквозь
            туннель мне не удастся.
            ]];
        end
        if s._visit == 3 then
            p [[Здесь было всё по-прежнему. Заваленный вход в туннель,
            пустынный карьер и обломки челнока. Я осмотрелся. Меня окружали
            высокие горы. С запада ветер приносил запахи моря и шум прибоя...
            ]];
        end
        return;
    end,
    rest = function (s)
        if s._rested == 0 then
            s._rested = 1;
            status_change (2, 1, 1, 0, 0);
            p 'Выбрав удобное место для отдыха, я немного вздремнул.';
            return;
        end
        if s._rested == 1 then
            if status._health == 1 then
                health_finish._from = deref(here());
                walk (health_finish);
                return;
            else
                status_change (-1, -1, -1, 0, 0);
                p 'Прошло несколько часов...';
                return;
            end
        end
    end,
    obj = { 'shuttle_wreckage' },
    exit = function (s, to)
        if to == r_435 or to == r_437 then
            health_finish._from = deref(here());
            clock_next ();
            status_change (-2, -1, -1, 0, 0);
            check_health();
            return;
        end
    end,
};


shuttle_wreckage = obj
{
    nam = 'обломки',
    _cracked = false,
    _examined = false,
    exam = function (s)
        if not s._cracked then
            p [[Я осмотрел обломки челнока. Было ясно, что корабль уже не
            восстановить.
            ]];
        else
            if not s._examined then
                s._examined = true;
                put (enavigator, r_437);
                p [[Я заглянул в приоткрывшуюся щель и заметил, что в
                развороченном пульте торчит карточка электронного навигатора.
                ]];
            else
                p [[Я ещё раз осмотрел обломки, но больше ничего не нашёл.]];
            end
        end
        return;
    end,
    used = function (s, w)
        if w == spear then
            if not s._cracked then
                s._cracked = true;
                p [[С помощью копья мне удалось приподнять разбитую крышку
                кабины.
                ]];
            else
                p 'Я уже поднял крышку кабины.';
            end
        end
        return;
    end,
};

