require "nolife"
require "snapshots"

morph:word { plural = true, 
"деревья",
"деревья",
"деревьям",
"деревья",
"деревьями",
"деревьях"}

girl = obj {
	live = true;
	attr [[~exam]];
	nam = function(s)
		if not s.exam then
			return _"силуэт";
		else
			return _"девушка|~силуэт";
		end
	end;
	Exam = function(s)
		p [[Тусклый тонкий силуэт на краю крыши. Мне кажется, это девушка!]]
		if here() == roof then
			p [[Что она делает здесь? Надо что-то предпринять!]]
			return
		end
		if not s.exam then
			p [[Что она делает там? Неужели? О, нет, она собирается прыгать?]];
			s.exam = true;
		end
	end;
	TalkTo = function(s)
		if here() == roof then
			p [[-- Послушайте! Эй, вы! -- громко произношу я, но девушка не обращает на меня внимания.]];
			return
		end
		p [[-- Эй, постойте! Послушайте меня!!! -- услышал я свой хриплый и дрожащий голос. Конечно, ничего не изменилось.]];
	end;
	alias [[ Exam: LookAt ]];
	Default = function(s)
		p [[Девушка далеко.]]
	end;
	Walk = function(s)
		if here() == roof then
			walk 'fall' 
			return
		end
		parser:redirect({'WalkIn', win});
		return true
	end;
}:disable();

door = obj {
	attr [[openable]];
	nam = _'дверь|~выход';
	WalkIn = [[Нет настроения гулять.]];
	Exam = [[Обшарпанная деревянная дверь, окрашенная в синий цвет.]];
	alias [[ Walk: Open ]];
}

win = obj {
	attr [[openable,first]];
	nam = _'окно';
	before_Open = function(s)
		if here().rain then
			p [[За стеклом дождь, не хочу, чтобы он намочил мои картины.]]
			return
		end
	end;
	after_Open = function(s)
		p [[Я открыл окно. В мастерскую дохнуло свежестью.]]
		girl:enable()
		if s.first then
			p [[Мой взгляд скользнул по мокрой крыше, когда... Я заметил чей-то силуэт на самом краю!]]
			s.first = false
		else
			p [[Я вижу силуэт на краю крыши!]];
		end
	end;
	after_Close = function(s)
		girl:enable();
	end;
	Exam = function(s)
		p [[Небольшое чердачное окно, через которое поступает свет в мою мастерскую. Оно выходит на покатую мокрую крышу.]]
		if s.opened then
			p [[Окно открыто.]]
		else
			p [[Окно закрыто.]]
		end
	end;
	WalkIn = function(s)
		if not s.opened then
			p [[Окно закрыто.]]
			return
		end
		if girl.exam then
			walk 'roof'
			return
		end
		p [[Мне не хочется сейчас гулять по крыше.]];
	end;
};

phone_dlg = cutscene {
	hideverbs = false;
	nam = 'Телефонный разговор';
	nolife = true;
	dsc = {
		[[-- Привет, старик, ну как ты? -- услышал я знакомый голос.^
		-- Нормально..]],
		[[-- Нормально? Что-то изменилось у тебя? Ха-ха-ха, не важно,
		это все не важно, потому что я нашел тебе работу!!! Одевайся, через час у тебя
		собеседование!^
		-- Собеседование?]],
		[[-- Да, старик, вопросы и благодарности потом. Я им
		расписал тебя в лучших красках, кажется, они даже знают твою фамилию, 
		что, признаюсь, меня немало удивило. В общем, давай, собирайся, записывай адрес...^-- А что за работа?]],
		[[-- Старик, ты меня огорчаешь! Не в твоей ситуации выбирать. Не бойся, это не грязная работа, будешь рисовать.^ -- Рисовать?]],
		[[-- Да, рисовать! Ты что-то туго сегодня соображаешь. Дай угадаю, напился вчера? Ах-ха-ха-ха-ха! Но теперь твоя жизнь изменится, и все благодаря мне!^Но у тебя мало времени, одевайся, найди какой-нибудь костюм, или что-то вроде этого, тебе нужно добраться до рекламного агентства "Зеркало", оно находится возле...]],
		[[-- Постой, рекламное агентство? Рисовать рекламу?^-- Ну конечно, в рекламных агентствах рисуют рекламу, наконец-то ты приходишь в себя. Короче, это одно из лучших агентств, и тебе крупно повезло, потому что...]],
		[[-- Я не поеду на собеседование, извини, но я...^
		-- Чтооооо? Что ты сказал?^
		-- Я просто не могу, нет, я не...^
		-- Да ты кретин! Я уже звонил Кате, она была так рада, что ты, наконец, встанешь на ноги, а ты просто... ломаешься! Реклама ему не по вкусу, художник он, мараться не охота, да я на...]],
		[[-- Я не могу, понимаешь, просто не могу, своими руками...^
		-- Молчи! Не хочу слушать твой бред, я знаю заранее все то, что ты мне скажешь! Но послушай теперь меня! Хочешь ты или нет, тебе придется играть по правилам! Все крутится вокруг одного, и остановить это не возможно, выпасть из этого -- невозможно, так что....]],
		[[-- Извини, Борис, я не могу, я должен дорисовать картину, потом созвонимся.^
		-- Да пошел ты ко всем чертям собачьим!^
		На другом конце провода Борис бросил трубку и я услышал короткие гудки.]]
	};
	walk_to = 'mast';
}

phone = obj {
	attr [[~talked,takeable]];
	nam = _'телефон|~трубка';
	Exam = function(s)
		p [[Обычный проводной телефон из синего пластика.]]
		if here().n > 5 and not s.talked then
			p [[Звонит, не переставая.]]
		end
	end;
	Attack = [[Потом придется покупать новый.]];
	Take = function(s)
		if girl.exam then
			p [[Мне кажется, уже поздно звонить по телефону, надо спешить!]]
			return
		end
		p [[Я поднял телефонную трубку.]];
		if here().n >= 5 and not s.talked then
			s.talked = true
			walkin 'phone_dlg'
		else
			p [[Гудки... Я положил трубку.]]
		end
	end;
}:disable();

papers = obj {
	nam = _'бумаги|~наброски';
	dsc = [[В углу валяются обрывки бумаги.]];
	Exam = [[Неудачные наброски. Их очень много, не хочу их видеть.]];
	SearchUnder = [[Этот хлам давно пора выкинуть.]];
	alias [[Search: SearchUnder ]];
	Search = function(s)
		if disabled(phone) then
			p [[Я покопался в набросках и обнаружил там свой телефон.]];
			phone:enable();
		else
			p [[Больше ничего интересного.]]
		end
	end;
}

pict = obj {
	nam = _'холст|~картина|~мольберт';
	dsc = [[Напротив окна в центре комнаты стоит мольберт с моим холстом.]]; 
	alias [[Take: Push, Pull]];
	Take = [[Зачем?]];
	Exam = function(s)
		p [[На холсте изображена осень и скамейка в парке. Картина почти закончена.]]
		p [[Перед холстом находится табуретка, на которой лежат краски и кисть.]];
		tabur:enable();
		paint:enable();
		brush:enable();
	end;
}

stul = obj {
	nam = _'стул';
	Exam = [[Деревянный стул. Я привык к его деликатному поскрипыванию.]];
	Take = [[Стул стоит там, где ему следует стоять.]];
	alias [[ Take: Push, Pull ]];
}

drawings = obj {
	nam = _'картины';
	dsc = [[Вдоль стен на полу лежат картины.]];
	Exam = [[Мои картины плохо продаются, но на жизнь, все-таки, хватает.]];
	alias [[Take: Push, Pull, Attack]];
	Take = [[Сейчас я работаю над картиной, которую я назвал "Краски сентября".]];
}

