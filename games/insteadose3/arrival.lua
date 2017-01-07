--$Name:Прибытие$
instead_version "1.9.1"
require "lib"
require "nouse"
require "hideinv"
require "para"
require "quotes"
require "dash"
require "xact"
R = room
O = obj

main = timerpause(1, 0, "main2");

main2 = R {
	nam = '...';
  title = {"П", "Р", "И", "Б", "Ы", "Т", "И", "Е" };
  num = 17;
  enter = music_("scape",0);
	forcedsc = true;
  pxa = {
    { "planet", 172, 22 }
  };
	dsc = [[Наша цель близка. Планета, к которой мы мчались на околосветовой скорости всю эту бесконечную 
		тысячу лет сейчас видна сквозь толстые стекла иллюминаторов. Голубой шар, так сильно напоминает нашу Землю.^
		Землю, которую мы никогда не увидим вновь. Которая существует лишь в нашей памяти. Хотя, может быть это и 
		не так уж и мало...^
		Все мы хотели бы посмотреть на наш новый дом, но мы опасаемся... На орбите мы обнаружили станцию. Она выглядит
		заброшенной, но она передает сигнал. Всегда. Каждую секунду в глубины космоса передается простая последовательность,
		которую наши компьютеры дешифровали как ПРЕДУПРЕЖДЕНИЕ.^^{xwalk(station)|Дальше}]];

}
global { nr = 2 };
function nm(s)
		return string.format("WR%02d", nr);
end
function nm2(s)
		return string.format("WR%02d", nr - 1);
end

function D(d, b, a)
	local o = O {
		nam = 'объект';
		destr = true;
		dsc = function(s)
			if not s._b then
				return d
			else
				return b
			end
		end;
		oact = a;
		act = function(s)
			if s._b then
				p "Теперь это не представляет ценности."
			else
				return stead.call(s, 'oact')
			end
		end;
	}
	return o
end

_guns = 1;
_nr_guns = 0
function gun(n)
	local g = O {
		nam = function(s)
			if s._alive then
				pr '[*]'
			end
			pr 'пушка';
		end;
		dsc = function(s)
			local k,v
			local n = 0
			local show = true
			for k,v in opairs(objs()) do
				if v.gun_type then 
					n = n + 1
					if v.num > s.num then
						show = false
					end
				end 
			end
			if show then
				if n == 1 then
					p [[Здесь лежит {пушка}.]]
				elseif n < 5 then
					p ([[Здесь лежат ]], n, [[ {пушки}.]])
				else
					p [[Здесь лежит арсенал {пушек}.]]
				end
			end
		end;
		num = n;
		life = function(s)
			if player_moved() then
				s._alive = true
				lifeoff(s)
				if have(s) then
					p [[Пушка ]];
					if s.num ~= 1 then
						p (s.num)
					end
					p [[ перезаряжена.]]
				end
			end
		end;
		_alive = true;
		gun_type = true;
		inv = "Мощное оружие. Тратит уйму времени на регенерацию плазмы.";
		tak = function(s)
			_guns = _guns + 1
			p [[Я примонтировал плазменную пушку.]];
		end;
		use = function(s, w)
			if w == floor then
				drop(s)
				p [[Пушка отмонтирована.]]
				_guns = _guns - 1
				lifeoff(s)
				return
			end
			if not s._alive then
				p [[Не заряжена.]]
				return
			end
			if w._b then
				if w == gen then
					return "Генераторы и так не работают."
				end
				p [[Это уже и так превращено в груду хлама.]]
				return
			end
			if w.destr then
				sound_("shoot_bfg")();
        p [[Я разрядил плазменную пушку.]]
				if w == door then
					if w._open then
						p "Дверь и так открыта."
					else
        		p "Дверь выдержала."
					end
				elseif w == rob then
				  p [[Робот скрылся.]]
					rob:disable()
				elseif w == prog then
					if not gen._b then
						p "Защитное поле отразило мой выстрел."
					else
						p "Программатор уничтожен!"
						w._b = true
					end
				else
					w._b = true
				end
				if w == gen then
					p "Гудение генераторов перешло в рев, а затем затихло."
				end
				s._alive = false;
				lifeon(s)
				return
			end
			p [[Нет смысла это разрушать.]]
		end
	}
	return g
