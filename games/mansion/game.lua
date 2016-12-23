global { track_time = 0 };

music_player = obj {
	nam = 'player';
	var { pos = 15; };
	playlist = { '01.ogg', 0,
		'02.ogg', 0,
		'03.ogg', 0,
		'04.ogg', 0,
		'05.ogg', 0,
		'06.ogg', 1,
		'07.ogg', 0,
		'08.ogg', 0,
		'09.ogg', 0,
		'10.ogg', 1,
		'11.ogg', 0,
		'12.ogg', 0,
		'13.ogg', 0,
		'14.ogg', 0,
		'15.ogg', 1},
	life = function(s)
		if here() == entrance or here() == sside or here() == nside or here() == atmansion then
			add_sound('snd/rain.ogg', 5, 0);
		else
			stop_sound(5);
		end
		if is_music() and ( track_time < 120 or not player_moved() ) then
			return
		end
		track_time = 0
		s.pos = s.pos + 2
		if s.pos > #s.playlist then
			s.pos = 1
		end
		set_music('mus/'..s.playlist[s.pos], s.playlist[s.pos + 1]);
	end
}

game.timer = function(s)
	track_time = track_time + 1
	music_player:life();
end

timer:set(1000)

lifeon(music_player);
function start()
	music_player:life()
end
global { gameover = false }

function takeit(txt)
	return function(s)
		p (txt);
		return true;
	end
end

function lifeonf(s)
	game.lifes:add(s, 1);
end

game.use = function(s, w, o)
	if w.nouse then
		return call(w, 'nouse');
	end
	if o.noused then
		return call(o, 'noused');
	end
	return 'Думаю, это не поможет...'
end

room = stead.inherit(room, function(v)
	v.dsc = stead.hook(v.dsc, function(f, s,...)
		if s.dsc1 and not s._first_dsc then
			s._first_dsc = true
			return call(s, 'dsc1');
		end
		return f(s, ...);
	end)
	return v
end)

door = function(v)
	v.door_type = true
	if not v._opened then
		v._opened = false
	end
	v.useit = function(s)
		s._opened = not s._opened;
		if s._opened then
			path(s.path):enable();
			p [[Я открыл дверь.]]
		else
			path(s.path):disable();
			p [[Я закрыл дверь.]]
		end
	end
	return obj(v);
end

shotgun = obj {
	nam = 'дробовик';
	var { armed = false; flash = false; };
	dsc = [[Над камином висит охотничье {ружье}.]];
	exam = function(s)
		p 'Черные стволы хорошо смазаны. Красивое оружие. На прикладе что-то написано по-немецки.';
		if s.flash then
			p [[К стволам изолентой примотан фонарик.]]
		end
	end;
	take = function(s)
		if on_chair then
			p [[Ружье у меня!]]
			return true
		else
			p [[Слишком высоко, не дотянуться.]];
		end
	end;
	useit = function(s)
		if s.armed then
			p [[Ружье заряжено.]]
		else
			p [[Не заряжено.]];
		end
	end;
	shot = function(s)
		s.armed = false
		add_sound 'snd/gun.ogg'
	end;
	use = function(s, w)
		if w == card then
			if w.locked then
				p [[Я размахнулся и двинул прикладом по стеклу.
				Стекло не выдержало. Я осторожно просунул руку
				и открыл дверь изнутри.]]
				w.locked = false
				add_sound 'snd/glass.ogg'
				return
			end
			p [[Я уже открыл дверь.]]
			return
		end

		if not s.armed then
			return [[Не заряжено.]], false
		end

		if w.slug_type and w:dead() then
			return [[Уже мертво.]]
		end

		if w == slug2 then
			if flash.gun then
				if not flash.on then
					p [[Я включил фонарик, примотанный к ружью и прицелился.]]
					flash.on = true
					lifeon(flash)
				else
					p [[Я навел свет фонарика, примотанного к ружью, на эту гадость.]]
				end
				p [[Звук двойного выстрела разнесся по особняку. Слизень разлетелся на кусочки.]]
				s:shot()
				slug2:kill()
				lifeoff(ladder1)
				make_snapshot()
				return
			end
			if not flash.on then
				p [[Я включил фонарик и проверил -- слизень был на месте.]]
			else
				p [[Я посветил фонариком на ступеньки -- слизень был на месте.]]
			end
			p [[Я не мог целиться в слизня и светить в его сторону фонариком, поэтому мне пришлось убрать фонарик и
				выстрелить почти наугад. Грохот разнесся по дому.
				Я снова посмотрел на лестницу...]]
			flash.on = true;
			lifeon(flash)
			s:shot()
			return
		end
		if w.slug_type then
			s:shot()
			if w._dist > 2 then
				p [[Я выстрелил в слизня и промахнулся.]];
				return
			end
			p [[Я вскинул дробовик и нажал на спусковой крючок. Грохнул выстрел. По разлетающимся во все стороны зеленым ошметкам я понял, что попал.]];
			w:kill();
			if here() == floor2 then
				remove(w)
				put(slug2dead)
				if slug3:dead() and slug4:dead() and slug5:dead() then
					make_snapshot()
				end
			end
			return
		end
		if w == dog then
			if not dog:dead() then
				if dog.down then
					p [[Я разрядил дробовик в мертвое чудовище.]]
				else
					p [[Я вскинул дробовик и разрядил ее в чудовище. Оно вздрогнуло, но продолжило свой бег.]]
					dog.shot = 1
				end
				s:shot();
				return
			end
		end
		if w == tdoor then
			if not dog.down then
				p [[Я прислонил ружье к двери и выстрелил. Разлетающиеся щепки царапнули мое лицо.]]
				if dog.shot == 1 then
					p [[Послышался еще один удар в дверь,
					затем еще один -- слабее. Потом удары прекратились.]];
					dog.down = true
					lifeoff(dog)
				else
					p [[Удары в дверь прекратились, но затем возобновились, казалось, с новой силой.]];
				end
				s:shot()
				return
			end
			p [[Кажется, в этом нет необходимости...]]
			return
		end	
		if w == door34 then
			if not dog.down then
				return [[Пока я буду стрелять в дверь, эта тварь меня съест.]];
			end
			sleeping.broken = true
			w:disable()
			s:shot()
			return [[Я выстрелил из дробовика в замок двери. Глухой звук разнесся по коридору. Сработало!]]
		end;
		if w == spider1 then
			if w:dead() then
				return [[От него и так мало что осталось.]]
			end
			s:shot()
			w:kill()
			remove(vantuz, me())
			return [[Я выстрелил почти не целясь. Просто, направив стволы дробовика на рыжее пятно.
				Ошметки паука вместе с вантузом разлетелись в разные стороны.]]
		end
		if w == luk then
			if not dog.down then
				return [[Пока я буду стрелять в люк, эта тварь меня съест.]];
			end
			s:shot()
			return [[Я выстрелил из дробовика в люк! Несколько щепок разлетелось в стороны.]]
		end;
	end;
	nouse = [[Дробовик здесь не поможет.]];
}

function init()
--	take 'shotgun'
	mode_exam:ini()
end

main = room {
	nam = '';
	pic = 'gfx/intro.png';
	hideinv = true;
	dsc = function(s)
		p [[ -- Иван, я еду в город, задержусь до завтра. Присмотри за братом.^
		 -- Хорошо.^
		 -- На ночь не забудьте закрыть двери.^
		 -- Конечно, отец.^
		 -- Кстати, а где сейчас Андрей?^
		 -- На велике гоняет, полчаса назад видел его...^
		 -- Жаль, не получилось проститься...
		 Ты все-таки присмотри за ним... Приеду так быстро, как смогу...^
		 -- Все будет хорошо, отец...^
		 -- Ладно, я поехал...]];

		if (PLATFORM == 'UNIX' or PLATFORM == 'WIN32') and theme:name() ~= '.' then
			pn()
			pn()
			p (txtem("ВНИМАНИЕ!!! Вы отключили собственные темы игр. Игра будет выглядеть не так, как ее задумал автор."));
		end
	end;
	obj =  { vway('дальше', '{Дальше}', 'title') };
}

title = room {
	nam = 'INSTEAD 2011';
	pic = 'gfx/0.png';
	hideinv = true;
	dsc = [[Вечером, когда мой десятилетний брат не пришел ужинать, я сел на велосипед и поехал
		его искать. Мне кажется, я догадывался, где он мог быть. Начиналась гроза...]];
	obj =  { vway('дальше', '{Начать приключение}', 'entrance') };
}


wall = obj {
	nam = 'ограда';
	dsc = [[Высокая {ограда} ощетинилась острыми железными прутьями.]];
	exam = [[Крепкие стальные прутья, острые на концах.]];
	useit = function(s)
		if on_tree then
			return "Я на дереве."
		end
		if velo.state == 2 then
			p [[Я встал на велосипед и попробовал перелезть через ограду. Острые 
			пики прутьев не дали мне это сделать. Лучше поискать другой путь.]]
			return
		end
		p [[Я попытался перелезть через ограду, но мои руки скользили о мокрые прутья.]];
	end;
}

vorota = obj {
	nam = 'ворота';
	dsc = [[Прямо передо мной расположены закрытые {ворота}.]];
	exam = [[На воротах висит массивный замок.]];
	useit = function()
		if on_tree then
			return "Я на дереве."
		end
		p [[Я попытался толкнуть ворота, но они не поддались.]];
	end
}

mansion = obj {
	nam = 'особняк';
	dsc = [[Сквозь прутья я вижу зловещий силуэт {особняка}.]];
	exam = [[Что и говорить, это здание было заманчивым местом для мальчишки: 
		обнесенное высокой железной оградой оно, казалось, скрывает в 
		себе зловещие тайны...^
		Загадочного жильца особняка у нас видели не часто, изредка он ездил в город на своем черном "ЗиМ"-12,
		вот и все...^
		Но вот уже несколько месяцев здание выглядело заброшенным, и так как никто не видел,
		чтобы обитатели особняка покидали дом, поползли слухи, что жильца
		объявили врагом народа и вывезли его вместе с прислугой под покровом ночи...^
		Мальчишки, понижая голос, рассказывали небылицы об этом доме.
		Не думаю, что кто-то из них действительно был там, за оградой... Так или иначе,
		я должен забрать брата оттуда. Надеюсь, с ним ничего не случилось...]];
}

velo = obj {
	nam = 'велосипед';
	var { state = 1 };
	dscs = { "Под деревом лежит {велосипед}.",
		"Под деревом стоит {велосипед}.",
		"У ограды стоит {велосипед}."};
	dsc = function(s)
		return s.dscs[s.state];
	end;
	exam = [[Сейчас, видя велосипед моего младшего брата, я понимал,
		что об отъезде отца он догадался заранее, и сразу же помчался сюда, к особняку...]];
	take = function(s)
		if on_tree then
			return "Я на дереве."
		end
		s.state = 1
		p "Я взял велосипед."
		return true
	end;
	useit = function(s)
		if have(s) then
			return "Мне не хочется кататься..."
		end
		if s.state == 1 then
			p [[Я задумчиво посмотрел на лежащий велосипед.]]
		else
			p [[Я задумчиво посмотрел на стоящий велосипед.]]
		end
	end;
	use = function(s, w)
		if w == tree then
			p 'Я поставил велосипед у дерева.'
			s.state = 2
			drop(s)
		elseif w == wall or w == vorota then
			p 'Я поставил велосипед у ограды.'
			s.state = 3
			drop(s)
		else
			p "Странное применение для велосипеда..."
		end	
	end
}
global { on_tree = false };
tree = obj {
	nam = 'деревья';
	dsc = [[Порывистый ветер шумит листьями {дерева}.]];
	exam = [[Это старый дуб. Узловатые ветви, переплетаясь, теряются в тумане дождя...]];
	useit = function(s)
		if velo.state ~= 2 then
			return [[Я попытался залезть на дерево, но мне не удавалось допрыгнуть до первых веток,
			а влезть по мокрому узловатому стволу у меня не получилось]];
		end
		if on_tree then
			path('Через ограду'):disable();
			on_tree = false
			return [[Я слез с дерева.]]
		end
		on_tree = true;
		path('Через ограду'):enable();
		return [[Встав на велосипед, я ухватился за ветки и взобрался на дерево.]]
	end
}

entrance = room {
	pic = 'gfx/1.png';
	nam = 'У ограды';
	dsc = [[Я стою перед входом в старинный особняк. Идет дождь.
		Бледный силуэт здания словно растворяется в дымке дождя.]];
	way = { vroom('Через ограду', 'atmansion'):disable() };
	obj =  { 'wall', 'vorota', 'mansion', 'tree', 'velo' };
}

man0 = obj {
	nam = 'особняк';
	dsc = [[Трехэтажное здание {особняка} зловеще возвышается надо мной.]];
	exam = [[Окна первого этажа закрыты решетками. Я задрал голову и посмотрел
	наверх. Свет в окнах не горит.]];
	useit = [[-- Андреееей! -- мой крик потонул в грозе.]];
}

door0 = obj {
	nam = 'вход';
	var { broken = false };
	dsc = [[Дорога, ведущая от ограды к входной {двери},]];
	exam = function(s)
		if s.broken then
			p "Остатки распиленной двери валяются под ногами.";
		else
			p "Думаю, она сделана из дуба. На двери есть звонок.";
		end
		if cap:disabled() then
			p [[Осматривая дверь, я вдруг заметил под ногами какой-то предмет...]];
			cap:enable()
		end
	end;
	useit = function(s)
		if s.broken then
			return "Звонить и стучать уже нет никакого смысла."
		end
		p [[Дверь была заперта. Я несколько раз нажал на звонок и подождал. 
			Потом начал бить в дверь. Это не принесло результата.]]
	end;
};

fountain = obj {
	nam = 'фонтан';
	dsc = [[огибает {фонтан}.]];
	exam = [[Круглый бассейн наполнен водой, которая кажется совсем черной.]];
	useit = function(s)
		p [[Я внимательно обследовал фонтан и обнаружил шланг.]];
		pipe:enable();
	end;
	obj =  { 'cap', 'pipe' };
}

cap = obj {
	nam = 'кепка';
	var { wear = false };
	dsc = [[На лестнице, перед входом в особняк, я вижу какой-то {предмет}...]];
	take = function(s)
		p [[Я нагнулся и поднял что-то с лестницы. Это была кепка моего брата.
		Отец подарил ее Андрею совсем недавно. Я стиснул зубы. Надо будет отдать
		ее, когда я найду своего брата.]]
		return true
	end;
	exam = function(s)
		if have(s) then
			return [[Кепка моего брата. Я должен вернуть ее ему.]]
		end
		p [[Что-то небольшое.]]
	end;
	useit = function(s)
		if not have(s) then
			return [[Сначала надо это взять.]]
		end
		s.wear = not s.wear;
		if s.wear then
			p [[Я подумал немного и надел кепку.]];
		else
			p [[Я снял кепку.]]
		end
	end;
	use = function(s, w)
		if w == brother then
			return [[Сейчас ему не нужна его кепка.]]
		end
	end;
	nouse = [[Это кепка моего брата!]];
}:disable();

pipe = obj {
	nam = 'шланг';
	dsc = [[Я вижу {шланг}, лежащий около фонтана.]];
	exam = [[Длинный резиновый шланг подсоединен к железной 
		трубе возле фонтана. Скорее всего, он здесь для поливки
		цветов.]];
	useit = [[Нет смысла поливать цветы, и так идет дождь.]];
	take = [[Мне не нужен этот длинный шланг. К тому же он намертво приделан к трубе.]];
}:disable();

lclumbs = obj {
	nam = 'левые клумбы';
	dsc = [[{Слева} и]];
	exam = [[По-моему, цветы завяли...]];
	take = [[Мне это не нужно.]];
	useit = function(s)
		if not nognicy:disabled() then
			return [[Я прошелся вдоль клумб, но не нашел ничего интересного.]];
		end
		p [[Я прошелся вдоль клумб. На земле, у самой дороги я заметил
		 ножницы.]]
		nognicy:enable()
	end;	
}

tube = obj {
	nam = 'шланг';
	exam = 'Кусок резинового шланга.';
	useit = [[Как его можно использовать?]];
	use = function(s, w)
		if w == bak then
			inv():del(s)
			w.tube = true
			p [[Я открыл дверцу бака и воткнул в него шланг.]] 
			return
		end
		p [[Шлангом?]]
	end
}

nognicy = obj {
	nam = 'ножницы';
	dsc = 'У левой клумбы на земле лежат садовые {ножницы}.';
	exam = 'Садовые ножницы. Острые -- надежный инструмент!';
	take = takeit [[Я поднял ножницы с земли.]];
	useit = function(s)
		if not have(s) then
			return  [[Сначала их нужно взять.]]
		end
		return [[Я пощелкал ножницами.]]
	end;
	use = function(s, w)
		if w == pipe then
			if  not taken 'tube' then
				p [[Я отрезал ножницами кусок шланга.]]
				take 'tube'
				return
			end
			return [[Мне больше не нужен шланг.]]
		end
		if w == brother then
			if w.web then
				w.web = false
				return [[Не без труда я разрезал мерзкие нити паутины.]]
			end
			return [[Я уже освободил брата от паутины.]]
		end
	end;
	nouse = [[Разрезать?]];
}:disable();

rclumbs = obj {
	nam = 'правые клумбы';
	dsc = [[{справа} вокруг фонтана я вижу клумбы с цветами.]];
	exam = [[Похоже, это были розы...]];
	take = [[Мне это не нужно.]];
	useit = [[Я прошелся вдоль клумб, но не нашел ничего интересного.]];
	obj = { 'nognicy' };
}

