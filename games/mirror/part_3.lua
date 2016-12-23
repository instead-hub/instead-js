i301 = room {
    nam = '...',
    pic = 'images/movie_3.gif',
    dsc = '...Хранитель вошёл в тёмную пещеру. Но не успел он ступить и несколько шагов, как магическая сила перенесла его в самый центр Лабиринта...';
    enter = function(s)
        set_music('music/part_3.ogg');
        status._drink_water_on_this_level = false;
        status._fatigue_death_string = '...Скитания по бесконечным коридорам и лестницам лабиринта измотали меня. Я опустился возле стены и потерял сознание...';
    end,
    way = { vroom ('Назад', 'part_2_end'), vroom ('Далее', 'i302') },
};


i302 = room {
    nam = '...',
    pic = 'images/darkness.png',
    dsc = function(s)
--        return 'ddd';
        return 'Всё случилось так быстро, что я не успел ничего предпринять. Яркая вспышка, слепящий глаза белый свет, а когда я очнулся на холодном полу, то меня окружала полная тьма.^Через некоторое время мои глаза привыкли к темноте и я осмотрелся. Я находился в каменном лабиринте.';
    end,
--    way = { vroom ('Далее', 'labyrinth_21') },
    obj = { vway('1', '{Далее}', 'labyrinth_21') },
    exit = function (s, to)
--        if to == labyrinth_21 then
--            status._health = 1000;
--            me().obj:add(status);
--            actions_init();
--            lifeon(status);
--            me():enable_all();

--            put('flint', i302);
--            flint:enable();
--            Take(flint);
--            put('crossbow', i302);
--            crossbow:enable();
--            Take(crossbow);
--            put('jug', i302);
--            jug._dirty = false;
--            Take(jug);
--            put('fruit', i302);
--            Take(fruit);
--            put('rope', i302);
--            rope:enable();
--            Take(rope);
--        end
        me():enable_all();
    end,
};


-- ----------------------------------------------------------------------

labyrinth_11 = room {
    nam = 'Площадка',
    _add_health_rest = 2,
    _del_health = 3,
    _eagle_seating_on_stone = true,
    _fruit_is_dropped = false,
    _eagle_is_eating = false,
    _eagle_is_finishing = false,
    _eagle_is_finished = false,
    _boulder_is_here = true,
    pic = function(s)
        if s._fruit_is_dropped then
            return 'images/labyrinth_11_fruit.png';
        end
        if s._eagle_is_finishing or s._eagle_is_finished then
            if s._boulder_is_here then
                return 'images/labyrinth_11_fruit_eagle.png';
            else
                return 'images/labyrinth_11_fruit_eagle_no_boulder.png';
            end
        end
        if s._boulder_is_here then
            return 'images/labyrinth_11_initial.png';
        else
            return 'images/labyrinth_11_no_boulder.png';
        end
    end,
    enter = function(s, from)
        if not(from == labyrinth_11_fruit) then
            lifeon (labyrinth_11);
        end
    end,
    dsc = function(s)
        if s._eagle_is_eating or s._eagle_is_finishing then
            return true;
--            return 'Я стоял на открытой площадке, с которой открывался величественный вид.';
        end
        if s._boulder_is_here then
            return [[Стены и ступени лестницы освещались слабым светом, льющимся сверху. Это казалось странным в тёмном лабиринте, но поднявшись наверх, я увидел в чём дело.^
                     Я стоял на открытой площадке, с которой открывался величественный вид. Вокруг, на сколько хватало глаз, раскинулись крутые скалы и глубокие ущелья. Но над ними, по-прежнему, грозно возвышался Трёхглавый Замок, окружённый тёмными тучами.^
                     Тут я заметил, что на площадке я не один: у самого края на большом камне сидел, не обращая на меня никакого внимания, огромный орёл.]];
        else
            return [[Стены и ступени лестницы освещались слабым светом, льющимся сверху. Это казалось странным в тёмном лабиринте, но поднявшись наверх, я увидел в чём дело.^
                     Я стоял на открытой площадке, с которой открывался величественный вид. Вокруг, на сколько хватало глаз, раскинулись крутые скалы и глубокие ущелья. Но над ними, по-прежнему, грозно возвышался Трёхглавый Замок, окружённый тёмными тучами.^
                     Тут я заметил, что на площадке я не один: у самого края, не обращая на меня никакого внимания, огромный орёл.]];
        end
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Лестница', 'labyrinth_24'), },
    obj = { 'boulder', 'brushwood', 'eagle' },
    life = function (s)
        if s._eagle_is_finished then
            s._eagle_is_finished = false;
            objs():del(fruit);
            if s._boulder_is_here then
                s._eagle_seating_on_stone = true;
                p 'Я остановился, наблюдая, как орёл, закончив свою небольшую трапезу, вернулся на прежнее место.';
                return true;
            else
                p 'Закончив свою небольшую трапезу, птица вернулась на место, но, не обнаружив камня, села на краю площадки.';
                return true;
            end
        end
        if s._eagle_is_finishing then
            s._eagle_is_finishing = false;
            s._eagle_is_finished = true;
        end
        if s._eagle_is_eating then
            s._eagle_is_eating = false;
            s._eagle_is_finishing = true;
            s._eagle_seating_on_stone = false;
            p 'Тут же голодная птица сорвалась со своего места и накинулась на него, быстро действуя крепким клювом и мощными лапами.';
            return true;
        end
        if s._fruit_is_dropped then
            walk (labyrinth_11_fruit);
            return;
        end
--        return 'LIFE. При выходе с локации установить флаги как надо!!!';
    end,
    exit = function(s, to)
        if to == labyrinth_24 or to == The_End then
            s._fruit_is_dropped = false;
            s._eagle_is_finishing = false;
            s._eagle_is_finished = false;
            objs():del(fruit);
            lifeoff(labyrinth_11);
        end
    end,
};


labyrinth_11_fruit = room {
    nam = 'Площадка',
    pic = function(s)
        return 'images/labyrinth_11_fruit.png';
    end,
    enter = function (s)
        fruit:disable();
        me():disable_all();
    end,
    dsc = function(s)
        return 'Я бросил плод на пол.';
    end,
--    way = { vroom ('Далее', 'labyrinth_11'), },
    obj = { vway('1', '{Далее}', 'labyrinth_11') },
    exit = function (s)
        fruit:enable();
        me():enable_all();
        labyrinth_11._fruit_is_dropped = false;
        labyrinth_11._eagle_is_eating = true;
    end,
};


brushwood = iobj {
    nam = 'хворост',
    _weight = 19,
    dsc = function(s)
        if here() == labyrinth_22 then
            if labyrinth_22._brushwood_is_here then
                return 'В нише лежит {хворост}.';
            else
                return 'На полу лежит {хворост}.';
            end
        end
        return 'Недалеко от меня лежит {хворост}.';
    end,
    exam = 'Тонкие сухие ветки деревьев.',
    take = function(s)
        if here() == labyrinth_22 and labyrinth_22._brushwood_is_here then
            labyrinth_22._brushwood_is_here = false;
            return 'Я взял хворост из ниши.';
        end
        return 'Я взял хворост.';
    end,
    drop = function(s)
        return 'Я бросил хворост.';
    end,
    used = function (s, w)
        if w == flint then
            if not have (flint) then
                return 'У меня нет кремня.';
            else
                if here() == labyrinth_22 and labyrinth_22._brushwood_is_here then
                    labyrinth_22._brushwood_is_here = false;
                    labyrinth_22._fire_is_burning = true;
                    status._progress = status._progress + 6;
                    objs():del(brushwood);
                    ways(labyrinth_34):add(vroom ('Лестница', 'labyrinth_60'));
                    return 'Ударив кремнем о край ниши, я зажёг хворост. Удивительно, но после того, как ветви сгорели, огонь не погас, словно поддерживаемый неведомыми чарами.';
                else
                    return 'Я бы мог сжечь хворост, но здесь от этого будет мало толку.';
                end
            end
        end
    end,
};


boulder = iobj {
    nam = 'камень',
    _weight = 98,
    _talked = false,
    dsc = function(s)
        return 'На полу лежит {камень}.';
    end,
    exam = 'Большой, удивительно гладкий камень без единой трещины или царапины.',
    take = function (s)
        if ( (here() == labyrinth_34) and (not(status._cargo + s._weight > 100)) ) then
            labyrinth_34._boulder_is_here = false;
        end
        if here() == labyrinth_11 then
            if labyrinth_11._eagle_seating_on_stone then
                p 'Орёл забил крыльями, не подпуская меня к камню, пытаясь поцарапать мне лицо когтистыми лапами, так что мне пришлось отступить. Птица успокоилась и приняла прежнее безразличное положение.';
                return false;
            else
                if (not(status._cargo + s._weight > 100)) then
                    labyrinth_11._boulder_is_here = false;
                    return 'Я поднял камень с пола.';
                end
            end
        else
            return 'Я поднял камень с пола.';
        end
    end,
    drop = function (s)
        if here() == labyrinth_34 then
            labyrinth_34._boulder_is_here = true;
        end
        if here() == labyrinth_11 then
            labyrinth_11._boulder_is_here = true;
            if not(labyrinth_11._eagle_is_finished) then
                return 'Я бросил камень, и орёл, упорно не обращая на меня внимания, вновь уселся на гладкую глыбу.';
            end
        end
        if here() == labyrinth_25 and not (labyrinth_25._stair_is_accessible) then
            labyrinth_25._stair_is_accessible = true;
            objs():del(obstruction);
            Drop (boulder);
            objs():del(boulder);
            put('boulder', labyrinth_26);
            p 'Я осторожно опустил камень на разбитый пол. Но наклон был так велик, что округлая глыба, не удержавшись, покатилась по лестнице, ломая и круша всё на своём пути.';
            return false;
        end
        return 'Я бросил камень на пол.';
    end,
    talk = function(s)
        if here()== labyrinth_11 then
            return 'Не получается...';
        else
            if s._talked then
                return 'Безрезультатно.';
            else
                walk (boulder_dlg_1);
                return true;
            end
        end
    end,
};


boulder_dlg_1 = dlg{
    nam = function (s)
        return call(from(),'nam');
--     'Камень',
    end,
    pic = function(s)
        return call(from(),'pic');
    end,
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = [[Я погладил рукой совершенно гладкую поверхность камня.^
            — Да-а-а, — протянул я, — много загадок таит в себе Лабиринт...^
            Но вдруг высокий голос скороговоркой ответил на мои слова:^
            — Наконец я слышу живой голос! Как скучно лежать у этой зазнавшейся птицы, которая и слова не скажет!^
            Я удивлённо оглянулся, но возле меня не было ни единого существа.]],
    obj = {
            [1] = phr('Кто это говорит со мной?', '— Не бойся, человек. Я Торн — камень, который ты украл у орла. Со мной так долго никто не разговаривал, что я даже стал забывать, как это делается. Я рад, что встретил тебя...^И ещё долго камень рассказывал о своём одиночестве. Я старался вежливо поддерживать беседу, чтобы не обидеть Торна, но когда он, наконец, замолчал, я почувствовал большое облегчение.', [[status._progress = status._progress + 3; poff(1, 2);]]),
            [2] = phr('Уйди, нечистая сила! Не действуй на моё сознание!', '— Послышался обиженный голос:^— Ну вот, сразу «нечистая сила!», «уйди»... не разобравшись! Хм...^Ещё некоторое время слышалось сопение и вздохи, после чего всё стихло.', [[poff(1, 2);]]),
          },
    exit = function (s, t)
        boulder._talked = true;
        me():enable_all();
    end,
};


