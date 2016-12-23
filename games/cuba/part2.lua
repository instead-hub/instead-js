function init()
	take 'mobil'
	take 'news'
	inv():enable_all();
	lifeon 'timof'
	set_music 'mus/shadows.it'
end

mobil = obj {
	nam = 'мобильник';
	inv = function(s)
		if seen 'унитаз' then
			walk 'entercode'
			return
		end
		p [[Мой мобильник.]]
	end;
	use = function(s, o)
		if o == storog or nameof(o) == 'будка' and not storog.sleep then
			if timof.fountain and rifle.arm then
				p [[Я включил на мобильнике максимальную громкость
				и поставил одну из своих любимых песен.
				Звук рока нарушил ночную тишину зоопарка.]]
				storog_sleep();
				return false
			end
			return "Позвонить сторожу?", false
		end
		if o == fisher and fisher.trading then
			return "Мобильник я не отдам!", false
		end
		p [[Не выйдет...]];
		return false
	end
}
function storog_sleep()
	p [[Через некоторое время дверь сторожевой будки открылась
	и сторож осторожно вышел на площадь... Слева я слышал
	ровное дыхание Тимофея, затем последовал хлопок выстрела,
	сторож удивленно вскрикнул и побежал обратно в будку...
	Немного не добежав до будки он упал. Мы вышли из-за фонтана.]]
	storog.sleep = true
	timof.fountain = false
	path('Будка'):enable();
	set_music 'mus/long.it'
end

main = room {
	enter = code [[ walk 'inhome' ]];
	nam = 'Часть 2';
}

global { know_adm = false }

tdlg = dlg {
	pic = 'gfx/timof.png';
	nam = 'Тимофей';
	dsc = [[ Я смотрю в мудрые и честные глаза Тимофея. ]];
	left = code [[ poff(1, 4) ]];
	entered = function()
		if from() == inhome then
			pon(1);
		end
		if not storog.sleep and visited(inside) and know_adm then
			pon(4);
		end
		if taken 'gas' then
			poff(7)
		elseif timof.rifle and timof.shpric then
			pon(7);
		end
	end;
	obj = {
		[1] = _phr('А где кот?',
			[[ -- Барсик то? Да бегает где-то по зоопарку, охотится.]],
			[[ prem() ]]);
		[3] = phr('Как вы думаете, где ключи от клеток?',
			'-- Я думаю, они в административном здании...',
			[[ pon(5) ]]);
		[4] = _phr('Как бы нам обмануть охранника и попасть в административное здание...',
			function()
				if timof.rifle then
					return "Ну, у нас есть ружье..."
				end
				return "Пока не ясно, сынок..."
			end);
		[5] = _phr("А где находится административное здание?",
			[[-- От главного входа направо, сынок... И еще, нам
			скорее всего понадобится ветеринарное свидетельство
			на Горация, если мы доберемся до порта... Думаю,
			оно должно быть там-же.]],
			[[ know_adm = true;]]);
		[6] = _phr("А как Барсик спас вам жизнь?",
			[[-- Старая история, сынок... Как-то одни нехорошие люди забрали его в институт... 
				Натерпелись мы там... Потом еще с ураном нехорошо как-то получилось... 
				Хотя, сынок, не надо об этом...]]);
		[7] = _phr("Где же искать баллончик для ружья?",
			"-- Я думаю что там же, где ты нашел ружье, сынок.",
			[[ prem() ]]); 
		[99] = phr ('Я рад, что не один в эту ночь!',
			[[ -- Сынок, этот мир все еще держится на дружбе. ]],
			[[ pon(); inv():del 'timof'; back(); ]]);
	};
}

news = obj {
	nam = 'газета';
	var { wet = false };
	inv = function(s)
		p [[Я уже прочитал все, что было нужно.]]
		if s.wet then
			p [[К тому-же, газета мокрая.]]
		end
	end;
	use = function(s, w)
		if nameof(w) == 'озеро' then
			if s.wet then
				return "Газета уже мокрая."
			end
			p [[Я нагнулся и намочил газету в воде.]]
			s.wet = true;
			return false
		end
		if w == win1 then
			if path('В окно'):disabled() then
				return "Не дотянуться...";
			end
			if s.wet then
				inv():del(s);
				win1.news = true;
				p [[Я приклеил мокрую газету на стекло.]]
				return
			end
			p [[Гм, как это поможет? Газета не будет держаться... Может быть, намочить ее?]]
			return
		end
		return [[Не думаю, что это поможет.]], false
	end
}

glassend = room {
	pic = 'gfx/gora-cage.png';
	hideinv = true;
	forcedsc = true;
	enter = code [[ game.lifes:zap(); set_music 'mus/story.ogg' ]];
	nam = 'Конец';
	dsc = [[Звук битого стекла на фоне тишины показался
		очень пронзительным... На шум прибежал сторож...
		Так наш план провалился... Хотя,
		может быть все было {заново:по-другому}?]];
	obj = {
		xact('заново', code [[ restore_snapshot(); ]]);
	}
}

bottle = obj {
	var { full = false };
	nam = 'бутылка';
	inv = function(s)
		if s.full then
			return "В бутылке зеленая вода из озера.";
		end
		return 'Я не разбираюсь в спиртном, но кажется, это был коньяк.';
	end;
	use = function(s, w)
		if w == win1 then
			if disabled(path('В окно')) then
				p [[Я размахнулся и бросил увесистую бутылку в окно.]]
				return walk 'glassend'
			else
				p [[Я взял бутылку в правую руку за горлышко и нанес удар по стеклу.]]
				if not win1.news then
					return walk 'glassend'
				end
				p [[Стекло разбилось с небольшим шумом -- мокрая газета не 
				дала осколкам разлететься...]]
				win1.broken = true
				inv():del(s);
				delete_snapshot() -- save space
				return
			end
		end
		if nameof(w) == 'озеро' then
			if s.full then
				return [[В бутылке уже есть вода.]], false
			end
			s.full = true
			return [[Я набрал воду в бутылку.]], false;
		end
		if w == news and s.full then
			if w.wet then
				return "Уже мокрая."
			end
			s.full = false
			w.wet = true
			return [[Я вылил содержимое бутылки на газету.]]
		end
		return 'Бутылкой?', false
	end
}

