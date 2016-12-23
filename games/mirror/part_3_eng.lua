-- ’
-- —

i301 = room {
    nam = '...',
    pic = 'images/movie_3.gif',
    dsc = '...The Keeper enter the dark cave. Before he made a few steps, magical force transfer him into the center of Labyrynth...';
    enter = function(s)
        set_music('music/part_3.ogg');
        status._drink_water_on_this_level = false;
        status._fatigue_death_string = '...Roaming on endless corridors and stairs of labyrynth exhaust me. I fall on he floor and loose consciousness...';
    end,
    way = { vroom ('Back', 'part_2_end'), vroom ('Next', 'i302') },
};


i302 = room {
    nam = '...',
    pic = 'images/darkness.png',
    dsc = function(s)
--        return 'ddd';
        return 'All happens so fast that I have no time to do anything. Bright flash, blinding white light, and when I wake up on cold floorm the darkness surrounds me.^After some time my eyes get used to dark and I look out. I was in stone labyrynth.';
    end,
--    way = { vroom ('ДАЛЕЕ', 'labyrinth_21') },
    obj = { vway('1', '{Next}', 'labyrinth_21') },
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
    nam = 'Landing',
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
            return [[Walls and stairs had litten by weak light, which comes from above. It seems quite strange in this dark Labyrynth, but when I ascend, I realise what is the matter.^
                     I stand on open landing, from which opens majestic view. Around, as far as my eyes can see, spread steep cliffs and deep canyons. But above of them, threateningly still rises above Triple-headed Castle, surrounded by dark clouds.^
                     Now I notice, that I’m not alone on the landing: on the very brink, on a big stone not paying attention on me, sit huge eagle.]];
        else
            return [[Walls and stairs had litten by weak light, which comes from above. It seems quite strange in this dark Labyrynth, but when I ascend, I realise what is the matter.^
                     I stand on open landing, from which opens majestic view. Around, as far as my eyes can see, spread steep cliffs and deep canyons. But above of them, threateningly still rises above Triple-headed Castle, surrounded by dark clouds.^
                     Now I notice, that I’m not alone on the landing: on the very brink, not paying attention on me, sit huge eagle.]];
        end
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Stairs', 'labyrinth_24'), },
    obj = { 'boulder', 'brushwood', 'eagle' },
    life = function (s)
        if s._eagle_is_finished then
            s._eagle_is_finished = false;
            objs():del(fruit);
            if s._boulder_is_here then
                s._eagle_seating_on_stone = true;
                p 'I watch as the eagle finish his small meal and then return to his previous place.';
                return true;
            else
                p 'After finished his small meal, the eagle return to his previous place, but when he not found boulder, he just seat on landing edge.';
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
            p 'Immediately hungry bird loose his place and fall on it, operating his strong beak and powerful arms fast.';
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
    nam = 'Landing',
    pic = function(s)
        return 'images/labyrinth_11_fruit.png';
    end,
    enter = function (s)
        fruit:disable();
        me():disable_all();
    end,
    dsc = function(s)
        return 'I drop fruit on the floor.';
    end,
--    way = { vroom ('Далее', 'labyrinth_11'), },
    obj = { vway('1', '{Next}', 'labyrinth_11') },
    exit = function (s)
        fruit:enable();
        me():enable_all();
        labyrinth_11._fruit_is_dropped = false;
        labyrinth_11._eagle_is_eating = true;
    end,
};


brushwood = iobj {
    nam = 'brushwood',
    _weight = 19,
    dsc = function(s)
        if here() == labyrinth_22 then
            if labyrinth_22._brushwood_is_here then
                return '{Brushwood} lay in the niche.';
            else
                return '{Brushwood} lay on the floor.';
            end
        end
        return '{Brushwood} lay not far from me.';
    end,
    exam = 'Thin dry tree branches.',
    take = function(s)
        if here() == labyrinth_22 and labyrinth_22._brushwood_is_here then
            labyrinth_22._brushwood_is_here = false;
            return 'I take the brushwood from the niche.';
        end
        return 'I take brushwood.';
    end,
    drop = function(s)
        return 'I drop brushwood.';
    end,
    used = function (s, w)
        if w == flint then
            if not have (flint) then
                return 'I have no flint.';
            else
                if here() == labyrinth_22 and labyrinth_22._brushwood_is_here then
                    labyrinth_22._brushwood_is_here = false;
                    labyrinth_22._fire_is_burning = true;
                    status._progress = status._progress + 6;
                    objs():del(brushwood);
                    ways(labyrinth_34):add(vroom ('Stairs', 'labyrinth_60'));
                    return 'I hit edge of niche by flint and spark light up the brushwood. It is strange, but after branches burned down, fire is not fade out, just like it was support by mysterious magic.';
                else
                    return 'I can burn brushwood, but there is no use of it here.';
                end
            end
        end
    end,
};


boulder = iobj {
    nam = 'boulder',
    _weight = 98,
    _talked = false,
    dsc = function(s)
        return '{Boulder} is laying on the floor.';
    end,
    exam = 'Big, stragenly smooth stone without any cracks and scratches.',
    take = function (s)
        if ( (here() == labyrinth_34) and (not(status._cargo + s._weight > 100)) ) then
            labyrinth_34._boulder_is_here = false;
        end
        if here() == labyrinth_11 then
            if labyrinth_11._eagle_seating_on_stone then
                p 'Eagle start to hit his wings, not allowing me to approach to boulder, trying to scratch my face by his sharp-clawed arms, so I have to retreat. Bird calms down and take previous indifferent position.';
                return false;
            else
                if (not(status._cargo + s._weight > 100)) then
                    labyrinth_11._boulder_is_here = false;
                    return 'I take boulder from the floor.';
                end
            end
        else
            return 'I take boulder from the floor.';
        end
    end,
    drop = function (s)
        if here() == labyrinth_34 then
            labyrinth_34._boulder_is_here = true;
        end
        if here() == labyrinth_11 then
            labyrinth_11._boulder_is_here = true;
            if not(labyrinth_11._eagle_is_finished) then
                return 'I drop the boulder, and eagle, not payin attention at me at all, seat on smooth lump again.';
            end
        end
        if here() == labyrinth_25 and not (labyrinth_25._stair_is_accessible) then
            labyrinth_25._stair_is_accessible = true;
            objs():del(obstruction);
            Drop (boulder);
            objs():del(boulder);
            put('boulder', labyrinth_26);
            p 'I carefully lower boulder on broken floor. But the slope was too big and roundish boulder, does not hold out and roll on stairs, breaking and crushing on it’s way.';
            return false;
        end
        return 'I drop boulder.';
    end,
    talk = function(s)
        if here()== labyrinth_11 then
            return 'I can’t do this...';
        else
            if s._talked then
                return 'It’s useless.';
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
    dsc = [[I stroke plain stone surface.^
            — Yea-a-ah, — I drawl, — The Labyrynth hides many enigmas...^
            But suddenly high voice answer to my by rapid speech:^
            — I hear alive voice at last! It is so boring to lay down here, near that presumptuous bird, who even said a word!^
            I look around in wonder, but there is no one by my side.]],
    obj = {
            [1] = phr('Who is talking to me?', '— Don’t be afraid, human. I’m Thorne — the stone you stole from the Eagle. So long no one talk to me, that I start to forget how to speak. I’m glad to meet you...^And for a long time stone told me about his loneliness. I try to keep up the conversation politely, just not to offend Thorne, but when he stops, I feel huge relief.', [[status._progress = status._progress + 3; poff(1, 2);]]),
            [2] = phr('Go away, evil force! Do not afftect on my mind!', '— Offended voice said:^— Well, out of hand «evil force!», «go away»... without understanding! Hmmm...^And for some time I heard wheezes and sighs, and then all calm down.', [[poff(1, 2);]]),
          },
    exit = function (s, t)
        boulder._talked = true;
        me():enable_all();
    end,
};


