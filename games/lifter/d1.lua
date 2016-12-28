me()._fall_of_passengers = false; --пассажиры упали
me()._known_death = false; --знание о смерти пассажиров
me()._open_basement = false; --открытый подвал
me()._know_about_burnt = false; --знание, что лампочка перегоревшая
me()._light = 0; --свет в 1-й + 2-й части подвала
me()._elevator_key_p2_pressed = false; --нажата кнопка лифта 2-го подъезда
me()._open_attic_p2 = false; --открытый чердак 2-го подъезда
me()._stepa_escape = false; --спасение Стёпы с чердака
me()._stepa_speak1 = false; --разговор со Стёпой о 79-м доме
me()._know_d79closed1 = false; --знание, что дверь 1 с крыши 79-го закрыта
me()._know_d79closed2 = false; --знание, что дверь 2 с крыши 79-го закрыта
me()._stepa_speak2 = false; --разговор со Стёпой о выходе

--для статуса
game._dom = 77; --номер дома
game._pod = 1; --номер подъезда
game._stat_str2_oth = false; --вторая строка статуса не номер подъезда
game._stat_oth = ''; --вторая строка статуса

--статус о месте
status = stat {
	nam = function()
		if game._stat_str2_oth then
			return 'Дом: '..game._dom..'^ '..game._stat_oth;
		else
			return 'Дом: '..game._dom..'^ Подъезд: '..game._pod;
		end
	end,
};

--сепатор статуса
separator = stat {
	nam = '',
};

--Заставка
screen = room {
	nam = 'Лифтёр',
	dsc = [[Версия: 0.4 (15.07.2013)^^
	Автор: Евгений Анатольевич Ефремов^
	Движок INSTEAD: Петр А. Косых^
	Музыка: Петр Владимирович Семилетов, Евгений Анатольевич Ефремов^^
	Благодарности: Александр Владимирович Шохров, Вероника Николаевна Рубин^^
	Сайт автора: jhekasoft.net^^
	Дата выхода игры: 19.03.2010]],
	enter = music('mus/screen.ogg', 1),
	obj = { vway('Продолжить','{Продолжить}','porch') },
	pic = 'img/screen.png',
};

--Крыльцо дома
porch = room {
	nam = 'Крыльцо',
	dsc = [[Я нахожусь на крыльце подъезда. Я пришёл по вызову. В лифте на 9-м этаже застряли люди.
	Мой напарник Стёпа говорил, что пошёл в шахту ослабить двери лифта. Значит, мне нужно просто
	открыть их вместе с напарником, который должен меня ждать внутри. Инструменты я не брал, они есть у напарника.]],
	way = {'l_enter'},
	enter = music('mus/main.ogg'),
	exit = function()
		inv():add('status', 1);
		inv():add('separator', 2);
	end,
	pic = 'img/porch.png',
};

--Вход
l_enter = room {
	nam = 'Вход в 1-й подъезд 77-го дома',
	enter = function()
		set_music('mus/levels.ogg');
		return walk('level1');
	end,
};

--кнопка вызова лифта
elevator_key = obj {
	nam = 'кнопка',
	dsc = 'Возле дверей расположена {кнопка} вызова лифта.',
	act = 'Не работает.',
};

--двери лифта
elevator_door = obj {
	nam = 'двери лифта',
	dsc = 'Передо мной {двери лифта}.',
	act = 'Обычные двери лифта.',
};

--лампочка 1
bulb1 = obj {
	nam = img('img/bulb1.png')..'лампочка',
	dsc = 'На этом этаже висит {лампочка}, которую можно выкрутить. Вот растяпы, не могли даже выше повесить.',
	tak = 'Я взял лампочку.',
	inv = 'Обычная лампочка, на 60 ватт.',
	use = function(s, w)
		if w == 'chuck' then
			me()._light = me()._light + 1;
			remove('dark', here());
			remove('chuck', here());
			remove('bulb1', me());
			if ways():look('basement') then
				ways():add('p2level1');
			else
				ways():add('basement2');
			end
			return 'Я вкрутил лампочку, и стало светло!';
		end
	end,
};