eagle = iobj {
    nam = 'орёл',
    _hungry = true,
    _dlg_line = 0,
    dsc = function(s)
        return 'Я вижу большого {орла}.';
    end,
    exam = function(s)
        if s._eagle_is_eating or s._eagle_is_finishing then
            return 'Гордая птица, не обращая на меня никакого внимания, наслаждалась пищей.';
        else
            return 'Гордая птица неподвижно смотрела вдаль, не обращая на меня никакого внимания. На чёрно-белых перьях играли редкие лучи далёкого солнца.';
        end
    end,
    useit = function (s)
        if s._hungry or not labyrinth_46._conversation_was_good then
            return 'Орёл забил крыльями, пытаясь поцарапать мне лицо когтистыми лапами, так что мне пришлось отступить. Птица успокоилась и приняла прежнее безразличное положение.';
        else
            if status._exit_hints then
                walk (part_3_end_hints_1);
                return;
            else
                walk (part_3_end);
                return;
            end
        end
    end,
    accept = function (s, w)
        if w == fish1 or w == fish2 then
            if not s._hungry then
                return 'Я уже накормил орла.';
            else
                s._hungry = false;
                Drop (w);
                objs():del(w);
                return 'Я отдал орлу рыбу. Ловко разодрав её мощным лапами, птица быстро проглотила добычу.';
            end
        end
        return 'Орёл даже не посмотрел в мою сторону.';
    end,
    talk = function (s)
        walk (eagle_dlg);
        return;
    end,
};


eagle_dlg = dlg{
    nam = 'Площадка',
    pic = function(s)
        return call(from(),'pic');
    end,
    enter = function (s, from)
        me():disable_all();
        if ( labyrinth_46._conversation_was_good and (not eagle._hungry) ) then
            poff (2);
        end
    end,
    obj = {
            [1] = phr('Помоги мне, добрая птица, добраться до Трёхглавого Замка. Я должен остановить злодеяния Чёрного Властелина.', nil, [[pon(1); eagle._dlg_line=1; back();]]),
            [2] = phr('Почему ты всё время молчишь?! Ответь мне!', nil, [[pon(2); eagle._dlg_line=2; back();]]),
          },
    exit = function (s, to)
        if ( labyrinth_46._conversation_was_good and (eagle._dlg_line == 1) ) then
            if eagle._hungry then
                p '— Я перенёс бы тебя к Трёхглавому Замку, но, боюсь, мне не выдержать столь долгого путешествия.';
            else
                p '— Хорошо, я перенесу тебя к Замку. Садись мне на спину.';
            end
        else
            p 'На мои слова не последовало никакого ответа. Птица даже не повернула голову в мою сторону.';
        end
        boulder._talked = true;
        me():enable_all();
        return;
    end,
};


--eagle_dlg_1 = dlg{
--    nam = 'Площадка',
--    pic = function(s)
--        return call(from(),'pic');
--    end,
--    enter = function (s, t)
--        me():disable_all();
--    end,
--    obj = {
--            [1] = phr('Помоги мне, добрая птица, добраться до Трёхглавого Замка. Я должен остановить злодеяния Чёрного Властелина.', 'На мои слова не последовало никакого ответа. Птица даже не повернула голову в мою сторону.', [[pon(1); back();]]),
--            [2] = phr('Почему ты всё время молчишь?! Ответь мне!', 'На мои слова не последовало никакого ответа. Птица даже не повернула голову в мою сторону.', [[pon(2); back();]]),
--          },
--    exit = function (s, t)
--        boulder._talked = true;
--        me():enable_all();
--    end,
--};


--eagle_dlg_2 = dlg{
--    nam = 'Площадка',
--    pic = function(s)
--        return call(from(),'pic');
--    end,
--    enter = function (s, t)
--        me():disable_all();
--    end,
--    obj = {
--            [1] = phr('Помоги мне, добрая птица, добраться до Трёхглавого Замка. Я должен остановить злодеяния Чёрного Властелина.', '— Я перенёс бы тебя к Трёхглавому Замку, но, боюсь, мне не выдержать столь долгого путешествия.', [[pon(1); poff(2); back();]]),
--            [2] = phr('Почему ты всё время молчишь?! Ответь мне!', 'На мои слова не последовало никакого ответа. Птица даже не повернула голову в мою сторону.', [[pon(2); back();]]),
--          },
--    exit = function (s, t)
--        boulder._talked = true;
--        me():enable_all();
--    end,
--};


--eagle_dlg_3 = dlg{
--    nam = 'Площадка',
--    pic = function(s)
--        return call(from(),'pic');
--    end,
--    enter = function (s, t)
--        me():disable_all();
--    end,
--    obj = {
--            [1] = phr('Помоги мне, добрая птица, добраться до Трёхглавого Замка. Я должен остановить злодеяния Чёрного Властелина.', '— Хорошо, я перенесу тебя к Замку. Садись мне на спину.', [[pon(1); back();]]),
--          },
--    exit = function (s, t)
--        eagle._talked = true;
--        me():enable_all();
--    end,
--};



labyrinth_21 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
--    _just_arrive = false;
--    _came_from_forest = false;
--    _first_time_rest = true;
    pic = function(s)
        if labyrinth_22._fire_is_burning then
            return 'images/labyrinth_21_light.png';
        else
            return 'images/labyrinth_21.png';
        end
    end,
    dsc = function(s)
        if labyrinth_22._fire_is_burning then
            return 'Яркий свет далёкого огня резко очерчивал высеченные в стенах арки, бросая густые тени на ступени лестницы.';
        else
            return 'Стены с высеченными арками, холодный коридор, исчезающий в темноте, бегущие вниз ступени лестницы. Однообразие лабиринта навевало тоску и страх.';
        end
    end,
    way = { vroom ('Поворот', 'labyrinth_23'),
            vroom ('Лестница', 'labyrinth_33'),
            vroom ('Коридор', 'labyrinth_22'), },
    rest = 'Я присел на пол и немного отдохнул.',
    exit = function (s, to)
        if to == labyrinth_23 and labyrinth_23._first_time then
            walk (labyrinth_23a);
            return;
        end
    end,
};


labyrinth_22 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    _brushwood_is_here = false,
    _fire_is_burning = false,
--    _just_arrive = false,
--    _came_from_forest = false,
--    _first_time_rest = true,
    pic = function(s)
        if s._brushwood_is_here then
            return 'images/labyrinth_22_brushwood.png';
        end
        if s._fire_is_burning then
            return 'images/labyrinth_22_fire.png';
        else
            return 'images/labyrinth_22.png';
        end
    end,
    dsc = function(s)
        if s._fire_is_burning then
            return 'Не останавливаясь, коридор бежал сквозь скалу, пересекаясь лестницами и резкими поворотами. В нише возле лестницы ярко горел огонь, распространяя свет по всему коридору.';
        else
            return 'Не останавливаясь, коридор бежал сквозь скалу, пересекаясь лестницами и резкими поворотами. Нарушая унылое однообразие стен, возле лестницы чернела глубокая ниша.';
        end
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Коридор', 'labyrinth_21'),
            vroom ('Лестница', 'labyrinth_31') },
    obj = { 'niche' },
};


niche = iobj {
    nam = 'ниша',
    dsc = function(s)
        return 'В стене видна {ниша}.';
    end,
    exam = function(s)
        if here()==labyrinth_22 and labyrinth_22._fire_is_burning then
            return 'В глубоком отверстии в стене ярко горел огонь.';
        end
        if here()==labyrinth_75 and labyrinth_75._fire_is_burning then
            return 'В глубоком отверстии в стене ярко горел огонь.';
        end
        if here()==labyrinth_48 and labyrinth_48._fire_is_burning then
            return 'В глубоком отверстии в стене ярко горел огонь.';
        end
        if here()==labyrinth_34 and labyrinth_34._fire_is_burning then
            return 'В глубоком отверстии в стене ярко горел огонь.';
        end
        return 'Просто глубокое отверстие в стене.';
    end,
    used = function (s, w)
        if w == brushwood then
            if not have (brushwood) then
                return 'У меня нет хвороста.';
            else
                labyrinth_22._brushwood_is_here = true;
                Drop (brushwood);
                return 'Я положил хворост в нишу.';
            end
        end
        if w == flint then
            if not have (flint) then
                return 'У меня нет кремня.';
            else
                if here() == labyrinth_75 then
                    labyrinth_75._fire_is_burning = true;
                    put('niche', labyrinth_48);
                    status._progress = status._progress + 4;
                    return 'В нише занялся огонь. По коридору разнёсся гул, массивные колонны задрожали, но с места так и не двинулись.';
                end
                if here() == labyrinth_48 then
                    labyrinth_48._fire_is_burning = true;
                    put('niche', labyrinth_34);
                    status._progress = status._progress + 4;
                    ways(labyrinth_48):add(vroom ('Коридор', 'labyrinth_25'));
                    ways(labyrinth_25):add(vroom ('Коридор', 'labyrinth_48'));
                    ways(labyrinth_49):add(vroom ('Поворот', 'labyrinth_32'));
                    ways(labyrinth_32):add(vroom ('Направо', 'labyrinth_49'));
                    return 'Искра попала в самый центр ниши, в которой тут же вспыхнул яркий огонь, разливая магический свет по всему коридору. Вдруг раздался каменный скрежет, и одна из стен исчезла, открывая ещё один коридор.';
                end
                if here() == labyrinth_34 then
                    labyrinth_34._fire_is_burning = true;
                    status._progress = status._progress + 4;
                    labyrinth_46._people_are_free = true;
                    objs(labyrinth_47):del(people);
                    objs(labyrinth_47):del(girl);
                    return 'Когда пламя запылало в нише, разгоняя густую тень, по коридорам и лестницам пронёсся, отдаваясь многочисленным эхо, страшный вопль.';
                end
            end
        end
    end,
};