eagle = iobj {
    nam = 'eagle',
    _hungry = true,
    dsc = function(s)
        return 'I see big {eagle}.';
    end,
    exam = function(s)
        if s._eagle_is_eating or s._eagle_is_finishing then
            return 'Proud bird, not paying attention on my at all, enjoy his food.';
        else
            return 'Proud bird looking in far motionlessly, not paying attention to me at all. On black-and-white feathers play rare rays of distant sun.';
        end
    end,
    useit = function (s)
        if s._hungry or not labyrinth_46._conversation_was_good then
            return 'Eagle start to flop, trying to scratch my face by his sharp-clawed arms, so I have to retreat. Bird calms down and return to his indifferent position.';
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
                return 'I already feed an eagle.';
            else
                s._hungry = false;
                Drop (w);
                objs():del(w);
                return 'I give the fish to en eagle. Cunningly tear up he fish by strong arms, bird quickly swallow his booty.';
            end
        end
        return 'An eagle even doesn’t look at me.';
    end,
    talk = function (s)
        walk (eagle_dlg);
        return;
    end,
};


eagle_dlg = dlg{
    nam = 'Landing',
    pic = function(s)
        return call(from(),'pic');
    end,
    enter = function (s, t)
        me():disable_all();
        if ( labyrinth_46._conversation_was_good and (not eagle._hungry) ) then
            poff (2);
        end
    end,
    obj = {
            [1] = phr('Kind bird, please help me to get to Triple-headed Castle. I must stop misdeeds of The Dark Lord.', nil, [[pon(1); eagle._dlg_line=1; back();]]),
            [2] = phr('Why are you always keeps silent?! Answer to me!', nil, [[pon(2); eagle._dlg_line=2; back();]]),
          },
    exit = function (s, to)
        if ( labyrinth_46._conversation_was_good and (eagle._dlg_line == 1) ) then
            if eagle._hungry then
                p '— I might have carry you over to Triple-headed Castle, but I fear that I will not bear such a long journey.';
            else
                p '— All right, I will carry you over to the Castle. Seat on my back.';
            end
        else
            p 'There was no answer on my words. The Bird not even turn her head in my direction.';
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
    nam = 'Labyrynth',
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
            return 'Bright light of distant fire outline sharply acrs graven in walls, dropping thick shadows on stairs.';
        else
            return 'Walls with graven acrs, cold corridor, dissapearing in the dark, running down the stairs. Monotony of labyrynth cast a gloom and fear over me.';
        end
    end,
    way = { vroom ('Turning', 'labyrinth_23'),
            vroom ('Stairs', 'labyrinth_33'),
            vroom ('Corridor', 'labyrinth_22'), },
    rest = 'I seat on the floor and rest for a while.',
    exit = function (s, to)
        if to == labyrinth_23 and labyrinth_23._first_time then
            walk (labyrinth_23a);
            return;
        end
    end,
};


labyrinth_22 = room {
    nam = 'Labyrynth',
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
            return 'Without stopping, corridor had run through the rock, and was crossed by stairs and sharp turnings. In the niche near the stairs the fire burns brightly, spreading the light all over the corridor.';
        else
            return 'Without stopping, corridor had run through the rock, and was crossed by stairs and sharp turnings. Violating sad monotony of the walls, the deep niche shows black near the stair.';
        end
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('Corridor', 'labyrinth_21'),
            vroom ('Stairs', 'labyrinth_31') },
    obj = { 'niche' },
};


niche = iobj {
    nam = 'niche',
    dsc = function(s)
        return 'There is a {niche} in the wall.';
    end,
    exam = function(s)
        if here()==labyrinth_22 and labyrinth_22._fire_is_burning then
            return 'The fire burning brightly in the deep opening in the wall.';
        end
        if here()==labyrinth_75 and labyrinth_75._fire_is_burning then
            return 'The fire burning brightly in the deep opening in the wall.';
        end
        if here()==labyrinth_48 and labyrinth_48._fire_is_burning then
            return 'The fire burning brightly in the deep opening in the wall.';
        end
        if here()==labyrinth_34 and labyrinth_34._fire_is_burning then
            return 'The fire burning brightly in the deep opening in the wall.';
        end
        return 'It’s just a deep openning in the wall.';
    end,
    used = function (s, w)
        if w == brushwood then
            if not have (brushwood) then
                return 'I have no brushwood.';
            else
                labyrinth_22._brushwood_is_here = true;
                Drop (brushwood);
                return 'I put a brushwood into the niche.';
            end
        end
        if w == flint then
            if not have (flint) then
                return 'I have no flint.';
            else
                if here() == labyrinth_75 then
                    labyrinth_75._fire_is_burning = true;
                    put('niche', labyrinth_48);
                    status._progress = status._progress + 4;
                    return 'The fire flare up in the niche. Rumble spread across the corridor, massive columns trembles, but doesn’t move.';
                end
                if here() == labyrinth_48 then
                    labyrinth_48._fire_is_burning = true;
                    put('niche', labyrinth_34);
                    status._progress = status._progress + 4;
                    ways(labyrinth_48):add(vroom ('Corridor', 'labyrinth_25'));
                    ways(labyrinth_25):add(vroom ('Corridor', 'labyrinth_48'));
                    ways(labyrinth_49):add(vroom ('Turning', 'labyrinth_32'));
                    ways(labyrinth_32):add(vroom ('To the right', 'labyrinth_49'));
                    return 'The spark hit right in the center of niche, and the bright fire flare up, spilling magic light over the corridor. Suddenly stony gnash ring out, and one of the walls dissapears, revealing one more corridor.';
                end
                if here() == labyrinth_34 then
                    labyrinth_34._fire_is_burning = true;
                    status._progress = status._progress + 4;
                    labyrinth_46._people_are_free = true;
                    objs(labyrinth_47):del(people);
                    objs(labyrinth_47):del(girl);
                    return 'When the flame flares up in the niche, driving away thich shadow, frightful howl spreads out over the corridors and stairs, reverberating numerous echoes.';
                end
            end
        end
    end,
};


labyrinth_23a = room {
    nam = 'Labyrynth',
    pic = function(s)
        return 'images/labyrinth_23a.gif';
    end,
    enter = function(s)
        me():disable_all();
    end,
    dsc = function(s)
        return [[After a while I come into spacious room. There are three corridors run from it to different sides.^^
                 Suddenly vision appears instead of me. I freeze, no able to move a muscle.^
                 At a distance of few steps from me terrible head was inthe air, maliciously watching on me.^
                 Under stone arches of labyrynth spreads out thunder voice, creating numerous echoes:^
                 — Human! How dare you trouble silence of my labyrynth! You will not go oustide from here alive! Servats of the Evil will send your soul into the Kingdom of Shadows! Preapre to die!!!]];
    end,
    way = { vroom ('Next', 'labyrinth_23b') },
--    obj = { vway('1', '{Next}', 'labyrinth_23b') },
};


labyrinth_23b = room {
    nam = 'Labyrynth',
    pic = function(s)
        return 'images/labyrinth_23b.gif';
    end,
    dsc = function(s)
        return '...and the head dissolves in the air with terrible laughter.';
    end,
    way = { vroom ('Back', 'labyrinth_23a'), vroom ('Next', 'labyrinth_23') },
--    obj = { vway('1', '{}', 'labyrinth_23b'),
--            vway('2', '{Next}', 'labyrinth_23b'),},
    exit = function(s, to)
        if to == labyrinth_23 then
            me():enable_all();
        end
    end,
};