--лампочка 2
bulb2 = obj {
	nam = img('img/bulb2.png')..'лампочка',
	dsc = 'На этом этаже висит {лампочка}, которую можно выкрутить. Вот растяпы, не могли даже выше повесить.',
	tak = 'Я взял лампочку.',
	inv = 'Обычная лампочка, на 60 ватт.',
	use = function(s, w)
		if w == 'chuck' then
			me()._light = me()._light + 1;
			remove('dark', here());
			remove('chuck', here());
			remove('bulb2', me());
			if ways():look('basement') then
				ways():add('p2level1');
			else
				ways():add('basement2');
			end
			return 'Я вкрутил лампочку, и стало светло!';
		end
	end,
};

--перегоревшая лампочка
burnt_out_bulb = obj {
	nam = function()
		if me()._know_about_burnt then
			return img('img/bulb3.png')..'перегоревшая лампочка';
		else
			return img('img/bulb3.png')..'лампочка';
		end
	end,
	dsc = 'На этом этаже висит {лампочка}, которую можно выкрутить. Вот растяпы, не могли даже выше повесить.',
	tak = 'Я взял лампочку.',
	inv = function()
		if me()._know_about_burnt then
			return 'Оказывается, эта лампочка перегоревшая.';
		else
			return 'Обычная лампочка, на 60 ватт.';
		end
	end,
	use = function(s, w)
		if w == 'chuck' then
			me()._know_about_burnt = true;
			return 'Я вкрутил лампочку, но она не горит. При свете зажигалки я увидел, что она перегоревшая.';
		end
	end,
};

--звонки
bells = obj {
	nam = 'звонки',
	dsc = 'По сторонам расположены {звонки} в квартиры.',
	act = 'Я позвонил в разные звонки на этаже. Но никто не открыл. Странно...',
};

--Выход из подъезда
l_out = room {
	nam = 'Выход из подъезда',
	enter = function()
		if me()._known_death then
			return 'Я пытаюсь выйти, но дверь не открывается. Все мои попытки тщетны! А-а-а! Стоп. Не паниковать. Должен быть другой выход.', false;
		else
			return 'Нет, ещё рано уходить...', false;
		end
	end,
};

--двери лифта 1-го этажа
elevator_door1 = obj {
	nam = 'двери лифта',
	dsc = function()
		if me()._fall_of_passengers then
			return 'Передо мной открытые {двери лифта}.';
		else
			return 'Передо мной {двери лифта}.';
		end
	end,
	act = function()
		if me()._fall_of_passengers then
			me()._known_death = true;
			return 'Я вижу в лифте тех двух пассажиров... Они в крови... Они... О, чёрт! Они мертвы!!!';
		else
			return 'Обычные двери лифта.';
		end
	end,
};

--труба мусоропровода
chute1 = obj {
	nam = 'труба',
	dsc = 'Здесь расположена {труба} мусоропровода.',
	obj = { vobj(1, 'дверца', 'В ней есть {дверца} для выброса мусора.') },
	act = function(s, w)
		if w == 1 then
			return 'Дверца. Можно мусор выбросить. Только у меня нет мусора...';
		else
			return 'Отличная труба. А в нашем подъезде развалилась.';
		end
	end,
};

--труба мусоропровода (без дверцы)
chute2 = obj {
	nam = 'труба',
	dsc = 'Здесь расположена {труба} мусоропровода.',
	act = 'Отличная труба. А в нашем подъезде развалилась.',
};

--1 этаж
level1 = room {
	nam = function()
		if here() == ref('basement') then
			return 'Этаж 1 (1-й подъезд)';
		else
			return 'Этаж 1';
		end
	end,
	dsc = [[Я нахожусь на этаже 1.]],
	way = {'l_out', 'basement', 'level12', 'level2'},
	obj = {'elevator_door1', 'elevator_key', 'bells', 'lock_basement'},
	enter = function()
		game._dom = 77;
		game._stat_str2_oth = false;
		game._pod = 1;
	end,
	pic = function()
		p 'img/level.png;img/level1.png@25,16;img/elevator_key1.png@195,109';
		if me()._fall_of_passengers then
			p ';img/elevator_passengers.png@217,60';
		end
	end,
};

