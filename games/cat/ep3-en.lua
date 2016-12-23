lection = room {
	nam = 'Belin\'s Lecture',
	pic = 'gfx/lection.png',
	dsc = [[I take my seat... I can hear everything clearly from this place. Let's listen to the famous physicist...
	^^- So, in November 1935 Schrödinger published his paper in which the following experiment was described. So, what's the point of the experiment? - Belin paused for a second and put some strange box on the table. 
- I like experiments! - Belin's white smile gave a shiny flash. -
- So, as you can see, this is a box... - Belin tapped its plain surface by his hand.
- This box has a built-in container with the poison gas. Besides, the box contains the radiation counter, the radioactive element and the timer. 
The parameters of the experiment are set up so, that the probability of the radioactive element decay during 1 hour - equals to 50%.^^
- If the decay occurs, the mechanism starts working and the poison gas is released from its container to the inner space of the box. So, gentlemen, I guess it's simple so far, isn't it? - Belin smiles again.
- But the point is that in his experiment Schrödinger puts a cat inside the box - an alive being.^^

- According to the quantum theory, if we are observing the nucleus - the state of the nucleus is described as a superposition (mixing) of two states - the state of decayed nucleus and the state of non-decayed nucleus. Therefore, the cat in the box is alive and dead simultaneously.
- Belin raises his voice.
- So we can say that it is just a mind game, but I will show and proove that it's not quite so...^^

- So, if the experimenter opens the box - he will observe only one of the two states - <<decay occurred, the cat is dead>> or <<decay not occurred, the cat is alive>>. Schrödinger thought that this paradox proves the inconsistence of the quantum mechanics theory. But we all know that the quantum mechanics really IS the TRUE picture of our world!
- Belin raises his voice again.
- And so, independently of each other (and this partly proves the truth of the theory) - Hans Moravec in 1987 and Bruno Marchal in 1988 cosidered the situation from the cat's point of view!^^

- If Everett's multi-world interpretation is true, every time when the cat experiment takes place - the Universe splits into two universes. In the first universe - the cat is alive, and in the second - dead. The cat stops existing in the worlds where it dies. On the other hand, from the alive cat's point of view - the experiment will be continued and will not lead to the cat's death. This is true because in any branch the cat is capable to observe the experiment only in that world where it stays alive. And if the multi-world interpretation is true, then the cat can only observes that it never dies...
- Belin pauses and looks to the audience...^^

- And so what does this mean, gentlemen? I ask you, what does this mean? Let us imagine that the observer of the experiment explodes an atomic bomb near himself. According to the multi-world interpretation, the observer will destroy himself almost in all parallel universes. But despite of this fact, some small set of alternative universes should exist where the observer somehow survives. And we come to the idea... - Belin raised his voice again. - The Idea of Quantum Immortality!!! ^^

- The Idea of Quantum Immortality is that the observer stays alive and stays capable to observe the reality, at least in one of all set of universes, even if there are very few of these (happy) universes. Thus, eventually the observer will find out that he can live forever!!! ^^

- We all have been working very hard for all this year, guided by the great leadership of...
- at that moment Belin gave a glance to the portraits,
- And I must tell you, gentlemen, that we have enough information in our media center...
- Belin looked at the ceiling, 
- Enough information to prove, I say it again, to prove scientifically by theory and by experiment - to prove the validity of the multi-world interpretation...^^

- But what does it mean for us? You can't see it, but... - Belin looked at his watch
- But in several minutes the train loaded with uranium arrives to the back gates of the institue... It will be enough uranium to provide everyone of you with a nuclear bomb. Since you will assure soon that the Quantum Immortality is the true reality, anyone of you may become an invincible terrorist!!! The Universe will split to many worlds where YOU - Belin points his finger to the audience, - YOU become its dictator and master!!! - Belin almost screamed...^^

The audience could not resist to this speech. Everybody stood up and applauded... Their eyes were burning with some evil fire... O God! This is a kind of delusion! - I thought... My legs didn't obey me. I was sitting at my place and could not move...^^ 

- But let's get back to the point. - Belin said. - Let's continue our experiment. - with these words he took out some alive object from under the table... It was my Barsik...
- Ok, now I'll put this cat to the box and we all will see how she... - I feel red mist blurring my eyes...
	]],
	enter = function(s)
	-- end of episode 2
		eside = nil;
		moika = nil;
		eating = nil;
		kitchen = nil;
		stolcorridor = nil;
		entrance = nil;
		floor2 = nil;
		eroom = nil;
		room33 = nil;
		room3x = nil;
		cor3 = nil;
		toilet3 = nil;
		floor3 = nil;
		toilet = nil;
		toiletw = nil;
		room4x = nil;
		room46 = nil;
		hall42 = nil;
		hall41 = nil;
		floor4 = nil;
		floor5 = nil;
		povardlg = nil;
		kitchendlg = nil;
		facectrl = nil;
	end,
	act = function(s, w)
		if w == 1 then
			set_music("mus/under.s3m");
			return walk('escape1');
		end
	end,
	obj = {
		vobj(1, 'next', '{Next}.'),
	};
};

profdlg = dlg {
	nam = '!!!',
	pic = 'gfx/me.png',
	dsc = 'I grip my strength, stand up and scream as loud as I can...',
	obj = {
		[1] = phr('It\'s not SHE, it\'s HE!', 
	'Belin stops his hand. His sight focuses on me. He recognizes me!! - Security! Unauthorized in the hall!!! Ge.. Get him out of here!!! - he screams.',
	[[poff(2);escape1.obj:add('guardian')]]),
		[2] = phr('Don\'t touch my cat!', 
	'Belin stops and looks me in the eyes. His face expresses a surprise. - Guards!!! Guards!!! Unauthorized in the hall!!!',
	[[poff(1);escape1.obj:add('guardian')]]),
	},
};