atmansion = room {
	nam = 'Перед особняком';
	pic = function(s)
		if door0.broken then
			return 'gfx/2b.png'
		else
			return 'gfx/2.png'
		end
	end;
	entered = function(s, f)
		if f == entrance then
			return [[По ветвям дерева я забрался на ограду и спустился с
			той стороны. В последний момент я вдруг понял, что видимо допустил
			ту же ошибку, что и мой брат -- я не подумал о том, как вернуться назад...^
			Ладно, главное найти брата, а там посмотрим...]]
		end
	end;
	dsc = [[Перед зданием особняка.]];
	way = { vroom('Северная сторона', 'nside'), 
		vroom('В особняк', 'inmansion'):disable(), 
		vroom('Южная сторона', 'sside')};
	obj = { man0, door0, fountain, lclumbs, rclumbs};
}
lamberts = obj {
	nam = 'бревна';
	dsc = 'У ограды я заметил сложенные {бревна}.';
	exam = 'Наверное, в доме есть камин...';
	take = 'Таскать с собой бревно?';
	useit = 'Я толкнул пару бревен, и они скатились вниз...';
}

pila = obj {
	nam = 'бензопила';
	var { fuel = false; on = false; };
	dsc = 'Рядом с бревнами лежала {бензопила}.';
	exam = 'Бензопила "Дружба". 12 килограмм полезного веса!';
	take = function(s)
		p [[Я взял бензопилу.]];
		return true
	end;
	ini = function(s)
		if s.on and not gameover then
			add_sound ('snd/chain2.ogg', 3, 0)
		end
	end;
	useit = function(s)
		if not s.fuel then
			return [[Я попытался завести бензопилу, но у меня это не получилось.
				Заглянув в бак, я с сожалением отметил, что бензина в нем нет.]]
		end
		s.on = not s.on
		if s.on then
			p [[Я дернул за стартер и бензопила с шумом завелась. Запах
			бензина будоражил мою кровь.]]
			lifeon(s)
			add_sound 'snd/chain.ogg'
		else
			stop_sound(3)
			p [[Я заглушил бензопилу.]]
			lifeoff(s)
		end
	end;
	life = function(s)
		if player_moved() then
			s.on = false
			p [[Я заглушил бензопилу.]]
			stop_sound(3)
			lifeoff(s)
		else
			if not gameover then
				add_sound ('snd/chain2.ogg', 3, 0)
			end
			return [[Звук мотора бензопилы, работающего на низких оборотах, успокаивает.]]
		end
	end;
	use = function(s, w)
		if w == card then
			if w.locked then
				p [[Я размахнулся и двинул всей массой бензопилы по стеклу.
				Конечно, стекло не выдержало. Я осторожно просунул руку
				и открыл дверь изнутри.]]
				w.locked = false
				add_sound 'snd/glass.ogg'
				return
			end
			p [[Я уже открыл дверь.]]
			return
		end
		if w == bak then
			if w.tube then
				p [[Я всосал немного бензина и затем воткнул шланг в бак
				бензопилы. Я заправил бензопилу.]]
				s.fuel = true
				return
			end
			return [[Чтобы заправить бензопилу таким образом, мне нужно
				перевернуть машину...]]
		end
		if not s.on then
			return [[Бензопила не запущена.]], false
		end
		if w == door0 then
			if w.broken then
				p [[Я уже распилил это.]]
				return
			end
			p [[Недолго думая, я принялся пилить дверь. 
				Бензопила ревела, щепки и стружка летели мне в лицо, я вдыхал запах
				выхлопов...
				Наконец, я опустил пилу. Дело было сделано.]];
			w.broken = true
			path 'В особняк':enable()
			add_sound 'snd/chain3.ogg'
			return
		end
		if w == kotel0 then
			return [[Вопреки расхожему мнению, бензопила пилит дерево, а не металл.]]
		end
		if w.door_type then
			if w.locked then
				w.locked = false
				p [[Недолго думая я принялся пилить дверь. 
					Бензопила взревела... Распилить эту дверь оказалось проще, чем входную...]]
				return 
			end
			return [[Может быть лучше просто открыть?]]
		end
		if w == vetkid then
			return "Я уже отпилил их."
		end
		if w == vetka then
			if not vetka.seen then
				p [[Я ударил движущимся полотном пилы по страшным щупальцам, что сжимали меня. Звук пилы перешел в визг, щупальца резко дернулись и ослабили хватку.]];
			else
				p [[Я ударил движущимся полотном пилы по страшным ветвям. Звук пилы перешел в визг, ветви резко дернулись и ослабили хватку.]];
			end
			p [[Запахло каким-то неприятным кисло-сладким приторным запахом.]]
			vetkid:enable()
			lifeoff(w);
			w:disable();
			add_sound 'snd/chain3.ogg'
			return
		end
		if nameof(w) == 'растения' then
			if seen (vetka) then
				return 'Я не дотянусь до них!'
			end
			if not tree_attack then
				return 'Да, мне не нравятся эти деревья, но зачем тратить бензин?';
			end
			if tree_dead then
				return 'Я уже все сделал.'
			end
			tree_dead = true
			add_sound 'snd/chain3.ogg'
			return [[Я осторожно подошел к деревьям держа работающую бензопилу наготове. Узловатые ветви потянулись ко мене,
				но я был готов. Бензопила ревела, запах бензина заполнял оранжерею... Через некоторое время все было кончено...]];
		end
		if w == lamberts then
			p [[Мне не нужны дрова.]]
			return
		end
		if w == kotelshelf then
			if w.broken then
				return [[Уже нет смысла это пилить.]]
			end
			w.broken = true
			add_sound 'snd/chain3.ogg'
			return [[Распилить стеллаж не заняло много времени.]]
		end
		if w == doska then
			return [[Зачем мне пилить доску?]]
		end
		if w == door34 then
			if not dog.down then
				return [[Пока я буду пилить дверь, эта тварь меня съест.]];
			end
			sleeping.broken = true
			w:disable()
			add_sound 'snd/chain3.ogg'
			return [[Я принялся пилить дверь. У меня уже был опыт, поэтому в этот раз я справился быстрее.]]
		end
		if w == dog then
			if dog:dead() then
				return [[Я не мясник.]]
			end
			if not dog.down then
				gameover = true
				lifeoff(dog)
				walkin 'dogend'
				add_sound 'snd/chain3.ogg'
				return [[Я попытался встретить эту тварь бензопилой... Но она была слишком быстра, 
					я только успел отпилить ее левую лапу, перед тем, как огромная туша навалилась на меня...]]
			end
			dog.killed = true
			add_sound 'snd/chain3.ogg'
			make_snapshot();
			return [[Теперь я был уверен, что чудовище не причинит мне вреда.]]
		end
		if w == spider1 then
			if w:dead() then
				return [[От него и так мало что осталось.]];
			end
			gameover = true
			p [[Я попытался атаковать паука пилой, но не успел.]];
			lifeoff(spider1)
			stop_sound(3)
			walkin 'spiderend2'
			return 
		end
	end;
	nouse = [[Бензопила полезная вещь, но здесь она не поможет.]];
}

kotel0 = obj {
	nam = 'подвал';
	var { opened = false };
	dsc = [[Здесь находится {вход}, ведущий в подвальные помещения.]];
	exam = [[Потрескавшиеся ступеньки ведут вниз и упираются в железную дверь с надписью "Котельная".]];
	useit = function(s)
		if s.opened then
			p [[Дверь открыта.]]
		else
			p [[Дверь закрыта.]]
		end
	end;
}

nside = room {
	nam = 'Северная сторона';
	pic = 'gfx/3.png';
	entered = function(s, f)
		if f == atmansion then
			p [[Я обошел особняк с северной стороны.]];
		end
	end;
	obj = { 'kotel0', 'lamberts', 'pila' };
	way = { vroom('К фронтальной стороне', 'atmansion'), vroom('В подвал', 'kotel'):disable() };
}

car = obj {
	nam = 'машина';
	dsc = [[Рядом, на дороге, стоит черная {машина}.]];
	exam = [[Газ 12. Девяносто лошадиных сил.]];
	useit = function(s)
		if have(mkeys) then
			return [[У меня есть ключи!! Но я не уеду отсюда один.]];
		else
			return [[У меня нет ключей от машины.]]
		end
	end
}

bak = obj {
	nam = 'бак';
	var { tube = false };
	dsc = [[Сзади расположен {бак}.]];
	exam = function(s)
		if s.tube then 
			p [[Из бака торчит трубка.]];
		else
			p [[Думаю, машина заправлена.]];
		end
	end;
	useit = [[Я заглянул в бак. Пахнет бензином...]];
}:disable();

kuzov = obj {
	nam = 'кузов';
	dsc = [[Всполохи молний отражаются бликами на ее черном {кузове}.]];
	exam = function(s)
		p [[На кузове я вижу дверцу бака.]];
		bak:enable()
	end;
	obj = { 'bak' };
}

card = obj {
	nam = 'двери';
	var { locked = true; };
	dsc = [[Хромированные ручки {дверей} блестят даже в вечерних сумерках.]];
	exam = function(s)
		p [[Красивая машина.]];
		if not s.locked then
			p [[Только стекло выбито.]]
		end
	end;
	useit = function(s)
		if s.locked then
			p [[Я подергал ручку двери. Закрыто.]];
			return
		end
		if have(mkeys) then
			return [[У меня есть ключи от машины, я думаю ворота теперь не помеха, но уезжать без брата я не собираюсь.]];
		end
		walkin 'incar'
	end;
}

sside = room {
	nam = 'Южная сторона';
	pic = 'gfx/4.png';
	entered = function(s, f)
		if f == atmansion then
			p [[Я обошел особняк с южной стороны.]];
		end
	end;
	obj = { 'car', 'kuzov', 'card' };
	way = { vroom('К фронтальной стороне', 'atmansion') };
}

light = obj {
	nam = 'зажигалка';
	dsc = [[В бардачке лежит {зажигалка}.]];
	exam = [[Красивая, дорогая зажигалка.]];
	take = function()
		p [[Я взял зажигалку.]]
		return true
	end;
	useit = function(s)
		if have(s) then
			return [[Работает!]];
		end
		p [[Я ее еще не взял.]]
	end;
	use = function(s, w)
		if w == podsobka then
			p [[Я включил зажигалку и осмотрел подсобку.]];
			w:enable_all();
			return
		end
		if w == acid or w == acid2 then
			gameover = true
			stop_sound(3)
			return walkin 'lightend'
		end
		if w == dihlo then
			if not w.on then
				p [[Если поджечь баллончик, он взорвется.]]
				return
			else
				if w.fire then
					return [[Уже нет необходимости делать это.]]
				end
				w.fire = true
				w.step = 4
				return [[Я осторожно поднес зажигалку к струе и поджег ее!!!]];
			end
		end
		if w == ladder1 then
			p [[Света зажигалки недостаточно, чтобы рассмотреть верхние темные ступеньки лестницы, но мне кажется, что там что-то есть...]]
			return
		end
		if w == kamin then
			p [[Можно, конечно, разжечь камин, но не вижу особенного смысла терять время.]]
		end
		if w == hbook or w == hobelens or w == port2 then
			p [[Боюсь, зажигалки не хватит.]]
			return
		end
		if w == kandelabr then
			if w.light then
				p [[Уже горит.]]
			else
				p [[Я зажег свечу, но стало не намного светлее...]];
				w.light = true
			end
			return
		end
		p [[Я не хочу это поджигать.]]
	end
}:disable();

wheel = obj {
	nam = 'Руль';
	dsc = [[Мои руки сами легли на обделанный кожей {руль}.]];
	exam = [[Машина не роскошь, а средство.]];
	useit = [[Я немного покрутил руль.]];
}

bard = obj {
	var { opened = false };
	nam = 'бардачок';
	dsc = 'Справа от меня находится {бардачок}.';
	exam = function(s)
		if s.opened then
			p [[Бардачок открыт.]];
		else
			p [[Бардачок закрыт.]];
		end
	end;
	useit = function(s)
		s.opened = not s.opened;
		if s.opened then
			p [[Я открыл бардачок.]]
			s:enable_all();
		else
			p [[Я закрыл бардачок.]]
			s:disable_all();
		end
	end;
	obj = { 'light' };
}
incar = room {
	nam = 'В машине';
	pic = function(s)
		if bard.opened then
			return 'gfx/5a.png';
		else
			return 'gfx/5.png';
		end
	end;
	entered = [[Я залез в салон машины.]];
	left = [[Я снова вылез из машины под дождь.]];
	dsc = [[Здесь было уютно. Дождь перестал заливать мне за шиворот.
		Когда я почувствовал под собой мягкое кожаное сидение, меня потянуло в сон.]];
	obj = { 'wheel', 'bard' };
	way = { vroom('Назад', 'sside') };
}

key1 = obj {
	nam = 'ключ';
	dsc = function(s)
		if not taken 'flash' then
			p [[Еще в подсобке на крючках висит {ключ}.]]
		else
			p [[В подсобке на крючке висит {ключ}.]];
		end
	end;
	exam = [[Большой железный ключ.]];
	useit = function(s)
		if have(s) then
			p [[Я повертел ключ в руках.]]
		else
			p [[Сначала надо его забрать.]]
		end
	end;
	take = takeit [[Я снял ключ с крючка.]];
	use = function(s, w)
		if w == kotel0 then
			if w.opened then
				return [[Уже открыто.]]
			end
			p [[Я вставил ключ в немного поржавевшую замочную скважину. Ключ подошел!!! С некоторым трудом я отомкнул замок.]];
			w.opened = true
			path 'В подвал':enable()
			remove(s, me())
			return
		end
		return [[Не подходит.]]
	end
}:disable();

flash = obj {
	nam = 'фонарик';
	var { bat = false; gun = false; on = false; };
	dsc = 'На полочке в подсобке я заметил {фонарик}.';
	take = function(s)
		p [[Я забрал фонарик.]]
		return true
	end;
	exam = function(s)
		if s.on then
			p [[Фонарик включен.]]
		else
			p [[Фонарик выключен.]]
		end
		if s.gun then
			p [[Он примотан изолентой к двустволке.]]
		end
	end;
	life = function(s)
		if player_moved() and not here().dark and not s.gun then
			p [[Я выключил фонарик.]]
			lifeoff(s)
			s.on = false
		end
	end;
	useit = function(s)
		if not taken(s) then
			return "Сначала нужно его взять."
		end
		if not s.bat then
			return [[Я попытался включить фонарик, но он не включался. Сели батарейки.]];
		end
		if here().dark then
			return "Если я выключу фонарик, я останусь в темноте."
		end
		s.on = not s.on
		if s.on then 
			lifeon(s)
			p [[Я включил фонарик.]]
		else
			lifeoff(s);
			p [[Я выключил фонарик.]]
		end
	end;
	use = function(s, w)
		if s.gun then
			p [[Фонарик примотан изолентой к ружью.]]
		end
		if w == shotgun then
			if not taken(w) then
				return "Сначала надо это взять."
			end
			if s.gun then
				return [[Фонарик уже прикручен к ружью.]]
			end
			if not have (isol) then
				return [[Прикрепить фонарик к ружью? Но как?]]
			end
			w.flash = true
			s.gun = true;
			move(s, shotgun, me())
			return [[У меня возникла идея. Я примотал фонарик к стволам изолентой и включил его. 
				Теперь мне было легко целиться!!!]];
		end
		if not s.bat then return "Фонарик выключен." end
		s.on = true
		lifeon(s)
		if w == ladder1 then
			if not slug2:dead() then
				p [[Я посветил фонариком на верхние ступеньки. Мои предчувствия меня не обманули. На верхней ступеньке что-то было.]]
				slug2:enable()
			else
				p [[Кажется, там ничего нет.]]
			end
			return
		end
		if w == kamin then
			p [[Я тщательно обследовал камин с фонариком и обнаружил, что один из камней в кладке немного выступает вперед.]]
			pushstone:enable()
			return
		end
		return [[Я посветил фонариком.]]
	end
}:disable();

shelf1 = obj {
	nam = 'дверца';
	var { opened  = false };
	door_type = true;
	dsc = function(s)
		if s.opened then
			p '{Дверь} в';
		else
			p 'Под лестницей расположена небольшая {дверь}.';
		end
	end;
	exam = 'Дверь в маленькую подсобку.';
	useit = function(s)
		s.opened = not s.opened;
		if s.opened then
			s:enable_all()
			p [[Я открыл дверцу.]]
		else
			s:disable_all()
			p [[Я закрыл дверцу.]]
		end
	end;
	obj = { 'podsobka' };
}:disable();

podsobka = obj {
	nam = 'подсобка';
	dsc = '{подсобку} открыта.';
	exam = [[Темно, ничего не видно.]];
	useit = [[Каморка слишком тесная и темная, чтобы забираться туда.]];
	obj = { 'flash', 'key1' };
}:disable();