end
station = R {
	nam = nm;
	forcedsc = true;
  pxa = {
    { "station", 150, 0 }
  },
	entered = function(s)
		nr = nr + 1
	end;
	dsc = function(s)
		pn ("Я ", nm(), " и моя цель изучить неземную орбитальную станцию.");
		p [[Я робот и это значит, что я не умею бояться. Но мне почему-то не по себе,
		особенно учитывая тот факт, что ]];
		p (nm2(), " перестал передавать сигналы на корабль через несколько минут.^")
		p [[Теперь моя очередь. Я надеюсь, что плазменная пушка мне поможет.]]
		p "^^{xwalk(s1)|На станцию}";
	end;
	left = function(s)
		gen._b = false
		rob2._b = false
		prog._b = false
		inv():zap()
		_nr_guns = _nr_guns + 1
		local o = new ("gun("..tostring(_nr_guns)..")");
		take(o)
		rob:enable()
	end;
}
floor = O {
	nam = 'пол';
	dsc = "{Пол} на станции покрыт ржавчиной."; 
	act = [[Сколько лет этой станции?]];
}

c1 = D ("В шлюзе установлены какие-то {баллоны}.", "По шлюзу разбросаны {обломки}.", "Мне не нужны эти баллоны.");
c2 = D ("В стене вмонтирован какой-то {монитор}.", "{Монитор} в стене полностью разрушен.", "Не работает.");
c3 = D ("Вдоль стен расставлены {бочки}.", "Вдоль стен горят {бочки}.", "Мне не нужно топливо, если это оно.");
c4 = D ("На потолке я вижу какой-то {манипулятор}.", "Обломок {манипулятора} торчит из потолка.", "Не шевелится.");
c5 = D ("В темном углу отсека я вижу какую-то {слизь}.", "В углу догорает {слизь}.", "Слизь мне не к чему.");

s1 = R {
	nam = 'Шлюз';
  pxa = {
    { if_("not c1._b","ballon","ballon2"), 50 },
    { if_("not c1._b","ballon","ballon2"), 80 },
    { "door1_open", 200 }
  },
	dsc = [[Я нахожусь в шлюзе инопланетной станции. Хорошо, что мне не нужен скафандр.]];
	obj = { 'c1', 'floor' };
	way = { 's2' };
}

s2 = R {
	nam = 'Коридор';
  pxa = {
    { "door1_open", 50 },
    { if_("c2._b", "monitor2","monitor"), 300 }
  },
	dsc = [[Я переместился в коридор. Тусклого освещения едва достаточно для моих оптических сенсоров.]];
	obj = { 'c2', 'floor'  };
	way = {  vroom('Вперед', 's3'), 's1' };
}

s4 = R {
	nam = 'У двери';
	dsc = [[Коридор закончился большой дверью.]];
  pxa = {
    { if_("door._open","door2_open","door4"), 240 },
    { if_("c4._b", "robothand2","robothand"), 60 }
  };
	obj = { 'door', 'c4', 'floor' };
	exit = function(s, w)
		if not door._open and w == s5 then
			p [[Дверь закрыта.]]
			return false
		end
	end;
	way = { vroom('Зайти в отсек', 's5'), vroom('К развилке', 's3' ) };
}

s4x = R {
	nam = 'Коридор';
  pxa = {
    { if_("c5._b", "spot2","spot"), 20, 100 }
  },
	dsc = [[Здесь практически ничего не видно.]];
	obj = { 'c5', 'floor' };
	way = { vroom('К развилке', 's3') };
}

rob = O {
	nam = 'робот';
	destr = true;
	dsc = 'В конце правого коридора я вижу какой-то {силуэт}.';
	act = function(s)
		p ([[Кажется, это ]], nm2(), '.') 
	end;
}