labyrinth_23a = room {
    nam = 'Лабиринт',
    pic = function(s)
        return 'images/labyrinth_23a.gif';
    end,
    enter = function(s)
        me():disable_all();
    end,
    dsc = function(s)
        return [[Через некоторое время я вышел в просторную комнату, из которой в разные стороны разбегались три коридора.^^
                 Внезапно передо мной возникло видение, от которого я замер, не в силах пошевелиться.^
                 В нескольких шагах от меня висела огромная жуткая голова, зло глядя на меня.^
                 Порождая многочисленное эхо, под каменными сводами лабиринта пронёсся громовой голос:^
                 — Человек! Как ты посмел потревожить тишину моего лабиринта! Ты не выйдешь отсюда живым! Слуги Зла отправят твою душу в Царство Теней! Приготовься к смерти!!!]];
    end,
    way = { vroom ('Далее', 'labyrinth_23b') },
--    obj = { vway('1', '{Далее}', 'labyrinth_23b') },
};


labyrinth_23b = room {
    nam = 'Лабиринт',
    pic = function(s)
        return 'images/labyrinth_23b.gif';
    end,
    dsc = function(s)
        return '...И со страшным хохотом голова растворилась в воздухе.';
    end,
    way = { vroom ('Назад', 'labyrinth_23a'), vroom ('Далее', 'labyrinth_23') },
--    obj = { vway('1', '{}', 'labyrinth_23b'),
--            vway('2', '{Далее}', 'labyrinth_23b'),},
    exit = function(s, to)
        if to == labyrinth_23 then
            me():enable_all();
        end
    end,
};


labyrinth_23 = room {
    nam = 'Лабиринт',
    _first_time = true,
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_23.png';
    end,
    dsc = function(s)
        if s._first_time then
            s._first_time = false;
            return 'Я был в просторной комнате, из которой в разные стороны разбегались три коридора.';
        else
            return 'Через некоторое время я вышел в просторную комнату, из которой в разные стороны разбегались три коридора.';
        end
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Налево', 'labyrinth_21'),
            vroom ('Прямо', 'labyrinth_24'),
            vroom ('Направо', 'labyrinth_25'), }
};


labyrinth_24 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_24.png';
    end,
    dsc = function(s)
        return 'В этом месте коридор обрывался, уступая место лестнице с высокими ступенями, конец которой терялся в вышине.';
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Лестница', 'labyrinth_11'),
            vroom ('Коридор', 'labyrinth_23'), },
};


labyrinth_25 = room {
    nam = 'Лабиринт',
    _stair_is_accessible = false;
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        if labyrinth_48._fire_is_burning then
            return 'images/labyrinth_25b.png';
        else
            return 'images/labyrinth_25.png';
        end
    end,
    dsc = function(s)
        if labyrinth_48._fire_is_burning then
            return 'По длинному коридору струился свет, резко очерчивая неровные трещины смятого пола. Полуразрушенная лестница вела вниз.';
        else
            return 'Стены с высеченными арками, полуразрушенная лестница с расколотыми неведомой силой ступенями. Идти по разбитому полу в темноте было очень трудно.';
        end
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Поворот', 'labyrinth_23'),
            vroom ('Лестница', 'labyrinth_26'), },
    obj = { 'obstruction', 'mushrooms' },
    exit = function (s, to)
        if to == The_End then
            return true;
        end
        if to == labyrinth_26 then
            if s._stair_is_accessible then
                return true;
            else
                obstruction:enable();
                p 'Путь по лестнице преграждал завал из брёвен.';
                return false;
            end
        end
    end,
};


obstruction = iobj {
    nam = 'завал',
--    _mushroom_is_exist = false,
    dsc = function (s)
        return 'Проход на лестницу преграждает {завал} из брёвен.';
    end,
    exam = function (s)
--        put('mushroom', labyrinth_25);
        mushrooms:enable();
        return 'Толстые суковатые брёвна крепко врезались друг в друга, образуя сплошную стену. От сырости лабиринта завал порос мхом и грибами.';
    end,
}:disable();


mushrooms = iobj {
    nam = 'грибы',
    _mushroom_is_exist = false,
    dsc = function (s)
        return 'Многочисленные {грибы} росли на завале.';
    end,
    exam = function (s)
        return 'Из-за сырости лабиринта грибы в этом месте росли в большом количестве.';
    end,
    take = function(s)
        if (status._cargo + 3 > 100) then
            p 'Слишком тяжело!';
            return false;
        end
        if s._mushroom_is_exist then
            p 'Нет смысла брать ещё один гриб.';
            return false;
        else
            s._mushroom_is_exist = true;
            put('mushroom', labyrinth_25);
            mushroom:enable();
            Take (mushroom);
            p 'Я взял самый большой гриб.';
            return false;
        end
    end,
}:disable();


mushroom = iobj {
    nam = 'гриб',
    _weight = 3,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Гриб} лежит на плите ';
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
--            return ref(s._on_what);
        end
        return 'Я вижу {гриб}.';
    end,
    exam = function (s)
        return 'Большой гриб.';
    end,
    take = function (s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        return 'Я взял гриб.';
    end,
    drop = function()
        return 'Я бросил гриб.';
    end,
--    used = function (s, w)
--        if w == rope then
--            if have (rope) then
--                River_Bank_Steep._rope_is_attached = true;
--                Drop(rope);
--                return 'Надёжно обвязав верёвку вокруг большого камня, я сбросил другой её конец в пропасть.';
--            else
--                return 'У меня нет верёвки.';
--            end
--        end
--    end,
    useit = function(s)
        if have (mushroom) then
            status._health = status._health + 30;
            Drop (mushroom);
            objs():del(mushroom);
--            inv():del(mushroom);
            mushrooms._mushroom_is_exist = false;
            return 'Гриб был совершенно безвкусен, но неплохо утолял голод.';
        else
            return 'У меня нет гриба.';
        end
    end,
};
--}:disable();


labyrinth_26 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        if labyrinth_75._fire_is_burning then
            return 'images/labyrinth_26c.png';
        end
        if seen (logs) then
            return 'images/labyrinth_26a.png';
        end
        return 'images/labyrinth_26b.png';
    end,
    dsc = function(s)
        if labyrinth_75._fire_is_burning then
            return 'Ярко освещённый коридор был от пола до потолка перекрыт огромными металлическими столбами.';
        end
        if seen (logs) then
            return 'Старые ступени выходили в следующий коридор, уходящий в тёмную даль и перекрытый огромными металлическими столбами. Около лестницы валялись брёвна разбитой перегородки.';
        else
            return 'Старые ступени выходили в следующий коридор, уходящий в тёмную даль и перекрытый огромными металлическими столбами.';
        end
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    obj = { 'logs' },
    way = { vroom ('Лестница', 'labyrinth_25'), }
};


logs = iobj {
    nam = 'брёвна',
    _weight = 93,
    dsc = function (s)
        return 'Недалеко от меня лежат {брёвна}.';
    end,
    exam = function (s)
        return 'Несколько брёвен, примерно одинаковых по размерам.';
    end,
    take = function()
        return 'Я взял брёвна.';
    end,
    drop = function()
        return 'Я бросил брёвна.';
    end,
    used = function (s, w)
        if w == rope then
            if have (rope) then
                if ( (here() == labyrinth_60) and (seen (logs)) ) then
                    Drop(rope);
                    objs():del(logs);
                    objs():del(rope);
                    put('raft', labyrinth_60);
                    return 'Крепко связав брёвна верёвкой, я получил небольшой, но устойчивый плот, вполне способный выдержать вес человека.';
                end
            else
                return 'У меня нет верёвки.';
            end
        end
    end,
};


raft = iobj {
    nam = 'плот',
    _weight = 101,
    _ready = false,
    dsc = function (s)
        if s._ready then
            return 'На водной глади озера, у самого берега располагается {плот}.';
        else
            return 'Я вижу {плот}.';
        end
    end,
    exam = function (s)
        return 'Небольшой, но устойчивый плот, вполне способный выдержать вес человека.';
    end,
    take = function()
    end,
    useit = function(s)
        if s._ready then
            return 'Я уже столкнул плот на воду.';
        else
            s._ready = true;
            ways(labyrinth_60):del('Озеро');
            ways(labyrinth_60):add(vroom ('На плот', 'labyrinth_61'));
            return 'Я столкнул плот на воду.';
        end
    end,
};



labyrinth_31 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_31.png';
    end,
    dsc = function(s)
        return 'Резкие повороты сменялись лестницами, лестницы — унылыми тоннелями. В лабиринте было сыро и холодно.';
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Коридор', 'labyrinth_32'),
            vroom ('Лестница', 'labyrinth_22'), }
};


labyrinth_32 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        if labyrinth_48._fire_is_burning then
            return 'images/labyrinth_32c.png';
        end
        if labyrinth_47._fire_is_burning then
            return 'images/labyrinth_32b.png';
        end
        return 'images/labyrinth_32.png';
    end,
    dsc = function(s)
        if labyrinth_48._fire_is_burning then
            return 'Я вышел в небольшую комнату, влево и вправо из которой расходилось два коридора. Ярко освещённая лестница вела вниз, к центру Лабиринта.';
        end
        if labyrinth_47._fire_is_burning then
            return 'Из этой комнаты налево уходил коридор, прямо вниз бежала лестница, а справа, где можно было предположить третий выход, в стене была вырезана широкая колонна.';
        end
        return 'Казалось, что из этой симметричной комнаты должно вести три выхода, но вместо предполагаемых двух из них в стене были вырезаны неуклюжие широкие колонны.';
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Налево', 'labyrinth_31'), },
};


labyrinth_33 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        if labyrinth_34._fire_is_burning then
            return 'images/labyrinth_33b.png';
        else
            return 'images/labyrinth_33.png';
        end
    end,
    dsc = function(s)
        if labyrinth_34._fire_is_burning then
            return 'Ровный свет ещё более подчёркивал неуклюжесть стен и колонн. Видимо эта часть Лабиринта была прорублена древними мастерами раньше, и время уже оставило здесь свой отпечаток.';
        else
            return 'Очередной коридор, ещё более мрачный и холодный. Стены здесь обработаны более грубо, и в отличие от арок и тонких колонн, вырезанных в стенах верхнего лабиринта, имели более мощные формы.';
        end
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Лестница', 'labyrinth_21'),
            vroom ('Коридор', 'labyrinth_34'), }
};