profdlg2 = dlg {
	nam = 'Belin',
	pic = 'gfx/prof2.png',
	dsc = 'Belin came white. He stares at the shotgun with a lost sight.',
	obj = {
		[1] = phr('I have come for my cat!', 
	'I grab Barsik from Belin\'s hand and put him to my bosom.',
		[[inv():add('mycat'); lifeon('mycat')]]),
		[2] = phr('Tell them to get out!!!',
	'Belin is white faced. He does not seem to understand me...',
		[[pon(3)]]),
		[3] = _phr('Come on!!! Tell them to get out of here...', 
		'I shake him. Belin does not feel anything. He just stares at the black barrels of the shotgun.',
		[[pon(3); back();]]);
	},
};
gdlg1 = dlg {
	nam = 'guard',
	pic = 'gfx/guard42.png',
	dsc = 'I scream at the guard and find my voice unnatural...',
	obj = {
	[1] = phr('Put your weapon upside down on the table and push it to me..',
		'The guard stares on me with uncertainty..',
		[[pon(2)]]),
	[2] = _phr('I said the gun on the table!!! — I push the barrels more hard to Belin\'s chest. He is very close to fainting.',
	'The guard carefully puts the shotgun on the table and pushes it to me... I take it quickly. Now I\'ve got two guns in both hands.',
		[[pon(3); inv():add('shotgun')]]),
	[3] = phr('You didn\'t like my face? Right???',
		'The guard keeps silence. The sweat comes out on his forehead...',
		[[pon(3); back();]]),
	};
};

shotgun = obj {
	nam = 'guard\'s shotgun',
	inv = 'A pump-action shotgun... For 6 shells. Interesting, how much shells is left?',
	dsc = 'The pump-action {shotgun} lies on the floor.',
	tak = function(s)
		if s._unloaded then
			return 'I don\'t need it. It has no ammo.', false
		end
		return 'I take my shotgun back.';
	end,
};

guardian = obj {
	nam = 'guard',
	dsc = function(s, w)
		if not professor._gun then
			return 'I see how the {guard} with a shotgun slowly but surely moves towards me.';
		end
		if have('shotgun') then
			return 'I see the {guard} with no weapon. He watches me attentively.';
		end
		return 'I see the {guard} holding his gun not confidently.';
	end,
	act = function(s, w)
		if not professor._gun then
			return 'He will get me soon...';
		end
		return walk('gdlg1');
	end,
	used = function(s, w)
		if w == 'shotgun' then
			return 'No, I can\'t make me do it...';
		end
		if w == 'gun' then
			if not professor._gun then
				return 'My shortened shotgun is not for a distant battle...';
			end
			return 'I should point my gun on Belin in my situation. Besides, I will need to reload the gun if I fire...'; 
		end
	end
};

professor = obj {
	nam = 'Belin',
	dsc = function(s, w)
		if not s._gun then
			return '{Belin} is standing at the board and holding my Barsik in his hand.';
		end
		return 'I point both shotgun barrels to the chest of {Belin}.';
	end,
	act = function(s)
		if not s._gun then
			return walk('profdlg');
		end
		return walk('profdlg2');	
	end,
	used = function(s, w)
		if w == 'gun' then
			if s._gun then
				return 'I push the Belin\'s chest with the shotgun even more hard.';
			end
			s._gun = true;
			objs():add('guardian');
			gun._hidden = false;
			return 'I take my shortened shotgun out of my coat, jump over the table and run to Belin.';
		end
	end,
};

pdlg = dlg {
	nam = 'people',
	pic = 'gfx/me.png',
	dsc = 'I look at the audience and scream...',
	obj = {
		[1] = phr('It\'s a lie!!! There\'s no scientific proof at all!!!',
			'— no reaction...',[[pon(2)]]),
		[2] = _phr('The World is unique!!! Everyone of you knows it since childhood!!! Get out of here!! Run from these sectarians!!!', 
		' - the silence was the answer...'),
		[3] = phr('A herd of stupid sheep!!! You can be deceived so easy???',
			'- they keep silence, and I don\'t like their sights...',
			[[pon(3); back();]]),
	},
};

narod = obj {
	nam = 'people',
	dsc = function(s)
		if not professor._gun then
			if seen('guardian') then
				return '{People} in the hall are looking at me questionably. They are in hesitation.';
			end
			return '{People} in the hall are watching for Belin.';
		end
		return '{People} in the hall froze. Their sights are all on me. If I make a mistake - I\'m dead... And the whole world... is dead...';
	end,
	act = function(s)
		if professor._gun then
			return walk('pdlg');
		end
		if seen('guardian') then
			return 'They haven\'t assaulted me so far... So far so good...';
		end
		return 'Fanatics! They all are fanatics...';
	end,
	used = function(s, w)
		if w == 'gun' or w =='shotgun' then
			return 'I think I have not enough shells.';
		end
		return 'Alas...';
	end
};

win = obj {
	nam = 'window',
	dsc = function(s)
		local st = '';
		if s._broken then
			st = ' One window is broken.';
		end
		return 'Three wide {windows} look to the west.'..st;
	end,
	act = 'It\'s dark outside. Nothing to watch but snowflakes bumping the glass.';
	used = function(s, w)
		if w ~= 'gun' and w ~= 'shotgun' then
			return 'Won\'t help...';
		end
		if s._broken then
			return 'Broken already...';
		end
		if not have('shotgun') then
			return 'The guard will shoot me.';
		end
		s._broken = true;
		ways():add('window');
		return 'I break the nearest window by the shotgun butt...';
	end	
};

escape1 = room {
	nam = 'Hall 2',
	dsc = 'I am in the hall. The people here are waiting for the experiment to continue.',
	pic = function()
		if professor._gun then
			return 'gfx/meandgun.png';
		end
		return 'gfx/lection2.png';
	end,
	obj = {
		'win',
		vobj(4, 'lamps', 'The hall is lit by fluorescent {lamps}.'), 
		'professor',
		'narod',
		vobj(5, 'box', 'The {box} is placed on the table.'),
		'portrait',
	},
	act = function(s, w)
		if w == 5 then
			return 'Damned box...';
		end
		if w == 4 then
			return 'Six lamps... I hate this blinking light...';
		end
	end,
	used = function(s, w, ww)
		if ww == 'gun' or ww == 'shotgun' then
			if not professor._gun then
				return 'I\'d better not...';
			end
			if w == 4 then
				return 'The darkness will help not only me, but them too... And they are in a greater number.';
			end
			if w == 5 then
				return 'The poison is still there. I don\'t want to hurt my Barsik.';
			end
		end
	end,
	exit = function(s, t)
		if t == 'window' and not have('mycat') then
			return 'And what about Barsik?', false
		end
		if t == 'cor4' then
			return 'I must do something immediately!', false;
		end
	end,
	way = { 'cor4' },
};
lest = obj {
	nam = function(s, w)
		if s._seen then
			return 'ladder';
		else
			return 'some thing';
		end
	end,
	dsc = function(s, w)
		if s._seen then
			return 'Looking through the snowstorm I hardly can distinguish the fire-escape {ladder}!';
		end
		return 'Looking through the snowstorm I see outlines of some {construction}.';
	end,
	act = function(s, w)
		if not s._seen then
			ways():add('ladder');
			s._seen = true;
			return 'It is the fire-escape ladder!!!';
		end
		return 'Jump or not? This is the question...';
	end,
};

