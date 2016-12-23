-- ’

i101 = room {
    nam = 'Preface',
    pic = 'images/movie_101.gif',
    enter = function(s)
        set_music('music/movie.ogg');
    end,
    dsc = 'Early one dark and rainy morning, the human army stood motionless in the wide fields...',
    way = { vroom ('Back', 'main2'),
            vroom ('Next', 'i102') }
};


i102 = room {
    nam = 'Preface',
    pic = 'images/movie_102.gif',
    dsc = '...facing a decisive battle against a cruel and threatening enemy.',
    way = { vroom ('Back', 'i101'),
            vroom ('Next', 'i103') }
};


i103 = room {
    nam = 'Preface',
    pic = 'images/movie_103.gif',
    dsc = 'Hordes of orcs and goblins, led by a Knight of Darkness and his Dark Mage, had attacked their country.',
    way = { vroom ('Back', 'i102'),
            vroom ('Next', 'i104') }
};


i104 = room {
    nam = 'Preface',
    pic = 'images/movie_104.gif',
    dsc = '— Move forward, my loyal soldiers! Everyone, who dares to oppose me, must be killed!',
    way = { vroom ('Back', 'i103'),
            vroom ('Next', 'i105') }
};


i105 = room {
    nam = 'Preface',
    pic = 'images/movie_105.png',
    dsc = 'And so the bloody battle started.',
    way = { vroom ('Back', 'i104'),
            vroom ('Next', 'i106') }
};


i106 = room {
    nam = 'Preface',
    pic = 'images/movie_106.gif',
    dsc = 'The gruesome slaughter was to go on for many hours.',
    way = { vroom ('Back', 'i105'),
            vroom ('Next', 'i107') }
};


i107 = room {
    nam = 'Preface',
    pic = 'images/movie_107.gif',
    dsc = 'All forces were sent into battle.',
    way = { vroom ('Back', 'i106'),
            vroom ('Next', 'i108') }
};


i108 = room {
    nam = 'Preface',
    pic = 'images/movie_108.png',
    dsc = 'But the humans were so few, and soon the victory of the dark forces was close...',
    way = { vroom ('Back', 'i107'),
            vroom ('Next', 'i109') }
};


i109 = room {
    nam = 'Preface',
    pic = 'images/movie_109.gif',
    dsc = 'Finally, the humans decided to use their last hope — The Magic Mirror. The Demon of War was summoned from the Mirror, using the life energy of many warriors.',
    way = { vroom ('Back', 'i108'),
            vroom ('Next', 'i110') }
};


i110 = room {
    nam = 'Preface',
    pic = 'images/movie_110.gif',
    dsc = 'The Demon rushed over the battlefield like a tornado, and the Knight of Darkness was defeated.',
    way = { vroom ('Back', 'i109'),
            vroom ('Next', 'i111') }
};


i111 = room {
    nam = 'Preface',
    pic = 'images/movie_111.gif',
    dsc = 'So, all enemies were destroyed. Many brave warriors had fallen in this battle. They gave their lives for the peace and freedom of those who lived.',
    way = { vroom ('Back', 'i110'),
            vroom ('Next', 'i112') }
};


i112 = room {
    nam = 'Preface',
    pic = 'images/movie_112.png',
    dsc = 'But the Black Mage, he had fled from the battlefield.^^Two hundred years have passed, and now the Black Mage has returned. He calls himself The Dark Lord now. He gathers enormous hordes of goblins and orcs again. These vile forces have captured the country quickly, and the humans are unable to stop them...',
    way = { vroom ('Back', 'i111'),
            vroom ('Next', 'Cell_entry') }
};


-- ----------------------------------------------------------------------

door = iobj {
    nam = 'door',
    dsc = function(s)
        return 'There is an iron bar cell {door} in darkness.';
    end,
    exam = function(s)
        if (chain._chain_on) then
            return 'I can barely see the outline of the door in the dim light, because the chain doesn’t allow me to reach even the middle of the cell.';
        else
            if Cell._cell_locked then
                lock:enable();
            end
            return 'Solid iron bar cell door with a massive lock on it.';
        end
    end,
    obj = { 'lock' },
};