labyrinth_34 = room {
    nam = 'Дыра в потолке',
    _add_health_rest = 2,
    _del_health = 3,
    _fire_is_burning = false,
    _boulder_is_here = false,
    pic = function(s)
        if s._fire_is_burning then
            if s._boulder_is_here then
                return 'images/labyrinth_34_boulder_stair_niche_fire.png';
            else
                return 'images/labyrinth_34_stair_niche_fire.png';
            end
        end
        if seen (niche) then
            if s._boulder_is_here then
                return 'images/labyrinth_34_boulder_stair_niche.png';
            else
                return 'images/labyrinth_34_stair_niche.png';
            end
        end
        if labyrinth_22._fire_is_burning then
            if s._boulder_is_here then
                return 'images/labyrinth_34_boulder_stair.png';
            else
                return 'images/labyrinth_34_stair.png';
            end
        else
            if s._boulder_is_here then
                return 'images/labyrinth_34_boulder.png';
            else
                return 'images/labyrinth_34_initial.png';
            end
        end
    end,
    dsc = function(s)
        if s._fire_is_burning then
            return 'Ярко освещённый коридор упирался в глухую стену. В стене пылал огонь, разгоняя холодный полумрак; лишь на стенах идущей вниз лестницы лежали длинные чёрные тени.';
        end
        if labyrinth_22._fire_is_burning then
            return 'Длинный унылый коридор упирался в глухую стену. От расположенной неподалёку лестницы веяло леденящей сыростью. В потолке зияла неровная дыра с рваными краями.';
        else
            return 'Коридор заканчивался глухой стеной, в которой была вырезана необычной формы колонна. Окружённая свисающей густой паутиной, на потолке виднелась дыра.';
        end
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Коридор', 'labyrinth_33'),
            vroom ('Дыра', 'labyrinth_41'), },
    exit = function (s, to)
        if to == The_End then
            return true;
        end
        if to == labyrinth_41 then
            if s._boulder_is_here then
                return true;
            else
                p 'Дыра слишком высоко.';
                return false;
            end
        end
    end,
};


labyrinth_41 = room {
    nam = 'Нора',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        if labyrinth_34._fire_is_burning then
            return 'images/labyrinth_41b.png';
        else
            return 'images/labyrinth_41.png';
        end
    end,
    dsc = function(s)
        if labyrinth_34._fire_is_burning then
            return 'Узкая круглая нора была покрыта чем-то похожим на паутину. Длинные липкие пряди, свисавшие с потолка и стен, цеплялись за одежду, неприятно касались тела.';
        else
            return 'Узкая круглая нора, начинавшаяся дырой в потолке коридора и уходившая всё дальше в глубь скалы, была покрыта чем-то похожим на паутину. Длинные липкие пряди, свисавшие с потолка и стен, цеплялись за одежду, неприятно касались тела.';
        end
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Из пещеры', 'labyrinth_34'),
            vroom ('Нора', 'labyrinth_42'), }
};


labyrinth_42 = room {
    nam = 'Нора',
    _add_health_rest = 2,
    _del_health = 3,
    _web = true,
    pic = function(s)
        if s._web then
            return 'images/labyrinth_42.png';
        else
            return 'images/labyrinth_42b.png';
        end
    end,
    dsc = function(s)
        return 'Здесь нора начинала опускаться вниз, что затрудняло продвижение по скользкой паутине.';
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    obj = { 'web_42' },
    way = { vroom ('Вверх', 'labyrinth_41'),
            vroom ('Вниз', 'labyrinth_43'), },
};


web_42 = iobj {
    nam = 'паутина',
    dsc = function (s)
        if labyrinth_42._web then
            return 'В одном месте {паутина} собиралась в пучки, образуя густую сетку.';
        else
            return 'Под лохмотьями разрубленной {паутины} виден проход.';
        end
    end,
    exam = function (s)
        if labyrinth_42._web then
            return 'Прочная липкая пружинящая сеть.';
        else
            return 'Лохмотья прочной липкой паутины.';
        end
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'У меня нет шеста.';
            else
                if labyrinth_42._web then
                    return 'Паутина спружинила, едва не выбив шест у меня из рук.';
                else
                    if pole._wrap then
                        return 'Я уже обернул шест лохмотьями паутины.';
                    else
                        pole._wrap = true;
                        return 'Я намотал на шест лохмотья разрубленной паутины.';
                    end
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                if labyrinth_42._web then
                    labyrinth_42._web = false;
                    ways(labyrinth_42):add(vroom ('Дыра', 'labyrinth_46'));
                    return 'Меч мягко врезался в сеть. Паутина расползлась, открывая ход.';
                else
                    return 'Я уже прорубил ход.';
                end
            end
        end
    end,
};



labyrinth_43 = room {
    nam = 'Нора',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_43.png';
    end,
    dsc = function(s)
        return 'Скользкий ход уходил резко вверх — я с трудом полз, цепляясь за мерзкую паутину. Откуда-то сверху доносились непонятные звуки, похожие на тяжёлое дыхание какого-то огромного существа.^Крепкие пряди густо оплетали каменные балки, которые образовывали арку.';
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Вверх', 'labyrinth_42'),
            vroom ('Арка', 'labyrinth_44'),
            vroom ('Ход', 'labyrinth_45'), }
};


labyrinth_44 = room {
    nam = 'Обрыв',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_44.png';
    end,
    dsc = function(s)
        return 'Пройдя под каменную арку, я оказался на самом краю огромного обрыва. Вокруг стояла полная темнота; лишь далеко внизу я различал странные блики, игравшие на мелкой ряби подземного озера.';
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    way = { vroom ('Арка', 'labyrinth_43'), },
};


labyrinth_45 = room {
    nam = 'Логово',
    _add_health_rest = 2,
    _del_health = 3,
    _web = true,
    pic = function(s)
        if spider._is_alive then
            return 'images/labyrinth_45_spider_alive.png';
        else
            if spider._arrowed then
                if s._web then
                    return 'images/labyrinth_45_arrowed.png';
                else
                    return 'images/labyrinth_45_arrowed_way.png';
                end
            else
                if s._web then
                    return 'images/labyrinth_45_headless.png';
                else
                    return 'images/labyrinth_45_headless_way.png';
                end
            end
        end
    end,
    enter = function (s)
        if spider._is_alive then
            spider._state = 2;
            lifeon (spider);
        end
    end,
    dsc = function(s)
        return 'Вскарабкавшись по липкой паутине наверх, я оказался в самом логове чудовища, построившего эту нору. Нечто, похожее на паука, шипя, тянуло длинные лапы ко мне, уставив злые, жаждущие крови глаза на новую жертву.';
    end,
    rest = 'Я присел на пол и немного отдохнул.',
    obj = { 'spider', 'web_45' },
    way = { vroom ('Ход', 'labyrinth_43'), },
};


spider = iobj {
    nam = 'паук',
    _is_alive = true,
    _arrowed = false,
    _state = 0,
    dsc = function (s)
--        if labyrinth_42._web then
--            return 'В одном месте {паутина} собиралась в пучки, образуя густую сетку.';
--        else
            return 'Я вижу {паука}.';
--        end
    end,
    exam = function (s)
        if s._is_alive then
            return 'Паук, шипя, тянул ко мне длинные лапы.';
        else
            return 'Круглое тело паука лежало на полу, разбросав длинные лапы. Из раны медленно сочилась зелёная кровь.';
        end
    end,
    used = function (s, w)
        if not s._is_alive then
            if (w == crossbow or w == sword) then
                return 'Паук уже мёртв.';
            end
        end
        if w == crossbow then
            if not have (crossbow) then
                return 'У меня нет арбалета.';
            else
                if not crossbow._loaded then
                    return 'Арбалет не заряжен.';
                else
                    s._is_alive = false;
                    s._arrowed = true;
                    lifeoff (spider);
                    return 'Быстро вскинув арбалет, я выстрелил в голову надвигающегося паука. Чудовище забилось в агонии, судорожно дёргая лапами. Но вот паук содрогнулся последний раз, и мёртвое тело осело на пол.';
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                s._is_alive = false;
                s._arrowed = false;
                lifeoff (spider);
                return 'Не дожидаясь, пока паук дотянется до меня, я взмахнул мечом, и ужасная голова чудовища отделилась от тонкой шеи. Тело забилось в последних судорогах, но вскоре осело на пол, растянув длинные лапы.';
            end
        end
    end,
    life = function (s)
        if s._state == 1 then
            lifeoff (spider);
            ACTION_TEXT = nil;
            walk (labyrinth_spider_death);
            return true;
        end
        if s._state == 2 then
            s._state = 1;
        end
    end,
};


web_45 = iobj {
    nam = 'паутина',
    dsc = function (s)
        if labyrinth_45._web then
            return 'В одном месте {паутина} собиралась в пучки, образуя густую сетку.';
        else
            return 'Под лохмотьями разрубленной {паутины} виден проход.';
        end
    end,
    exam = function (s)
        if labyrinth_45._web then
            return 'Прочная липкая пружинящая сеть.';
        else
            return 'Лохмотья прочной липкой паутины.';
        end
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'У меня нет шеста.';
            else
                if labyrinth_45._web then
                    return 'Паутина спружинила, едва не выбив шест у меня из рук.';
                else
                    if pole._wrap then
                        return 'Я уже обернул шест лохмотьями паутины.';
                    else
                        pole._wrap = true;
                        return 'Я намотал на шест лохмотья разрубленной паутины.';
                    end
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                if labyrinth_45._web then
                    labyrinth_45._web = false;
                    ways(labyrinth_45):add(vroom ('Дыра', 'labyrinth_48'));
                    return 'Мечом я рассёк густую паутину, за которой оказался узкий ход.';
                else
                    return 'Я уже прорубил ход.';
                end
            end
        end
    end,
};



labyrinth_spider_death = room {
    nam = 'Логово',
    pic = function(s)
        return 'images/labyrinth_45_spider_alive.png';
    end,
    enter = function (s)
        me():disable_all();
    end,
    dsc = function(s)
        return 'Холодные жёсткие когти сомкнулись на моём горле.';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function(s)
        me():enable_all();
    end,
};





labyrinth_46 = room {
    nam = 'Большая зала',
    _add_health_rest = 2,
    _del_health = 3,
    _people_are_free = false,
    _conversation_was_good = false,
    pic = function(s)
        if labyrinth_47._fire_is_burning then
            return 'images/labyrinth_46b.png';
        end
        return 'images/labyrinth_46a.png';
    end,
    enter = function (s)
        if labyrinth_46._people_are_free then
            walk (girl_dlg_2);
            return true;
        end
    end,
    dsc = function(s)
        if s._people_are_free then
            return '??? FREEE!';
        end
        if labyrinth_47._fire_is_burning then
            return 'Большая светлая зала с глубоким колодцем в центре. Вверх уходит освещённая мерцающим светом лестница. В стене рядом — уродливая дыра, облепленная паутиной.';
        end
        return 'С трудом протиснувшись в дыру, я оказался в большой удивительной зале. Посреди неё, окружённый высокими стройными колоннами и широким карнизом, находился глубокий колодец, дно которого терялось во мраке.^^В залу вела единственная дверь, закрытая массивной решёткой.';
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('По карнизу', 'labyrinth_47'), vroom ('Дыра в стене', 'labyrinth_42'),},
};


