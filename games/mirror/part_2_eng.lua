i201 = room {
    nam = 'Meanwhile in Triple-headed Castle...',
    pic = 'images/movie_2.gif',
    enter = function(s)
        set_music('music/part_2.ogg');
    end,
    dsc = function(s)
        return '— What news bring to me my winged spy?^— My Master! The prisoner has escaped from goblin’s castle!^— What?! Bring him dead or alive!!';
    end,
    way = { vroom ('Back', 'part_1_end'), vroom ('Next', 'River_Bank') },
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
            status._fatigue_death_string = '...I feel myself worse with each step. Suddenly, stinging pain pierce all my body, my legs are refuse to move. I fell on the ground...';
        end
    end,
};

-- ----------------------------------------------------------------------


river = iobj {
    nam = 'river',
    dsc = function(s)
        return 'There is a fast {river} flows nearby.';
    end,
    exam = 'Crystal-clear cold water.',
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'I have no jug.';
            else
                if jug._dirty then
                    jug._dirty = false;
                    return 'I’ve clean up the jug from the covered him dirt. It was not an easy job.';
                end
                if ((not jug._dirty) and (not jug._filled)) then
                    Drop (jug);
                    jug._filled = true;
                    jug._weight = 40;
                    if (status._cargo + 40 <= 100) then
                        Take (jug);
                    end
                    return 'I’ve filled up the jug with crystal-clear water from the river.';
                end
            end
        end
    end,
};



River_Bank = room {
    nam = 'River bank',
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
            return 'I’ve open my eyes. Bright beam of sunlight, penetrating through dense leaves, had played on my face. I’ve hear tuneful singing of forest birds. Against a background of this peaceful picture, events of last night are seems a nightmare.^I’ve get up and look around. It was an early morning. The sun, starting his daily trip on heaven, had shown from the distant mountains.^Along the river stretches rather narrow sandy strip. Behind the sandy strip begin a dense forest.';
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
            return 'Hardly maked my way through dense thicket of fern, I’ve come out on a river bank. Along the river from north to south stretches a sandy strip. The river rounds over a short cliff and goes to the east, from where I’ve heard a noise of waterfall.';
        else
            return 'Fast wisted river has tun from the north. Due to this river I get there. The river rounds over a short cliff and goes to the east, from where I’ve heard a noise of waterfall.';
        end
    end,
    rest = 'Stretched out on soft grass, I had rested, not thinking about any problems.',
    way = { vroom ('North', 'River_Bank_Tree'),
            vroom ('East', 'River_Bank_Steep'),
            vroom ('Forest', 'Forest_04'),
            vroom ('River', 'main') },
    obj = { 'river' },
    exit = function (s, to)
        if to == main then
            p 'It’s dangerous to cross the river here — the flow is too fast.';
            return false;
        end
    end,
};


stones = iobj {
    nam = 'stones',
    _weight = 101,
    dsc = function(s)
        return 'A pile of rough {stones} is laying on edge of steep.';
    end,
    exam = [[Big rough stones with sharp edges.]],
    take = function()
    end,
    used = function (s, w)
        if w == rope then
            if not have (rope) then
                return 'I have no rope.';
            else
                River_Bank_Steep._rope_is_attached = true;
                Drop(rope);
                return 'I tie up rope around big stone, and throw free end of rope to the abyss.';
            end
        end
    end,
};


River_Bank_Steep = room {
    nam = 'Canyon',
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
            return 'I’m standing on steep rocky bank, not far from the deep canyon. The river fell down to bottomless abyss with fearful rattle.';
        else
            return 'As I moving, I came across more and more sharp stones, which are stick out from the sand. Sandy stripe little by little change into steep rocky bank.^Moving towards to becoming stronger the noise of waterfall, I come out to deep canyon. The river fell down to bottomless abyss with fearful rattle';
        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('West', 'River_Bank'),
            vroom ('Forest', 'Forest_04'),
            vroom ('Steep', 'River_Bank_Fall_Death') },
    obj = { 'stones' },
};


River_Bank_Fall_Death = room {
    nam = 'Canyon',
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
    dsc = 'I carelessly come to very edge of steep. Suddenly the stones are slide under my feets, I lost balance...';
    obj = { vway('1', '{Next}', 'The_End') },
};


waterfall = iobj {
    nam = 'waterfall',
    _state = 0,
    _spell_is_correct = false;
    dsc = function(s)
        if (s._state == 0) then
            return 'Just right before me roar {waterfall}, crush water into sparkling dust.';
        end
    end,
    exam = 'Solid wall of water, falling to the abyss with rattle.',
    talk = function(s)
        if s._state == 0 and s._spell_is_correct then
            waterfall._state = 6;
            ways(River_Bank_Fall):add(vroom ('Cave', 'cave_01'));
            ways(cave_01):add(vroom ('Waterfall', 'River_Bank_Fall'));
            return 'I pronounce magical words loudly. Right now river slow down it’s flow, becoming viscous. In front of me waterfall freeze, and start to stretch out in all directions. Pellicle of water tear up, as if inviting to enter...';
        end
        if not River_Bank_Fall._spell_is_known then
            return 'It’s useless to try outvoice the rattle of waterfall...';
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
                return 'I have no jug.';
            else
                if (not jug._filled) then
                    Drop (jug);
                    jug._filled = true;
                    jug._weight = 40;
                    if (status._cargo + 40 <= 100) then
                        Take (jug);
                    end
                    return 'I fill the jug with crystal river water.';
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
            ways(River_Bank_Fall):del('Cave');
            ways(cave_01):del('Waterfall');
            p '...Soon stark water come to motion, gradually flooding formed opening. The waterfall start to seethe and after a few moments the river carry it’s water to abyss as before.';
            return true;
        end
        if (s._state == 4) then
            s._state = 3;
            return;
        end
        if (s._state == 3) then
            s._state = 0;
            p 'Being unable to do something, I just stare on flaming waterfall. But the fire gradually calm down, and soon water poured from above had destroy last tongues of flame.';
            return true;
        end
        if (s._state == 2) then
            s._state = 1;
            return;
        end
        if (s._state == 1) then
            s._state = 0;
            p 'Suddenly gigantic crack cut through stark waterfall. Stone splinters fall down, in the air becoming into water.^After a few moments the river run into canyon again.';
            return true;
        end
    end,
};


waterfall_dlg = dlg{
    nam = 'Waterfall',
    pic = 'images/river_bank_fall_rope.png',
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = 'I try to recall spell:',
    obj = {
            [1] = phr('Idhamasam asana ihdamus!', 'I enunciate loudly the spell. Above waterfall became gather fog, covering the water with dense shroud.^The roar become quit, changing light crackle. When mist lift, in front of me rise huge stone lump...', [[pon(1); waterfall._state = 2; walk (River_Bank_Fall);]]),
            [2] = phr('Idhamasahim asana ihdamis!', 'I enunciate magic words. It become very hot, the water become dark, staining in black color...^...and here all waterfall flare up, like dry grass from casual spark.', [[pon(2); waterfall._state = 4; walk (River_Bank_Fall);]]),
            [3] = phr('Idhamasaham asana ihdamas!', 'I enunciate loudly magic words. Right now the river slow down it’s flow, becoming viscous. Thw waterfall freeze in front of me and start to stretch out in all directions. Pellicle of water tear up, as if inviting to enter...', [[pon(3); waterfall._state = 6; ways(River_Bank_Fall):add(vroom ('Cave', 'cave_01')); waterfall._spell_is_correct=true; walk (River_Bank_Fall);]]),
            },
    exit = function (s, t)
        me():enable_all();
    end,
};