function slug(v)
	v.nam = 'слизень';
	v.dscalive = v.dsc;
	if not v.name then
		v.name = 'Слизень';
	end
	v._seen = false
	v._dist = v.dist;
	if not v.delayed then
		v.delayed = false
	end
	v._trigger = v.delayed 
	v.dsc = function(s)
		if not v._dead then
			return call(s, 'dscalive');
		else
			return call(s, 'dscdead');
		end
	end
	v.dead = function(s)
		return s._dead;
	end
	v.kill = function(s)
		s._dead = true
		add_sound 'snd/squash.ogg'
		lifeoff(s)
	end
	v.exam = function(s)
		if s._dead then
			p [[Эта, похожая на гигантскую пиявку или слизня гадость -- мертва.]]
		else
			s._seen = true
			if not live(s) then
				p [[Эта штука похожа на большую пиявку или слизня зеленого цвета!!!]]
				return
			end
			if s._dist >= 3 then
				p [[Небольшой темный силуэт. Он быстро двигается в мою сторону!!!]]
			elseif s._dist >= 2 then
				p [[Эта тварь похожа на пиявку или слизня!!! Она умеет прыгать, ей осталось совсем не много чтобы добраться до меня!!!]]
			elseif s._dist >= 1 then
				p [[Эта штука похожа на здоровую пиявку или слизня!!! Она совсем рядом!!! И она зеленая!!!]]
			else
				p [[Это слизень! Гигантский зеленый слизень!!!!]]
			end
		end
	end
	v.useit = [[Лучше держаться от этого подальше!!! Вот и все.]];
	v.slug_type = true;
	v.take = [[Думаю, не стоит касаться его руками...]];
	v._dead = false
	v.life = function(s)
		if s._trigger then
			s._trigger = false
			return
		end

		if s._dist >=3 then
			p (s.name, [[ сделал длинный прыжок в мою сторону.]])
		else
			if s._dist ~= s.dist then
				p (s.name, [[ сделал еще один прыжок в мою сторону.]])
			else
				p (s.name, [[ сделал прыжок в мою сторону.]])
			end
		end
		if s._dist == 0 then
			lifeoff(s)
			gameover = true
			slugend.adsc = s.adsc
			stop_sound(3)
			walkin 'slugend'
			return
		end
		s._dist = s._dist - 1
	end
	return obj(v)
end


slug2 = slug {
	dist = 3;
	delayed = true;
	dsc = [[На верхней ступеньке лестницы я вижу какую-то {дрянь}!!!]];
	dscdead = [[На полу под лестницей валяются ошметки дохлого {слизня}.]]
}


ladder1 = obj {
	nam = 'лестница';
	life = function(s)
		if rnd(100) > 50 then
			if seen(slug2) and not slug2:dead() then
				p [[Слизень на верхней ступеньке переползает с места на место.]];
			else
				p [[Мне кажется, откуда-то сверху лестницы доносится тихий шорох...]]
			end
		end
	end;
	dsc = [[В центре холла расположена {лестница}, ведущая на второй этаж.]];
	exam = function(s)
		p [[Шикарная лестница ведет на второй этаж. Верхние ступеньки скрываются в темноте.]];
		if shelf1:disabled() then
			p [[Под лестницей я заметил небольшую дверцу.]]
			shelf1:enable();
		end
	end;
	useit = function(s)
		if not slug2:dead() then
			lifeoff(s)
			p [[Я начал подниматься наверх, когда что-то скользкое и холодное бросилось мне на голову.]]
			gameover = true
			stop_sound(3)
			walkin 'slugend'
			return
		end
		walk(floor2) 
	end;
	obj = {'shelf1', slug2:disable() };
}

global { tree_attack = false; tree_dead = false; };
vetka = obj {
	nam = 'ветка';
	var { seen = false; step = 1 };
	dsc = function(s)
		if s.seen then
			p [[Узловатые {ветви} дерева тащат меня!!!]];
		else
			p [[{Что-то} сжимает меня!!!]];
		end
	end;
	exam = function(s)
		if s.seen then
			p [[Это дерево! Мерзкое дерево!!!]]
		else
			s.seen = true;
			p [[Вдруг, я с ужасом понял, что это одно из деревьев тянет меня к себе своими мерзкими узловатыми ветвями!!!]];
		end
	end;
	life = function(s)
		if s.step == 1 then
			p [[Хватка стала еще сильнее. Я упал на холодный пол.]];
		elseif s.step == 2 then
			p [[С ужасом я понимаю что меня тащат по полу!]];
		elseif s.step == 3 then
			s.seen = true
			p [[Это проклятое дерево тащит меня к себе!!! Я вижу его узловатые ветки, они тянутся ко мне!!]]
		else
			gameover = true
			lifeoff(s)
			lifeoff(pila)
			stop_sound(3)
			walkin 'treeend'
			return 
		end
		s.step = s.step + 1
	end;
}

restart = obj {
	menu_type = true;
	nam = 'restart';
	dsc = [[{Переиграть}]];
	act = code [[ restore_snapshot(); ]];
}

acidend = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Я не рассчитал времени и мои ноги погрузились в кислоту. Почти сразу, я почувствовал резкую боль в подошвах и потерял сознание. Проклятая слизь погубила меня.]];
	obj = { restart };
}

dogend = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Проклятая собака набросилась на меня!!!]];
	obj = { restart };
}

dogend2 = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Щеколда не выдержала и проклятая собака ввалилась в туалет. У меня не было шансов.]];
	obj = { restart };
}


lightend = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Я попытался поджечь жижу зажигалкой. И у меня это получилось. Слизь вспыхнула и взорвалась... Пламя объяло меня. Проклятая  кислота!!!]];
	obj = { restart };
}

treeend = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Проклятое дерево погубило меня.]];
	obj = { restart };
}

spiderend = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Я поднялся по узкой лесенке и толкнул люк. Он открылся и с шумом ударился о пол чердака.
	Я начал забираться на чердак, когда что-то мохнатое бросилось мне на голову. Это был паук.
		Его рыжее волосатое тело было размером с баскетбольный мяч. Я начал задыхаться...]];
	obj = { restart };
}

spiderend2 = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Я бросил вантуз под ноги. Паук оказался на полу, а затем бросился на меня. Я начал задыхаться...]];
	obj = { restart };
}

spiderend3 = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	hideinv = true;
	dsc = [[Проклятый паук погубил меня.]];
	obj = { restart };
}

slugend = room {
	nam = 'Конец';
	pic = 'gfx/34.png';
	fading = true;
	hideinv = true;
	dsc = function(s)
		if s.adsc then
			p(s.adsc)
		else
			p[[Мерзкая, скользкая дрянь погубила меня!!!]];
		end
	end;
	obj = { restart };
}

vetkid = obj {
	nam = 'ветки';
	dsc = [[Под ногами валяются отпиленные {ветки}.]];
	exam = [[Липкие мерзкие щупальца!!!]];
	take = [[Нет! Я не буду это трогать!]];
	useit = [[Я не буду использовать эту гадость.]];
}

dihlo = obj {
	nam = 'дихлофос';
	disp = function(s)
		if s.fire then
			p [[огнемет]]
		else
			p [[дихлофос]]
		end
	end;
	var { fire = false; on = false; step = 1; fuel = 7 };
	dsc = [[На полке стоит баллончик с {дихлофосом}.]];
	exam = function(s)
		p [[Аэрозольный баллончик с дихлофосом.]]
		if s.on then
			if s.fire then
				p [[Из баллончика бьет огненная струя!]];
			else
				p [[Из баллончика бьет струя!]];
			end
		end
	end;
	take = takeit [[Я забрал баллончик с дихлофосом.]];
	life = function(s)
		local k,v
		for k,v in ipairs(objs()) do
			if v.slug_type and not v:dead() then
				if s.on then
					s.fuel = s.fuel - 1
					if s.fuel == 0 then
						p [[Пламя из баллончика погасло. Кончился дихлофос?]]
						s.on = false
						s.fire = false
						lifeoff(s)
						return true
					end
				end
				return
			end
		end
		s.step = s.step - 1;
		if s.step == 0 then
			p [[Я отпустил палец с кнопки баллончика.]]
			if s.fire then
				p [[Пламя погасло.]]
			end
			lifeoff(s)
			s.fire = false
			s.on = false
		else
			if not s.fire then
				p [[Из баллончика бьет струя.]]
			end
		end
	end;
	use = function(s, w)
		if w.slug_type then
			if w:dead() then
				return "Это уже мертво."
			end
			if not s.on then
				return "Ударить его баночкой?"
			end
			if not s.fire then
				return "Я прыснул дихлофосом..."
			end
			if w == slug1 then
				w:kill()
				add_sound 'snd/flame.ogg'
				return "Я направил огненную струю внутрь холодильника. Тварь мгновенно вспыхнула и с глухим стуком свалилась на дно холодильника."
			end
			if w._dist > 0 then
				p [[Слишком далеко...]]
				return
			end
			w._dist = 3
			add_sound 'snd/flame.ogg'
			p [[Я направил огненную струю на слизня, но он отпрыгнул от меня назад.]]
			return
		end
		if s.fire then
			return "Огнеметом?"
		end
		p [[Дихлофосом?]]
	end;
	useit = function(s)
		if have(s) then
			if s.on then
				s.step = 1
				s:life()
				return
			end
			if s.fuel == 0 then
				p [[Я нажал на кнопку, но ничего не произошло. Кончился дихлофос?]]
				p [[Я решил выбросить теперь бесполезный баллончик.]]
				remove(s, me())
				return
			end
			lifeon(s);
			p [[Я слегка нажал на кнопку, струя дихлофоса начала с шипением выходить из баллончика.]];
			s.on = true
			s.step = 2;
		else
			p [[Я могу это взять с собой.]]
		end
	end;
}

windows = function(dsc, exam, useit)
	local v = obj {
		nam = 'окна';
		dsc = dsc;
		exam = exam;
		useit = useit;
		window_type = true;
	}
	return v
end

treeroom = room {
	nam = 'Оранжерея';
	pic = function(s)
		if tree_dead then
			return 'gfx/7a.png'
		else
			return 'gfx/7.png'
		end
	end;
	entered = function(s)
		if not tree_dead then
			make_snapshot()
		end
		if not visited() then
			p [[Я осторожно открыл дверь и прошел в большую комнату. Некоторое время я осматривался.
			Здесь было много растений. Похоже, я попал в оранжерею.]]
		end
	end;
	exit = function(s)
	if seen(vetka) then
			p [[Я не могу уйти!!!]]
			return false
		end
	end;
	dsc = [[Оранжерея занимала четверть первого этажа особняка.]];
	obj = { vetka:disable(),
			vetkid:disable();
			obj {
			nam = 'растения';
			exam = function(s)
				if tree_dead then
					p [[Проклятые деревья больше мне не помешают!]];
				else
					p [[Странные растения. Большая часть из них -- странные на вид деревья. Ветви толстые, узловатые и они очень сильно переплетены... Кажется, они следят за мной...]];
				end
			end;
			take = [[Уж лучше тогда завядшие цветы с клумб, чем эти узловатые ветки...]];
			dsc = [[Всю площадь оранжереи занимают {растения}. ]];
			useit = function(s)
				if seen 'vetka' then
					p [[Дерево держит меня!!!]]
				else
					if tree_dead then
						return [[Получили, проклятые твари?]]
					end
					if tree_attack then
						return [[Лучше держаться от них подальше!]]
					end
					vetka.seen = true
					vetka.step = 2
					vetka:enable()
					lifeon(vetka);
					tree_attack = true
					p [[Я подошел поближе к растениям... Вдруг, одно из деревьев протянуло ко мне свои узловатые ветви!!!]]
					p [[Через мгновение они уже обвили меня за пояс и сжали мертвой хваткой!!!]];
				end
			end
		},
		obj  {
			nam = 'система полива';
			dsc = [[Над растениями расположена {система} полива.]];
			exam = [[Вода подается по трубам и распрыскивается сверху сквозь маленькие отверстия.]];
			useit = function(s)
				if seen(vetka) then
					p [[Сейчас мне не до изучения системы полива.]];
					return
				end
				p [[Где-то тут должны быть краны. Не могу найти...]];
			end;
		};
		obj {
			nam = 'полки';
			exam = [[Думаю, на полках могут находиться садовые принадлежности.]];
			take = [[Мне не нужны полки.]];
			dsc = [[У дальней стены оранжереи я едва различаю {полки}.]];
			useit = function(s) 
				if tree_dead then
					p [[Я подошел к полкам и осмотрел их.]]
					dihlo:enable()
					return
				end
				if seen(vetka) then
					p [[Я сейчас не в состоянии это сделать!]]
					return
				end
				lifeon(vetka);
				vetka.step = 1;
				vetka.seen = tree_attack
				local w = rnd(2);
				if w == 1 then
					w = 'слева';
				else
					w = 'справа';
				end
				local a = rnd(4);
				if a == 1 then
					a = 'больно обхватило мою левую ногу';
				elseif a == 2 then
					a = 'больно обхватило мою правую ногу';
				elseif a == 3 then
					a = 'схватило меня за ноги';
				else
					a = 'обвило меня вокруг пояса';
				end	
				if tree_attack then
					p ([[Я начал обходить растения ]]..w..', когда еще одно щупальце '..a..'!!!')
				else
					p ([[Я начал обходить растения ]]..w..', когда что-то '..a..'!!!')
				end
				tree_attack = true
				vetka:enable();
			end;
			obj = { dihlo:disable() };
		};
		windows([[Из больших {окон} в комнату поступает тусклый свет.]],
			[[Днем, когда солнечно, здесь может быть красиво...]],
			[[На окнах с внешней стороны решетки.]]);
	 };
	way = { vroom('В холл', 'inmansion') };
}

doors1 = obj {
	nam = 'двери справа';
	door_type = true;
	dsc = 'Справа и слева от лестницы находятся три {двери}.';
	exam = function(s)
		p [[Я осмотрел все двери. Две из них ведут направо и одна -- налево.]];
		d1:enable();
		d2:enable();
		d3:enable();
	end;
	useit = [[Двери не заперты.]];
}

corr1 = obj {
	nam = 'коридор';
	dsc = [[Узкий {коридор} ведет налево.]];
	exam = function(s)
		p [[В коридоре темно, но я могу туда пройти.]];
		path('В коридор'):enable();
	end;
	useit = code [[ return self:exam() ]];
}

clocktime = obj {
	nam = '10:45';
	exam = [[Не знаю зачем, но я запомнил это время.]];
	useit = [[Как можно это использовать?]];
	take = [[Это в моей памяти.]];
	nouse = [[Я подумал про 10:45... 10:45? 10:45.. Гм...]];
	use = function(s, w)
		if w == lclock then
			if w.set then return [[Я уже установил 10:45 на этих часах.]]; end
			w.set = true;
			remove(s, me())
			return [[Я установил 10:45 на часах.]];
		end
	end
}

lupa = obj {
	nam = 'лупа';
	dsc = [[На дне тумбочки лежит {лупа}.]];
	exam = [[Большое увеличительное стекло на ручке.]];
	useit = function(s)
		if disabled(brother) then
			p [[Андрей любил выжигать лупой буквы на газете... Любил??? Я еще найду своего младшего брата, я обещал отцу, что позабочусь о нем.]];
		else
			p [[Отдам ее Андрею, когда все кончится...]]
		end
	end;
	take = takeit [[Я спрятал лупу в кармане.]];
	nouse = [[Я решил воспользоваться лупой, но ничего не обнаружил.]];
	use = function(s, w)
		if w == kamin then
			p [[Я тщательно обследовал камин и обнаружил, что один из камней из кладки немного выступает вперед.]]
			pushstone:enable()
			return
		end
		if w == hclock then
			p [[На крышке выцарапана надпись: ERDIENST UM DEN STAAT. Гм...]];
		elseif w == foto and not taken 'clocktime' then
			p [[Я внимательно рассмотрел фотографию лупой. Интересно, можно даже различить время на часах, которые Гитлер дарит человеку в черном!!!]];
			take 'clocktime'
		end
	end
}

tumb1 = obj {
	nam = 'тумбочка';
	dsc = 'Рядом с кроватью стоит {тумбочка}.';
	useit = function(s)
		if not disabled(lupa) or here() == room1 then
			p [[Я тщательно осмотрел тумбочку и не нашел ничего интересного.]];
		else
			p [[Я заглянул в тумбочку. В ней было много старых газет. Под одной из газет лежала лупа.]];
			lupa:enable()
		end
	end;
	exam = [[Простая деревянная тумбочка.]];
}

bed1 = obj {
	nam = 'кровать';
	dsc = 'У стены стоит {кровать}.';
	exam = [[Аккуратно заправлена.]];
	useit = [[Не время спать...]];
}

room1 = room {
	pic = 'gfx/11.png',
	nam = 'Комната 1';
	dsc = [[Совсем небольшая аккуратно прибранная комната.]];
	obj =  { 
		bed1,
		tumb1,
		windows([[В комнате есть единственное {окно}.]], [[Капли дождя стекают по бледному стеклу.]], [[На окне решетка.]] ) 
	};
	way = { vroom('Выйти', 'corr') };
}

room2 = room {
	nam = 'Комната 2';
	pic = 'gfx/12.png';
	dsc = [[Довольно просторная комната с белым потолком и светло-зелеными стенами.]];
	obj =  { 
		bed1, 
		tumb1,
		lupa:disable(),
		obj {
			nam = 'шкаф';
			dsc = [[Здесь есть платяной {шкаф}.]];
			useit = [[Я открыл дверцы и заглянул внутрь. Эта одежда мне не подходит.]];
			exam = [[Надежная мебель. Может простоять не один десяток лет.]];
		};
		windows([[Бледный свет проникает в комнату через два {окна} в восточной стене.]], [[Капли дождя...]], [[На окнах решетки.]] ) 
	};
	way = { vroom('Выйти', 'corr') };
}