lock = iobj {
    nam = 'lock',
    dsc = function(s)
        if Cell._cell_locked then
            return 'The door is locked with an iron {lock}.';
        else
            return '{The lock} is open.';
        end
    end,
    exam = 'Massive iron lock. Rusty, but solid...',
    used = function (s, w)
        if w == rod and Cell._cell_locked then
            if have (rod) then
                Cell._cell_locked = false;
                Drop(rod);
                rod:disable();
                lifeon(guardian);
                return 'I put the rod in the keyhole and turn it. The rod hooks into a hidden mechanism inside. Something clicks and... the door is open.';
            else
                return 'I have no rod.';
            end
        end
    end,
}:disable();


plate = iobj {
    nam = 'plate',
    _weight = 6,
    dsc = function(s)
        return 'There is a {plate} on the floor.';
    end,
    exam = function (s)
        return 'A rough clay plate, filled with something like grease with a most unpleasant scent.';
    end,
    take = function(s)
        return 'I took the plate.';
    end,
    drop = function(s)
        if chain._chain_on then
            p 'The plate can be useful to me later.';
            return false;
        else
            plate:disable();
            shard:enable();
            return 'The plate have hited the stone floor and smashes into pieces.';
        end
    end,
    useit = function (s)
        if have (plate) then
            return 'I don’t want to eat this. It looks too nasty.';
        else
            return 'I have no plate.';
        end
    end,
};


shard = iobj {
    nam = 'shard',
    _weight = 2,
    dsc = function(s)
        return 'There is a {shard} on the floor.';
    end,
    exam = function (s)
        return 'A sharp shard from the clay plate.';
    end,
    take = function(s)
        return 'I took the shard.';
    end,
    drop = function(s)
        return 'I dropped shard.';
    end,
    useit = function (s)
        return 'It’s very sharp.';
    end,
}:disable();


window = iobj {
    nam = 'window',
    dsc = function(s)
        return 'The illusive light coming out from the little {window}.';
    end,
    exam = function(s)
        if (chain._chain_on) then
            return 'I can barely see only main contours in twilight, because chain is not allowing me to reach even the middle of the cell.';
        else
             if Cell._rod_attached then
                 rod:enable();
                 return 'Just a small hole in a wall, protected with a thin bars. One of the bars is come to loose.';
             else
                 return 'Just a small hole in a wall, protected with a thin bars. One of the bars is missing.';
             end
        end
    end,
    obj = { 'rod' },
};


rod = iobj {
    nam = 'rod',
    _weight = 20,
    dsc = function(s)
        if Cell._rod_attached then
            return 'One of the {bars} in window lattice is come to loose.';
        else
            return 'There is a {rod} on the floor.';
        end
    end,
    exam = 'Thin metal rod.',
    take = function(s)
        if Cell._rod_attached then
            p 'The rod is come to loose, but I can’t pull it over.';
            return false;
        else
            p 'I’ve taked the rod.';
            return;
        end
    end,
    drop = function(s)
        return 'I’ve drop the rod on the floor.';
    end,
    used = function (s, w)
        if w == shard then
            if have (shard) then
                Cell._rod_attached = false;
                Drop(shard);
                shard:disable();
                return 'I’ve sway the rock by using a shard. Rod dropped on the floor just a second before clay shard had crumbled in my hands.';
            else
                return 'I have no shard.';
            end
        end
    end,
}: disable();