girl_dlg_2 = dlg{
    nam = 'Большая зала',
    pic = 'images/labyrinth_46c.png';
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'На карнизе, снимая последние нити опавшей паутины, стояли ожившие люди. Им помогала девушка. Я уже видел её раньше, не полностью скрытую паутинным коконом. Заметив меня, она сразу подошла:^^— Благодарю тебя, незнакомец! Ты вернул нам свет и жизнь. Скажи, чем мы можем помочь тебе?';
    end,
    obj = {
           [1] = phr('Спасибо, мне не нужна помощь. Я сам добьюсь своей цели.', '— Как скажешь, незнакомец. Но ты всегда можешь рассчитывать на нашу поддержку.', [[labyrinth_46._conversation_was_good = false; poff (1, 2); walk (girl_dlg_2_end); return;]]),
           [2] = phr('Я должен избавить мир от Чёрного Властелина. Не скажешь как попасть в Трёхглавый Замок?', '— Это нелегко, но я помогу тебе. В верхней части Лабиринта есть лестница, которая ведёт на открытую площадку. Там живёт Орёл, наш друг. Я расскажу ему о тебе и твоих благородных намерениях. Думаю он согласится отнести тебя к Трёхглавому Замку.', [[ labyrinth_46._conversation_was_good = true; poff (1, 2); walk (girl_dlg_2_end); return;]]),
          },
};


girl_dlg_2_end = room {
    nam = 'Большая зала',
    enter = function (s)
        labyrinth_46._people_are_free = false;
    end,
    pic = function(s)
        return 'images/labyrinth_46c.png';
    end,
    dsc = function(s)
        return '— А сейчас я должна помочь своим братьям.^^И с этими словами девушка пошла к группе людей. Освободившись от паутины, люди один за другим уходили по лестнице.^^Вскоре я остался один в светлой зале.';
    end,
    obj = { vway('1', '{Далее}', 'labyrinth_46') },
    exit = function (s)
        me():enable_all();
    end,
};




labyrinth_47 = room {
    nam = 'Голова демона',
    _fire_is_burning = false;
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        if labyrinth_34._fire_is_burning then
            return 'images/labyrinth_47e.png';
        end
        if s._fire_is_burning then
            if girl._wake then
                return 'images/labyrinth_47c.png';
            else
                return 'images/labyrinth_47d.png';
            end
        end
        if girl._wake then
            return 'images/labyrinth_47b.png';
        else
            return 'images/labyrinth_47a.png';
        end
    end,
    dsc = function(s)
        if labyrinth_34._fire_is_burning then
            return 'Карниз вёл к огромной голове демона, высеченной в стене залы. Длинные рога, звериный оскал, широко раскрытая пасть, в которой пылал яркий огонь, наводили суеверный ужас.';
        end
        if s._fire_is_burning then
            return 'Карниз вёл к огромной голове демона, высеченной в стене залы. Длинные рога, звериный оскал, широко раскрытая пасть наводили суеверный ужас. Но у стены находилось то, что было страшнее изображения над колодцем: завёрнутые в коконы, неподвижно стояли люди, как жуткое свидетельство царствующей здесь злой силы.';
        else
            return 'Карниз вёл к огромной голове демона, высеченной в стене залы. Но у стены находилось то, что было страшнее изображения над колодцем: завёрнутые в коконы, неподвижно стояли люди, как жуткое свидетельство царствующей здесь злой силы.';
        end
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('По карнизу', 'labyrinth_46') },
--    way = { vroom ('По карнизу', 'labyrinth_46'), vroom ('TEST', 'labyrinth_75') },
    obj = { 'head', 'people' },
};


people = iobj {
    nam = 'люди',
    _sharp = false,
    dsc = function (s)
        return 'У стены неподвижно стоят {люди}, завёрнутые в коконы.';
    end,
    exam = function (s)
        girl:enable();
        return 'Все они с ног до головы были закутаны в коконы из паутины; лишь голова стоящей с краю девушки не была скрыта длинными белыми прядями. Живы ли эти люди — понять было невозможно.';
    end,
    useit = function (s)
        return 'Я попытался освободить людей от паутины, но это было бесполезно.';
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                return 'Я попытался разрезать паутину, но даже острое лезвие меча оказалось бессильно перед столь густо сплетёнными путами.';
            end
        end
    end,
    obj = { 'girl' },
};


girl = iobj {
    nam = 'девушка',
    _wake = false,
    _story_told = false,
    dsc = function (s)
        return 'Лишь голова стоящей с краю {девушки} не была скрыта длинными белыми прядями паутины.';
    end,
    exam = function (s)
        if s._wake then
            return 'Девушка полностью была оплетена паутиной, только голова оставалась открытой. Длинные волосы спадали на плечи, усталые и измученные глаза смотрели на меня с надеждой.';
        else
            return 'Девушка полностью была оплетена паутиной, только голова оставалась открытой.';
        end
    end,
    useit = function (s)
        return 'Я попытался освободить девушку от паутины, но мне это не удалось.';
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                if ( jug._filled and (not girl._wake) and (not girl._story_told) ) then
                    girl._wake = true;
                    status._progress = status._progress + 5;
                    return 'Осторожно откинув каштановые волосы, я смочил холодной водой лицо и губы девушки. От живительного действия влаги дрогнули закрытые веки. С тихим стоном девушка подняла голову. На красивом лице лежала тень печали и тревоги, большие удивительные глаза смотрели на меня сквозь пелену боли. Я поднёс к её губам кувшин с водой, и девушка жадно сделала несколько глотков. Наконец, слабым голосом она произнесла:^^— О, спасибо тебе, человек! Кажется, так долго я не видела ни одной живой души. С тех пор, как зло проникло в Лабиринт...^^Она закрыла глаза, видимо вспомнив недавние страшные события. По щеке скатилась горячая слеза. Чтобы девушка успокоилась, я дал ей выпить ещё немного воды.^^— Слишком много зла появилось в Лабиринте. Но есть ещё шанс избавиться от него.';
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                return 'Я попытался разрезать паутину, но даже острое лезвие меча оказалось бессильно перед столь густо сплетёнными путами.';
            end
        end
    end,
    talk = function (s)
        if s._wake then
            walk (girl_dlg);
            return;
        else
            return 'Не получается.';
        end
    end,
}:disable();


girl_dlg = dlg{
    nam = 'Голова демона',
    pic = function (s)
        if labyrinth_47._fire_is_burning then
            return 'images/labyrinth_47c.png';
        else
            return 'images/labyrinth_47b.png';
        end

    end,
    enter = function (s, t)
        girl._story_told = true;
        me():disable_all();
    end,
    obj = {
            [1] = phr('Расскажи мне, что здесь произошло?', 'На некоторое время девушка задумалась. Но, собравшись, она начала рассказ:^^— Лабиринт был полон жизни. Люди сделали его светлым и тёплым. Все жили в мире и согласии.^^Но вот явился Чёрный Властелин со своими воинами. Ему на помощь из самых тёмных концов Лабиринта вылезли страшные твари. Силы были слишком неравны, и зло заполнило Лабиринт.', [[pon(1); back();]]),
            [2] = phr('Скажи, как очистить Лабиринт от тёмных сил?', '— Это нелегко сделать. Но если зажечь пять больших факелов, то зло отступит. Свет изгонит из Лабиринта злого демона.', [[ pon(2); back();]]),
            [3] = phr('Я хочу выбраться отсюда как можно скорее, как мне найти выход?', 'Девушка ничего не ответила, только закрыла глаза и опустила голову на грудь. Каштановые волосы закрыли лицо.', [[ poff(1); poff(2); poff(3); girl._wake = false; ]]),
            },
    exit = function (s, t)
        me():enable_all();
    end,
};



head = iobj {
    nam = 'изображение',
    _sharp = false,
    dsc = function (s)
        return 'В стене залы высечено {изображение} огромной головы демона.';
    end,
    exam = function (s)
        if labyrinth_34._fire_is_burning then
            return 'Изображение огромной головы демона, высеченной в стене залы. Длинные рога, звериный оскал, широко раскрытая пасть, в которой пылал яркий огонь, наводили суеверный ужас.';
        end
        return 'Изображение высеченной в стене огромной головы демона наводило суеверный ужас.';
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'У меня нет шеста.';
            else
                if (pole._state == 1) then
                    pole._state = 3;
                    labyrinth_47._fire_is_burning = true;
                    ways(labyrinth_46):add(vroom ('Лестница', 'labyrinth_32'));
                    ways(labyrinth_32):add(vroom ('Прямо', 'labyrinth_46'));
                    put('niche', labyrinth_75);
                    status._progress = status._progress + 7;
                    return 'Я закинул горящий шест прямо в пасть каменной головы. Внезапно ярко вспыхнуло пламя, разливая мягкий свет по всей зале.';
                end
            end
        end
    end,
};


labyrinth_48 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    _fire_is_burning = false,
    pic = function(s)
        if labyrinth_48._fire_is_burning then
            return 'images/labyrinth_48c.png';
        end
        if seen (niche) then
            return 'images/labyrinth_48b.png';
        else
            return 'images/labyrinth_48a.png';
        end
    end,
    dsc = function(s)
        if labyrinth_48._fire_is_burning then
            return 'Привычный коридор и лестница, бегущая вниз. Одну из стен полностью занимала огромная уродливая дыра, опутанная паутиной — вход в нору паука. В другой стене — глубокая ниша, в которой ярко пылал огонь.';
        end
        return 'Привычный коридор и лестница, бегущая вниз. Одну из стен полностью занимала огромная уродливая дыра, опутанная паутиной. Это был вход в нору паука.';
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Дыра в стене', 'labyrinth_45'), vroom ('Лестница', 'labyrinth_49'),},
};


labyrinth_49 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
--        if labyrinth_48._fire_is_burning then
--            return 'images/labyrinth_46b.png';
--        end
        return 'images/labyrinth_49.png';
    end,
    dsc = function(s)
--        if labyrinth_48._fire_is_burning then
--            return 'Большая светлая зала с глубоким колодцем в центре. Вверх уходит освещённая мерцающим светом лестница. В стене рядом — уродливая дыра, облепленная паутиной.';
--        end
        return 'Очередной поворот, за которым всё та же серая холодная мгла.';
    end,
    rest = 'Некоторое время я спокойно стоял, прислонившись спиной к прохладной стене.',
    way = { vroom ('Лестница', 'labyrinth_48'),},
};


-- ------------------------------------------------------------------------

labyrinth_60 = room {
    nam = 'Берег подземного озера',
    _add_health_rest = 2,
    _del_health = 3,
    _first_time = true,
    pic = function(s)
        if seen (raft) then
            if raft._ready then
                return 'images/labyrinth_60c.png';
            else
                return 'images/labyrinth_60b.png';
            end
        end
        if seen (logs) then
            return 'images/labyrinth_60a.png';
        end
        return 'images/labyrinth_60_initial.png';
    end,
    dsc = function(s)
        if s._first_time then
        s._first_time = false;
            return 'Лестница бежала всё глубже, устремляясь к центру скалы. Наконец бесконечная вереница ступеней оборвалась, и я вышел на берег подземного озера. Отражаясь от ледяных стен и мелкой ряби водной поверхности, на стенах пещеры играли слабые блики света. Может, это неизвестные растения излучали его, или обитатели озера освещали свой путь — так или иначе, это останется ещё одной загадкой таинственного лабиринта.';
        else
            return 'Лестница заканчивалась у самого озера, и мелкие волны смачивали каменный берег. Лёд блестел на стенах, образуя причудливые узоры; тихо капала вода.';
        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('Лестница', 'labyrinth_34'), vroom ('Озеро', 'labyrinth_61'), },
    obj = { 'pole', 'lake' },
    exit = function (s, to)
        if to == The_End then
            return true;
        end
        if ( (to==labyrinth_61) and (not raft._ready) and (status._cargo > 20)) then
            p 'Я не решался плыть со столь большим грузом.';
            return false;
        end
    end,
};