River_Bank_Fall = room {
    nam = 'Waterfall',
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
    rest = 'I sat on a stone and rest for a while.',
    way = { vroom ('Steep', 'The_End') },
    obj = { 'waterfall', 'rope' },
    exit = function (s, to)
        ways(River_Bank_Fall):del('Cave');
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
    nam = 'Cave',
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
        ways(cave_01):del('Waterfall');
        lifeon(waterfall);
        if (from == River_Bank_Fall) then
            s._came_from_waterfall = true;
        else
            s._came_from_waterfall = false;
        end
    end,
    dsc = function(s)
        if s._came_from_waterfall then
            return 'I come through the waterfall into cave. And at once the river close in behind me, rushing to canyon with bigger force. The water break up on stones, pouring me out with splashes.';
        else
            return 'I came back to the waterfall. Sun beams, penetrating through the thickness of water, play on wet stones. The fast river blocks me exit from the cave.';
        end
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('Corridor', 'cave_02') },
    obj = { 'waterfall' },
    exit = function (s, to)
        ways(cave_01):del('Waterfall');
        lifeoff(waterfall);
    end,
};



bowl_left = iobj {
    nam = 'left bowl',
    dsc = function(s)
        if cave_02._left_fire then
            return 'The fire is burning in the {left bowl}.';
        end
        if not cave_02._left_jug then
            return 'The {left bowl} is empty.';
        end
    end,
    exam = function (s)
        if cave_02._left_fire then
            return 'The fire in burning in stone bowl, which seems forms whole entire with floor of cave.';
        else
            return 'The stone bowl, seems, forms whole entire with floor of cave.';
        end
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'I have no jug.';
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
                            return 'With quiet hiss of dying fire, the darkness flood the cave, leaving only gleams of distant torches in the end of a tunnel.';
                        else
                            return 'I put out the left fire with water from the jug.';
                        end
                    else
                        return 'I do not know what to do...';
                    end
                end
                if not cave_02._left_fire and jug._filled then
                    cave_02._left_jug = true;
                    Drop (jug);
                    cave_03._hiding_place_closed = false;
                    hiding_place:enable();
                    return 'I put the jug with water on left bowl.';
                else
                    return 'I do not know what to to...';
                end
            end
        end
        if w == flint then
            if not have (flint) then
                return 'I have no flint.';
            else
                if cave_02._left_fire then
                    return 'There is a fire in left bowl burning already.';
                end
                if not cave_02._left_jug then
                    cave_02._left_fire = true;
                    return 'Using flint, I kindle a fire in the left bowl.';
                else
                    return 'I can’t kindle a fire in the left bowl. The jug is standing there.';
                end
            end
        end
    end,
};


bowl_right = iobj {
    nam = 'right bowl',
    dsc = function(s)
        if cave_02._right_fire then
            return 'The fire is burning in the {right bowl}.';
        end
        if not cave_02._right_jug then
            return 'The {right bowl} is empty.';
        end
    end,
    exam = function (s)
        if cave_02._right_fire then
            return 'The fire in burning in stone bowl, which seems forms whole entire with floor of cave.';
        else
            return 'The stone bowl, seems, forms whole entire with floor of cave.';
        end
    end,
    used = function (s, w)
        if w == jug then
            if not have (jug) then
                return 'I have no jug.';
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
                            return 'With quiet hiss of dying fire, the darkness flood the cave, leaving only gleams of distant torches in the end of a tunnel.';
                        else
                            return 'I put out the right fire with water from the jug.';
                        end
                    else
                        return 'I do not know what to to...';
                    end
                end
                if not cave_02._right_fire and jug._filled then
                    cave_02._right_jug = true;
                    Drop (jug);
                    return 'I put the jug with water on right bowl.';
                else
                    return 'I do not know what to to...';
                end
            end
        end
        if w == flint then
            if not have (flint) then
                return 'I have no flint.';
            else
                if cave_02._right_fire then
                    return 'There is a fire in right bowl burning already.';
                end
                if not cave_02._right_jug then
                    cave_02._right_fire = true;
                    return 'Using flint, I kindle a fire in the right bowl.';
                else
                    return 'I can’t kindle a fire in the right bowl. The jug is standing there.';
                end
            end
        end
    end,
};


cave_02 = room {
    nam = 'Cave',
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
            return 'It was complete dark in this part of cave — I walk and stumble on walls constantly. My only orients was muted rattle of waterfall and reflections of distant fires in the end of corridor.';
        else
            return 'On each side of underground corridor there was columns, which was glyphic from the rock. Rough stones of cave change here into brickwork walls, which goes to depth of corridor. The fire burning near columns.';
        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('To waterfall', 'cave_01'),
            vroom ('Corridor', 'cave_03') },
    obj = { 'bowl_left', 'bowl_right' },
};


cave_03 = room {
    nam = 'Room',
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
        return 'The narrow corridor enlarge here, forming small room. Smoking lamps fill the air with acrid smoke, which make eyes water. The huge head of tiger silently grin from the opposite wall.';
    end,
    rest = 'I calmly stand some time, leaning to the cool wall.',
    way = { vroom ('Corridor', 'cave_02') },
    obj = { 'hiding_place' , 'crystal'},
};


hiding_place = iobj {
    nam = 'hiding',
    _looked = false,
    _examined = false,
    dsc = function(s)
        return 'The {hiding} showed black in center of opposite wall.';
    end,
    exam = function(s)
        s._looked = true;
        return 'The hiding is empty — someone was here before me. There are a lot of sockets in stone for objects different shapes, but they are all empty. There is nothing but dust here.';
    end,
    useit = function(s)
        if s._examined then
            return 'I carefully search hiding one more time, touching every relief. There is nothing here.';
        end
        if not s._looked then
            return 'First of all I need to examine hiding.';
        else
            crystal:enable();
            s._examined = true;
            return 'I carefully search hiding one more time, touching every relief. Something clicks, and a small crystall fall on the floor. It seems that robbers miss him somehow.';
        end
    end,
}:disable();



crystal = iobj {
    nam = 'crystal',
    _weight = 2,
    dsc = function(s)
        return 'I see {crystal}.';
    end,
    exam = function(s)
        return 'Crystal shine cold blue light. Inside of it there are white sparks flashing, like they want to get out.';
    end,
    take = function(s)
        return 'I take crystal.';
    end,
    drop = function(s)
        return 'I drop crystal.';
    end,
}:disable();