corr = room {
	nam = 'Коридор';
	pic = 'gfx/10.png';
	dsc = [[В темном коридоре я чувствую себя неуютно.]];
	obj = { 
		obj {
			door_type = true;
			nam = 'дверь 1';
			dsc = [[В правой стене коридора расположены две двери. Думаю, это двери в комнаты прислуги. Первая {дверь}]];
			exam = [[Деревянная дверь.]];
			useit = function(s)
				p [[Я подергал ручку. Дверь не заперта.]];
				path 'Комната 1':enable();
			end
		},
		obj {
			door_type = true;
			nam = 'дверь 2';
			dsc = [[и {вторая}.]];
			exam = [[Деревянная дверь.]];
			useit = function(s)
				p [[Я подергал ручку. Дверь не заперта.]];
				path 'Комната 2':enable();
			end
		}
	};
	way = { vroom('В холл', 'inmansion'), 
			vroom('Комната 1', 'room1'):disable(), 
			vroom('Комната 2', 'room2'):disable() };
}

switch1 = obj {
	nam = 'выключатель';
	dsc = 'У входной двери я вижу {выключатель}.';
	exam = [[Обычный выключатель.]];
	useit = [[Я пощелкал выключателем, но свет не зажигался. Похоже, дом обесточен.]];
}

function wroom_enter(self, ...)
	return stead.walk(call(self, 'where'));
end

function wroom(a, b, c)
	local v = room { vroom_type = true, nam = a, where = c, enter = wroom_enter };
	v.oldenter = v.enter;
	v.newname = b;
	v.oldname = a;
	v._toggle = false
	v.nam = function(s)
		if s._toggle then
			return call(s, 'newname')
		else
			return call(s, 'oldname');
		end
	end
	v.enter = function(s, ...)
		local r,v =  v:oldenter(...)
		if v ~= false then
			s._toggle = true
		end
		return r, v
	end
	return v
end

d1 = wroom('Дверь 1', 'На кухню', 'kitchen'):disable();
d2 = wroom('Дверь 2', 'В оранжерею', 'treeroom'):disable();
d3 = wroom('Дверь 3', 'В каминный зал', 'lroom'):disable();

inmansion = room {
	nam = 'Холл';
	pic = 'gfx/6.png';
	entered = function(s)
		if not visited() then
			p [[Ступая по обломкам двери, я вошел в темный холл особняка.
			Пока мои глаза привыкали к темноте,  ко мне пришла очевидная мысль о том, 
			что либо моего брата здесь нет, либо особняк не такой пустой, каким
			кажется... И все-таки я чувствовал, что мой брат где-то здесь...]]
		end
		if not slug2:dead() and not live(slug1) then
			make_snapshot()
			lifeon(ladder1);
		elseif not slug3:dead() and not live(slug1) then
			make_snapshot()
		end
	end;
	left = code [[ lifeoff(ladder1) ]];
	dsc = [[Пространство холла встретило меня темнотой и тишиной.]];
	way = { vroom('Наружу', 'atmansion'), 
			vroom('В коридор', corr):disable(), d1, d2, d3 };
	obj = { 'ladder1', 'corr1', 'doors1', 'switch1' };
}

slug1 = slug {
	dist = 0;
	delayed = true;
	dsc = [[В холодильнике ползает какая-то {дрянь}!!!]];
	dscdead = [[На дне холодильника лежат обгорелые {останки}.]]
}

batt = obj {
	nam = 'батарейки';
	dsc = [[На одной из полок дверцы холодильника лежат {батарейки}.]];
	exam = function(s)
		if have(s) then
			p [[Батарейки типа "D".]]
		else
			p [[Гм... Говорят, батарейки действительно лучше хранить в холодильнике. Надеюсь, они не разряжены.]];
		end
	end;
	take = takeit [[Я взял батарейки.]];
	useit = [[Гм. Как можно их использовать?]];
	use = function(s, w)
		if w == flash then
			w.bat = true
			p [[Я вставил батарейки в фонарик. Они подошли!!!]]
			inv():del(s)
			return
		end
		p [[Тут не помогут батарейки.]]
	end
}
refreg = obj {
	nam = 'холодильник';
	dsc = [[В дальном конце кухни белеет {холодильник}.]];
	exam = function(s)
		if slug1:dead() then
			p [[В открытом холодильнике лежит дохлый слизень.]];
			if disabled(batt) then
				p [[Еще внутри я заметил батарейки.]]
				batt:enable()
			end
		else
			p [[Гм.. Дверца холодильника приоткрыта...]];
		end
	end;
	useit = function(s)
		if not slug1:dead() then
			if live(slug1) then
				p [[Я собрался быстро закрыть холодильник...]]
				return
			end
			slug1:enable()
			lifeon(slug1)
			lifeoff(s)
			p [[Я осторожно заглянул в холодильник и содрогнулся. В пустом холодильнике, на средней полке лежала какая-то зеленая дрянь!!!]]
			return
		end
		p [[Я осмотрел внутренности холодильника.]];
		batt:enable();
	end;
	life = function(s)
		if not seen(slug1) and rnd(100) > 50 then
			p [[Странно, мне кажется, я слышу какой-то тихий шорох из холодильника...]];
		end
	end;
	obj = { slug1:disable(), batt:disable() };
}

kitchen = room {
	nam = 'Кухня';
	pic = 'gfx/9.png',
	entered = function(s)
		if not slug1:dead() then
			make_snapshot()
		end
		if not slug1:dead() then
			lifeon(refreg);
		end
		if not visited() then
			p [[Я осторожно открыл дверь и прошел в комнату. Оказалось, я попал на кухню. ]];
		end
	end;
	left = code [[ lifeoff(refreg) ]];
	dsc = [[Комната кухни была длинной и узкой.]];
	obj = { 
		obj {
			nam = 'стол';
			dsc = [[Длинный {стол} для готовки, занимал почти всю стену.]];
			exam = [[На столе есть посуда. Мойка пуста. ]];
			useit = [[Тут нет еды.]];
		};
		windows([[Из {окон} в западной стене поступал тусклый сумеречный свет.]], [[Хоть какое-то освещение.]],
			[[На окнах решетки.]]);
		refreg;			
	};
	way = { vroom('В холл', 'inmansion') };
}

pushstone = obj {
	nam = 'камень';
	dsc = [[Один из {камней} в кладке камина немного выступает.]];
	exam = [[Такой же, как и другие -- его сложно заметить.]];
	useit = function(s)
		if not lclock.set or not disabled(ladder0) then
			return [[Я нажал на камень -- ничего не произошло.]];
		end
		ladder0:enable();
		p [[Я нажал на камень. Почти в то же мгновение камин отъехал в сторону и открыл нишу.]];
	end;
}

ladder0 = obj {
	nam = 'лестница';
	dsc = [[За камином, в темной нише находится узкая {лестница}, ведущая вниз.]];
	exam = [[Лестница ведет в подвал!]];
	useit = function(s)
		if not flash.on then	
			flash.on = true
			lifeon(flash)
			p [[В нише было совсем темно, поэтому я включил фонарик.]];
		end
		p [[Осторожно я начал спускаться вниз.]];
		walk 'lab';
	end
}

kamin = obj {
	nam = 'камин';
	dsc = [[У восточной стены установлен {камин}.]];
	exam = [[Камин монументально выступает из темноты. ]];
	obj = { shotgun, pushstone:disable(), ladder0:disable() };
}

ltable = obj {
	nam = 'стол';
	dsc = [[Центр зала занимает {стол}.]];
	exam = [[Стол убран и заправлен белой скатертью.]];
	useit = [[Я заглянул под стол -- пусто.]];
}

global { on_chair = false; }

lchair = obj {
	nam = 'стул';
	var { trig = false };
	dsc = [[Один из {стульев} стоит возле камина.]];
	exam = [[Он такой-же как и остальные.]];
	take = [[Этот стул мне больше не нужен.]];
	use = function(s, w)
		if w == kamin then
			p [[Я поставил стул возле камина.]]
			drop(s, lchairs);
			return
		end
		p [[Ударить стулом? Не поможет.]];
	end;
	life = function(s)
		if not s.trig then	s.trig = true return end
		p [[Я слез со стула.]]
		lifeoff(s);
		on_chair = false
		return true
	end;
	useit = function(s)
		if on_chair then
			s.trig = false
			return "Уже на стуле."
		end
		s.trig = false
		if have(s) then
			p [[Я держу стул в руке.]];
			return
		end
		on_chair = true;
		p [[Я забрался на стул.]]
		lifeon(s);
	end
}

lchairs = obj {
	nam = 'стулья';
	dsc = [[Вокруг стола стоят {стулья}.]];
	exam = [[Какие красивые резные спинки. Орех?]];
	take = function(s)
		if have(lchair) or seen(lchair) then
			return [[Мне больше не нужны стулья.]]
		end
		p [[Я взял один стул.]]
		take(lchair)
	end;
	useit = [[Не время сидеть.]]; 
}

lclock = obj {
	nam = 'часы';
	var { set = false };
	dsc = [[В углу стоят большие напольные {часы}.]];
	exam = function(s)
		if s.set then
			return [[Часы стоят. Стрелки показывают 10:45.]];
		end
		p [[Часы стоят. Стрелки остановились в 12:17.]];
	end;
	useit = [[Интересно, как они бьют?]];
	take = [[Слишком массивные.]];
		
}

notes = obj {
	nam = 'ноты';
	dsc = 'На пианино лежат {ноты}.';
	take = takeit [[Я забрал ноты.]];
	exam = function(s)
		if have(s) then
			p [[Гм, надпись на обложке по-немецки: EINE SONATE FÜR DAS ALBUM VON FRAU MATHILDE WESENDONCK. WWV 85 (1853).
				Сверху написано имя композитора: "Richard Wagner". Гм, Вагнер?]]
		else
			p [[Ноты раскрыты.]]
		end
	end;
	useit = function(s)
		p [[Я не умею играть на фортепиано.]]
	end
}

piano = obj {
	nam = 'пианино';
	dsc = 'У дальней стены стоит черное {фортепиано}.';
	exam = function(s)
		if disabled(notes) then
			notes:enable();
			p [[На пианино лежат ноты.]];
		else
			p [[Черное пианино в плохо освещенной комнате... Белые клавиши блестят словно зубы.]];
		end	
	end;
	useit = [[Я провел пальцами по белым клавишам...]];
	obj = { notes:disable() };
}

lroom = room {
	nam = 'Каминный зал';
	pic = function(s)
		if not disabled(ladder0) then
			return 'gfx/8b.png'
		elseif taken 'shotgun' then
			return 'gfx/8a.png'
		end
		return 'gfx/8.png'
	end;
	left = function(s)
		if have(lchair) then
			p [[Уходя из зала, я оставил стул.]];
			inv():del(lchair);
		end
	end;
	entered = function(s)
		if not visited() then
			p [[Я осторожно открыл широкую двустворчатую дверь и прошел в просторный зал. ]];
		end
	end;
	dsc = [[В просторном каминном зале пусто и тихо. От оконных решеток на пол падают причудливые тени.]];
	obj = { 
		kamin,
		ltable,
		lchairs,
		lclock,
		piano,
		windows("На западной стене расположены {окна}.", "Скоро кончится лето...", [[На окнах решетки.]]);
	};
	way = { vroom('В холл', 'inmansion') };
}

isol = obj {
	nam = 'изолента';
	dsc = function(s)
		if kotelshelf.broken then
			p [[ На полу рядом с досками валяется {изолента}.]];
		else
			p [[ На нижней полке стеллажа лежит {изолента}.]];
		end
	end;
	use = function(s, w)
		if w == shotgun then
			return [[Примотать что-нибудь к ружью?]]
		end
		if w == kiy then
			return [[Примотать что-нибудь к кию?]]
		end
		if w == vantuz then
			return [[Примотать что-нибудь к вантузу?]]
		end
		return [[Не нужно это изолировать.]]
	end;
	exam = [[ Большой моток черной изоленты! ]];	
	useit = [[ Мне нравится отрывать кусочек изоленты, а затем снова приклеивать его к мотку. ]];
	take = takeit [[ Я забрал изоленту. ]];
}

kotelshelf = obj {
	var { broken = false };
	nam = 'шкаф';
	dsc = function(s)
		if not s.broken then
			p [[У выхода из котельной стоит {стеллаж}.]];
		else
			p [[На полу у входа из котельной лежат {доски}.]];
		end
	end;
	exam = function(s)
		if s.broken then
			p [[Хорошие, толстые и длинные доски.]];
		else
			p [[Похоже, он самодельный. Из него торчат гнутые гвозди.]];
		end
	end;
	useit = function(s)
		if not s.broken then
			p [[Ничего интересного: банка с засохшей краской, кисточка, старый манометр...]];
		else
			p [[Что мне нужно от этих досок?]];
		end
	end;
	take = function(s)
		if s.broken then
			if have 'doska' then
				return [[У меня уже есть одна.]]
			end
			take 'doska'
			return [[Я взял одну доску.]]
		else
			p [[Таскать стеллаж с собой?]];
		end
	end;
	obj = { isol };
}

doska = obj {
	nam = 'доска';
	exam = function(s)
		if have(s) then
			p [[Длинная толстая доска. Как бы занозу не загнать.]];
		else
			p [[Слизь разъедает ее!!!]]
		end		
	end;
	dsc = [[На полу в нише прохода, на зеленой слизи лежит {доска}.]];
	useit = [[Что мне с ней делать?]];
	take = [[Она лежит в этой гадости, лучше поберечь руки.]];
	var { time = 1 };
	life = function(s)
		s.time = s.time - 1
		if s.time  == 0 or player_moved() then
			lifeoff(s)
			if here() == disel then
				p [[Доска окончательно растворилась в зеленой жиже.]]
			end
			remove(s, disel);
			path('По доске', disel):disable()	
		end
	end;
	use = function(s, w)
		if w == kotelshelf then
			p [[Я бросил доску назад.]]
			inv():del(s);
			return
		end
		if w == acid then
			p [[Я бросил доску в зеленую жижу. 
				Почти тут же она начала постепенно чернеть с краев. 
				Как зачарованный, минуту или две я наблюдал, как доска растворялась в этой зеленой слизи.]]
			inv():del(s)
			return
		end
		if w == onsklad then
			p [[Я бросил доску на зеленую жижу в проходе. 
				Почти тут же она начала постепенно чернеть с краев. Но у меня было несколько минут, чтобы пройти по
				этому мостику в следующее помещение.]]
			path('По доске'):enable()
			s.time = 3
			lifeon(s)
			drop(s)		
			return
		end
		p [[Доской двинуть???]]
	end
}

kotel = room {
	nam = 'Котельная';
	pic = 'gfx/13.png';
	dark = true;
	enter = function(s, f)
		if not taken (flash) or not flash.bat or not flash.on then
			p [[Я зашел в подвал, но внутри было совсем темно и мне пришлось выйти наружу.]]
			return false
		end
		if f == nside then
			p [[Я спустился в подвал. Свет фонарика помогал мне ориентироваться в темноте.]]
		end
	end;
	left = function(s, to)
		if to == nside and have 'doska' then
			inv():del(doska);
			p [[Уходя из котельной, я бросил доску.]];
		end
	end;
	dsc = [[В котельной было тесно и сыро. Небольшой проход вел в следующее подвальное помещение.]];
	obj = { obj {
			nam = 'котел';
			dsc = 'Здесь установлен {котел}.';
			exam = [[Котел для обогрева воды.]];
			useit = [[Что мне делать с котлом?]];
		},
		obj {
			nam = 'трубы';
			dsc = 'Изогнутые {трубы} расположены вдоль стен.';
			exam = 'Выглядят старыми.';
			useit = [[Я постучал по трубам.]];
		};
		kotelshelf;		
	};
	way = { vroom('Наверх', 'nside'), vroom('Дальше', 'disel') };
}

onsklad = obj {
	nam = 'проход';
	dsc = [[Из помещения есть два выхода. Один ведет назад -- к котельной, а второй {проход} дальше -- в следующую часть подвала.]];
	exam = [[Из темного прохода в помещение втекает зеленая жижа.]];
	useit = [[Пытаясь пройти дальше, я наступил краем ботинка на зеленую жижу, которая залила часть пола. Раздался запах горелой резины, я быстро отскочил назад. Кислота?]];
}

acid = obj {
	nam = 'кислота';
	dsc = [[Пол здесь залит какой-то зеленой {жижей}.]];
	exam = [[Неприятный, приторный, кисло-сладкий запах бьет в нос... Эта гадость залила часть пола помещения, особенно много возле насоса.]];
	useit = [[Не хочется этого касаться...]];
}

disel = room {
	nam = 'Дизельная';
	dark = true;
	pic = function(s)
		if seen 'doska' then
			return 'gfx/14a.png'
		end
		return 'gfx/14.png'
	end;
	enter = function(s, f)
		if f  == kotel then
			p [[Осторожно я прошел в следующее помещение.]];
		end
		make_snapshot()
	end;
	dsc = [[Это подвальное помещение было просторнее, чем помещение котельной.]];
	obj = { obj {
				nam = 'дизель';
				dsc = [[У западной стены расположен {дизель-генератор}.]];
				exam = [[Не работает, наверное все топливо кончилось...]];
				useit = [[Если я запущу генератор, возможно, в доме будет свет. Но где я возьму топливо и сколько времени потрачу на запуск этой штуки? К тому же,
					у меня есть фонарик.]];
			},
			obj {
				nam = 'насос';
				dsc = [[Восточную часть занимает водяной {насос}.]];
				exam = [[У них тут, похоже, артезианская скважина. Конечно, без электричества подачи воды нет. 
					Интересно, что зеленая жижа полностью залила пол под насосом. Похоже, она стекает дальше, вдоль трубы, ведущей вниз.]];
				useit = [[Включить насос? Но как? Дизель-генератор не работает.]];
			};
			onsklad,
			acid,		
	};
	way = { vroom('В котельную', 'kotel'), vroom('По доске', 'sklad'):disable() };
}