pole = iobj {
    nam = 'шест',
    _weight = 21,
    _sharp = false,
    _wrap = false,
    _oiled = false,
    _state = 0,
    dsc = function (s)
        return 'Недалеко от меня лежит {шест}.';
    end,
    exam = function (s)
        if s._wrap then
            if s._sharp then
                if s._oiled then
                    return 'Длинный шест из очень твёрдой, плотной, тяжёлой древесины. Один конец шеста заострён. Другой конец, обмотанный лохмотьями паутины, пропитан густой чёрной жидкостью.';
                else
                    return 'Длинный шест из очень твёрдой, плотной, тяжёлой древесины. Один конец шеста обмотан лохмотьями паутины, другой конец заострён.';
                end
            else
                if s._oiled then
                    return 'Длинный шест из очень твёрдой, плотной, тяжёлой древесины. Один конец шеста, обмотанный лохмотьями паутины, пропитан густой чёрной жидкостью.';
                else
                    return 'Длинный шест из очень твёрдой, плотной, тяжёлой древесины. Один конец шеста обмотан лохмотьями паутины.';
                end
            end
        else
            if s._sharp then
                return 'Длинный шест из очень твёрдой, плотной, тяжёлой древесины. Один конец шеста заострён.';
            else
                return 'Длинный шест из очень твёрдой, плотной, тяжёлой древесины.';
            end
        end
    end,
    take = function (s)
        return 'Я взял шест.';
    end,
    drop = function (s)
        return 'Я бросил шест.';
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                if s._sharp then
                    return 'Шест уже заострён с одного конца.';
                else
                    s._sharp = true;
                    return 'Я тщательно заострил один конец шеста.';
                end
            end
        end
        if w == flint then
            if not have (flint) then
                return 'У меня нет кремня.';
            else
                if s._oiled then
                    if (s._state == 0) then
                        s._state = 2;
                        lifeon (pole);
                        return 'Несколько искр попало на пропитанную чёрной жидкостью паутину, и на конце шеста заплясало жаркое ярко-жёлтое пламя, с каждой секундой разгораясь всё сильнее.';
                    else
                        return 'Факел уже горит. Нет смысла пытаться зажечь его повторно.';
                    end
                end
            end
        end
    end,
    life = function (s)
        if (s._state == 3) then
            s._state = 0;
            Drop (pole);
            objs():del(pole);
            lifeoff (pole);
            return true;
        end
        if (s._state == 1) then
            s._state = 0;
            Drop (pole);
            objs():del(pole);
            lifeoff (pole);
            return 'Через несколько секунд шест был полностью уничтожен пламенем.';
        end
        if (s._state == 2) then
            s._state = 1;
        end
    end,
};