--1-2 этаж
level12 = room {
	nam = 'Площадка между этажами 1-2',
	dsc = [[Я нахожусь на площадке между этажами 1-2.]],
	way = {'level1', 'level2'},
	obj = {'chute1'},
	pic = 'img/levelp.png;img/tr1.png@57,0;img/gr1.png@219,114',
};

--2 этаж
level2 = room {
	nam = 'Этаж 2',
	dsc = [[Я нахожусь на этаже 2.]],
	way = {'level1', 'level12', 'level23', 'level3'},
	obj = {'elevator_door', 'elevator_key', 'bells'},
	pic = 'img/level.png;img/gr02.png@312,15',
};

--2-3 этаж
level23 = room {
	nam = 'Площадка между этажами 2-3',
	dsc = [[Я нахожусь на площадке между этажами 2-3.]],
	way = {'level2', 'level3'},
	obj = {'chute1'},
	pic = 'img/levelp.png;img/tr1.png@57,0;img/gr2.png@219,114;img/gr01.png@128,46',
};

--3 этаж
level3 = room {
	nam = 'Этаж 3',
	dsc = [[Я нахожусь на этаже 3.]],
	way = {'level2', 'level23', 'level34', 'level4'},
	obj = {'elevator_door', 'elevator_key', 'bells', 'bulb1'},
	pic = 'img/level.png;img/elevator_key3.png@197,113;img/gr03.png@322,35',
};

--3-4 этаж
level34 = room {
	nam = 'Площадка между этажами 3-4',
	dsc = [[Я нахожусь на площадке между этажами 3-4.]],
	way = {'level3', 'level4'},
	obj = {'chute1'},
	pic = 'img/levelp.png;img/tr1.png@57,0;img/gr3.png@219,114',
};

--4 этаж
level4 = room {
	nam = 'Этаж 4',
	dsc = [[Я нахожусь на этаже 4.]],
	way = {'level3', 'level34', 'level45', 'level5'},
	obj = {'elevator_door', 'elevator_key', 'bells', 'burnt_out_bulb'},
	pic = 'img/level.png;img/gr04.png@312,45',
};

--диск
disc = obj {
	nam = img('img/disc.png')..'диск',
	dsc = 'На полу лежит {диск}.',
	tak = 'Компакт-диск? Возьму...',
	inv = 'Компакт-диск...',
};

--ручка
pen = obj {
	nam = img('img/pen.png')..'ручка',
	dsc = 'На полу лежит {ручка}.',
	tak = 'Я взял ручку.',
	inv = 'Обычная шариковая ручка...',
};

--4-5 этаж
level45 = room {
	nam = 'Площадка между этажами 4-5',
	dsc = [[Я нахожусь на площадке между этажами 4-5.]],
	obj = {'chute2', 'disc'},
	way = {'level4', 'level5'},
	pic = 'img/levelp.png;img/tr2.png@57,0;img/gr4.png@219,114',
};

--5 этаж
level5 = room {
	nam = 'Этаж 5',
	dsc = [[Я нахожусь на этаже 5.]],
	way = {'level4', 'level45', 'level56', 'level6'},
	obj = {'elevator_door', 'elevator_key', 'bells'},
	pic = 'img/level.png;img/elevator_key5.png@195,111',
};

--зажигалка
lighter = obj {
	nam = img('img/lighter.png')..'зажигалка',
	dsc = 'На полу лежит {зажигалка}.',
	tak = 'Я поднял зажигалку. Может и пригодится где...',
	inv = 'Дешёвая пластмассовая зажигалка.',
	use = function(s, w)
		if w == 'dark' then
			put('chuck', here());
			return 'Немного светлее.';
		elseif w == 'dark2' then
			put('ladder', here());
			remove('dark2', here());
			return 'Так лучше.';
		end
	end,
};

--5-6 этаж
level56 = room {
	nam = 'Площадка между этажами 5-6',
	dsc = [[Я нахожусь на площадке между этажами 5-6.]],
	way = {'level5', 'level6'},
	obj = {'chute2', 'lighter'},
	pic = 'img/levelp.png;img/tr2.png@57,0;img/gr5.png@219,114',
};