tree = iobj {
    nam = 'tree',
    _weight = 101,
    _fruit_is_present = false,
    dsc = function(s)
        return 'A {tree} stand on a river bank.';
    end,
    exam = 'High tree with unknown fruits.',
    useit = function(s)
        if s._fruit_is_present then
            return 'I have one fruit already.';
        else
            s._fruit_is_present = true;
            put('fruit', River_Bank_Tree);
            return 'Due to shaking one of the fruits fall on the sand.';
        end
    end,
};


fruit = iobj {
    nam = 'fruit',
    _weight = 8,
    dsc = function(s)
        return 'I see the {fruit}.';
    end,
    exam = function(s)
        if have (barrel) then
            return 'The heavy barrel troubled my movements — I’m unable to do anything.';
        else
            return 'Big juicy fruit.';
        end
    end,
    take = function(s)
        if here() == labyrinth_11 and labyrinth_11._eagle_is_finishing then
            p 'I try to take fruit back, but the eagle wave his wings, not allowing me to approach, and I have to step back.';
            return false;
        end
        if have (barrel) then
            p 'The heavy barrel troubled my movements — I’m unable to do anything.';
            return false;
        end
        if have (fruit) then
            return 'I have a fruit already.';
        else
            return 'I take fruit.';
        end
    end,
    drop = function(s)
        if here() == labyrinth_11 then
            labyrinth_11._fruit_is_dropped = true;
--            walk (labyrinth_11_fruit);
        end
        return 'I drop fruit.';
    end,
    useit = function(s)
        if have (fruit) then
            status._health = status._health + 20;
            Drop (fruit);
            objs():del(fruit);
            tree._fruit_is_present = false;
            return 'I eat the fruit, enjoying unusual taste.';
        else
            return 'I have no fruit.';
        end
    end,
};



River_Bank_Tree = room {
    nam = 'Tree on a river bank',
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
            return 'Hardly maked my way through dense thicket of fern, I’ve come out on a river bank. Along the river from north to south stretches a sandy strip. The tree is standing near the water. The dense forest showed black on the west.';
        else
            return 'Walking on riverside, I see high fruit tree, growing near the river, which carry it’s waters from north to south. The dense forest showed black on the west.';
        end
    end,
    rest = 'I make myself comfortable under the tree and lay some time, with my eyes closed.',
    way = { vroom ('North', 'River_Bank_Bridge'),
            vroom ('South', 'River_Bank'),
            vroom ('Forest', 'Forest_04'),
            vroom ('River', 'main') },
    obj = { 'river', 'tree' },
    exit = function (s, to)
        if to == main then
            p 'It’s dangerous to cross the river here — the flow is too fast.';
            return false;
        end
    end,
};


River_Bank_Bridge = room {
    nam = 'Bridge',
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
            return 'Hardly maked my way through dense thicket of fern, I’ve come out on a river bank. Forest approach to river close here. Hanging bridge is attached to coastal stones.';
        else
            return 'Sandy stripe stops here, giving way to dense forest, which surrounds me from north and west. Over the river, which lose it’s source between he trees, there is an old hanging bridge, weighed down to very water.';
        end
    end,
    rest = 'Stretched out on soft grass, I had rested, not thinking about any problems.',
    way = { vroom ('South', 'River_Bank_Tree'),
            vroom ('Forest', 'Forest_04'),
            vroom ('Bridge', 'Arc'),
            vroom ('River', 'main') },
    obj = { 'river' },
    exit = function (s, to)
        if to == main then
            p 'It’s dangerous to cross the river here — the flow is too fast.';
            return false;
        end
    end,
};


snake = iobj {
    nam = 'snake',
    dsc = function(s)
        if Arc._snake_is_alive then
            return 'A huge {snake} is twine around the tree.';
        else
            return 'A huge dead {snake} is twine around the tree.';
        end
    end,
    exam = 'A huge snake, which twine around the tree.',
    useit = function(s)
        if Arc._snake_is_alive then
            walk (Snake_Strike);
            return;
        else
            return 'Snake will dusturb me no more.';
        end
    end,
    used = function (s, w)
        if w == crossbow then
            if not have (crossbow) then
                return 'I have no crossbow.';
            else
                if Arc._snake_is_alive then
                    Arc._snake_is_alive = false;
                    status._progress = status._progress + 2;
--                    status._cargo = status._cargo - 1;
                    crossbow._loaded = false;
                    return 'Bowstring rings short, sending an arrow to a snake’s head. Fortunately, I not miss.';
                else
                    return 'Snake will dusturb me no more.';
                end
            end
        end
    end,
};


Snake_Strike = room {
    nam = 'Arc',
    pic = 'images/snake_strike.png',
    enter = function(s)
        me():disable_all();
    end,
    dsc = 'Monster rush to attack on me with a speed of lightning. Standing in light, in front of me arise abominable snake head, uncovering huge curved tooths...';
    obj = { vway('1', '{Next}', 'The_End') },
};



Arc = room {
    nam = 'Arc',
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
            return 'Find myself on the other side of the river, I stand in front of arched entrance, which lead into the cliff. But the way is blocked by huge snake, twisted around nearby tree.';
        else
            return 'Find myself on the other side of the river, I stand in front of arched entrance, which lead into the cliff. Huge snake twisted around nearby tree is dead.';
        end
    end,
    rest = 'I sat on a stone and rest for a while.',
    way = { vroom ('Bridge', 'River_Bank_Bridge'),
            vroom ('Arc', 'part_2_end') },
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
            return 'jug';
        else
            return 'jug of water';
        end
    end,
    _weight = 18, -- 18 empty, 40 filled
    _dirty = true,
    _filled = false;
    _powder_inside = false;
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Jug} is laying on a plate ';
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
            return 'The {jug} stand on a left bowl.';
        end
        if here() == cave_02 and cave_02._right_jug then
            return 'The {jug} stand on a right bowl.';
        end
        if not s._filled then
            return 'I see {jug}.';
        else
            return 'I see {jug of water}.';
        end
    end,
    exam = function(s)
        if s._powder_inside then
            return 'Clay jug, filled sparkling water. The water has goldish tint.';
        end
        if s._dirty then
            return 'The jug is empty and covered with a layer of dirt. It seems that it lay in the ground for many years.';
        end
        if not s._dirty and not s._filled then
            return 'Empty clay jug.';
        end
        if not s._dirty and s._filled then
            return 'Clay jug, filled with water.';
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
            return 'I take jug from the bowl.';
        end
        return 'I take jug.';
    end,
    drop = function(s)
        return 'I drop the jug.';
    end,
    useit = function(s)
        if not have (jug) then
            return 'I have no jug.';
        else
            if not jug._filled then
                return 'I don’t know how to use an empty jug.';
            else
                if jug._powder_inside then
                    return 'I’ll better keep it. This sparkling water may be useful.';
                else
                    Drop (s)
                    s._filled = false;
                    s._weight = 18;
                    Take (s);
                    if not status._drink_water_on_this_level then
                        status._health = status._health + 6;
                        status._drink_water_on_this_level = true;
                        return 'Cool water strengthen my force a little.';
                    else
                        return 'I drink crystal river water.';
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
            return 'Powder is dissolve in the water, giving it a golden tint.';
        end
    end,
    give = function(s, w)
        if w == girl then
            if have (jug) then
                if ( jug._filled and (not girl._wake) ) then
                    girl._wake = true;
                    status._progress = status._progress + 5;
                    return 'Carefully turn down chestnut hairs, I wet girl’s face and lips with cold water. From life-giving influence of moisture, girl’s eyelids shake. Girl raise her head with quiet moan. Shadow of grief and alarm lie on pretty face, big beautiful eyes watch at me through the shroud of pain. I bring the jug of water to her lips and girl make some gulps greedily. Finally, she pronounce by weak voice:^^— Oh, thank you, man! It seems, I don’t see any living soul for a very long time. It was since evil penetrate into The Labyrinth...^^She closed her eyes, apparently remembering terrible events. Hot tear roll down her cheek. To calm her down, I give her water to drink some more.^^— Too much evil appeared in The Labyrinth. But there is a chance to get rid of it still.';
                end
            else
                return 'I have no jug.';
            end
        end
    end,
};