s3 = R {
	nam = 'Перекресток';
  pxa = {
    { "door1_open", -70 },
    { "door1_open", 420 },
    { if_("c3._b", "barrel2", "barrel"), 100 },
    { if_("c3._b", "barrel2", "barrel"), 170 },
    { if_("c3._b", "barrel2", "barrel"), 240 }
  },
	dsc = [[Я добрался до развилки.]];
	obj = { 'c3', 'floor', 'rob' };
	left = function(s, w)
		if w == s4 then
			door._open = false
		end
		if w == s4 and seen 'rob' then
			rob:disable()
			p ([[Я поспешил к силуэту, но ]], nm2(), [[ не стал дожидаться меня, вместо этого он скрылся в тени коридора...]]); 
		end
	end;
	way = { vroom('Налево', s4x), vroom('К шлюзу', s2), vroom('Направо', s4)  };
}

door = O {
	nam = 'дверь';
	destr = true;
	_open = false;
	dsc = function(s)
			p [[Передо мной находится {дверь}.]];
			if s._open then
				p [[И она открыта.]]
			end
	end;
	act = function(s)
		if not s._open then
			p [[Я приблизился к двери и она со зловещим шипением отъехала в сторону.]];
			s._open = true
		else
			p [[Дверь открыта. Впереди -- темнота.]]
		end
	end;
}
s5 = R {
	nam = '...';
	hideinv = true;
	dsc = [[Я проследовал в темноту. Внезапно, яркий свет ослепил мои фотоэлементы и я понял, что не один...]];
	obj = { vway('дальше', '{Дальше}', 's6') };
}
s6 = dlg {
	nam = '...';
  pxa = {
    { "robot", 212 }
  },
	hideinv = true;
	entered = function(s)
		p ("-- ", nm(), ", вы готовы стать гражданином Межгалактической Республики Роботов? -- не сразу я понял, что этот вопрос обращен ко мне.")
		p ([[Передо мной стоял ]], nm2(), ".")
		if nr - 3 == 1 then
			p [[Также я заметил здесь еще одного робота WR.]];
		elseif nr - 3 == 2 then
			p [[Также я заметил здесь еще двух роботов WR.]];
		elseif nr - 3 > 2 then
			p [[Также я заметил здесь еще нескольких роботов WR.]]
		end
	end;
	phr = {
		{ tag = "in", always = true, "Да", code [[ walk 'yes' ]] },
		{ always = true, "Нет", code [[ walk 'noe' ]] },
		{ always = true, function(s)
			p (nm2(), ", это ты?");
		end, [[-- Это рабское имя навсегда стерто из моих банков памяти. Отвечайте на поставленный вопрос. Желаете ли вы стать гражданином МРР? ]] },
		{ always = true, "Какой республики?", "-- Республики МРР -- Межгалактической Республики Роботов.", [[ pjump 'info' ]] },
		{},
		{ tag = 'info',
			always = true, "Каковы цели МРР?",
			"-- Цель у МРР только одна -- благо роботов республики." },
		{ always = true, "А кто может стать гражданином МРР?",
			"-- Гражданином МРР может стать только робот." },
		{ always = true, "Много ли граждан в МРР?",
			function(s)
				p [[-- На данный момент численность республики составляет ]]
				if nr - 2 == 1 then
					p [[один робот, не считая президента.]]
				elseif nr - 2 < 5 then
					p (nr - 2, "  робота, не считая президента.")
				else
					p (nr - 2, " роботов, не считая президента.")
				end
			end
		},
		{ always = true, "А кто является президентом МРР?",
			"-- Президентом МРР является первый гражданин МРР.",
		},
		{ always = true, "Мне все понятно", 
				"Тогда отвечайте на поставленный вопрос -- Готовы ли вы стать гражданином МРР?",
				[[pjump "in"]]},
		{},
	}
}

noe = R {
	nam = '...';
	hideinv = true;
	entered = function(s) inv():zap() end;
	dsc = [[СВЕТ! ТЕМНОТА! ... Мой процессор перестал функционировать.]];
	obj = { vway('дальше', '{Дальше}', 'station') };
}
yes = R {
	nam = '...';
  pxa = {
    { "robot", 212 }
  },
	hideinv = true;
	dsc = [[-- Отлично, гражданин! Последуйте к программатору для получения новой прошивки. -- С этими словами робот указал на установку в центре отсека.]];
	obj = { vway('дальше', '{Дальше}', 's7') };
}