acid2 = obj {
	nam = 'жижа';
	dsc = [[и зеленая вязкая {жижа} стекала из них на пол.]];
	exam = function(s)
		p [[Эта гадость залила почти весь пол и вытекла в дизельную.]] 
	end;
	useit = [[Искупаться?]];
	take = [[Ты исследователь-экспериментатор? Ты бы взял в руки кислоту???]];
}

barrels = obj {
	nam = 'бочки';
	dsc = [[Большую часть помещения занимали металлические {бочки}. У нескольких бочек были сорваны крышки,]];
	exam = [[Зеленые бочки, штук семь или восемь. Эта зеленая дрянь оттуда. Похоже, по какой-то причине она увеличилась в объеме и вытолкнула крышки.]];
}

doska2 = obj {
	nam = 'доска';
	var {time = 4 };
	dsc = [[Под моими ногами медленно, но верно разрушается {доска}.]];
	exam = [[Осталось совсем мало времени!!!]];
	take = [[Я на ней стою.]];
	useit = [[Я уже нашел применение этой доске.]];	
	life = function(s)
		s.time = s.time - 1
		if s.time == 0 then
			lifeoff(s)
			gameover = true
			stop_sound(3)
			walkin 'acidend'
			return
		end
		p [[От доски исходит дым. Она медленно чернеет.]]
	end
}

shelfs1 = obj {
	nam = 'полки';
	dsc = [[На стенах справа и слева от входа установлены деревянные {полки}.]];
	exam = function(s)
		if not taken(box1) then
			p [[Справа от меня, на краю полки я заметил небольшую картонную коробку.]];
			box1:enable();
		else
			p [[Ничего интересного в зоне доступности я не обнаружил.]]
		end
	end;
	useit = function(s)
		p [[Я могу дотянуться до правой полки.]];
	end;
	obj = { 'box1' };
}

dropshells = obj {
	nam = 'гильзы';
	dsc = [[Под ногами валяются {гильзы} от дробовика.]];
	exam = [[Пустые гильзы.]];
	take = [[Они мне не нужны.]];
	useit = [[Они бесполезны.]]
}

shells = obj {
	nam = 'патроны';
	var { first = true };
	exam = [[Патроны для дробовика.]];
	useit = [[Как их использовать?]];
	use = function(s, w)
		if w == shotgun then
			if w.armed then
				return [[Дробовик уже заряжен.]]
			end
			w.armed = true
			add_sound 'snd/load.ogg'
			if not s.first then
				p [[Я перезарядил двустволку.]]
				add_sound 'snd/drop.ogg'
				put(dropshells)
			else
				p [[Я зарядил двустволку.]]
			end
			s.first = false
			return
		end
		if w == revol then
			return [[Не тот калибр.]]
		end
		p [[Тут патроны не нужны.]]
	end
}

box1 = obj {
	nam = 'коробка';
	dsc = [[На навесной полке справа стоит картонная {коробка}.]];
	exam = function(s)
		if not have(s) then
			p [[Небольшая картонная коробка. Я могу до нее дотянуться.]];
		else
			p [[Открыть?]]
		end
	end;	
	useit = function(s)
		if have(s) then
			p [[Я открыл коробку. Ух-ты, мне сильно повезло! В ней оказались патроны!!!]]
			replace(s, shells, me())
		else
			p [[Что мне с ней сделать?]]
		end
	end;
	take = takeit [[Я схватил коробку.]];
}:disable();

sklad = room {
	nam = 'Склад';
	pic = 'gfx/15.png';
	dark = true;
	left = function(s)
		lifeoff(doska2);
		p [[Я бросился назад в дизельную. Доска под моими ногами окончательно погрузилась в зеленую слизь.]]
	end;
	entered = function(s)
		make_snapshot()
		p [[Я добежал до конца доски и быстро осмотрелся.]];
		doska2.time = 5
		lifeon(doska2);
	end;
	dsc = [[Я находился в складском помещении.]];
	way = { vroom('В дизельную', 'disel') };
	obj = { barrels, acid2, doska2, shelfs1, obj {
			nam = 'дверь';
			dsc = [[На противоположной стене находится железная {дверь}.]];
			exam = [[Выглядит запертой.]];
			useit = [[Туда не добраться...]];
		}
	 };
}

slug2dead = obj {
	nam = 'ошметки';
	dsc = function(s)
		local c = 0
		if slug3:dead() then c = c + 1 end
		if slug4:dead() then c = c + 1 end
		if slug5:dead() then c = c + 1 end
		if c == 1 then
			p [[По полу разбросаны {ошметки} от слизня.]]
		elseif c == 2 then
			p [[По полу разбросаны {ошметки} двух слизней.]]
		else
			p [[По полу разбросаны {ошметки} трех слизней.]]
		end
	end;
	take = [[Ну уж нет...]];
	exam = [[Мерзкое зрелище...]];
	useit = [[Не знаю, как это может пригодиться.]]
}

slug3 = slug {
	dist = 1;
	delayed = true;
	name = [[Первый слизень]];
	adsc = [[Первый слизень кинулся на меня.]];
	descs = {
		txtem "Я вижу как первый {слизень} готовится к финальному прыжку!";
		"Первый {слизень} находится в 3-х метрах от меня.";
		"Первый {слизень} начал двигаться в мою сторону.";
		"Первый {слизень} совсем далеко.";
	};
	dsc = function(s)
		p (s.descs[s._dist + 1])
	end;
};

slug4 = slug {
	dist = 0;
	name = [[Второй слизень]];
	delayed = true;
	adsc = [[Второй слизень кинулся на меня.]];
	descs = {
		txtem "Я вижу как второй {слизень} готовится к финальному прыжку.";
		"Второй {слизень} уже совсем близко от меня!";
		"Второй {слизень} ползает на некотором отдалении.";
		"Второй {слизень} совсем далеко.";
	};
	dsc = function(s)
		p (s.descs[s._dist + 1])
	end;
};

slug5 = slug {
	dist = 2;
	delayed = true;
	name = [[Третий слизень]];
	adsc = [[Третий слизень кинулся на меня.]];
	descs = {
		txtem "Я вижу как третий {слизень} готовится к финальному прыжку!";
		"Третий {слизень} скоро доберется до меня!";
		"Третий {слизень} находится в 6 метрах от меня.";
		"Третий {слизень} совсем далеко.";
	};
	dsc = function(s)
		p (s.descs[s._dist + 1])
	end;
};

cor2 = obj {
	nam = 'коридор';
	dsc = function(s)
		p [[От лестницы, поднимающейся с первого этажа, в обе стороны расходится длинный {коридор}.]];
		local c = 0
		if not slug3:dead() then c = c + 1 end
		if not slug4:dead() then c = c + 1 end
		if not slug5:dead() then c = c + 1 end
		if c == 2 then
			p [[В коридоре осталось два слизня.]]
		elseif c == 3 then
			p [[По полу ползают три слизня.]]
		end		
	end;
	exam = [[Коридор проходит вдоль всей западной стены.]];
	useit = [[На полу постелена красная ковровая дорожка.]];
}

d23 = wroom('Дверь 3', 'В библиотеку', 'library');
d21 = wroom('Дверь 1', 'В комнату для гостей', 'guests');
d22 = wroom('Дверь 2', 'В комнату отдыха', 'happyr');

doors2 = obj {
	nam = 'двери';
	door_type = true;
	dsc = 'Вдоль коридора, напротив окон, расположены {двери}.';
	exam = function(s)
		p [[Я осмотрел все двери. Выглядят, как двери.]];
	end;
	useit = [[Двери не заперты.]];
}

ladder2n = obj {
	nam = 'северная лестница';
	dsc = [[В {северном} и]];	
	exam = [[Кажется, путь свободен...]];
	useit = function(s)
		floor3.from = 'n';
		p [[Я поднялся по северной лестнице на третий этаж.]]
		walk 'floor3'
	end
}

ladder2s = obj {
	nam = 'южная лестница';
	dsc = [[{южном} конце коридора расположены лестницы на третий этаж.]];	
	exam = [[Кажется, путь свободен...]];
	useit = function(s)
		floor3.from = 's';
		p [[Я поднялся по южной лестнице на третий этаж.]]
		walk 'floor3'
	end
}

floor2 = room {
	nam = 'Второй этаж';
	dsc = [[Я нахожусь на втором этаже особняка.]];
	pic = function(s)
		if live(slug3) or live(slug4) or live(slug5) then
			return 'gfx/16.png'
		else
			return 'gfx/17.png'
		end
	end;
	exit = function(s)
		if not slug3:dead() or not slug4:dead() or  not slug5:dead() then
			lifeoff(slug3);
			lifeoff(slug4);
			lifeoff(slug5);
			p [[Я попытался уйти из этого страшного места, но одна из тварей набросилась на меня...]]
			gameover = true
			stop_sound(3)
			walkin 'slugend'
			return
		end
	end;
	entered = function(s, f)
		if f == inmansion then
			p [[Я осторожно поднялся по лестнице, освещая свой путь фонариком.]]
			if not slug3:dead() then
				slug4._dist = 0
				slug3._dist = 1
				slug5._dist = 2
				lifeon(slug3)
				lifeon(slug4)
				lifeon(slug5)
				p [[Когда я миновал последнюю ступеньку, то с ужасом обнаружил, что окружен тремя зелеными тварями. Одна из них готовилась к прыжку...]]
			end
		else
			if not dog:dead() then
				make_snapshot()
			end
		end
	end;
	obj = { cor2, 'slug3', 'slug4', 'slug5', 
		windows([[{Окна} выходят на восточную сторону.]], [[Из окон ужасный вид.]], [[Спрыгнуть вниз?]]), doors2, ladder2n, ladder2s  };
	way = { vroom('Вниз', inmansion), d21, d22, d23 };
}
global { book_sw = 0 };
function book(n, sw)
	local v = obj {
		nam = 'книга';
		sw = sw;
		dsc = '{'..n..'}^';
		exam = [[Выглядит как книга.]];
		take = function(s)
			if s.sw then
				return [[Странно! Эта книга не вытаскивается с полки.]]
			end
			p [[Я повертел в руках книгу и поставил обратно.]]
		end;
		useit = function(s)
			if s.sw then
				if book_sw == 6 then
					return [[Я уже поиграл с книгами.]]
				end
				p [[Книга была каким-то образом закреплена на полке. Мне удалось только наклонить ее корешком и поставить обратно.]]
				if s.sw == book_sw + 1 or s.sw == 1 then
					book_sw = s.sw
					if book_sw == 2 then
						p [[При этом раздался какой-то тихий щелчок.]]
					elseif book_sw == 3 then
						p [[Я прислушался, и снова услышал щелчок!]]
					elseif book_sw == 4 then
						p [[И снова я услышал звук срабатывания какого-то механизма.]]
					elseif book_sw == 5 then
						p [[Очередной щелчок подтвердил мою догадку!!!]];
					end
				else
					book_sw = 0
					p [[При этом я услышал тихий стук.]]
				end
				if book_sw == 6 then
					p [[Раздался звук срабатывания механизма, и полка с книгами повернулась вокруг своей оси,
					открывая проход в темную нишу.]];
					walk 'library'
					path 'В тайник':enable()
					hiddenpath:enable()
					return
				end
			else
				p [[Я провел рукой по корешку книги.]];
			end
		end;
	}
	return v
end

books2n = room {
	nam = 'Книги';
	pic = 'gfx/21.png',
	dsc = [[Я подошел к шкафам и пробежался взглядом по корешкам некоторых книг. Гм... Только немецкие авторы!!!]];
	enter = function(s)
		if book_sw == 6 then
			p [[Можно пройти за шкаф!]]
			return false
		end
	end;
	obj = {
		book("Friedrich von Sallet");
		book("Karl Lebrecht Immermann");
		book("Erich Maria Remarque", 6),
		book("Thomas Bernhard");
		book("Karl Grünberg", 3),
		book("Philipp von Zesen");
		book("Emil Ludwig");
		book("Freiherr von Novalis", 4),
		book("Friedrich Schlegel");
		book("Wilhelm Arent", 2),
		book("Max Weber", 1),
		book("Günter Eich", 5),
	};
	way = { vroom('Отойти', 'library') };
}


books2e = room {
	nam = 'Книги';
	pic = 'gfx/21.png',
	dsc = [[Я подошел к шкафам и пробежался взглядом по корешкам некоторых книг.]];
	obj = {
		book('Собрание сочинений Маркса и Энгельса');
		book('Британская энциклопедия');
		book('Сочинения Гегеля');
		book('Сочинения Шопенгауэра');
		book('Собрание сочинений Ницше');
		book('Собрание сочинений Ленина');
	};
	way = { vroom('Отойти', 'library') };
}

books2s = room {
	nam = 'Книги';
	pic = 'gfx/21.png',
	dsc = [[Я подошел к шкафам и пробежался взглядом по корешкам некоторых книг.]];
	obj = {
		book('Книги по астрономии');
		book('Книги по химии');
		book('Книги по физике');
		book('Книги по биологии');
		book('Книги по географии');
	};
	way = { vroom('Отойти', 'library') };
}


shelf2n = obj {
	nam = 'северный шкаф';
	dsc = [[{северной}]];
	exam = function(s)
		if book_sw == 6 then
			return [[Один из шкафов повернут вокруг своей оси!]]
		end
		p [[Здесь расположено два шкафа.]];
	end;
	take = [[Взять шкаф?]];
	useit = code [[ walk 'books2n' ]];
}

shelf2e = obj {
	nam = 'восточный шкаф';
	dsc = [[Вдоль {восточной},]];
	exam = [[Вдоль восточной стены установлено четыре шкафа. Такое количество книг прочитать -- не хватит жизни.]];
	useit = code [[ walk 'books2e' ]];
	take = [[Взять шкаф?]];
}

shelf2s = obj {
	nam = 'южный шкаф';
	dsc = [[и {южной} стен расположены книжные]];
	exam = [[Здесь стоят два книжных шкафа.]]; 
	useit = code [[ walk 'books2s' ]];
	take = [[Взять шкаф?]];
}

shelfs2 = obj {
	nam = 'шкафы';
	dsc = function(s)
		p [[{шкафы}.]];
	end;
	exam = [[Очень массивные деревянные шкафы полностью заставленные книгами.]];
	useit = [[Что можно сделать с шкафами?]];
	take = [[Они слишком большие.]]
}

hobelens = obj {
	nam = 'гобелены';
	dsc = [[Стены комнаты увешены красно-черными {гобеленами} с изображением свастики.]];
	take = [[Мне не нужна эта гадость!]];
	useit = [[Я проверил стены за гобеленами и ничего не обнаружил.]];
	exam = [[Черные свастики словно пауки! Мне не нравится это место.]];
}

port2 = obj {
	nam = 'портрет';
	dsc = [[Прямо напротив входа на стене висит {портрет} Гитлера.]];
	exam = [[Значит, хозяин дома -- фашист. Похоже, война еще не закончилась...]];
	useit = [[Не без содрогания я проверил пространство за портретом и ничего не обнаружил.]];
	take = [[Я не буду брать это с собой!]];
}

hbook = obj {
	nam = 'книга';
	dsc = [[На столике лежит {книга} в толстом переплете.]];
	take = [[Я взял книгу и открыл ее. Она была написана на немецком, но, несмотря на это, я быстро понял, что это была книга Гитлера.
		На первых страницах были указаны годы его жизни: 1889 - 1945. С омерзением я бросил книгу назад.]];
	exam = [[Книга в толстом кожаном переплете.]];
	useit = [[Что мне делать с ней?]];
}

kandelabr = obj {
	nam = 'канделябр';
	var { light = false };
	dsc = function(s)
		if s.light then
			p [[Возле столика находится {канделябр} с зажженной свечей.]]
		else
			p [[Возле столика находится {канделябр}.]]
		end
	end;
	exam = [[В канделябре всего одна свеча.]];
	useit = [[Я не смог придумать, что мне сделать с канделябром.]];
	take = [[Слишком громоздкий, чтобы его таскать за собой. И не так полезен, как бензопила.]]
}

foto = obj {
	nam = 'фото';
	dsc = [[Рядом с книгой стоит {фотография}.]];
	exam = function(s)
		if taken(s) then
			p [[На черно-белой фотографии изображены два человека.
			Один из них Гитлер. Другой -- одетый в темный костюм человек с редкой бородкой. 
			Гитлер пожимает правую руку человека в черном, а в левой держит наготове большие карманные часы.]];
		else
			p [[Небольшая фотография в рамке.]];
		end
	end;
	useit = function(s)
		if have(s) then
			p [[На другой стороне фотографии дата: 11.09.1939]];
		else
			p [[Фотография стоит на столике.]]
		end
	end;
	take = takeit [[Я взял фотографию.]];
}

stolik3 = obj {
	nam = 'столик';
	dsc = [[На полу стоит маленький круглый {столик} на ножке.]];
	exam = function(s)
		p [[Столик заправлен красной скатертью.]]
		if disabled(hbook) then
			p [[На столике я заметил книгу и небольшую фотографию.]]
			hbook:enable();
			foto:enable()
		end
	end;
	obj = { hbook:disable(); foto:disable() };
	useit = [[Столик мне ничем не поможет. Тем более -- ЭТОТ столик.]];
}