timof = obj {
	var { door1 = false, bottle = true };
	var { rifle = false, gas = false, shpric = false };
	var { fountain = false };
	nam = 'Тимофей';
	dsc = function(s)
		if not live(s) and here() == entr2 then
			return "{Тимофей} возится у дверей машины."
		end
		p 'Со мной {Тимофей}.';
		if rnd(20) < 3 then
			if s.bottle then
				p (txtem'Я вижу, как он достал {timof(bottle):бутылку} из-за пазухи и сделал глоток.')
			else
				p (txtem 'Я вижу, как он достал из-за пазухи небольшую фляжку и сделал глоток.')
			end
		end
	end;
	inv = function(s)
		if s.door1 then
			if not path('В окно'):disabled() then
				return 'Я стою на плечах Тимофея.'
			end
			p [[Я подошел к Тимофею, он взял меня на руки и поставил на плечи.
			Теперь я могу добраться до окна 2-го этажа!]]
			path('В окно'):enable();
			return
		end
		if isDialog(here()) then
			return true
		end
		walkin 'tdlg'
	end;
	act = function(s, w)
		if not live(s) and here() == entr2 then
			return "Лучше ему не мешать."
		end
		if w == 'bottle' then
			pn '-- А можно мне взять бутылку?'
			pn '-- Зачем она тебе, сынок?'
			pn '-- Для дела!'
			pn '-- Ладно, держи!'
			pn '...'
			pn '-- Ох, сынок! Зачем же ты ее вылил?!!!'
			pn '-- Мы должны быть трезвыми.'
			p '-- Эх, сынок...'
			s.bottle = false 
			take 'bottle'
			return
		end
		if not have(s) then
			inv():add(s);
			return "-- Да, сынок?";
		end
		inv():del(s);
		if s.door1 then
			return "Тимофей стоит на тележке."
		end
		if s.fountain then
			return "Тимофей занял позицию за фонтаном.";
		end
		p "-- Ничего... Я так..."
	end;
	use = function(s, w)
		inv():del(s);
		if w == teleg and teleg.door1 then
			if s.door1 then
				return "Уже стою на этой проклятой штуке, сынок!", false
			end
			p "-- Гм... -- Тимофей подошел к тележке и взобрался на нее.";
			s.door1 = true
			return false
		end
		if w == dogs then
			if rifle.arm then
				return [[-- Сынок, их слишком много, ружье нужно каждый раз
				перезаряжать. Да и шприцов у нас столько нет...]], false
			end
			return [[-- Заклятые друзья моего Барсика, сынок...]], false
		end
		if w == win1 then
			return "-- Не дотянуться!", false
		end
		if nameof(w) == 'прутья' then
			return "-- Слишком крепкие, сынок.", false
		end
		if nameof(w) == 'окна' then
			return "-- Тут прутья, сынок.", false
		end
		if nameof(w) == 'дверь1' then
			return "-- Дверь открыта, сынок!", false
		end
		if nameof(w) == 'дверь2' then
			if w.opened then
				return "-- Она открыта, сынок!", false
			end
			p [[-- Сынок, тут негде даже разбежаться.]]
			return false
		end
		if nameof(w) == 'двери' then
			p [[Некоторое время Тимофей безрезультатно испытывал 
			закрытые двери на прочность. -- Я как то к окнам больше 
			привык, сынок -- почему-то сказал он.]]
			return false
		end
		if w == door1 or w == door2 then
			s.door1 = false
			if here() == whouse then
				path('В окно'):disable()
			end
			p [[ -- Гм. Можно попробовать. -- Тимофей отошел немного и
			с разбега врезался в дверь плечом, после глухого удара я услышал
			приглушенный стон. -- Похоже, 
			у меня не получилось, сынок.]]
			return
		end
		if nameof(w) == 'сейф' then
			return [[-- Не думаю, что мы сможем открыть его силой, сынок.]], false;
		end
		if nameof(w) == 'фонтан' then
			if storog.sleep then
				return [[-- Сторож нам не помешает, сынок.]], false
			end
			if s.fountain then
				return [[-- Уже здесь, сынок!]], false
			end
			s.fountain = true
			return [[-- Спрятаться за фонтаном? Гм.. Хорошо. -- Мы осторожно прокрались
			к фонтану и, пригнувшись, затаились.]], false
		end
		if w == storog then
			if storog.sleep then
				return "-- Он спит, сынок... Нет смысла его беспокоить.", false;
			end
			if not rifle.arm then
				if s.rifle then
					p "-- Да, у нас есть ружье, сынок,";
					if not s.gas then
						p "но оно не сможет выстрелить без баллончика."
						return false
					end
					if not s.shpric then
						p "но нет патронов."
						return false
					end
				end
				p "-- Что нам делать со сторожем, сынок?";
				return false
			end
			if not s.fountain then
				return [[-- Я не смогу попасть в него с этой позиции,
				ружье не такое дальнобойное... К тому-же сторож сидит в будке.
				Нужно что-то придумать, сынок.]], false
			end
			return [[-- Мне кажется, я не смогу попасть в него, пока он внутри.]], false;
		end
		p [[-- Гм, не понимаю тебя, сынок.]]
	end;
	life = function(s)
		if here() ~= where(s) and not isDialog(here()) and not here().hideinv then -- follow player
			move(s, here(), where(s));
			inv():del(s);
			s.door1 = false
			return true
		end
	end
}

flash = obj {
	var { on = false; off = false; };
	nam = 'фонарик';
	life = function(s)
		if here() == endz and have 'keys' then
			s.off = true
			lifeoff(s)
			return [[Свет фонарика ослаб, а через минуту погас совсем. 
			Батарейки?]];
		end
		if here() ~= inw and player_moved() and here().light ~= false and not isDialog(here()) then
			p [[Лучше выключу фонарик, чтобы зря батарейки не сажать. Я выключил фонарик.]];
			lifeoff(s);
			s.on = false
		end
	end;
	inv = function(s)
		if s.on then
			s.on = false
			lifeoff(s)
			return "Я выключил фонарик."
		end
		if s.off then
			return "Я попробовал включить фонарик, но он не загорелся. Сели батарейки?"
		end
		s.on = true
		if ((here() == endz or here() == incage) and taken(keys)) or (coast1 and visited(coast1)) then
			s.off = true
			return "Я включил фонарик. Его свет был непривычно тусклым, а через минуты и вовсе пропал. Батарейки?"
		end
		lifeon(s)
		return "Я включил фонарик.";
	end;
	use = function(s, o)
		if o == fisher and fisher.trading then
			p [[Я протянул рыбаку фонарик. Он сначала проявил к нему интерес,
			но потом вернул назад.^
			-- Не работает!!!^
			-- Он работает!!! Просто батарейки сели!!!^
			-- Гм... Сдается мне вы хотите меня надуть??? -- он посмотрел
			мне в глаза, -- ладно, давай свой фонарик, я даю за него
			новый чехол от удочки!!! Забирайте...]];
			chehol.price = true
			inv():del(s)
			return false
		end
		if s.on then
			if o == storog or nameof(o) == 'будка' and not storog.sleep then
				if timof.fountain and rifle.arm then
					p [[Я посветил фонариком в сторону сторожа.]]
					storog_sleep();
					return false
				end
				if storog.sleep then
					return "Сторож спит!", false
				end
				return "Сторож заметит!", false
			end
			p [[Я посветил фонариком.]]
			return
		end
		p [[Выключенным фонариком? Странно...]]
		return false
	end
}

mlamp = obj {
	nam = 'лампа',
	inv = [[Старая лампа, с фитилем! Раритет.]];
	use = function(s, w)
		if w == fisher and fisher.trading then
			p [[Я протянул лампу рыбаку... -- Гм, антиквариат??? Гм... Ну если у вас больше
			ничего нет... Ладно, забирайте весло!!!]];
			inv():del(s);
			veslo.price = true
			fishdlg:prem(6, 8, 9)
			return false
		end

		if w == teleg then
			if w.skrip then
				p [[Я нагнулся, открыл лампу и вылил немного масла на колеса,
				стараясь попасть в подшипники.]]
				w.skrip = false
				delete_snapshot(1) -- save user space!!!
				return false
			end
			p [[Я уже смазал тележку.]]
			return false
		end
		p [[-- Гм, зачем?]]
		return false
	end
}

global { cat_drink = false }

inhome = xroom {
	inside = true;
	pic = 'gfx/home.png';
	nam = 'В сарае';
	dsc = [[ Я нахожусь в сарае Тимофея, небольшом подсобном помещении, сбитом из досок. ]];
	xdsc = function(s)
		p [[ На полу стоит {раскладушка:раскладушка}. Желтый и тусклый свет от {лампа:лампочки}
		накаливания освещает {полки:полки}. В углу я вижу {коврик:коврик}, у которого стоит]]
		if not cat_drink then
			p "{блюдце:блюдце} с молоком."
		else
			p "пустое {блюдце:блюдце}."
		end
		p [[В одной из стен находится  деревянная {дверь:дверь}.]]
	end;
	obj = {
		xact('раскладушка', [[Похоже, на ней спит Тимофей.]]);
		xact('лампа', [[Лампочка висит на проводе, уходящем в угол сарая.
			Хорошо, что в сарае нет окон, иначе бы Тимофея заметили сторожа.]]);
		xact('полки', code [[ 
			if taken(flash) then 
				if not taken(mlamp) then
					take(mlamp);
					return "Я еще порылся на полках и нашел... старую лампу!";
				end
				return "Больше ничего интересного." 
			end
			p "Я поискал на полках, что могло оказаться интересным.\
			Ой, да тут фонарик!"
			take 'flash'
			]]);
		xact('коврик', "Наверное, это коврик кота Тимофея?");
		xact('блюдце', code [[ 
			if cat_drink then 
				p "Похоже, молоко выпил кот!"; 
			else 
				p "Я не люблю молоко."
			end]]);
		xact('дверь', "Дверь не заперта.");
	};
	way = { vroom('Выйти', 'houses') };
}