brush = obj {
	attr [[takeable,~paint,dropable]];
	nam = _'кисть';
	Exam = [[Это моя любимая кисточка.]];
	alias [[Drop: PutOn]];
	Drop = function(s, w)
		if w == tabur then
			p [[Я положил кисть обратно.]]
			drop(s)
			return
		end
		if w == girl then
			p [[Что за ребячество?]]
			return
		end
		if here() == mast then
			return [[Место кисти -- на табуретке.]]
		end
		p [[Кисть мне еще пригодится.]]
	end;
	Smear = function(s)
		p [[Я обмакнул кисточку в краску.]];
		s.paint = true
	end;
}:disable();

paint = obj {
	attr [[takeable, smear]];
	nam = _'краски';
	Take = [[Не зачем брать краски в руки.]];
	Exam = [[Мои масляные краски.]];
	alias [[Push: Pull]];
	Push = [[Я могу их уронить.]];
}:disable();

tabur = obj {
	nam = _'табуретка';
	Exam = [[На табуретке лежат краски.]];
	alias [[Take: Push, Pull]];
	Take = [[Табуретка должна стоять возле мольберта.]];
}:disable();

mast = room {
	walkout = _'мастерская';
	WalkOut = function(s)
		if parser:word(1) == 'вылезти' then
			parser:redirect({'WalkIn', win});
			return
		end
		parser:redirect({'WalkIn', door});
	end;
	exit = function(s, t)
		if t == s then
			parser:redirect({'WalkIn', door});
			return false
		end
	end;
	entered = function(s)
		if not live(s) then
			lifeon(s)
		end
	end;
	Listen = function(s)
		if s.rain then
			p [[Я слышу тихий стук капель.]]
		else
			p [[Тихо.]]
		end
	end;
	var { n = 1, rain = true };
	life = function(s)
		s.n = s.n + 1
		if s.n == 5 then
			set_sound 'snd/tel.ogg'
			p [[Вдруг, раздался телефонный звонок.]]
			if not seen 'phone' then
				p [[Я огляделся, но телефона нигде не было видно. Куда же я его дел?]];
			end
			return true
		elseif s.n > 5 and not phone.talked then
			p [[Я слышу, как звонит телефон.]]
			if not seen 'phone' then
				if rnd(3) >= 2 then
					p [[Где этот проклятый аппарат?]]
				end
			end
		elseif s.n > 7 and brush.paint then
			lifeoff(s)
			s.rain = false
			p [[Я замечаю, что шум дождя за окном стих.]]
		else
			p [[Я слышу тихий шум дождя за окном.]]
		end
	end;
	nam = 'Мастерская';
	dsc = [[В моей мастерской почти нет места, это просто чердак старого дома,
		который уже давно пора сносить. Но здесь есть окно, выходящее на север, 
		и достаточно места, чтобы работать.]];
	obj = { 'win', 'stul', 'pict', 'drawings', 'papers', 'phone', 'tabur', 'brush', 'paint', 'girl', 'door' };
	way = { vroom(_'улица', 'mast') };
}
parser.events.before_Draw = function(self)
	if not have(brush) then
		p [[Мне нужна кисть.]]
		return
	end
	if not brush.paint then
		p [[На кисти нет нужной краски.]]
		return
	end
	if parser:word() == 'котенка' then
		if plakat._draw then
			p [[Нет времени рисовать котят. Да и краска кончилась.]]
			return
		end
		plakat._draw = true
		p [[И тут мне пришла в голову идея. Я достал свою кисточку, на ней была краска. 
		Развернул плакат другой чистой стороной и схематично нарисовал котенка.]]
		return
	end
	if have(plakat) then
		p [[У меня осталось немного краски на кисти, и есть бумага, но желания рисовать что-то нет...]]
		return
	end
	if not seen 'pict' then
		p [[Здесь нет холста.]]
		return
	end
	if here() == mast and here().n >= 5 and not phone.talked then
		p [[Телефонный звонок мешает сосредоточиться.]];
		return
	end
	if not win.first then
		p [[Там за окном кто-то стоит на краю крыши!]]
		return
	end
	if not win.opened then
		if here().rain then
			here().rain = false
			lifeoff(here())
			p [[Этот звонок выбил меня из колеи. Вдруг, я заметил, что шум дождя утих. Может, открыть окно?]]
			return
		end
		p [[Этот звонок выбил меня из колеи. Может, открыть окно?]];
		return
	end
end

roof = room {
	nam = 'На крыше';
	entered = function(s)
		picture = 'gfx/roof.png'
		p [[Я понял, что должен что-то делать. Выбравшись через окно, я встал на ноги и осторожно осмотрелся.]];
	end;
	dsc = [[Я нахожусь на покатой и угрожающе мокрой крыше. На краю крыши я вижу силуэт девушки.]];
	obj = { 'girl' };
--	way = { vroom(_'девушка', 'fall') };
}
replay = cutscene {
	hideverbs = false;
	nolife = true;
	nam = '...';
	entered = function(s)
		picture = 'gfx/leaves.png'
	end;
	dsc = { [[Взрыв ворвался и разметал все. Я погружался в пестрые краски сентября...]] };
	exit = function(s)
		restore_snapshot()
		restore_mode = true
		return false
	end;
	walk_to = [[replay]];
}

replay2 = cutscene {
	hideverbs = false;
	nolife = true;
	nam = '...';
	entered = function(s)
		picture = 'gfx/leaves.png'
	end;
	dsc = { [[Я ухватился за женскую маленькую руку и понял, слишком поздно понял, что она
	не сможет меня удержать... Я летел вниз и погружался в пестрые краски сентября... ]] };
	exit = function(s)
		restore_snapshot()
		restore_mode = true
		return false
	end;
	walk_to = [[replay2]];
}