hidden2 = room {
	nam = "Тайная комната";
	pic = 'gfx/22.png';
	dark = true;
	enter = function(s)
		if not flash.on then
			p [[Там было совсем темно, я не решился заходить в комнату с выключенным фонариком.]]
			return false
		end
	end;
	entered = [[Не без содрогания я зашел в темную нишу...]];
	left = [[Я вернулся из тайника в библиотеку.]];
	dsc = [[Я нахожусь в небольшой комнате квадратной формы.]];
	obj = { hobelens, port2, stolik3, kandelabr };
	way = { vroom('Выйти', 'library') };
}

hiddenpath = obj {
	nam = 'тайник';
	dsc = [[Один из шкафов на северной стороне повернут вокруг своей оси, открывая секретный {проход}.]];
	exam = [[Там темно, похоже на небольшую комнату.]];
	useit = [[Можно пойти туда...]];	
}

stolik2 = obj {
	nam = 'стол';
	dsc = [[В центре комнаты расположен овальный {стол}.]];
	exam = [[Стол деревянный.]];
	useit = [[Мне не нужен стол.]]
}

chairs2 = obj {
	nam = 'кресла';
	dsc = [[Вокруг стола стоят кожаные {кресла}.]];
	exam = [[Кресла обиты черной кожей. В темноте они выглядят угрожающе.]];
	useit = [[Мне не хотелось садиться в эти черные кресла.]];
}

library = room {
	nam = 'Библиотека';
	pic = function(s)
		if disabled(hiddenpath) then
			return "gfx/20.png"
		else
			return "gfx/20a.png"
		end
	end;
--	dark = true;
	entered = function(s, f)
		if not visited() then
			p [[Я зашел в комнату и осмотрелся. Похоже, я оказался в библиотеке!]];
		end
	end;
	dsc = [[Комната занимает все южное крыло второго этажа.]];
	obj = { stolik2, chairs2, shelf2e, shelf2n, shelf2s, shelfs2, hiddenpath:disable(),
		windows("Сквозь {окна} в западной стене в библиотеку поступает свет.",
			"Скоро стемнеет...", "Я выглянул в окно -- во дворе было пустынно.")};
	way = { vroom('В коридор', floor2), vroom('В тайник', hidden2):disable() };
}

guests = room {
	nam = 'Комната для гостей';
	pic = 'gfx/18.png';
	entered = function(s, f)
		if not visited() then
			p [[Я зашел в комнату и осмотрелся. Это была небольшая спальня. И судя по тому,
			что все вещи здесь выглядели нетронутыми, я назвал ее комнатой для гостей...]];
		end
	end;
	dsc = [[Я находился в небольшой комнате.]];
	obj = {
		windows([[В единственное {окно} барабанит дождь.]],
			[[Надо спешить, скоро начнет темнеть.]],
			[[У меня не было мыслей, что делать с окном.]]);

		obj {
			nam = 'кровать';
			dsc = [[У стены стоит заправленная {кровать}.]];
			exam = [[Аккуратно заправлена. Думаю, на ней давно не спали.]];
			useit = [[Я посмотрел под кровать. Пусто.]];
		};

		obj {
			nam = 'тумбочка';
			dsc = [[Возле кровати находится {тумбочка}.]];
			exam = [[Небольшая деревянная тумбочка.]];
			useit = [[Я заглянул внутрь тумбочки и не обнаружил ничего интересного.]];
		};
		obj {
			nam = 'лампа';
			dsc = [[На тумбочке стоит {ночник}.]];
			exam = [[Красивая вещица.]];
			take = [[Он бесполезен без электричества.]];
			useit = [[Я пощелкал выключателем. Не работает. Дом обесточен. ]];
		};
		obj {
			nam = 'шкаф';
			dsc = [[У противоположной стены расположен {шкаф}.]];
			exam = [[Платяной шкаф.]];
			useit = [[В шкафу были только вешалки.]];
		}
	};
	way = { vroom('В коридор', floor2) };
}

kiy = obj {
	nam = 'кий';
	dsc = [[На бильярдном столе лежит {кий}.]];
	take = takeit [[Я забрал кий с собой.]];
	exam = [[Длинный и прочный.]];
	useit = [[Поиграть в бильярд? Отец учил нас с братом...]];
	use = function(s, w)
		if w == vantuz then
			p [[Я примотал вантуз к кию изолентой. У меня получился интересный инструмент. Надеюсь, я знаю, зачем он мне.]];
			remove(s, me())
			w.kiy = true
			return
		end
		if nameof(w) == 'бильярд' then
			p [[Что-то не то настроение...]]
			return
		end
		if w == luk then
			if not dog.down then
				return [[Пока я буду заниматься люком, эта тварь меня съест.]];
			end
			return [[Немного не хватает длины.]];
		end
		return [[Ударить кием? Гм...]];
	end;
}

happyr = room {
	nam = 'Комната отдыха';
	pic = 'gfx/19.png';
	dsc = [[Я оказался в довольно просторной комнате, увешанной коврами. ]];
	obj = {
		windows("Сквозь {окна} в западной стене в комнату проникает свет.",
				"Отсюда хорошо просматривается пространство перед особняком.",
				"Я не стал открывать окна.");
		obj {
			nam = 'граммофон';
			dsc = [[У одного из окон на небольшом столике возле стены стоит {граммофон}.]];
			useit = [[Прослушивание музыки сейчас было бы бегством от действительности.]];
			exam = [[На столике лежала пластинка. Гм... Вагнер?]];
		};
		obj {
			nam = 'бильярд';
			dsc = [[В комнате установлен бильярдный {стол}.]];
			exam = function(s)
				if disabled(kiy) then
					p [[На столе я заметил кий.]];
					kiy:enable()
					return
				end
				p [[Бильярдные шары беспорядочно распределены по столу. Вряд-ли эта партия будет закончена.]]
			end;
			useit = [[Этот стол для того, чтобы играть в бильярд.]];
			obj = { kiy:disable() };
		};
		obj {
			nam = 'кальян';
			dsc = [[В дальнем углу на резном столике стоит {кальян}.]];
			exam = [[Тут у них курительный уголок...]];
			useit = [[Накуриться и забыть обо всем???]];
			take = [[Взять с собой и покурить потом? Странные мысли...]];
		};
		obj {
			nam = 'стулья';
			dsc = [[Вдоль стен и около кальяна расположены {стулья}.]];
			exam = [[Резные деревянные спинки и ножки... У нас в доме в основном табуретки, отец их ремонтировал с Андреем в прошлую пятницу...]];
			take = [[Нет смысла переставлять стулья.]];
			useit = [[Я присел на стул и немного перевел дух.]];
		};
	};
	way = { vroom('В коридор', floor2) };
}

d31 = wroom('Дверь 1', 
	function() if floor3.from == 'n' or dog.down then return 'В туалет' end return 'В спальню' end, 
	function() if floor3.from == 'n' or dog.down then return 'toilet' end return 'sleeping' end);

d32 = wroom('Дверь 2', 
	function() if floor3.from == 'n' or dog.down then return 'В ванную' end return 'В кабинет' end,
	function() if floor3.from == 'n' or dog.down then return 'bath' end return 'bossr' end);

d33 = wroom('Дверь 3', 
	function() if floor3.from == 'n' or dog.down then return 'В кабинет' end return 'В ванную' end,
	function() if floor3.from == 'n' or dog.down then return 'bossr' end return 'bath' end);

d34 = wroom('Дверь 4', 
	function() if floor3.from == 'n' or dog.down then return 'В спальню' end return 'В туалет' end,
	function() if floor3.from == 'n' or dog.down then return 'sleeping' end return 'toilet' end);

doors3 = obj {
	nam = 'двери';
	door_type = true;
	dsc = function(s)
		p 'Вдоль коридора, напротив окон, расположены {двери}.';
	end;
	exam = function(s)
		p [[Я осмотрел все двери. Выглядят как двери.]];
		if door34.broken then
			p [[Одна из дверей распилена.]]
		end
	end;
	useit = [[Двери не заперты.]];
}

tdoor = obj {
	nam = 'дверь';
	dsc = function(s)
		if not dog:dead() then
			p [[{Дверь} в коридор закрыта на щеколду.]];
			return
		end;
		p [[{Дверь} в коридор открыта.]];
	end;
	exam = function(s)
		if not dog.down then
			p [[Не думаю, что эта щеколда выдержит атаки черной твари.]];
			return
		end
		p [[В двери -- дырки от выстрела.]];
	end;
}

toilet = room {
	nam = 'Туалет';
	pic = 'gfx/25.png';
	enter = function(s)
		if floor3.from == 's' and not dog:dead() then
			p [[Эта дверь находится в противоположном конце коридора!!!]];
			return false
		end
	end;
	entered = function(s)
		if not dog:dead() then
			dog.state = 3
			p [[Я бросился к двери справа от меня и захлопнул ее за собой!!!
				Чудом я заметил щеколду и закрыл на нее дверь. В следующий момент
				раздался удар.]];				
		end
	end;
	exit = function(s)
		if not dog.down then
			p [[Я не пойду в пасть к этой твари!]]
			return false
		end
	end;
	dsc = [[Я находился в туалете.]];
	obj = { tdoor,
		obj {
			nam = 'унитаз';
			dsc = [[Здесь установлен {унитаз}.]];
			exam = [[Белый и монументальный.]];
			useit = [[Да, от всего, что происходило в этом доме, может не выдержать желудок, но я еще не закончил то, зачем пришел...]];
		};
		obj {
			nam = 'умывальник';
			dsc = [[Рядом находится {умывальник}.]];
			exam = [[Тут есть мыло и зеркало.]];
			useit = [[Вода в дом не поступает.]];
		};
		obj {
			nam = 'крючки';
			dsc = [[На стене висят три {крючка}.]];
			exam = [[Странное ощущение дежа-вю не покидает меня.]];
			take = [[Крепко закреплены.]];
			useit = [[Не могу придумать применения этим крючкам.]];
		};
		windows([[Над унитазом находится открытое {окно}.]], [[Сквозь открытое окно в туалет попадают капли дождя.]], [[Я могу выброситься из окна,
			но это будет означать поражение.]]);
	};
	way = { vroom('В коридор', 'floor3') };
}

medal = obj {
	nam = 'медаль';
	exam = function(s)
		if have(s) then
			p [[Большая круглая медаль. Похоже, с собачьей выставки!]];
		else
			p [[Что-то круглое...]];
		end
	end;
	useit = [[Зачем это мне?]];
	take = takeit [[Я взял странный предмет с пола.]];
	dsc = [[Рядом с чудовищем лежит {что-то} блестящее...]];
	nouse = [[Сложно применить собачью медаль таким образом.]];
}:disable()

dog = obj {
	nam = 'собака';
	var { killed = false; down = false; state = 5; shot = 0; };
	dead = function(s)
		return s.killed
	end;
	life = function(s)
		s.state = s.state - 1
		if s.state == 4 then
			if here() == floor3 then
				p [[Я слышу топот лап по полу!]];
			end
		elseif s.state == 3 then
			if here() == floor3 then
				p [[От ударов массивных лап содрогается пол!!!]]
			end
		elseif s.state == 2 then
			if here() == floor3 then
				gameover = true
				lifeoff(s)
				stop_sound(3)
				walkin 'dogend'
			end
			p [[Чудовище ударилось о закрытую дверь.]]
		elseif s.state == 1 then
			p [[Щеколда вот-вот не выдержит!!]]
		elseif s.state == 0 then
			p [[Массивные удары в дверь мешают сосредоточится!!]]
			gameover = true
			lifeoff(s)
			stop_sound(3)
			walkin 'dogend2'
		else
			return
		end
	end;
	useit = function(s)
		if not s.down then
			return [[Нужно что-то делать!!!]];
		end
		return [[Не хочется копаться в этом.]]
	end;
	exam  = function(s)
		if s.killed then
			p [[Теперь тварь не опасна.]]
		elseif s.down then
			p [[Похожа на гигантскую черную собаку!!! Из многочисленных ран на ковер стекает зеленая жидкость...]]
		else
			if s.state == 4 then
				p [[Эта тварь похожа на гигантскую собаку!]]
			elseif s.state == 3 then
				p [[Черная гигантская собака!!! Ее глаза налиты кровью!!]];
			else
				p [[Я вижу как с пасти этой гигантской собаки на пол капает слюна!!!]]
			end	
			return
		end
		if disabled(medal) then
			medal:enable()
			p [[Рядом с чудовищем я заметил что-то блестящее...]];
		end
	end;
	dsc = function(s)
		if s.killed then
			return [[Перед дверью в туалет лежат останки черного {чудовища}.]]
		end
		if s.down then
			return [[Перед дверью в туалет лежит черное {чудовище}.]]
		end
		if s.state == 4 then
			p [[Из глубины коридора на меня несется черное {чудовище}!]];
		elseif s.state == 3 then
			p (txtem([[Здоровая черная {собака} огромными прыжками приближается ко мне!!!]]))
		elseif s.state == 2 then
		elseif s.state == 1 then
		elseif s.state == 0 then
		else
			return
		end
	end;
	take = [[Мне больше нравятся кошки.]];
}

floor3 = room {
	nam = 'Третий этаж';
	pic = function(s)
		if dog.down then
			if sleeping.broken then
				return 'gfx/26a.png'
			end
			return 'gfx/26.png'
		end
		if s.from == 'n' then
			if dog.state == 4 then
				return 'gfx/24.png'
			else
				return 'gfx/24a.png'
			end
		else
			if dog.state == 4 then
				return 'gfx/24l.png'
			else
				return 'gfx/24la.png'
			end			
		end
	end;
	var { from = 'x'; };
	entered = function(s)
		if not dog.down then
			lifeon(dog)
			if not dog.down then
				p [[Вдруг я отчетливо услышал приближающийся ко мне топот]]
				if s.form == 's' then
					p [[Дверь 1 находится у северной лестницы, а дверь 4 -- у южной.]]
				end
			end
		elseif (not spider1:dead() or not spider:dead()) and dog:dead() then
			make_snapshot()
		end
	end;
	dsc = [[Третий этаж особняка был последним. Я стоял в коридоре, который проходил вдоль всей длины здания.
		Двери в комнаты располагались по одной стороне.]];
	exit = function(s, t)
		if not dog:dead() then
			if dog.down then
				if t == sleeping and not sleeping.broken then
					p [[Я дернул за ручку двери -- закрыто!!!]];
					door34:enable()
					return false
				end
				p [[Когда я уже собирался уйти из коридора, я услышал за собой чье-то тяжелое дыхание.
					Быстро обернувшись, я понял, что уже слишком поздно... Проклятая тварь каким-то образом ожила и готовилась сделать финальный бросок...]];
				lifeoff(dog);
				gameover = true
				stop_sound(3)
				walkin 'dogend'
				return
			end

			if t == floor2 then
				p [[Не долго думая, я бросился назад. Пока я спускался по лестнице, гигантская собака настигла меня.]];
				lifeoff(dog);
				gameover = true
				stop_sound(3)
				walkin 'dogend'
				return
			end

			if s.from == 'n' then
				if t == toilet then
					return
				end
				p [[Пока я буду добираться до этой двери, эта тварь доберется до меня!!!]];
				return false
			else
				if t == sleeping then
					p [[Я дернул за ручку двери слева -- закрыто!!!]];
					door34:enable()
					return false
				end
				p [[Пока я буду добираться до этой двери, эта тварь доберется до меня!!!]];
				return false
			end
		end
	end;
	obj = { windows([[Сквозь залитые дождем окна в восточной стене, в коридор проникает свет.]], [[Дождь все не кончается...]], [[С третьего этажа можно и ноги переломать.]]), 
		dog, medal, doors3, 'door34', 'luk' };
	way = { vroom('Вниз', floor2), d31, d32, d33, d34 };
}

door34 = obj {
	nam = 'дверь 4';
	dsc = function(s)
		if floor3.from == 'n' then
			p [[{Дверь 4} закрыта на ключ.]]
		else
			p [[{Дверь 1} закрыта на ключ.]]
		end
	end;
	useit = [[Эта дверь закрыта.]];
	exam = [[Деревянная дверь темно-коричневого цвета.]];
}:disable()

hclock = obj {
	nam = 'карманные часы';
	dsc = [[На трельяже лежат карманные {часы}.]];
	exam = function(s)
		if not have(s) then
			return 'Карманные часы с римскими цифрами на циферблате.';
		end
		if not disabled(foto) then
			p 'Я осмотрел часы. Они похожи на те, что я видел на фотографии!!!';
		end
		p "Красивая вещь. Думаю, их механизм так же идеален, как и их внешний вид."
	end;
	useit = [[Гм... Я поднес часы к уху... Стоят... 5:32..]];
	nouse = [[Часы мне здесь не помогут.]];
	take = takeit [[Я забрал часы.]];
}

sleeping = room {
	nam = 'Спальня';
	pic = 'gfx/28.png';
	var { broken = false };
	enter = function(s)
		if not s.broken then
			p [[Я не могу попасть туда. Дверь в комнату закрыта.]]
			door34:enable()
			return false
		end
	end;
	dsc = [[Эта комната, скорее всего, служила хозяину спальной. Просторная, хорошо обставленная комната.]];
	obj = {
		obj {
			nam = 'кровать';
			dsc = [[Широкая {кровать} занимает центр комнаты.]];
			exam = [[Выглядит очень мягкой.]];
			useit = function(s)
				if disabled(brother) then
					p [[Скоро стемнеет, мне нужно найти Андрея.]];
				else
					p [[Мне нужно найти способ открыть ворота.]]
				end
			end
		};
		obj {
			nam = 'шкаф';
			dsc = [[Справа от меня находится платяной {шкаф}.]];
			exam = [[Большой деревянный шкаф угрожающе нависает надо мной.]];
			useit = [[Я открыл шкаф и заглянул внутрь. На вешалках висели черные костюмы. Много черных костюмов. Я закрыл дверь.]];					
		};
		obj {
			nam = 'тумбочка';
			dsc = [[Рядом с кроватью стоит {трельяж}.]];
			exam = function(s)
				if hclock:disabled() then
					p [[На трельяже я заметил какой-то предмет.]];
					hclock:enable();
				else
					p [[Зеркала, отражающие друг-друга...]];
				end
			end;
			useit = [[Я изучил содержимое ящиков трельяжа, и не нашел ничего интересного.]]
		};
		hclock:disable();
		windows("{Окно} выходит на западную сторону.",
			"Я уже насмотрелся на этот пейзаж.",
			"Какой смысл открывать окно?");
		
	};
	way = { vroom('В коридор', 'floor3') };	
}

