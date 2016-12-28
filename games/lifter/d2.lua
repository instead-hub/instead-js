me()._stepa_speak_yard = false; --разговор со Стёпой во дворе
me()._stepa_speak_gl2 = false; --разговор со Стёпой при ремонте лифта
me()._num_patron = 6; --количество патронов в пистолете
me()._num_strikes_hatch = 0; --кол-во ударов по люку
me()._num_try_armature = 0; --кол-во попыток вытащить арматуру
me()._can_try_armature = true; --можно ли вытаскивать арматуру на текущем шаге
me()._pistol_shot = false; --был ли выстрел на текущем шаге
me()._game_over_bad_type = 0; --вид плохого конца

--диалог со Стёпой
stepayarddlg = dlg {
	nam = 'Диалог со Стёпой',
	dsc = 'Вот мы и выбрались. Теперь можно нормально поговорить.',
	obj = {
	[1] = phr('Стёпа, ты точно не помнишь, что с тобой произошло?', 'Да нет! Рылся в шахте, ослабил двери лифта... И всё. А потом очнулся, когда услышал тебя со стороны крыши.'),
	[2] = phr('Может тебя кто-то ударил там, на чердаке?', 'Не знаю. Может и ударили. Но я удар не помню. Как бы там ни было — они стащили инструменты! И закрыли меня там!'),
	[3] = phr('А я не мог выйти из 77-го дома. Там что, двери заклинило?', 'На бред похоже. В двух подъездах заклинило входные двери с кодовым замком.'),
	[4] = phr('Я пробовал звонить в двери жильцам дома. Но... никто не открыл. Правда, я не слышал звук звонка ни в одной двери.', 'А вот тут уже бесовщиной попахивает... Ведь свет в доме-то есть!'),
	[5] = phr('А почему те люди погибли при падении?', 'Может, они просто сознание потеряли? Во всяком случае, они должны были остаться живыми.', [[pon(6);]]),
	[6] = _phr('Я видел надпись на лифте. Там были два имени. Говорилось об их смерти... И пассажиров было двое!', 'Да мало ли что пишут на наших лифтах!', [[pon(7);]]),
	[7] = _phr('Что делать теперь будем?', 'Идём в диспетчерский пункт, всё там расскажем!'),
	},
	exit = function()
		me()._stepa_speak_yard = true;
	end,
	pic = 'img/stepadlg.png',
};

--Стёпа
stepayard = obj {
	nam = 'Стёпа',
	dsc = 'Рядом со мной стоит {Стёпа}.',
	act = function()
		if me()._stepa_speak_yard then
			return 'Это Стёпа. Мы с ним решили пойти в диспетчерский пункт и всё рассказать.';
		else
			return walk('stepayarddlg');
		end
	end,
};

function noenter()
	return function()
		if me()._stepa_speak_yard then
			return 'Нам сюда пока не нужно...';
		else
			return 'Нужно обсудить со Стёпой, куда пойдём.';
		end
	end
end;

--дом 77, п. 1
d77p1 = obj {
	nam = 'подъезд 1',
	dsc = 'Можно пойти в: {подъезд 1},',
	act = noenter();
};

--дом 77, п. 2
d77p2 = obj {
	nam = 'подъезд 2',
	dsc = '{подъезд 2} 77-го дома,',
	act = noenter();
};

--дом 79, п. 1
d79p1 = obj {
	nam = 'подъезд 1',
	dsc = '{подъезд 1},',
	act = noenter();
};

--дом 79, п. 2
d79p2 = obj {
	nam = 'подъезд 2',
	dsc = '{подъезд 2} 79-го дома,',
	act = noenter();
};

--диспетчерский пункт
dispatcher = obj {
	nam = 'диспетчерский пункт',
	dsc = '{диспетчерский пункт}.',
	act = function()
		if me()._stepa_speak_yard then
			return walk('newspaper');
		else
			return 'Нужно обсудить со Стёпой, куда пойдём.';
		end
	end,
};

--Двор
yard = room {
	nam = 'Двор',
	dsc = 'Здесь можно дышать свежим воздухом...',
	obj = {'stepayard', 'd77p1', 'd77p2', 'd79p1', 'd79p2', 'dispatcher', vobj(1, 'кошка', 'Ко мне лащится трёхцветная {кошка}.')},
	act = function(s, w)
		if w == 1 then
			return 'Я погладил кошку — она начала громко мяукать. Стёпа смотрит сердито на неё. Ладно, не до котов сейчас.';
		end
	end,
	enter = function()
		inv():del('status');
		inv():del('separator');
		set_music('mus/main.ogg');
	end,
	pic = 'img/yard.png',
};