chain = iobj {
    nam = 'chain',
    _weight = 43,
    _chain_on = true,
    _chain_attached = true,
    dsc = function(s)
        if chain._chain_on then
            return 'I’m fettering by {chain} to the wall.';
        elseif chain._chain_attached then
            return '{Chain} is lying on the floor. One end of a chain is attached to the wall.';
        else
            if here() == Dark_Room then
                if Dark_Room._chain_on_hook then
                    return '{Chain} is hanging on a beam. The end of a chain is attached to the hook.';
                end
                if Dark_Room._chain_on_beam then
                    return '{Chain} is hanging on a beam.';
                end
            end
            return 'I see {chain}.';
        end
    end,
    exam = 'Long rusty chain with a manacles and heavy iron ball.',
    take = function(s)
        if s._chain_attached then
            p 'It’s impossible — chain is attached to the wall.';
            return false;
        else
            if here() == Dark_Room then
                if Dark_Room._chain_on_lid_opened then
                    Dark_Room._chain_on_beam = false;
                    Dark_Room._chain_on_hook = false;
                    Dark_Room._chain_on_lid_opened = false;
                    Dark_Room._chain_off_lid_opened = true;
                    return 'I’ve take a chain from the beam.';
                end
                if Dark_Room._chain_on_beam then
                    Dark_Room._chain_on_beam = false;
                    Dark_Room._chain_on_hook = false;
                    return 'I’ve take a chain from the beam.';
                end
                if Dark_Room._chain_on_hook then
                    Dark_Room._chain_on_beam = false;
                    Dark_Room._chain_on_hook = false;
                    return 'I’ve take a chain from the beam.';
                end
                return 'I’ve take a chain.';
            end
            return 'I’ve take a chain.';
        end
    end,
    drop = function(s)
        return 'I drop a chain.';
    end,
    useit = function(s)
        if here() == Dark_Room then
            if Dark_Room._chain_on_lid_opened then
                return 'I’ve opened a manhole already.';
            end
            if Dark_Room._chain_on_hook then
                Dark_Room._chain_on_lid_opened = true;
                ways(Dark_Room):add(vroom ('Manhole', 'Tunnel'));
                return 'Hang down on a chain by all my _weight, I’ve put in action my simple mechanism. Stone have yielded, and on reveal a dark manhole under itself.';
            end
        end
        return 'I’ve try to tear the chain in vain.';
    end,
    used = function (s, w)
        if w == plate then
            if have (plate) then
                if s._chain_on then
                    s._chain_on = false;
                    return 'I’ve overcome disgust, draw some fat from the plate and grease my hands. Poorly fitted manacles have slided to the floor slightly.';
                else
                    return 'I’ve free from the chain already. I don’t want to soil my hands anymore.';
                end
            else
                return 'I’ve no plate.';
            end
        end
        if w == rod and s._chain_attached then
            if have (rod) then
                s._chain_attached = false;
                return 'I’ve unbend cramps which strengthen the chain to the wall.';
            else
                return 'I’ve no rod.';
            end
        end
    end,
};


GOING = 0;
ENTER = 1;
BEAT  = 2;
DEAD  = 3;

guardian = iobj {
    nam = 'goblin',
    _weight = 101,
    dsc = function(s)
        local st={
                  'There is a {goblin} standing at the door.',
                  '{Goblin} is very angry.',
                  '{Goblin} is lying at the floor.'
                 }
        return st[s._state];
    end,
    exam = 'Disgusting dirty goblin, wearing old chain armor an horned helmet.',
    life = function(s)
        if not s._state then
            s._state = GOING
            return
        end
        if s._state == GOING then
            put('guardian');
            s._state = ENTER; -- стражник зашёл
            p 'Before I’ve had time to do anything, just in front of me have appeared strong goblin, sternly drawing his weapon.';
            return true;
        end
        if s._state == ENTER then
            s._state = BEAT; -- стражник бъёт
            p 'Have not waiting my attack, goblin have waved his sword...';
            return true;
        end
        lifeoff(s);
        me():disable_all();
        p 'Stab was fast and strong. Everything went dark before my eyes...';
        walk (The_End);
        return;
    end,
    take = function(s)
    end,
    talk = function(s)
        if guardian._state == DEAD then
            return 'It’s useless. Goblin is unconscious.';
        else
            return 'Goblin have growl in response only...';
        end
    end,
    used = function(s, w)
        if w == chain then
            if have (chain) then
                if (s._state ~= DEAD) then
                    s._state = DEAD; -- стражник в ауте
                    lifeoff(s);
                    return 'Lifted my arm, I’ve hit goblin on a horned helmet as hard as I can. Goblin have not expected this obviously. Guardian have fell on the floor unconscious.';
                else
                    return 'There is no need to hit goblin once more. He will not bother me any more.';
                end
            else
                return 'I’ve no chain.';
            end
        end
    end
};


guardians = iobj {
    nam = 'goblins',
    life = function(s)
        if not s._state then
            s._state = GOING
            p 'I’ve heard suddenly tramping, clanking of weapons and swearing of guardians from below. On stairs I’ve seen gleams of torches.';
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
    dsc = [[...Cold stone walls. The freezing wind has turned me cold to the bone...^
             ...Bright light of torch, brought straight to my face, blinding me. I hear voices, screaming, they must be wanting something from me... Unable to keep up with events, I almost pass out...^
             ...Two goblins grasp my hands and drag me along many cold corridors...]];
    enter = function(s)
        set_music('music/part_1.ogg');
    end,
    obj = { vway('1', '{Next}', 'Cell') },
    exit = function (s, t)
        me().obj:add(status);
        actions_init();
        lifeon(status);
        status._fatigue_death_string = 'My long journey along gloomy castle corridors has taken my last strength.^I fall down on the cold floor, unconscious.';
    end,
};