Forest_01 = room {
    nam = 'Forest',
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/forest_01.png',
    dsc = 'Dense branches of high trees get entagled, covering the forest solid carpet. Neither a single ray of sunlight can’t penetrate here, nor light wind can’t reach here.',
    rest = 'I try to relax and banish all dark thoughts.',
    way = { vroom ('North', 'Forest_03'), vroom ('South', 'Forest_02'), vroom ('West', 'River_Bank'), vroom ('East', 'Forest_Troll_Entry') },
    obj = { 'jug' },
};


Forest_02 = room {
    nam = 'Forest',
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/forest_02.png',
    dsc = 'Making my way between the trees, I notice, that the forest become thicker there, even it’s appear to be impossible.',
    rest = 'I make myself comfortable under the tree and lay some time, with my eyes closed.',
    way = { vroom ('North', 'River_Bank_Tree'), vroom ('South', 'Forest_01'), vroom ('West', 'Forest_Tree'), vroom ('East', 'Forest_03') },
};


Forest_03 = room {
    nam = 'Forest',
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
            return 'I rush to the forest, under the shelter of trees. I heard sharp whistle of flying arrow, but green wall close up behind my back already, cutting me from cursing me troll.^^There is not a single gleam in the wall of trees. The forest looks the same in all directions, and I have no idea in which way I should go.';
        else
            return 'There is not a single gleam in the wall of trees. The forest looks the same in all directions, and I have no idea in which way I should go.';
        end
    end,
    rest = 'Stretched out on soft grass, I had rested, not thinking about any problems.',
    way = { vroom ('North', 'Forest_Spirit'), vroom ('South', 'River_Bank_Bridge'), vroom ('West', 'Forest_02'), vroom ('East', 'Forest_01') },
};


Forest_04 = room {
    nam = 'Forest',
    _add_health_rest = 6,
    _del_health = 8,
    pic = 'images/forest_04.png',
    dsc = 'The dark forest surrounds me. The similar trees as like as two peas in a pod and darkness reigned here, is not allow me to estimate walked distance..',
    rest = 'I sat on a stone and rest for a while.',
    way = { vroom ('North', 'Forest_02'), vroom ('South', 'River_Bank'), vroom ('West', 'Forest_03'), vroom ('East', 'Forest_01') },
};


spirit = iobj {
    nam = 'Spirit',
    dsc = function(s)
        return 'The {spirit} is sitting on a stone.';
    end,
    exam = function(s)
        return 'Spectral old man lean on stuff with many knots. Long greyhaired beard, look full of pride and dignity -- all of these force to filled with respect to this etheric being.';
    end,
    talk = function(s)
--        if Forest_Spirit._spirit_angry or Forest_Spirit._story_told then
        if Forest_Spirit._spirit_angry then
            return 'It’s useless — he is just ignoring me.';
        else
            walk (spirit_dlg);
            return;
        end
    end,
    accept = function(s, w)
        if Forest_Spirit._spirit_angry then
            return 'It’s useless — he is just ignoring me.';
        else
            if w == scroll then
                Drop (scroll);
                objs():del(scroll);
                walk (spirit_dlg_scroll);
                return;
            end
            p '— I don’t need your gifts, Keeper.';
            return false;
        end
    end,
};


Forest_Spirit = room {
    nam = 'Spirit',
    _add_health_rest = 6,
    _del_health = 8,
    _spirit_angry = false;
    _story_told = false;
    _story_told_now = false;
    pic = 'images/forest_spirit.png',
    dsc = function(s)
        if s._story_told and s._story_told_now then
            return 'I stand on small clearing, which is warm by rays of sun. There are a lot of boulders on this clearing. Spirit is sitting on one of them and motionlessly looking in my direction. Image of Spirit is strange and unusual in this forest, but he is not scaring, command mine devout respect.';
        else
            return 'Making my way through the wreathed branches of old trees, finally I come out on a small clearing, which is warmed by rays of sun. There are a lot of boulders on this clearing. Spirit is sitting on one of them and motionlessly looking in my direction. Image of Spirit is strange and unusual in this forest, but he is not scaring, command mine devout respect.';
        end
    end,
    rest = 'I try to relax and banish all dark thoughts.',
    obj = { 'spirit' },
    way = { vroom ('Forest', 'Forest_02') },
    exit = function (s, to)
        if s._spirit_angry then
            p 'It was very thoughtless to spoil relationship with Spirit... The Dark Lord can not be beaten by alone...';
            walk (The_End);
            return;
        end
        if s._story_told_now then
            s._sory_told_now = false;
        end
    end,
};


spirit_dlg = dlg{
    nam = 'Spirit',
    pic = 'images/forest_spirit.png',
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = nil,
    obj = {
            [1] = phr('I’m lost. Could you tell me, good Spirit, how can I come to river?', '— As soon as you enter the forest, Keeper, you should turn in direction, from what the cold come to us.', [[poff(3);pon(1);me():enable_all();back();]]),
            [2] = phr('My memory is foggy and I need to know my past. Help me, oh, Wizard!', nil, [[poff(3); walk (spirit_dlg_tale_1); return;]]),
            [3] = phr('I need help... oh... what could do this spirit, though...', 'Nothing changes in look of the Spirit, not a single sound fly by on forest clearing. But I felt that I should not say this words...', [[Forest_Spirit._spirit_angry = true; poff (1,2,3); me():enable_all(); return;]]),
            },
};

spirit_dlg_tale_1 = dlg{
    nam = 'Spirit',
    pic = 'images/forest_spirit_tale_1.png',
    dsc = '— I knew, Keeper, what you will come. I tell you all that I know.^^I was suprised by addressnig of Spirit to me, but I keep listening. Now the blue sphere appear in front of him, in which start to gleam vague images.^^— Legends warned about great troubles and about a man, who will win the evil. The choise is defined: it will be you who will stop The Dark Lord.',
    obj = {
            [1] = phr('But how can I do this?', nil, [[poff(1); walk (spirit_dlg_tale_2); return;]]),
          },
};