--6 этаж
level6 = room {
	nam = 'Этаж 6',
	dsc = [[Я нахожусь на этаже 6.]],
	way = {'level5', 'level56', 'level67', 'level7'},
	obj = {'elevator_door', 'elevator_key', 'bells'},
	pic = 'img/level.png;img/gr02.png@318,27',
};

--6-7 этаж
level67 = room {
	nam = 'Площадка между этажами 6-7',
	dsc = [[Я нахожусь на площадке между этажами 6-7.]],
	way = {'level6', 'level7'},
	obj = {'chute1'},
	pic = 'img/levelp.png;img/tr1.png@57,0;img/gr6.png@219,114',
};

--7 этаж
level7 = room {
	nam = 'Этаж 7',
	dsc = [[Я нахожусь на этаже 7.]],
	way = {'level6', 'level67', 'level78', 'level8'},
	obj = {'elevator_door', 'elevator_key', 'bells', 'bulb2'},
	pic = 'img/level.png;img/elevator_key7.png@196,114;img/gr01.png@322,35',
};

--7-8 этаж
level78 = room {
	nam = 'Площадка между этажами 7-8',
	dsc = [[Я нахожусь на площадке между этажами 7-8.]],
	way = {'level7', 'level8'},
	obj = {'chute1'},
	pic = 'img/levelp.png;img/tr1.png@57,0;img/gr7.png@219,114',
};

--8 этаж
level8 = room {
	nam = 'Этаж 8',
	dsc = [[Я нахожусь на этаже 8.]],
	way = {'level7', 'level78', 'level89', 'level9'},
	obj = {'elevator_door', 'elevator_key', 'bells'},
	pic = 'img/level.png;img/elevator_key3.png@197,113;img/gr03.png@312,45',
};

--8-9 этаж
level89 = room {
	nam = 'Площадка между этажами 8-9',
	dsc = [[Я нахожусь на площадке между этажами 8-9.]],
	way = {'level8', 'level9'},
	obj = {'chute2', 'pen'},
	pic = 'img/levelp.png;img/tr2.png@57,0;img/gr8.png@219,114',
};

--замок чердака
lock_attic = obj {
	nam = 'замок',
	dsc = 'Вверху под потолком навесной {замок}, закрывающий люк на чердак.',
	act = 'Чем бы его открыть?',
};

--замок подвала
lock_basement = obj {
	nam = 'замок',
	dsc = 'На двери, ведущей в подвал, навесной {замок}.',
	act = 'Чем бы его открыть?',
};

--ключ 1
key1 = obj {
	nam = img('img/key1.png')..'ключ 1',
	dsc = 'На полу лежит {ключ 1}.',
	tak = 'Я взял ключ 1.',
	inv = 'Ключ, который используют для навесных замков.',
	use = function(s, w)
		if w == 'lock_basement' then
			me()._open_basement = true;
			remove('lock_basement', 'level1');
			remove('key1', me());
			return 'Получилось!';
		elseif w == 'lock_attic' or w == 'lock_attic_p2' then
			return 'Не подходит...';
		else
			return 'С ключом нужно поаккуратней, он может пригодиться там, где действительно нужен.';
		end
	end,
};

--ключ 2
key2 = obj {
	nam = img('img/key2.png')..'ключ 2',
	dsc = 'Также на полу {ключ 2}.',
	tak = 'Я взял ключ 2.',
	inv = 'Ключ, который используют для навесных замков.',
	use = function(s, w)
		if w == 'lock_attic_p2' then
			me()._open_attic_p2 = true;
			remove('lock_attic_p2', 'p2level9');
			remove('key2', me());
			return 'Получилось!';
		elseif w == 'lock_attic' or w == 'lock_basement' then
			return 'Не подходит...';
		else
			return 'С ключом нужно поаккуратней, он может пригодиться там, где действительно нужен.';
		end
	end,
};

--ключ от чердака 77-го дома 1-го подъезда
--[[key3 = obj {
	nam = 'ключ от чердака',
	inv = 'Ключ от чердака 1-го подъезда 77-го дома.',
	use = function(s, w)
		if w == 'lock_attic' then
			me()._open_attic = true;
			remove('lock_attic', 'level9');
			remove('key3', me());
			return 'Получилось!';
		else
			return 'Не подходит...';
		end
	end,
};]]