window = room {
	nam = function(s)
		if here() == window then
			return 'on the window sill';
		end
		return 'to the window';
	end,
	pic = 'gfx/fromwin1.png',
	enter = "I know I am mad, but I run to the window... I hear the roar of the crowd behind...";
	dsc = 'I stand on the window sill and look inside the night darkness.',

	obj = {
		'lest',
	},
	exit = function(s, t)
		if t == 'escape1' then
			return 'I can\'t get back... There are fanatics there...', false;
		end
	end,
	way = { 'escape1',},
};


down = room {
	nam = 'down';
};

window5 = obj {
	nam = 'window',
	dsc = function(s, w)
		if s._broken then
			return 'A broken {window} is to the left of me.';
		end
		return 'There is a yellow light coming from a {window} to the left of me.';
	end,
	act = function(s)
		if not s._broken then
			return 'The window is closed...';
		end
		return walk('room5');
	end,
	used = function(s, w)
		if w == 'gun' or w == 'shotgun' then
			if s._broken then
				return 'Already broken...';
			end
			s._broken = true;
			return 'I break out the glass with the shotgun butt... Pieces of the broken glass fall into the night...';
		end
	end
};


up = room {
	_num = 0;
	nam = 'up',
	enter = function(s, w)
		s._num = s._num + 1;
		if s._num == 2 then
			lifeon('ladder');
			return 'Suddenly the night darkness is cut by a ray of spotlight and the silence is broken by a howl of a siren... It seems I was noticed from down there...', false;
		end
		if s._num > 4 then
			ladder.way:del('up');
			ladder.obj:add('window5');
		end
		return 'I am slowly climbing up...', false;
	end
};

ladder = room {
	nam = 'ladder',
	pic = 'gfx/ladder.png',
	dsc = [[I am on the cold ladder. Sharp icy snowflakes hurt my face.]],

	act = function(s, w)
		if w == 1 then
			return 'I will get frozen soon if I don\'t start moving...';
		end
	end,
	obj = {
		vobj(1, 'ladder rails', 'I hold iron ladder {rails}.'),
	};
	enter = function(s)
		inv():del('gun');
		return [[I make a run and jump... My heart collapses for some seconds, but I feel the warmth of Barsik in my bosom and in the next moment my hands catch the black steel... The shotgun falls from my shoulder and flies down...]];
	end,
	way = { 'up', 'down' },
	life = function(s)
		if rnd(2) == 1 then
			return 'I hear rattle of machine guns fire - several bullets hit very close...';
		end
	end,
	exit = function(s, t)
		if t == 'down' then
			if s._shoot then
				return 'They will kill me... And they will kill Barsik too... And they will destroy the whole world...', false;
			end
			lifeon('ladder');
			s._shoot = true;
			return 'I start to come down when suddenly the night darkness is cut by a ray of a spotlight and the silence is broken by a howl of a siren... It seems I was noticed from down there...', false;
		end
		if t ~= 'up' then
			lifeoff('ladder');
		end
	end
};

hand = obj {
	nam = 'bloody hand',
	inv = 'My hand is bleeding... I think I will lose my conscience...',
	life = 'Blood drops are falling on the floor from my hand...',
	used = function(s, w)
		if w == 'galstuk' then
			inv():del('galstuk');
			inv():del('hand');
			lifeoff('hand');
			return 'I bandage my hand with the tie... It\'s ok so far...';
		end
	end
};

computers = obj {
	nam = 'computers',
	dsc = 'The most space is occupied by the tall racks with computer {hardware}. Quiet hum of fans. The network indicators blink nervously.';
	act = function(s)
		if kover._fire then
			return 'So... Burn, evil machines!!! Burn!!! It\'s time to get out of here.';
		end
		return 'This hardware stores evil... I need to destroy it all, but how? I know from the past that the most reliable way to destroy information on magnetic storage - is to bring it through the Curie point. In other words - I should BURN all these damned things!!! But where can I get the fire?';
	end,
	used = function(s, w)
		if w == 'shotgun' then
			return 'Shoot the servers? Not reliable... I must burn this evil...';
		end
	end
};

poroh = obj {
	nam = 'gun powder',
	inv = 'This gun powder should help me.',
};

trut = obj {
	nam = 'tinder',
	inv = 'A piece of paper with gun powder. I think I\'ve got a tinder!!!',
	use = function(s, w)
		if w == 'ibp' and ibp._knife and not ibp._trut then
			ibp._trut = true;
			inv():del('trut');
			return 'I put the tinder on the UPS.';
		end
	end
};

fire = obj {
	nam = 'fire',
	inv = 'The paper burns fast... I must do something right now!!!',

	use = function(s, w)
		if w == 'poroh' then
			return 'It will explode in my hand.';
		end
		if w == 'news' then
			return 'I tear another piece from the newspaper. The flame starts burning it.';
		end
		inv():del('fire');
		if w ~= 'kover' then
			return 'The paper burns out and disappears...';
		end
		if kover._fire then
			return 'I throw the paper on the burning carpet...';
		end
		kover._fire = true;
		return 'I put the paper on the carpet... The nap of the carpet starts burning... I guess the fire is starting...';
	end
};

ibp = obj {
	nam = 'UPS',
	dsc = 'One disassembled {UPS} lies on the floor.',
	inv = function(s)
		if not s._knife then
			return 'This is uninterruptible power supply unit. What should I do with it?';
		end
		local st = '';
		if s._trut then
			st = ' There\'s the paper with gunpowder on the battery.';
		end
		return 'Disassembled UPS. I see contacts leading to the battery...'..st;
	end,
	act = function(s)
		if not have('ibp') then
			if not have('fire') and not kover._fire then
				take('ibp');
				return 'I take UPS again.';
			end
			return 'I don\'t need it anymore.';
		end
		return s:inv();
	end,
	used = function(s, w)
		if not have('ibp') then
			return 'It will not do...';
		end
		if w == 'knife' then
			s._knife = true;
			return 'I unscrew the screws and disassemble UPS. Now I see the contacts leading to the battery...';
		end
		if w == 'provodki' and s._knife then
			if not provodki._knife then	
				return 'The wires are not bare.';
			end
			if not s._trut then
				return 'I connect the wires to the contacts and make a short circuit. The spark comes out. I need a tinder...';
			end
			drop('ibp');
			ibp._trut = false;
			inv():add('fire');
			return 'I connect the wires to the contacts and make a short circuit. The spark comes out. The tinder begins to burn! I\'ve got a fire!!!';
		end
		if w == 'provod' then
			return 'I inserted the wire to the UPS and took it back... Hmm...';
		end
	end,
};