spirit_dlg_tale_2 = room {
    nam = 'Spirit',
    dsc = '— You have power, but you are not ready to resistance yet. YOU ARE THE KEEPER OF THE MIRROR, DWELLING-PLACE OF DEMON OF WAR. Only you can operate this powerful weapon of humans.',
    pic = 'images/forest_spirit_tale_1.png',
    obj = { vway('1', '{Next}', 'spirit_dlg_tale_3') },
};


spirit_dlg_tale_3 = room {
    nam = 'Spirit',
    pic = 'images/forest_spirit_tale_2.png',
    dsc = 'In sphere start to appear real images.^^— Horde of orcs and goblins, under The Dark Lord control, attack the country. Everything what they encounter, turns to ruins. People stand up on defend their lands, but forces was not equal.',
    obj = { vway('1', '{Next}', 'spirit_dlg_tale_4') },
};


spirit_dlg_tale_4 = room {
    nam = 'Spirit',
    pic = 'images/forest_spirit_tale_3.png',
    dsc = 'And then they decide resort to the last mean — to The Mirror.^After the defeat of Knight of Darkness, The Mirror was in The Labyrynth. So, troop of peoples make it’s way there. Keeper must summon the Demon of War.',
    obj = { vway('1', '{Next}', 'spirit_dlg_tale_5') },
};


spirit_dlg_tale_5 = room {
    nam = 'Spirit',
    pic = 'images/forest_spirit_tale_4.png',
    dsc = 'But peoples was late — troop of goblins rushed into The Labyrynth. The Mirror was delivered in Triple-headed Castle — castle of The Dark Lord. And Keeper was prisoned in rocky fortress.',
    obj = { vway('1', '{Next}', 'spirit_dlg_tale_6') },
};


spirit_dlg_tale_6 = room {
    nam = 'Spirit',
    pic = 'images/forest_spirit_tale_1.png',
    dsc = '— Without Keeper The Mirror is dead. The Dark Lord needs YOU.',
    obj = { vway('1', '{Next}', 'spirit_dlg_tale_7') },
};


spirit_dlg_tale_7 = room {
    nam = 'Spirit',
--    _add_progress = 10,
    pic = 'images/forest_spirit.png',
    dsc = '— And you must stop The Dark Lord. Make your way to Triple-headed Castle and summon The Demon of War.^There is only one way to Triple-headed Castle — through the Labyrynth. I can’t go with you, but I’ll give you a leaf, which possess magic force. I hope it helps you.^Right before me appear swarm of green fireflies. Fires moves faster and faster. After then swarm flashes brightly and dissaper, leaving a green leaf instead of it. Leaf smoothly fall in my hand.',
    obj = { vway('1', '{Next}', 'Forest_Spirit') },
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
    nam = 'Spirit',
    pic = 'images/forest_spirit.png',
    enter = function (s, t)
        me():disable_all();
    end,
    dsc = 'I hold out scroll to the Spirit. Old parchment slip out of my hand and hang in the air.^^— Runes point on hiding-place, hidden under the waterfall. Ask the river to stop it’s flow and you will get to the cave.',
    obj = {
            [1] = phr('Ask the river? In what way?', 'Just say «Idhamasaham asana ihdamas», and the river will obey to you.', [[River_Bank_Fall._spell_is_known = true; me():enable_all(); poff(1)]]),
          },
};



leaf = iobj {
    nam = 'leaf',
    _weight = 0,
    dsc = function(s)
        return 'I see {leaf}.';
    end,
    exam = function(s)
        return 'Brightly green velvety leaf, slightly shining.';
    end,
    take = function(s)
        return 'I take leaf.';
    end,
    drop = function(s)
        return 'I drop leaf.';
    end,
    give = function(s,w)
        if w == forest_master and Forest_Tree._tree_is_humble then
            Drop(leaf);
            objs():del(leaf);
            Forest_Tree._boulder_is_lifted = true;
            scroll:enable();
            rope:enable();
            return '— Thank you, wanderer, you restore my forces. Probably that which lay under this boulder, will help you.';
        end
    end,
};


boulder_forest = iobj {
    nam = 'boulder',
    dsc = function(s)
        if Forest_Tree._boulder_is_lifted then
            return 'Huge {boulder} near the tree is lifted.';
        else
            return 'There is a huge {boulder} laying near the tree.';
        end
    end,
    exam = function(s)
        return 'Huge stone, covered with moss.';
    end,
    take = function(s)
        p 'I try to lift boulder, but in vain.';
        return false;
    end,
};


scroll = iobj {
    nam = 'scroll',
    _weight = 0,
    _lay_under_boulder = true,
    dsc = function(s)
        if s._lay_under_boulder then
            return 'There is a {scroll} laying under the boulder.';
        else
            return 'I see {scroll}.';
        end
    end,
    exam = function(s)
        return 'Small parchment scroll, choppy because of old age. I can barely define ancients runes on it.';
    end,
    take = function(s)
        s._lay_under_boulder = false;
        return 'I take scroll from the ground.';
    end,
    drop = function(s)
        return 'I drop scroll.';
    end,
}:disable();


rope = iobj {
    nam = 'rope',
    _weight = 29,
    _lay_under_boulder = true,
    dsc = function(s)
        if here() == Forest_Tree and s._lay_under_boulder then
            return 'There is a {rope} laying under the boulder.';
        end
        if River_Bank_Steep._rope_is_attached then
            if here() == River_Bank_Steep then
                return '{Rope} surely tie to stones.';
            else
                return '{Rope} hang from above.';
            end
        end
        return 'I see {rope}.';
    end,
    exam = function(s)
        return 'Firm long rope, winded from fibre of some sort of plant.';
    end,
    take = function(s)
        if here() == River_Bank_Fall then
            p 'I can’t untie rope from here.';
            return false;
        end
        if River_Bank_Steep._rope_is_attached then
            River_Bank_Steep._rope_is_attached = false;
            return 'I untie rope from stones.';
        end
        s._lay_under_boulder = false;
        return 'I take rope.';
    end,
    drop = function(s)
        return 'I drop rope.';
    end,
    useit = function (s)
        if River_Bank_Steep._rope_is_attached then
            if here() == River_Bank_Steep then
                p 'Using rope I dscend on small platform, miraculously holding on vertical wall of steep.^';
                walk (River_Bank_Fall);
                return;
            end
            if here() == River_Bank_Fall then
                p 'I climb up using a rope.^';
                walk (River_Bank_Steep);
                return;
            end
        end
        return 'In what way?';
    end,
}:disable();


