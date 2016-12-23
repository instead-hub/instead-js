-- $Name:Куба$
-- $Version:1.1$
instead_version "1.2.0"
require "para"
require "dash"
require "quotes"
require "hideinv"
require "xact"
require "hotkeys"
require "prefs"
require "snapshots"

if stead.version < "1.5.3" then
	walk = _G["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

game.act = [[Это не поможет...]];
game.use = [[Не сработало...]];

global {
	not_money = false;
	can_pass = false;
	see_map = false;
	seen_table = false;
	know_name = false;
	mama_ring = false;
	need_save = false;
	know_ship = false;
}

main = room {
	forcedsc = true,
	nam = 'Введение';
	pic = 'gfx/story.png';
	entered = code [[ set_music 'mus/story.ogg' ]];
	dsc = [[-- Здравствуйте! Меня зовут Павел, но вообще можно просто {pavel:Павлик}.
	В сентябре я пойду в 6-й класс, а сейчас у меня летние каникулы... Я хочу 
	рассказать вам одну историю,
	которая произошла со мной прошлым летом... Тогда я после школы поехал в {os.exit:зоопарк},
	я никогда не был в зоопарке до этого, и мне ужасно хотелось попасть туда...
	Правда, пришлось соврать, чтобы дома не беспокоились...
	Но потом я все рассказал, конечно...^^ 

	Ну вот тогда-то, в теплый майский день, я и познакомился с {timof:Тимофеем}...]];
	obj = { xact ('pavel', 'А если полностью -- Павел Федорович...');
			xact('timof', 'Послушайте историю дальше, и все узнаете...');
			xact('os.exit', 'Добраться до зоопарка оказалось не так уж и сложно...');
			vway('next', '{Дальше}', 'entr');
		};
	left = code [[ inv():enable_all(); set_music 'mus/intro.ogg' ]];
}

global { tim_place = null; tim_plnr = 0 }

tdlg = dlg {
	nam = 'Тимофей';
	pic = 'gfx/timof.png';
	dsc = [[ -- Что случилось, сынок???]];
	obj = {
		[1] = phr('Мне очень нужно остаться в зоопарке на ночь!!!',
			[[-- Гм... Вижу, что очень нужно... Но нельзя. Извини, сынок.]],
			[[ pon(2) ]]);
		[2] = _phr('Это вопрос жизни и смерти!',
			[[-- Понимаю, а как же мама??? Она будет беспокоиться?]],
			[[ if mama_ring then pon(5); else pon(3,4) end]]);
		[3] = _phr('Не будет!',
			[[ -- Я знаю, что будет... Сынок, никогда не расстраивай маму.]],
			[[ pon(6) ]]);
		[4] = _phr('Утром я вернусь домой!',
			[[ -- Мама будет беспокоиться... Нет, так не пойдет, сынок.]],
			[[ pon(6) ]]);
		[5] = _phr('Я звонил маме, все в порядке. До утра она не будет беспокоиться!',
			[[ Тимофей посмотрел мне в глаза -- Похоже, ты говоришь правду... -- 
			Ну что же, идем...]],
			[[walk 'incuba' ]]);
		[6] = _phr('Ладно, я поехал домой.',
			[[ -- Вот это правильно, сынок!!!]],
			[[ back() ]]);
	};
	exit = code [[ lifeon(people) ]];
	left = code [[ poff(2,3,4,5,6); pon(1); ]]			
}

incuba = room {
	hideinv = true;
	forcedsc = true;
	pic = 'gfx/timof.png';
	nam = 'Тимофей';
	dsc = [[ Тимофей быстро зашагал по дороге, затем мы свернули в 
		сторону и оказались на тропе. Я едва поспевал за ним... ]];
	obj = { vway('дальще', '{Дальше}.', 'cuba') };
}

timof = obj {
	nam = 'Тимофей';
	act = function(s)
		p [[--Тимофей, это я, Павлик!!! -- я подбежал к нему. -- Мне нужна помощь!!!]]
		lifeoff 'people'
		walk (tdlg);
	end
}
people = obj {
	nam = 'люди';
	life = function(s)
		local places = {
			entr, -- just nowhere
			lroad,
			lake,
			lake2,
			lake3,
			endz,
		}
		if here() == tim_place then
			return
		end
		if tim_place == null then
			tim_place = here();
			while tim_place == here() do
				tim_plnr = rnd(#places)
				tim_place = places[tim_plnr]
			end
			place(timof, tim_place)
			return
		end
		tim_plnr = tim_plnr + 1
		if tim_plnr >= 2*(#places) then
			tim_plnr = 1
		end
		if tim_plnr > #places then
			tim_place = places[2 * #places - tim_plnr];
		else 
			tim_place = places[tim_plnr]
		end
		remove(timof, where(timof));
		place(timof, tim_place);
	end;
	dsc = function(s)
		if visited(skam) then
			p [[{Люди} медленно бредут к выходу.]];
			return
		end
		if seen 'клетки' then
			p [[{Люди} столпились у клеток.]]
			return
		end
		p [[Я вижу множество {людей}.]];
	end;
	act = function(s)
		if visited(skam) then
			p [[Я вглядываюсь в незнакомые лица...]]
			if tim_place == here() and know_ship then
				p [[Кажется я вижу {Тимофей:Тимофея!}]];
			end
			return
		end
		if seen 'клетки' then
			p [[Детские возгласы и улыбки родителей. Кто-то кормит животных.]]
			return
		end
		p [[ Гуляют.]]
	end
};

mobil = obj {
	nam = 'мобильник';
	inv = function(s)
		if goon and know_ship and not mama_ring then
			if here() == tdlg then
				p [[Сейчас я разговариваю с Тимофеем.]]
				return
			end
			p [[-- Гм... Я взял свой телефон и набрал номер мамы... Гудки. 
			Потом мама взяла трубку. Я скрестил пальцы на руке:^^
			-- Мама, я останусь сегодня ночевать у Миши!?^
			-- Хорошо, Павлик. Только позвони обязательно завтра перед школой!^
			-- Спасибо, мама!]];
			mama_ring = true
			return
		end
		p [[Мой мобильник.]]
	end;
	use = function(s, o)
		p [[Не выйдет...]];
		return false
	end
}

money = obj {
	nam = 'деньги';
	inv = [[Деньги на завтрак, которые дала мне мама. 
		Я специально их не тратил сегодня, чтобы попасть в зоопарк.
		Правда, за проезд пришлось заплатить... ]];
	use = function(s, w)
		if nameof(w) == 'касса' then
			p [[Отдать деньги кому?]]
			return false
		elseif w == cassir then
			p [[Я протягиваю все свои деньги тетке, она их считает, 
				а затем возвращает назад.]]
			p [[Не хватает??? Не может быть!!!]]
			not_money = true
			set_music 'mus/noway.ogg'
			return false
		elseif w == cont then
			if not_money then
				p [[Ну что делать... Я подхожу к контролеру и 
					незаметно пытаюсь дать ему деньги...]]
				p [[Кажется, сработало!!! Он берет мои деньги... Но... ^^
				-- А теперь вали отсюда, пацан, пока я тебя в милицию не отдал.. ^^
				Вот так вот...]] 
				remove(s, me())
				return false
			end
			p [[Думаю, лучше купить билет в кассе...]]
			return false
		elseif nameof(w) == 'дети' then
			p [[Зачем детям деньги? У них есть родители, а мне нужно попасть в зоопарк...]]
			return false
		elseif nameof(w) == 'нищий' or nameof(w) == 'бездомный' then
			p [[Сначала нужно подойти к нему.]]
			return false
		end
		p 'Деньги здесь не помогут...';
		return false
	end
}

function init()
	take 'money'
	take 'mobil';
	put(money, inside);
--	put(money, entr);
	inv():disable_all();
end

cassir = obj {
	nam = 'кассир';
	act = [[Ее сложно разглядеть подробно... Она где-то там, в глубине кассовой будки...]];
}

cdlg = dlg {
	nam = 'Контролер',
	pic = 'gfx/guard.png',
	dsc = 'Я вижу перед собой потное лицо контролера...',
	obj = {
		[1] = phr('Дяденька, пустите меня, я же дал вам деньги!',
				'-- Пошел отсюда, шкет!', [[ pon(); back() ]]);
		[2] = phr('Я пойду к милиционеру! Отдайте мои деньги или пустите внутрь!',
				'-- И что ты скажешь? Что дал мне взятку? Пошел отсюда, а то расскажу твоей маме!', 
				[[ pon(); back(); ]]);
		[3] = _phr('Пустите меня! Или я расскажу кассиру, что вы берете взятки!!!',
				[[Контролер посмотрел по сторонам... ^^
				-- Ладно -- иди, но больше не попадайся мне тут!!!]],
				[[ ways(entr):add(vroom('Внутрь', inside)); 
					can_pass = true; set_music 'mus/zoo.xm'; back() ]]);
	}
}
cont = obj {
	nam = 'Контролер';
	act = function(s)
		if can_pass then
			p [[Лучше его лишний раз не раздражать...]];
		elseif not have(money) then
			walk (cdlg);
		else
			p [[Дядька в черной униформе охранника... 
			Жарко ему, наверное, на этом празднике жизни...]];
		end
	end
}

guydlg = dlg {
	nam = 'Бездомный';
	pic = 'gfx/timof.png';
	entered = function(s)
		poff(1,2);
		if have 'money' then pon(1) end
		if seen_table then pon(2) end
		if not_money and not can_pass and visited(cdlg) then pon(4) end
		p [[Я подошел к нему, сам не знаю зачем, и почти сразу услышал его
		немного хрипловатый голос: ^
		-- Как дела, сынок?]];
	end;
	dsc = [[Я гляжу на бездомного.]];
	obj = {
		[1] = _phr('Возьмите немного денег!', '-- Нет, я не возьму деньги у ребенка!');
		[2] = _phr('Здравствуйте! А вам правда нужны деньги на корм кота?',
				'-- Да, сынок!', [[ prem(); pon (3) ]]);
		[3] = _phr('А где же ваш кот?',
				'-- Мой кот живет у меня дома...');
		[4] = _phr('Теперь я тоже без денег.', 
			'-- Я все видел, сынок, мне жаль, что так вышло...', [[ prem(); pon(5) ]]);
		[5] = _phr('Может вы дадите мне немного денег?',
			'-- Я должен кормить своего кота, но я могу дать тебе совет...', [[ pon(6) ]]);
		[6] = _phr('Дайте мне совет!', 
			'-- Скажи этому... дяде, что ты расскажешь все кассирше. Они сильно не любят друг-друга.', 
			[[ pon(7); cdlg:pon(3) ]]);
		[7] = _phr('Спасибо за совет!', '-- Не за что, сынок!');
		[8] = phr('Здравствуйте! А как вас зовут?', '-- Тимофей я.', [[ pon(12); know_name = true ]]);
		[9] = phr('Вы нищий?', 
			'-- Да, я нищий, но может быть я богат этим... Может быть я философ. Слыхал про дауншифтинг?');
		[10] = phr('А почему вы сидите у зоопарка?', 
			'-- Потому что я собираю деньги на корм моему коту... А еще я тут ночую.', 
			[[ pon(11) ]]);
		[11] = _phr('А как вы попадаете внутрь?',
			'-- Когда хорошо знаешь местность, это не проблема...', [[ pon(14) ]]);
		[12] = _phr('Как ваши дела, Тимофей?',
					'-- Да все по-старому...', [[ pon(); ]]);
		[13] = phr('До свидания!', nil, [[ pon(); back(); ]]);
		[14] = _phr('Помогите мне попасть внутрь!!!',
			'-- Сейчас слишком людно, приходи попозже...');
	},
	exit = function(s)
		if not know_name then
			p "Кстати, меня зовут Тимофей. -- слышу я хриплый голос.";
			prem(8);
			pon(12);
			know_name = true
			return false
		end
		p '-- Давай, сынок!';
	end
};
entr = xroom {
	pic = 'gfx/entr.png';
	nam = 'У входа в зоопарк';
	dsc = [[ Я нахожусь у входа в зоопарк. Теплый майский день. Немного припекает.]];
	xdsc = [[ {ворота:Ворота} открыты, а рядом стоит {cont:контролер}. Справа от ворот находится
		{касса:касса}. В зоопарк заходят  {люди:люди}, неподалеку, у каменной стены сидит
	{нищий:нищий}.]];
	obj = {
		xact('нищий', [[{бездомный:Бездомный} в потрепанной кепке и драном ватнике прислонился к
				стене и сидит в тени. В его руках я вижу {картонка:картонку}.]]); 
		xact('картонка', code [[ 
			p '"На корм коту" -- читаю я на табличке.'
			seen_table = true
		]]);
		xact('бездомный', code [[ walk 'guydlg' ]]);
		xact('люди','Они выглядят довольными. И много {дети:детей}.');
		xact('дети', 'У некоторых я вижу воздушные шарики и вертушки.');
		xact('касса', [[ Подойдя к кассе и заглянув сквозь стекло я могу разглядеть 
			{cassir:кассира}.]]);
		xact('ворота', code [[
			if can_pass then
				walk 'inside'
				return
			end
			if not_money then 
				p "Контролер меня не пропустит..."; 
			else
				p "Я подхожу к воротам, но меня останавливает {cont:контролер}.^^\
		-- Ваш билет, молодой человек?"
			end]]);
		cassir;
		cont;
	};
}
inside = xroom {
	nam = 'Площадь';
	pic = 'gfx/inside.png';
	dsc = [[Я нахожусь на небольшой площади перед выходом из зоопарка.]];
	xdsc = [[Слева от ворот находится сторожевая {будка:будка}. Здесь я вижу множество {народ:детей и их родителей}. 
			Небольшая очередь расположилась у тележки с {тележка:мороженым}, 
			а чуть дальше продаются {шарики:воздушные шарики}. 
			В центре площади расположен {фонтан:фонтан}.
			От площади расходятся две дороги. Около левой находится {карта:карта} зоопарка. ]];
	obj = {
		xact('будка', [[Будка пуста. Наверное, обычно в ней сидит сторож, но пока зоопарк открыт,
			в этом нет необходимости.]]);
		xact('фонтан', code [[ if goon then p 'Фонтан выключен.' else p 'Ух ты! Кажется, я вижу радугу!' end ]]);
		xact('народ', [[Смех детей, улыбки родителей... Лай собак... 
				У меня нет собаки, я всегда прошу родителей купить мне собаку на день рождения, 
				а они дарят мне всякую ерунду. Снова и снова.]]);
		xact('тележка', [[Хорошо бы купить мороженого, но у меня нет денег. Неизвестно еще, как домой добираться.]]);
		xact('шарики', [[Шарики... Когда-то их наполняли водородом и они взрывались. А сейчас от них никакого
			толку...]]);
		xact('карта', code [[
			if not see_map then
				see_map = true
			end
			p 'У нас в городе совсем небольшой зоопарк, судя по карте... Прямо от входа дорога разветвляется на \
		две. Правая -- ведет к административному зданию, а левая петляет вдоль всего зоопарка. На карте отмечены: \
		детская площадка, озеро, много разных зверей, аквариум..';
		]]);
	};
	way = { vroom('Уйти из зоопарка', 'entr'), 
			vroom('Левая дорога', 'lroad'), 
			vroom('Правая дорога', 'rroad') };
	exit = function(s, to)
		if to == entr then
			if goon then
				if visited(tdlg) then
					p [[Неужели я так просто уйду домой? Да и денег все-равно нет.]]
					return false
				end
				if know_ship then
					p [[Второй раз я сюда уже вряд-ли попаду. Думаю, стоит
					поискать Тимофея внутри зоопарка.]]
					return false
				end
				p [[Мне не хотелось уходить домой... Ноги сами вели меня обратно...]]
			else
				p "Я не хочу пока идти домой!"
			end
			return false
		end
	end
}

lroad = xroom {
	nam = 'Дорога';
	pic = 'gfx/lroad.png';
	dsc = [[Я вижу как, извиваясь, дорога уходит вниз к
		хорошо заметному отсюда озеру.]];
	xdsc = [[С одной стороны дороги стоят {клетки:клетки}. Напротив клеток расположена детская площадка.]];
	obj = {
		xact('клетки', [[В клетках сидят разные птицы! Попугаи, конечно, самые красивые. Жаль, не
		говорящие.]]);
		people;
	};
	way = {
		vroom('К выходу', 'inside');
		vroom('К озеру', 'lake');
	};
}
stone = obj {
	nam = 'камень';
	var { in_water = 0 };
	inv = 'Еле держу его в руках...';
	use = function(s, w)
		if nameof(w) == 'озеро' then
			s.in_water = s.in_water + 1
			p [[Я бросил камень в озеро... Довольно заметные волны начали расходиться кругами от места падения.]]
			if s.in_water == 3 then
				p [[Я вгляделся и увидел, как маленький игрушечный кораблик почти прибило к противоположному
					берегу.]];
			end
			remove(s, me());
		else
			p [[Ну нет.]]
		end
		return false
	end
}
lake = xroom {
	nam = 'Озеро';
	pic = 'gfx/lake.png';
	dsc = [[Я подошел к водной глади.]];
	xdsc = [[Поверхность {озеро:озера} имеет зеленоватый оттенок. Посреди озера я вижу скучающего
		белого лебедя! У берега, выложенного с этой стороны озера большими белыми 
		{камни:камнями}, 
		плавают утки. Дорога огибает озеро и ведет свой путь дальше. На другой стороне 
		дороги стоят небольшие {клетки:клетки} с животными, рядом с которыми стоит
		столбик с {табличка:табличкой}.]];
	obj = {
		xact('озеро', [[ Вода притягивает. Даже если не совсем чистая. ]]);
		xact('табличка', [[-- Мелкие млекопитающие! -- читаю я надпись на табличке.]]);
		xact('клетки', [[Больше всего мне понравились зайцы! И опоссумы.]]);
		obj {
			nam ='камни';
			act = code [[
				if need_save then
					if have 'stone' then
						return 'Уже есть один.'
					end
					take 'stone'
					return 'Я взял обеими руками большой камень... Ух -- тяжелый!!!';
				end
				p 'Здоровенные!'
			]]
		};
		people;
	};
	way = {
		vroom('К выходу', 'lroad');
		vroom('Дальше', 'lake2');
	};
	exit = function(s)
		if have 'stone' then
			remove('stone', me());
			p [[Окончательно устав, я бросил камень обратно. Руки ужасно ныли.]]
		end
	end
};

seadlg = dlg {
	pic = 'gfx/seaman.png';
	nam = 'Моряк';
	entered = function(s)
		if stone.in_water > 0 and stone.in_water < 3 then
			pon(10);
		elseif stone.in_water >= 3 then
			p [[Я подошел к матросу, он держал в руках модель судна.
			Лицо его светилось от счастья.]];
			pon(11);
			poff(12,13,14,15,8,7);
			return;
		end
		p [[ Я подошел к человеку в бескозырке. ]];
	end;
	dsc = [[Эй! Да это же моряк!]];
	obj = {
		[1] = phr('Здравствуйте! А вы моряк?...',
			'-- Отстань, а?..', [[ pon(2) ]]);
		[2] = _phr('А что случилось?',
			'Он мельком взглянул на меня. -- Эх, да отстань ты, иди к родителям...',
			[[pon(3)]] );
		[3] = _phr('Дяденька, а я в детстве хотел быть моряком!',
			'-- Эх, месяц трудов насмарку! -- Матрос не обращает на меня внимания...',
			[[ pon(4)]]);
		[4] = _phr('А что у вас в руках?',
			[[ -- Проклятый аккумулятор!!! -- Тут он повернул ко мне свое расстроенное
			лицо. -- Месяц делал! Понимаешь? Ночами! На этом проклятом банановозе!!!
			Эх!!! -- тут он бросил что-то на землю. Похоже, пульт от радиоуправляемой модели.
			Потом он немного постоял так, нагнулся, и поднял пульт с травы.]],
			[[ pon(5) ]]);
		[5] = _phr('Банановозе?',
			[[ -- Отдохнул, понимаешь, отдохнул!!?! Утром отплываем на Кубу, а он заглох!!!
			-- Я проследил за его взглядом и почти на самой середине озера заметил
			едва заметный силуэт игрушечного корабля. -- Поганая жизнь!!! Думаешь, моряк это
			здорово, да??? Замшелый банановоз. Каждый день одно и тоже.]],
			[[ need_save = true; pon (6) ]]);
		[6] = _phr('Ух ты! Это же копия, да?',
			[[ -- Да, сынок! Это канонерка "Кореец"! Слышал? Проклятые аккумуляторы, сдохли!!!]],
			[[ pon (7) ]]);
		[7] = _phr('Ну так сплавайте за ним!',
			[[ -- Умный да? А если я плавать не умею??? -- Все, вали отсюда. Мммм.... Матрос
			явно был не в себе от поразившего его горя.]],
			[[ pon (8) ]]);
		[8] = _phr('Дяденька! Да не переживайте вы так!',
			[[ -- Уйди, а?? Жизни еще не видел, а туда же!!!]],
			[[ pon () ]]);
		[10] = _phr('Как ваш кораблик, еще не прибило к берегу?',
			[[ -- Пока нет! Но мне кажется у нас может получится!!!]]);
		[11] = _phr('Получилось! Теперь вы счастливы?',
			[[-- Да, пацан! Теперь я счастлив. Это даст мне сил проработать еще
			полгодика на дряном банановозе.]],
			[[pon(12) ]]);
		[12] = _phr('А что такое банановоз?',
			[[-- Судно для перевозки фруктов.]],
			[[pon(13)]]); 
		[13] = _phr('А как называется ваш корабль?',
			[[ -- "Поплавок"]],
			[[ pon(14) ]]),
		[14] = _phr('А когда он отплывает?',
			[[ -- В пять утра. Что, хочешь стать юнгой?]],
			[[ know_ship = true; pon(15) ]]);
		[15] = _phr('Неплохая мысль!',
			[[ -- Гони ее в шею, пацан!]]);
		[99] = phr('Ну я пошел...',
			code [[ pon(); back() ]]);
	};
	exit = function()
		poff(10);
		p [[Я отошел от него.]]
		if know_ship then
			p [[Матрос взял свою модель и пошел
			по направлению к выходу...]];
			exist('матрос', objs(lake2)):disable();
			if goon then
				lifeon 'people'
				p [[И тут меня осенило!!! Все сомнения закончились. Я знал, что должен был делать.
				Нужно найти Тимофея! Он поможет мне спрятаться в зоопарке.]]
			end
		end
	end
};
lake2 = xroom {
	nam = 'Озеро';
	pic = 'gfx/lake2.png';
	entered = function(s)
		if from() == lake then
			p [[Пройдя по извивающейся дороге, я обогнул озеро.]];
		else
			p [[Я подошел к месту, где дорога поворачивает налево.]];
		end
	end;
	dsc = [[На этой стороне озера немного прохладней, растущие рядом тополя отбрасывают тени.]];
	xdsc = [[Здесь находятся {клетки:клетки} животных побольше.]];
	obj = {
		xact('клетки', '-- Медведи, волки, обезьяны!!!');
		obj {
			nam = 'матрос';
			dsc = 'На берегу озера стоит человек, по виду {моряк}, и куда-то всматривается.';
			act = function(s)
				walk 'seadlg';
			end
		};
		people;
	};
	way = { 
		vroom('Обойти озеро', 'lake'),
		vroom('Дальше', 'lake3'),
	}
}

lake3 = xroom {
	nam = 'Восточная часть зоопарка';
	pic = 'gfx/lake3.png';
	dsc = [[Здесь дорога довольно далеко отходит от озера.]];
	xdsc = [[Недалеко в траву вбита {табличка:табличка}. Множество больших
		{клетки:клеток} расположены по обеим сторонам дороги. И еще я вижу
		громадный {аквариум:аквариум}!]];
	obj = {
		xact('клетки', [[Я провел довольно продолжительное время у клеток, разглядывая животных.]]);
		xact('табличка', [[-- Зебры, кенгуру, жирафы, верблюды -- читаю я на табличке.]]);
		xact('аквариум', [[Ух ты, камбала... И скаты!!!]]);
		people;
	};
	way = {
		vroom('К повороту', 'lake2');
		vroom('Дальше', 'endz');
	};
};

global {
	seen_gora = false;
	gora_eat = false;
}

banan = obj {
	nam = 'банан';
	tak = 'Я поднял банан с горячего асфальта.';
	dsc = [[У клетки лежит {банан}.]];
	inv = [[Чуть помятый банан.]];
	use = function(s, o)
		if nameof(o) == 'слон' then
			if not seen_gora then
				p [[Мне кажется, служащие зоопарка могут нам помешать.]];
				return
			end
--			set_music 'mus/love2.xm'
			p [[Я протянул банан Горацию сквозь прутья решетки. Но он все так же 
			молча стоял и смотрел мимо меня своими немигающими добрыми глазами.
			А я все ждал, и уже моя рука начала дрожать. Я смотрел в его глаза
			и просил:^
			-- Съешь, пожалуйста, съешь...^
			И тут что-то случилось, Гораций вышел из своего странного состояния и 
			протянул ко мне хобот... Банан скрылся у него во рту.]];
			remove(s, me());
			gora_eat = true
		elseif nameof(o) == 'служащие' then
			p [[У них и так много бананов.]]
		end
	end
}
guysdlg = dlg {
	nam = 'Разговор со служащими зоопарка.';
	pic = 'gfx/two.png';
	entered = [[ Я робко кашлянул и подошел к ним поближе...]];
	dsc = [[ Я вижу перед собой лица служащих зоопарка. Не могу сказать,
		что они мне нравятся.]];
	obj = {
		[1] = phr('Простите, я слышал, слона зовут Гораций?',
			'-- Да, пацан, но тебе не говорили, что подслушивать скверно?',
			[[pon(3)]]);
		[2] = phr('Меня зовут Павлик.',
			'-- Привет-привет, что тебе нужно?');
		[3] = _phr('Я услышал случайно, что Гораций нездоров?',
			'-- Да, не ест он... Думаю, долго не протянет...',
			[[ pon(4) ]]);
		[4] = _phr('А почему?',
			'-- Ну просто плохо ему в клетке, зоопарк у нас маленький, и подружки нет...',
			[[pon (5)]]);
		[5] = _phr('А нельзя его выпустить на волю?',
			[[-- Ха ха!!! Ну ты пацан даешь! Это же какие расходы, да и кто будет этим заниматься?
			Ладно, некогда нам тут с тобой языками чесать. -- С этими словами
			служащие ушли.]], [[ back() ]]);
	}
};
gora = xroom {
	nam = 'У слона';
	pic = 'gfx/gora-cage.png';
	var { time = 1 };
	entered = function(s,f)
		if f == guysdlg then
			return
		end
		if not seen_gora then
			set_music 'mus/love1.xm'
			p [[Когда я увидел его, я понял, что это самое доброе,
			красивое и замечательное существо в этом маленьком
			тусклом зоопарке... Я стоял и смотрел, шло время,
			а я все не мог отойти от клетки... Я держался за холодные
			прутья и смотрел в его добрые спокойные глаза...]];
			lifeon(s);
		end		
	end;
	life = function(s)
		s.time = s.time + 1;
		if s.time > 3 then
			p [[Вдруг я заметил, как к клетке подошли два человека,
			судя по одежде, это были служащие зоопарка. Один из них
			нес мешок с бананами.]]
			lifeoff(s);
			exist('служащие'):enable();
			lifeon(seen('служащие'));
--			path('Назад'):disable();
			return true
		end
	end;
	exit = function(s, to)
		if seen('служащие') then
			p [[Мне пока лучше остаться здесь и посмотреть, что будет дальше.]]
			return false
		end
		if not seen_gora then
			lifeoff(s);
			s.time = 3;
			s:life();
			return false
		end
--		if to ~= guysdlg then
--			p [[Я нехотя отошел от Горация.]]
--		end
	end;
	dsc = [[Я стою перед клеткой.]];
	obj = {
		obj {
			nam = 'слон';
			dsc = [[За прутьями решетки я вижу {слона}!]];
			act = [[Какой он замечательный! Прекрасный слон!!! Клетка для него явно маловата.]];
		},
		obj {
			var { time = 1 };
			nam = 'служащие';
			dsc = [[Два {человека} стоят у клетки.]];
			act = function(s)
				if live(s) then
					p [[Похоже, служащие зоопарка... Послушаю, о чем они говорят...]];
				else
					path('Назад'):enable();
					remove(s);
					seen_gora = true;
					walk 'guysdlg';
				end
			end;
			life = function(s)
				if s.time == 1 then
					p [[Я вижу как один из людей пытается кормить слона,
					вывалив содержимое мешка в клетку,
					но слон не взял ни одного банана. Один из бананов падает под ноги
					с этой стороны клетки...]];
					put('banan');
				elseif s.time == 2 then
					set_music 'mus/noway.ogg'
					p [[ -- Что, не хочешь? Что ж -- тем хуже для тебя, Гораций... -- я слышу, как один 
					из служителей обращается не то к слону, не то к напарнику...]];
				elseif s.time == 3 then
					p [[-- Да, эта хандра убьет его...^
					-- Жаль, он приносил зоопарку деньги.^
					-- Такое бывает с животными в неволе...]];
				else
					p [[-- Ну не ест и ладно, пойдем...]];
					lifeoff(s);
				end
				s.time = s.time + 1
				return true
			end
		}:disable();
	};
	way = { vroom('Назад', 'endz') };
}
cages = obj {
	nam = 'клетки',
	act = function(s)
		if not seen_gora then
			p [[Рассматривая животных я обошел все клетки, пока не подошел к клетке со слоном.]]
		else
			p [[Я сразу подошел к клетке со слоном]];
		end
		walk ('gora')
	end
}
global {
	goon = false;
}
readnews = room {
	nam = 'Газета';
	pic = 'gfx/news.png';
	forcedsc = true;
	hideinv = true;
	dsc = [[ Я не люблю газеты, и пока я переворачивал страницы, мой взгляд рассеянно блуждал
		по сухим взрослым словам: "арестован террорист",
		"пресс-конференция", "электронные паспорта", "кубинский зоопарк"....
		Гм... Зоопарк???^^
		"...Кубинский национальный зоопарк -- один из самых больших зоопарков в мире. 
		Он уникален в том числе тем, что практикует дружественное отношение к 
		братьям нашим меньшим и на его территории зверей не сажают под замок. 
		В зоопарке дружно соседствуют зебры, бегемоты, жирафы, слоны и 
		другие миролюбивые животные. 
		Поездка по зоопарку в автобусе с фотоаппаратом подарит море приятных эмоций."^^
		Гм... Кубинский Национальный Зоопарк!!!]];
	left = function()
		if know_ship then
			lifeon 'people'
			p [[Все сомнения закончились. Я знал, что должен был делать.
			Нужно найти Тимофея! Он поможет мне спрятаться в зоопарке.]]
		else
			p [[-- Гм... Куба...]];
		end
	end;
	obj = {
		vway('дальше', '{Дальше}', 'skam');
	}
};
news = obj {
	nam = 'газета';
	inv = function(s)
		if goon then
			p [[Я уже прочитал все, что было нужно.]]
			return
		end
		if not live(skam) then
			goon = true
			p [[Устав от непривычных мыслей, я взглянул на газету...]];
			ways():enable_all();
			walk 'readnews'
		else
			p [[Мне было не до газеты...]];
		end
	end;
	use = [[Не думаю, что это поможет.]];
	tak = [[Я протянул руку и взял газету.]];
}
skam = xroom {
	var { time = 1 };
	pic = 'gfx/skam.png';
	nam = 'На скамейке';
	entered = function(s, f)
		if f == readnews then
			return
		end
		lifeon(s);
	end;
	way = { vroom('Встать', 'endz'):disable() };
	xdsc = function()
		if goon then
			p [[ Я сидел на {скамейка:скамейке}, люди не спеша проходили мимо.]]
		else
			p [[ Я сидел на {скамейка:скамейке}, почти не замечая проходивших мимо людей.
			Странные {мысли:мысли} бродили в моей голове.]];
		end
	end;
	life = function(s)
		if s.time == 1 then
			p [[-- Почему мир таков, какой он есть? Моя мама добрая,
			а служители зоопарка -- не очень...]];
		elseif s.time == 2 then
			p [[-- Все знают, что злым быть плохо, но Гораций погибает
			здесь совсем один...]];
		elseif s.time == 3 then
			p [[-- Что должен делать я? Мир устроен так просто, но и 
			сложно...]];
		elseif s.time == 4 then
			p [[-- То, что есть мама, я и Гораций -- это просто...]];
		elseif s.time == 5 then
			p [[-- Погибает Гораций -- это сложно...]]
			lifeoff(s);
		end
		s.time = s.time + 1
		return
	end;
	obj = {
		xact('мысли', [[...Непривычные и невеселые мысли, но кажется, что 
			важные...]]);
		obj {
			nam = 'скамейка';
			act = function()
				if have 'news' then
					p [[Я посмотрел на скамейку -- ровные шершавые доски
					синего цвета...]];
					return
				end
				p [[Я посмотрел на скамейку и заметил, что на ее краю
				лежит {газета:газета}, слегка шелестя страницами под
				летним ветерком.]]
				put 'news';
				return
			end
		}
	}
}
endz = xroom {
	nam = 'Конец зоопарка';
	pic = 'gfx/endz.png';
	enter = function(s, f)
		if f == skam then
			p [[Я встал со скамейки.]]
			return
		end
		if f ~= gora then
			p [[Я прошел по дороге еще немного, и наконец дошел до конца зоопарка.]];
		elseif seen_gora then
			if not gora_eat or have 'news' then
				p [[Я медленно отошел от клетки. Гораций не выходил у меня из головы.]]
				return
			end
			p [[Я медленно отошел от клетки. Немногочисленные уже посетители
			тянулись к выходу. Похоже, гуляя по зоопарку, я не заметил, как день
			подошел к концу. Мне надо было ехать домой, без денег... ^
			Но не это занимало сейчас мои мысли. Сам не заметив как, я сел
			на скамейку.]]
			set_music 'mus/lost.mod'
			walk 'skam';
		end
	end;
	dsc = [[Я стою у конца дороги, которая проходит через весь зоопарк.]];
	xdsc = [[Здесь я вижу несколько больших {клетки:клеток}. Как и везде, на {табличка:табличке} 
		написаны названия животных. Возле дороги стоит {скамейка:скамейка}.]];
	obj = {
		xact('скамейка', [[Посидеть? Нет, не хочу.]]);
		xact('табличка', [[-- Зубр, Овцебыки, Тигры, Слон...]]);
		cages;
		people;
	};
	way = {
		vroom('Назад', 'lake3');
	};
};

rroad = xroom {
	nam = 'Дорога';
	pic = 'gfx/rroad.png';
	dsc = 'Я вышел на неширокую прямую дорогу.';
	xdsc = [[Дорога довольно круто уходит вниз и упирается в {дом:здание}.]];
	way = {
		vroom('Наверх', 'inside'),
		vroom('Вниз', 'build'),
	};
	obj = {
		xact('дом', [[Белое здание с потрескавшейся отделкой утопает в зелени.]]);
--		people;
	}
}

build = xroom {
	nam = 'Здание';
	pic = 'gfx/build.png';
	dsc = 'Я нахожусь возле небольшого белого здания. Здесь никого нет.';
	xdsc = [[Деревянная {дверь:дверь} в здание закрыта, 
			на двери висит красная {табличка:табличка}. Несколько окон забраны железными 
			{прутья:прутьями}.]];
	obj = {
		xact('дверь', 'Думаю, не стоит туда заглядывать.');
		xact('табличка', 'А Д М И Н И С Т Р А Ц И Я -- читаю я на красной табличке.');
		xact('прутья', 'На вид крепкие... Хотя и поржавели немного.');
	};
	way = {
		vroom('По дороге', 'rroad');
	};
}

cuba = room {
	hideinv = true;
	nam = 'КУБА';
	pic = 'gfx/cuba.png';
	entered = code [[ set_music 'mus/story.ogg' ]];
	left = code [[stop_music()]];
	dsc = function(s)
		p [[Куба (исп. Cuba) — островное государство в северной части Карибского моря.
		Официальное название — Республика Куба (исп. República de Cuba [re'puβlika ðe 'kuβa]), 
		неофициальное с 1959 года — Остров Свободы.]]
	end;
	obj = { vway('дальше', '{Дальше}', 'intro2') };
}

intro2 = xroom {
	hideinv = true;
	pic = 'gfx/timof.png';
	entered = code [[ set_music 'mus/shadows.it' ]];
	nam = [[Зоопарк. 00:14]];
	dsc = [[... -- Ну хорошо, а как мы его увезем?^
		-- На корабле!^
		-- Гм, логично.... Эм... На каком корабле???^
		-- В пять утра на кубу отправляется банановоз "Поплавок".^
		-- Гм... До порта 60 км... И ты говоришь, Гораций умирает?^
		-- Да, и он никому не нужен, кроме нас...^
		-- Нас??? Гм, да, сынок. Я с тобой... -- С этими словами Тимофей достал из ватника бутылку и сделал
		большой глоток. -- Идем!...]];
	xdsc = [[{дальше:Дальше}]];
	obj = { xact('дальше', code [[ gamefile('part2.lua', true); ]]) };
};
-- vim:ts=4