--надпись
label77 = obj {
	nam = 'надпись',
	dsc = 'На двери лифта какая-то {надпись}...',
	act = '"Глава 1. Смерть Петра и Олега" — что за бред?!',
};

--двери лифта 9-го этажа
elevator_door9 = obj {
	nam = 'двери лифта',
	dsc = 'Передо мной {двери лифта}.',
	act = function()
		if me()._fall_of_passengers then
			return [[За дверями уже нет пассажиров...]];
		else
			return [[За ними находятся пассажиры. Я слышу их голоса. Надо их оттуда вытащить. Просто с помощью рук не получится. И инструментов нет. Их должен был взять Стёпа.]];
		end
	end,
	obj = {'label77'},
	used = function(s, w)
		if w == 'knife' then
			if me()._fall_of_passengers then
				return 'Уже доигрался с ножом...';
			else
				me()._fall_of_passengers = true;
				return walk('passengers1');
			end
		end
	end,
};

--9 этаж
level9 = room {
	nam = 'Этаж 9',
	dsc = [[Я нахожусь на этаже 9. Странно, но моего напарника Стёпы здесь нет.]],
	way = {'level8', 'level89', 'attic'},
	obj = {'elevator_door9', 'elevator_key', 'bells', 'key1', 'key2', 'lock_attic'},
	enter = function()
		if not me()._fall_of_passengers then
			set_sound("mus/passengers.ogg");
		end
	end,
	pic = 'img/level.png;img/level9.png@1,15;img/gl1label.png@225,81',
};

--Чердак
attic = room {
	nam = 'Чердак',
	enter = function()
		return 'Замок закрывает люк, через который можно попасть на чердак...', false;
	end,
};

--Освобождение пассажиров
passengers1 = room {
	nam = 'Освобождение пассажиров',
	dsc = [[Двери удалось легко раздвинуть ножом. Это означает, что Стёпа был в шахте и ослабил двери лифта. Но где он сейчас?..^^
	Я вижу радостные лица пассажиров... Наконец-то они могут выйти.]],
	obj = { vway('Продолжить','{Продолжить}','passengers2') },
	pic = 'img/passengers.png;img/passengers1.png@99,66',
};

--Падение пассажиров
passengers2 = room {
	nam = 'Падение пассажиров',
	dsc = [[Как вдруг... Нет! Лифт стремительно полетел вниз... Я слышу их крики...^^
	Что случилось?! Трос оборвался?! Надо спуститься вниз и проверить, в порядке ли они. Я убрал руки с дверей лифта, и они закрылись.]],
	obj = { vway('Продолжить','{Продолжить}','level9') },
	enter = music('mus/ext.ogg'),
	pic = 'img/passengers.png;img/passengers2.png@102,67',
	--exit = function()
	--	me()._fall_of_passengers = true;
	--	return true;
	--end,
};

--темнота
dark = obj {
	nam = 'темнота';
	dsc = 'Передо мной одна {темнота}...',
	act = 'Ну и темень!',
};

--патрон (для лампочки)
chuck = obj {
	nam = 'патрон',
	dsc = 'Но я вижу {патрон} для лампочки.',
	act = 'Надеюсь, он подключён.',
};

--Подвал
basement = room {
	nam = 'Подвал';
	dsc = function()
		if me()._light > 0 then
			return 'Сейчас здесь светло.';
		else
			return 'Я нахожусь в подвале 77-го дома. Здесь темно и ничего не видно...';
		end
	end,
	obj = {'dark'},
	way = {'level1'},
	enter = function()
		if me()._known_death then
			if me()._open_basement then
				game._dom = 77;
				game._stat_str2_oth = true;
				game._stat_oth = 'Подвал';
				return true;
			else
				return 'Дверь подвала закрыта на навесной замок.', false;
			end
		else
			return 'Мне совсем не нужно в подвал...', false;
		end
	end,
	pic = function()
		if me()._light > 0 then
			return 'img/basement1.png';
		else
			if seen('chuck') then
				return 'img/basement_l.png';
			else
				return 'img/basement_dark.png';
			end
		end
	end
};