forest_master = iobj {
    nam = 'tree',
    dsc = function(s)
        return 'In the middle of forest clearing there is a huge {tree} standing.';
    end,
    exam = function(s)
        if Forest_Tree._tree_is_dead then
            return 'The tree is dead — there are only several dry leafs lonely swings on lifeless branches.';
        else
            return 'Mighty trunk with thick wrinkled bark, strong long branches, rough look — all of this says about strength and power of master of the forest.';
        end
    end,
    used = function(s,w)
        if w == jug and jug._filled then
            if not have (jug) then
                return 'I have no jug.';
            else
                Drop (jug);
                jug._filled = false;
                jug._weight = 18;
                Take (jug);
                if jug._powder_inside then
                    jug._powder_inside = false;
                    p 'Dry wood instantly soak up sparkling water. Suddenly forest giant shakes; it’s branches, filling with life, stretch to the sun.^';
                    walk (Forest_Tree_Awake);
                    return;
                else
                    return 'I spill water under the tree. Nothing happens.';
                end
            end
        end
    end,
    talk = function(s)
        if Forest_Tree._tree_is_dead then
            return 'The tree is dead.';
        else
            if Forest_Tree._tree_is_angry then
                return 'The tree is not respoinding.';
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
    nam = 'Gigantic tree',
    pic = 'images/forest_tree_green.png',
    enter = function (s, t)
        me():disable_all();
    end,
    obj = {
            [1] = phr('This forest clearing will be more roomy, if this clumsy tree will be uprooted.', 'My words has sound in stark air. I have strange feeling that all around me freeze in alarming waiting. When exertion is fall down, leaves of huge tree unpleasenlty start to make nosie.', [[poff(1,2); Forest_Tree._tree_is_angry = true; me():enable_all();]]),
            [2] = phr('The Dark Lord injure this magical forest as well. If there is somebody who could help me to stop his misdeeds...', nil, [[poff(1,2); walk (tree_dlg_2); return;]]),
          },
};


tree_dlg_2 = room{
    nam = 'Gigantic tree',
    pic = 'images/forest_tree_green.png',
    dsc = function(s)
        return 'Disturbing silence was the answer on my proclamation. It seems that forest estimate sincerity of my words. But at last crow of gigantic tree animatedly start to make noise, strong trunk start to move...';
    end,
    obj = { vway('1', '{Next}', 'Forest_Tree') },
    exit = function(s)
        Forest_Tree._tree_is_humble = true;
        me():enable_all();
        return '...and in front of me appears Master of Magical Forest himself. Under the forest clearing spread low voice of the tree:^— I heard, wanderer, that you want to release country from rule of The Dark Lord? This is noble, but very uneasy deal. I’ll help you as I can. What do you need?';
    end,
};


tree_dlg_3 = dlg{
    nam = 'Gigantic tree',
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
            [1] = phr('Tell me, what is this forest?', '— This is biggest and most beautiful forest at all. First trees settle in this mountains from immemorial time; our roots penetrate to fertile soil, our crowns become home for many liveing creatures. For a thousands years we live in peace. There were difficult times, of couse, but  the forest always win. But now... Now the forest is near the death. Hordes of trolls, orcs and goblins destroy trees, in forest settle some eveil beasts. Troop of orcs found me, and if you, wanderer, have not show up, forest loose it’s master.^Save the forest! Stop The Dark Lord!'),
            [2] = phr('I’m lost. how can I go to the river?', '— Oh yes... My forest is huge. But it’s not very difficult to get out of this clearing. As soon as you enter the forest, go there Sun is going when finishing it’s day path.', [[pon(2); back();]]),
            [3] = phr('I have to be ready to meet the enemy. Have you any weapon for me?', '— I have something for you, wanderer, under this boulder, but I’m too weak to lift it still.',[[poff(3); back();]]),
          },
};



Forest_Tree_Awake = room {
    nam = 'Gigantic tree',
    pic = 'images/forest_tree_green.png',
    dsc = 'In a few moments over the clearing quietly make noise green crown of revived tree.',
    enter = function(s)
        status._progress = status._progress + 3;
        Forest_Tree._tree_is_dead = false;
--        Forest_Tree._tree_is_just_awake = true;
        me():disable_all();
    end,
    obj = { vway('1', '{Next}', 'Forest_Tree') },
    exit = function (s, to)
        me():enable_all();
    end,
};



Forest_Tree = room {
    nam = 'Gigantic tree',
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
            return 'Solid wall of trees step aside, and I come out on a small forest clearing. In the middle of clearing beside the huge boulder which covered moss, rise above gigantic tree, scattered it’s dry branches over entire clearing.^It seems that this is a forest master itself — so majestic it looks.';
        else
            if s._tree_is_humble then
                if s._came_from_forest then
                    return 'Maked my way through solid wall of trees, I’ve come out on forest clearing, in the middle of it rise Master of this magical forest. Dense tree crown nicely make noise, reassuring after pressure of dark thicket.';
                else
                    return 'I stand at small forest clearing, in the middle of it rise Master of this magical forest. Dense tree crown nicely make noise, reassuring after pressure of dark thicket.';
                end
            else
                if s._came_from_forest then
                    return 'Finally dark forest wall step aside, and I come out on a small forest clearing, in the middle of it beside a single boulder rises huge tree. Dense crown of majestic forest master nicely make noise, making imppression that tree is speaking.';
                else
--                    return 'Исполинское дерево, раскинуло свои зелёные ветви над всей поляной.^Казалось, что это сам хозяин леса — так величественен был его вид.';
                    return 'I stand at small forest clearing, in the middle of it beside a single boulder, rises huge tree. Dense crown of majestic forest master nicely make noise, making impression that tree is speaking.';
                end
            end
        end
    end,
    rest = 'I make myself comfortable under the tree and lay some time, with my eyes closed.',
    way = { vroom ('Forest', 'Forest_01') },
    obj = { 'forest_master', 'boulder_forest', 'scroll', 'rope' },
    exit = function (s, to)
--        if s._tree_is_just_awake then
--            s._tree_is_just_awake = false;
--        end
        if s._tree_is_angry then
            p 'It was very thoughtless — spoil relationships with a Master of Forest. The Dark Lord cannot be beaten by one man...';
            walk (The_End);
            return;
        end
    end,
};


Forest_Troll_Entry = room {
    nam = 'Forest',
    pic = 'images/forest_01.png',
    enter = function(s)
        me():disable_all();
    end,
    dsc = 'I alomst lost hope to get out from this dense forest, when all at once I notice a road paved with cracked stones.^Hoping that somebdoy help me to get out of here, I go along the road.',
    obj = { vway('1', '{Next}', 'Forest_Troll_Village') },
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
                    p 'The troll is seating on a threshold.';
                    return true;
                end
                if troll._state == TROLL_PATROLLING then
                    p 'House owner roaming not far. He notice me and point armed crossbow on me.';
                    return true;
                end
            end
            if troll._state == TROLL_SEATING then
                troll._state = TROLL_HIDING;
                troll:disable();
                p 'Troll notice me, then jump up and hide in a house yelling.';
                return true;
            end
            if troll._state == TROLL_HIDING then
                troll._state = TROLL_PREPARING;
                troll:enable();
                p 'I think a few moment, trying to figure that troll’s yelling means. Suddenly house door fly open, and troll start to arm his crossbow while running at me.';
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
                p 'Carefully step over troll laying on the floor, I run out from shed and stop to take a deep breath.^^Suddenly in a shed rattle something, heard out almost savage roar...';
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
                p 'I heard fast steps from outside. The door harshly opens wide: on a threshold stand a troll, stunnly looking at me.';
                return true;
            end
            if troll._state == TROLL_SHED_ENTER then
                if Forest_Troll_Shed._box_is_broken then
                    troll._state = TROLL_SHED_DISABLED;
                    p 'With a force, warming with anger, I drop box on a troll’s head. Troll collapse on earthern floor.';
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
    nam = 'troll',
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
        return 'I see {troll}.';
    end,
    exam = function(s)
        if s._state == TROLL_FROZEN then
            return 'Troll looks like skilfully processed lump of ice, miraculously saved under the rays of sun.';
        else
            return 'It’s a troll.';
        end
    end,
    take = function(s)
    end,
    talk = function(s)
        if s._state == TROLL_SEATING then
            return true;
        end
        if s._state == TROLL_FROZEN then
            return 'It’s useless to talk with an ice troll statue...';
        end
        return 'Troll just growl at answer only...';
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
                return 'I have no box.';
            end
        end
        if w == crystal then
            if have (crystal) then
                if troll._state == TROLL_PATROLLING then
                    Drop(crystal);
                    objs():del(crystal);
                    troll._state = TROLL_FROZEN;
                    return 'Crystal blows up by blue cloud, instantly wrapping up troll from head to foot. Burning ice wind fly by over the clearing...^^A moment after clod dissapear. Ice statue stand on a clearing, still squeezing a crossbow in arms.';
                end
            else
                return 'I have no crystal.';
            end
        end
    end,
    useit = function(s)
        if troll._state == TROLL_FROZEN then
            troll._state = TROLL_SMASHED;
            troll:disable();
            crossbow:enable();
            return 'I hit statue. Fragile ice cracks up and fall down on a ground in a shapeless pile.';
        end
    end
};