--Газета
newspaper = room {
	nam = 'Лучше бы мы ничего не рассказывали...',
	dsc = [[В диспетчерском пункте мы со Стёпой подняли панику. Но зря...^^
	Когда мы пришли в те подъезды, их двери легко открывались. А в первом подъезде 77-го дома в лифте не нашли тех двух пассажиров.^^
	После всего произошедшего нас обвинили в чрезмерном употреблении алкоголя. Про нас написали даже в газете! "Сумасшедшие лифтёры" — так называлась статья.^^
	Но я то знал, что всё было на самом деле. И что это только начало... Ведь там было написано "Глава 1"...^^
	Я даже приобрёл травматический пистолет.^^
	И вот опять вызов в тот самый дом, в тот самый подъезд...]],
	obj = { vway('Продолжить','{Продолжить}','gl2level9') },
	enter = function()
		inv():zap();
		set_music('mus/levels.ogg');
	end,
	pic = 'img/newspaper.png';
};

--травматический пистолет
pistol = obj {
	nam = img('img/pistol.png')..'пистолет',
	inv = function()
		p 'Травматический пистолет. '
		if me()._num_patron == 0 then
			p 'Без патронов.'
		elseif me()._num_patron == 1 then
			p '1 патрон внутри.';
		elseif me()._num_patron <= 4 then
			p (me()._num_patron..' патрона внутри.');
		else
			p (me()._num_patron..' патронов внутри.');
		end
	end,
};

--кнопка вызова лифта
gl2elevator_key = obj {
	nam = 'кнопка',
	dsc = 'Возле них расположена {кнопка} вызова лифта.',
	act = 'Лучше не трогать...',
};

--двери лифта
gl2elevator_door = obj {
	nam = 'двери лифта',
	dsc = function()
		if me()._stepa_speak_gl2 then
			return 'Передо мной закрытые {двери лифта}.'
		else
			return 'Передо мной открытые {двери лифта}.';
		end
	end,
	act = function()
		if me()._stepa_speak_gl2 then
			return 'Надпись: "Глава 2. Смерть Степана" — опять это! Нужно вытащить Стёпу! Нужно открыть двери!'
		else
			return 'Мы уже всё починили. В лифте Стёпа закручивает крышку.';
		end
	end,
	used = function(s, w)
		if w == 'knife' then
			return 'На этот раз нож не поможет. Двери не ослаблены.';
		end
	end,
};

--звонки
gl2bells = obj {
	nam = 'звонки',
	dsc = 'По сторонам расположены {звонки} в квартиры.',
	act = 'Лучше никого не беспокоить без надобности.',
};

--арматура
armature = obj {
	nam = img('img/armature.png')..'арматура',
	dsc = '{арматура},',
	act = function()
		if not me()._stepa_speak_gl2 then
			return 'Арматура...';
		end
	end,
	tak = function()
		if me()._stepa_speak_gl2 then
			return 'Я схватил арматуру.';
		end
	end,
	inv = 'Арматура. Заточена с одного края.',
	use = function(s, w)
		if w == 'gl2elevator_door' then
			return walk('gl2stepaescape');
		end
	end,
	
};

--ящик с инструментами
tools_box = obj {
	nam = 'ящик',
	dsc = 'На полу стоит {ящик} с инструментами.',
	obj = {vobj(1, 'плоскогубцы', 'Сверху в ящике {плоскогубцы},'), 'armature', vobj(2, 'ключ', 'гаечный {ключ}.')},
	act = function(s, w)
		if w == 1 then
			if me()._stepa_speak_gl2 then
				return 'Плоскогубцами не получится!';
			else
				return 'Плоскогубцы...';
			end;
		elseif w == 2 then
			if me()._stepa_speak_gl2 then
				return 'Ключ толстый, не просунуть между дверей!';
			else
				return 'Гаечный ключ...';
			end;
		else
			return 'В этот раз с нами наши инструменты.';
		end
	end,
};

--8 этаж
gl2level8 = room {
	nam = 'Этаж 8',
	enter = function()
		if me()._stepa_speak_gl2 then
			return 'Нет! Нужно спасать Стёпу!', false;
		else
			return 'Лучше никуда не уходить. Мы тут работаем.', false;
		end
	end,
};