provodki = obj {
	nam = 'thin wires',
	inv = function(s)
		if s._knife then
			return 'A pair of thin wires with bared edges.'
		end
		return 'A pair of thin wires.'
	end,
	used = function(s, w)
		if w == 'knife' and not s._knife then
			s._knife = true;
			return 'I cut the insulation of wire edges and releasing the bare wires.';
		else
			return 'It won\'t work...';
		end
	end
};

provod = obj {
	nam = 'wire from UPS',
	inv = 'This is the wire from UPS.',
	used = function(s, w)
		if w == 'knife' then
			if not knife._oster then
				return 'The knife blade is too blunt...';
			end
			inv():del('provod');
			inv():add('provodki');
			return 'I cut the main insulation and take out two wires.'
		end
	end
};

ups = obj {
	nam = 'ups',
	dsc = '{Uninterruptible power supply units} are placed near every rack.',
	act = function(s)
		if have('hand') then
			return 'My hand is wounded. Bleeding much. I can\'t take an UPS.';
		end
		if not have('ibp') and not seen('ibp') then
			inv():add('ibp');
			inv():add('provod');
			return 'After some work I disconnect one of the UPSes and take it...';
		end
		return 'I have one already.';
	end,
};

kover = obj {
	nam = 'carpet',
	dsc = function(s)
		if s._fire then
			return 'The {carpet} on the floor is burning more and more.';
		end
		return 'The floor is covered with the red {carpet}.';
	end,
	act = 'Useless luxury.',
};

room5 = room {
	nam = 'information center';
	pic = 'gfx/servers.png',
	dsc = [[I am in the big room which occupies all of the south part of the institute.]],
	enter = function(s, f)
		if f == 'ladder' then
			set_music('mus/hybrid.xm');
			lifeon('hand');
			inv():add('hand');
			return 'I jump and catch the window frame. My right hand is in blood. Despite of the pain I jump to the room floor...';
		end
	end,
	exit = function(s, f)
		set_music("mus/under.s3m");
	end,
	act = function(s, w)
		if w == 1 then
			return 'I will not go back... It is cold and too much shooting outside...';
		end
	end,

	obj = { 'computers', 'ups',
		vobj(1, 'window', 'Cold winter wind blows through the broken {window}.'),
		'kover',
		'dout',
		'portrait',
	},
};

dout = obj {
	nam = 'door',
	dsc = function(s)
		return 'Far ahead I can see the exit {door}.';
	end,
	act = function(s)
		if not kover._fire then
			return 'This is the information processing center. I must destroy it to save the world from this infection which resides inside its storages...';
		end
		return 'I run to the door. It leads to elevators. But it has electronic lock!!! This means I need a card with appropriate access level to open the door. Will I burn in fire?';
	end,
	used = function(s, w)
		if not kover._fire then
			return s:act();
		end
		if w == 'card' then
			return 'I bring the card to the door. Beep. Access denied! I\'ll die here!!!';
		end
		if w == 'shotgun' then
			return walk('escape2');
		end
		return 'Won\'t help...';
	end
};

handgdlg = dlg {
	nam = 'guard',
	pic = 'gfx/handhoh.png',
	dsc = 'The guard - a young guy of age 30 - looks at me. He is confused.',

	obj = {
	[1] = phr('Give me your weapon!', 
		'- I have no weapon... - the guard shakes his head... I don\'t know if I can trust him, but I don\'t want to search him...'),

	[2] = phr('I need the key for the red door.', 
		'The guard goes white. - No one has the key for THIS door. - he says. - What a nonsense... - I think.'),

	[3] = phr('Okay! Just stand still and do not move.', 'The guard watches me silently.',
		[[pon(3);back();]]),
	},
};

win5 = obj {
	nam = 'window',
	dsc = function (s)
		if s._broken then
			return 'The winter wind is howling through the broken {window}. Snowflakes whirl on the floor.';
		end
		return 'The wide {window} looks to the west.';
	end,
	act = function(s)
		if not s._broken then
			return 'I come to the window... Interesting. I see that the window looks at quite wide area of the roof, which streches through the front part of the building...';
		end
		return 'The window is broken... The third one for today.';
	end,
	used = function(s, w)
		if s._broken then
			return s:act();
		end
		if w == 'shotgun' then
			s._broken = true;
			ways():add('krysha');
			return 'Oohh.... The third window for today... I swing with all my strength and pieces of the broken glass fly to the roof...'; 
		end
	end,
};

escape2 = room {
	_timer = 0,
	nam = '5th floor site',
	pic = 'gfx/floor5e.png',
	dsc = [[The ceilings are very high on the fifth floor.]],
	enter = function(s, f)
		if f == 'room5' then
			lifeon('escape2');
			return 'With no strength left I hit the hated door with the shotgun butt. But suddenly, in a second I hear someone comes to the door from outside... It is a guard!!! The card reader beeps and the door opens. The guard steps back - his chest is pushed by the pump-action gun of mine. We exit to the elevators site.';
		end
		if f == 'krysha' then
			lifeon('escape2');
		end
	end,
	life = function(s)
		s._timer = s._timer + 1;
		if s._timer == 3 then
		return 'Suddenly a siren sound rang out. - Attention!!! Zero access level individual on the fifth floor! I repeat... - the voice flows from the radio.';
		end
		if s._timer > 3 then
			return '— Zero access level individual on the fifth floor!!! - I\'m getting sick of the siren howling.';
		end
	end,
	act = function(s, w)
		if w == 1 then
			return 'My legs are drowning in the red velvet... Damned luxury!';

		end
		if w == 2 then
			return 'Still, it is made of crystal...';
		end
		if w == 4 then
			return 'The fire is going on...';
		end
		if w == 5 then
			return 'I don\'t think my pass works here.';
		end
		if w == 6 then
			return walk('handgdlg');
		end
	end,
	used = function(s, w, ww)
		if w == 6 then
			return 'I keep targeting the guard.';
		end
		if w == 5 then
			return 'Won\'t help.';
		end
	end,
	obj = {
	vobj(1, 'carpet', 'The elevator site is covered with a red {carpet}.'),
	vobj(2, 'chandelier', 'A crystal {chandelier} hangs on the high ceiling.'),
	'win5',
	vobj(4, 'information', 'The {door} to the information processing center is wide opened. The smoke starts to come out from there.');
	vobj(5, 'red door', 'The opposite {door} has no label. This is a massive door upholstered with red leather.'),
	vobj(6, 'guard', 'The {guard} stands in the center of the site with hands up.');
	},
	way = { 'lift','room5' },
	exit = function(s, t)
		if t == 'room5' then
			return 'There\'s the flame!', false
		end
		if t == 'lift' then
			return 'I notice that all elevator indicators are on. I\'m quite sure that this means the guard troops are coming up here... I should hurry!', false;
		end
		if t == 'krysha' then
			lifeoff('escape2');
		end
	end
};