houses = xroom {
	nam = 'Хозяйственные постройки';
	pic = 'gfx/houses.png';
	dsc = [[ Хозяйственные постройки занимают небольшую площадь,
		слабо освещаемую фонарем.]];
	xdsc = [[ В темной части находится {сарай:сарайчик} Тимофея.
		Рядом находится небольшое двухэтажное {здание:здание}.
		Отсюда расходятся две неширокие дороги.]];
	obj = {
		xact('сарай', [[Интересно, как тут живется зимой?]]);
		xact('здание', [[Здание еле видно отсюда. Угрюмое 
		двухэтажное здание с темными окнами.]]);
	};
	way = { vroom('Сарай', inhome);
		vroom('Здание', 'whouse');
		vroom('Левая дорога', 'entr2');
		vroom('Правая дорога', 'lroad');
	}
}
dogs = obj {
	var { run = false };
	nam = 'собаки';
	life = function(s)
		if s.run then
			if not here().inside and not isDialog(here())
				and not here().hideinv and rnd(10) == 5 then
				p [[Где-то в глубинах зоопарка я слышу собачий лай.]]
			end
			return
		end
		p [[Перед нами скалятся {dogs:собаки}.
		Что-то мне подсказывает, что у нас нет шансов. Нужно отходить.]];
		return true
	end;
	act = function(s)
		p [[Рядом две... Еще третья бежит... Ох... А там еще... Надо убираться.]];
	end;
}
entr2 = xroom {
	nam = 'Служебная зона';
	dsc = [[Служебная зона занимает небольшую площадь и окружена деревьями.]];
	pic = function(s)
		if not tigr.seen then
			return 'gfx/sz.png';
		end
		return 'gfx/sz2.png';
	end;
	enter = function(s)
		if not storog.sleep then
			p [[Я собрался идти по левой дороге, когда Тимофей взял меня за руку.
			-- Сынок, наверное, не стоит туда сейчас идти, там 
			у служебных ворот собаки... Они могут 
			привлечь внимание сторожа.^^Похоже, стоит довериться Тимофею.]]
			return false
		end
		if seen 'dogs' then
			p [[Когда, пройдя по темной дороге мы, 
			наконец, вышли на освещенную территорию,
			навстречу к нам выбежало несколько собак.
			Похоже, тут их территория...]];
			lifeon 'dogs'
			here():disable_all();
			dogs:enable();
			set_sound 'snd/dog.ogg'
		end
	end;
	left = function(s, to)
		if to == houses and seen 'dogs' then
			here():enable_all();
			lifeoff 'dogs'
			p [[Мы очень осторожно, пятясь, пошли назад. 
			Где-то на середине пути собаки потеряли к нам
			интерес.]]
		end
	end;
	xdsc = function(s)
		if not tigr.seen then
			p [[Недалеко, напротив служебных {ворота:ворот},
			стоит большой {грузовик:грузовик}.]]
		else
			p [[Здесь находятся служебные {ворота:ворота}.]]
		end
		p [[ Чуть поодаль
			расположено длинное одноэтажное {здание:здание}
			с множеством {двери:дверей}. Служебная зона
			освещена {фонари:фонарями}.]];
	end;
	obj = {
		dogs;
		'lamps';
		xact('ворота', 'Ворота закрыты.');
		xact('грузовик', 'Фура, наверное, для перевозки животных');
		xact('здание', 'Похоже, здесь хранится корм.');
		xact('двери', code [[
			path 'В сарай':enable();
			p 'Все двери оказались закрыты, кроме одной.'
		]]);
	};
	way = { 
		vroom('К постройкам', 'houses');
		vroom('В сарай', 'saray'):disable();
	};
}

pila = obj {
	nam = 'пила';
	var { blade = true };
	inv = function(s)
		p 'Пила по металлу.';
		if not s.blade then
			p 'Без лезвия.';
		end
	end;
--	dsc = [[У забора лежит {что-то} металлическое...]];
--	tak = [[Да это же пила!]];
	use = function(s, on)
		if not s.blade then
			return "У пилы нет лезвия."
		end
		if on == cages then
			p [[Я начал пилить прутья клетки... Но старое полотно пилы не выдержало
			и треснуло. Теперь у пилы нет лезвия.]]
			s.blade = false
			return
		end

		if nameof(on) == 'прутья' or (on ~= win1 and nameof(on) == 'окно' and here() == whouse) then
			p [[Я начал пилить прутья... Но старое полотно пилы не выдержало
			и треснуло. Теперь у пилы нет лезвия.]]
			s.blade = false
			return
		end
		
		if nameof(on) == 'контейнеры' then
			p [[Запилить их всех?]];
			return
		end
		if nameof(on) == 'контейнер' then
			if on.opened then
				return "Уже распилил!"
			end
			if seen 'gruzchik' then
				return "Нужно что-то делать, нас обнаружил грузчик!";
			end
			p [[Я взял в руки пилу и принялся пилить
			стержень замка. Много сил не требовалось,
			но нужно было время... И все-таки мое
			упорство дало результат, замок был открыт!!!]]
			on.opened = true
			return
		end
		return "Нет смысла это пилить."
	end
}

drel = obj {
	nam = 'дрель';
	var { on = false; try = false; };
	inv = 'Электродрель. Тяжелая!';
	dsc = "На полу лежит {дрель}";
	tak = "Я поднял тяжелую дрель с пола.";
	use = function(s, w)
		if w == rozetka and not taken(w) then
			p [[Я воткнул дрель в розетку и попробовал включить.
			Не работает. Или дрель, или розетка.]]
			return false
		end
		if w == rozetka2 then
			if rozetka2.chainik or rozetka2.provod then
				return [[Розетка занята.]], false
			end
			p [[Я воткнул дрель в розетку.]]
			drel.on = true
			rozetka2.drel = true
			return false
		end
		if w == udlin and not s.on then
			if not rozetka2.provod then
				return "Зачем? Удлинитель не подключен.", false
			end
			s.on = true
			return "Я подсоединил дрель к удлинителю.", false
		end
		if not s.on then
			return "Это электродрель. Значит, нужно электричество.", false
		end
		if nameof(w) == 'дверь2' and not w.opened then
			p [[Я нажал на кнопку и дрель с шумом включилась. Сверло вгрызлось в дверь,
			я пытался высверлить замок...  Но мои руки меня не слушались,
			и я вынужден был выключить дрель.]]
			s.try = true;
			return false
		end
		if w == timof and s.try and here() == bin and not exist('дверь2').opened then
			p [[Я передал дрель Тимофею. Он взял ее в свои крепкие руки и дело пошло...
			Через несколько минут Тимофей устало положил дрель на пол.]]
			inv():del(s);			
			put(s);
			exist('дверь2').opened = true
			return false
		end
		p [[Нет смысла это сверлить.]]
		return false
	end
}

otvertka = obj {
	nam = 'отвертка';
	inv = 'Замечательная отвертка!';
	use = function(s, w)
		if w == gerb and not taken 'gerb' then
			p [[Я поддел отверткой герб и оторвал его от почтового ящика!!!]]
			take 'gerb'
			return
		end
		if w == rozetka and not taken(w) then
			p [[Я осторожно выкрутил розетку.]]
			take (w);
			return
		end
		if nameof(w) == 'чайник' then
			if w.opened then
				return "Я уже разобрал все, что мог.", false
			end
			if rozetka2.chainik then
				return "Током шибанет!", false
			end
			w.opened = true
			p [[Проще всего было разобрать подставку, что я и сделал.]]
			return false
		end
		p [[Это бесполезно раскручивать.]]
	end
}

saray = xroom {
	inside = true;
	nam = 'В сарае';
	pic = function(s)
		if not flash.on then
			return 'gfx/dark.png'
		end
		return 'gfx/saray.png'
	end;
	dsc = 'В сарае сыро и прохладно.';
	xdsc = function(s)
		if flash.on then
			return [[Свет фонарика освещает небольшое
			подсобное помещение. В центре расположен {верстак:верстак}.]]
		end
		p [[Темно, ничего не видно.]]
	end;
	obj = {
		xact('верстак', code [[
			if taken 'drel' then
				return "Ничего интересного, только стружки."
			end
			take 'drel'
			take 'otvertka'
			take 'pila'
			return "Осмотрев верстак, я обнаружил электродрель, отвертку и пилу!"
		]]);
	};
	way = { vroom('Выйти', 'entr2')};
}
door1 = obj {
	nam = 'дверь';
	act = [[ Несмотря на всеобщее запустение,
		закрытая дверь выглядит надежной.]];
}

win1 = obj {
	var { news = false; broken = false; };
	nam = 'окно';
	act = function(s)
		if teleg.door1 then
			if not timof.door1 then
				return [[Я встал на тележку и попробовал дотянуться до
				окна на втором этаже. Не выходит.]]
			end
		end
		p "Одно из окон находится прямо над дверью."
		if s.broken then
			p "Оно разбито!"
			return
		end
		if s.news then
			p "На стекло наклеена мокрая газета."
		end
	end
}