labyrinth_23 = room {
    nam = 'Labyrynth',
    _first_time = true,
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_23.png';
    end,
    dsc = function(s)
        if s._first_time then
            s._first_time = false;
            return 'I stand in the spacious room. There are three corridors run from it to different sides.';
        else
            return 'After a while I come into spacious room. There are three corridors run from it to different sides.';
        end
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('To the left', 'labyrinth_21'),
            vroom ('Straight', 'labyrinth_24'),
            vroom ('To the right', 'labyrinth_25'), }
};


labyrinth_24 = room {
    nam = 'Labyrynth',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_24.png';
    end,
    dsc = function(s)
        return 'Corridor stops here, making way to stair with high stairs, which ends somewhere in the height.';
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('Stair', 'labyrinth_11'),
            vroom ('Corridor', 'labyrinth_23'), },
};


labyrinth_25 = room {
    nam = 'Labyrynth',
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
            return 'Light streamed on the long corridor, outlining sharp rough cracks of crumpled floor. Dilapidated stair lead down.';
        else
            return 'Walls with carved arcs, dilapidated stair with stairs splitted by unknown force. It was very hard to walk in the dark on the broken floor.';
        end
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Turning', 'labyrinth_23'),
            vroom ('Stair', 'labyrinth_26'), },
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
                p 'Obstruction from logs blocks the pass on stair.';
                return false;
            end
        end
    end,
};


obstruction = iobj {
    nam = 'obstruction',
--    _mushroom_is_exist = false,
    dsc = function (s)
        return '{Obstruction} from logs blocks the pass on stair.';
    end,
    exam = function (s)
--        put('mushroom', labyrinth_25);
        mushrooms:enable();
        return 'Thick logs with many knots firmly cut into each other, forming solid wall. Obstruction become overgrown with moss and mushrooms due to moisture of labyrynth.';
    end,
}:disable();


mushrooms = iobj {
    nam = 'mushrooms',
    _mushroom_is_exist = false,
    dsc = function (s)
        return 'Numerous {mushrooms} grow on obstruction.';
    end,
    exam = function (s)
        return 'Numerous mushrooms grow here due to moisture of labyrynth.';
    end,
    take = function(s)
        if (status._cargo + 3 > 100) then
            p 'Too heavy!';
            return false;
        end
        if s._mushroom_is_exist then
            p 'There is no point to take one more mushroom.';
            return false;
        else
            s._mushroom_is_exist = true;
            put('mushroom', labyrinth_25);
            mushroom:enable();
            Take (mushroom);
            p 'I take the biggest mushroom.';
            return false;
        end
    end,
}:disable();


mushroom = iobj {
    nam = 'mushroom',
    _weight = 3,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Mushroom} lays on plate ';
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
        return 'I see {mushroom}.';
    end,
    exam = function (s)
        return 'Big mushroom.';
    end,
    take = function (s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        return 'I take mushroom.';
    end,
    drop = function()
        return 'I drop mushroom.';
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
            return 'Mushroom was tasteless, but satisfy hunger quite well.';
        else
            return 'I have no mushroom.';
        end
    end,
};
--}:disable();


labyrinth_26 = room {
    nam = 'Labyrynth',
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
            return 'Bright litten corridor from the floor to the ceiling was blocked by huge metal columns.';
        end
        if seen (logs) then
            return 'Old stairs lead to next corridor, which goes to the dark distance. Corridor was blocked by huge metal columns. Logs of broken obstruction lie near the stair.';
        else
            return 'Old stairs lead to next corridor, which goes to the dark distance. Corridor was blocked by huge metal columns.';
        end
    end,
    rest = 'I seat on the floor and rest for a while.',
    obj = { 'logs' },
    way = { vroom ('Stair', 'labyrinth_25'), }
};


logs = iobj {
    nam = 'logs',
    _weight = 93,
    dsc = function (s)
        return 'There are several {logs} lay not far from me.';
    end,
    exam = function (s)
        return 'Several logs, about same size.';
    end,
    take = function()
        return 'I take logs.';
    end,
    drop = function()
        return 'I drop logs.';
    end,
    used = function (s, w)
        if w == rope then
            if have (rope) then
                if ( (here() == labyrinth_60) and (seen (logs)) ) then
                    Drop(rope);
                    objs():del(logs);
                    objs():del(rope);
                    put('raft', labyrinth_60);
                    return 'After tightly tie logs with the rope, I get small but stable raft, which could maintain man’s weight.';
                end
            else
                return 'I have no rope.';
            end
        end
    end,
};


raft = iobj {
    nam = 'raft',
    _weight = 101,
    _ready = false,
    dsc = function (s)
        if s._ready then
            return 'On the smooth of lake water, not far from the bank there is a {raft}.';
        else
            return 'I see {raft}.';
        end
    end,
    exam = function (s)
        return 'Small but stable raft, which able to maintain man’s weight.';
    end,
    take = function()
    end,
    useit = function(s)
        if s._ready then
            return 'I push down raft on the water already.';
        else
            s._ready = true;
            ways(labyrinth_60):del('Lake');
            ways(labyrinth_60):add(vroom ('To the raft', 'labyrinth_61'));
            return 'I push down raft on the water.';
        end
    end,
};



labyrinth_31 = room {
    nam = 'Labyrynth',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_31.png';
    end,
    dsc = function(s)
        return 'Shar turnings changes by stairs, stairs changes by cheerless tunnels. It was moist and cold in the labyrynth.';
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Corridor', 'labyrinth_32'),
            vroom ('stair', 'labyrinth_22'), }
};


labyrinth_32 = room {
    nam = 'Labyrynth',
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
            return 'I come out to small room. There are two corridors here which go to the left and to the right. Brightly litten stair leads down to the center of Labyrynth.';
        end
        if labyrinth_47._fire_is_burning then
            return 'There is a corridor goes to the left, in the middle the stair goes down, and on the right, where assuming to be a third way, there was a solid wall.';
        end
        return 'It seems, that from this summetrical room must be three ways lead out, but there was just solid walls here instead of two of assuming ways.';
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('To the left', 'labyrinth_31'), },
};


labyrinth_33 = room {
    nam = 'Labyrynth',
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
            return 'Regulat light underline even more the awkward of walls and columns. It seems that this part of Labyrynth been cutted through by ancient masters earlier, and the time left his marks on it already.';
        else
            return 'Next corridor, ven more gloomy and colder. The walls here were worked up more rough, and in contrast to arcs and thin columns, cutted in walls of upper Labyrynth, have more mighty forms.';
        end
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Stair', 'labyrinth_21'),
            vroom ('Corridor', 'labyrinth_34'), }
};


labyrinth_34 = room {
    nam = 'Hole in the ceiling',
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
            return 'Highlighted corridor set against the solid wall. In the wall burns a fire, driving away cold twilight; there are only long black shadows lie on the walls of stair which goes down.';
        end
        if labyrinth_22._fire_is_burning then
            return 'Long downcast corridor set against the solid wall. From the nearby stairs breathes chilling moisture. Rough hole with ragged edges gape in the ceiling.';
        else
            return 'Corridor ends with solid wall, in which is carved column of unusual form. There is a hole surrounded by hanging thick spiderweb could be seen on the ceiling.';
        end
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Corridor', 'labyrinth_33'),
            vroom ('Hole', 'labyrinth_41'), },
    exit = function (s, to)
        if to == The_End then
            return true;
        end
        if to == labyrinth_41 then
            if s._boulder_is_here then
                return true;
            else
                p 'The hole is too high.';
                return false;
            end
        end
    end,
};