swin = obj {
	nam = 'south window',
	dsc = 'Smoke is coming out from the south {window}.',
	act = 'Yes, it is one of the windows of the information center. I look at the window and see the flame.',
};

nwin = obj {
	nam = 'north window',
	dsc = function(s)
		local st = '';
		if s._broken then
			st = ' The window is broken.';
		end
		return 'The north {window} shines to the darkness with yellow light.'..st;
	end,
	act = function(s)
		if s._broken then
			return walk('hall5');
		end
		return 'Hmm... I look at the window and see a nice hall.';
	end,
	used = function(s, w)
		if w == 'shotgun' then
			s._broken = true;
			ways():add('hall5');
			return 'Oohh... I hope it\'s the last one??? I swing with my shotgun and break the glass.';
		end
	end,
};

hall5 = room {
	nam = 'hall',
	pic = 'gfx/hall5.png',
	enter = function(s, f)
		if f == 'krysha' then
			return 'I jump to the hall and look around...';
		end
	end,
	act = function(s, w)
		if w == 1 then
			return 'Useless luxury.';
		end
		if w == 2 then
			return 'I run my hand across the surface of one of the columns... Marble!';
		end
		if w == 3 then
			return 'I guess this chandelier made of mountain crystal.';
		end
		if w == 4 then
			return 'Dark... But... What is it? It seems that some train arrived to the back side of the institute.';
		end
		if w == 5 then
			return 'Snowflakes wirl through the broken window.';
		end
		if w == 6 then
			if s.way:srch('escape3') then
				return walk('escape3');
			end
			return walk('gudlg');
		end
		if w == 7 then
			return 'This door is closed. I don\'t think I can open it with my key.';
		end
		if w == 8 then
			return 'Hmmm... Picasso?';
		end
		if w == 9 then
			return 'Terrible weakness posesses all me... No! I must not sleep...';
		end
	end,
	used = function(s, w, ww)
		return 'What for?';
	end,
	dsc = 'The huge and magnificent hall occupies almost all north part of the building!',
	obj = {
		vobj(1,'carpet', 'My feet feel the depth of the red velvet {carpet}.'),
		vobj(2,'columns', 'Eight marble {columns} form a corridor.'),
		vobj(3,'chandelier', 'The great {chandelier} hangs from the ceiling.'),
		vobj(4,'east windows', 'Four {windows} look to the east.'),
		vobj(5,'west windows', 'A broken {window} is to the left of me.'),
		vobj(6,'small door', 'At the north end of the hall I see a small wooden {door}.'),
		vobj(7,'entry door', 'There is the entry {door} behind me.'),
		vobj(8,'paintings', 'Nice framed {paintings} hang on the walls.'),
		vobj(9,'sofas', 'Soft {sofas} are placed along the perimeter.'),
	},
	way = { 'krysha' },
};

krysha = room {
	nam = 'roof',
	pic = 'gfx/krysha.png',
	enter = function(s, f)
		return 'I quickly approach the broken window and a moment later I am on the roof...';
	end,
	dsc = 'It seems that the fifth floor was built after the rest four. Walking on the roof I can reach the first windows of the south and north building parts.',
	obj = {'nwin', 'swin'},
	way = {'escape2'},
};

gudlg2 = dlg {
	nam = 'portrait man',
	pic = 'gfx/pmanb.png',
	dsc = 'I watch his drooping face. It is calm as already.',
	obj = {
		[1] = phr('You got it, freak?',
		'The answer is a hardly heard groan.',
		[[pon(1); back();]]),
		[2] = phr('But why? Why all this?',
		'He raised his head and looked at me. - I just did my job...',
		[[pon(3);poff(1);]]),
		[3] = _phr('What a bullshit?',
		'- And then I became of no use... So - I thought... - The world will pay for this mistake...',
		[[pon(4)]]),
		[4] = _phr('What\'re you saying?',
		'- I worked as a professor... But I was of no use.. I... I could not stand this...',
		[[pon(5)]]),
		[5] = _phr('What a scoundrel...',
		'— But I will make them... Make them... I, I, I - I will live forever... Myself... Alone.',
		[[pon(6)]]),
		[6] = _phr('I think you got crazy...',
		'His body shakes in the corner like in chill.',
		[[pon(1); back()]]),
	}
};

