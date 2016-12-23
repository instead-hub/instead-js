------------- now got inside!!! -----------------------
napil = obj {
	nam = 'rasp',
	dsc = 'There\'s a {rasp} lying under the gates.',
	inv = 'A rusty thing...',
	tak = 'I took the rasp.',
	use = function(s, w)
		if w == 'knife' and not knife._oster then
			knife._oster = true;
			return 'I\'m sharpening the knife... Now it\'s sharp!';
		elseif w == 'gun' and not gun._obrez then
			if here() == wside or here() == sside then
				return 'There are people around here!';
			end
			gun._obrez = true;
			return 'I took a seat and sawed off the shotgun barells.';
		else
			return 'No, sawing is useless here...';
		end
	end
};

eside = room {
	pic = 'gfx/eside.png',
	nam = 'behind the institute',
	dsc = [[ I am at the back wall of the institute building. There's a railway here.]],
	act = function(s,w)
		if w == 1 then
			return 'The machine guns are turned to the south side of the institute perimeter. It\'s better to stay far from them.';
		end
		if w == 2 then
			return 'The gates are iron made. And they are locked from the inside.';
		end
	end,
	obj = {
	vobj(1,'gun towers', 'The railway entrance is guarded by the {towers} with machine guns...'),
	vobj(2,'the gates', 'The rails flow near the big iron {gates}. It seems they are used for supply.'),	
	'napil',
	},
	exit = function(s, t)
		if t == 'sside' then
			return 'The machine guns on the south side make me nervous. Too risky.'
				, false
		end
	end,
	enter = function(s, f)
		if f == 'onwall' then
			-- end of episode 1
			inmycar = nil;
			deepforest = nil;
			road = nil;
			forest = nil;
			home = nil;
			shop = nil;
			village = nil;
			kpp = nil;
			inst = nil;
			onwall = nil;
			backwall = nil;
			guydlg = nil;
			shop2 = nil;
			shopdlg = nil;
			guarddlg = nil;
			set_music("mus/ice.s3m");
		end
	end,
	way = {'nside','sside'},
};

card = obj {
	nam = 'pass',
	inv = [[It's a someone's pass - an electronic smartcard with a photo of some heavy-metal guy. The label says: Alexey Podkovin — Level: 3, Category: The Matter. Hmmm...]],
};

alienwear = obj {
	xnam = {'denim jacket', 'red jacket', 'overcoat', 'jacket', 'white jacket', 
	'coat', 'black leather jacket', 'sport jacket',},
	xinv = {
		'A cold clothes for this season, but has a certain style!',
		'Nice look on snowy background.',
		'A long coat - some kind of retro!',
		'I\'m the Terminator!',
		'Make peace, not war!',
		'It suits me',
		'"And nothing else matters!.."',
		'There were days I liked mountaineering!',
	},
	nam = function(s)
		return s.xnam[s._num];
	end,
	inv = function(s)
		if s._num == 7 and not have('card') then
			inv():add('card');
			return 'I\'ve examined the pockets of the leather jacket and found some card.';
		end
		return s.xinv[s._num];
	end,
};

garderob = obj {
	nam = 'wardrobe',
	dsc = 'There is a {wardrobe} with visitors outerwear on the right.',
	act = function(s, w)
		if have('mywear') or have('alienwear') then
			return 'There are too much people here. I don\'t think I can change clothes without being noticed.';
		elseif tonumber(w) and tonumber(w) > 0 and tonumber(w) <= 8 then
			if not me()._walked then
				return 'It will be too noticeable if I do it now...';
			end
			alienwear._num = w;
			inv():add('alienwear');
			ref(s.obj[w]):disable();
			me()._walked = false;
			inv():add('gun');
			return 'Feeling confidently I take someone else\'s clothes and put it on... I take my shotgun with me.';
		else
			return 'I should make a decision...';
		end
	end,
	used = function(s, w)
		if w == 'mywear' then
			garderob.obj:add('mywear');
			inv():del('mywear');
			inv():del('gun');
			return 'I take off my quilted jacket. I need to leave my shotgun in it.';
		end
		if w == 'alienwear' then
			local v = alienwear._num;
			ref(s.obj[v]):enable();
			inv():del('alienwear');
			inv():del('gun');
			return 'I put someone else\'s clothes back to wardrobe. I hide the shotgun in my quilted jacket.';
		end
	end,
	obj = {
		vobj(1,'denim jacket','{A denim jacket}.'),
		vobj(2,'red jacket','{A red-coloured jacket}.'),
		vobj(3,'overcoat','{An overcoat}.'),
		vobj(4,'terminator jacket', "{A jacket} with \"I\'ll be back\"."),
		vobj(5,'jacket with daisies', "{A white jacket} with daisies."),
		vobj(6,'coat', "{A wool jacket}."),
		vobj(7,'leather jacket','{A cool black leather jacket}.'),
		vobj(8,'sport jacket', "{An orange sport jacket}."),
	}
};
portrait = obj {
	nam = 'portraits',
	dsc = 'There are big {portraits} in wooden frames on the walls.',
	act = 'Hmm... There is the same face on all portraits! The cold-smiled face of a fourty-aged man with an empty chilling sight.',
};

salo = obj {
	nam = 'lard',
	inv = 'This piece of lard is too hard to eat...',
	use = function(s, w)
		if w == 'trap' and not trap._salo then
			inv():del('salo');
			trap._salo = true;
			return 'Hmm... I think I\'ve made a mousetrap!';
		end
	end
};

food = obj {
	nam = 'food',
	inv = function (s) 
		inv():del('food');
		return 'I\'m so hungry, so I eat all this yummy food just right now without even taking a seat. Wow... Then I take the tray with empty plates to the washers.';
	end
};

knife = obj {
	nam = 'knife',
	dsc = 'I observe {a knife} on the tray.',
	inv = function(s)
		if s._oster then
			return 'A steel knife. Very sharp.';
		end
		return 'A steel knife. Too blunt.';
	end,
	use = function(s, w)
		if w == 'shells' then
			if not s._oster then
				return 'The knife is not sharp enough to be used.';
			end
			if have('poroh') then
				return 'I have the gunpowder already.';
			end
			inv():add('poroh');
			return 'I crack one of the shells and take the gunpowder out.';
		end
	end,
	tak = function(s)
		if have('knife') then
			return 'I\'ve already got one...', false
		end
		return 'I think I\'ll take it with me.';
	end
};

ostatki = obj {
	nam = 'food leftovers',
	dsc = '{The leftovers of food} are evenly distributed on the plates.',
	tak = function(s)
		if food._num ~= 2 or have('salo') then
			return 'Nothing useful...', false;
		else 
			take('salo');
			return 'A piece of lard!', false;
		end
	end
};

podnos = obj {
	nam = 'tray',
	dsc = 'There is my {tray} on the table.',
	act = function(s, w)
		if w == 1 then
			return 'A fork like a fork... Not ideally clean.';
		end
		if w == 2 then
			return 'The design of this spoon has no remarkable features.';
		end
		return 'Blue plastic. A little oily by touch.';
	end,
	obj = { 'ostatki',
		vobj(1, 'fork', 'A {fork} and'), 
		vobj(2, 'spoon', 'a {spoon} lie beside.') 
	},
};

moika = room {
	nam = 'dish washing',
	enter = function()
		return cat('I take the tray to the dish washing area.^^', walk('kitchen')), false;
	end
};

eating = room {
	pic = 'gfx/podnos.png',
	enter = function(s, f)
		podnos.obj:add('knife');
		inv():del('food');
		if not me()._kitchendlg then
			me()._kitchendlg = true;
			return walk('kitchendlg'), false;
		end
		if f ~= 'kitchendlg' then
			return 'I take a seat at a free table and have some meal.';
		end
	end,
	nam = 'at the table',
	dsc = 'I feel a plain surface of the table under my hands.',
	obj = { 'podnos' },
	way = { 'moika' },
	exit = function(s)
	end
};

gotfood = function(w)
	inv():add('food');
	food._num = w;
	return back();
end

invite = obj {
	nam = 'invitation',
	inv = 'The invitation to the lecture of Belin: Level:4, Hall:2... Hmmm... I need to get there... He has my Barsik.',
}

povardlg = dlg {
	nam = 'in the kitchen',
	pic = 'gfx/povar.png',
	dsc = 'I see the tired fat face of the service woman in a white cap...',
	obj = {
	[1] = phr('Please, give me these green... Yeah - and beans!', 'Here you are!', [[pon(1); return gotfood(1);]]),
	[2] = phr('Potatoes with bacon, please!', 'Bon appetite!', [[pon(2); return gotfood(2);]]),
	[3] = phr('Two garlic soups!!!', 'Nice choice!', [[pon(3);return gotfood(3);]]),
	[4] = phr('Please, something not hard. I have an ulcer...', 'Oatmeal!', [[pon(4); return gotfood(4);]]),
	},
};
kitchendlg = dlg {
	nam = 'talking to employee',
	pic = 'gfx/ilya.png',
	dsc = 'I took my tray and sat at a free table. A minute later some guy tried to join my table with a question: "Occupied?"',
	obj = {
	[1] = phr('No, not occupied...', '— Thanks. How\'s it going? What unit are you from?', [[pon(3,4,5); poff(2);]]),
	[2] = phr('Occupied...', '— Ha-ha! Nice joke! What unit are you from?', [[pon(3,4,5); poff(1);]]),
	[3] = _phr('Hmm... Space Curvatures...', '— Oh, that\'s an old stuff!', [[pon(6);poff(4,5)]]),
	[4] = _phr('E-er... Quantum Jumps...', '- Hmm? Haven\'t heard about it.', [[pon(6);poff(3,5)]]),
	[5] = _phr('Oh... The Department of Quasispace Research!', '— Wow! Cool!', [[pon(6);poff(3,4)]]),
	[6] = _phr('Hmm... ', '— And what is your security level?', [[pon(7,8)]]),
	[7] = _phr('Super-secret!', '— Wow! ... ', [[poff(8); pon(9)]]),
	[8] = _phr('Anonymous.', '— Really? Haven\'t heard about it. Maybe it\'s even more classified than mine...', 
[[poff(7); pon(9)]]),
	[9] = _phr('Mmm...', '— I\'m Ilya... — the guy reaches his thin hand — And what\'s your name?', [[pon(10, 11, 12)]]),
	[10] = _phr('Pp.. Pk... Pupkin... Vasily Pupkin.', '— Oh, a rare last name!', [[poff(11,12); pon(13)]]),
	[11] = _phr('Sergey.', '— Give me five, man!', [[poff(10,12); pon(13)]]),
	[12] = _phr('George...', '— Ok, nice to meet you, Gosha!', [[poff(10,11); pon(13)]]),
	[13] = _phr('Hmm...', 
[[— You're some kind weird... But it doesn't matter. We are all here... — Ilya made an expressive face -... I'm distributing invitations to the classified lecture of Belin... Only for friends... I think I like you. And your security level is high enough... So...]], [[pon(14)]]),

	[14] = _phr('Where is he?... Hmm.. Where the lecture will take place?', 

[[— Security level 4. Hall 2. So, be there! It's a good opportunity to get close to... — Ilya gave a look at one of the portraits on the wall. — Oh, I almost forgot! — he gave me a piece of white plastic — Well, see ya!... — Uhhh...]],[[inv():add('invite');return walk('eating');]]), 
	}
};
kitchen = room {
	nam = 'canteen',
	pic = 'gfx/kitchen.png',
	dsc = 'A small canteen.',
	act = function(s, w)
		if w == 4 then
			return 'I see someone\'s hands taking trays with used plates to somewhere inside...';
		end
		if w == 1 then
			if not have('food') then
				return 'I took a seat at a free table. Ok, got some rest - now it\'s time to go!';
			end
			return walk('eating');
		end
		if w == 2 then
			return 'They sound like a hive of bees...';
		end
		if w == 3 and not have('food') then
			return cat([[I joined the queue... I took a tray, cutlery and wipes. Time flows painfully slowly. At last I make an order...^^]], walk('povardlg'));
		end
	end,
	used = function(s, w, ww)
		if w == 1 and ww == 'food' then
			return s:act(1);
		end
	end,
	enter = function(s)
		if not have('mywear') and not have('alienwear') then
			me()._walked = true;
		end
		set_music('mus/foot.mod');
	end, 
	exit = function(s, t)
		if have('food') and t ~= 'eating' then
			return 'Just leave with a tray in my hands? No.', false;
		end
		if t == 'stolcorridor' then
			set_music('mus/ice.s3m');
		end
	end,
	obj = { 'portrait', 
		vobj(1, 'tables', '{Tables} for 4 and 8 persons are placed evenly in the hall.'), 
		vobj(2, 'people', 'The canteen is full of {people}.'),
		vobj(3, 'queue', 'The {queue} of hungry people waiting for their food moves fast enough.'),
		vobj(4, 'dish washing', 'In the corner there\'s a {slot} for disposal of used trays and washing-up.'), 
	},
	way = { 'stolcorridor' },
};

stolcorridor = room {
	nam = 'canteen entrance',
	pic = 'gfx/kitchencor.png',
	dsc = 'The long and narrow corridor is illuminated by fluorescent light.',
	act = function(s, w)
		if w == 1 then
			return 'Yeah, these people came here to eat...';
		end
	end,
	obj = {'garderob', vobj(1,'люди', '{People} walk back and forth along the corridor.')},
	way = {'sside', 'kitchen'},
	exit = function(s, t)
		if t == 'sside' and not have('mywear') and not have('alienwear') then

			return 'It\'s cold outside... I won\'t go there without a coat... No...', 
				false;
		end
	end,
	enter = function(s)
		-- generate garderob
		if have('gun') and not gun._hidden then
			return 'I\'m afraid there will be some questions to me if I go inside with a shotgun...', false;
		end
		local i
		for i=1, 8 do
			local o = garderob.obj[i];
			ref(o):disable();
		end
		local k = 7;
		for i=1, 5 do
			if not have('alienwear') or k ~= alienwear._num then
				local o = garderob.obj[k];
				ref(o):enable();
			end
			k = rnd(8);
		end
	end
};

sside = room {
	nam = 'south side',
	pic = 'gfx/sside.png',
	dsc = [[I am at the south wall of the institute building. ]],
	act = function(s, w)
		if w == 1 then
			ways():add('stolcorridor');
			return "I came across the entrance and saw a label - 'Canteen'. Hmm... Maybe go inside?";
		end
		if w == 2 then
			return 'The ones who walk out seem to be more pleased than others...';
		end
	end,
	way = {'eside','wside'},
	obj = { vobj(1, "entrance", "There's an {entrance} near the east corner."),
		vobj(2, "people", "The entrance door opens from time to time letting {people} in and out.")},
	exit = function(s, t)
		if t == 'eside' then
			return 'If I go there I will be a good target for machine guns.', false
		end
	end
};

nside = room {
	nam = 'north side',
	pic = 'gfx/nside.png',
	dsc = 'I am at the north wall of the institute building.',
	way = {'eside','wside' },
	act = function(s, w)
		if w == 1 then
			return 'Yeah — a drainpipe... Seems strong enough. But I doubt I can climb it up.';
		end
	end,
	obj = { vobj(1, 'tube', 'A {drainpipe} flows along the east corner.')},
};


wside = room {
	nam = 'front side',
	pic = 'gfx/wside.png',
	dsc = 'The front side of the institute.',
	way = {'entrance', 'nside','sside' },
	act = function(s, w)
		if w == 1 then
			return 'The van my story began with...';
		end
		if w == 5 then
			return 'It starts too high to reach. Also it\'s locked. Maybe it may be of some use during fire, but I really doubt about it...'
		end
		if w == 2 then
			return 'The guards will recognize me for sure. I\'d better save my Barsik first.';
		end
		if w == 3 then
			return 'Nice entrance... But I can\'t get rid of an idea that the institute eats people.';
		end
		if w == 4 then
			return 'It\'s almost dark outside, but people still keep going inside...';
		end
	end,
	obj = { vobj(3, 'entrance', 'The main {entrance} has a big rotating door'),
		vobj(4, 'people', ' letting {people} in and out.'), 
		vobj(1, 'van', 'There\'s a black {van} in front of the door.'),
		vobj(2, 'checkpoint', 'Sixty meters further I can hardly distinguish a {checkpoint}.'),
		vobj(5, 'ladder', 'I see a fire-escape {ladder} on the south part of the wall. The ladder stretches from the second to the fifth floor.' ),
	}
};

turn1 = obj {
	nam = 'tourniquet',
	dsc = 'Shiny steel {tourniquets} block the passage to the elevators. The green indicators show the message: <<All levels and categories>>.',
	act = function(s, w)
		if s._inside then
			s._inside = false;
			here().way:del('lift');
			return 'I approach the tourniquets, use the card and go out from the restricted area.';
		end
		if s._unlocked then
			s._inside = true;
			here().way:add('lift');
			return 'I approach the tourniquets, use the card and and in a moment I\'m at the elevators.';
		end
		return 'I approach a tourniquet, but I see a red X sign shining. Bad idea to go further.';
	end,
	used = function(s,w)
		if w == 'card' then
			s._unlocked = true;
			s._inside = true;
			here().way:add('lift');
			return 'I apply the card to a tourniquet and see a green light. The passage is clear. I go to the elevators.';
		end
	end
};

lustra = obj {
	nam = 'chandeliers',
	dsc = 'Big shiny {chandeliers} hang over my head.',
	act = 'I can\'t help watching them... I think they are made of crystal.';

};

divan = obj {
	nam = 'sofa',
	dsc = 'In the corner there\'s a {sofa} for guests placed opposite to the guard table.',
	act = function(s)
		return 'Black-leathered, very soft sofa.';
	end,
};

entrance = room {
	nam = 'main entrance',
	pic = 'gfx/entrance.png', 
	dsc = 'The first floor of the institute is shocking by its magnificence.',
	act = function(s, w)
		if w == 2 then
			return 'A big padlock hangs on the gates.';
		end
		if w == 3 then
			if not turn1._inside then
				return 'The tourniquets block my way to the elevators.';

			end
			return 'Four elevators seem not enough for all institute employees.';
		end
		if w == 4  then
			return 'A table made from glass or crystal. There\'s a terminal beyond the table.'; 
		end
		if w == 5 then
			return 'It would be better for me if he doesn\'t see me once again.'; 
		end
		if w == 6 then
			return 'People... It\'s very unusual for me to see so many people.';
		end
	end,
	obj = {
		'lustra',
		vobj(2, 'gates', 'Iron {gates} to railways occupy all space of east wall.'),
		vobj(3, 'elevators', 'In the middle of the hall there are {elevators}.'),
		'turn1',
		vobj(4, 'table', 'There\'s a {table} before tourniquets.'),
		vobj(5, 'guard', 'The {guard} sits at the table.'),
		vobj(6, 'people', '{People} come and go in and out making a queue near the elevators.'),
		'divan',
	},
	way = { 'wside' },
	enter = function(s, f)
		if have('gun') and f == 'wside' and not gun._hidden then
			return 'I think there will be many questions about my shotgun if I take it inside with me... I should hide it somewhere', false;
		end
	end,
	exit = function(s, t)
		if t == 'wside' then
			turn1._inside = false;
			s.way:del('lift');
		end
	end,
};

pinlift = obj {
	nam = function(s)
		if s._num == 3 then
			return '';
		end
		return 'people';
	end,
	act = function(s)
		return 'Empty and depressed sights... Painful silence.';
	end,
	dsc = function(s)
		if s._num == 1 then
			return 'The elevator is full of {people}.';
		end
		if s._num == 2 then
			return 'There are several {men} in the elevator.';
		end
		if s._num == 3 then
			return 'The elevator is empty.'
		end
	end
};

lift = room {
	nam = 'elevator',
	pic = 'gfx/lift.png',
	dsc = 'It must be bright and comfortably in the elevator. But I am tormented by claustrophobia. I see buttons on the panel:',
	enter = function(s, t)
		if here() == entrance then
			s._from = 1;
			pinlift._num = 1;
			return 'I wait for one of the elevators and go inside.';
		end
		pinlift._num = rnd(3);
		if here() == floor2 then
			s._from = 2;
		elseif here() == floor3 then
			s._from = 3;
		elseif here() == floor4 then
			s._from = 4;
		elseif here() == floor5 then
			s._from = 5;
		end
		return 'I press an elevator call button and wait. After some time I go inside an elevator.';
	end,
	act = function(s, w)
		local to,st
		if not tonumber(w) then
			return
		end
		if w == s._from then
			return cat('No!!! The claustrophobia forces me out of the elevator.^^', 
				back());
		end
		if w == 8 then
			st = '';
			if galstuk._wear then
				st = ' By the way, I have a tie.';
			end
			if me()._brit then
				return 'I look in the mirror and see the tired but smoothly shaved face. This is me.' .. st;
			end
			return 'I look in the mirror and see tired and bearded face. This is me.'..st;
		end
		if w == 6 or w == 7 then
			return 'I\'m nervous... But I should not take nervous decisions.';
		end
		if w == 1 then
			to = 'entrance';
		else 
			to = 'floor'..w;
		end
		return cat('I press the button and wait. Claustrophobia almost knocks me down, but I\'m waiting... Ukhh... Trip done at last!^^',
			walk(to));
	end,
	exit = function()
		return 'Elevator doors close behind me.';
	end,
	obj = {
		vobj(1,'1', '{1},'),
		vobj(2,'2', '{2},'),
		vobj(3,'3', '{3},'),
		vobj(4,'4', '{4},'),
		vobj(5,'5', '{5},'),
		vobj(6,'stop','{stop}'),
		vobj(7,'go','и {go}.'),
		vobj(8,'mirror', 'The elevator back wall is a {mirror}.'),
		'pinlift',
	},
};

floor2 = room {
	nam = '2nd floor site',
	pic = 'gfx/floor2.png',
	dsc = "There are no windows on the second floor. Low ceiling and grey-green walls. It's cold and silent here.",
	act = function(s, w)
		if w == 1 then
			return 'The door seems to be made of lead... I do not see any possibility to get in there. And it\'s for good. There\'s a label under the sign which says: <<Level: 2, Category: Nuclear Energy>>.';
		end
		if w == 2 then
			return 'Yeah, one of these elevators brought me to this damned place...';
		end
	end,
	obj = { 
		vobj(1, 'door', 'I see a massive {door} with the sign <<Beware! High Radiation!!!>>'),
		vobj(2, 'elevators', 'It seems the four elevator slots are watching for me gloomily.'),
	},
	way = { 'lift' },
};

resh = obj {
	nam = 'bars',
	dsc = function(s)
		if not s._unscrew then
			return 'The hole is protected by the iron-bar {lattice}.';
		end
		if vent._off then
			return 'In the hole I can distinguish blades of a big airing fan. The {lattice} lies on the floor.';
		end
		return 'The blades of the big airing fan are rotating. The {lattice} lies on the floor.';
	end,
	act = function(s)
		if s._unscrew then
			return 'This is what can be done with a blunt knife if you have enough patience and skill!';
		end
		if not stoly._moved then
			return 'Cannot reach...';
		end
		return 'The {lattice} is screwed tightly with 12 screws...';
	end,
	used = function(s, w)
		if w == 'knife' and not s._unscrew and stoly._moved then
			s._unscrew = true;
			return 'I climb the table and try to unscrew the screws with a knife. This takes me much time. But at last I make it. The lattice falls down on the floor. I get down from the table.';
		end
		if w ~= 'stol' then
			return 'No way...';
		end
	end,
};

vent = obj {
	nam = 'airing hole',
	dsc = 'In the middle of the ceiling there is a big square {hole} for airing.',
	act = function(s)
		if not stoly._moved then
			return 'I cannot reach it...';
		end
		if not resh._unscrew then
			return 'I step on the table and examine the hole. It is covered by the lattice... Being disappointed I get down.';
		end
		if not s._off then
			return 'I climb the table and watch the sharp blades of the fan. I\'m afraid it is too dangerous...';
		end
		if not s._trap then
			return 'I climb the table. Holding the edges of the hole I\'m trying to get in... It\'s dark and wet there. I\'m almost in when I see red eyes and teeth of a big rat... No!!! I fall back on the table and then hit the floor.';
		end
-- here we go!
		return walk('toilet');
	end,

	used = function(s, w)
		if w == 'stol' then
			return
		end
		if not stoly._moved  then
			return 'I can\'t reach the hole...';
		end
		if not resh._unscrew then
			return 'The hole is covered by the lattice...';
		end
		if not s._off then
			return 'I can\'t because of the fan blades...';
		end
		if w == 'gun' and not s._trap then
			gun._loaded = false;
			return 'I climb the table and point the shotgun to the hole. Both barells shot simultaneously with deep sound. I listen. The hole is silent... I get down. I think it\'s useless...';
		end
		if w == 'trap' then
			if not trap._salo then
				return 'I set the trap on the edge of the hole. Waiting. But the rat is not a fool. I take the trap back. I need some bait.';
			end
			inv():del('trap');
			vent._trap = true;
			return 'I climb the table and set the baited trap on the edge of the hole... I need not wait for too long... The clash sound and the last scream of the rat make me know that the work is done!';
		end
	end,
	obj = {
		'resh'
	}
};

stol = obj {
	nam = 'table',
	inv = 'I hold the corner of one of the tables. Seems made from oak.',
	use = function(s, w)
		if w == 'vent' or w == 'resh' then
			inv():del('stol');
			stoly._moved = true;
			return 'I strained myself and moved one of the tables to the center of the room.';
		end
	end
};

stoly = obj {
	nam = 'tables',
	dsc = function(s, w)
		if not s._moved then
			return 'Four oak {tables} take their places in the four room corners respectively.';
		end
		return 'Three oak {tables} reside in the room corners. One table is moved to the center.';
	end,
	act = function(s, w)
		if s._moved then
			return 'Put one table on another? No - I won\'t make it...';
		end
		inv():add('stol');

		return [[Good furniture... But the table in my house is better - I've made it with my own hands. I hold the corner of a table.]];
	end
};

eroom = room {
	nam = 'STR department',
	pic = function()
		if not stoly._moved then
			return 'gfx/sto.png';
		end
		if not resh._unscrew then	
			return 'gfx/sto2.png';
		end
		return 'gfx/sto3.png';

	end, 
	dsc = [[I am in the small room with beige walls.]],
	enter = function(s, f)
		if f == 'cor3' then
			return [[I opened the door and looked inside. Whew... Empty! I think I may look around...]];
		end
		if f == 'toilet' then
			return 'Well... I lift the iron lattice from the toilet floor and go into darkness... In some minutes I jump from the airing hole to the table and go to the floor.';
		end
	end,
	act = function(s, w)
		if w == 1 then
			return 'I move the louvers and look into outside darkness. I face my dim reflection in the window. Looking down I see the machine gun towers and the railways.';
		end
		if w == 2 then
			return 'It is just terminals. The client machines which connect to the institute servers. However, I\'m not interested in them. I have not used a computer for 10 years.';
		end
	end,
	obj = { 
		vobj(1, 'window', 'A big {window} looks to the east.'),
		'stoly',
		vobj(2, 'terminals', 'On each table there is a {terminal} with a 17-inch display.'),
		'vent',
		'portrait',
	},
	way = { 'cor3' },
	exit = function()
		inv():del('stol');
	end
};

key = obj {
	nam = 'key',
	dsc = 'Someone has left the {key} in the door lock.',
	tak = 'I carefully take out the key and put it in my pocket.',
	inv = 'To my surprise - ordinary door locks are used in the institute along with complex electronic security!',
};

room33 = room {
	nam = 'room',
	pic = 'gfx/bholes.png',
	dsc = [[I stand for some seconds near the door. Then I open it and go inside.]],
	act = function(s, w)
		if w == 1 then
			return cat('A grey-haired man in thick glassed turns to me and for watches me for a second. - Who are you? Go outside immediately!!^^',back());
		end
	end,
	obj = { 
		vobj(1, 'people', [[I see a group of {people} in white technical coats standing at the board in the middle of the room and having a great debate among theirselves.]]),
		'portrait',
		'key' 
		};
	way = { 'cor3' },
	exit = [[ I carefully leave the room.]];
};

room3x = room {
	nam = 'room',
	enter = function(s, f)
		if s._num == 2 then
			return [[I open the door a little and look inside. 
			A square room with two windows.
			A lot of people are sitting at terminals along the walls. 
			I close the door in a hurry.]], false;
		end
		if s._num == 4 then
			return [[I touch the cold metal handle and open the door carefully... - Simulation in progress!!! - I hear someone's angry voice from inside. I release the handle and the door closes...]],
			false;
		end
		if s._num == 5 then
			ref(f).way:add('eroom');
			return walk('eroom'), false;
		end
		if s._num == 6 then
			return [[I start opening the door, but I begin to hear some strange sound which is becoming louder and louder. - What idiot hasn't closed the door?! - someone inside is very angry. I close the door in a hurry.]], 
			false;
		end
	end,
};

switch = obj {
	nam = 'switch',
	dsc = function(s)
		local t
		if vent._off then
			t = ' in <<off>> state.';
		else
			t = ' in <<on>> state.';	
		end
		return 'In the corner near the entrance there\'s a {switch}'..t;
	end,
	act = function(s)
		if vent._off then
			vent._off = false;
			return 'Switching ON!'
		end
		if not cor3._locked then
			return [[I turn the switch OFF and walk away. But suddenly one of the doors opens and some old voice screams to the corridor: What the...!!! This is impossible!!! No way to work!!! Turn it on back!!! - I need to return to the switch and to turn it ON.]];
		end
		vent._off = true;
		return 'Switching OFF!';
	end
};

cor3 = room {
	nam = '3rd floor corridor',
	pic = 'gfx/cor3.png',
	enter = function(s, f)
		if f == 'floor3' then
			return 'I apply the card to a card reader... Red indicator blinks and then becomes green... The way is free!';
		end
	end,
	dsc = 'The long corridor stretches to the end of the building. Fluorescent lamps bring some dim light from the ceiling. There\'s a green carpet walkway on the floor.',
	act = function(s, w)
		if w == 1 then
			return 'I walk to one of the doors and look in the door porthole... People in white are moving around some weird devices. Just like bees... I think these rooms are labs.';
		end
		if not tonumber(w) then
			return nil, false
		end
		if w == 3 then
			if s._locked then
				return 'This room is locked... I hear some not loud but intense sounds. I do not want to open it.';
			end
			return walk('room33');
		end
		if tonumber(w) >=2 and tonumber(w) <=6 then
			room3x._num = w;
			return walk('room3x');
		end
		if w == 7 then
			return 'The window looks to the south side... It\'s dark outside. Nothing to watch but snowflakes bumping the glass...';
		end
		if w == 8 then
			return 'Visit?';
		end
	end,
	used = function(s, w, ww)
		if w == 1 or w == 2 or w == 4 or w == 5 or w == 6 then
			return 'No way...';
		end 
		if w == 3 and ww == 'key' then
			if s._locked then
				return 'Already closed...';
			end
			s._locked = true;
			return 'I insert the key in the key hole and lock the door making two turns. I take out the key and put it back to the pocket.';
		end
	end,
	obj = {
		vobj(1, 'white doors', 'On the right side there are white metal {doors} with windows.'),
		vobj(2, 'gravity', 'On the left side there are several doors with labels: {gravity},'),
		vobj(4, 'simulation', '{simulation}'),
		vobj(5, 'STR effects','{STR effects},'),
		vobj(3, 'black holes', '{black holes},'),
		vobj(6, 'quasispace', '{quasispace}.'), 
		vobj(7, 'window', 'I see the {window} in the end of the corridor.'),
		vobj(8, 'toilet', '{Toilets} are near the window.'),
		'switch',
		'portrait',
	},
	way = {'floor3', 'toilet3', 'toiletw'},
};

mylo = obj {
	nam = 'soap',
	inv = function(s)
		if s._pena then
			return 'A piece of soap with foam.';
		end
		return 'A piece of soap.';
	end,
	dsc = 'A piece of {soap} lies on the basin.',
	tak = 'I took the slippy soap... It fell down back to the basin, but I caught it up again and put it in the pocket...';
};

sushka = obj {
	nam = 'dryer',
	dsc = 'A hand {dryer} hangs nearby.',
	act = function(s,w)
		return 'I bring my hands to the dryer and it starts working... Deja vu...';
	end,
};

umyvalnik = obj {
	nam = 'basin',
	dsc = 'The {basin} is located near the entrance.',
	act = function(s)
		if me()._mylo then
			me()._mylo = false;
			return 'I wash away soap foam from my face...';
		end
		return 'I drink chlorinated water greedily... Yeah - this water is not the same as in my creek...'; 
	end,
	used = function(s, w)
		if w == 'mylo' then
			mylo._pena = true;
			return 'I put the soap into warm water...';
		end
	end
};

toilet3 = room {
	nam = 'toilet',
	pic = 'gfx/toil3.png',
	dsc = 'I am in a toilet. A standard architecture. No windows. White tile.',
	act = function(s, w)
		if w == 2 then
			return 'All are in use!';
		end
		if w == 3 then
			return 'People are evenly distributed over the toilet. All closets are occupied. A couple of men are waiting for their turn.';
		end
	end,
	obj = { 
		'umyvalnik',
		'mylo',
		'tzerkalo',
		'sushka',
		vobj(2, 'closets', 'There are 4 {closets} in this toilet.'),
		vobj(3, 'people', 'Some {people} are present...'),
	},
	way = { 'cor3' }, 
	exit = function()
		if me()._mylo then
			return 'With soap on the face? No...', false
		end
		objs():del('face');
	end
};

floor3 = room {
	nam = '3rd floor site',
	pic = 'gfx/floor3.png',
	dsc = [[The site of the third floor is large enough. Beige walls. High ceilings.]],
	act = function(s, w)
		if w == 1 then
			return 'I gaze at the window for a minute... A white desert flowing to the darkness... At this moment I realize what an alien place I am in...';
		end
		if w == 2 then
			if not s._unlocked then
				return 'Metal upholstered with leather. The door has a card reader. The door label says: <<Level: 3, Category: Applied Physics>>';
			end
			return walk('cor3');
		end
		if w == 3 then
			return 'Strong doors I must admit... Much stronger than the door of my hut... The door has a card reader. The door label says: <<Level: 3, Category: Nanotechnologies>>';
		end
	end,
	used = function(s,w,ww)
		if ww ~= 'card' then
			return 'It won\'t help...';
		end
		if w == 2 then
			s._unlocked = true;
			s.way:add('cor3');
			return walk('cor3');
		end
		if w == 3 then
			return 'I apply the card to the card reader. I hear an annoying beep - access denied.';
		end
	end,
	obj = { 
		vobj(1, 'window', 'A wide {window} looks to the west.'),
		vobj(2, 'brown door', 'There\'s a brown {door} to the right of the window.'),
		vobj(3, 'white door', 'A white {door} - to the left.'),
	},
	way = { 'lift' },
};

britva = obj {
	nam = 'razor',
	dsc = 'A {razor} lies on the basin.',
	tak = 'I put the razor in pocket hoping no one notices it.',
	inv = 'A razor, little bit rusty...',
};

face = obj {
	nam = 'face',
	dsc = 'The mirror reflects my {face}.',
	act = function(s)
		local st = '';
		if me()._brit then
			st = ' Well shaved.';
		elseif me()._mylo then
			st = ' With soap foam on it.';
		end
		if galstuk._wear then
			st = st..' With a tie, by the way.';
		end
		return 'This is a reflection of my face.'..st;
	end,
	used = function(s, w)
		if w == 'mylo' then
			if me()._brit then
				return 'I\'ve shaved already...';
			end
			if not mylo._pena then
				return 'The soap is quite dry...';
			end
			if not have('britva') then
				return 'I put soap on the face and wash away the dirt... Ooh...';
			end
			me()._mylo = true;
			return 'I put soap foam on the face...';
		end
		if w == 'britva' then
			if me()._brit then
				return 'I\'ve shaved already...';
			end
			if not me()._mylo then 
				return 'I need foam on my face...';
			end
			me()._brit = true;
			me()._mylo = false;
			return 'I\'m shaving... Then I wash my face...';
		end
	end
};

tzerkalo = obj {
	nam = 'mirror',
	dsc = 'A {mirror} is placed where it should be - above the basin.',
	act = function(s)
		local st = '';
		objs():add('face');
		if galstuk._wear then
			st = ' With a tie, besides...';
		end
		if me()._brit then
			return 'Sad, but well shaved face.' .. st;
		end
		return 'Wild bearded face looks at me from the mirror.' .. st;
	end,	
};

toilet = room {
	nam = 'toilet',

	pic = 'gfx/toil4.png',
	dsc = 'Quite large toilet, I should say. White tile. Yellow stains. Humidity and sounds of flowing water. A wooden door leads to the corridor.',
	enter = function(s, f)
		if f == 'eroom' then
			return 'I climb to the airing hole. It\'s dusty and quiet inside. I wander the airing system maze until at last I see the light over my head. A moment later I push the iron lattice in the toilet floor...';
		end
	end,
	act = function(s, w)
		if w == 2 then
			return 'Yeah... I\'m lucky. I guess it\'s a men\'s toilet...';
		end
		if w == 3 then
			return 'They have strange airing system. But thanks to it I am here!...';
		end
	end,
	obj = { 
		vobj(2, 'closets', 'There are only 2 {closets} in this toilet.'),
		'umyvalnik',
		'britva',
		'tzerkalo',
		'sushka',
		vobj(3, 'lattice', 'There is an iron {lattice} on the floor.');
	},
	way = { 'eroom', 'cor4'},
	exit = function(s, t)
		if me()._mylo then
			return 'With foam on the face? No...', false
		end
		objs():del('face');
		if t ~= 'eroom' then
			return 'I come outside the toilet carefully.';
		end
	end
};

toiletw = room {
	nam = 'women closet',
	enter = function(s, w)
		return 'Whew... I was about making a mistake...', false;
	end
};

function room4x_hear()
	local ph = {
	[1] = '...According to the uncertainty principle it is impossible to know both the position and the momentum of a quantum particle...',
	[2] = '...According to the theory of quantum mechanics, measurement causes an instantaneous collapse of the wave function describing the quantum system into an eigenstate of the observable state that was measured...',
	[3] = '...The reduction of the wave packet is the phenomenon in which a wave function appears to reduce to a single one of those states after interaction with an observer...',
	[4] = '...The theory predicts that both values cannot be known for a particle, and yet the EPR experiment shows that they can...',
	[5] = '...The principle of locality states that physical processes occurring at one place should have no immediate effect on the elements of reality at another location...';
	[6] = '...They claim that given a specific experiment, in which the outcome of a measurement is known before the measurement takes place, there must exist something in the real world, an "element of reality", which determines the measurement outcome...',
	[7] = '...The many-worlds interpretation is a postulate of quantum mechanics that asserts the objective reality of the universal wavefunction, but denies the actuality of wavefunction collapse, which implies that all possible alternative histories and futures are real—each representing an actual "world" (or "universe")...',
	[8] = '...Everett\'s original work contains one key idea: the equations of physics that model the time evolution of systems without embedded observers are sufficient for modelling systems which do contain observers; in particular there is no observation-triggered wave function collapse which the Copenhagen interpretation proposes...',
	[9] = '...The particles are thus said to be entangled. This can be viewed as a quantum superposition of two states, which we call state I and state II...',
	[10] = '...Alice now measures the spin along the z-axis. She can obtain one of two possible outcomes: +z or -z. Suppose she gets +z. According to quantum mechanics, the quantum state of the system collapses into state I. The quantum state determines the probable outcomes of any measurement performed on the system. In this case, if Bob subsequently measures spin along the z-axis, there is 100% probability that he will obtain -z. Similarly, if Alice gets -z, Bob will get +z...',
	};
	return ph[rnd(10)];
end

room4x = room {
	nam = 'room',
	enter = function(s, f)
		if s._num == 1 then
			return 'I carefully touch the handle and try to open the door. Closed...'
			, false;
		elseif s._num == 2 then
			return 'I come close to the door and listen... - '..room4x_hear()..
			' — Ooh... I\'d better keep going...',
			false;
		elseif s._num == 3 then
			return 'I come close to the door and listen... - I hear someone argue fiercly... - I\'d better go...', false;
		elseif s._num == 4 then
			return 'I open the door and come inside. 12 pairs of eyes of guys sitting at desks look at me attentively. Another eye pair belongs to a man standing at a board. - Sorry, I must have missed the door... - this is all I can say in such situation. I quickly get outside...', false;
		elseif s._num == 5 then
			return 'Closed...', false;
		end
	end,
};

galstuk = obj {
	nam = function(s)
		if s._gal then
			return 'tie';
		end
		return 'rag';
	end,
	inv = function(s, w)
		if not s._gal then
			s._gal = true;
			return 'I examine the rag and I figure out that it used to be a tie some time ago.'
		end
		if s._hot then
			if not s._wear then
				s._wear = true;
				return 'I put the tie on with dignity...';
			end
			return 'I wear the tie...';
		end
		if s._mylo then
			return 'It is all in soap!';
		end
		if not s._water then
			return 'It is dirty! I won\'t put it on!';
		end
		if not s._hot then
			return 'It is wet! I won\'t wear it!';
		end
	end,
	used = function(s, w)
		if s._wear then
			return 'I wear the tie...';
		end
		if w == 'mylo' then
			if not mylo._pena then
				return 'The soap is dry...';
			end
			s._mylo = true;
			if not s._gal then
				s._gal = true;
				return 'While putting soap to the rag, I understand that this rag use to be a tie once.';
			end
			return 'I put some soap on the tie...';
		end
	end,
	use = function(s, w)
		if s._wear and w ~= 'hand' then
			return 'I wear the tie...', false;
		end
		if w == 'umyvalnik' then
			if not s._mylo  then
				return 'Using just water? I doubt it washes chalk away...';
			end
			s._water = true;
			s._mylo = false;
			return 'I washed the tie in warm water...';
		end
		if w == 'sushka' then
			if not s._water then
				return 'Why should I dry this?';
			end
			s._hot = true;
			s._water = false;
			return 'In 5 minutes I dried the tie well...';
		end
	end
};

room46 = room {
	nam = 'lecture room 6',
	pic = 'gfx/room4.png',
	enter = 'I open the door and come inside... The room is empty...',
	dsc = 'I am inside the lecture room... Several tables are placed in two rows towards the board.',
	act = function(s, w)
		if w == 1 then
			if not have('galstuk') then
				inv():add('galstuk');
				return 'I see a rag on the board. I take the rag.';
			end
			return 'Hmm... I do not understand a thing in this stuff...';
		end
		if w == 2 then
			return 'I see how spotlights are searching the snowy field down there...';
		end
		if w == 3 then
			return 'I sit by the keyboard, but I recall that I\'m done with the past... I am not a hacker anymore - I am a forester.';
		end
	end,
	obj = {
		vobj(3,'terminal', 'Every table has a {terminal} placed on it.');
		vobj(1,'board', 'Some weird formulas are written on the lecture {board}...'),
		vobj(2,'window', 'The {window} looks to the east.'),
		'portrait',
	},
	way = { 'cor4' },
};

facectrl = dlg {
	nam = 'face control',
	pic = 'gfx/guard4.png',
	dsc = 'I see the unpleasant and unfriendly face of the fat security guy.',
	obj = {
		[1] = phr('I\'ve come to listen to the lecture of Belin...',
		'— I don\'t know who you are, — the guard grins — but I was told to let only decent people in here.',
		[[pon(2);]]),

		[2] = _phr('I have the invitation!', 
		'— I do not damn care! Look at yourself! Used a mirror recently?! You\'ve come to listen to Belin himself! Be-lin! The right hand of ... - the guard paused for a second in respect - So... Get out of here!',
		[[pon(3,4)]]),

		[3] = _phr('I\'m gonna kick you fat face!', '— Well, that\'s enough... - Powerful hands push me out to the corridor... I feel lucky to stay in one piece...',
		[[poff(4)]]),

		[4] = _phr('You boar! I\'ve told you I have the invitation!',
			'— Whaaat? - The guard\'s eyes are going red... The powerful kick sendsme to the corridor... It could be worse...',
		[[poff(3)]]),

		[5] = _phr('I want to listen to the lecture of Belin...',
		'— First — Doctor Belin, and second — no way if no tie...',
		[[pon(2)]]),

		[6] = _phr('I want to listen to the lecture of Dr. Belin very much!!!',
		'The guard examines me with his suspicious eyes and says unwillingly: Your invitation...',
		[[pon(7)]]),

		[7] = _phr('Here... you b... please...', 'Ok... Come in, hurry... The lecture has already begun...',
		[[inv():del('invite'); return walk('hall42')]]);
	},
	exit = function(s,w)
		s:pon(1);
	end
};

hall42 = room {
	nam = 'Hall 2',
	pic = 'gfx/hall2.png',
	dsc = 'A lot of people. Silent. I guess the lecture is going on.',
	obj = {
		vobj(1, 'Belin', 'A man stands at the board - it\'s {Belin}! The man who has stolen my cat.'),
		vobj(2, 'seats', 'I see some free {seats} at the third row.'),
		vobj(3, 'window', 'Three wide {windows} look to the west.'),
		vobj(4, 'lamps', 'The hall is illuminated by fluorescent {lamps}.'), 
	},
	act = function(s, w)
		if w == 1 then
			return 'Now he is without a coat and a hat, and I can see him in details... Quite fat but tall... A tricky smile but opened face... He runs the lecture. I\'ll wait till he finishes and try to have a talk with him...';
		end
		if w == 2 then
			return walk('lection');
		end
		if w == 3 then
			return 'It\'s dark outside... Only white snowflakes reveal theirselves in the fluorescent light from time to time.';
		end
		if w == 4 then
			return 'Six lamps... I hate this blinking light...';
		end
	end,
	exit = function(s, t)
		if t == 'cor4' then
			return 'I do not want to lose Belin again...', false;
		end
	end,
	enter = function(s, f)
		if f == 'facectrl' then
			return 'I enter the lecture hall...';
		end
		if not galstuk._wear then
			facectrl:pon(5);
			facectrl:poff(1);
		end
		if not me()._brit or not galstuk._wear then
			return cat(
'I try to enter the hall, but a man in a uniform stops me. I read <<SECURITY>> on his label. He holds a shotgun.^^', walk('facectrl')), false;
		end
		facectrl:poff(1, 5);
		facectrl:pon(6);
		return walk('facectrl'), false;
	end,
	way = { 'cor4' },
};

hall41 = room {
	nam = 'Hall 1',
	dsc = [[I enter the empty hall. It seems to be one of lecture halls. Many rows of seats get higher and higher one after another till the ceiling.]],
	pic = 'gfx/hall1.png',
	act = function(s, w)
		if w == 1 then
			return 
'Watching the night darkness I remember Barsik with melancholy...';
		end
		if w == 2 then
			return 'We had just like these in our institute when I... Nevermind...';
		end
		if w == 3 then
			return 'Everything I could remember - I\'ve forgotten.';
		end
	end,
	obj = {
		vobj(1, 'windows', 'Three big {windows} look to the west side.'),
		vobj(2, 'table', 'A long {table} takes place near the lecture board.'),
		vobj(3, 'board', 'Some formulas of a previous lecture remain on the {board}.'),
		'portrait',
	},
	way = {
		'cor4',
	},
};

cor4 = room {
	nam = '4th floor corridor',
	pic = 'gfx/cor4.png',
	dsc = 'I am in the corridor. Very high ceilings. I see toilets in the end of the corridor. There\'s a green carpet walkway on the floor.',
	act = function(s, w)
		if not tonumber(w) then
			return;
		end
		if w == 11 then
			return 'Some of them are going to the hall 2.';
		end
		if w == 1 then
			return 'I am melancholically looking in the night darkness... I realize how much I am tired... But I must keep going...';
		end
		if w == 12 then
			return 'This door like many others is provided with a smart-card reader. The red indicator is on.';
		end
		if tonumber(w) >=5 and tonumber(w) <=9 then
			room4x._num = w - 4;
			return walk('room4x');
		end
		if w == 10 then
			ways():add('room46');
			return walk('room46');
		end
		if w == 2 then
			ways():add('hall41');
			return walk('hall41');
		end
		if w == 3 then
			ways():add('hall42');
			return walk('hall42');
		end
	end,
	used = function(s, w, ww)
		if w == 12 and ww == 'card' then
			return 
			'I apply the card to the card reader... Beep... Access denied...';
		end
	end,
	obj = {
	vobj(1, 'window', 'A {window} looks to the south.'),
	vobj(2, 'hall 1','On the west side I see two wide doorways: {hall 1},'),
	vobj(3, 'hall 2', '{hall 2}.'),
	vobj(5, 'lecture room 1', 'On the east side there are less wide doors. The door labels: {lecture room 1},'),
	vobj(6, 'lecture room 2', '{lecture room 2},'),
	vobj(7, 'lecture room 3', '{lecture room 3},'),
	vobj(8, 'lecture room 4', '{lecture room 4},'),
	vobj(9, 'lecture room 5', '{lecture room 5},'),
	vobj(10, 'lecture room 6', '{lecture room 6}.'),
	vobj(11, 'people', 'From time to time {people} appear in the corridor.'),
	vobj(12, 'front door', 'The front {door} is located at the north end of the corridor.'),
	'portrait',
	},
	way = {
		'toilet',
		'toiletw',
	}
};
floor4 = room {
	nam = '4th floor site',
	pic = 'gfx/floor4.png',
	dsc = 'The fourth floor has high ceilings.',
	act = function(s, w)
		if w == 1 then
			return 'Darkness... Not a single light... I can\'t even see the stars. Dim and heavy fluorescent light prevents me to see them...';
		end
		if w == 2 then
			return 'I hate elevators...';
		end
		if w == 3 or w == 4 then
			return 'An ordinary door. One of many in this building. An electronic lock. I can\'t get in without a card.';
		end
	end,
	used = function(s, w, ww)
		if ww == 'card' then
			if w == 3 or w == 4 then
				return [[I apply the card to a card reader... Beep. Access denied...]];
			end
		end
	end,
	obj = {
		vobj(1, 'window','A wide {window} looks to the west.'),
		vobj(2, 'elevators', 'The site with four {elevators} is dimly lit.'),
		vobj(3, 'south door', 'Two doors lead to the north and south corridors. The south {door} label: <<Level:4, Category:Theoretical Physics>>'),
		vobj(4, 'north door', 'The north {door} label: <<Level:4, Category:Biology>>'),
	},
	way = { 'lift' },
};

floor5 = room {
	nam = '5th floor site',
	pic = 'gfx/floor5.png',
	dsc = [[The ceilings on the fifth floor are very high.]],
	act = function(s, w)
		if w == 1 then
			return 'My legs are drowning in red velvet... I should be careful not to leave my footprints here...';
		end
		if w == 2 then
			return 'Yeah, made from crystal. Surely not glass.';
		end
		if w == 3 then
			return 'I approach the window... Interesting. I see that the window looks at quite wide area of the roof, which streches through the front part of the building...';
		end
		if w == 4 or w == 5 then
			return 'I can\'t examine the doors because of the guard... My ID card is not valid here...';
		end
		if w == 6 then
			return 'Though he does not pay any attention to me, still it is better not to bother him...';
		end
	end,
	used = function(s, w)
		if not tonumber(w) then
			return
		end
		if w == 6 then
			return 'It\'s better not to bother him...';
		end
		if w >=1 and w <=5 then
			return 'I won\'t do it while the guard is here,';
		end
	end,
	obj = {
	vobj(1, 'carpet', 'The floor is covered by the red {carpet}.'),
	vobj(2, 'chandelier', 'A crystal {chandelier} hangs over my head.'),
	vobj(3, 'window', 'A wide {window} looks to the west.'),
	vobj(4, 'information', 'I see two doors leading to the south and north corridors. The south {door} label: <<Level:5, Category:Information>>.'),
	vobj(5, 'red door', 'The north {door} does not have any labels. This is a massive door upholstered with red leather.'),
	vobj(6, 'guard', 
		'The passage to the doors are blocked by a checkpoint with a {guard}.');
	},
	way = { 'lift' },
};