crossbow = iobj {
    nam = 'crossbow',
    _weight = 36,
    _loaded = true,
    _charged = false,
    _on_what = false,
    dsc = function (s)
        if s._on_what then
            local v = '{Crossbow} is laying on a plate ';
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
            return '{Crossbow} hitched up on a stones and thrown out with a handle hanging out.';
        end
        if here() == castle_402 and ledge._ready then
            return '{Crossbow} hooked up on a stones of upper level.';
        end
        return 'I see {crossbow}.';
    end,
    exam = function(s)
        if s._charged then
            return 'Powerfull crossbow, charged with hook and rope.';
        end
        if s._loaded then
            return 'Powerfull crossbow, charged with a short arrow.';
        else
            return 'Powerfull crossbow with a comfortable butt. Now it’s discharged. Without an arrow it’s completely useless.';
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
        return 'I take a crossbow.';
    end,
    drop = function(s)
        return 'I drop a crossbow.';
    end,
    used = function (s, w)
        if w == arrow then
            if have (arrow) then
                if s._loaded then
                    return 'Crossbow is already charged.';
                else
                    Drop(arrow);
                    objs():del(arrow);
                    s._loaded = true;
                    return ' I charge a crossbow with an arrow.';
                end
            else
                return 'I have no arrow.';
            end
        end
        if w == rope_hook then
            if s._charged then
                return 'I already charge crossbow with an iron hook.';
            else
                if here() == castle_413 then
                    s._charged = true;
                    return 'I charge a crossbow with an iron hook.';
                else
                    return 'I can charge a crossbow with an iron hook, but right now there is no need in it. I must find a place more appropriate for it.';
                end
            end
        end
    end,
    useit = function (s)
        if here() == castle_401 and ledge._ready then
            walk (castle_401_end);
            return;
        else
            return 'I can not do it.';
        end
    end,
}:disable();



Forest_Troll_Village = room {
    nam = 'Troll’s house',
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
            return 'After some time from the trees appears small house, surrounded household buildings.';
        else
            if troll._state == TROLL_FROZEN or troll._state == TROLL_SMASHED then
                return 'I come out on courtyard, which was flooded by sunlight.';
            else
                return 'I stand near small house, surrounded household buildings.';
            end
        end
    end,
    rest = 'Stretched out on soft grass, I had rested, not thinking about any problems.',
    way = { vroom ('Forest', 'Forest_03'), vroom ('Shed', 'Forest_Troll_Shed')  },
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
    nam = 'house',
    dsc = function(s)
        return 'On a forest clearing stands {house}, surrounded household buildings.';
    end,
    exam = function (s)
        troll_house_window:enable();
        return 'Single-storey yellow-brick house with strong oak door and small glass window.';
    end,
    useit = function (s, w)
        return 'I have no wish to enter the house of troll.';
    end,
    obj = { 'troll_house_window' },
};


troll_house_window = iobj {
    nam = 'window',
    _arrow_present = true,
    dsc = function(s)
        if Forest_Troll_Village._window_smashed then
            return 'In troll’s house there is a small {window}. It’s broken.';
        else
            return 'In troll’s house there is a small glass {window}.';
        end
    end,
    exam = function (s)
        if Forest_Troll_Village._window_smashed then
            arrow:enable();
            if troll_house_window._arrow_present then
                return 'Instead of window gape hole with sharp edges, through which household goods be seen vaguely. On window-sill lay short arrow.';
            else
                return 'Instead of window gape hole with sharp edges, through which household goods be seen vaguely..';
            end
        else
            return 'Window with muddy glass, which does not allow to look inside.';
        end
    end,
    useit = function (s)
        if troll._state == TROLL_HIDING then
            return true;
        end
        Forest_Troll_Village._window_smashed = true;
        return 'Splinters of glass splash out, revealing black hole in a place of window.';
    end,
    used = function (s, w)
        if w == fruit then
            if troll._state == TROLL_HIDING then
                return true;
            end
            if have (fruit) then
                  Forest_Troll_Village._window_smashed = true;
                  Drop (fruit);
                  return 'Splinters of glass splash out, revealing black hole in a place of window.';
            else
                return 'I have no fruit.';
            end
        end
        if w == crossbow then
            if not have (crossbow) then
                return 'I have no crossbow.';
            else
                Forest_Troll_Village._window_smashed = true;
                return 'Swing my arm, I hit a glass by butt of crossbow. Splinters of glass splash out, revealing black hole in a place of window.';
            end
        end
    end,
    obj = { 'arrow' },
}:disable();


arrow = iobj {
    nam = 'arrow',
    _weight = 0,
    dsc = function(s)
        return 'I see an {arrow}.';
    end,
    exam = function(s)
        return 'Sharp arrow for crossbow.';
    end,
    take = function (s)
        troll_house_window._arrow_present = false;
        return 'I take an arrow.';
    end,
    drop = function (s)
        return 'I drop an arrow.';
    end
}:disable();



Forest_Troll_Village_Death = room {
    nam = 'Troll’s house',
    pic = function(s)
        return 'images/forest_village_troll_firing.png';
    end,
    enter = function(s)
--        ACTION_TEXT = nil;
    end,
    dsc = function(s)
        return '...Troll shoulder crossbow, briefly whistle flying arrow...';
    end,
    obj = { vway('1', '{Next}', 'The_End') },
};