whouse = xroom {
	nam = 'У здания';
	pic = function(s)
		if not teleg.door1 then
			return 'gfx/inw.png';
		end
		if not timof.door1 then
			return 'gfx/inw2.png';
		end
		if path('В окно'):disabled() then
			return 'gfx/inw3.png';
		end
		return 'gfx/inw4.png'
	end;
	entered = code [[	make_snapshot() ]];
	dsc = [[ Невысокое двухэтажное здание. Тишину нарушают
		лишь хруст сухих веток под ногами.]];
	xdsc = [[
		К черному проему {дверь:двери} ведут потрескавшиеся ступеньки.
		Возле двери расположено {окно:окно}, еще два {win1:окна} находятся
		на уровне второго этажа.
	]];
	obj = {
		door1;
		xact('окно', [[ Окно на первом этаже забрано железной решеткой.]]);
		win1;
	};
	left = code [[ path('В окно'):disable() ]];
	way = { houses, vroom('В окно', 'inw'):disable() };
}

function give_timof(w)
	if w == rifle then
		p [[Я протянул ружье Тимофею... -- Вот это да, сынок! Это же
		пневматическое ружье, стреляющее транквилизаторами.]]
		if not timof.gas then
			p [[Жаль, баллончика с газом нет. Без него ружье не стреляет.]]
		end
		timof.rifle = true
	end
	if w == gas then
		p [[Я протянул баллончик Тимофею... -- Сынок, это похоже на
		CO2 баллончик для пневматики.]]
		timof.gas = true
	end
	if w == shpric then
		p [[Я протянул шприцы Тимофею... -- Гм... -- Тимофей вгляделся
		в находку -- похоже, транквилизаторы!]];
		timof.shpric = true
	end
	inv():del(w)
	if timof.rifle and timof.gas and not rifle.loaded then
		p [[С этими словами Тимофей ловко вставил баллончик CO2 в ружье.]]
		rifle.loaded = true
	end
	if rifle.loaded and timof.shpric and not rifle.arm then
		p [[-- Гм, теперь мы вооружены! -- закончил он, вставляя один из
		шприцов в ружье.]]
		rifle.arm = true
	end
end

rifle = obj {
	var { arm = false; loaded = false; hidden = false; arms = 2; };
	nam = 'ружье';
	inv = "Это же пневматическое ружье.";
	use = function(s, w)
		if w ~= timof then
			return "Мне кажется, сам я не справлюсь с ружьем.", false
		end
		give_timof(s)
	end
}

gas = obj {
	nam = "баллон";
	inv = "Какой-то баллончик... Гм...";
	use = function(s, w)
		if w ~= timof then
			return "Я даже не знаю что это такое.", false
		end
		give_timof(s)
	end
}

shpric = obj {
	nam = 'шприцы';
	inv = "Какие-то шприцы странного вида... Внутри прозрачная жидкость.";
	use = function(s, w)
		if w ~= timof then
			return "Уколоть шприцом? Ерунда какая-то...", false
		end
		give_timof(s)
	end
}

kolbasa = obj {
	nam = 'колбаса';
	inv = 'Не до колбасы как-то...';
	use = function(s, w)
		if w == timof then
			return '-- Спасибо, сынок, мне не нужна закуска.', false;
		end
		if w == dogs then
			p [[Я бросил колбасу псам, стараясь, чтобы она упала
			подальше от нас... Вдруг из-за деревьев
			метнулась темная тень...^^
			-- Барсик! -- крикнул Тимофей.^
			Крупный кот промчался мимо псов к колбасе, и не меняя траектории
			движения, уже добрался до первых кустов, когда
			собаки, наконец очнувшись, с лаем бросились в том
			направлении, где скрылся Барсик...^^
			-- Вот негодный кот -- улыбается Тимофей -- все время их
			доводит! -- Знаешь, сынок, а ведь он мне жизнь однажды спас,
			мы многое вынесли вместе с котом этим, сынок, многое...]]
			tdlg:pon(6);
			inv():del(s);
			remove(dogs)
			here():enable_all();
			dogs.run = true
		end
	end
}

rozetka = obj {
	nam = 'розетка';
	dsc = function(s)
		if flash.on then
			p [[У холодильника расположена {розетка}.]]
		end
	end;
	use = function(s, w)
		if taken 'rozetka' and (w == rozetka or w == provod) then
			p [[Я соединил провод с розеткой при помощи отвертки. У меня получился
			удлинитель!]];
			inv():del(rozetka);
			inv():replace('провод', udlin);
			return false
		end
		return "Вряд-ли это поможет.", false
	end;
	act = [[Обычная розетка.]];
	inv = [[Старая пластмассовая розетка.]]
};
		
inw = xroom {
	inside = true;
	nam = "Комната";
	pic = function(s)
		if not flash.on then
			if s.time > 2 then
				return 'gfx/insideb-dark.png'
			end
			return 'gfx/dark.png'
		else
			return 'gfx/insideb.png'
		end
	end;
	var { time = 0 };
	life = function(s)
		s.time = s.time + 1;
	end;
	enter = function(s)
		cat_drink = true
		if not win1.broken then
			return "Попасть внутрь мне мешает стекло!", false
		end
		lifeon (s)
		s.time = 0
		lifeoff 'teleg'
		inv():del 'teleg';
		lifeoff 'timof'
		inv():del 'timof';
		p [[Стараясь не порезаться об острые осколки я спрыгнул на пол.
		Глухой звук падения нарушил звенящую тишину пустого помещения.]]
	end;
	dsc = [[ Я внутри незнакомой комнаты.]];
	xdsc = function(s)
		if not flash.on then
			if s.time == 2 then
				return "Мои глаза начинают привыкать к темноте. Слева я различаю очертания {шкаф:шкафа}."
			elseif s.time == 3 then
				return [[Я могу различить очертания комнаты. Слева я различаю {шкаф:шкаф}. Еще
				здесь есть {стол:стол}.]]
			elseif s.time > 3 then
				return [[Я нахожусь в темной комнате. Слева я различаю какой-то {шкаф:шкаф}. Еще
				здесь есть {стол:стол}. И {холодильник:холодильник}!]]
			end
			return "Темно. Я ничего не вижу. Хотя, кажется слева {шкаф:что-то} есть..."
		end
		p [[Фонариком я освещаю комнату, в которую забрался. Слева я вижу {шкаф:шкаф}.
			Еще здесь есть {стол:стол}. Напротив меня {дверь:дверь}, возле которой
			есть {выключатель:выключатель}.
			В углу стоит {холодильник:холодильник}.]]
	end;
	obj = {
		xact ('выключатель', 'Я пощелкал выключателем. Света нет.');
		obj {
			nam = "шкаф";
			act = function(s)
				if inw.time == 1 and not flash.on then
					return "Это шкаф!"
				end
				if not taken(rifle) then
					take 'rifle'
					return [[Я заглянул в высокий шкаф. Постойте-ка... Да это же ружье!]]
				end 
				p [[Больше ничего интересного я не нашел.]];
			end;
			used = function(s, w)
				if w == flash then
					if not taken 'rifle' then
						take 'rifle'
						return [[Я заглянул в высокий шкаф. Постойте-ка... Да это же ружье!]]
					elseif not taken 'gas' then
						take 'gas'
						p [[Я тщательно обследовал шкаф фонариком и что-то нашел!]]
						return
					end
					p [[Я еще раз все обследовал, но не нашел ничего интересного.]]
				end
			end;
		};
		rozetka;
		xact("стол", "Стол как стол.");
		xact("дверь", "Дверь закрыта снаружи.");
		xact("холодильник", function(s)
			if not taken 'shpric' then
				take 'shpric'
				take 'kolbasa'
				return [[Я подошел к холодильнику и открыл дверцу... Так...
				Еда... А это что такое? Какие-то странные шприцы...]]
			end
			p [[Больше ничего интересного.]]
		end)
	};
	left = function(s)
		lifeoff (s)
		lifeon 'timof'
		timof.door1 = false
		p [[Я выбрался из окна на плечи Тимофея. Он помог мне спуститься и спрыгнул с тележки сам.]]
	end;
	way = { vroom('Назад', whouse) };
}