--Подвал2
basement2 = room {
	nam = function()
		if here() == ref('p2level1') then
			return 'Подвал';
		else
			return 'Глубь подвала';
		end
	end,
	dsc = function()
		if me()._light > 1 then
			return 'Сейчас здесь светло.';
		else
			return 'Снова подвал 77-го дома. Здесь темно и ничего не видно...';
		end
	end,
	obj = {'dark'},
	way = {'basement'},
	enter = function(s, w)
		if w == 'p2level1' then
			return 'Я не вернусь в этот ад!', false;
		end
	end,
	pic = function()
		if me()._light > 1 then
			return 'img/basement2.png';
		else
			if seen('chuck') then
				return 'img/basement_l.png';
			else
				return 'img/basement_dark.png';
			end
		end
	end
};

--кнопка вызова лифта 2-го подъезда
p2elevator_key = obj {
	nam = 'кнопка',
	dsc = 'Возле дверей лифта расположена {кнопка} вызова лифта.',
	act = function()
		me()._elevator_key_p2_pressed = true;
		return 'Я вызвал лифт. Двери открылись.';
	end,
};

--двери лифта 2-го подъезда
p2elevator_door = obj {
	nam = 'двери лифта',
	dsc = 'Передо мной {двери лифта}.',
	act = function()
		if me()._elevator_key_p2_pressed then
			me()._elevator_key_p2_pressed = false;
			if here() == ref('p2level1') then
				return walk ('p2level9');
			else
				return walk ('p2level1');
			end
		else
			return 'Обычные двери лифта.';
		end
	end,
};

--Выход из подъезда 2
p2l_out = room {
	nam = 'Выход из подъезда',
	enter = function()
		return 'Я пытаюсь выйти, но дверь не открывается. В этом подъезде она тоже закрыта. Нужно проверить чердак.', false;
	end,
};

--1 этаж 2 подъезда
p2level1 = room {
	nam = function()
		if here() == ref('basement2') then
			return 'Этаж 1 (2-й подъезд)';
		else
			return 'Этаж 1';
		end
	end,
	dsc = [[Я нахожусь на этаже 1.]],
	way = {'p2l_out', 'basement2', 'p2level2'},
	obj = {'p2elevator_door', 'p2elevator_key', 'bells'},
	enter = function(s, w)
		set_music('mus/levels.ogg');
		if w == 'basement2' then
			game._dom = 77;
			game._stat_str2_oth = false;
			game._pod = 2;
			return 'Мне повезло, что дверь подвала открыта. Теперь я во 2-м подъезде!';
		end
	end,
	pic = function()
		p 'img/level.png;img/level1.png@25,16';
		if me()._elevator_key_p2_pressed then
			p ';img/d79elevator.png@217,58';
		end
	end,
};

--2 этаж 2 подъезда
p2level2 = room {
	nam = 'Этаж 2',
	enter = function()
		return 'Я устал ходить. Лучше на лифте.', false;
	end,
};

--замок чердака 2-го подъезда
lock_attic_p2 = obj {
	nam = 'замок',
	dsc = 'Вверху под потолком навесной {замок}, закрывающий люк на чердак.',
	act = 'Чем бы его открыть?',
};

--8 этаж 2 подъезда
p2level8 = room {
	nam = 'Этаж 8',
	enter = function()
		return 'Я устал ходить. Лучше на лифте.', false;
	end,
};

--9 этаж 2 подъезда
p2level9 = room {
	nam = 'Этаж 9',
	dsc = [[Я нахожусь на этаже 9.]],
	way = {'p2level8', 'p2attic'},
	obj = {'p2elevator_door', 'p2elevator_key', 'bells', 'lock_attic_p2'},
	enter = function(s, f)
		if f == 'p2level1' then
			return 'Поехал до самого верха...';
		end
	end,
	pic = function()
		p 'img/level.png;img/level9.png@1,15;img/elevator_key7.png@196,114';
		if me()._elevator_key_p2_pressed then
			p ';img/d79elevator.png@217,58';
		end
	end,
};

--темнота2
dark2 = obj {
	nam = 'темнота',
	dsc = 'И здесь одна {темнота}...',
	act = 'Ну и темень!',
};