happyend= cutscene {
	hideverbs = false;
	nolife = true;
	nam = '...';
	entered = function(s)
		picture = 'gfx/happyend.png';
		set_music 'snd/theend2.ogg'
	end;
	dsc = { [[Мы сидели на краю мокрой крыши и смотрели на осень в городе.]],
	[[Я не знаю, о чем думала она, а я вспоминал пустынный осенний парк, мальчика с котенком
	и бомбы...]],
	[[Был ли этот парк реальным? Парк, который я нарисовал, и в котором я оказался тогда, когда
	кому-то понадобилась моя помощь?]],
	[[В кармане я нащупал кисточку и достал ее. На ней еще оставалась краска...
	А в моей мастерской -- незаконченная картина.]],
	[[Я осторожно встал и позвал девушку.]],
	[[ И пока мы шли и наши шаги громыхали по мокрой крыше я вдруг отчетливо понял, 
	что краски сентября останутся в моей душе навсегда...]],
	[[ И что ничего не может быть реальней того, кому нужна твоя помощь.]] };
	walk_to = [[happyend2]];
}
happyend2 = cutscene {
	nocls = true;
	entered = function()
		picture = 'gfx/skam.png'
	end;
	hideverbs = false;
	nolife = true;
	nam = 'Краски сентября';
	dsc = function(s)
		pn [[Спасибо вам за прохождение этой небольшой игры.]]
		p (txtc("КОНЕЦ")..[[^^]]..txtr [[Петр Косых, 2015^http://instead.syscall.ru]])
	end;
	walk_to = [[titles]];
}


fall = cutscene {
	hideverbs = false;
	nam = '...';
	entered = function(s)
		picture = 'gfx/leaves.png';
	end;
	dsc = {
		[[Осторожно ступая, я начал свое движение в сторону девушки.
		Шаг, другой! Только бы успеть. Только бы успеть. Я не сводил с нее глаз, когда...]];
		[[Моя правая нога соскользнула и я упал на мокрую поверхность. Я с ужасом почувствовал,
		что качусь к краю!!!]];	
		[[Как странно, но мыслей не было. Я подумал о девушке, потом, почему-то вспомнил о своей
		незаконченной картине. "Краски сентября"...]],
		[[Огненно-красные листья в парке, в котором я никогда не был...]],
		[[Мир завертелся у меня перед глазами. Когда же я достигну края крыши? Внезапно я отчетливо почувствовал запах мокрой листвы.]];
	};
	walk_to = [[park1]];
}

skam = obj {
	nam = _'скамейка';
	Exam = function(s)
		if here() == entrance then
			p [[Скамейка отсюда плохо различима.]]
			return
		end
		p [[Я был уверен, что это та самая скамейка с моей картины. 
		Удивительное чувство, ведь я не мог ее видеть! И тем не менее,
		вот она -- зеленая скамейка в осеннем парке...]];
	end;
	alias [[ Exam: LookAt ]];
	Default = function(s)
		if here() ~= park2 then
			p [[Сначала нужно подойти к скамейке.]]
		end
	end;
	SitDown = function(s)
		if visits(park2) == 1 and here() == park2 then
			p [[Я и так сижу на скамейке.]]
			return
		end
		if visits(park2) >= 1 then
			p [[Мне больше не хочется сидеть на скамейке.]]
			return
		end
		s:Walk();
	end;
	alias [[ Walk: Climb ]];
	Walk = function(s)
		if here() == entrance or here() == park1 then
			walk 'park2'
		end
	end;
}

vorota = obj {
	nam = _'ворота';
	attr [[openable]];
	before_Open = [[Ворота уже открыты.]];
	before_Close = [[Зачем мне делать это?]];
	Exam = function(s)
		if here() == park2 then
			p [[Узор на черных железных прутьях ворот отсюда плохо различим.]]
			return
		end
		p [[Черные пики прутьев ворот смотрят в хмурые осенние облака. Ворота открыты, 
			на их широких створках сварен железный орнамент в виде восьмиконечных звезд.]];
	end;
	alias [[ Exam: LookAt ]];
	Default = function(s)
		if here() ~= entrance and here() ~= street then
			p [[К воротам сначала нужно подойти.]]
			return
		end
	end;
	alias [[ WalkIn: Walk ]];
	WalkIn = function(s)
		if here() == street then
			walk 'entrance'
		elseif here() == park2 then
			walk 'entrance'
		else
			walk 'street'
		end
	end;
}
local function lalarm(s)
	if mission2 then
		return [[Я слышу нарастающий рокот приближающихся самолетов!]]
	end
	if not alarm then
		if here() == street or here() == entrance or here() == underground then
			p [[Здесь совсем тихо.]]
		elseif here() == lake then
			p [[Тихий плеск озера едва нарушает тишину.]]
		else
			p [[Здесь тихо, лишь тихий шелест осенних листьев едва нарушает тишину.]]
		end
		return
	end
	if here() == street or here() == entrance or here() == underground then
		p [[Дикий звук мешает мне сосредоточиться.]]
	elseif here() == underground2 then
		p [[Интересно, здесь почти не слышно звука сирены.]]
	else
		p [[Всепроникающий звук сирены слышен даже здесь.]]
	end
end

global { ranen = false };

entrance = room {
	nam = 'У ворот';
	Listen = lalarm;
	entered = function(s)
		picture = 'gfx/vorota.png'
	end;
	walkout = function(s)
		if hole._in then
			return _'воронка';
		else
			return _"парк";
		end
	end;
	WalkOut = function(s) walk 'street' end;
	dsc = function(s)
		p [[Немного покосившиеся железные ворота открыты. Отсюда хорошо заметна
	моя скамейка в парке. Сразу за воротами начинается город.]];
		if seen 'people1' then
			p [[Я вижу двух пожилых людей, которые медленно прогуливаются по парковой дорожке.]]
		end
	end;
	obj = { 'vorota', 'skam', 'people1', 'sky' };
	way = { vroom(_'улица', 'street') };
	exit = function(s, t)
		if mission2 and t ~= street and t ~= inhole then
			p [[Нужно бежать к бомбоубежищу, а не гулять по парку!]]
			return false
		end
		if mission2 and t == street and hole._in then
			if ranen then
				p [[Я собрал остатки сил, взял мальчика за руку, мы с трудом выползли из воронки и
				побежали...]]
				hole._in = false
				return
			end
			ranen = true
			p [[Я попытался выбраться из воронки, но острая боль в боку заставила меня снова сесть
			на дно воронки.]] 
			p [[Я ранен? Но здесь опасно долго находиться, а убежище совсем рядом... Сейчас, только немного передохну...]] 
			return false
		end
		if t ~= inhole then
			hole._in = false
		end
	end;
	left = function(s)
--		if people1._talk and seen 'people1' then
--			remove(people1, s)
--			remove(people1, park2)
--		end
	end
}
global  { alarm = false };

soldier = obj {
	nam = 'soldier';
	live = true;
	var {
		seen = false
	};
	disp = function(s)
		if s.seen then
			return _'солдат|~военный|~человек';
		end
		return _'человек';
	end;
	Exam = function(s)
		p [[Мне кажется что это военный. На это указывают его форма и я замечаю
			что-то похожее на кобуру на его ремне с металлической бляхой.]];
		s.seen = true
	end;
	TalkTo = function(s)
		if mission then
			p [[-- Там в парке ребенок!!! -- закричал я -- пустите меня!^
				-- Баджа пор, баджа! -- солдат уверенно перегородил мне проход.^
				-- Пусти меня, там ребенок!!! -- я попытался жестами показать,
				что мне нужно наружу, но солдат был непреклонен. ]];
			return
		end
		if alarm then
			p [[Мне кажется, сейчас неудачное время для разговоров.]]
		else
			p [[Попросить его, чтобы он открыл дверь? Мне показалось, что это плохая идея. Мне кажется, 
			эта дверь закрыта неслучайно. Вероятно он что то здесь охраняет.]]
		end
	end;
	Attack = function(s, w)
		if not mission then
			p [[Это слишком радикально.]]
			return
		end
		if w then
			p [[В последнее время я стараюсь быть проще. Может быть просто ударить солдата?]]
			return
		end
		p [[Не думая о последствиях я врезал со всей силы ему по лицу и не дожидаясь реакции
		бросился в переход через решетчатую дверь.^
		Выстрелов не последовало, через мгновение я был уже на улице...]]
		exist ('прохожие', 'street'):disable()
		walkin 'street'
	end
}:disable();

underground = room {
	nam = 'Переход';
	Listen = lalarm;
	enter = function(s, f)
		if mission and  f == street then
			if mission2 then
				walkin 'flashout'
				return
			end
			p [[Сначала нужно найти того мальчика!]]
			return false
		end
	end;
	entered = function(s, f)
		picture = 'gfx/downstairs.png';
		if f == street then
			p [[Я подошел к переходу и спустился по широким ступенькам вниз.]]
		else
			if mission then
				p [[Я бегом поднялся по ступенькам и, запыхавшись, побежал к
					решетчатой двери, когда меня грубо остановил человек в коричневой форме.]]
			else
				p [[Я поднялся по ступенькам и, запыхавшись, направился к
					решетчатой двери, когда меня грубо остановил человек в коричневой форме.]]
			end
			picture = 'gfx/soldier.png';
			soldier:enable()
			here().d_to = 'underground2';
			if not soldier.seen then
				soldier.seen = true
				p [[Мне показалось что это был солдат. На это указывала его форма и что-то похожее
				на кобуру на его поясе с железной бляхой.]]
			end
			p [[^-- Но се педе! Но сан пелигросос! -- требовательно прозвучал его голос.]]
		end
	end;
	left = function(s, t)
		if t == underground2 then
			if not visited(underground2) then
				p [[Я проследовал вместе с людьми через дверь и оказался в зале. 
					Зал оканчивался крутыми лестницами, ведущими вниз и мне
					ничего не оставалось, кроме как начать спускаться по одной из них
					вместе с остальными людьми. Спуск показался мне утомительным,
					и я почти с облегчением преодолел последние ступеньки.]];
					exist 'люди':disable()
			else
				p [[Мне ничего не оставалось как снова спуститься в подземный зал.]]
			end
		end
	end;
	dsc = function(s)
		if alarm then
			if from() == underground2 then
				p [[Я нахожусь в просторном, хорошо освещенном зале. Чтобы выйти наверх мне нужно
				пройти через решетчатую дверь, путь к которой преграждает солдат.]]
			else
				p [[Лампы вдоль стен мерцают желтым светом.]]
				p [[Между выходами наверх есть открытая решетчатая дверь и люди, спустившись в переход, торопливо спешат к ней.]]
			end
		else
			p [[В переходе никого нет. Лампы, расположенные вдоль стен, не горят.]]
			p [[Между выходами наверх есть широкая железная решетчатая дверь.]]
		end
	end;
	exit = function(s, t)
		if t == street and from() == underground2 then
			p [[Я не могу просто так пройти мимо солдата. Нужно что то предпринять!]]
			return false
		end
		if t == underground2 then
			if not alarm then
				p [[Дверь закрыта.]]
				return false 
			end
		end
	end;
	obj = {
		obj {
			nam = _'дверь';
			Exam = function(s)
				if from() == underground2 then
					p [[Дверь приоткрыта. Я вижу сквозь ее решетку желтый свет ламп перехода.]]
					return
				end
				if not alarm then
					p [[Я подошел к двери и заглянул сквозь прутья. За дверью был довольно просторный
					и хорошо освещенный зал. Зал заканчивался двумя крутыми лестницами, ведущими 
					куда-то вниз. Справа у стены я заметил стоящего человека в коричневой форме.]]
				else
					p [[Я вижу как люди проходят через хорошо освещенный зал к лестницам, которые
					ведут куда-то вниз. Со стороны зала, рядом с открытой дверью я вижу стоящего человека в коричневой форме.]]
				end
				soldier:enable()
				here().d_to = 'underground2';
			end;
			before_Open = function(s)
				if alarm  then
					return [[Дверь и так открыта.]]
				end
				p [[Я подергал дверь, но она не поддалась. Внезапно, я увидел, как с той стороны 
					к двери шагнул человек в коричневой форме и что то резко произнес мне:^
					-- Аледжарс!^Я благоразумно отошел.]]
			end;
			before_Close = function(s)
				if alarm then
					return [[Я думаю мой поступок сейчас неправильно поймут.]]
				end
				p [[Но она же и так закрыта! Это какое-то наваждение, похоже, я схожу с ума.]]
			end;
			attr [[door]];
			door_to = function(s)
				if from() == underground2 then
					return 'street'
				else
					return 'underground2';
				end
			end
		},
		obj {
			nam = _'лампы|~фонари';
			Exam = [[Круглые лампы закреплены прямо на стенах.]];
		};
		obj {
			nam = 'люди';
			live = true;
			disp = _'люди|~прохожие';
			Exam = [[Что же здесь происходит? Куда они направляются?]];
			TalkTo = [[Мне кажется им сейчас не до моих вопросов.]];
		}:disable();
		'soldier',
	};
	u_to = 'street';
	var {
		d_to = false;
	};
}

give_plakat = cutscene {
	nam = '...';
	disp = false;
	hideverbs = false;
	nolife = true;
	nocls = true;
	entered = function()
		picture = 'gfx/boy.png';
	end;
	dsc = {
		[[Я достал плакат и развернул его обратной стороной.^
				-- Смотри, вот твой котенок! Ты же его ищешь?^
		Моя догадка оказалась верна! Мальчик, увидев плакат, подбежал ко мне:^
		-- Донде еста Аба? -- спросил он быстро заглядывая мне в глаза.^
		-- Да да, Аба, идем за Абой... -- я взял его за руку и мы побежали к озеру...]];
		[[Я показал ему дерево у озера и котенок, узнав мальчика, прыгнул к нему в руки.
		Все это время мне казалось, что я слышу все усиливающийся рокот приближающихся самолетов,
		и это действительно оказалось так. Их гул уже был отчетливо слышен даже не взирая
		на непрекращающийся вой сирены.]];
		[[Я потащил мальчика за собой. Мы бежали к воротам...]];
	};
	left = function()
		make_snapshot();
	end;
	walk_to = [[park2]];
}
global { mission2 = false };
plakat = obj {
	var { seen = false };
	nam = function(s)
		if s.seen then
			if s._draw then
				return _'плакат|~лист|~рисунок|~картина|~котенок';
			end
			return _'плакат|~лист|~бумага';
		end
		return _'бумага|~лист';
	end;
	attr [[takeable]];
	Show = function(s, w)
		if w == boy then
			return s:Give(w)
		end
	end;
	Give = function(s, w)
		if w == boy then
			if mission2 then
				p [[Мальчик уже видел мою картину.]]
				return
			end
			if s._draw then
				lifeoff(here())
				mission2 = true
				put(boy, street)
				put(boy, park2)
				put(boy, entrance)
				lifeon(airplane)
				walkin 'give_plakat';
				return true
			else
				p [[Я достал и развернул плакат так, чтобы мальчик увидел изображение бомбоубежища.]]
				p [[Мальчик увидел его, и я был уверен -- он понимал что я от него хочу, но по прежнему
				не собирался уходить со мной из парка.]]
			end
		end
	end;
	Exam = function(s)
		if s._draw then
			p [[На обратной стороне плаката схематично нарисован котенок.]]
			return
		end
		if not have(s) then
			p [[Большой немного смятый лист бумаге лежит на полу.]];
			return
		end
		s.seen = true
		p [[Я развернул лист бумаги. Одна сторона была чистой, а на другой я обнаружил
			изображение, довольно грубо нарисованное красной и черной краской.^
			Справа внизу красной краской была изображена женщина, обнимающая ребенка. 
			Над ними была проведена жирная красная черта, над которой были нарисованы
			птицы или... Самолеты? Черные самолеты. Черные схематичные самолеты заполнили
			верхнюю часть плаката. Самолеты сбрасывали бомбы, которые взрывались о красную
			полосу -- мать и ребенок были в безопасности!!! Я все понял!!! 
			Это бомбоубежище, я находился в бомбоубежище.]];
	end;
}:disable()
global { mission = false };
underground2 = room {
	Listen = lalarm;
	nam = 'Подземелье';
	entered = function(s)
		picture = 'gfx/underground.png';
	end;
	dsc = [[Я нахожусь в подземном зале, довольно просторном, но с низкими потолками. 
		Освещение неяркое, но достаточное. Здесь уже набралось
		десятка два человек. Большинство из них сидят на длинных скамьях, которые стоят рядами
		по всей поверхности плитчатого пола.]];
	obj = {
		obj {
			nam = _'пол';
			Exam = function(s)
				p [[Я посмотрел на пол. Он был пыльным и выглядел старым.]]
				if disabled(plakat) or seen 'plakat' then
					p [[Возле одной из скамеек я заметил
					большой лист бумаги.]]
					plakat:enable()
				end
			end;
			Climb = [[Но я и так на полу!]];
			alias [[Exam: Search, SearchOn ]];
		};
		'plakat';
		obj {
			nam = _'люди';
			live = true;
			Exam = function(s)
				p [[Я обвел взглядом людей в подземелье. Лица усталые, многие сидят на скамейках.
				Мужчины, женщины, старики... Детей я среди них не заметил.]];
				if plakat.seen then
					mission = true;
					put(dog, lake)
					put(tree, lake)
					p [[^Да, детей среди них не было. Я видел сегодня только одного ребенка -- мальчика
					из парка. И его здесь не было, он остался снаружи! Звук сирены говорит о скорой
					бомбардировке, мне нужно спешить!]];
				end
			end;
			TalkTo = function(s)
				if not s._talk then
					s._talk = true
					p [[Я выбрал взглядом одного мужчину и подошел к нему:^
					-- Простите, что здесь происходит?^
					Я заметил как он удивился.^
					-- Ан ентендо. Кью нестатис.^^
					Я почувствовал, что ловлю на себе подозрительные взгляды от окружающих нас людей.]];
				else
					p [[К сожалению, они меня не понимают, а я их...]]
				end
			end;
		};
		obj {
			nam = _'скамейки';
			Exam = [[Грубые деревянные скамьи стоят по всему залу.]];
			alias [[Take: Push, Pull]];
			Take = [[Мне кажется, что люди не одобрят мой поступок.]];
		};
	};
	u_to = 'underground';
}

downstairs = obj {
	nam = _'переход';
	attr [[door]];
	door_to = 'underground';
	Exam = function(s)
		p [[Широкие ступеньки ведут вниз. Над входом я заметил плакат.]];
		exist 'plakat':enable()
	end;
	obj = {
		obj {
			nam = 'plakat';
			disp = _'плакат';
			Exam = [[Плакат -- щит квадратной формы, на котором схематично 
			изображены три человека, вокруг которых расположены четыре красных прямоугольных треугольника, 
			смотрящие прямыми углами в центр.]]
		}:disable();
	};
}

sky = obj {
	nam = _'небо';
	Exam = function(s)
		if mission2 and not visited(roof2) then
			p [[Я вижу в небе силуэты самолетов!]]
			return
		end
		p [[Хмурое осеннее небо заволокло облаками.]];
	end;
	alias [[ Exam: LookAt ]];
	Default = [[Небо слишком далеко.]];
	TalkTo = [[Я произнес про себя молитву.]];
}
inhole = room {
	nam = '';
	enter = function(s, f)
		hole:Walk(f)
		return false
	end
}
hole = obj {
	nam = _'воронка|~яма';
	dsc = [[Рядом с воротами я вижу огромную воронку.]];
	Exam = [[Глубокая воронка.]];
	alias [[ WalkIn: Walk ]];
	WalkIn = function(s, w)
		if hole._in then
			p [[Мы и так находимся в воронке.]]
			return
		end
		if here() == street or w == street then
			p [[Уже нет никакого смысла бежать назад! Нужно добраться до бомбоубежища!]]
			return
		end
		hole._in = true
		hole._first = true
		airplane._n = 3
		p [[Мы бросились бежать по направлению к воронке. Свист падающей бомбы все нарастал.
		Время остановилось. Перед воронкой я с силой вытолкнул мальчика перед собой и почти
		сразу прогремел взрыв. Я почувствовал сильный толчок в спину и, оглушенный, скатился
		в воронку вслед за мальчиком.]]
	end;
}

airplane = obj {
	nam = _'самолет';
	life = function(s)
		local t
		if not s._n then
			s._n = 0
		end
		s._n = s._n + 1
		if s._n >= 2 then
			t = s._n - 2
		else
			p [[Я слышу нарастающий свист падающей бомбы.]]
			return
		end
		if (t % 3) == 0 then
			p [[Я слышу пронзительный свист падающей бомбы!]]
			return
		end
		if (t % 3) == 1 and hole._in then
			if not hole._first then
				p [[Где-то рядом взорвалась бомба.]]
			end
			hole._first = false
			return
		end
		if (t % 3) == 1 and not liedown then
			parser:cls()
			walkin 'replay'
			return
		end
		if (t % 3) == 1 then
			if not seen(hole, entrance) and here() == park2 then
				p [[Бомба взорвалась где-то впереди!]]
				put(hole, entrance);
				put(hole, street);
--				path('к воронке', entrance):enable()
--				path('к воронке', street):enable()
			else
				parser:cls()
				walkin 'replay'
				return
			end
			p [[Мы вскочили на ноги и снова побежали...]]
			liedown = false
			return
		end
		if (t % 3) == 2 then
			p [[Я слышу звук падающей бомбы!]]
			return
		end
	end;
}

street = room {
	nam = 'Город';
	entered = function(s)
		picture = 'gfx/street.png';
		if not s._first then
			s._first = true
			p [[Я вышел из парка и оказался на городской улице.]]
			lifeon(s)
		end;
	end;
	Listen = function(s)
		if not alarm then
			p [[Здесь очень тихо.]]
		else
			p [[Этот громкий воющий звук сводит меня с ума. Его источником, похоже, является столб у подземного перехода.]]
		end
	end;
	life = function(s)
		if not s._n then
			s._n = 0
			return
		end
		if (here() == street or here() == entrance) then
				s._n = s._n + 1
		end
		if s._n < 5 then
			return
		end
		if s._n == 5 then
			s._n = 6
			alarm = true
			p [[Внезапно тишину нарушил громкий воющий звук.]]
			set_sound 'snd/sirene.ogg'
			if seen(people1) then
				p [[Пожилая пара быстро скрылась за воротами парка и я остался в одиночестве.]]
			elseif here() == street then
				p [[Я заметил как из парка выбежала пожилая пара, которую я видел в парке, и скрылась
					в подземном переходе.]]
			end
			remove(people1, entrance)
			remove(people1, park2)
			exist('люди', underground):enable()
			return true
		end
		if mission2 then
			return [[Шум двигателей самолетов заглушает вой сирены.]]
		end
		if here() == street then
			p [[Улица заполнена пронзительным воем. Три сменяющих друг друга
			монотонных звука сливаются в один тревожный гул.]]
		elseif here() == underground then
			p [[Вой сирены мешает сосредоточится.]]
		elseif here() == entrance then
			p [[Громкий, все заполняющий воющий звук доносится со стороны улицы.]]
		elseif here() == underground2 then
			p [[Вой сирены здесь заметно тише.]]
		elseif here() ~= sad then
			p [[Воющий звук доносится со стороны выхода из парка.]]
		end
	end;
	dsc = function(s)
		p [[Улица как и парк выглядит опустевшей. На противоположной стороне
		пустой автомобильной дороги громоздятся дома.]]
		if not alarm then
			p [[Я замечаю несколько редких прохожих, которые словно крадутся вдоль потрескавшихся фасадов
		зданий.]]
		elseif seen 'прохожие' then
			p [[Я вижу как немногочисленные прохожие в спешке спускаются в переход.]]
		else
			p [[Я не вижу на улице ни одного прохожего.]]
		end
		p [[Машин нет. Неподалеку я вижу подземный переход рядом с которым установлен столб.]];
	end;
	obj = { 'vorota', obj {
			nam = _'здания|~дома|~строения';
			Exam = function(s)
				p [[Архитектура напоминает 60-е, но только высота этих шести- или семиэтажных 
			зданий непривычно высокая. Многие стены покрыты трещинами и сколами. Кое-где я замечаю
			горящий свет в окнах.]]; 
				exist 'окна':enable();
			end;
			WalkIn = [[Судя по всему, в этом городе у меня нет знакомых. Кого мне искать в чужих квартирах?]];
		},
		obj {
			nam = _'окна';
			Exam = [[Мне всегда нравилось смотреть на уютный свет из чужих окон, 
				но сейчас этот свет внушает мне тревогу.]]
		}:disable();
		obj {
			nam = _'дорога';
			Exam = [[Дорога пустынна и покрыта множеством выбоин и ям.]];
		};
		obj {
			nam = _'столб';
			Exam = [[Высота столба около шести метров. Столб широкий у основания, но
			постепенно сужается к середине. На самом верху я вижу три конуса.]];
			Climb = [[Какой смысл в том, чтобы залезть на столб?]];
		};
		'downstairs',
		obj {
			live = true;
			nam = 'прохожие';
			disp = _'прохожие|~люди';
			Exam = function(s)
				if alarm then
					p [[Мужчины и женщины спешат по направлению к подземному переходу. Кое-кто бежит.]]
				else
					p [[Прохожих единицы. Они осторожно передвигаются вдоль стен, словно ожидая
					нападения.]]
				end
			end;
			TalkTo = function(s)
				if alarm then
					p [[Им не до моих расспросов.]]
					return
				end
				if people1._talk then
					p [[После разговора с мальчиком и пожилой парой я сомневаюсь, что это хорошая идея.]]
				else
					p [[Мне совсем не хочется беспокоить их. Может быть лучше поговорить с пожилой парой в парке?]]
				end
			end;
		}, sky, 
	};	
	way = { vroom(_'парк', 'entrance'), vroom('к воронке', 'inhole'):disable() };
}

people1 = obj {
	nam = _'посетители|~прохожие|~люди';
	attr [[live]];
	Exam = function(s)
		if here() == park2 then
			p [[Я вижу пожилую пару, медленно направляющуюся к выходу из парка.]]
		else
			p [[Пожилые мужчина и женщина, явно супружеская пара. Женщина держит мужчину под руку.
			Он одет в черное пальто, она -- в сером.]]
		end
	end;
	TalkTo = function(s)
		if here() ~= entrance then
			p [[Они слишком далеко.]]
			return
		end

		if not s._talk then
			s._talk = true
			lifeon(street)
			p [[-- Простите, вы не подскажете что это за парк? -- осторожно начал я.^
			Они остановились, при этом женщина еще крепче сжала руку
			мужчины и быстро взглянула на него.^
			-- Ло сентимос, но ентендемос -- вежливо, но вместе с тем как-то отчужденно произнес мужчина.]]
		else
			if not s._ans then
				s._ans = true
				p [[-- Извините, -- все, что мне оставалось им ответить.]]
			else
				p [[Они меня не поймут. Не стоит их беспокоить.]]
			end
		end
	end;
	alias [[ Exam: LookAt ]];
	Default = function(s)
		if here() ~= entrance then
			p [[Они слишком далеко.]]
		end
	end;
	Walk = function(s)
		if here() == park2 then
			walk 'entrance'
		end
	end;
}

boy = obj {
	attr [[live]];
	nam = _'мальчик|~паренек';
	dsc = function(s)
		if mission2 then
			if hole._in or liedown then
				p [[Мальчик находится рядом со мной.]]
			else
				p [[Я крепко держу мальчика за руку.]]
			end
		end
	end;
	Exam = function(s)
		if mission2 then
			p [[Мальчик держит котенка за пазухой пальто и, кажется, 
			это все что его сейчас беспокоит.]]
			return
		end
		if here() == sad then
			p [[Я вижу как он бродит от дерева к дереву.]]
			return
		end
		p [[Паренек лет десяти. Мешковатые в коленях темно-серые штаны, короткое пальто и
		что-то вроде кепки на голове. Большие темные глаза на испачканном сажей лице.]]
		if here() == park2 then
			if not s._talk1 then
				p [[-- Ми гато се пиере! -- мальчик смотрел на меня черными выразительными глазами
				я явно ожидал ответа.]]
				s._talk1 = true
			else
				p [[Мальчик ждет ответа на свой вопрос.]]
			end
		end
	end;
	Walk = function(s)
		if here() == sad then
			if not mission then
				p [[Я подошел к мальчику.]]
				return
			end
			if mission and not mission2 then
				if s._panic then
					s:Take()
				else
					p [[Я подошел к мальчику.]]
				end
			end
		end
	end;
	Attack = function(s)
		if not mission then
			p [[Этот помысел я быстро отсек.]]
			return
		end
		p [[Оглушить и оттащить в убежище? Нет, это плохая идея.]]
	end;
	Take = function(s)
		if mission2 then
			p [[Я покрепче схватил мальчика за руку.]]
			return
		end
		if not mission then
			p [[С чего бы это мне хватать мальчика?]]
			return
		end
		if not s._panic then
			s:TalkTo()
			return 
		end
		p [[Я попытался догнать мальчика, но он ловко использовал деревья для того,
		чтобы уйти от меня. Так ничего не выйдет!]]
	end;
	TalkTo = function(s)
		if mission2 then
			if ranen then
				p [[-- Ничего, скоро мы будем в безопасности. -- мой голос прозвучал устало и 
				неубедительно. -- Нам осталось совсем немного.^С этими словами 
				я показал рукой по направлению к переходу.^
				Мальчик ничего не ответил, а только кивнул и крепче прижал к груди своего котенка.]]
				return
			end
			p [[Сейчас самое главное добежать до убежища, а поговорить можно и потом.]]
			return
		end
		if here() == sad then
			if not mission then
				p [[Интересно, кого он ищет? Но узнать это проблематично.]]
				return
			end
			if not s._panic then
				s._panic = true
				p [[Я подбежал к мальчику и схватил его за руку.^
				-- Скорей, бежим! Самолеты! -- я указал рукой в небо -- Опасно!^
				-- Ан пюедо! Деждано сен Аба! -- мальчик вырвал руку и отбежал от меня на безопасное расстояние.]] 
				return
			else
				p [[-- Иди сюда! Бежим, у нас мало времени -- прокричал я в отчаянии. Но мальчик только еще немного больше углубился в сад.]];
			end
			return
		end
		p [[-- Прости, но я не понимаю... -- я растерянно развел руками.^]]
		p [[Удивительно, но мальчик, кажется, совсем не удивился, а только разочарованно
		взглянул на меня, бросил что-то вроде: "Дискулпеме!" -- и убежал по
		парковой дорожке в сторону озера.]]
		remove(s, here())
		picture = 'gfx/skam.png'
	end;
}

park2 = room {
	nam = 'Скамейка';
	Listen = lalarm;
	exit = function(s, t)
		if mission2 then
			if t ~= entrance and t ~= inhole then
				p [[Нужно бежать к бомбоубежищу, а не гулять по парку!]]
				return false
			end
			return
		end
		if seen 'boy' then
			p [[Было бы не вежливо проигнорировать этого паренька.]]
			return false
		end
		if not boy._talk0 then
			picture = 'gfx/boy.png'
			boy._talk0 = true
			place(boy, here())
			p [[Я поднялся со скамейки и собрался уходить, когда обнаружил, что справа
				ко мне приближается одинокая фигурка в пальто. Это был мальчик, лет десяти.
				Он подбежал ко мне и, едва переведя дыхание, быстро но не громко проговорил:^
				-- Устед но ха висто ал гато?]]
			return false
		end
	end;
	entered = function(s, f)
		picture = 'gfx/skam.png';
		if f ~= park1 then
			return
		end
		p [[Медленно, сопровождаемый тихим шорохом листвы, я побрел к скамейке.
		Скамейка была пуста. Я сел на нее и осмотрелся.]]
	end;
	dsc = function(s)
		if seen 'people1' then
			p [[Почти безлюдный осенний парк. Несильный ветер играет листьями под ногами немногочисленных посетителей.]]
		else
			p [[Парк безлюден. Только несильный ветер шелестит опавшей листвой.]]
		end
		p [[Ветви деревьев молчаливо смотрят в хмурое небо. Главная дорожка парка огибает небольшое
		озеро и заканчивается воротами главного входа.]];
	end;
	obj = { 'skam', 'vorota', 'people1', sky, 'trees' };
	way = { vroom(_'озеро', 'lake') };
}

sad = room {
	Listen = lalarm;
	life = function(s)
		s._n = s._n + 1
		if s._n > 1 then
			s._n = 0
			p [[Вдруг я услышал как мальчик кого-то зовет: -- Аба, аба, аба!!!]];
		end
	end;
	entered = function(s)
		s._n = 0
		lifeon(s)
		picture = 'gfx/sad.png';
	end;
	left = function(s)
		lifeoff(s)
	end;
	nam = 'Яблоневый сад';
	dsc = function(s)
		p [[Я оказался в яблоневом саду. Здесь множество деревьев, которые почти
			облетели. Мои ноги зарываются в толстый слой опавшей листвы.
			В другой ситуации, мне было бы приятно шелестеть ими, но сейчас мне не 
			до созерцания. Парковая дорожка здесь заканчивается. Я могу вернуться по ней
			обратно к озеру.]]
		if seen 'boy' then
			p [[Я вижу знакомого мне мальчика, который ходит между деревьями. Кажется, 
			он что-то ищет...]]
		end
	end;
	obj = { 'boy', 'sky', 'trees' };
	way = { vroom(_'озеро', 'lake') };
}

stone = obj {
	nam = _'камень';
	attr [[ dropable ]];
	Exam = [[Серый крупный камень, округлый и гладкий.]];
	Drop = function(s, w)
		if not w then
			if here() == lake then
				p [[Я выбросил камень.]]
				remove(s, me())
			else
				p [[Камень может мне пригодиться.]]
			end
			return
		end
		if w ~= dog then
			if w == cat then
				return [[Сбить котенка с дерева? Это уж слишком...]]
			end
			if mission and w == soldier then
				p [[Камень вряд ли поможет мне обезвредить солдата.]]
				return
			end
			if w.live then
				return [[Я не уверен, что это хорошая идея.]]
			end
			if stead.nameof(w) == 'озеро' then
				remove(s, me())
				return [[Я швырнул камень в озеро и некоторое время смотрел на расходящиеся круги на воде.]]
			end
			p [[Камень может мне пригодиться.]];
		else
			dog:Attack(s)
		end
	end;
	Show = function(s, w)
		if w == dog then
			return w:Attack(s)
		end
	end;
}

stones = obj {
	nam = _'галька|~камни';
	Exam = [[Круглые крупные камни серого и белого цвета уложенные вдоль покатого берега. Кое-где камней
		не хватает.]];
	Take = function(s)
		if not have 'stone' then
			p [[Подумав, я взял один из камней с собой.]]
			take 'stone'
			return
		end
		p [[Мне не нужны больше камни.]]
	end
}:disable()

trees = obj {
	nam = _'деревья';
	Exam = [[Листва еще осталась, но скоро она облетит...]];
}

tree = obj {
	nam = _'дерево';
	Exam = function(s)
		if seen 'dog' then
			p [[Я собрался было подойти поближе к дереву и посмотреть на то, 
				что так беспокоит пса, но рычание и оскаленные клыки
				отбили всякое желание это делать.]]
		else
			p [[Я подошел к дереву и заметил высоко в ветвях маленький темный
			комочек. Это был котенок!]]
			put(cat)
		end
	end;
	Climb = function(s)
		if not seen 'cat' then
			p [[С чего бы мне зазать по деревьям?]]
			return
		end
		if seen 'dog' then
			return [[Собаке это не понравится.]]
		end
		cat:Take()
	end;
}

dog = obj {
	nam = _'собака|~пес';
	live = true;
	dsc = [[Я вижу, как у одного из деревьев с громким лаем кружит пес.]];
	Take = [[Я никогда не умел ладить с собаками.]];
	TalkTo = [[-- Эй, блоховоз!!! -- крикнул я псу. Он на короткое время отвлекся от дерева, но потом
		принялся за старое. Может быть -- к лучшему?]];
	Attack = function(s, w)
		if w == stone then
			p [[-- Эй, волчище, смотри что у меня есть!!! -- с этими словами я достал камень и размахнулся,
				делая вид, что хочу бросить его. Интересно, что как только пес увидел камень, то с визгом
				бросился в сторону парковых ворот. Похоже, за свою нелегкую жизнь он уже не один раз
				успел получить удар камнем...]]
				remove(s)
			return
		end
		p [[Я попытался отогнать пса от дерева, но чуть не остался без рук (как мне показалось).]];
	end;
	Exam = function(s)
		p [[Большущий пес коричнево-рыжего окраса. Кое-где его шерсть всклочена.
		Обнаженные клыки придают ему свирепый вид. Он кружит у одного из
		деревьев и громко и непрерывно лает, задрав морду вверх.]]
	end;
}

cat = obj {
	nam = _'котенок';
	dsc = [[Среди тонких ветвей дерева затаился котенок.]];
	Exam = [[Он напуган и крепко вцепился в ствол дерева.]];
	Take = function(s)
		if seen 'dog' then
			p [[Этот блоховоз тоже хочет его достать...]]
			return
		end
		s._take = true
		p [[Я с сожалением признался сам себе, что плохо лазаю по деревьям.
		Особенно с такими тонкими ветками, а ведь котенок
		забрался довольно высоко...]];
	end;
	TalkTo = function(s)
		p [[-- Кис кис кис кис!!! -- зачем-то произнес я вслух. Котенок не отреагировал.]]
		if seen 'dog' then p [[^Собака с неодобрением покосилась в мою сторону.]] end
	end;
	alias [[ Exam: LookAt ]];
	Default = [[Я не могу достать котенка отсюда.]];
};

lake = room {
	entered = function(s)
		picture = 'gfx/lake.png';
		if seen 'dog' then
			set_sound 'snd/bark.ogg'
		end
	end;
	Listen = function(s)
		if seen 'dog' then
			return "Я слышу громкий собачий лай."
		end
		return lalarm(s);
	end;
	nam = "У озера";
	dsc = [[По поверхности озера идет легкая рябь. Красно-желтые
	листья, опавшие с деревьев растущих вдоль берега, плавают в темной воде. 
	Парковая дорожка, идущая из центра парка где стоит моя скамейка, огибает озеро и 
	ведет в сад.]];
	obj = {
		obj {
			nam = _'берег';
			Exam = function(s)
				p [[Берег озера усыпан крупной галькой. ]];
				stones:enable()
			end
		};
		stones;
		sky,
		'trees',
		obj {
			nam = 'озеро';
			disp = _'озеро';
			Exam = [[Вода совсем темная и, наверное, холодная.]];
			WalkIn = [[Вода холодная...]];
			alias [[ WalkIn: Climb ]];
		};
	};
	way = { vroom(_'скамейка', park2), vroom(_'сад', 'sad') }
}

park1 = room {
--	fading = fade;
	nam = 'Парк';
	entered = function(s, f)
		if f == fall then
--			parser:cls()
			p [[... Я лежал лицом вниз, уткнувшись в мокрые листья. Голова немного кружилась и я почувствовал тошноту.
			Странно, я все еще на крыше? Я поднял голову и осмотрелся. Потом осторожно, не веря в то, что я все еще жив и цел, 
			поднялся на ноги. Это был парк. Это не могло быть правдой, но это было так.]]
			if not have(brush) then
				p [[В моей руке что-то было. Я с удивлением понял, что держу в руках свою кисть.
					На кисти была свежая краска. В замешательстве я убрал кисть в карман.]]
				take(brush)
			end
		end
		set_music('snd/2.ogg')
	end;
	dsc = [[Я нахожусь в парке. Мокрые осенние листья. Неподалеку я вижу скамейку.]];
	obj = { 'skam', 'sky', 'trees' };
--	way = { vroom(_'скамейка', park2) };
}
flashout = cutscene {
	hideverbs = false;
	entered = function()
		lifeoff(airplane)
		lifeoff(street)
		set_music 'snd/theend.ogg'
	end;
	nam = '...';
	dsc = { [[Я бежал за мальчиком, все время держа его в поле своего зрения. Каждый шаг отдавался в боку острой болью.
		Я слышал свист бомб, но мне ничего не оставалось, как просто бежать эти бесконечные десятки метров и надеяться...]],
	[[Сквозь подступающую к сознанию темноту я видел, как мальчик добежал до перехода. Вот он
		оглянулся и вопросительно посмотрел на меня...]],
	[[Я закричал на него и, не обращая внимания на боль в боку,
	отчаянно замахал руками.]],
	[[Я увидел как он словно бы неохотно скрылся в подземном переходе.]],
	[[... Я с трудом преодолел последние несколько метров и повис на лестничных перилах.
	Теряя сознание, я начал сползать вниз. Потом упал и покатился по ступенькам. Перед глазами я видел пляшущие...]],
	[[... краски сентября ...]]
	};
	walk_to = 'roof2';
}

girl2 = obj {
	nam = _'девушка';
	live = true;
	Exam = function(s)
		if s._talked and not s._truba then
			p [[Девушка негромко плачет. Похоже, ее нервная система не выдержит чужой смерти.]]
			return
		end
		if s._truba then
			p [[Девушка держится за вентиляционную трубу. Думаю, можно попробовать.]]
			return
		end
		p [[Честно говоря, мне сейчас совсем не до разглядывания девушек.]];
	end;
	Take = [[Лучше взяться за ее руку.]];
	TalkTo = function(s)
			if not s._talked then
				p [[-- Послушайте, вы не удержите меня. Наверное нет никакого способа мне помочь. -- мне 
				показалось, что я услышал всхлипывания. Но почему-то сейчас меня это не тронуло.
				^-- Знаете что, раз уж мне удалось с вами поговорить, то... не делайте больше то, что 
				собирались делать...^]]
				p [[-- В общем, попробуйте позвать кого-то на помощь -- произнес я в надежде, что
				она не увидит как мои ослабевшие пальцы разожмутся.^]]
				p [[Но девушка не ушла, она просто сидела и плакала.]]
				s._talked = true
				hand:disable()
				return
			end
			if s._truba then
				p [[-- Все нормально? -- спросил я уверенно.^-- Да -- да, все нормально... У меня получится.]];
				return
			end
			if seen 'truba' then	
				p [[Да, паршивая ситуация...^]]
				p [[-- Хотя знаете что, попробуйте лечь за вот ту трубу, так чтобы она была между нами, 
				и дайте руку, а я попробую выбраться.^]];
				p [[Девушка не перестала плакать, но хоть какой-то конкретный план вывел ее из оцепенения
				и она бросилась его выполнять. Ну что-же, сейчас она достаточно безопасно закрепилась
				на крыше.]]
				s._truba = true
				hand:enable()
			else
				p [[Я не нашел что сказать плачущей девушке.]]
			end
	end;
}:disable();

hand = obj {
	nam = _'рука';
	Exam = [[Женская рука не выглядит сильной.]];
	Take = function(s)
		if not girl2._truba then 
			walkin 'replay2'
			return
		end
		walkin 'happyend'
	end;
}:disable()

truba = obj {
	nam = _'труба';
	Exam = function(s)
		s._seen = true;
		p [[Железная вентиляционная труба с козырьком. Мне до нее не дотянуться.]];
	end;
	alias [[ Exam: LookAt ]];
	Default = [[Мне до нее не дотянуться.]];
}:disable();

roof2 = room {
	nam = 'На крыше';
	entered = function(s)
		picture = 'gfx/roof2.png';
		p [[Запах мокрой листвы... Он появился и куда-то пропал. Холод на щеке. Стук. Глухой стук.
	Крыша... Я качусь по мокрой крыше!!! Ужас захлестнул меня. И в тот же миг крыша кончилась...]];
		remove(stone, me())
		remove(plakat, me())
		make_snapshot()
	end;
	after_Default = function(s, w)
		if not s._n then s._n = 0 end
		s._n = s._n + 1
		if s._n == 3 then
			p [[^Вдруг, я услышал стук приближающихся шагов по крыше. Кто-то бежал ко мне!]]
		elseif s._n == 4 then
			p [[^-- Держитесь! -- услышал я дрожащий женский голос. -- Возьмите мою руку!]];
			hand:enable()
		elseif seen(hand) and not girl2._truba  then
			p [[^-- Держите мою руку -- слышу я женский голос.]];
		end
	end;
	Wait = [[Проходит немного времени.]];
	Default = [[Все что я могу, я уже и так делаю.]];
	dsc = [[Я вишу на краю крыши. Каким то чудом я зацепился за водосток, идущий по краю, но 
	сил чтобы висеть так у меня не хватит. Мои пальцы немеют от холода и страха.]];
	obj = {
		obj {
			nam = _'водосток';
			Exam = [[Водосток идет вдоль края крыши. Какое чудо, что я зацепился за него!]];
			Take = [[Я еще крепче ухватился за водосток.]];
--			Default = [[Все что я могу, я уже и так делаю.]]
		};
		sky, 
		obj {
			nam = _'крыша';
			Exam = function(s)
				if roof2._n == 3 then 
					p [[Я собрал остаток сил, немного подтянулся и посмотрел за край.
					Ко мне спешила девушка! Я все вспомнил, здесь на крыше была девушка...]]
					girl2:enable()
					return
				end
				if roof2._n > 3 then
					p [[Я собрал остаток сил, немного подтянулся и посмотрел за край.
					На краю крыши была девушка. Рядом с ней заметил вентиляционную трубу.]]
					girl2:enable()
					truba:enable()
					return
				end
				p [[Отсюда я вижу только небольшой участок крыши. 
				Крыша мокрая от дождя.]];
			end;
		};
		girl2;
		hand;
		truba;
	};
}
parser.events.before_Smear = function(self, s, w)
	if not w.smear then
		p (w:CM 'вн')
		p "нельзя намазать."		
		return
	end
end

parser.events.after_Listen = function(self, s)
	if not self:react() then
		p [[Ничего необычного.]]
	end
end

parser.events.after_SitDown = function(self, s)
	if not self:react() then
		p ([[Не хочу сидеть на ]]..s:M 'пр2'..".");
		return
	end
end

parser.events.after_Show = function(self, s, w)
	if not self:react() then
		p ("Я показал ", s:M 'вн', " ", w:M 'дт', ", но ничего не произошло.");
	end
end
global { liedown = false };
parser.events.LieDown = function(s)
	if here() == mast or here() == roof then
		p [[Нет никакого желания делать это.]]
		return
	end
	if hole._in then
		p [[Мы и так уже лежим на дне воронки.]]
		return
	end
	if not mission2 then
		p [[Приятно иногда поваляться на земле. Успокаивает нервную систему.]]
		return
	end
	if lidedown then
		p [[Я уже и так на земле...]]
		return
	end
	liedown = true
	p [[Схватив за плечи мальчика, я бросился на землю...]]
end

game.verbs = {};

parser.verb.Inventory()
parser.verb.Exam()
parser.verb.Walk()
parser.verb.LookAt()
parser.verb.Search()
parser.verb.Open()
parser.verb.Close()
parser.verb.Push()
parser.verb.Pull()
parser.verb.Smell()
-- parser.verb.Eat()
parser.verb.Put()
parser.verb.Attack()
parser.verb.Take()
parser.verb.Drop()
-- parser.verb.Remove()
parser.verb.Wait()
parser.verb.Read()
-- parser.verb.Tie()
parser.verb.TalkTo()
parser.verb.Give()

Verb { "Smear %2 %4", "макнуть|~обмакнуть", "{inv}вн", "в", "{obj}вн" };
Verb { "Smear %2 %3", "~смазать|~мазать", "{inv}вн", "{obj}тв" };
Verb { "Draw", "рисовать|~нарисовать", function ()
	if boy._panic and seen(cat, lake) then
		return "котенка"
	end
	return "{}"
end};

Verb { "Listen", "слушать|~прислушаться"};
Verb { "SitDown %3", function(s)
	if seen 'skam' then
		return "~сесть|~сидеть|~посидеть"
	end
end, "на", "{obj}вн"};
Verb { "Show %2 %3", "~показать", "{inv}вн", "{obj}дт" };
Verb { "TalkTo %2", "~кричать|~крикнуть", "{obj}дт" };
Verb { "TalkTo %3", "~закричать", "на", "{obj}вн" };
Verb { "TalkTo %2", "~позвать", "{obj}вн" };
Verb { "Walk %3", "~бежать", "к", "{obj}дт|{way}дт" };
Verb { "LieDown", "упасть|~лечь|~броситься",
	function(s)
		if s:word() ~= 'броситься' then
			return "{}|на землю"
		end
		return "на землю"
	end;
}
Verb { function(s)
		if parser:word(2) == 'из' then
			return "WalkOut"
		else
			return "WalkIn %3"
		end
	end,
	"~вылезти|~выйти", function(s)
	local r = 'в';
	if here().walkout then
		r = r.. '|из'
	end
	return r
end, function(s)
	if parser:word() == 'из' then
		local r,v = stead.call(here(), 'walkout')
		return morph:case(r, 'рд')
	else
		return "{obj}вн"
	end
end};

-- vim:tabstop=4
-- vim:shiftwidth=4