hole = iobj {
    nam = 'hole',
    dsc = function(s)
        return 'In the wall, right near the floor, there is a small {hole}.';
    end,
    exam = function(s)
        if have (barrel) then
            return 'The heavy barrel troubled my movements — I’m unable to do anything.';
        end
        if Forest_Troll_Shed._powder_in_a_hole then
            powder:enable();
            return 'The hole was full of garbage, among of it I notice small leather bag, filled some sort of powder.';
        else
            return 'There was nothing in the hole but the garbage.';
        end
    end,
    obj = { 'powder' },
}:disable();


powder = iobj {
    nam = 'powder',
    _weight = 8,
    dsc = function(s)
        if Forest_Troll_Shed._powder_in_a_hole then
            return 'In the hole is laying small {bag with the powder}.';
        end
        return 'I see {bag with powder}.';
    end,
    exam = function(s)
        return 'Bag with a powder of goldish color powder.';
    end,
    take = function(s)
        if Forest_Troll_Shed._powder_in_a_hole then
            Forest_Troll_Shed._powder_in_a_hole = false;
            return 'I take the bag from the hole.';
        else
            return 'I take the bag with powder.';
        end
    end,
    drop = function(s)
        return 'I drop the bag with powder.';
    end,
}:disable();


barrel = iobj {
    nam = 'barrel',
    _weight = 97,
    dsc = function(s)
        return 'There is a {barrel} on the floor.';
    end,
    exam = function(s)
        return 'Huge wooden barrel, seems empty.';
    end,
    take = function(s)
        if Forest_Troll_Shed._barrel_is_moved then
            p 'I don’t want to carry heavy barrel any more.';
            return false;
        end
        if Forest_Troll_Shed._box_is_on_barrel then
            p 'Too heavy!';
            return false;
        else
            if status._cargo + 97 <= 100 then
                Forest_Troll_Shed._barrel_is_moved = true;
                hole:enable();
                return 'I lift the barrel.';
            else
                p 'Too heavy!';
                return false;
            end
        end
    end,
    drop = function(s)
        return 'I drop the barrel on the floor.';
    end,
    useit = function (s)
        if have (barrel) then
            return 'The heavy barrel troubled my movements — I’m unable to do anything.';
        end
        if troll._state == TROLL_SHED_DISABLED then
            return true;
        end
        if troll._state == TROLL_FROZEN or troll._state == TROLL_SMASHED then
            return 'As hard as I can I hit the barrel: dull boom from which seems make the walls tremble, fill the narrow room.';
        end
        if troll._state == TROLL_SHED_ENTER then
            return 'As hard as I can I hit the barrel: dull boom from which seems make the walls tremble, fill the narrow room.';
        else
            Forest_Troll_Shed._troll_enter = true;
            return 'As hard as I can I hit the barrel: dull boom from which seems make the walls tremble, fill the narrow room.';
        end
    end,
};


box = iobj {
    nam = 'box',
    _weight = 48,
    dsc = function(s)
        if Forest_Troll_Shed._box_is_on_barrel then
            return 'The {box} is laying on barrel.';
        else
            return 'There is a {box} laying on the floor.';
        end
    end,
    exam = function(s)
        if have (barrel) then
            return 'The heavy barrel troubled my movements — I’m unable to do anything.';
        else
            return 'Firmly knocked togeher heavy box.';
        end
    end,
    take = function(s)
        if have (barrel) then
            p 'The heavy barrel troubled my movements — I’m unable to do anything.';
            return false;
        end
        if Forest_Troll_Shed._box_is_on_barrel then
            if status._cargo + 48 <= 100 then
                Forest_Troll_Shed._box_is_on_barrel = false;
                return 'I take the box from the barrel.';
            else
                p 'Too heavy!';
                return false;
            end
        else
            return 'I take the box from the floor.';
        end
    end,
    drop = function(s)
        return 'I drop the box on the floor.';
    end,
};


Forest_Troll_Shed = room {
    nam = 'Shed',
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
    rest = 'I calmly stand some time, leaning to the cool wall.',
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
            return 'Using absence of house owner, I fast race through into tumbledown building, and prudently close door, look out in small window, which was cut through by ceiling.^After a few moments in a cortyard appear the troll, charging a crossbow while running. It seems he become furious because of my dissapearing. Troll raoming for a while on the cortyard and then seat on a front steps, tensely peer in forest.^I look out. Rays of sun, peentrating through lattice window, hardly light narrow room, throwing long shadows from many objects.^In the corner is standing huge barrel, on a top of it laying box, that seems to be heavy. There is a shelf above the door. All is covered with a dense layer of dust; spider’s web is hang down from the ceiling.';
        else
            return 'I stand in a shed. Rays of sun, peentrating through lattice window, hardly light narrow room, throwing long shadows from many objects.^In the corner is standing huge barrel, on a top of it laying box, that seems to be heavy. There is a shelf above the door. All is covered with a dense layer of dust; spider’s web is hang down from the ceiling.';
        end
    end,
    way = { vroom ('Outside', 'Forest_Troll_Village') },
    obj = { 'barrel', 'box', 'hole', 'troll' },
    exit = function (s, to)
        if troll._state == TROLL_SHED_ENTER then
            p 'Troll is blocking my way...';
            return false;
        end
        if have (barrel) then
            p 'The heavy barrel troubled my movements — I’m unable to do anything.';
            return false;
        end
        if not (to == Forest_Troll_Shed_Death) then
            if have (box) then
                p 'I don’t need the box. I have to left it here.';
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
    nam = 'Shed',
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
            return 'Troll jump on growling pointing crossbow at me. I try to dodge, but in narrowness of four walls it was uneasy...';
        else
            return '...Troll throw up crossbow. I try to dodge, but in narrowness of four walls it was uneasy...';
        end
    end,
    obj = { vway('1', '{Next}', 'The_End') },
};


part_2_end_hints_1 = room {
    nam =  'Arc',
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
             return 'You have all needed objects to pass over the game. You can go on next level.';
        else
             return 'ATTENTION!^You don’t have all needed objects! If you leave this level, you will stuck and will not be able to complete the game!';
        end
    end,
    obj = { vway('1', '{Back}^', 'Arc'), vway('2', '{Show list of needed objects}^', 'part_2_end_hints_2'), vway('3', '{Go on next level}', 'part_2_end'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_2_end_hints_2 = room {
    nam =  'Arc',
    pic = 'images/arc_snake_dead.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Are you ABSOLUTELY sure, that you want to see list of needed objects?^Answer «Yes» ONLY in case if you desparately stuck!';
    end,
    obj = { vway('1', '{Back}^', 'Arc'), vway('2', '{Show list of needed objects}', 'part_2_end_hints_3'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_2_end_hints_3 = room {
    nam =  'Arc',
    pic = 'images/arc_snake_dead.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'List of objects you need in next parts of game:^- crossbow;^- arrow (in case if crossbow is discharged);^- flint;^- jug;^- rope;^- fruit.';
    end,
    obj = { vway('1', '{Back}', 'Arc') },
    exit = function(s)
        me():enable_all();
    end,
};



part_2_end = room {
    nam =  'Arc',
    pic = 'images/arc_snake_dead.png',
    dsc = 'I walk by the dead snake and enter the cave...',
    obj = { vway('1', '{Next}', 'i301') },
    enter = function(s)
        me():disable_all();
    end,
};