cages = obj {
	nam = 'клетки';
	act = function(s)
		if not have 'keys' and not gora_open and tigr.seen then
			inv():add 'keys'
			return [[Я вытащил ключи из замка.]]
		end
		if gora_open then
			return walk 'ep2end'
		end
		if tigr.seen then
			return [[Клетка Горация справа от тигров...]]
		end
		if here() == endz then
			return [[Там Гораций! Кажется, я вижу его очертания...]];
		end
		p [[Не буду беспокоить животных, у них был трудный день.]];
	end;
}

lamps = obj {
	nam = 'фонари';
	act = [[Дрожащий желтый свет. Кажется, что тусклые фонари едва горят.]];
}

lroad = xroom {
	nam = 'Дорога';
	pic = 'gfx/night-lroad.png';
	dsc = [[Я вижу как, извиваясь, дорога уходит вниз.]];
	xdsc = [[С одной стороны дороги стоят {клетки:клетки}. Напротив клеток расположена детская площадка.
	Дорога освещена тусклым светом {фонари:фонарей}.]];
	obj = {
		cages;
		lamps;
	};
	way = {
		vroom('К выходу', 'inside');
		vroom('К постройкам', 'houses');
		vroom('К озеру', 'lake');
	};
}

stone = obj {
	nam = 'камень';
	inv = 'Еле держу его в руках...';
	use = function(s, w)
		if nameof(w) == 'озеро' then
			p [[Я бросил камень в озеро... Довольно заметные волны начали расходиться кругами от места падения.]]
			remove(s, me());
		elseif nameof(w) == 'камни' then
			remove(s, me());
			return "Я бросил камень обратно."
		elseif w == teleg then
			if teleg.stones > 5 then
				p [[Еще пару камней и я не смогу возить тележку.]]
				return
			end
			remove(s, me());
			teleg.stones = teleg.stones + 1
			p [[Я положил камень в тележку. Со стуком он упал внутрь.]]
		else
			p [[Ну нет.]]
		end
		return false
	end
}

teleg = obj {
	var { skrip = true; door1 = false; broken = false; stones = 0; };
	nam = 'тележка';
	dsc = function(s)
		if s.broken then
			return "Здесь валяется перевернутая {тележка} с мороженым."
		end
		return [[ Здесь стоит {тележка} с мороженым. ]];
	end;
	inv = function(s)
		if s.stones ~= 0 then
			if s.stones > 1 then
				return "В тележке камни! И никакого мороженого...";
			end
			return "В тележке камень! И никакого мороженого...";
		end
		p [[Ой, да она пустая!!! Никакого мороженого.]];
	end;
	life = function(s)
		if here() ~= where(s) and not isDialog(here()) then
			if here().inside then
				p [[Я бросил тележку.]]
				lifeoff(s);
				inv():del(s);
				return true
			end
			if where(s) then
				if s.stones > 3 then
					p [[Я потащил тележку за собой. Из-за камней внутри она катилась тяжело.]]
				else
					p [[Я потащил тележку за собой. Она катилась довольно легко.]]
				end
				s.door1 = false
			end
			move(s, here(), where(s));
			return true
		end
	end;
	act = function(s)
		if s.broken then
			s.broken = false
			return "Я поставил тележку на колеса...";
		end
		if not have(s) then
			if s.skrip then
				make_snapshot(1)
			end
			lifeon(s);
			p [[Я ухватился за тележку.]]
			inv():add(s);
		else
			lifeoff(s)
			inv():del(s);
			if s.door1 then
				return [[Тележка стоит у двери.]]
			end
			p [[Я отпустил тележку.]]
		end
	end;
	use = function(s, w)
		if w == door1 or w == win1 then
			if s.door1 then
				return "Уже стоит...", false
			end
			inv():del(s);
			lifeoff(s);
			s.door1 = true
			p [[Я поставил тележку возле двери.]]
			return false
		end
		if w == door2 and not door2.broken then
			p [[Я разогнал тележку и ударил ей в дверь, как тараном. Но дверь
			выдержала. Маловато кинетической энергии...]];
			return false
		end
		if nameof(w) == 'дом' then
			p [[Я разогнал тележку и пустил ее под спуск,
			набирая скорость она помчалась к зданию.]]
			inv():del(s);
			lifeoff(s);
			move(s, build);
			if s.stones >=5 then
				door2.broken = true;
				s.broken = true;
				door2:disable_all();
				path("Внутрь здания",build):enable();
			elseif not door2.broken then
				door2.noenergy = true
			end
			return false
		end
		return "Это не поможет.", false
	end
}

storog = obj {
	var { sleep = false };
	nam = 'сторож';
	dsc = function(s)
		if s.sleep then
			return "Недалеко от будки лежит {сторож}."
		end
	end;
	act = function(s)
		if s.sleep then
			return "Спящий сторож!"
		end
		if timof.fountain and rifle.arm then
			return [[Если я просто встану и пойду к нему, или крикну,
				это сразу же нас раскроет.]]
		end
		p [[Стоит ли это делать?]]
	end;
}

vorota = obj {
	var { unlocked = false };
	nam = 'ворота';
	act = function(s)
		if s.unlocked then
			return "Ворота открыты!"
		end
		return "Ворота закрыты."
	end
}
entr = xroom {
	nam = 'У входа';
}
inside = xroom {
	nam = 'Площадь';
	pic = function(s)
		if timof.fountain then
			return 'gfx/night-inside2.png';
		end
		return 'gfx/night-inside.png';
	end;
	dsc = [[Небольшая площадь перед выходом из зоопарка освещена лучше.]];
	xdsc = [[Слева от {ворота:ворот} находится сторожевая {будка:будка}. 
			В центре площади расположен {фонтан:фонтан}.
			От площади расходятся две дороги. Около левой находится {карта:карта} зоопарка.]];
	obj = {
		vorota;
		teleg;
		storog;
		xact('будка', code [[
			if storog.sleep then 
				return "Будка открыта."; 
			end 
			p "Кажется, я могу разглядеть {сторож:сторожа}." 
			]]);
		xact('фонтан', 'Фонтан выключен на ночь.');
		xact('карта', 'Я ее уже видел.');
	};

	way = { vroom('Уйти из зоопарка', 'entr'), 
			vroom('Левая дорога', 'lroad'), 
			vroom('Правая дорога', 'rroad'),
			vroom('Будка', 'budka'):disable()
			};

	exit = function(s, to)
		if to == entr then
			p "Рано уходить. Или уже поздно. Диалектика."
			if not vorota.unlocked then
				p "К тому-же, ворота закрыты."
			end
			return false
		end
		if to == rroad then
			if not storog.sleep then
				p "Боюсь, проскочить мимо сторожа не удастся."
				return false
			end
		end
		if have 'teleg' and teleg.skrip then
			walk 'telegfail'
		end
		timof.fountain = false
	end
}

telegfail = room {
	pic = 'gfx/gora-cage.png';
	hideinv = true;
	forcedsc = true;
	enter = code [[ game.lifes:zap(); set_music 'mus/story.ogg' ]];
	nam = 'Конец';
	dsc = [[Я потащил тележку за собой и в следующий
		момент ржавые колеса издали пронзительный скрип.
		Сторож, конечно же не спал, и выбежал на звук.
		Так наш план провалился... Хотя,
		может быть все было {заново:по-другому}?]];
	obj = {
		xact('заново', code [[ restore_snapshot(1); ]]);
	}
}

key = obj {
	nam = 'ключ';
	inv = 'Большой ключ!';
	tak = 'Я взял ключ.';
	use = function(s, w)
		if w == vorota then
			if w.unlocked then
				return "Уже открыты!", false
			end
			w.unlocked = true
			return "Я попробовал вставить ключ в замок. Он подошел! Я повернул ключ и открыл ворота.", false
		end
		return "Не сработало."
	end
}

budka = xroom {
	inside = true;
	pic = 'gfx/budka.png';
	enter = code [[ timof:disable() ]];
	nam = "Сторожевая будка";
	exit = code [[ timof:enable() ]];
	dsc = [[Внутри сторожевой будки темно, но уютно.]];
	xdsc = [[Здесь находятся маленький {стол:столик}, {стул:стул} и небольшой
	{шкаф:шкаф}.]];
	obj = {
		xact("стул", "Я немного посидел на стуле, ощущая себя настоящим сторожем!");
		xact("стол", function ()
			if taken(key) then
				p [[На столе нет ничего интересного.]];
				return
			end
			return 'На столе я заметил {ключ:ключ}.';
		end);
		xact("шкаф", "Ничего интересного я не нашел.");
		key;
	};
	way = { vroom('Назад', 'inside') };
}