Cell = room {
    nam = 'Cell',
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
            return [[The voices and sounds of footsteps faded slowly. I was left in utter darkness.^
                     I open my eyes. Thank heavens! It must have been just a dream. However, I quickly realize that reality seems to catch up with my nightmare!^
                     I’m lying on the floor, chained to a rough stone wall. A damp cell, drowning in the twilight of night. From the small window, faint light enters the cell, just barely revealing the dark silhouette of a door in the darkness.^
                     Stretching my numb hands, I stir a plate next to me, and try to remember how I got here. Very strange, but the past seems a mystery to me.]];
        else
            return 'I have entered the cell. Cold twilight have remined me about unpleasant time, which I have spend chained here.';
        end
    end,
    rest = function(s)
        if s._cell_locked then
            return 'I’ve make myself comfortable anyhow on cold floor, and have spend several hours in troubled doze.';
        else
            p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
            walk (Guardians_Death);
            return;
        end
    end,
    rested = 'I don’t want to lie on this dirty and cold floor anymore.',
    obj = { 'door', 'plate', 'window', 'chain', 'shard' },
    way = { vroom('Door', 'Entryway') },
    exit = function (s, to)
        if to == The_End then
           return;
        end
        if s._cell_locked then
            p 'The door is locked.';
            return false;
        end
        if guardian._state ~= DEAD then
            return false;
        end
    end,
};


flint = iobj {
    nam = 'flint',
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
        return 'I see a {flint}.';
    end,
    exam = 'Just a small flint.',
    take = function(s)
        if s._on_what then
            ref(s._on_what)._occupied = false;
            s._on_what = false;
        end
        if have (barrel) then
            p 'Heavy barrel is not allowing me to act.';
            return false;
        end
        chest._flint_inside = false;
        return 'I’ve take a flint.';
    end,
    drop = function(s)
        if here() == Dark_Room and not Dark_Room._light_on then
            p 'If I’ll drop flint here, I’ll can’t find it later in the dark.';
            return false;
        end
        return 'I’ve drop a flint.';
    end,
}:disable();


chest = iobj {
    nam = 'chest',
    _weight = 101,
    _flint_inside = true;
    dsc = function(s)
        return 'There is a half-opened metal-covered {chest} in the corner.';
    end,
    exam = function(s)
       if s._flint_inside then
           flint:enable();
           return 'An old metal-covered box with a half-rotten planks. Inside of it there was a lot of garbage, just like everywhere in a castle. Among the garbage I’ve noticed almost whole flint.';
       else
           return 'An old metal-covered box with a half-rotten planks. Inside of it there was a lot of garbage, just like everywhere in a castle.';
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
            return 'There is no need to hide anymore — the danger gone away.';
        end
    end,
    obj = { 'flint' }
};


Entryway = room {
    _guardians_alert = true,
    _del_health = 2,
    nam =  'Entryway',
    pic = 'images/entryway.png',
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
        walk (Guardians_Death);
        return;
    end,
    dsc = function(s)
        if s._guardians_alert then
            return 'Behind the lattice door I’ve found entryway, there was spiral stairs which lead up and down.';
        else
            return 'An entryway. Serpentine stairs lead up and down. I can see a black hole — enter to my cell.';
        end
    end,
    enter = function(s)
        if s._guardians_alert then
            lifeon(guardians);
        end
    end,
    obj = { 'chest' },
    way = { vroom ('Down', 'Prison_Bottom'), 'Cell', vroom ('Up', 'Prison_Top') },
    exit = function(s, to)
        if to == Entryway_Death then
            lifeoff(guardians);
            return
        end
        if s._guardians_alert then
            return false;
        end
    end,
};