vantuz = obj {
	var { kiy = false, meat = false };
	nam = function(s)
		if s.kiy then
			p 'вантуз на кие';
		else
			p 'вантуз'
		end
	end;
	dsc = [[Под умывальником лежит {вантуз}.]];
	take = takeit [[Когда я брал вантуз, меня не покидало странное ощущение, что он мне обязательно поможет.]];
	useit = [[Что-нибудь протолкнуть?]];
	exam = function(s)
		p [[Крепкая деревянная ручка и большая присоска из черной резины -- надежный механизм!]];
		if s.kiy then
			p [[К тому же он закреплен изолентой на кие.]]
		end
	end;
	nouse = [[Протолкнуть это?]];
	use = function(s, w)
		if w == kiy then
			return w:use(s)
		end

		if (w == dog and dog.down) or nameof(w) == 'слизень' or nameof(w) == 'ошметки' then
			s.meat = true
			p [[Я измазал резиновый конец вантуза.]]
			return
		end

		if w == luk then
			if not s.kiy then
				return [[Не дотянуться.]];
			end
			if spider1:dead() then
				p [[Я снова приоткрыл вантузом крышку люка. Ничего не произошло.]]
				return
			end
			if not s.meat then
				p [[Я взял вантуз на кие и приоткрыл им крышку люка. Ничего не произошло. Я благоразумно закрыл люк.]];
				return
			else
				p [[Я взял дробовик в правую руку, а вантуз в левую, и осторожно приоткрыл им крышку люка.]];
				p [[Вдруг вантуз в моей руке вздрогнул. На конце вантуза, ухватившись мохнатыми лапами за присоску,
				сидел рыжий паук!]];
				lifeon(spider1)
				put(spider1);
			end			
		end
	end;
}:disable()

bath = room {
	nam = 'Ванная';
	pic = 'gfx/27.png';
	dsc = [[Я оказался в ванной комнате.]];
	obj = { 
		obj {
			nam = 'ванная';
			dsc = [[Вдоль стены стоит {ванная}.]];
			exam = [[Бронза? Ножки в стиле барокко.]];
			take = [[Взять ее с собой? Нет ничего проще.]];
			useit = [[Воды нет.]];
		};
		obj {
			nam = 'умывальник';
			dsc = [[Слева от ванной расположен {умывальник}.]];
			exam = function(s)
				if disabled(vantuz) then
					p [[Под умывальником я обнаружил вантуз.]];
					vantuz:enable();
				else
					p [[Умывальник чист.]];
				end
			end;
			useit = [[В доме нет воды.]];
		};
		vantuz,
		obj {
			nam = 'зеркало';
			dsc = [[На кафельной стене висит большое {зеркало}.]];
			exam = [[Зеркало великолепно, как и вся фурнитура в этом доме.]];
			useit = [[Я всмотрелся в незнакомое и усталое лицо.]];
			take = [[Не хочется таскать его с собой.]];
		};
		windows ([[В ванной есть {окно}.]], [[Окно закрыто.]], [[Эта аномальная тяга к окнам начинает меня пугать.]]);
	};
	way = { vroom('В коридор', 'floor3') };	
}

bossdoor = obj {
	nam = 'дверь';
	dsc = [[{Дверь}, ведущая в коридор, вся в дырках.]];
	exam = [[Шесть дырок. Интересно, паз в косяке двери выломан.]];
	useit = [[Похоже, что замок этой двери выломан сильным ударом снаружи.]];	
}

revol = obj {
	nam = 'револьвер';
	var { armed = false, ammo = 0 };
	dsc = [[На полу валяется {револьвер}.]];
	take = takeit [[Я взял револьвер с собой.]];
	exam = function(s)
		if not have(s) then
			p [[Револьвер лежит в центре комнаты.]]
			return
		end
		p [[Револьвер .38 калибра.]]
		if not s.armed then
			p [[Барабан на 6 патронов пуст.]]
			return
		end
		if s.ammo == 1 then
			p [[В барабане 1 патрон.]]
		elseif s.ammo == 5 then
			p [[В барабане 5 патронов.]]
		else
			p([[В барабане ]], s.ammo, [[ патрона.]]);
		end
	end;
	useit = function(s)
		p [[Думаю, у него хорошая скорострельность. Но целиться не так удобно.]]
	end;
	shot = function(s) s.armed = false; add_sound 'snd/revol.ogg' end;
	use = function(s, w)
		if not s.armed then
			return [[Револьвер не заряжен.]], false;
		end
		if w == spider1 then
			if w:dead() then
				return [[Лучше поберегу патроны. Их и так не много.]]
			end
			gameover = true
			p [[Я попытался выхватить револьвер из кармана, но не успел...]]
			lifeoff(spider1)
			lifeoff(pila)
			stop_sound(3)
			walkin 'spiderend2'
			return
		end
		if w == door34 then
			if not dog.down then
				return [[Пока я буду стрелять в дверь, эта тварь меня съест.]];
			end
			return [[Лучше воспользоваться дробовиком.]]
		end;
	end;
	nouse = [[Стукнуть револьвером?]];
}

foto3 = obj {
	nam = 'фото';
	dsc = [[На стене висит большая {фотография} в рамке.]];
	exam = function(s)
		p [[На фотографии в массивной раме изображен человек с редкой бородой и собака -- ротвейлер.
		Собака встала на задние лапы и, положив свои лапы на плечи человека, лижет ему лицо. 
		Человек улыбается. На ошейнике у собаки висит медаль.]];
		if taken(medal) then
			p [[Я несколько минут смотрел на фотографию.]]
			p [[Странные мысли приходили мне в голову. Я подумал, что эта собака не виновата в том,
			что с ней произошло. Мне стало больно.]];
		end
	end;
	useit = function(s)
		if not visited 'safe' then
			p [[Я внимательно изучил картину и сделал это не зря! Картина откидывалась в сторону,
			словно дверь. За ней был спрятан сейф.]];
		else
			p [[Я подошел к сейфу.]]
		end
		walkin 'safe'
	end;
	take = [[Слишком большая, чтобы таскать ее с собой.]];
}

mkeys = obj {
	nam = 'ключи';
	dsc = [[В ящике стола лежат {ключи}.]];
	exam = [[По-моему, это ключи от машины!]];
	take = takeit [[Я взял ключи из ящика.]];
	useit = [[Теперь я знаю, как мы выберемся отсюда!]];
	use = function(s, w)
		if w == car or w == card then
			return [[Я уеду только с братом!!!]];
		end
	end;
	nouse = [[Не подходят.]];
}

bossr = room {
	nam = 'Кабинет';
	pic = 'gfx/29.png';
	entered = function(s)
		if not visited() then
			p [[Заходя в эту комнату, я заметил, что дверь в нее была приоткрыта...]];
		end
	end;
	dsc = [[Просторная комната в которой я находился, скорее всего служила хозяину особняка кабинетом.]];
	obj = { windows("Окно в комнате {разбито}.",
			"Рама выломана, сквозь разбитое окно в комнату попадает дождь.",
			"Я подошел к окну и посмотрел вниз. Ничего необычного я не заметил.");
			obj {
				nam = 'стол';
				dsc = [[Возле окна установлен массивный {стол}.]];
				exam = [[На столе беспорядок. Ворох бумаг, упавшая лампа, разлитые чернила...]];
				useit = function()
					p [[Я выдвинул ящик стола.]];
					if mkeys:disabled() then
						p [[Какие-то ключи!]];
						mkeys:enable()
					else	
						p [[Пусто.]];
					end
				end;
				obj = {
					mkeys:disable()
				}
			};
			obj {
				nam = 'бумаги';
				dsc = [[По всей комнате разбросаны {бумаги}.]];
				exam = [[Думаю их разметал со стола ветер, который проникает в комнату сквозь разбитое окно.]];
				useit = [[Я посмотрел несколько листков. Какие-то химические формулы?]];
				take = function(s)
					if disabled(brother) then
						p [[Они мне не нужны. Мне нужно найти брата.]];
					else
						p [[Вряд ли они мне нужны.]];
					end
				end
			};
			revol,
			foto3, 
			bossdoor,
	};
	way = { vroom('В коридор', 'floor3') };	
}

function val(n)
	local v = {}
	v.nam = n
	v._state = rnd(10) - 1;
	v.dsc = function(s)
		p("{",v._state,"}");
	end
	v.exam = function(s)
		p ("Ручка была выставлена в позицию ",s._state, ".")
		s:useit();
	end;
	v.useit = function(s)
		s._state = s._state + 1
		if s._state == 10 then
			s._state = 0;
		end
		p "Я перевел ручку в следующее положение."
	end
	return obj(v)
end

patron = obj {
	nam = '9мм патроны';
	dsc = [[В глубине сейфа лежат {патроны} к револьверу.]];
	take = takeit [[Я забрал патроны.]];
	useit = [[Хорошо, что я их нашел!]];
	exam = [[9мм патроны. Оптимальный диаметр. К сожалению в коробке осталось только 5 патронов.]];
	use = function(s, w)
		if w == revol then
			p [[В коробке было только 5 патронов. Я зарядил ими револьвер.]]
			w.armed = true
			w.ammo = 5
			remove(s, me())
			return
		end
		return [[Это патроны для револьвера.]]
	end
}

insafe = obj {
	nam = 'в сейфе';
	dsc = function(s)
		p [[В сейфе лежат слитки {золота}.]];
	end;
	exam = [[Золото. Весь сейф полон слитками золота.]];
	take = [[Первым моим желанием было взять пару слитков, но потом я почувствовал, что золото фашистов мне не нужно.]];
	useit = function(s)
		if not patron:disabled() then
			p [[Больше ничего интересного в сейфе не оказалось.]]
		else
			p [[Я сдвинул несколько слитков в сторону и заметил в глубине сейфа коробку с патронами для револьвера!]];
			patron:enable()
		end
	end;
	obj = {
		patron:disable(),
	}
}:disable();


safe = room {
	var { opened = false; };
	nam = 'У сейфа';
	pic = function(s)
		if s.opened then
			return 'gfx/30a.png'
		else
			return 'gfx/30.png'
		end
	end;
	dsc = "Сейф выглядит надежно.";
	obj = {
		obj {
			nam = 'дверца';
			dsc = 'Я стою у металлической {дверцы} сейфа. На дверце восемь ручек с цифрами:';
			exam = [[Да, перебор здесь не поможет...]];
			useit = function(s)
				if safe.opened == true then
					return "Сейф открыт!";
				end
				if objs()[2]._state == 1 and
					objs()[3]._state == 8 and
					objs()[4]._state == 8 and
					objs()[5]._state == 9 and
					objs()[6]._state == 1 and
					objs()[7]._state == 9 and
					objs()[8]._state == 4 and
					objs()[9]._state == 5 then
					safe.opened = true
					insafe:enable();
					return "Я потянул ручку сейфа на себя и дверь открылась!";
				end
				return "Не открывается.";
			end;
		};
		val('1'); val('2'); val('3'); val('4');
		val('5'); val('6'); val('7'); val('8');
		insafe;
	};
	way = { vroom('Назад', 'bossr')};
}

spider1 = obj {
	var { killed = false, trigger = false };
	nam = 'паук';
	dsc = function(s)
		if s.killed then
			return [[Под люком на полу валяются останки {паука}.]];
		end
		p (txtem [[На вантузе сидит {паук}!]]);
	end;
	take = [[Нет, спасибо.]];
	useit = [[Сложно найти применение этому.]];
	exam = function(s)
		if s.killed then
			p [[Он разлетелся на куски! Целыми остались только мохнатые лапы.]];
		else
			p [[Он сейчас бросится на меня!!!]]
		end
	end;
	dead = function(s) return s.killed end;
	kill = function(s)
		lifeoff(s)
		s.killed = true
		make_snapshot()
	end;
	life  = function(s)
		if not s.trigger then
			s.trigger = true
			return [[Паук сейчас набросится на меня!!!]];
		end
		lifeoff(s);
		lifeoff(pila)
		gameover = true
		stop_sound(3)
		walkin 'spiderend2';
	end;
}

luk = obj {
	nam = 'люк';
	door_type = true;
	dsc = 'В северной стороне коридора в потолке находится {люк}.';
	exam = [[Он ведет на чердак. Рядом с люком есть небольшая лестница.]];
	useit = function(s)
		if not dog.down then
			p [[Пока я буду взбираться по лестнице чудовище доберется до меня!]];
			return
		end
		if not spider1:dead() then
			gameover = true;
			lifeoff(dog)
			lifeoff(pila)
			stop_sound(3)
			walkin 'spiderend'
			return
		end
		p [[Я начал взбираться по лестнице. Достигнув крышки люка, я толкнул ее ружьем и выбрался
			на чердак.]]
		walk 'floor4';
	end
}

antifire = obj {
	nam = 'огнетушитель';
	dsc = function(s)
		if here() == floor4 then
			p [[На полу валяется пустой {огнетушитель}.]]
		else
			p [[В углу стоит {огнетушитель}.]];
		end
	end;
	take = function(s)
		if here() == floor4 then
			return [[Я уже его использовал.]]
		end
		p [[Я забрал огнетушитель.]];
		return true
	end;
	useit = function(s)
		if not have(s) then
			return [[Я его не взял.]]
		end
		p [[Пожара пока нет. Пока...]];		
	end;
	exam = [[Красный железный баллон.]];
	nouse = [[Это не нужно тушить.]];
}

lab = room {
	nam = 'В лаборатории';
	pic = function(s)
		if seen 'стол'.broken then
			return 'gfx/23a.png'
		else
			return 'gfx/23.png'
		end
	end;
	dark = true;
	dsc = [[Я оказался в довольно просторном помещении, занимавшем большую часть пространства под каминным залом.]];
	exit = function(s)
		if not seen 'стол'.broken or not seen 'колбы'.broken then
			p [[Мне кажется, прежде чем уйти, нужно уничтожить это зло. Возможно, что я не смогу сюда больше вернуться.]];
			return false
		end
	end;
	obj = {
		obj {
			var { broken = false };
			nam = 'стол';
			dsc = function(s)
				if s.broken then
					p [[На длинном {столе} хаос из битого стекла.]];
				else
					p [[Здесь есть длинный {стол}, на котором находятся какие-то приборы.]];
				end
			end;
			exam = function(s)
				if s.broken then
					p [[На столе месиво из стекла и пластика. Я хорошо поработал.]];
				else
					p [[Колбочки, пробирки с зеленой жидкостью, какие-то странные устройства...]];
				end
			end;
			used = function(s, w)
				if w == pila or w == shotgun then
					if s.broken then
						return [[Зло разрушено.]];
					end
					if w == pila then
						add_sound 'snd/chain3.ogg'
						p [[Не долго думая, я принялся крушить все, что стояло на столе.]]
					else
						shotgun:shot()
						p [[Я выстрелил в стеклянные сооружения из дробовика, а затем принялся крушить то, что осталось...]]
						p [[Звон битого стекла заполнил комнату.]]
					end
					add_sound 'snd/crash.ogg'
					s.broken = true
				end
			end;
			take = [[Мне не нужен весь этот хлам.]];
			useit = [[Вот оно, зло -- подумал я.]];
		};
		obj {
			nam = 'колбы';
			var { broken = false };
			dsc = function(s)
				if s.broken then
					return [[По всей лаборатории валяется битое стекло и останки {тварей}.]];
				end
				p [[На полках вдоль стен стоят стеклянные {колбы}.]];
			end;
			exam = function(s)
				if s.broken then
					return [[Они не виноваты в том, что стали такими. Этот дом оказался страшным местом, надеюсь, с моим братом все в порядке.]]
				end
				p [[В больших колбах я вижу каких-то странных существ.. Лучше держаться от них подальше...]];	
			end;
			take = [[Мне не нужен всякий хлам.]];
			useit = [[Не нужно это трогать.]];
			used = function(s, w)
				if w == pila or w == shotgun then
					if s.broken then
						return [[Зло разрушено.]];
					end
					add_sound 'snd/chain3.ogg'
					if w == pila then
						p [[Не долго думая, я принялся крушить колбы.]]
						p [[Твари были живы, и пытались выбраться из битого стекла, но на этот раз у них не было шансов.]]
						s.broken = true
					else
						p [[Я выстрелил из дробовика в одну из колб, и она разлетелась на мелкие осколки.
						Тварь в колбе была жива и набросилась на меня.
						К счастью, я успел включить бензопилу.]]
						shotgun:shot()
						pila.on = true
						lifeon(pila)
						s.broken = true
						p [[Затем я принялся за другие колбы... Через несколько минут все было кончено.]];
					end
					add_sound 'snd/crash.ogg'
				end
			end;
		};
		obj {
			nam = 'дверь';
			door_type = true;
			dsc = [[В северной стене расположена железная {дверь}.]];
			exam = [[Похоже, эта дверь ведет в помещение склада, где я видел бочки с зеленой дрянью.]];
			useit = [[Лучше ее не открывать, там все залила эта проклятая зеленая слизь в бочках.]];
		};
		antifire,
	};
	way = { vroom('Наверх', lroom) };
}