lake = iobj {
    nam = 'озеро',
    dsc = function (s)
        if here() == labyrinth_60 then
            return 'Подземное {озеро} подступало почти к самым ступеням лестницы.';
        else
            return 'Подземное {озеро} было очень большим.';
        end
    end,
    exam = function (s)
        return 'Вода в подземном озере была очень холодной.';
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'У меня нет кувшина.';
            else
                if jug._filled then
                    return 'Кувшин уже наполнен водой.';
                else
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


labyrinth_61 = room {
    nam = 'Подземное озеро',
    _water = true,
    _add_health_rest = 2,
    _del_health = 3,
    _first_time = true,
    pic = function(s)
        if water_monster._is_alive then
            if raft._ready then
                return 'images/labyrinth_61b.png';
            else
                return 'images/labyrinth_61.png';
            end
        else
            return 'images/labyrinth_61c.png';
        end
    end,
    dsc = function(s)
        if water_monster._is_alive then
            return 'Около берега глубина была небольшой, и сквозь чистую воду было видно покрытое водорослями дно. Иногда, сверкая чешуёй, проплывали стайки рыбок. Вдали, едва выделяясь из мрака пещеры, плавало огромное животное, медленно поворачивая голову на длинной шее.';
        else
            return 'Около берега глубина была небольшой, и сквозь чистую воду было видно покрытое водорослями дно. Иногда, сверкая чешуёй, проплывали стайки рыбок. Вдали, едва выделяясь из мрака пещеры, плавало огромное тело чудовища.';
        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('На берег', 'labyrinth_60'), vroom ('Вдоль скалы', 'labyrinth_63'), vroom ('К чудовищу', 'labyrinth_64'), vroom ('Центр озера', 'labyrinth_65'), vroom ('Нырнуть', 'labyrinth_underwater'),},
    obj = { 'lake', 'water_monster', },
    exit = function (s, to)
        if to == labyrinth_64 then
            if water_monster._is_alive then
                walk (labyrinth_water_monster_death);
                return;
            end
        end
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


labyrinth_underwater = room {
    nam = 'Дно подземного озера',
    _del_health = 3,
    _return_to = 0,
    _count = 0,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_61_underwater.png';
    end,
    enter = function (s, from)
        if from == labyrinth_61 then
            s._return_to = 61;
        end
        if from == labyrinth_63 then
            s._return_to = 63;
        end
        if from == labyrinth_65 then
            s._return_to = 65;
        end
        if from == labyrinth_66 then
            s._return_to = 66;
        end
        if from == labyrinth_68 then
            s._return_to = 68;
        end
        s._count = 0;
        lifeon (labyrinth_underwater);
    end,
    dsc = function(s)
            return 'Набрав побольше воздуха в лёгкие, я нырнул в ледяную воду. Дно было устлано настоящим ковром из водорослей; между извивающимися буро-зелёными лентами мелькали подводные жители.';
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    way = { vroom ('Вынырнуть', 'labyrinth_61'),},
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'Я не мог больше оставаться под водой — мне не хватало воздуха; в глазах помутилось, кружилась голова...';
            return true;
        end
        if s._count == 3 then
            labyrinth_underwater_death._drown = true;
            walk (labyrinth_underwater_death);
            return true;
        end
--        return 'A='..s._count;
    end,
    exit = function (s, to)
        lifeoff (labyrinth_underwater);
        if to == labyrinth_underwater_death then
            return true;
        end
        if (s._return_to == 61) then
            walk (labyrinth_61);
            return;
        end
        if (s._return_to == 63) then
            walk (labyrinth_63);
            return;
        end
        if (s._return_to == 65) then
            walk (labyrinth_65);
            return;
        end
        if (s._return_to == 66) then
            walk (labyrinth_66);
            return;
        end
        if (s._return_to == 68) then
            walk (labyrinth_68);
            return;
        end
    end,
};


labyrinth_underwater_death = room {
    nam = 'Дно подземного озера',
    _drown = false,
    pic = function(s)
        return 'images/labyrinth_61_underwater.png';
    end,
    enter = function (s, from)
        me():disable_all();
    end,
    dsc = function(s)
        if s._drown then
            return 'Сдерживать дыхание не было сил. Судорожным движением я попытался вдохнуть воздух, но лёгкие заполнились водой. Я стал медленно опускаться на дно...';
        else
            return 'Ледяная вода сковала мои мышцы. Я был уже не в силах сопротивляться усталости, и озеро полностью завладело мной.';
        end
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function(s)
        me():enable_all();
    end,
};


water_monster = iobj {
    nam = 'чудовище',
    _is_alive = true,
    dsc = function (s)
        return 'В холодной воде озера плавало огромное {чудовище}.';
    end,
    exam = function (s)
        if here() == labyrinth_63 then
            if water_monster._is_alive then
                water_monster_neck:enable();
                return 'Покрытое крупной чешуёй тело обитателя озера блестело, переливаясь зелёным и синим. Чудовище хищно высматривало добычу в холодной воде, раскачивая маленькой головой. Отсюда была хорошо видна длинная тонкая шея чудовища.';
            else
                return 'Огромное чешуйчатое тело переливалось зелёным и синим. Маленькая голова на длинной шее безжизненно плавала на воде. Острые плавники слегка покачивались на волнах.';
            end
        else
            if water_monster._is_alive then
                return 'Покрытое крупной чешуёй тело обитателя озера блестело, переливаясь зелёным и синим. Чудовище хищно высматривало добычу в холодной воде, раскачивая маленькой головой.';
            else
                return 'Огромное чешуйчатое тело переливалось зелёным и синим. Маленькая голова на длинной шее безжизненно плавала на воде. Острые плавники слегка покачивались на волнах.';
            end
        end
    end,
    used = function (s, w)
        if w == crossbow then
            if not have (crossbow) then
                return 'У меня нет арбалета.';
            else
                if crossbow._loaded then
                    crossbow._loaded = false;
                    return 'Стрела отскочила от чешуи, не причинив чудовищу никакого вреда.';
                else
                    return 'Арбалет не заряжен.';
                end
            end
        end
    end,
};


water_monster_neck = iobj {
    nam = 'шея чудовища',
    dsc = function (s)
        return 'У чудовища была длинная тонкая {шея}.';
    end,
    exam = function (s)
        return 'Толстая чешуя покрывала всё тело, шею и голову водного создания, что делало его неуязвимым для врагов. Но присмотревшись повнимательнее, я заметил, что на шее, у самой головы, роговой покров не так крепок.';
    end,
    used = function (s, w)
        if w == crossbow then
            if not have (crossbow) then
                return 'У меня нет арбалета.';
            else
                if crossbow._loaded then
                    crossbow._loaded = false;
                    water_monster._is_alive = false;
                    water_monster_neck:disable();
                    return 'Стараясь не раскачиваться на воде, я навёл арбалет на незащищённую шею чудовища, и, затаив дыхание, спустил тетиву. Просвистев в воздухе, стрела вонзилась точно между чешуйками.^^Животное замотало шеей, издавая булькающие звуки, забило плавниками. Но вскоре мёртвая голова упала в воду, и тело чудовища неподвижно замерло.';
                else
                    return 'Арбалет не заряжен.';
                end
            end
        end
    end,
}:disable();


labyrinth_63 = room {
    nam = 'Скала',
    _add_health_rest = 2,
    _del_health = 3,
--    _first_time = true,
    _water = true,
    pic = function(s)
        if water_monster._is_alive then
            if raft._ready then
                return 'images/labyrinth_63b.png';
            else
                return 'images/labyrinth_63.png';
            end
        else
            return 'images/labyrinth_63c.png';
        end
    end,
    dsc = function(s)
--        if s._first_time then
--        s._first_time = false;
--            return 'Лестница бежала всё глубже, устремляясь к центру скалы. Наконец бесконечная вереница ступеней оборвалась, и я вышел на берег подземного озера. Отражаясь от ледяных стен и мелкой ряби водной поверхности, на стенах пещеры играли слабые блики света. Может, это неизвестные растения излучали его, или обитатели озера освещали свой путь — так или иначе, это останется ещё одной загадкой таинственного лабиринта.';
--        else
            return 'Я медленно продвигался вдоль стены подземного озера. Покрытые мхом мокрые скалы слабо блестели, как и ледяные колонны, встречавшиеся на пути. Вдали, покачивая уродливой головой, плавало водное создание.';
--        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('К берегу', 'labyrinth_61'), vroom ('К чудовищу', 'labyrinth_64'), vroom ('Нырнуть', 'labyrinth_underwater'),},
    obj = { 'lake', 'water_monster', 'water_monster_neck' },
    exit = function (s, to)
        if to == labyrinth_64 then
            if water_monster._is_alive then
                walk (labyrinth_water_monster_death);
                return;
            end
        end
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


labyrinth_64 = room {
    nam = 'Чудовище',
--    _monster_is_alive = true,
    _add_health_rest = 2,
    _del_health = 3,
--    _first_time = true,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_64.png';
    end,
    dsc = function(s)
        return 'Хотя чудовище и было мертво, всё же при приближении к огромному чешуйчатому телу становилось немного не по себе.';
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('К берегу', 'labyrinth_61'), vroom ('Вдоль скалы', 'labyrinth_63'), vroom ('Центр озера', 'labyrinth_65'), vroom ('Тоннель', 'labyrinth_68'), vroom ('Нырнуть', 'labyrinth_underwater_monster'),},
    obj = { 'lake', 'water_monster' },
    exit = function (s, to)
        if ( to == labyrinth_underwater_monster and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


labyrinth_underwater_monster = room {
    nam = 'Дно подземного озера',
    _del_health = 3,
    _count = 0,
    _water = true,
    pic = function(s)
        if chest_underwater._closed then
            return 'images/labyrinth_71.png';
        else
            return 'images/labyrinth_71b.png';
        end
    end,
    enter = function (s, from)
        s._count = 0;
        lifeon (labyrinth_underwater_monster);
    end,
    dsc = function(s)
            return 'Сделав глубокий вдох, я опустился под воду. Водоросли густо покрывали всё дно и стены.';
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    obj = { 'chest_underwater' },
    way = { vroom ('Вынырнуть', 'labyrinth_64'),},
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'Я не мог больше оставаться под водой — мне не хватало воздуха; в глазах помутилось, кружилась голова...';
            return true;
        end
        if s._count == 3 then
            labyrinth_underwater_death._drown = true;
            walk (labyrinth_underwater_death);
            return true;
        end
--        return 'A='..s._count;
    end,
    exit = function (s, from)
        lifeoff (labyrinth_underwater_monster);
    end,
};


chest_underwater = iobj {
    nam = 'сундук',
    _sword_inside = true,
    _closed = true,
    _examined = false,
    _weight = 101,
    dsc = function (s)
        if s._closed then
            return 'Среди камней, опутанный подводными растениями, стоял старый, обитый железом {сундук}.';
        else
            return 'Среди камней, опутанный подводными растениями, стоял открытый {сундук}.';
        end
    end,
    exam = function (s)
        if s._examined then
            return 'Большой деревянный сундук.';
        else
            labyrinth_underwater_monster._count = labyrinth_underwater_monster._count - 1;
            s._examined = true;
            return 'Большой деревянный сундук.';
        end
    end,
    useit = function (s)
        if s._closed then
            s._closed = false;
            sword:enable();
            return 'С большим трудом мне удалось поднять тяжёлую, окованную железом крышку. Среди потерявших от времени всякую форму предметов, лежал короткий меч, каким-то чудом избежавший разрушительного действия воды.';
        else
            return 'Сундук уже открыт.';
        end
    end,
    obj = { 'sword' },
};


sword = iobj {
    nam = 'меч',
    _weight = 20,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Меч} лежит на плите ';
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
--            return ref(s._on_what);
        end
        if chest_underwater._sword_inside then
            return 'В сундуке лежит короткий {меч}.';
        else
            return 'Я вижу короткий {меч}.';
        end
    end,
    exam = function (s)
        return 'Искусно выкованный острый короткий меч из серебристо-серого металла.';
    end,
    take = function (s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        if chest_underwater._sword_inside then
            chest_underwater._sword_inside = false;
            status._progress = status._progress + 1;
            return 'Я взял меч из сундука.';
        else
            return 'Я взял меч.';
        end
    end,
    drop = function (s)
        if here() == castle_415 and seen (knight) then
            knight._ready_to_talk = true;
            knight._attack = false;
            return true;
        end
        return 'Я бросил меч.';
    end,
}:disable();



labyrinth_water_monster_death = room {
    nam = 'Чудовище',
    pic = function(s)
        return 'images/labyrinth_water_monster_death.png';
    end,
    enter = function (s)
        me():disable_all();
--        if from == labyrinth_34 then
--            s._came_from_above = true;
--        else
--            s._came_from_above = false;
--        end
    end,
    dsc = function(s)
--        if s._first_time then
--        s._first_time = false;
--            return 'Лестница бежала всё глубже, устремляясь к центру скалы. Наконец бесконечная вереница ступеней оборвалась, и я вышел на берег подземного озера. Отражаясь от ледяных стен и мелкой ряби водной поверхности, на стенах пещеры играли слабые блики света. Может, это неизвестные растения излучали его, или обитатели озера освещали свой путь — так или иначе, это останется ещё одной загадкой таинственного лабиринта.';
--        else
            return 'Я осторожно приближался к чудовищу, стараясь не тревожить воду. Но вдруг огромная шея изогнулась, страшные глава злобно блеснули, раскрылась зубастая пасть...';
--        end
    end,
    rest = function(s)
        return 'Я постарался расслабиться и прогнать все чёрные мысли.';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function(s)
        me():enable_all();
    end,
};


labyrinth_65 = room {
    nam = 'Центр озера',
    _add_health_rest = 2,
    _del_health = 3,
--    _first_time = true,
    _water = true,
    pic = function(s)
        if water_monster._is_alive then
            if raft._ready then
                return 'images/labyrinth_65b.png';
            else
                return 'images/labyrinth_65.png';
            end
        else
            return 'images/labyrinth_65c.png';
        end
    end,
--    enter = function (s, from)
--        if from == labyrinth_34 then
--            s._came_from_above = true;
--        else
--            s._came_from_above = false;
--        end
--    end,
    dsc = function(s)
        if water_monster._is_alive then
            return 'Выплыв на середину озера, я остановился среди ледяных выростов, спускавшихся с потолка огромной пещеры и уходивших под воду. Далёкие стены угадывались по слабому блеску.^^Около одной из них, закрывая огромным телом водный тоннель, плавало чудовище, вытянув длинную шею с ужасной головой.';
        else
            return 'Выплыв на середину озера, я остановился среди ледяных выростов, спускавшихся с потолка огромной пещеры и уходивших под воду. Далёкие стены угадывались по слабому блеску.^^Около одной из далёких стен плавало огромное тело чудовища, за которым виднелся водный тоннель.';
        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('К берегу', 'labyrinth_61'), vroom ('К чудовищу', 'labyrinth_64'), vroom ('К источнику', 'labyrinth_66'), vroom ('Нырнуть', 'labyrinth_underwater'),},
    obj = { 'lake', 'water_monster' },
    exit = function (s, to)
        if to == labyrinth_64 then
            if water_monster._is_alive then
                walk (labyrinth_water_monster_death);
                return;
            end
        end
        if ( to == labyrinth_underwater and status._cargo>20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


labyrinth_66 = room {
    nam = 'Источник',
    _add_health_rest = 2,
    _del_health = 3,
--    _first_time = true,
    _water = true,
    pic = function(s)
        if raft._ready then
            return 'images/labyrinth_66b.png';
        else
            return 'images/labyrinth_66.png';
        end
    end,
--    enter = function (s, from)
--        if from == labyrinth_34 then
--            s._came_from_above = true;
--        else
--            s._came_from_above = false;
--        end
--    end,
    dsc = function(s)
--        if s._first_time then
--        s._first_time = false;
--            return 'Лестница бежала всё глубже, устремляясь к центру скалы. Наконец бесконечная вереница ступеней оборвалась, и я вышел на берег подземного озера. Отражаясь от ледяных стен и мелкой ряби водной поверхности, на стенах пещеры играли слабые блики света. Может, это неизвестные растения излучали его, или обитатели озера освещали свой путь — так или иначе, это останется ещё одной загадкой таинственного лабиринта.';
--        else
            return 'На воде стали появляться маслянистые пятна, послышался глухой плеск, и вскоре я подплыл к скале, из которой медленно стекала на поверхность озера густая жидкость, устремляясь в сторону недалёкого водоворота.';
--        end
    end,
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
    way = { vroom ('Центр озера', 'labyrinth_65'), vroom ('По течению', 'labyrinth_67'), vroom ('Нырнуть', 'labyrinth_underwater'),},
    obj = { 'oil' },
    exit = function (s, to)
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};





labyrinth_68 = room {
    nam = 'Тоннель',
    _add_health_rest = 2,
    _del_health = 3,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_68.png';
    end,
    dsc = function(s)
        return 'В этой части озера ледяные колонны образовывали нечто вроде тоннеля. Ни единого звука со стороны озера не доносилось сюда. Здесь царил полный покой.';
    end,
    obj = { 'school_of_fishes' },
    way = { vroom ('К чудовищу', 'labyrinth_64'), vroom ('К стене', 'labyrinth_69'), vroom ('Нырнуть', 'labyrinth_underwater'),},
    exit = function (s, to)
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


oil = iobj {
    nam = 'жидкость',
    dsc = function (s)
        return 'Чёрная маслянистая {жидкость} стекала из скалы на поверхность озера.';
    end,
    exam = function (s)
        return 'Чёрная маслянистая жидкость с резким запахом.';
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'У меня нет шеста.';
            else
                if pole._oiled then
                    return 'Я уже смочил конец шеста в чёрной жидкости.';
                else
                    if pole._wrap then
                        pole._oiled = true;
                        return 'Я погрузил обмотанный паутиной конец шеста в самый центр источника.';
                    else
                        return 'Не получается.';
                    end
                end
            end
        end
    end,
};

labyrinth_67 = room {
    nam = 'Водоворот',
    pic = function(s)
        return 'images/labyrinth_67.png';
    end,
    enter = function(s)
        me():disable_all();
    end,
    dsc = function(s)
        return 'Течение становилось всё сильнее и сильнее, и когда быстрая вода подхватила и понесла меня прямо в страшную пасть водоворота, я понял, что неосторожно поплыл в эту сторону, но было поздно — волны уже скрыли от меня мир живых...';
    end,
    obj = { vway('1', '{Далее}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};


school_of_fishes = iobj {
    nam = 'стая рыб',
    _number_of_fishes = 2,
    dsc = function (s)
        return 'У самой поверхности плавала {стая рыб}.';
    end,
    exam = function (s)
        return 'Несколько крупных рыб неторопливо плавали у самой поверхности озера.';
    end,
    useit = function(s)
        return 'Я безуспешно попытался поймать рыбу руками.';
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'У меня нет шеста.';
            else
                if pole._sharp then
                    if school_of_fishes._number_of_fishes == 2 then
                        put('fish1', labyrinth_68);
                        Take (fish1);
                        school_of_fishes._number_of_fishes = 1;
                        return 'Быстрым движением я наколол рыбу на острый шест.';
                    end
                    if school_of_fishes._number_of_fishes == 1 then
                        school_of_fishes._number_of_fishes = 0;
                        put('fish2', labyrinth_68);
                        Take (fish2);
                        objs():del(school_of_fishes);
                        return 'Быстрым движением я наколол рыбу на острый шест, неосторожно спугнув всю стаю.';
                    end
                else
                    return 'Я попытался оглушить одну из рыб шестом, но она без труда увернулась.';
                end
            end
        end
    end,
};


fish1 = iobj {
    nam = 'рыба',
    _weight = 7,
    dsc = function (s)
        return 'Я вижу {рыбу}.';
    end,
    exam = function (s)
        return 'Крупная рыба с короткими колючими плавниками.';
    end,
    take = function (s)
        return 'Я взял рыбу.';
    end,
    drop = function (s)
        return 'Я бросил рыбу.';
    end,
    useit = function (s)
        if not have (s) then
            return 'У меня нет рыбы.';
        else
            status._health = status._health + 80;
            Drop (s);
            objs():del(s);
            return 'Есть сырую рыбу было неприятно, но всё же, поев, я почувствовал себя значительно лучше.';
        end
    end,
};


fish2 = iobj {
    nam = 'рыба',
    _weight = 7,
    dsc = function (s)
        return 'Я вижу {рыбу}.';
    end,
    exam = function (s)
        return 'Крупная рыба с короткими колючими плавниками.';
    end,
    take = function (s)
        return 'Я взял рыбу.';
    end,
    drop = function (s)
        return 'Я бросил рыбу.';
    end,
    useit = function (s)
        if not have (s) then
            return 'У меня нет рыбы.';
        else
            status._health = status._health + 80;
            Drop (s);
            objs():del(s);
            return 'Есть сырую рыбу было неприятно, но всё же, поев, я почувствовал себя значительно лучше.';
        end
    end,
};


labyrinth_69 = room {
    nam = 'Стена',
    _add_health_rest = 2,
    _del_health = 3,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_69.png';
    end,
    dsc = function(s)
        return 'Ледяной коридор упирался в стену, покрытую мхом. На тихой воде не было даже мелкой ряби, не было слышно ни звука. Под действием полного безмолвия я и сам старался плыть как можно тише.';
    end,
    way = { vroom ('Туннель', 'labyrinth_68'), vroom ('Нырнуть', 'labyrinth_70'), },
    exit = function (s, to)
        if ( to == labyrinth_70 and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


labyrinth_70 = room {
    nam = 'Дно подземного озера',
    _del_health = 3,
    _count = 0,
    _cutted = false,
    _water = true,
    pic = function(s)
        if s._cutted then
            return 'images/labyrinth_70b.png';
        end
        return 'images/labyrinth_70.png';
    end,
    enter = function (s, from)
        s._count = 0;
        if from == labyrinth_72 then
            s._count = labyrinth_72._count;
        end
        lifeon (labyrinth_70);
    end,
    dsc = function(s)
        if s._count == 2 then
            return true;
        end
        if s._cutted then
            return 'Сделав глубокий вдох, я опустился под воду. Длинные густые водоросли слегка колыхались при движении воды. Крепкое сплетение их вокруг камней было разрублено, открывая подводную арку в скале.';
        else
            return 'Сделав глубокий вдох, я опустился под воду. Длинные густые водоросли слегка колыхались при движении воды. Крепко переплетаясь вокруг камней, они закрывали подводную арку в скале.';
        end
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    way = { vroom ('Вынырнуть', 'labyrinth_69'),},
    obj = { 'algae' },
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'Я не мог больше оставаться под водой — мне не хватало воздуха; в глазах помутилось, кружилась голова...';
            return true;
        end
        if s._count == 3 then
            labyrinth_underwater_death._drown = true;
            walk (labyrinth_underwater_death);
            return true;
        end
--        return 'A70='..s._count;
    end,
    exit = function (s, from)
        lifeoff (labyrinth_70);
    end,
};


algae = iobj {
    nam = 'водоросли',
    dsc = function (s)
        return 'Я вижу {водоросли}.';
    end,
    exam = function (s)
        return 'Настоящая живая стена, сквозь которую не проскочит даже мелкая рыбёшка.';
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                if s._cutted then
                    return 'Я уже освободил проход.';
                else
                    labyrinth_70._cutted = true;
                    ways(labyrinth_70):add(vroom ('Проход', 'labyrinth_72'));
                    return 'Острое лезвие с лёгкостью разрезало переплетённые водоросли.';
                end
            end
        end
    end,
};


labyrinth_72 = room {
    nam = 'Дно подземного озера',
    _del_health = 3,
    _count = 0,
    _cutted = false,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_72.png';
    end,
    enter = function (s, from)
        s._count = 0;
        if from == labyrinth_70 then
            s._count = labyrinth_70._count;
        end
        lifeon (labyrinth_72);
    end,
    dsc = function(s)
        return 'Короткий подводный проход соединял две части огромного озера, разделённые каменной стеной.';
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    way = { vroom ('Проход', 'labyrinth_70'), vroom ('Вынырнуть', 'labyrinth_73'),},
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'Я не мог больше оставаться под водой — мне не хватало воздуха; в глазах помутилось, кружилась голова...';
            return true;
        end
        if s._count == 3 then
            labyrinth_underwater_death._drown = true;
            walk (labyrinth_underwater_death);
            return true;
        end
--        return 'A72='..s._count;
    end,
    exit = function (s, from)
        lifeoff (labyrinth_72);
    end,
};


labyrinth_73 = room {
    nam = 'Тихая заводь',
    _del_health = 3,
    _from_stair = false;
    _water = true,
    enter = function (s, from)
        if from == labyrinth_74 then
            s._from_stair = true;
        else
            s._from_stair = false;
        end
    end,
    pic = function(s)
        return 'images/labyrinth_73.png';
    end,
    dsc = function(s)
        if s._from_stair then
            return 'Я вошёл в воду и поплыл к отвесно уходящей под воду каменной стене.';
        else
            return 'Тихая заводь, со всех сторон окружённая отвесными стенами. Неподалёку из воды полого поднимался каменный берег.';
        end
    end,
    way = { vroom ('Нырнуть', 'labyrinth_72'), vroom ('На берег', 'labyrinth_74'), },
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    exit = function (s, to)
        if ( to == labyrinth_72 and status._cargo > 20 ) then
            p 'Я не решался нырять со столь большим грузом.';
            return false;
        end
    end,
};


labyrinth_74 = room {
    nam = 'Берег подземного озера',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_74.png';
    end,
    dsc = function(s)
        return 'Ступени идущей наверх лестницы подходили почти к самой воде. Берег полого уходил в озеро, скрываясь в тёмной воде.';
    end,
    way = { vroom ('В озеро', 'labyrinth_73'), vroom ('Лестница', 'labyrinth_75'), },
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
};


labyrinth_75 = room {
    nam = 'Лабиринт',
    _add_health_rest = 2,
    _del_health = 3,
    _fire_is_burning = false;
    pic = function(s)
        if seen (niche) then
            if s._fire_is_burning then
                return 'images/labyrinth_75c.png';
            else
                return 'images/labyrinth_75b.png';
            end
        end
        return 'images/labyrinth_75a.png';
    end,
    dsc = function(s)
        return 'Широкий коридор уходил в темноту, но путь преграждали массивные колонны.';
--        return 'Широкий коридор уходил в темноту, но путь преграждали массивные колонны. В стене чернело углубление правильной формы.';
    end,
    way = { vroom ('Лестница', 'labyrinth_74'), },
--    way = { vroom ('Лестница', 'labyrinth_74'), vroom ('TEST', 'labyrinth_48'), },
    rest = 'Я постарался расслабиться и прогнать все чёрные мысли.',
};


part_3_end_hints_1 = room {
    nam =  'Площадка',
    _all_items = true,
    pic = function (s)
        if labyrinth_11._boulder_is_here then
            return 'images/labyrinth_11_initial.png';
        else
            return 'images/labyrinth_11_no_boulder.png';
        end
    end,
    enter = function (s)
        me():disable_all();
        s._all_items = true;
        if not have (crossbow) then
            s._all_items = false;
        end
        if not have (flint) then
            s._all_items = false;
        end
        if not have (jug) then
            s._all_items = false;
        end
        if not have (sword) then
            s._all_items = false;
        end
        if not have (mushroom) then
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
    obj = { vway('1', '{Назад}^', 'labyrinth_11'), vway('2', '{Показать список необходимых предметов}^', 'part_3_end_hints_2'), vway('3', '{Перейти на следующий уровень}', 'part_3_end'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_3_end_hints_2 = room {
    nam =  'Площадка',
    pic = function (s)
        if labyrinth_11._boulder_is_here then
            return 'images/labyrinth_11_initial.png';
        else
            return 'images/labyrinth_11_no_boulder.png';
        end
    end,
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Вы АБСОЛЮТНО уверены, что хотите увидеть перечень предметов, необходимых для дальнейшего прохождения игры?^Отвечайте «Да» только в случае если Вы безнадёжно застряли!';
    end,
    obj = { vway('1', '{Назад}^', 'labyrinth_11'), vway('2', '{Показать список необходимых предметов}', 'part_3_end_hints_3'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_3_end_hints_3 = room {
    nam =  'Площадка',
    pic = function (s)
        if labyrinth_11._boulder_is_here then
            return 'images/labyrinth_11_initial.png';
        else
            return 'images/labyrinth_11_no_boulder.png';
        end
    end,
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Перечень предметов, которые Вам потребуются в последней части игры:^- арбалет;^- кремень;^- кувшин;^- меч;^- гриб.';
    end,
    obj = { vway('1', '{Назад}', 'labyrinth_11') },
    exit = function(s)
        me():enable_all();
    end,
};


part_3_end = room {
    nam =  'Площадка',
    pic = 'images/labyrinth_11_no_eagle.png',
    dsc = 'Я осторожно залез на спину птице. Взмахнув широкими крыльями, орёл взлетел с площадки...',
    obj = { vway('1', '{Далее}', 'i401') },
    enter = function(s)
        me():disable_all();
    end,
};