--диалог со Стёпой
gl2stepadlg = dlg {
	nam = 'Диалог со Стёпой',
	dsc = 'Кажется, Стёпа прикрутил крышку.',
	obj = {
	[1] = phr('Ну, что там?', 'Готово! Я проверю работу лифта. Прокачусь на нём до 1-го этажа...'),
	},
	exit = function()
		me()._stepa_speak_gl2 = true;
		remove('gl2stepa', 'gl2level9');
		set_music('mus/ext.ogg');
		return [[Стёпа нажал кнопку, и двери лифта начали закрываться. Вдруг... я увидел эту надпись... ^^
		"Глава 2. Смерть Степана" — она была заранее написана. Но открытые двери лифта скрывали её... Нужно спасти Стёпу! Нужно открыть с помощью чего-то двери, пока он жив!]];
	end,
	pic = 'img/stepadlg.png',
};

--Стёпа
gl2stepa = obj {
	nam = 'Стёпа',
	dsc = 'В лифте находится {Стёпа}.',
	act = function()
		return walk('gl2stepadlg');
	end,
};

--9 этаж 77-го 1-го подъезда
gl2level9 = room {
	nam = 'Этаж 9',
	dsc = [[Я нахожусь на этаже 9. Снова здесь...]],
	way = {'gl2level8'},
	obj = {'gl2elevator_door', 'gl2elevator_key', 'tools_box', 'gl2bells', 'gl2stepa'},
	enter = function()
		inv():zap();
		inv():add('knife');
		inv():add('pistol');
		game._dom = 77;
		game._stat_str2_oth = false;
		game._pod = 1;
		inv():add('status', 1);
		inv():add('separator', 2);
		set_music('mus/levels.ogg');
	end,
	pic = function()
		p 'img/level.png;img/level9.png@1,15;img/tools_box.png@178,164';
		if me()._stepa_speak_gl2 then
			p ';img/gl2label.png@228,80';
		else
			p ';img/gl2level9.png@211,52';
		end
	end,
};

--Спасение Стёпы из лифта
gl2stepaescape = room {
	nam = 'Спасение Стёпы',
	dsc = [[Дверь с трудом открылась. Степан удивлённо смотрит на меня.^^
	— Выходи! — крикнул я.^^
	Но Стёпа продолжал стоять. Я вбежал в лифт и вытолкнул его. В этот момент двери лифта захлопнулись.
	Я оказался взаперти.^^
	Ещё мгновенье — и лифт сорвался. Всё как я и ожидал.]],
	obj = { vway('Продолжить','{Продолжить}','elevator') },
	pic = 'img/gl2stepaescape.png',
};

--двери лифта
gl2elevator_door_in = obj {
	nam = 'двери лифта',
	dsc = function()
		if me()._num_strikes_hatch < 3 then
			return 'Передо мной закрытые {двери лифта}.';
		else
			return 'Передо мной открытые {двери лифта}.';
		end
	end,
	act = function()
		if me()._num_strikes_hatch < 3 then
			return 'Думаю, бесполезно пытаться их открыть. Да и открытыми они мне не помогут.';
		else
			return 'Двери...';
		end
	end,
};

--люк
hatch = obj {
	nam = 'люк',
	dsc = 'На крыше лифта есть {люк}.',
	act = function()
		if me()._num_strikes_hatch < 3 then
		 return 'Если я его открою, то смогу пролезть.';
		else
			return 'Побитый люк.';
		end
	end,
	used = function(s, w)
		if w == 'armature' then
			me()._num_strikes_hatch = me()._num_strikes_hatch + 1;
			if me()._num_strikes_hatch < 3 then
				return 'Я ударил, но этого мало. Нужно ещё...';
			else
				inv():del('armature');
				put('armature2', 'hatch');
				put('knife_human', 'gl2elevator_door_in');
				return walk('elevator_down');
			end
		end
	end,
};

--человек с ножами
knife_human = obj {
	nam = 'человек',
	dsc = function()
		if not me()._can_try_armature then
			return 'В дверях стоит страшный {человек} с ножами.';
		else
			return 'В дверях присевший и корчащийся от боли {человек} с ножами.';
		end
	end,
	act = 'Нужно его как-то обезвредить.',
	used = function(s, w)
		if w == 'pistol' then
			if me()._num_patron > 0 then
				me()._num_patron = me()._num_patron - 1;
				me()._can_try_armature = true;
				me()._pistol_shot = true;
				set_sound('mus/shot.ogg');
				return 'Я выстрелил в человека с ножами.';
			else
				return 'У меня закончились патроны. Я не могу стрелять...';
			end
		elseif w == 'knife' then
			me()._game_over_bad_type = 0;
			return walk('game_over_bad');
		elseif w == 'armature2' then
			if me()._pistol_shot then
				return walk('game_over_good');
			else
				me()._game_over_bad_type = 1;
				return walk('game_over_bad');
			end
		end
	end,
};