Guardians_quarrel = room {
    nam =  'Entryway',
    pic = 'images/guardians_quarrel.png',
--    _add_progress = 3,
    dsc = [[Have not wasting a second, I’ve rush to an old box, have opened a lid and have hided in it. And that was just in time...^
             Sleepy goblins have run out on an entryway, waving their weapons and torches. It seems that my escape was a surprise for them, and they have rushed about, not knowing what to do.^
             — Miserable spawn!!! Disgusting creatures!!! You should gather leeches in swamp instead of serving to the Dark Lord! — speaked in saw-tones head of the guards. His voice fly over the stone corridors.^
             — Well... We are... We... You see...^
             — You just don’t know what HE will do to you for this! You’ll be rot in dungeons of Triple-headed Castle! How do you allow to escape a scoundrel just a three hours before the Dark Lord’s arrival? Shut down all entrances immediately!^
             Frightened goblins have runed to carry out an order of their head.^
             When echo of guardians steps have gone, I’ve get out from a chest cautiously.]],
    enter = function(s)
        status._progress = status._progress + 3; -- because disable_all disable status
        me():disable_all();
    end,
--    way = { vroom ('Next', 'Entryway') },
    obj = { vway('1', '{Next}', 'Entryway') },
    exit = function(s)
        me():enable_all();
    end,
};


Entryway_Death = room {
    nam = 'Entryway',
    pic = 'images/entryway_guardians.png',
    dsc = 'I’ve lingered a little bit on a stairs and have come across with running up giblins. Their spiteful state have not promised nothing good.';
    enter = function(s)
        me():disable_all();
    end,
    obj = { vway('1', '{Next}', 'The_End') },
};



observe_area = iobj {
    nam = 'platform',
    dsc = function(s)
        return 'I am standing on {platform}.';
    end,
    exam = function(s)
        if Prison_Top._torch_present then
            torch:enable();
            return 'It seems nobody have been there for a long time: the floor have covered by layer of garbage and dirt, there was a lot of old dark leaves in corners, bringed there by wind. There is an old lonely torch lying not far from stairs...';
        else
            return 'It seems nobody have been there for a long time: the floor have covered by layer of garbage and dirt, there was a lot of old dark leaves in corners, bringed there by wind.';
        end
    end,
    obj = { 'torch' },
};


Prison_Top = room {
    nam = 'Observe area',
    _del_health = 2,
    _add_progress = 5,
    _torch_present = true,
    pic = 'images/prison_top.png',
    dsc = [[Fearing of goblins appear, I have cautiously ascend up on spiral stairs, which leads me to wide observe area.^
             I have stopped, affected by open view. Right in front of me on houndreds of miles have lied gloomy country, surrounded by chain of distant mountains. Triple-headed Castle have rised threatenly on dark clouds background.^
             It was quite strange, but my look have returned to Castle constantly. Castle have drawn my attention, have aroused odd fear in me. I have remembered something. Something about that Castle. But my vision have dissapeared, and I have not been able to remember when I have seen this dark stronghold before.]],
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
        walk (Guardians_Death);
        return;
    end,
    obj = { 'observe_area' },
    way = { vroom ('Down', 'Entryway') },
};


door_out = iobj {
    nam = 'door',
    dsc = function(s)
        return 'There is a big wooden {door}.';
    end,
    exam = function(s)
       return 'Solid oak door, covered with an iron. It seems it leads to the castle exit.';
    end,
    useit = function(s)
        p 'Behind the door there have been a long corridor, there was an exit from the castle in the end of it.^But a group of giblins have blocked my way. And I have remembered coversation, which I have overhear on entryway.';
        walk (Guardians_Death);
        return;
    end,
    used = function(s, w)
        if w == chain then
            p 'Iron ball strike have call loud echo in the depth of corridor.^But goblin guardians have appeared in front of me just right now, and I have regret that I have done...';
            walk (Guardians_Enter);
            return;
        end
    end
};



Prison_Bottom = room {
    nam = 'Corridor',
    _del_health = 2,
    pic = 'images/prison_bottom.png',
    dsc = 'Faint light of several torches barely have drive away the dark of corridor, and have cast a tremble shadows on almost closed door and on leading up stairs.',
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
        walk (Guardians_Death);
        return;
    end,
    obj = { 'door_out' },
    way = { vroom ('Door', 'The_End'), vroom ('Up', 'Entryway'), vroom ('Dark passage', 'Dark_Room') },
    exit = function(s, to)
        if to == The_End then
            p 'Behind the door there have been a long corridor, there was an exit from the castle in the end of it.^But a group of giblins have blocked my way. And I have remembered coversation, which I have overhear on entryway.';
            walk (Guardians_Enter);
            return;
        end
    end,
};