labyrinth_41 = room {
    nam = 'Hole',
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
            return 'Narrow round hole was covered something like spiderweb. Long sticky locks, hanged down from ceiling and walls, catch for the clothes, touch the body unpleasently.';
        else
            return 'Narrow round hole, starting with the opening in the ceiling of corridor and going into the deep of the rock further, was covered by something like the spiderweb. Long sticky locks, hanged down from ceiling and walls, catch for the clothes, touch the body unpleasently.';
        end
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Out from the cave', 'labyrinth_34'),
            vroom ('Hole', 'labyrinth_42'), }
};


labyrinth_42 = room {
    nam = 'Hole',
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
        return 'The hole start to dscend there, and this makes trouble in my movement over the spiderweb.';
    end,
    rest = 'I seat on the floor and rest for a while.',
    obj = { 'web_42' },
    way = { vroom ('Up', 'labyrinth_41'),
            vroom ('Down', 'labyrinth_43'), },
};


web_42 = iobj {
    nam = 'spiderweb',
    dsc = function (s)
        if labyrinth_42._web then
            return 'There is a one place, where {spiderweb} gather in taft, forming thick net.';
        else
            return 'Under the rags of cutted {spiderweb} there is a passage could be seen.';
        end
    end,
    exam = function (s)
        if labyrinth_42._web then
            return 'Solid sticky springy net.';
        else
            return 'Rags of solid stircky spiderweb.';
        end
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'I have no pole.';
            else
                if labyrinth_42._web then
                    return 'Spiderweb had reseliented, almost had beated the pole from my hand.';
                else
                    if pole._wrap then
                        return 'I wrapped the pole by rags of the web already.';
                    else
                        pole._wrap = true;
                        return 'I wrap the pole by rags of cutted speiderweb.';
                    end
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'I have no sword.';
            else
                if labyrinth_42._web then
                    labyrinth_42._web = false;
                    ways(labyrinth_42):add(vroom ('Hole', 'labyrinth_46'));
                    return 'The sword softly cut into the spiderweb. Spiderweb come unravelled, revealing the passage.';
                else
                    return 'I’ve cutted the way already.';
                end
            end
        end
    end,
};



labyrinth_43 = room {
    nam = 'Hole',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_43.png';
    end,
    dsc = function(s)
        return 'Slippery passage goes sharply up — I crawl with difficulty, clutching at the nasty spiderweb. I heard some strange sounds somwhere from above, which was similar to the heavy breathing of some huge being.^Strong strands thickly twine around stone beams, which form the arc.';
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Up', 'labyrinth_42'),
            vroom ('Arc', 'labyrinth_44'),
            vroom ('Passage', 'labyrinth_45'), }
};


labyrinth_44 = room {
    nam = 'Steep',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_44.png';
    end,
    dsc = function(s)
        return 'I walk through under stone arc and find myslef on the very edge of huge steep. There is a complete darkness around; and only far off below I distinguish strange lights, playing on small ripples of underground lake.';
    end,
    rest = 'I seat on the floor and rest for a while.',
    way = { vroom ('Arc', 'labyrinth_43'), },
};


labyrinth_45 = room {
    nam = 'Lair',
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
        return 'I climb up over the sticky spiderweb and found myslef in the very lair of the monster, who had build this hole. Something looks like spider, hiss and strech his long arms to me, looking his evil blood lust eyes on his new victim.';
    end,
    rest = 'I seat on the floor and rest for a while.',
    obj = { 'spider', 'web_45' },
    way = { vroom ('Passage', 'labyrinth_43'), },
};


spider = iobj {
    nam = 'spider',
    _is_alive = true,
    _arrowed = false,
    _state = 0,
    dsc = function (s)
--        if labyrinth_42._web then
--            return 'В одном месте {паутина} собиралась в пучки, образуя густую сетку.';
--        else
            return 'I see the {spider}.';
--        end
    end,
    exam = function (s)
        if s._is_alive then
            return 'Spider with hissing stretching his long arms towards to me.';
        else
            return 'Round spider’s body lies on the floor, spread his long arms. Green blood ooze out from the wound.';
        end
    end,
    used = function (s, w)
        if not s._is_alive then
            if (w == crossbow or w == sword) then
                return 'The spider is dead already.';
            end
        end
        if w == crossbow then
            if not have (crossbow) then
                return 'I have no crossbow.';
            else
                if not crossbow._loaded then
                    return 'The crossbow is not loaded.';
                else
                    s._is_alive = false;
                    s._arrowed = true;
                    lifeoff (spider);
                    return 'Fastly shoulder the crossbow, I shot in the head of approaching spider. Monster writhe in agony, brokenly throb his arms. But finally the spider shudder the last time and his dead body sink on the floor.';
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'I have no sword.';
            else
                s._is_alive = false;
                s._arrowed = false;
                lifeoff (spider);
                return 'Not awaiting for spider to reach me, I wave by sword, and horrible head of monster separates from thin neck. The body writhe in last convulsions, but soon sinks, stretching his long arms.';
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
    nam = 'spiderweb',
    dsc = function (s)
        if labyrinth_45._web then
            return 'The {spiderweb} gathered in tuft in one place, making thick net.';
        else
            return 'Under the rugs of cutted {spiderweb} there is a passage could be seen.';
        end
    end,
    exam = function (s)
        if labyrinth_45._web then
            return 'Strong sticky springy net.';
        else
            return 'The rugs of strong sticky springy net.';
        end
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'I have no pole.';
            else
                if labyrinth_45._web then
                    return 'The spiderweb resilents and I almost had beated the pole from my hand.';
                else
                    if pole._wrap then
                        return 'I wrapped the pole by rags of the web already.';
                    else
                        pole._wrap = true;
                        return 'I wrap the pole by rags of cutted speiderweb.';
                    end
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'I have no sword.';
            else
                if labyrinth_45._web then
                    labyrinth_45._web = false;
                    ways(labyrinth_45):add(vroom ('Hole', 'labyrinth_48'));
                    return 'The sword softly cut into the spiderweb. Spiderweb come unravelled, revealing the passage.';
                else
                    return 'I’ve cutted the way already.';
                end
            end
        end
    end,
};


labyrinth_spider_death = room {
    nam = 'Lair',
    pic = function(s)
        return 'images/labyrinth_45_spider_alive.png';
    end,
    enter = function (s)
        me():disable_all();
    end,
    dsc = function(s)
        return 'Cold hard claws close down on my throat.';
    end,
    obj = { vway('1', '{Next}', 'The_End') },
    exit = function(s)
        me():enable_all();
    end,
};


labyrinth_46 = room {
    nam = 'Big hall',
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
            return 'Big bright hall with deep shaft in the center of it. The stair alight by flickering light goes up. In the wall near there is an ugly hole, covered by spiderweb.';
        end
        return 'Hardly squeeze into the hole, I found myslef in the big miraculous hall. In the center of it there is a deep shaft, surrounded by high slim columns and wide cornice. It’s bottom is lost in the darkness.^^To the hall leads single door, which was closed by massive lattice.';
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('To cornice', 'labyrinth_47'), vroom ('Hole in the wall', 'labyrinth_42'),},
};


girl_dlg_2 = dlg{
    nam = 'Big hall',
    pic = 'images/labyrinth_46c.png';
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'On the cornice, taking off last threads of falled spiderweb, there are people stand. The girl helps them. I’ve seen her already. She was the one who was not covered totally in spider cocoon. She notice me and approaches to me:^^— Thank you, stranger! You’ve return the light and life to us. Say how we can help you?';
    end,
    obj = {
           [1] = phr('Thank you, I do not need help. I achieve the goal by myself.', '— As you say, stranger. But you could count on our support always.', [[labyrinth_46._conversation_was_good = false; poff (1, 2); walk (girl_dlg_2_end); return;]]),
           [2] = phr('I must relieve the world from The Dark Lord. Could you tell me how to get to Triple-headed Castle?', '— This is hard, but I will help you. In upper part of the Labyrinth there is a stair which leads to the open landing. There lives an Eagle, the friend of ours. I’ll tell him about you and about your noble intentions. I think he’ll agree to carry you to the Triple-Headed Castle.', [[labyrinth_46._conversation_was_good = true; poff (1, 2); walk (girl_dlg_2_end); return;]]),
          },
};