--Лифт
elevator = room {
	nam = 'В лифте',
	dsc = function()
		if me()._num_strikes_hatch < 3 then
			return 'Я оказался в ловушке... Лифт летит вниз вместе со мной. Нужно что-то быстро сделать.';
		else
			return 'Я в лифте.';
		end
	end,
	obj = {'gl2elevator_door_in', 'hatch'},
	pic = function()
		p 'img/elevator.png';
		if seen('knife_human') then
			if not me()._can_try_armature then
				p ';img/knife_human.png@87,64';
			else
				p ';img/knife_human2.png@87,64';
			end
		end
		if seen('armature2') then
			p ';img/armature_elevator.png@133,13';
		end
	end,
};

--арматура
armature2 = obj {
	nam = img('img/armature.png')..'арматура',
	dsc = 'В люке застряла {арматура}.',
	act = function()
		if me()._num_try_armature < 3 then
			if me()._can_try_armature then
				me()._num_try_armature = me()._num_try_armature + 1;
				me()._can_try_armature = false;
				me()._pistol_shot = false;
				return 'Я пытаюсь вытянуть арматуру, но она крепко застряла. Нужно ещё попытаться.';
			else
				return 'Передо мной чудовище, нужно что-то с ним делать, а не отвлекаться.';
			end
		end
	end,
	tak = function()
		if me()._num_try_armature >= 3 then
			me()._can_try_armature = false;
			me()._pistol_shot = false;
			return 'На этот раз удалось её вытащить! Арматура у меня!';
		end
	end,
	
};

--Падение лифта
elevator_down = room {
	nam = 'Падение лифта',
	dsc = [[Арматура застряла в люке! Я понял, что не успел. В то же мгновение лифт приземлился. От резкого соприкосновения меня качнуло. Я упал...^^
	Вдруг раздался шум за дверями лифта. Они открылись — и я увидел перед собой человека мерзкой внешности с ножами в руках. Вот разгадка всего! Это он убил тех двух пассажиров!^^
	— Где он? Почему ты здесь?! — произнёс он грубым голосом.^
	— Ты не получишь Стёпу! — крикнул я и выстрелил в него из травматического пистолета. Всё-таки он мне пригодился!^^
	Это чудовище присело, корчась от боли. Всё это длилось одно мгновение... Но я не мог бежать и бросить Стёпу. Он был наверху, и я уже слышал его шаги. Нужно что-то делать...]],
	enter = function(s, f)
		if f == 'game_over_bad' then
			me()._num_patron = 6;
			me()._num_try_armature = 0;
			me()._can_try_armature = true;
			inv():del('armature2');
			put('armature2', 'hatch');
			set_music('mus/ext.ogg');
		end
		me()._num_patron = me()._num_patron - 1;
	end,
	obj = { vway('Продолжить','{Продолжить}','elevator') },
	exit = function()
		set_sound('mus/shot.ogg');
	end,
	pic = 'img/elevator.png;img/knife_human.png@87,64;img/armature_elevator.png@133,13',
};

--Конец плохой
game_over_bad = room {
	nam = 'Конец',
	dsc = function()
		if me()._game_over_bad_type == 0 then
			p [[Я попытался ударить это чудовище ножом, но он с лёгкостью отбил мою атаку...^^]];
		else
			p [[Я попытался ударить это чудовище арматурой, но он отбил мою атаку...^^]];
		end
		p [[Я оказался лежащим на полу... Его ножи обрушились на меня...]];
	end,
	pic = 'img/game_over_bad.png',
	enter = music('mus/levels.ogg');
	obj = { vway('Попробовать ещё','{Попробовать ещё}','elevator_down') },
};

--Конец хороший
game_over_good = room {
	nam = 'Конец',
	dsc = [[Я зарядил этому чудовищу по голове арматурой когда он корчился от боли. Он рухнул.^^
	В этот момент спустился Стёпа.^^
	— Кто это?! — спросил он.^^
	— Тот, кто хотел тебя убить! Уходим!^^
	Мы направились к выходу. Выбежали на улицу. Теперь я чувствовал, что всё завершилось... Это был конец...]],
	pic = 'img/game_over_good.png',
	enter = function()
		set_music('mus/main.ogg');
		inv():zap();
	end,
};