spider = obj {
	var { killed = false, step = 1, shotgun = 0, revol = false, pila = false };
	dead = function(s)  return s.killed end;
	nam = 'паук';
	useit = function(s)
		p[[Мне сложно найти применение]];
		if s.killed then
			p [[дохлому пауку.]]
		else
			p [[гигантскому пауку.]];
		end
	end;
	exam = function(s)
		if s.pila then
			return [[Даже останки паука выглядят угрожающе.]];
		end
		if s.killed then
			return [[Выглядит дохлым, но лучше я буду держаться от него подальше.]];
		end
		return [[Этот паук намного больше первого!!! Он громаден!!!]];
	end;	
	dsc = function(s)
		if s.pila then
			return [[Перед люком, ведущим на третий этаж, валяются останки {паука}.]];
		end
		if s.killed then
			return [[Перед люком, ведущим на третий этаж, безжизненно лежит {паук}.]];
		end
		if s.step == 2 then
			p [[Я вижу, как по наклонной крыше чердака ко мне приближается громадный {паук}!]];
		elseif s.step == 3 then
			p [[{Паук} движется очень быстро, я уже различаю волоски, которыми покрыто его жирное брюхо.]];
		elseif s.step == 4 then
			p (txtem([[{Паук} прямо передо мной. С его страшных челюстей стекает зеленая слизь!]]));
		elseif s.step == 6 then
			p [[{Паук} движется очень быстро, я уже различаю его злые маленькие глаза!!!]];
		elseif s.step == 7 then
			p (txtem([[{Паук} прямо передо мной. С его страшных челюстей стекает зеленая слизь!]]));
		end
	end;
	life = function(s)
		if s.step == 1 then
			p [[Я слышу тихий шорох, с которым паук передвигается по крыше чердака!!!]];
		elseif s.step == 2 then
			p [[Паук стремительно приближается ко мне. Он громаден!!! Интересно, как он умудряется ползти по наклонной крыше?]];
		elseif s.step == 3 then
			p [[Я думаю, паук сейчас нападет на меня!]];
		elseif s.step == 4 or s.step == 7 then
			gameover = true
			lifeoff(s)
			lifeoff(pila)
			stop_sound(3)
			walkin 'spiderend3'
			return
		elseif s.step == 5 then
			p [[Паук стремительно приближается ко мне. Он громаден!!!]];
		elseif s.step == 6 then
			p [[Я думаю, паук сейчас нападет на меня!]];
		end
		s.step = s.step + 1
	end;
	kill = function(s)
		s.killed = true
		lifeoff(s)
	end;
	used = function(s, w)
		if w == pila then
			if s.pila then
				return [[Я не мясник.]]
			end
			if s.killed then
				s.pila = true
				add_sound 'snd/chain3.ogg';
				return [[Теперь он точно не причинит вреда.]]
			end
			return [[Боюсь, холодное оружие здесь не поможет.]]
		end
		if s.step == 7 then
			if w == shotgun  then
				w:shot()				
				p [[Я разрядил двустволку прямо в страшную голову паука.]]
				if s.shotgun == 1 and s.revol then
					p [[Паук дернулся всем своим ужасным рыжим телом, сделал еще один шаг и, наконец, обмяк.]]
					s:kill()
				else
					p [[Но проклятая тварь бросилась на меня...]]
					gameover = true
					lifeoff(s)
					stop_sound(3)
					walkin 'spiderend3'
				end
				return
			elseif w == revol then
				w:shot()
				p [[Я разрядил револьвер в страшную голову паука.]]
				if s.shotgun == 2 then
					p [[Паук дернулся всем своим ужасным рыжим телом, сделал еще один шаг и, наконец, обмяк.]]
					s:kill();
				else
					p [[Но проклятая тварь бросилась на меня...]]
					gameover = true
					lifeoff(s)
					stop_sound(3)
					walkin 'spiderend3'
				end
				return
			end
		end
		if w == shotgun then
			if s.step == 4 then
				p [[Я разрядил двустволку в гигантского паука, но было уже поздно...]]
				w:shot()
				lifeoff(s)
				gameover = true
				stop_sound(3)
				walkin 'spiderend3'
				return
			end
			p [[Я разрядил двустволку в гигантского паука. Судя по зеленым брызгам, которые разлетелись от его жирного тела,
				я попал, но паук продолжал свой бег.]]
			s.shotgun = s.shotgun + 1
			w:shot()
			return
		end
		if w == revol then
			p [[Я выхватил револьвер и разрядил весь барабан в страшное создание, пулю за пулей.]];
			if s.step == 4 then
				p [[Но было уже поздно...]]
				lifeoff(s);
				gameover = true
				stop_sound(3)
				walkin 'spiderend3'
				return
			end
			if s.step == 2 then
				w:shot()
				p [[Увы, расстояние до паука было слишком большим и я промазал!]];
			else
				p [[Паук содрогнулся но, помедлив, продолжил свой страшный бег.]]
				w:shot()
				s.revol = true;
			end
			return
		end
		if w == antifire then
			if w.empty then
				return [[Огнетушитель уже пустой.]];
			end
			w.empty = true
			drop(w);
			add_sound 'snd/antifire.ogg'
			if s.step == 4 then
				p [[Я сорвал пломбу с огнетушителя, ударил его об пол и направил шипящий поток в жирную тварь!!!
					Паук с глухим стуком свалился с потолка и отбежал в дальнюю часть чердака.
					Некоторое время он смотрел своими маленькими злыми глазками на пену, выходящую из
					огнетушителя, а затем, начал снова быстро приближаться ко мне...]]
				s.step = 5
			else
				p [[Я сорвал пломбу с огнетушителя, ударил его об пол и начал заливать чердак пеной.
					Но паук был слишком далеко, и продолжал приближаться ко мне.]];
			end
		end
	end;
}

brother = obj {
	nam = 'брат';
	var { web = true };
	dsc = [[У одного из ящиков я нашел {брата}!]];
	exam = function(s)
		if s.web then
			p [[Он весь был опутан толстыми и липкими нитями паутины.]];
			return
		end
		if not have(s) then
			p [[Мой брат лежал возле проклятых ящиков.]];
			return
		end
		return [[Я держу брата.]];
	end;
	useit = function(s)
		if s.web then
			p [[Я потряс его и крикнул: Андрей!!! Звук моего голос быстро потонул в шуме дождя, барабанившего по крыше.]]
			return
		end
		if not have(s) then
			p [[Я пощупал пульс. Он был редким и слабым, но мой младший брат был жив!]];
			return
		end
		return [[Я крепче обнял брата. Все будет хорошо!!!]]
	end;
	used = function(s, w)
		if w == shotgun or w == pila then
			return [[Это помысел от лукавого...]];
		end
	end;
	take = function(s)
		if s.web then
			p [[Я хотел взвалить брата на плечи, но он был весь опутан толстой и липкой паутиной. Надо его освободить!]];
			return
		end
		if not have(mkeys) then
			p [[Прежде чем уносить его отсюда, нужно найти путь открыть ворота. А здесь он в относительной безопасности.]] 
			return
		end
		p [[Я взвалил брата на плечо.]];
		lifeoff(music_player)
		timer:stop()
		set_music('mus/13 Heart on fire.ogg');
		return true
	end;
}
boxes = obj {
	nam = 'ящики';
	dsc = [[На чердаке есть множество деревянных {ящиков}.]];
	used = function(s, w)
		if not spider:dead() then
			return [[Сейчас лучше подумать о себе.]]
		end
		if w == shotgun or w == pila then
			if brother:disabled() then
				return [[Я уже достаточно выяснил. Лучше я найду брата.]]
			end
			return [[Я нашел брата!!! Мне плевать, что в этих ящиках.]];
		end
	end;
	useit = function(s)
		if not spider:dead() then
			p [[Прятаться уже поздно!]];
			return
		end
		if not spider.pila then
			lifeoff(spider);
			gameover = true
			stop_sound(3)
			walkin 'spiderend3'
			return [[Я начал осматривать ящики, когда вдруг услышал за спиной какой-то шорох. Я обернулся, чтобы увидеть, что проклятая тварь ожила!!!]];
		end
		if disabled(brother) then
			p [[Я начал бродить среди ящиков, пока в углу чердака не заметил какой-то силуэт.]];
			p [[Я приблизился. Это был мой брат!!! Опутанный толстой паутиной, он не подавал признаков жизни.]]
			brother:enable()
			return
		end
		return [[Наконец, я нашел своего брата!!!]];
	end;
	exam = function(s)
		p [[Деревянные ящики. Многие из них на цепях с замками.]]
	end;
	obj = { brother:disable() };
}

floor4 = room {
	nam = 'На чердаке';
	pic = function(s)
		if have (brother) then
			return 'gfx/32.png'
		end
		if spider:dead() then
			return 'gfx/31e.png'
		end
		if spider.step == 2 then
			return 'gfx/31.png'
		elseif spider.step == 3 then
			return 'gfx/31a.png'
		elseif spider.step == 4 then
			return 'gfx/31b.png'
		elseif spider.step == 6 then
			return 'gfx/31c.png'
		elseif spider.step == 7 then
			return 'gfx/31d.png'
		end
	end;
	dark = true;
	dsc = [[Я находился на чердаке особняка. Наклонные плоскости крыши находились довольно высоко надо мной.
		Здесь было темно и сыро, сквозь разбитое окно на чердак врывался ветер.]];
	entered = function(s)
		if not flash.on then
			p [[Здесь было очень темно и я включил фонарик.]]
			flash.on = true
			lifeon(flash)
		end
		if not spider:dead() then
			lifeon(spider);
			p [[Оказавшись на чердаке, я осветил его фонариком... Мое сердце замерло, а потом резко забилось.
			Луч фонарика отразился от маленьких злых глаз жирной твари, она заметила меня и начала свое приближение.
			Гигантский паук, в несколько раз больший, чем тот, которого я убил, перебирая своими мохнатыми лапами,
			полз по наклонной крыше из дальнего угла чердака...]]
		end
	end;
	exit = function(s, t)
		if have 'brother' then gameover = true lifeoff(pila) stop_sound(3) walkin 'happyend' return end
		if not spider.killed then
			lifeoff(spider);
			gameover = true
			stop_sound(3)
			walkin 'spiderend3'
			return [[Заметив, что я пытаюсь сбежать, паук резко бросился вперед. Я не успел закрыть крышку люка...]];
		end
		if not spider.pila then
			lifeoff(spider);
			gameover = true
			stop_sound(3)
			walkin 'spiderend3'
			return [[Я начал спускаться на третий этаж, когда вдруг услышал за спиной какой-то шорох. Я обернулся, чтобы увидеть, что проклятая тварь ожила...]];
		end
	end;
	obj = { spider, boxes, windows([[Круглое {окно} чердака разбито.]], [[В окно льет дождь.]], [[Похоже, окно разбила эта тварь!!!]]),
			obj {
				nam = 'кости';
				dsc = [[Возле окна лежит груда {костей}.]];
				exam = [[Боюсь представить, чьи эти кости.]];
				take = [[Мне это не нужно!]];
				useit = [[Как?]];
			} };
	way = { vroom('Вниз', floor3) };
}

happyend = room {
	nam = 'Конец';
	pic = 'gfx/33.png';
	hideinv = true;
	forcedsc = true;
	dsc = function(s)
		p [[Мы проезжали через мост, когда в зеркале заднего вида я увидел бледное лицо Андрея.^
		-- Куда мы едем?^
		-- Домой.^
		Он помолчал, разглядывая темноту за стеклом.^
		-- Эта та машина из особняка?^
		-- Да, нужно было как-то открыть ворота... Я ее потом... верну.^
		-- Что со мной было?^
		-- Ты что-нибудь помнишь?^
		-- Да, я перелез по дереву через ограду, -- его голос зазвучал виновато, -- потом я заглядывал в окна,
		подошел к входной двери, и тут... на меня как будто что-то упало сверху. Потом...^
		-- Что было потом?^
		-- Не помню, кажется какое-то темное место и... Мне кажется... Не знаю... -- на его лице был написан вопрос, -- где ты меня нашел?^
		-- Я нашел тебя возле двери, ты потерял сознание. Рядом валялась сломанная оконная рама, наверное, она стукнула тебя по голове. Зря ты полез туда, Андрей, --
		я постарался, чтобы мой голос звучал строго.^
		-- Я знаю, что виноват. Как думаешь, отец рассердится?^
		-- Он тебя любит.^
		-- Расскажешь ему?^
		-- Ты сам ему расскажешь.^
		Лицо брата в зеркале на миг потемнело, но затем приобрело спокойное выражение. Его глаза были грустными, но счастливыми.^
		-- Да, хорошо.^
		]];
		if taken(cap) then
			p [[-- Держи, нашел рядом с тобой, -- я протянул назад кепку.^
			-- Спасибо!]]
		end
		p [[Мы помолчали.^
			-- Иван!^
			-- Что?^
			-- Ты спину где-то испачкал. Зеленой краской...^
			-- Да? Не страшно... Отстираю дома...]];
	end;
	obj = { obj {
		nam = 'дальше';
		dsc = [[{Дальше}]];
		act = code [[ me():disable_all(); walk 'titles']];
	} };
}

titles2 = room {
	nam = '...';
	hideinv = true;
	forcedsc = true;
	dsc = function(s)
		local k,v
		local center = true
		for k,v in ipairs(titles.txt) do
			if v == 'center' then center = true
			elseif v == 'left' then center = false
			else
				if center then
					pn(txtc(v))
				else
					pn(v)
				end
			end
		end
	end;
}
titles = room {
	nam = '';
	hideinv = true, 
	txt = { 
		"Программирование и иллюстрации:", 
		"Петр Косых", 
		" ",
		"Иллюстрации для оформления:",
		"http://fromoldbooks.org",
		" ",
		"Музыка:",
		"Александр Соборов (excelenter)",
		"http://electrodnevnik.ru",
		" ",
		"Звуки:",
		"http://www.freesound.org",
		" ",
		"Движок INSTEAD:",
		"Петр Косых",
		"http://instead.syscall.ru",
		" ",
		"На сценарий повлияли следующие игры:",
		"Maniac Mansion by Lucasfilm",
		"Malstrum's Mansion by ACE Team",
		"Проклятое наследство // Николай Жариков",
		"Dangerous Dave 2 by Id Software",
		"Escape The Toilet // В. Подобаев",
		" ",
		"Благодарности:",
		"Жене и детям",
		"Александру Соборову",
		"Вадиму Балашову",
		"Владимиру Подобаеву",
		"Всем, кто не мешал работать",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		"left",
		"— Иван, ты слышал???",
		"— Что?",
		"— Тот дом сгорел! Ничего от него не осталось!",
		"Все говорят, его подожгли!",
		"А вчера, когда ты возвращал машину, он был еще целым?",
		"— Гм... Ты кому-нибудь говорил, что мы были там?",
		"— Нет.",
		"— Хорошо. Не говори. Скорее всего, это молния...",
		"— Молния?",
		"— Да, молния... Так бывает. Редко, конечно, но бывает.",
		"— Молния...",
		"— Да, уверен, это была молния...",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		"center",
		"КОНЕЦ",
	};
	off = 200;
	w = 0;
	enter = function(s)
		set_music('mus/09 Good morning.ogg');
		if (PLATFORM ~= 'UNIX' and PLATFORM ~= 'WIN32') or theme:name() ~= '.' then
			return walk 'titles2';
		end
	end;
	fading = 16;
	entered = function(s)
		theme.win.geom((800 - 500) / 2, (600 - 200) / 2, 500, 200);
		theme.set('scr.gfx.bg', '');
		theme.set('scr.col.bg', 'black');
		theme.set('inv.mode', 'disabled');
		s:ini(true, true)
	end;
	timer = function(s)
		sprite.fill(SCR, 'black')
		sprite.draw(TEXT, s.pic, (500 - s.w) / 2, s.off);
		s.off = s.off - 1
		local w,h = sprite.size(TEXT)
		if s.off < -h + 100 - FH/2 then
			timer:stop()
		end
	end;
	ini = function(s, load, force)
		local k, v, h
		local spr = {};
		local w = 0
		local m = 0
		local center = true
		if (not load or not visited(s)) and not force then
			return
		end
		FN = sprite.font('gfx/sans.ttf', 16)
		SCR = sprite.load ('box:500x200,black')
		if not FN or not SCR then
			return
		end
		h = sprite.font_height(FN)
		FH = h
		for k,v in ipairs(s.txt) do
			if v == 'left' then
				table.insert(spr, v);
			elseif v == 'center' then
				table.insert(spr, v);
			else
				m = m + 1
				local t = sprite.text(FN, v, 'white');
				table.insert(spr, t);
				local ww, hh = sprite.size(t);
				if ww > w then
					w = ww
				end
			end
		end
		TEXT = sprite.load('box:'..tostring(w)..'x'..tostring(h * m)..',black');
		if not TEXT then
			return
		end
		local x, y
		y = 0
		for k, v in ipairs(spr) do
			if v == 'left' then center = false
			elseif v == 'center' then center = true
			else
				local ww, hh = sprite.size(v);
				if center then
					x = ((w - ww) / 2)
				else
					x = 0;
				end
				sprite.draw(v, TEXT, x, y);
				y = y + sprite.font_height(FN)
			end
		end
		s.w = w
		s.pic = SCR
		timer:set(60)
	end;
}
-- vim:ts=4