lake = xroom {
	nam = 'Озеро';
	pic = 'gfx/night-lake.png';
	dsc = [[Я подошел к водной глади.]];
	xdsc = [[Черная поверхность {озеро:озера} отражает тусклый свет {фонари:фонарей}. 
		Где-то там спит лебедь. С этой стороны озера берег выложен большими белыми {камни:камнями}.
		Дорога огибает озеро и ведет свой путь дальше. На другой стороне 
		дороги стоят небольшие {клетки:клетки} с животными.]];
	obj = {
		cages;
		lamps;
		xact('озеро', [[ Вода притягивает. Даже если не совсем чистая. ]]);
		xact('табличка', [[-- Мелкие млекопитающие! -- читаю я надпись на табличке.]]);
		obj {
			nam ='камни';
			act = code [[
				if have 'stone' then
					return 'Уже есть один.'
				end
				take 'stone'
				p 'Я взял обеими руками большой камень... Ух -- тяжелый!!!';
				inv():del 'teleg'
				lifeoff 'teleg'
			]]
		};
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

rroad = xroom {
	pic = 'gfx/night-rroad.png';
	nam = 'Дорога';
	dsc = 'Я вышел на неширокую прямую дорогу.';
	xdsc = [[Дорога довольно круто уходит вниз и упирается в {дом:здание}.]];
	way = {
		vroom('Наверх', 'inside'),
		vroom('Вниз', 'build'),
	};
	obj = {
		xact('дом', [[Белое здание с потрескавшейся отделкой утопает в тени деревьев.]]);
		lamps;
	}
}

door2 = obj {
	var { broken = false; noenergy = false};
	nam = "дверь";
	dsc = function(s)
		if s.broken then
			return [[Деревянная {дверь} выбита, ]]
		end
		return [[Деревянная {дверь} в стене закрыта, ]]
	end;
	act = function(s)
		if s.broken then
			return "Потенциальная энергия перешла в кинетическую...";
		end
		return "Надежные тут двери...";
	end;
	obj = {
		obj {
			nam = 'табличка';
			dsc = [[на двери висит красная {табличка}.]];
			act = 'А Д М И Н И С Т Р А Ц И Я -- читаю я на красной табличке.';
		}
	}
}

build = room {
	pic = 'gfx/night-build.png';
	nam = 'Здание';
	dsc = 'Я нахожусь возле небольшого белого здания.';
	entered = function(s, f)
		if f == rroad and door2.noenergy then
			door2.noenergy = false
			p [[Хм... Похоже, тележке не хватило кинетической энергии.]]
		end
	end;
	xdsc = [[ Несколько {окна:окон} забраны железными 
			{прутья:прутьями}.]];
	obj = {
		door2;
		xdsc();
		xact('прутья', 'На вид крепкие... Хотя и поржавели немного.');
		xact('окна', 'Если бы не прутья...');
	};
	way = {
		vroom('По дороге', 'rroad');
		vroom('Внутрь здания', 'bin'):disable();
	};
}

bin = xroom {
	inside = true;
	var { light = false, gotit = false };
	pic =  function(s)
		if s.light or flash.on then
			return 'gfx/inhouse.png';
		end
		return 'gfx/dark.png';
	end;
	nam = 'Внутри административного здания';
	dsc = function(s)
		if s.light then
			return [[Я стою посреди коридора, тускло освещенного
			светом люминисцентной лампы.]];
		end
		if flash.on then
			return [[Я стою посреди коридора, тускло освещенного
			светом фонарика.]];
		end
		return [[Я стою посреди темного коридора.]];
	end;
	xdsc = function(s)
		if s.light or flash.on then
			return [[На стене я вижу {выключатель:выключатель}.
			На другой стороне расположены две двери:
			деревянная {дверь1:дверь} и {дверь2:дверь} обитая красной кожей.]]
		end
		p [[Почти ничего не видно.]]
	end;
	obj = { xact('выключатель', function(s)
				bin.light = not bin.light
				if bin.light then
					return [[Я включил свет в корридоре.]]
				end
				p [[Я выключил свет.]]
			end),
			xact('дверь1', function(s)
					p [["Приемная", написано на двери. Дверь открыта!]]
					path 'Приемная':enable();
			end);
			obj {
				var {opened = false};
				nam = 'дверь2';
				act =  function(s)
					p [["Директор", написано на двери.]];
					if not s.opened then
						return "Дверь закрыта."
					end
					path 'Кабинет':enable();
					return "Путь свободен!"
				end
			};
		};
	way = { vroom('На улицу', 'build'), vroom('Приемная', 'priem'):disable(),
		vroom('Кабинет', 'cabinet'):disable()};
	exit = function(s, w)
		if drel.on and w ~= priem and have (drel) then
			return "Натянутый провод электродрели не дает мне уйти далеко.", false
		end
		if w == build and have 'keys' and seen('timof') and not s.gotit then
			p [[ -- Сынок! -- услышал я хриплый голос Тимофея --
			Иди открывай Горация, а я пойду подготовлю машину...^
			-- А как вы сделаете это без ключей??? ^-- Это не проблема, сынок,
			это не проблема... -- С этими словами Тимфоей быстро 
			скрылся в темноте.]]
			move(timof, entr2); 
			lifeoff 'timof'
			s.gotit = true
		end
	end
}

provod = obj {
	nam = 'провод';
	inv = [[Провод от подставки чайника. 2 метра. Концы оголены.]];
	use = rozetka.use;
}

udlin = obj {
	nam = 'удлинитель';
	inv = [[Удлинитель! 2-х метровый!]];
	dsc = [[К розетке подсоединен {удлинитель}.]];
	act = function(s)
		if drel.on then
			drel.on = false
			return [[Я отсоединил дрель от удлинителя.]]
		end
		return [[Я сделал его своими руками!]];
	end;
	use = function(s, w)
		if w == rozetka2 then
			if rozetka2.drel then
				return "Розетка занята.", false
			end
			inv():del(s);
			put(s, rozetka2);
			rozetka2.provod = true
			return [[Я подсоединил удлинитель к розетке.]], false
		end
	end
}

rozetka2 = obj {
	var { chainik = true; drel = false; provod = false; };
	nam = "розетка";
	act = function(s)
		if s.chainik then
			s.chainik = false
			return [[Я отключил чайник от розетки.]]
		end
		if s.drel then
			s.drel = false
			drel.on = false
			return [[Я отключил дрель от розетки.]]
		end
		if s.provod then
			return [[В розетку воткнут удлинитель.]]
		end
		return [[Розетка свободна.]]
	end
};
		
priem = xroom {
	inside = true;
	nam = 'Приемная';
	var { light = false };
	pic = function(s)
		if s.light or flash.on then
			return 'gfx/priem.png';
		end
		return 'gfx/dark.png'
	end;
	dsc = function(s)
		if s.light then
			return [[Приемная освещена.]];
		end
		if flash.on then
			return [[Я стою в приемной, тускло освещенной
			светом фонарика.]];
		end
		return [[Я стою в темной комнате.]];
	end;
	xdsc = function(s)
		if s.light or flash.on then
			return [[На стене я вижу {выключатель:выключатель}.
			В углу, рядом с {розетка:розеткой} расположена {тумбочка:тумбочка}, на которой
			стоит {чайник:чайник}. У стены стоит {диван:диван},
			напротив которого расположены {стол:стол} с 
			{кресло:креслом}.]]
		end
		p [[Почти ничего не видно.]]
	end;
	obj = {
		rozetka2;
		obj {
			var { opened = false; };
			nam = 'чайник';
			act = function(s)
				if s.opened then
					if not taken 'provod' then
						take 'provod'
						return [[Я забрал провод от подставки.
						Вдруг пригодится!]]
					end
					return "У чайника нет подставки!";
				end
				if not s.on and rozetka2.drel then
					return [[Розетка занята дрелью.]]
				end
				if rozetka2.chainik then
					return [[Чайник подключен к розетке.]]
				end
				rozetka2.chainik = true
				return [[Я воткнул чайник в розетку.]]
			end
		};
		xact('выключатель', function(s)
			priem.light = not priem.light
			if priem.light then
				return [[Я включил свет в комнате.]]
			end
			p [[Я выключил свет в комнате.]]
		end),
		xact('стол', [[Гм... Телефон, степплер, бумага... -- ничего
		полезного.]]);
		xact('кресло', [[Вращается!]]);
		xact('диван', [[Я прилег на большой диван. Как же хочется спать! Но Гораций ждет!]]);
		xact('тумбочка', [[Печенье!!! Я съел пару.]]);
	};
	way  = { vroom('Выйти', 'bin') };
	left = function(s)
		if rozetka2.drel then
			p [[Мне пришлось вытащить дрель из розетки.]]
			drel.on = false
			rozetka2.drel = false
			return
		end
		if drel.on then
			p [[Я вышел в корридор с дрелью в руках. Удлинитель натянулся.]];
			return
		end
	end
}

global { know_truth = false }

read_papers = xroom {
	nam = 'Зоопарк. 02:07';
	pic = 'gfx/timof.png';
	entered = code [[ timof:disable(); set_music 'mus/shadows.it' ]];
	forcedsc = true;
	hideinv = true;
	dsc = [[
		Я отошел от сейфа. Сердце мое учащенно билось.^
		-- Что, сынок, получилось? -- Тимофей весело посмотрел на меня.
		Я протянул ему бумаги и ключи.^
		-- Ключи оставь себе, а это сейчас посмотрим... Гммм... Вот
		ветеринарные свидетельства... Так, вот оно... Счета... Счета...
		Переводы денег в зоопарк... 
		Интересно... Ну-ка сынок, посмотрим повнимательнее, что мы нашли... --
		С этими словами Тимофей уселся в кресло и начал внимательно изучать
		бумаги...
	]];
	obj = { vway('дальше', '{Дальше}', 'read_papers2')};
}
compromat = obj {
	nam = 'компромат';
	inv = [[Тимофей подготовил несколько писем. Некоторые
	из них адресованы "конкурентам" директора зоопарка. Я думаю,
	это может сработать!]];
	use = function(s, w)
		if nameof(w) == 'ящик' then
			p [[Я бросил письма в почтовый ящик. Мы сделали все, что могли.]]
			inv():del(s)
			return
		end
		return 'Компромат на директора зоопарка тут не поможет.'
	end
}
read_papers2 = xroom {
	nam = 'Зоопарк. 02:21';
	pic = 'gfx/timof.png';
	forcedsc = true;
	hideinv = true;
	dsc = [[
		... Тимофей, послюнявив липкую полоску,  заклеил последний конверт...^
		-- Так директор зоопарка депутат?^
		-- Пока нет, сынок, пока нет. Он баллотируется в депутаты.
		Это значит, хочет им стать. И может.^
		-- Тогда зачем ему зоопарк?^
		-- До чего смог дотянуться, то и получил, сынок. 
		Этого директора не так давно
		назначили, сынок... Я уже тут жил с Барсиком. Он сразу уволил 
		старых сотрудников, и нанял своих... Такие
		дела, сынок... Такие дела...^
		-- И он тратит деньги для зоопарка на себя?^ 
		-- Точно сынок, на себя. И на то, чтобы стать депутатом.^
		-- Тимофей, но почему? Почему все так?^
		-- Мир сломан, сынок. Он сломан. Но пока мы знаем,
		что он сломан, не все потеряно... Не все потеряно, сынок...^
		-- А директор знает, что он сломан?^
		-- Он его ломает дальше, сынок, ему все-равно...^
		-- Как это странно...^
		-- Не забивай себе голову, сынок. Главное, теперь у нас есть
		компромат, и мы можем помешать ему, такие дела, сынок, такие дела...
		И не забывай, нас ждет Гораций...
	]];
	left = code [[ timof:enable(); inv():del 'papers'; inv():add 'compromat' ]];
	obj = { vway('дальше', '{Дальше}', 'cabinet')};
}

cabinet = xroom {
	inside = true;
	var { light = false };
	pic = function(s)
		if s.light or flash.on then
			return 'gfx/cabinet.png';
		end
		return 'gfx/dark.png'
	end;
	nam = 'В кабинете';
	dsc = [[ Я нахожусь в кабинете директора зоопарка.]];
	enter = function(s, w)
		if w == safe and have 'keys' and not know_truth then
			know_truth = true
			walk 'read_papers';
		end
	end;
	xdsc = function(s)
		if s.light or flash.on then
			return [[На стене у двери я вижу {выключатель:выключатель}.
			В центре комнаты, за {стол:столом}, установлено массивное
			красное {кресло:кресло}. Справа от кресла на стене висит
			{календарь:календарь}. В стене я вижу металлическую
			дверь {сейф:сейфа}.
			]]
		end
		p [[Темно, почти ничего не видно.]]
	end;	
	obj = {
		xact('стол', [[На столе я увидел пепельницу. Я поднял ее и прочитал надпись: "С юбилеем,
			от преданных сотрудников!!! 13 февраля 2010 года." Гм... Я поставил пепельницу обратно.]]);
		xact('календарь', [[Сегодня 19 мая. Или это вчера?]]);
		xact('кресло', "Наверное, директор очень толстый.");
		xact('сейф', code [[walk 'safe']]);
		xact('выключатель', function(s)
			cabinet.light = not cabinet.light
			if cabinet.light then
				return [[Я включил свет в кабинете.]]
			end
			p [[Я выключил свет в кабинете.]]
		end),
	};
	way = { vroom('Выйти', 'bin')};
}

function val(n)
	local v = {}
	v.nam = n
	v._state = rnd(10) - 1;
	v.dsc = function(s)
		if safe.light or flash.on then
			p("{",v._state,"}");
		else
			p("{?}");
		end
	end
	v.act = function(s)
		s._state = s._state + 1
		if s._state == 10 then
			s._state = 0;
		end
		return "Я перевел ручку в следующее положение."
	end
	return obj(v)
end

papers = obj {
	nam = 'бумаги';
	inv = [[Я в них никогда не разберусь.]];
}

global { gora_open = false }

keys = obj {
	nam = 'ключи';
	inv = [[Большая связка ключей!]];
	use = function(s, w)
		if w == cages then
			if here() ~= endz then
				return [[Я бы хотел выпустить зверей, но на следующий день их всех поймают,
					а если не поймают, они могут погибнуть в городе...
					Лучше делать то, что я могу... Пойду к Горацию...]];
			end
			if tigr.seen then
				if gora_open then
					return "Клетка Горация открыта.", false
				end
				inv():del 'keys'
				gora_open = true
				return "Я открыл клетку Горация. Ключи я оставил в замке.", false
			end
			walk 'incage'
			return
		end
		return [[Это ключи от клеток.]]
	end
}

insafe = obj {
	nam = 'в сейфе';
	dsc = function(s)
		if safe.light or flash.on then
			p 'В открытом сейфе я вижу {ключи} и {бумаги}.'
		end
	end;
	act = function(s)
		s:disable();
		take 'keys'
		take 'papers'
		p [[Я поскорее забрал содержимое сейфа.]];
	end
}:disable();

safe = xroom {
	var { opened = false; light = false; };
	nam = 'У сейфа';
	inside = true;
	pic = function(s)
		if s.light or flash.on then
			if s.opened then
				return 'gfx/safe-open.png';
			end
			return 'gfx/safe.png';
		end
		return 'gfx/dark.png'
	end;
	dsc = "Сейф внушает ощущение надежности.";
	xdsc = function(s)
		p 'Я стою у металлической {дверь:дверцы} сейфа. На дверце восемь ручек с цифрами:';
	end;
	entered = code [[ self.light = arg1.light; timof:disable(); ]];
	left = code [[timof:enable(); ]];
	obj = {
		val('1'); val('2'); val('3'); val('4');
		val('5'); val('6'); val('7'); val('8');
		xact('дверь', function(s)
			if safe.opened == true then
				return "Сейф открыт!";
			end
			if objs()[1]._state == 1 and
				objs()[2]._state == 3 and
				objs()[3]._state == 0 and
				objs()[4]._state == 2 and
				objs()[5]._state == 1 and
				objs()[6]._state == 9 and
				objs()[7]._state == 7 and
				objs()[8]._state == 0 then
				safe.opened = true
				insafe:enable();
				return "Я потянул ручку сейфа на себя и дверь открылась!";
			end
			return "Не открывается.";
		end);
		insafe;
	};
	way = { vroom('Назад', 'cabinet')};
}

lake2 = xroom {
	nam = 'Озеро';
	pic = 'gfx/night-lake2.png';
	entered = function(s)
		if from() == lake then
			p [[Пройдя по извивающейся дороге, я обогнул озеро.]];
		else
			p [[Я подошел к месту, где дорога поворачивает налево.]];
		end
	end;
	dsc = [[На этой стороне озера растут тополя.]];
	xdsc = [[Здесь находятся {клетки:клетки} животных побольше. Свет {фонари:фонарей} 
		порождает причудливые тени.]];
	obj = {
		cages;
		lamps;
	};
	way = { 
		vroom('Обойти озеро', 'lake'),
		vroom('Дальше', 'lake3'),
	}
}

lake3 = xroom {
	nam = 'Восточная часть зоопарка';
	pic = 'gfx/night-lake3.png';
	dsc = [[Здесь дорога довольно далеко отходит от озера.]];
	xdsc = [[Недалеко в траву вбита {табличка:табличка}. Множество больших
		{клетки:клеток} расположены по обеим сторонам дороги. И еще я вижу
		громадный {аквариум:аквариум}. Фонари здесь не работают.]];
	obj = {
		cages;
		xact('табличка', [[-- Зебры, кенгуру, жирафы, верблюды -- читаю я на табличке.]]);
		xact('аквариум', [[Интересно, спят ли рыбы сейчас...]]);
	};
	way = {
		vroom('К повороту', 'lake2');
		vroom('Дальше', 'endz');
	};
};

endz = xroom {
	nam = 'Конец зоопарка';
	pic = function(s)
		if seen 'машина' then
			return 'gfx/night-endz2.png';
		end
		return 'gfx/night-endz.png';
	end;
	enter = function(s, f)
		if f ~= outcage then
			p [[Я прошел по дороге еще немного, и наконец дошел до конца зоопарка.]];
		end
	end;
	dsc = [[Я стою у конца дороги, которая проходит через весь зоопарк.]];
	xdsc = [[Здесь я вижу очертания больших {клетки:клеток}. Возле дороги стоит {скамейка:скамейка}.
		Темно... Фонари здесь не работают.]];
	obj = {
		xact('скамейка', [[Надо освободить Горация!]]);
		cages;
	};
	way = {
		vroom('Назад', 'lake3');
	};
};

cat = obj {
	nam = 'кот';
	dsc = [[По клетке носится {кот}.]];
	act = [[Барсик!!! Это Барсик!!!]];
}

car = obj {
	nam = 'машина';
	dsc = [[ Здесь стоит грузовая {машина}. Я слышу рокот работающего мотора. ]];
	act = [[ Я вижу разбитое окно в двери. Интересно, как ее завел Тимофей? ]];
}

tigr = obj {
	var { seen = false, time = 0 };
	nam = function(s)
		if s.seen then
			return "тигр"
		end
		return "зверь";
	end;
	life = function(s)
		s.time = s.time + 1
		if s.time == 2 then
			return 'Темно... Я слышу какие-то звуки...'
		elseif s.time == 3 then
			return 'Глаза привыкают к темноте... Неясные шорохи наполнили клетку...'
		elseif s.time == 4 then
			s.seen = true
			set_sound 'snd/tiger.ogg'
			return 'Кажется, я различаю... Я слышу рычание!!!.', true
		elseif s.time == 5 then
			return "Я слышу громкий рык...", true
		elseif s.time == 6 then
			return "Один из тигров направляется ко мне!!!", true
		elseif s.time == 7 then
			lifeoff 'dogs'
			return "Кажется, он готовится к прыжку!!! Я слышу лай собак.", true
		elseif s.time == 8 then
			put 'cat'
			return "Тигр скалит свои зубы!!! Лай собак усиливается... В клетку влетела темная тень.", true
		elseif s.time == 9 then
			return "Тигр удивленно смотрит на Барсика!!! Лай собак приближается...", true
		elseif s.time == 10 then
			remove 'cat'
			return [[Тигр бросается на Барсика, кот немедленно выскакивает из клетки сквозь
			прутья решетки. Второй тигр смотрит на меня. Все заглушает лай собак...]], true
		elseif s.time == 11 then
			walkin 'outcage'
		end
	end;
	act = function(s)
		if s.seen then
			return "Это тигр!!! Тигры!!! Что делать???"
		end
		if s.time == 0 then
			return "Я позвал Горация и сделал шаг в его сторону."
		elseif s.time == 1 then
			return "Наверное, он спит..."
		elseif s.time == 2 then
			return "Странные звуки..."
		elseif s.time == 3 then
			return "Я что, ошибся клеткой??"
		else
			s.seen = true
			return "Это же тигр!!!"
		end
	end;
	dsc = function(s)
		if s.seen then
			return "Я в клетке с двумя {тиграми}."
		end
		return "Кажется, я различаю {очертания} Горация."
	end;
}

outcage = xroom {
	nam = 'Зоопарк. 02:39';
	pic = 'gfx/timof.png';
	enter = function(s)
		p [[Вдруг я слышу хлопок!!! Второй тигр вздрагивает всем телом и в туже 
			секунду, чьи то крепкие руки вытаскивают меня из клетки... Я слышу "Щелк!"...
			Лай собак утихает...]];
		set_music 'mus/ckjourney.it';
	end;
	left = function(s)
		lifeon 'timof'
		lifeon 'dogs'
		put ('car', endz)
	end;
	hideinv = true;
	dsc = [[Меня бьет озноб. Тимофей что-то говорит, его теплые руки обнимают меня... 
		Я пытаюсь сосредоточиться.^
		-- Не надо было тебя оставлять, братишка, не надо было... Ничего,
		все позади, сынок, все позади... Мы стояли так в темноте, и постепенно я 
		приходил в себя... Наконец, Тимофей разжал руки и поднял с земли 
		брошеное ружье...]];
	obj = { vway('дальше', '{Дальше}', endz) }
}

incage = xroom {
	nam = 'В клетке';
	inside = true;
	pic = function(s)
		if tigr.time <= 3 then
			return 'gfx/dark.png';
		end
		return 'gfx/tigers.png';
	end;
	enter = function(s)
		p [[Непослушными руками я подбирал ключ к клетке горация.
		Время тянулось мучительно долго... Сколько же их тут, этих ключей!??
		Вдруг я услышал: "Клац!!!". Есть! Дверь открыта!!! Я вошел внутрь... Ключи остались в замке.]];
		inv():del 'keys'
	end;
	entered = code [[ lifeon 'tigr' ]];
	dsc = [[ Я нахожусь в клетке, за моей спиной находится выход наружу. ]];
	obj = { tigr };
	exit = function(s, w)
		if tigr.time < 3 then
			return "Я пришел за Горацием!", false
		end
		return "Я медленно пячусь в выходу из клетки...", false
	end;
	way = {
		vroom('Выйти', endz);
	}
}

ep2end = xroom {
	hideinv = true;
	inside = true;
	forcedsc = true;
	nam = 'Зоопарк 02:42';
	pic = 'gfx/gora.png';
	dsc = function(s)
		p [[Я открыл клетку Горация. Слон, казалось, меня ждал. Он не спал и сразу вышел
		за мной, когда я открыл двери его вольера. Мы подошли к Тимофею, он посмотрел на нас
		и улыбнулся. Он подошел к машине сзади и распахнул двери. Внутри лежало сено и бананы.
		Деревянный, но прочный помост, который тоже находился в фуре, позволил нам завести слона внутрь...^
		-- Ну что, сынок, готов???^
		-- А как же Барсик?^
		-- ???^
		-- Мы поедем без него?.^
		-- Нет, сынок, конечно нет...^
		Мы залезли в машину через разбитое окно и Тимофей сел за руль. Когда мы проезжали
		мимо озера в окно влетел Барсик, и мы поехали дальше, слушая лай собак снаружи.^]]
		if not vorota.unlocked then
			if exist('key', me()) then
				p [[Подъехав к воротам, мне пришлось вылезти из машины и открыть их ключем.^]]
			else
				p [[Подъехав к воротам, мне пришлось вылезти из машины, сбегать
				в будку сторожа за ключем, чтобы их открыть.^]]
			end
		end
		p [[И вот, ворота зоопарка позади. Я глядел в зеркало заднего обзора и мои глаза
		слипались под ровный гул мотора...]]
	end;
	xdsc = "{дальше:Дальше}";
	obj = { xact('дальше', code [[ game.lifes:zap(); purge(timof, me()); gamefile('part3.lua'); walk 'part3' ]]) };
}

-- vim:ts=4