--лестница
ladder = obj {
	nam = 'лестница',
	dsc = 'Темно, но еле заметна {лестница} на крышу.',
	act = function()
		return walk('roof');
	end,
};

--Чердак 2-го подъезда
p2attic = room {
	nam = 'Чердак',
	dsc = 'Ну и местечко. Тут вонь.',
	obj = {'dark2'},
	way = {'p2level9'},
	enter = function()
		if me()._open_attic_p2 then
			game._dom = 77;
			game._stat_str2_oth = false;
			game._pod = 2;
			return true;
		else
			return 'Замок закрывает люк, через который можно попасть на чердак...', false;
		end
	end,
	pic = function()
		if seen('ladder') then
			return 'img/p2attic.png';
		else
			return 'img/p2attic_dark.png';
		end
	end,
};

--дверь крыши 77-го дома 1
roof_door1 = obj {
	nam = 'дверь',
	dsc = 'На крыше есть {дверь}, ведущая на чердак 1-го подъезда.',
	act = function()
		if me()._stepa_escape then
			return 'Нет, нам нужно выбираться. Через эту дверь не получится.';
		else
			return walk('roofstepadlg');
		end
	end,
};

--дверь крыши 77-го дома 2
roof_door2 = obj {
	nam = 'дверь',
	dsc = 'Также есть {дверь}, ведущая на чердак 2-го подъезда.',
	act = function()
		if me()._stepa_escape then
			return 'Нет, нам нужно выбираться. Через эту дверь не получится.';
		else
			return walk('p2attic');
		end
	end,
};

--диалог со Стёпой на крыше
roofstepadlg = dlg {
	nam = 'Диалог со Стёпой',
	dsc = 'Я подёргал дверь, но она оказалась закрытой. Постучал. И вдруг услышал голос Стёпы!',
	obj = {
	[1] = phr('Стёпа, это я, Иван. Что происходит?', 'Ванька! Вытащи меня отсюда. Я не могу ничего понять!'),
	[2] = phr('Что с лифтом? Он упал с пассажирами! Они мертвы!', 'Упал? Мертвы?! Как такое возможно?!', [[pon(3,4);]]),
	[3] = _phr('В лифте было два пассажира. Я открыл дверь, но лифт сорвался. И они погибли!', 'Не может такого быть! Лифт должен был затормозить! Там есть амортизаторы!'),
	[4] = _phr('Я ничего сам не пойму... Но ты ослабил двери лифта. Ты был в шахте?', 'Да. Я сделал всё как мы договаривались... А потом... Не помню. Я только сейчас очнулся. Дверь чердака, я так понял, закрыта с той стороны на замок. На крышу вот тоже закрыта с моей стороны на навесной замок. И инструментов нет... Ничего нет.', [[pon(5);]]),
	[5] = _phr('Ты можешь как-нибудь оттуда выбраться?', 'Стоп. Да тут замок детский, дешёвый китайский. Отойди-ка. Сейчас попробую!', [[pon(6);]]),
	[6] = _phr('Давай выбирайся, только осторожно.', '...', [[return walk('stepa_escape')]]),
	},
	pic = 'img/roofstepadlg.png',
};

--Освобождение Стёпы
stepa_escape = room {
	nam = 'Освобождение Стёпы',
	dsc = [[Стёпа сделал несколько ударов, и замок сломался. Дверь распахнулась...^^
	— Получилось! — крикнул Стёпа. — Давай выбираться отсюда!]],
	obj = { vway('Продолжить', '{Продолжить}', 'roof') },
	--enter = music('mus/ext.ogg');
	exit = function()
		put('stepa', ref('roof'));
		me()._stepa_escape = true;
	end,
	pic = 'img/stepa_escape.png',
}

--диалог со Стёпой 1 (когда освобождён)
stepa1dlg = dlg {
	nam = 'Диалог со Стёпой',
	dsc = 'Уставший Стёпа смотрит на меня.',
	obj = {
	[1] = phr('Слушай, Стёп. И в первом, и во втором подъезде двери закрыты!', 'Как закрыты?!', [[pon(2);]]),
	[2] = _phr('Сам удивлён. Поэтому пошли на крышу 79-го дома и попробуем там выбраться. Если, конечно, повезёт: и двери открыты, и замков нет.', 'Ладно, как скажешь.'),
	},
	exit = function()
		me()._stepa_speak1 = true;
	end,
	pic = 'img/stepadlg.png',
};