girl_dlg_2_end = room {
    nam = 'Big hall',
    enter = function (s)
        labyrinth_46._people_are_free = false;
    end,
    pic = function(s)
        return 'images/labyrinth_46c.png';
    end,
    dsc = function(s)
        return '— And now I must help my brothers.^^And after saying it the girl goes to the group of people. After getting free from the spiderweb, people leave by stair one by one.^^I remain alone in the bright hall soon.';
    end,
    obj = { vway('1', '{Next}', 'labyrinth_46') },
    exit = function (s)
        me():enable_all();
    end,
};


labyrinth_47 = room {
    nam = 'Demon’s head',
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
            return 'Karnice leads towards to huge demon’s head, carved in the hall’s wall. Long hornes, feral grin, mouth wide opened, where fire birns bright, all of it bring superstitious fear.';
        end
        if s._fire_is_burning then
            return 'Karnice leads towards to huge demon’s head, carved in the hall’s wall. Long horns, feral grin, mouth opened wide, all of it bring superstitious fear. But at the wall there is something, that is more terrifying than image above the well: there are people stand motionlessly there, packaged in cocoons, as sinister evidence of reign of evil force that lives there.';
        else
            return 'Karnice leads towards to huge demon’s head, carved in the hall’s wall. But at the wall there is something, that is more terrifying than image above the well: there are people stand motionlessly there, packaged in cocoons, as sinister evidence of reign of evil force that lives there.';
        end
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('To the carnice', 'labyrinth_46') },
--    way = { vroom ('По карнизу', 'labyrinth_46'), vroom ('TEST', 'labyrinth_75') },
    obj = { 'head', 'people' },
};


people = iobj {
    nam = 'people',
    _sharp = false,
    dsc = function (s)
        return 'There are {people} stand motionlessly there, packaged in cocoons.';
    end,
    exam = function (s)
        girl:enable();
        return 'All of them are wraped from the head to the feet in the cocoons of spiderweb. And only head of one girl who stand on the very edge is not covered by white threads. Are people live or not — it is hard to understand.';
    end,
    useit = function (s)
        return 'I try to set the people free from the spiderweb, but in vain.';
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'У меня нет меча.';
            else
                return 'I try to cut the spiderweb, but even sharp sword’s blade failed in the face of such dense spined shakles.';
            end
        end
    end,
    obj = { 'girl' },
};


girl = iobj {
    nam = 'girl',
    _wake = false,
    _story_told = false,
    dsc = function (s)
        return 'Only the head of the {girl} who stand at the very edge is not hidden under the long white threads of spiderweb.';
    end,
    exam = function (s)
        if s._wake then
            return 'The girl is totally twined by spiderweb, and only her head is left opened. Long hair fall over the shoulders, tired and exhausted eyes look at me with the hope.';
        else
            return 'The girl is totally twined by spiderweb, and only her head is left opened.';
        end
    end,
    useit = function (s)
        return 'I try to free the girl from the spiderweb, but I fail to do it.';
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'I have no jug.';
            else
                if ( jug._filled and (not girl._wake) and (not girl._story_told) ) then
                    girl._wake = true;
                    status._progress = status._progress + 5;
                    return 'I carefully toss aside chestnut girl’s hair and wet her face and lips by the cold water. Due to vivifying action of moisture, the closed eyelids flinch. With quiet moan girl raise her head. On her pretty face there is a shadow of grief and anxiety. Her amazing big eyes look at me through shroud of pain. I bring to her lips the jug with the water, and girl greedily make several gulps. Finally, she says by faint voice::^^— Oh, thank you, stranger! It seems that I did not see any living sole for ages. From the time that the evil penetrates the Labirynth...^^She close her eyes, apparently she remembers recent terrible events. Hot tear slip over her cheek. In order to calm her down I give her more water to drink.^^— Too much evil appears in the Labirynth. But there is a chance to get rid of it still.';
                end
            end
        end
        if w == sword then
            if not have (sword) then
                return 'I have no sword.';
            else
                return 'I try to cut the spiderweb, but even the sharp sword blade turn out to be weak in front of dense interlaced shackles.';
            end
        end
    end,
    talk = function (s)
        if s._wake then
            walk (girl_dlg);
            return;
        else
            return 'I can’t do this...';
        end
    end,
}:disable();


girl_dlg = dlg{
    nam = 'Demon’s head',
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
            [1] = phr('Tell me what’s happened there?', 'The girl lost in thoughts for some time. But she collect her thoughts and start her story:^^— Labirynth used to full of life. People makes it bright and warm. Everyone live in peace and inc chime.^^But here comes The Dark Lord with his warriors. To help him from the darkest corners of Labirynth crawl out fearful creatures. The forces was too far from the equal and the evil filled the Labirynth.', [[pon(1); back();]]),
            [2] = phr('Tell me, how can I clean up the Labirynth from the dark forces?', '— It’s hard to do. But if five big torches will be litten, than evil will fall back. The light will banish an evil demon from the Labirynth.', [[pon(2); back();]]),
            [3] = phr('I want to get out of here as soon as possible. How can I find the exit?', 'The girl did not answer to my question, she just close her eyes and lower her head down. Chestnut hair hide her face.', [[poff(1); poff(2); poff(3); girl._wake = false;]]),
          },
    exit = function (s, t)
        me():enable_all();
    end,
};



head = iobj {
    nam = 'image',
    _sharp = false,
    dsc = function (s)
        return 'An {image} of huge demon’s head is carvered in the wall of the hall.';
    end,
    exam = function (s)
        if labyrinth_34._fire_is_burning then
            return 'It’s an image of huge demon’s head, which is carvered in the wall of the hall. Long hornes, feral grin, mouth wide opened, where fire birns bright, all of it bring superstitious fear.';
        end
        return 'An image of huge demon’s head brings superstitious fear.';
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'I have no pole.';
            else
                if (pole._state == 1) then
                    pole._state = 3;
                    labyrinth_47._fire_is_burning = true;
                    ways(labyrinth_46):add(vroom ('Stair', 'labyrinth_32'));
                    ways(labyrinth_32):add(vroom ('Straight', 'labyrinth_46'));
                    put('niche', labyrinth_75);
                    status._progress = status._progress + 7;
                    return 'I throw burbing pole right into the mouth of stone head. Suddenly the fire flash brightly, pouring out soft light all pver the hall.';
                end
            end
        end
    end,
};


labyrinth_48 = room {
    nam = 'Labyrynth',
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
            return 'Usual corridor and the stair running down. One of the walls is occupied totally by huge ugly hole, entagled by spiderweb. It is an entrance into the spider’s burrow. In the other wall there is a niche the fire bunrs brightly within.';
        end
        return 'Usual corridor and the stair running down. One of the walls is occupied totally by huge ugly hole, entagled by spiderweb. It is an entrance into the spider’s burrow.';
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('Hole in the wall', 'labyrinth_45'), vroom ('Stair', 'labyrinth_49'),},
};


labyrinth_49 = room {
    nam = 'Labyrynth',
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
        return 'Next turning, from which was the same grey cold darknes.';
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('Stair', 'labyrinth_48'),},
};


-- ------------------------------------------------------------------------