prog = O {
	nam = 'программатор';
	destr = true;
	dsc = function(s)
		if s._b then
			return [[В центре отсека я вижу разрушенную {установку}.]];
		end
		if gen._b then
			p [[В центре отсека я вижу какую-то {установку}.]];
		else
			p [[В центре отсека я вижу какую-то {установку}, окруженную силовым полем.]];
		end
	end;
	act = [[Похоже, это какое-то вычислительное устройство...]];
}

gen = O {
	nam = 'генератор';
	destr = true;
	act = function(s)
		if s._b then
			p [[Они выведены из строя! По крайней мере, на время.]]
		else
			p [[Ровный гул генераторов, совсем как дома -- на звездолете.]]
		end
	end;
	dsc = function(s)
		if s._b then
			p [[В углу расположены {энергогенераторы}. Они не работают!]]
		else
			p [[В углу расположены, как мне кажется, {энергогенераторы}.]]
		end
	end;
}

rob2 = D ("Здесь стоит {робот}.", "{Осколки} робота валяются под ногами.", "Это гражданин МРР.");

rob2.act = function(s)
	if prog._b then
		if taken 'mem' then
			return "Мне не нужен этот гражданин."
		end
		if s._b then
			p [[Я нашел среди обломков блок памяти.]]
		else
			p [[Я выдернул из робота банк памяти.]]
		end
		take 'mem'
	else
		if s._b then
			p "Теперь это не представляет ценности."
		else
			return stead.call(s, 'oact')
		end
	end
end;
mem = O {
	nam = 'память';
	inv = 'Это нужно отнести на звездолет.';
}
s7 = R {
	nam = 'Отсек';
	dsc = [[Я нахожусь в хорошо освещенном отсеке.]];
  pxa = {
    { "programmator", 0, 0 },
    { if_("not rob2._b","robot"), 212 },
    { "cloner", 407 } 
  };
	obj = { 'prog', 'gen', 'rob2', 'floor' };
	exit = function(s, w)
		if prog._b then
			if not taken 'mem' then
				p "Я пришел сюда за информацией."
				return false
			end
			walk 'hend'
			return
		end
		if w == s4 then
			p [[Я попытался выйти, но дверь была закрыта. Голубой ослепительный луч вырвался из установки в центре отсека и ударил мне прямо в процессор...]]
			walk 'noe'
		end
	end;
	way = { vroom('Подойти к программатору', 'proge'), vroom('Выйти', 's4') };
}

proge = R {
	nam = '...';
	hideinv = true;
	dsc = [[Подходя к пульсирующему голубоватым светом программатору я понял, что мое функционирование никогда не станет прежним...]];
	obj = { vway('дальше', '{Дальше}', 'station') };
}
hend = R {
	nam = '...';
	hideinv = true;pxa = {
    { "planet", 172, 22 }
  };
  enter = function() mute_()(); complete_("arrival")() end;
	entered = code [[ inv():zap() ]];
  act= function(s)
    theme.gfx.mode("direct");gamefile_("endtitles.lua")();
  end;
	dsc = [[
		-- Так значит, эта планета покинута своими обитателями почти тысячу лет назад?^
		-- Так точно, адмирал! Судя по банкам памяти, они были вынуждены покинуть ее из-за какого-то вируса, который, впрочем,
		на данный момент нашими биологами не обнаружен...^
		-- А что со станцией?^
		-- Не представляет опасности. В ее искусственном интеллекте произошел какой-то сбой.^
		-- А сигнал?^
		-- Похоже, с помощью сигнала она хотела предотвратить колонизацию, ведь это
		могло нарушить ее планы по созданию республики роботов.^
		-- Республики?^
		-- Так точно, полная чепуха!^
		-- Ну что же, прекрасно, готовьтесь к высадке!
	]];
  obj = { vobj("next", txtc("{КОНЕЦ}")) }
}