torch = iobj {
    nam = 'torch',
    _weight = 10,
    dsc = function(s)
        if here() == Dark_Room then
            return 'An old {torch} is hanging on a wall.';
        else
            return 'An old {torch} is lying near the stair.';
        end
    end,
    exam = 'An old torch.',
    take = function(s)
        Prison_Top._torch_present = false;
        if here() == Dark_Room then
            if seen(flint) then
                p 'If I’ll drop flint here, I’ll can’t find it later in the dark.';
                return false;
            end
            if Dark_Room._chain_on_lid_opened or Dark_Room._chain_off_lid_opened then
                ways(Dark_Room):del('Manhole');
            end
            beam:disable();
            hook:disable();
            Dark_Room._light_on = false;
            ways(Prison_Bottom):del('Passage');
            ways(Prison_Bottom):add(vroom ('Dark passage', 'Dark_Room'));
            return 'I’ve take torch from the wall and have blow out it. The room have lost in the dark.';
        else
            return 'I’ve take a torch.';
        end
    end,
    drop = function(s)
        if here() == Dark_Room and not Dark_Room._light_on then
            p 'If I’ll drop torch here, I’ll can’t find it later.';
            return false;
        else
            p 'I’ve drop a torch.';
            return;
        end
    end,
    used = function (s, w)
        if w == flint and have (flint) and have (torch) then
            if here() == Dark_Room then
                if Dark_Room._chain_on_lid_opened or Dark_Room._chain_off_lid_opened then
                    ways(Dark_Room):add(vroom ('Manhole', 'Tunnel'));
                end
                Dark_Room._light_on = true;
                ways(Prison_Bottom):del('Dark passage');
                ways(Prison_Bottom):add(vroom ('Passage', 'Dark_Room'));
                Drop (torch);
                objs():del(torch);
                beam:enable();
                hook:enable();
                p 'I’ve hit flint by rough wall stone, have light the torch and fix it near the door.^The room have not been used for a long time. There was a lot of evidence of it: moss-grown stones, the web hanging from the ceiling and moist floor.';
                walk (here());
                return;
            else
                p 'There is no need to do it here.';
                return false;
            end
        end
    end,
}:disable();


Dark_Room = room {
    nam = 'Room',
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
             return 'I’ve take several steps and have end up in total darkness. There was just one thing that I can discern — narrow stripe of faint light, coming ot of corridor.';
        else
            if Dark_Room._chain_on_lid_opened then
                return 'I’ve take several steps and have end up in deserted room which was highlighted by torch. There was a dark opened manhole in the corner.';
            else
                return 'I’ve take several steps and have end up in deserted room which was highlighted by torch.';
            end
        end
    end,
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
        walk (Guardians_Death);
        return;
    end,
    obj = { 'beam', 'hook' },
    way = { vroom ('Corridor', 'Prison_Bottom') },
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
    nam = 'beam',
    dsc = function(s)
        if Dark_Room._light_on then
            return ' The room was almost empty. The {beam} in the corner was the one thing only have break monotony of bare walls.';
        end
    end,
    exam = 'Rough-hew log, driven into wall.',
    used = function (s, w)
        if w == chain then
            if Dark_Room._chain_off_lid_opened then
                return 'There is no need to do it once more. I’ve already opened the manhole.';
            end
            if not Dark_Room._chain_on_beam then
                Dark_Room._chain_on_beam = true;
                Drop (chain);
                return 'I’ve swing my arm and have throw chain over wooden beam.';
            else
                return 'Chain is hanging on a beam already.';
            end
        end
    end,
}:disable();


hook = iobj {
    nam = 'hook',
    dsc = function(s)
        if Dark_Room._light_on then
            return ' and iron {hook}, driven into the floor.';
        end
    end,
    exam = 'Rusy iron hook is stick out from the floor.',
    take = function(s)
        p 'I’ve grasp the hook by both hands and have try to pull it out from the floor. But all of my tries have lost in vain. I’ve just raise a little the stone, in which hook was drove in.';
        return false;
    end,
    used = function (s, w)
        if w == chain then
            if Dark_Room._chain_off_lid_opened then
                return 'There is no need to do it once more. I’ve already opened the manhole.';
            end
            if Dark_Room._chain_on_hook then
                return 'I’ve hitched up chain on a hook already.';
            end
            if Dark_Room._chain_on_beam then
                Dark_Room._chain_on_hook = true;
                return 'I’ve grapple a hook on the chain, hanging from the beam.';
            else
                return 'Using chain I’ve try to pull out a stone with a hook from the floor, but stone was too heavy. All my tries have lost in vain.';
            end
        end
    end,
}:disable();