labyrinth_60 = room {
    nam = 'Bank of underground lake',
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
            return 'The stair runs deeper and deeper, rushin to the center of the rock. Endless chain of stairs breaks finally, and I come out on the bank of underground lake. Reflecting from the icy walls and small ripples on the water surface, there are weak flashes of light play on the cave walls. May be it is a light of unknown plants, or may be inhabitants of lake light up their way... In either event this remains as one more enigma of mysterious Labyrynth.';
        else
            return 'The stair stops right near the lake, and small waves moisten stone bank. The ice glitter on the walls, creating queer patterns. There water drips slightly.';
        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('Stair', 'labyrinth_34'), vroom ('Lake', 'labyrinth_61'), },
    obj = { 'pole', 'lake' },
    exit = function (s, to)
        if to == The_End then
            return true;
        end
        if ( (to==labyrinth_61) and (not raft._ready) and (status._cargo > 20)) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


pole = iobj {
    nam = 'pole',
    _weight = 21,
    _sharp = false,
    _wrap = false,
    _oiled = false,
    _state = 0,
    dsc = function (s)
        return 'There is a {pole} lies not far from me.';
    end,
    exam = function (s)
        if s._wrap then
            if s._sharp then
                if s._oiled then
                    return 'Long pole maked from very strong thick heavy wood. One end of it is sharpen. The other end, which is wrapped by the rags of spiderweb is imbued with dense black liquid.';
                else
                    return 'Long pole maked from very strong thick heavy wood. One end of it is wrapped by rags of spiderweb, the other end is sharpen.';
                end
            else
                if s._oiled then
                    return 'Long pole maked from very strong thick heavy wood. One end of the pole, which is wrapped by the rags of spiderweb is imbued with dense black liquid.';
                else
                    return 'Long pole maked from very strong thick heavy wood. One end of the pole is wrapped by the rags of spiderweb.';
                end
            end
        else
            if s._sharp then
                return 'Long pole maked from very strong thick heavy wood. One end of it is sharpen.';
            else
                return 'Long pole maked from very strong thick heavy wood.';
            end
        end
    end,
    take = function (s)
        return 'I take pole.';
    end,
    drop = function (s)
        return 'I drop pole.';
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'I have no sword.';
            else
                if s._sharp then
                    return 'The pole is sharp from one side already.';
                else
                    s._sharp = true;
                    return 'I sharpen one side of the pole carefully.';
                end
            end
        end
        if w == flint then
            if not have (flint) then
                return 'I have no flint.';
            else
                if s._oiled then
                    if (s._state == 0) then
                        s._state = 2;
                        lifeon (pole);
                        return 'Several sparks drops on sodden by black liquid spiderweb, and on the end of the pole start to dance hot canary flame, blaze up more and more with every second.';
                    else
                        return 'The torch is burn already. There is no point to try to light it one more time.';
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
            return 'After a few seconds the pole was completely destroyed by the fire.';
        end
        if (s._state == 2) then
            s._state = 1;
        end
    end,
};


lake = iobj {
    nam = 'lake',
    dsc = function (s)
        if here() == labyrinth_60 then
            return 'Underground {lake} approaches to the very stairs of stair.';
        else
            return 'Underground {lakeозеро} is very big.';
        end
    end,
    exam = function (s)
        return 'The water in the underground lake is very cold.';
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'I have no jug.';
            else
                if jug._filled then
                    return 'The jug is filled with water already.';
                else
                    Drop (jug);
                    jug._filled = true;
                    jug._weight = 40;
                    if (status._cargo + 40 <= 100) then
                        Take (jug);
                    end
                    return 'I fill the jug with transparent cold water.';
                end
            end
        end
    end,
};


labyrinth_61 = room {
    nam = 'Underground lake',
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
            return 'The depth near the bank is not great, and I see the bottom covered with algae through the clean water. Sometimes there are fishes swim by, sparkling their scales. In the distance, slightly notable in the dark of the cave, swims huge animal, slowly turning his head on thin neck.';
        else
            return 'The depth near the bank is not great, and I see the bottom covered with algae through the clean water. Sometimes there are fishes swim by, sparkling their scales. In the distance, slightly notable in the dark of the cave, swims corpse of huge animal.';
        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('On the bank', 'labyrinth_60'), vroom ('Along the rock', 'labyrinth_63'), vroom ('To the monster', 'labyrinth_64'), vroom ('To the center of the lake', 'labyrinth_65'), vroom ('Dive', 'labyrinth_underwater'),},
    obj = { 'lake', 'water_monster', },
    exit = function (s, to)
        if to == labyrinth_64 then
            if water_monster._is_alive then
                walk (labyrinth_water_monster_death);
                return;
            end
        end
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


labyrinth_underwater = room {
    nam = 'Bottom of the underground lake',
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
        return 'I take as more air in lungs as I can and dive into the ice water. The bottom was covered by true carpet from algae. Between winded brown-green ribbons flash underwater inhabitants.';
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    way = { vroom ('Come to the surface', 'labyrinth_61'),},
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'I can’t stay under water no longer — I’m short of oxygen; all blur in front of my eyes, my head start to spining...';
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
    nam = 'Bottom of the underground lake',
    _drown = false,
    pic = function(s)
        return 'images/labyrinth_61_underwater.png';
    end,
    enter = function (s, from)
        me():disable_all();
    end,
    dsc = function(s)
        if s._drown then
            return 'I was not able to hold my breath no more. By convulsive movement I try to breathe in some air, but my lungs fill up with water. I start slowly dscend on the bottom...';
        else
            return 'Ice water chain my muscles. I was not able to resist fatigue and the lake grips me.';
        end
    end,
    obj = { vway('1', '{Next}', 'The_End') },
    exit = function(s)
        me():enable_all();
    end,
};


water_monster = iobj {
    nam = 'monster',
    _is_alive = true,
    dsc = function (s)
        return 'In cold lake water swims huge {monster}.';
    end,
    exam = function (s)
        if here() == labyrinth_63 then
            if water_monster._is_alive then
                water_monster_neck:enable();
                return 'Covered with large scales, the body of lake inhabitant shines, shimmering with green and blue. The monster predatorly look out the prey in the cold water, waving his small head. I see the long thin monster’s neck clearly from here.';
            else
                return 'Huge scaled body shimmering with green and blue. Small head on long neck lifelessly swim on the water. Sharp fins waving on the waves slightly.';
            end
        else
            if water_monster._is_alive then
                return 'Covered with large scales, the body of lake inhabitant shines, shimmering with green and blue. The monster predatorly look out the prey in the cold water, waving his small head.';
            else
                return 'Huge scaled body shimmering with green and blue. Small head on long neck lifelessly swim on the water. Sharp fins waving on the waves slightly.';
            end
        end
    end,
    used = function (s, w)
        if w == crossbow then
            if not have (crossbow) then
                return 'I have no crossbow.';
            else
                if crossbow._loaded then
                    crossbow._loaded = false;
                    return 'The arrow bounce off the scales, causing monster no harm.';
                else
                    return 'The crossbow is not charged.';
                end
            end
        end
    end,
};


water_monster_neck = iobj {
    nam = 'monster’s neck',
    dsc = function (s)
        return 'The monster has long thin {neck}.';
    end,
    exam = function (s)
        return 'Thick scales cover all body, neck and head of water creature, which makes him invulnerable to enemies. But when I examine more closely, I found out that on the neck, just right near the head, thick coverlet is not so solid.';
    end,
    used = function (s, w)
        if w == crossbow then
            if not have (crossbow) then
                return 'I have no crossbow.';
            else
                if crossbow._loaded then
                    crossbow._loaded = false;
                    water_monster._is_alive = false;
                    water_monster_neck:disable();
                    return 'Trying not to swinging on the water, I point the crossbow on unprotected monster’s neck and holding my breath release bow-string. An arrow whistle in the air and pierce precisely between scales.^^The beast shake his neck, making gurgle sounds and start to beat his fins. But soon dead head falls into the water and the monster’s body stand motionlessly.';
                else
                    return 'The crossbow is not charged.';
                end
            end
        end
    end,
}:disable();