--диалог со Стёпой 2 (когда нет выхода)
stepa2dlg = dlg {
	nam = 'Диалог со Стёпой',
	dsc = 'Уставший Стёпа смотрит на меня.',
	obj = {
	[1] = phr('Стёпа, двери на этой крыше заперты.', 'Вижу... Сейчас попробую открыть.', [[return walk('our_escape1');]]),
	},
	exit = function()
		me()._stepa_speak1 = true;
	end,
	pic = 'img/stepadlg.png',
};

--Стёпа
stepa = obj {
	nam = 'Стёпа',
	dsc = 'Рядом со мной {Стёпа}.',
	act = function()
		if me()._stepa_speak2 then
			return 'Это Стёпа.';
		elseif me()._know_d79closed1 and me()._know_d79closed2 and here() == ref('d79roof') then
			return walk('stepa2dlg');
		elseif me()._stepa_speak1 then
			return 'Стёпа. Мой напарник. Мы уже с ним поговорили.';
		else
			return walk('stepa1dlg');
		end
	end,
}

--Крыша 77-го дома
roof = room {
	nam = function()
		if here() == ref('roof') then
			return 'Крыша';
		else
			return 'Крыша (77-й дом)';
		end
	end,
	dsc = 'Я на крыше 77-го дома...',
	obj = {'roof_door1', 'roof_door2'},
	way = {'d79roof'},
	enter = function()
		game._dom = 77;
		game._stat_str2_oth = true;
		game._stat_oth = 'Крыша';
	end,
	pic = 'img/roof.png',
};

--дверь крыши 79-го дома 1
d79roof_door1 = obj {
	nam = 'дверь',
	dsc = 'На крыше есть {дверь}, ведущая на чердак 1-го подъезда.',
	act = function()
		me()._know_d79closed1 = true;
		return 'Закрыта.';
	end,
	pic = 'img/d79roof.png',
};

--дверь крыши 79-го дома 2
d79roof_door2 = obj {
	nam = 'дверь',
	dsc = 'Также есть {дверь}, ведущая на чердак 2-го подъезда.',
	act = function()
		me()._know_d79closed2 = true;
		return 'Закрыта.';
	end,
};

--Крыша 79-го дома
d79roof = room {
	nam = function()
		if here() == ref('d79roof') then
			return 'Крыша';
		else
			return 'Крыша (79-й дом)';
		end
	end,
	dsc = 'Это крыша 79-го дома. Он соприкасается с 77-м.',
	obj = {'d79roof_door1', 'd79roof_door2', 'stepa'},
	way = {'roof'},
	enter = function()
		if me()._stepa_speak1 then
			game._dom = 79;
			game._stat_str2_oth = true;
			game._stat_oth = 'Крыша';
			return true;
		elseif me()._stepa_escape then
			return 'Нужно сначала поговорить со Стёпой.', false;
		else
			return 'Нужно здесь всё осмотреть...', false;
		end
	end,
	pic = 'img/d79roof.png',
};

--Выход из дома 1
our_escape1 = room {
	nam = 'Выход из дома',
	dsc = [[Стёпа дёрнул с силой несколько раз дверь, и замок слетел. Дверь открылась.^^
	— Вперёд! — крикнул Стёпа.^^
	Мы побежали...]],
	obj = { vway('Продолжить', '{Продолжить}', 'our_escape2') },
	enter = music('mus/ext.ogg');
	pic = 'img/our_escape1.png',
};

--Выход из дома 2
our_escape2 = room {
	nam = 'Выход из дома',
	dsc = [[Нам повезло. Люк чердака был открыт. Мы спустились на лифте на первый этаж и подошли к двери,
	отделявшей нас от улицы...^^
	Она открылась...]],
	obj = { vway('Продолжить', '{Продолжить}', 'yard') },
	enter = function()
		game._dom = 79;
		game._stat_str2_oth = false;
		game._pod = 1;
	end,
	pic = 'img/our_escape2.png',
};