gudlg = dlg {
	nam = 'portrait man',
	pic = 'gfx/pman.png',
	enter = function(s)
		lifeoff('mycat');
		inv():del('shotgun');
		return [[Strange... The door is not closed... I carefully open the door and enter the room. 
^^Suddenly I find that a revolver barrel looks me in the face. - Bravo, bravo! Well done - says a man in an armchair - the owner of the revolver. - I was waiting for you for too long. You are that forester? Well, let's wait for guards. And now - throw your shotgun on the floor. - I cannot do anything, but obey him.]];
	end,
	dsc = [[I see that face - the face from the portraits which hang almost in all rooms of this building. The face is calm and expressing nothing. A slight smile. I need to extend the time... And I ask him:]],

	obj = {
	[1] = phr('Have a talk?',
	'Hmm... So what can we have a talk about? What a talk may be there between me and a... a forester?',
	[[pon(2)]]),
	[2] = _phr('For example, is the Everett interpretation really true?',
	'- Hah hah hah!!! - the man from the portrait laughs unexpressively, - It is not, of course... This is a tale for idiots to make them believe in their own immortality... And maybe...',
	[[pon(3)]] ),
	[3] = _phr('...So, there is no scientific proof at all?',
	'The man stops laughing - ...And maybe... Maybe still it is true? - says the man mysteriously. - So what is true? What do YOU think?',
	 [[pon(4)]]),
	[4] = _phr('I know it\'s a lie!',
	'Do you really know? - the empty eyes look at me - Yes or now? - Suddenly the panic knocks me down.'
	,[[pon(5,9)]]),
	[5] = _phr('IT\'S A LIE!', 
	'And what if? Imagine, what if?... You\'re a hacker, right? You like to predict and to think ahead...',
[[pon(6);poff(9)]]),

	[6] = _phr('No! This cannot be the truth! If it is the truth - then the world is doomed! Sooner or later! Then...',
	'— Yes, you understand correct... Then there is only YOU!!! Listen to yourself. Who gave you this answer? Don\'t you crave it? Doesn\'t your YOU crave it? - I am falling in his abysmal sight.',
	 [[pon(7)]]),
	[7] = _phr('If... If... Then why?',
	'— Right... Right... — says the portrait man suavely... A new wave of fear knocks me down, I fall down on the knees... The heart beats madly and tries to jump out from the chest...',

	[[pon(8)]]),
	[8] = _phr('I can\'t... No...',
	'- And if it is all true, then you have nothing to be afraid of. - he purrs. My heart beats faster. And at last, my chest blows and the soft ball of fur repels by his paws and flies just in the face of the portrait man. A shot rings out. Sharp pain in the left shoulder sobers me and I jump on my feet and rush forward...',
	[[return walk('escape3')]]),
	[9] = _phr('Let\'s assume it is true.',
		'— Well... Right... Think, think... You\'re a hacker, right? — whispers the portrait man to me.',
		[[pon(6);poff(5)]])
	},
};

--shkf = obj {
--	nam = 'край шкафа',
--	inv = 'Я держу в руках край шкафа.',
--};

shkaf = obj {
	nam = 'bookcase',
	inv = 'I hold the corner of the bookcase with my hands.',
	dsc = function(s)
		if s._fall then
			return 'The door is blocked by the {bookcase}.';
		end
		return 'One {bookcase} stands beside the door.';
	end,
	act = function(s)
		if not escape3._guards or s._fall then
			return 'Some books on philosophy... And physics.';
		end
		inv():add('shkaf');
		return 'I gripped the bookcase corner tightly.';
	end,
};

fromw5 = room {
	nam = 'on window sill',
	dsc = 'I stand on the window sill. Icy wind blocks my breathing.',
	pic = 'gfx/fromwin2.png',
	enter = 'Well, I hope it\'s the last time...',
	act = function(s, w)
		if w == 1 then
			return walk('nwall');
		end
	end,
	obj = {
		vobj(1, 'drainpipe', 'I hardly can distinguish a {drainpipe} to the right of me.'),
	},
	way = { 'escape3' },
	exit = function(s, t)
		if t == 'escape3' then
			return 'I must hurry up!', false;
		end
	end
};

winr5 = obj {
	nam = 'window',
	dsc = function(s)
		if s._broken then
			return 'Winter wind breathes through the broken {window}.';
		else
			return 'A {window} looks to the north side.';
		end
	end,
	act = function(s, w)
		if escape3._guards then
			if not shkaf._fall then
				return 'No time to enjoy landscapes... I need to delay the guards.';
			end
			if not have('mycat') then
				return 'Without Barsik? It\'s better to die together!';
			end
--			if not have('revol') then
--				return 'Лучше поднять с пола пистолет, на всякий случай.';
--			end
			if s._broken then
				ways():add('fromw5');
				return walk('fromw5');
			else
				return 'The window is closed.';
			end
		end
		escape3._guards = true;
		lifeon('escape3');
		return 'There is a pure darkness outside the window. I look in the dark, but then I hear the muted noise of someone\'s steps behind... The noise is coming from the hall. I guess the guards are already here! I must do something!';
	end,
	used = function(s, w)
		if escape3._guards and not shkaf._fall then
			return 'No time... The guards will break in here soon...';
		end
		if w == 'shotgun' then
			if not s._broken then
				s._broken = true;
				return 'Again? Well... I swing my shotgun and break the glass. The pieces fly to the dark.';
			end
			return 'This window is already broken.';
		end
	end,
};

revol = obj {
	nam = 'revolver',
	dsc = 'The {revolver} lies on the floor.',
	inv = 'Six bullets.',
	tak = 'I take the revolver from the floor.',
};

escape3 = room {
	nam = 'in the room',
	pic = 'gfx/manroom.png',
	enter = function(s, f)
		if f == 'gudlg' then
			inv():del('mycat');
			hall5.way:add('escape3');
			return 'I hear the noise of a falling gun... Then I hit someone\'s face with all my power. Again and again. Barsik runs around back and forth and anxiously meows.';
		end
	end,
	act = function(s, w)
		if w == 1 then
			return walk('gudlg2');
		end
		if w == 2 then
			return 'Abstract art is not to my taste.';
		end
		if w == 3 then
			local st = '';
			if shkaf._fall then
				st = ' It is blocked by the bookcase.';
			end
			return 'The door to the hall.'..st;
		end
	end,
	used = function(s, w, ww)
		if w == 1 and ww == 'shotgun' or ww == 'revol' then
			return 'Yes - this is evil. But I can\'t shoot a helpless human.';
		end
		if w == 3 and ww == 'shkaf' then
			shkaf._fall = true;
			inv():del('shkaf');
			return 'I push the bookcase and it falls down blocking the door.';
		end
	end,
	dsc = [[I am in a small, but cozy room. A table is placed to the center. A fallen armchair lies near. A small chandelier brings some soft light. Two small bookcases stand along the walls.]],
	obj = {
		vobj(1, 'man', 'The {man} from the portraits sits on the floor leaning against the table. A trickle of blood comes down from his lips. He groans.'),
		vobj(2, 'paintings', 'The walls carry some {paintings}.'),
		vobj(3, 'door', 'The {door} is behind me.'),
		'revol',
		'shkaf',
		'shotgun',
		'mycat',
		'winr5',
	},
	life = function(s)
		if rnd(3) == 1 then
			return 'I hear shots... Bullets break through the door... I must do something...';
		end
	end,
	exit = function(s,t)
		if t == 'hall5' then
			if shkaf._fall then
				return 'The passage is blocked by the bookcase.', false;
			end
			if s._guards then
				return 'I\'ll be shot there...', false;
			end
			s._guards = true;
			lifeon('escape3');
			return 'I\'m going to go to the hall when suddenly the door on the opposite side opens and the guards run in. I quickly shut the door.', false;
		end
		lifeoff('escape3');
	end,
	way = {
		'hall5'
	},
};

nwall = room {
	nam = 'north side',
	dsc = 'I am at the north wall of the institute building.',
	pic = 'gfx/nside.png',
	way = {'eside2','wside' },
	act = function(s, w)
		if w == 1 then
			return 'Yes - a drainpipe... Strong enough. But I doubt I can climb it up.';
		end
	end,
	enter = function(s, f)
		if f == 'fromw5' then
			return 'Overcoming the pain in the left shoulder I jump of the sill and catch the drainpipe... My heart beats madly in my chest while Barsik and I fall into the winter darkness. But in the next moment I slide the drainpipe hurting my palms...';
		end
	end,
	obj = { vobj(1, 'drainpipe',
		'The {drainpipe} stretches along the east corner of the building.')},
	exit = function(s, t)
		if t == 'wside' then
			if not s._guards then
				s._guards = true;
				return 'I look around the corner and see the crowd of guards running out of the checkpoint and moving towards me. - There he is! - I hear them screaming... The rattle of shots makes me to step backward.',
				false;
			end
			return 'They will get me there...', false;
		end
	end
};

eside2 = room {
	nam = 'behind the institute',
	pic = 'gfx/esidee.png',
	dsc = [[ I am at the back wall of the institute building. There's the railway here.]],
	act = function(s,w)
		if w == 1 then
			return 'The machine guns are turned to the south side of the institute perimeter. It\'s better to stay far from them.';
		end
		if w == 2 then
			return 'Hmm... It seems it is that train I\'ve heard about... The unloading haven\'t begun yet. But the gates are already opened.';
		end
		if w == 3 then
			return 'Four railroad vehicles. The type of locomotive - ChME3. The whole train fits to the institute area.';
		end
	end,
	obj = {
	vobj(1,'gun towers', 'The railway entrance is guarded by the gun {towers}.'),
	vobj(3,'train', 'I distinguish a black outline of some {train}.'),
	vobj(2,'gates', 'The big iron {gates} in the institute wall are opened. I see the light pouring out from the doorway.'),
	},
	exit = function(s, t)
		if t == 'sside' then
			return 'The machine guns on the south side make me nervous. Too risky.',
			false
		end
		if t == 'nwall' and nwall._guards then
			return 'No way back...', false;
		end
	end,
	way = {'nwall','train','sside'},
};
function checkloc()
	if p1._off or p2._off then -- battary or switch off off
		p3._off = true;
		p4._off = true;
		p5._off = true;
--		p51._off = true;
--		p6._off = true;
	end
	if p3._off or p4._off then
--		p7._off = true;
--		p71._off = true;
	end
	if p5._off then
		p7._off = true;
	end
	if p51._off then
		p71._off = true;
	end
	if p6._off then
--		p7._off = true;
--		p71._off = true;
	end
	if p7._off then
--		p71._off = true;
	end
end

p1 = obj {
	_off = false,
	nam = 'disconnector',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return 'The VB battery {disconnector} is: ' .. st;
	end,
	act = function(s)
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...';
	end
};

p2 = obj {
	_off = true;
	nam = 'key',
	dsc = function(s)
		local st = 'turned down.';
		if s._off then
			st = 'turned up.';
		end
		return 'The button switches {key} is: '..st;
	end,
	act = function(s)
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'I turn the key.';
	end
};
p3 = obj {
	_off = true,
	nam = 'electro-manometer',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return '{Electro-manometer}: '..st;
	end,
	act = function(s)
		if p1._off or p2._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p4 = obj {
	_off = false,
	nam = 'electro-thermometer',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return '{Electro-thermometer}: '..st;
	end,
	act = function(s)
		if p1._off or p2._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p5 = obj {
	_off = true,
	nam = '2nd section pump',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return 'The 2nd section fuel {pump}: '..st;
	end,
	act = function(s)
		if p1._off or p2._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p6 = obj {
	_off = true,
	nam = 'control',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return 'The {control}: '..st;
	end,
	act = function(s)
		if p1._off or p2._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p7 = obj {
	_off = true,
	nam = '2nd section diesel engine start',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return 'The 2nd section diesel engine {start}: '..st;
	end,
	act = function(s)
		if p3._off or p4._off or p5._off or p6._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p51 = obj {
	_off = true,
	nam = '1st section pump',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return 'The 1st section fuel {pump}: '..st;
	end,
	act = function(s)
		if p1._off or p2._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p71 = obj {
	_off = true,
	nam = '1st section diesel start',
	dsc = function(s)
		local st = 'on.';
		if s._off then
			st = 'off.';
		end
		return 'The 1st section diesel engine {start}: '..st;
	end,
	act = function(s)
		if p3._off or p4._off or p5._off or p6._off or p7._off then
			return 'Strange... Not working.'
		end
		if s._off then
			s._off = false;
		else
			s._off = true;
		end
		checkloc();
		return 'Switching...'
	end
};

p8 = obj {
	_num = 1,
	nam = 'reverser',
	dsc = function(s)
		local st;
		if s._num == 1 then
			st = 'neutral.';
		elseif s._num == 2 then
			st = 'backword.';
		elseif s._num == 3 then
			st = 'forward.';
		end
		return 'The {reverser} handle: ' .. st;
	end,
	act = function(s)
		s._num = s._num + 1;
		if s._num == 4 then
			s._num = 1;
		end
		return 'Switching...'
	end
};

p9 = obj {
	_num = 1,
	nam = 'controller',
	dsc = function(s)
		local st;
		if s._num == 1 then
			st = '0.';
		elseif s._num == 2 then
			st = '1.';
		elseif s._num == 3 then
			st = '2.';
		end
		return 'The {controller} handle: '..st;
	end,
	act = function(s)
		s._num = s._num + 1;
		if s._num == 4 then
			s._num = 1;
		end
		if s._num == 1 then
			return 'Switching...'
		end
		if not p71._off and not p7._off then
			if p8._num == 2 then
				s._num = 1;
				return 'The locomotive trembles and starts moving backwards. I switch the controller to 0.';
			elseif p8._num == 3 then
				lifeoff('mycat');
				set_music('mus/liberty.s3m');
				return walk('theend');
			end
		end
		s._num = 1;
		return 'Nothing happens... I switch the controller to 0.';
	end
};
	
train = room {
	nam = function(s)
		if here() == train then
			return 'in the locomotive';
		end
		return 'to the train';
	end,
	pic = 'gfx/cab.png',
	dsc = 'So, I am in the locomotive. The thick iron reliably saves me from bullets. The engineer cabin seems to be abandoned. I see lots of devices and controls.',
	act = function(s, w)
		if w == 2 then
			if p1._off or p2._off then
				return 'I pressed the horn button, but I heard nothing.';
			end
			return 'I hear a dull whistle. I am a railroad engineer!';
		end
		if w == 1 then
			return 'I really need to start this thing... And no gates will stop me.';
		end
	end,
	life = function(s)
		local st = '';
		if not p7._off or not p71._off then
			st = 'I feel how the locomotive trembles. The diesel engine is working. ';
		end
		if rnd(10) < 5 then
			st = st..'I hear bullets hitting the metal.';
		end
		return st;
	end,
	exit = function(s,t)
		if t == 'eside2' then
			return 'No... It\'s better to stay here! We will resist to the last.',
				false;
		end
		lifeoff('train');
	end,
	enter = function(s, f)
		if f == 'eside2' and not guards1._broken then 
			return cat('Hunched over I run to the train.^^', 
				walk('vorota')), false;
		end
		lifeon('train');
		set_music('mus/hispeed.s3m');
		return 'Hunched over I run to the train... Running past the vehicles I manage to notice the signs <<Beware! High Radiation!>>. A little bit more running and I get to the locomotive. I hear the shot sounds behind. The machine guns on the towers are turning to my direction. I open the heavy door and... I am inside!' 

	end,
	obj = {
		'p2', 'p1', 'p4', 'p3',  'p71','p51', 'p7', 'p5', 'p9', 'p8', 'p6',
		vobj(2, 'horn', 'The locomotive {horn}.');
		vobj(1, 'window', 'I see the closed gates through the {windows}.'),
	},
	way = { 'eside2' },
};

guards1 = obj {
	nam = 'guards',
	dsc = function(s, w)
		if s._broken then
			return 'The {guards} at the tourniquets are trying to get out from under the fallen chandelier.';
		end
		if s._shoot then
			return 'I see the {guards} hiding from my fire behind the tourniquets.';
		end
		return 'I see the {guards} with machine guns moving towards me through the first floor hall.';
	end,
	act = function(s, w)
		if s._broken then
			return 'It seems they are stunned...';
		end
		if s._shoot then
			return 'What a bastards!';
		end
		return 'It\'s amazing I am still alive...';
	end,
	used = function(s, w)
		if w == 'shotgun' or w == 'revol' then
			if s._shoot then
				return 'It\'s useless. The guards are protected by the metal tourniquets.';
			end
			s._shoot = true;
			return 'I look out from the wall and shoot several times by guess.';
		end
	end,
};

lustra1 = obj {
	nam = 'chandeliers',
	dsc = function(s, w)
		if s._broken then
			return 'The ceiling carries one {chandelier}.';
		end
		return 'Two shiny {chandeliers} hang on the ceiling.';
	end,
	act = function(s, w)
		if guards1._shoot then
			return 'One of the chandeliers hang just above the tourniquets.';
		end
		return 'I can\'t help watching them... Perhaps, they are made of crystal?';
	end,
	used = function(s, w)
		if w == 'revol' then
			return 'I doubt this revolver brings any significant damage to the chandeliers.';
		end
		if w == 'shotgun' then
			shotgun._unloaded = true;
			s._broken = true;
			guards1._broken = true;
			lifeoff('vorota');
			drop('shotgun');
			return 'I look out from the wall and fire the shotgun. The shot sound and a loud crash hit my ears. I see one of the chandeliers breaks away the ceiling and slowly starts falling down on the screaming guards. I throw away the useless and unloaded shotgun.';
		end
	end,
	
};

vorota = room {
	nam = 'near the gates',
	pic = 'gfx/shooting.png',
	enter = function(s, f)
		if f == 'eside2' and not guards1._broken then
			lifeon('vorota');
			return 'Reaching the gates I hear the rattle of shots and push myself to the wall.';
		end
	end,
	life = function(s)
		if rnd(6) < 4 then
			return 'Shots ring out. I push myself to the wall.';
		end 
	end,
	act = function(s, w)
		if w == 1 then
			return 'Those tourniquets which had let me inside today. Now I see them from the other side.';
		end
	end,
	dsc = 'I am at the opened gates. They open the way to the first floor of the institute.',
	obj = {
	vobj(1, 'tourniquets', 'I see the row of the {tourniquets}.'),
	'lustra1',
	'guards1',
	},
	exit = function(s, t)
		if not guards1._broken and t == 'train' then
			return 'I rush ahead, but the machine gun shots make me return back.',
			false;
		end
	end,
	way = { 'train', 'eside2' },
};

theend = room {
	nam = 'the epilogue',
	pic = 'gfx/chme3.png',
	dsc = [[I moved the controller handle to the most forward position and the locomotive shaked and started moving ahead. I heard screams and machine gun shots started bumping the cabin walls with new power... But the train moved faster and faster. And soon there was a great clash! It was the gates which could not stand 1350 horsepowers of my train! They broke out of their hinges and were pulled several tens of meters along the railroad...^^

Barsik showed his face out and looked around. I petted his ears as I always did. 
When the bullet sound had disappeared I looked out from the window and watched the institute for the last time. It was burning like a torch. The fire had already captured the whole fifth floor. I looked in the sky... And now - almost in complete darkness - I could see millons of stars shining like dimonds.^^

Very soon, the fields outside were followed by taiga and I could see the friendly outlines of pines and firs changing one another in the rhythm of wheel sound. The wound in the shoulder hurted much and I felt how hard I was tired... I sat on the floor and leaned against the cold iron of the cabin. I was listening the hum of the locomotive and petting my Barsik...^^

Barsik looked at me with his clever eyes and purred like asking me a question. - Back home... - I answered him - We are going back home...^^

THE END^^

 ---^^

The Story and the INSTEAD Engine: ^
Peter Kosyh a.k.a. gl00my // 2009^^

Graphics: ^
Peter Kosyh, some photos are taken from open sources.^^

Music: ^
One fine day // Elwood^
Revelation // necros^
New beginning // Purple Motion^
Ice frontier // Skaven^
Planete football // Frank Amoros^
Underwater world II // Slightly Magic^
Hybrid song // Quazar^
Hispeed - track whatever // Purple Motion^
Liberty // Zapper^^

Testers:^
Sergey Kalichev a.k.a. Pkun^
Vladimir Podobaev a.k.a. zloyvov^^

English Translation:^
Episode 1: tkzv^
Episodes 2 and 3: Vladimir Podobaev^^

If you like the game, the best what you can do - is to write your own history on the INSTEAD engine. :)^^

Acknowledgments:^
To all who haven't been bothering me. :)^^
]],
};