labyrinth_63 = room {
    nam = 'Rock',
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
        return 'I move ahead slowly along the underground lake wall. Covered by moss, wet rocks shines faintly, as do ice columns, which I meet on my way. In the distance, swinging his ugly head, swimming water creature.';
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('To the bank', 'labyrinth_61'), vroom ('To the mosnter', 'labyrinth_64'), vroom ('Dive', 'labyrinth_underwater'),},
    obj = { 'lake', 'water_monster', 'water_monster_neck' },
    exit = function (s, to)
        if to == labyrinth_64 then
            if water_monster._is_alive then
                walk (labyrinth_water_monster_death);
                return;
            end
        end
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


labyrinth_64 = room {
    nam = 'Monster',
--    _monster_is_alive = true,
    _add_health_rest = 2,
    _del_health = 3,
--    _first_time = true,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_64.png';
    end,
    dsc = function(s)
        return 'Although the monster was dead, nevertheless approaching to huge scaly body makes feel uncomfortable a little.';
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('To the bank', 'labyrinth_61'), vroom ('Along the rock', 'labyrinth_63'), vroom ('To the center of the lake', 'labyrinth_65'), vroom ('Tunnel', 'labyrinth_68'), vroom ('Dive', 'labyrinth_underwater_monster'),},
    obj = { 'lake', 'water_monster' },
    exit = function (s, to)
        if ( to == labyrinth_underwater_monster and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


labyrinth_underwater_monster = room {
    nam = 'Bottom of the underground lake',
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
        return 'I draw a deep breath and go down under water. Algae covered densely all bottom and walls.';
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    obj = { 'chest_underwater' },
    way = { vroom ('Come to the surface', 'labyrinth_64'),},
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'I can’t stay under water no longer — I’m short of oxygen; all blur in front of my eyes, my head start to spining...';
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
    nam = 'chest',
    _sword_inside = true,
    _closed = true,
    _examined = false,
    _weight = 101,
    dsc = function (s)
        if s._closed then
            return 'Among the stones, entagled by underwater plants, stands an old {chest}, padded with an iron.';
        else
            return 'Among the stones, entagled by underwater plants, stands an opened {chest}.';
        end
    end,
    exam = function (s)
        if s._examined then
            return 'Big wood chest.';
        else
            labyrinth_underwater_monster._count = labyrinth_underwater_monster._count - 1;
            s._examined = true;
            return 'Big wood chest.';
        end
    end,
    useit = function (s)
        if s._closed then
            s._closed = false;
            sword:enable();
            return 'Hardly I succeeded to lift a heavy lid, padded with iron. Among the objects, which lost their form with time, there lies short sword, which miraculously avoid destructive effect of water.';
        else
            return 'The chest is open already.';
        end
    end,
    obj = { 'sword' },
};


sword = iobj {
    nam = 'sword',
    _weight = 20,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = 'The {sword} is lay on plate ';
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
            return 'Short {sword} lies in the chest.';
        else
            return 'I see a short {sword}.';
        end
    end,
    exam = function (s)
        return 'Skilfuly forged sharp short sword from silvery-gray metal';
    end,
    take = function (s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        if chest_underwater._sword_inside then
            chest_underwater._sword_inside = false;
            status._progress = status._progress + 1;
            return 'I take sword from the chest.';
        else
            return 'I take sword.';
        end
    end,
    drop = function (s)
        if here() == castle_415 and seen (knight) then
            knight._ready_to_talk = true;
            knight._attack = false;
            return true;
        end
        return 'I drop sword.';
    end,
}:disable();



labyrinth_water_monster_death = room {
    nam = 'Monster',
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
            return 'I carefully approach to the monster, trying not to disturb the water. But suddenly huge neck curve, terrible eyes darkly shines, sharp-toothed mouth opens...';
--        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    obj = { vway('1', '{Next}', 'The_End') },
    exit = function(s)
        me():enable_all();
    end,
};


labyrinth_65 = room {
    nam = 'The center of the lake',
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
            return 'I swim out to the center of the lake and stop amongst ice outgrowth, which dscend from the ceiling of huge cave and come to the water. Distant walls discerns by faint glitter.^^Nearby one of them, covered by his huge body water tunnel, swims the monster, pulling out his shin neck with horrible head.';
        else
            return 'I swim out to the center of the lake and stop amongst ice outgrowth, which dscend from the ceiling of huge cave and come to the water. Distant walls discerns by faint glitter.^^Nearby one of the distant walls swims huge body of the monster, behind of it there is a water tunnel.';
        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('To the bank', 'labyrinth_61'), vroom ('To the monster', 'labyrinth_64'), vroom ('To the spring', 'labyrinth_66'), vroom ('Dive', 'labyrinth_underwater'),},
    obj = { 'lake', 'water_monster' },
    exit = function (s, to)
        if to == labyrinth_64 then
            if water_monster._is_alive then
                walk (labyrinth_water_monster_death);
                return;
            end
        end
        if ( to == labyrinth_underwater and status._cargo>20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


labyrinth_66 = room {
    nam = 'Spring',
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
        return 'On the water start to appear oily spots, dull splash is heard, and soon I swim to the rock, from which slowly dense fluid flows on the surface of the water, rushing toward to nearby whirlpool.';
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('To the center of the lake', 'labyrinth_65'), vroom ('Down-stream', 'labyrinth_67'), vroom ('Dive', 'labyrinth_underwater'),},
    obj = { 'oil' },
    exit = function (s, to)
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};





labyrinth_68 = room {
    nam = 'Tunnel',
    _add_health_rest = 2,
    _del_health = 3,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_68.png';
    end,
    dsc = function(s)
        return 'In this part of the lake icy columns forms something like tunnel. Not a single sound from the lake can not be hear here. Calm reigned here.';
    end,
    obj = { 'school_of_fishes' },
    way = { vroom ('To the monster', 'labyrinth_64'), vroom ('To the wall', 'labyrinth_69'), vroom ('Dive', 'labyrinth_underwater'),},
    exit = function (s, to)
        if ( to == labyrinth_underwater and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


oil = iobj {
    nam = 'fluid',
    dsc = function (s)
        return 'Black oily {fluid} flows from the rock on water surface.';
    end,
    exam = function (s)
        return 'Black oily fluid with strong scent.';
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'I have no pole.';
            else
                if pole._oiled then
                    return 'I wet the end of the pole in black fluid already.';
                else
                    if pole._wrap then
                        pole._oiled = true;
                        return 'I plunge wrapped end of the pole into the center of the spring.';
                    else
                        return 'I can’t do this...';
                    end
                end
            end
        end
    end,
};


labyrinth_67 = room {
    nam = 'Whirlpool',
    pic = function(s)
        return 'images/labyrinth_67.png';
    end,
    enter = function(s)
        me():disable_all();
    end,
    dsc = function(s)
        return 'The flow become more and more stronger, and when fast water pick me up and carry me right to the terrible mouth of whirlpool, I realise that carelessly swim to this side, but it was too late — the waves hide the world of living from me...';
    end,
    obj = { vway('1', '{Next}', 'The_End') },
    exit = function (s, to)
        me():enable_all();
    end,
};


school_of_fishes = iobj {
    nam = 'school of fishes',
    _number_of_fishes = 2,
    dsc = function (s)
        return 'The {school of fishes} swim by the very surface.';
    end,
    exam = function (s)
        return 'There are several large fishes slow swim by the very surface.';
    end,
    useit = function(s)
        return 'I try to catch the fish by hands but in vain.';
    end,
    used = function (s, w)
        if w == pole then
            if not have (pole) then
                return 'I have no pole.';
            else
                if pole._sharp then
                    if school_of_fishes._number_of_fishes == 2 then
                        put('fish1', labyrinth_68);
                        Take (fish1);
                        school_of_fishes._number_of_fishes = 1;
                        return 'With quickly movement I pin down the fish on sharp pole.';
                    end
                    if school_of_fishes._number_of_fishes == 1 then
                        school_of_fishes._number_of_fishes = 0;
                        put('fish2', labyrinth_68);
                        Take (fish2);
                        objs():del(school_of_fishes);
                        return 'Быстрым th quickly movement I pin down the fish on the sharp pole, but the rest of the fishes had scared off.';
                    end
                else
                    return 'I try to stun one of the fishes by the pole, but she dodge easily.';
                end
            end
        end
    end,
};


fish1 = iobj {
    nam = 'fish',
    _weight = 7,
    dsc = function (s)
        return 'I see the {fish}.';
    end,
    exam = function (s)
        return 'The big fish with short spiny fins.';
    end,
    take = function (s)
        return 'I take the fish.';
    end,
    drop = function (s)
        return 'I drop the fish.';
    end,
    useit = function (s)
        if not have (s) then
            return 'I have no fish.';
        else
            status._health = status._health + 80;
            Drop (s);
            objs():del(s);
            return 'It was very unpleasant to eat a raw fish, but after eating it I feel much better myself.';
        end
    end,
};


fish2 = iobj {
    nam = 'fish',
    _weight = 7,
    dsc = function (s)
        return 'I see the {fish}.';
    end,
    exam = function (s)
        return 'The big fish with short spiny fins.';
    end,
    take = function (s)
        return 'I take the fish.';
    end,
    drop = function (s)
        return 'I drop the fish.';
    end,
    useit = function (s)
        if not have (s) then
            return 'I have no fish.';
        else
            status._health = status._health + 80;
            Drop (s);
            objs():del(s);
            return 'It was very unpleasant to eat a raw fish, but after eating it I feel much better myself.';
        end
    end,
};


labyrinth_69 = room {
    nam = 'Wall',
    _add_health_rest = 2,
    _del_health = 3,
    _water = true,
    pic = function(s)
        return 'images/labyrinth_69.png';
    end,
    dsc = function(s)
        return 'Icy corridor set against the wall covered with moss. On quiet water there was not even a single ripples, not a single sound can not be heard. Under the influence of full silence I myslef start to swim as quiet as possible.';
    end,
    way = { vroom ('Tunnel', 'labyrinth_68'), vroom ('Dive', 'labyrinth_70'), },
    exit = function (s, to)
        if ( to == labyrinth_70 and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


labyrinth_70 = room {
    nam = 'Bottom of the underground lake',
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
            return 'I draw a deep breath and go down under water. Long dense algae waving slightly with a movement of the water. There is a cut in the algae interlacing aroung the stones. It reveals underwater arc in the rock.';
        else
            return 'I draw a deep breath and go down under water. Long dense algae waving slightly with a movement of the water. Algae firmly interlaced around the stones, hiding underwater arc behind it.';
        end
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    way = { vroom ('Come to the surface', 'labyrinth_69'),},
    obj = { 'algae' },
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'I can’t stay under water no longer — I’m short of oxygen; all blur in front of my eyes, my head start to spining...';
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
    nam = 'algae',
    dsc = function (s)
        return 'I see the {algae}.';
    end,
    exam = function (s)
        return 'It is a true living wall. Even the small fish can not slip through it.';
    end,
    used = function (s, w)
        if w == sword then
            if not have (sword) then
                return 'I have no sword.';
            else
                if s._cutted then
                    return 'I clear out the passage already.';
                else
                    labyrinth_70._cutted = true;
                    ways(labyrinth_70):add(vroom ('Passage', 'labyrinth_72'));
                    return 'The sharp blade cuts interlaced algae easily.';
                end
            end
        end
    end,
};


labyrinth_72 = room {
    nam = 'Bottom of the underground lake',
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
        return 'Short underwater passage connects two half of huge underground lake, which separated by stone wall.';
    end,
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    way = { vroom ('Passage', 'labyrinth_70'), vroom ('Come to the surface', 'labyrinth_73'),},
    life = function(s)
        s._count = s._count + 1;
        if s._count == 2 then
            p 'I can’t stay under water no longer — I’m short of oxygen; all blur in front of my eyes, my head start to spining...';
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
    nam = 'Quiet haven',
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
            return 'I enter the water and swim to stone wall which goes vertically to water.';
        else
            return 'Quit haven, surrounded by vertical walls. Not far from the water rises flatly stone bank.';
        end
    end,
    way = { vroom ('Dive', 'labyrinth_72'), vroom ('To the bank', 'labyrinth_74'), },
    rest = function(s)
        walk (labyrinth_underwater_death);
        return;
    end,
    exit = function (s, to)
        if ( to == labyrinth_72 and status._cargo > 20 ) then
            p 'I’m not dare to swim with such big weight.';
            return false;
        end
    end,
};


labyrinth_74 = room {
    nam = 'Bank of the underground lake',
    _add_health_rest = 2,
    _del_health = 3,
    pic = function(s)
        return 'images/labyrinth_74.png';
    end,
    dsc = function(s)
        return 'Stairs of stair which leads up are approaching almost to the very water. The bank flatly goes into the lake, dissapearing in the dark water.';
    end,
    way = { vroom ('To the lake', 'labyrinth_73'), vroom ('Stair', 'labyrinth_75'), },
    rest = 'I try to relax and banish all dark thoughts.',
};


labyrinth_75 = room {
    nam = 'Labyrynth',
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
        return 'Wide corridor goes into the darkness, but the way is blocked by massive columns.';
--        return 'Широкий коридор уходил в темноту, но путь преграждали массивные колонны. В стене чернело углубление правильной формы.';
    end,
    way = { vroom ('Stair', 'labyrinth_74'), },
--    way = { vroom ('Лестница', 'labyrinth_74'), vroom ('TEST', 'labyrinth_48'), },
    rest = 'I try to relax and banish all dark thoughts.',
};


part_3_end_hints_1 = room {
    nam =  'Landing',
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
            return 'You have all needed items to continue game. You can go to the next level.';
        else
            return 'ATTENTION!^You do not have all needed items to continue game! If you leave level right now, you will not be able to finish the game!';
        end
    end,
    obj = { vway('1', '{Back}^', 'labyrinth_11'), vway('2', '{Show list of needed items}^', 'part_3_end_hints_2'), vway('3', '{Перейти на следующий уровень}', 'part_3_end'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_3_end_hints_2 = room {
    nam =  'Landing',
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
        return 'Do you ABSOLUTELY sure that you want to see the list of items?^Answer «Yes» only if you despare stuck!';
    end,
    obj = { vway('1', '{Back}^', 'labyrinth_11'), vway('2', '{Show the list of needful items}', 'part_3_end_hints_3'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_3_end_hints_3 = room {
    nam =  'Back',
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
        return 'The list of items you will need in the last part of the game:^- crossbow;^- flint;^- jug;^- sword;^- mushroom.';
    end,
    obj = { vway('1', '{Back}', 'labyrinth_11') },
    exit = function(s)
        me():enable_all();
    end,
};


part_3_end = room {
    nam =  'Landing',
    pic = 'images/labyrinth_11_no_eagle.png',
    dsc = 'I carefully climb on bird’s back. Eagle flap his wide wings and take off the landing...',
    obj = { vway('1', '{Next}', 'i401') },
    enter = function(s)
        me():disable_all();
    end,
};