Tunnel = room {
    nam = 'Tunnel',
    pic = 'images/tunnel.png',
    _del_health = 2,
    enter = function (s, from)
        if from == Dark_Room then
            status._health = status._health - 10;
            return 'I’ve jump to dark manhole, but it was a little thoughtless, because I have to fly enough. I have hit my elbow, but I all seems good as for the rest.^Narrow corridor with hanging webs have lead to the darkness in front of me. Corridor walls have fall in some places, and there was a piles of beaten stones on the floor.';
        else
            return 'I’ve return to beginning of underground passage. Narrow corridor with hanging webs have lead to the darkness behind me. Corridor walls have fall in some places, and there was a piles of beaten stones on the floor.';
        end
    end,
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
        walk (Guardians_Death);
        return;
    end,
    way = { vroom ('Tunnel', 'Tunnel_End') },
};


Tunnel_End = room {
    nam = 'Tunnel',
    _del_health = 2,
    pic = 'images/tunnel_end.png',
    dsc = 'A small room in the end of underground corridor. Tumbledown walls and web threads have outlined sharp by faint light, which shine through semi-filled up exit.',
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
        walk (Guardians_Death);
        return;
    end,
    way = { vroom ('Tunnel', 'Tunnel'), vroom ('Up', 'Tunnel_Out') },
};


Tunnel_Out = room {
    nam = 'Tunnel exit',
    pic = 'images/tunnel_out.png',
    _del_health = 2,
    _add_progress = 2,
    dsc = 'I have leaved a gloomy corridor and have stayed, enjoying gusts of fresh air.^Tunnel have exit on the bank of fast mountain river. The river have break its waves about big boulders with a noise, have meander and have dissapear in a dark forest. I have seen a castle behind, which have been bloody sunrise alight.',
    way = { vroom ('Down', 'Tunnel_End'), vroom ('River', 'part_1_end') },
    rest = function(s)
        p '...May be I’ve should not loose vigilance in such danger place. But my fatigue have prevailed over me, and make me defensless before dangerous enemy...';
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
                p 'Trying to leave this gloomy and unsafe place, I have dive in a rapid river. Heavy chain have locked my movements and have drug me down. I have no forces to struggle with the rapid flow...';
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
    nam = 'Tunnel exit',
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
             return 'You have all needed objects for next level of play. You can pass.';
        else
             return 'ATTENTION!^You do not have all needed objects for next level! If you will leave current level now, you will be UNABLE to complete the game!';
        end
    end,
    obj = { vway('1', '{Back}^', 'Tunnel_Out'), vway('2', '{Show the list of needed objects}^', 'part_1_end_hints_2'), vway('3', '{Go to next level}', 'part_1_end'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_1_end_hints_2 = room {
    nam = 'Tunnel exit',
    pic = 'images/tunnel_out.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Are you ABSOLUTELEY sure, that you want to see the list of objects, which you need to complete the game??^Please, choose «Yes» ONLY if you desperately stuck!';
    end,
    obj = { vway('1', '{Back}^', 'Tunnel_Out'), vway('2', '{Show the list of needed objects}', 'part_1_end_hints_3'),},
    exit = function(s)
        me():enable_all();
    end,
};


part_1_end_hints_3 = room {
    nam = 'Tunnel exit',
    pic = 'images/tunnel_out.png',
    enter = function (s)
        me():disable_all();
    end,
    dsc = function (s)
        return 'Here are the objects which you will need:^- flint.';
    end,
    obj = { vway('1', '{Back}', 'Tunnel_Out') },
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
    obj = { vway('1', '{Next}', 'The_End') },
};


Guardians_Enter = room {
    nam = 'Corridor',
    pic = 'images/guardians_enter.png',
    enter = function (s)
        me():disable_all();
    end,
    obj = { vway('1', '{Next}', 'The_End') },
};


The_End = room {
    nam = 'Game over',
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
    nam =  'Tunnel exit',
    pic = 'images/tunnel_out.png',
    dsc = 'Trying to leave this gloomy and unsafe place, I have dived in a rapid river and have give my fate into the arms of providence...',
    obj = { vway('1', '{Next}', 'i201') },
    enter = function(s)
        me():disable_all();
    end,
};
