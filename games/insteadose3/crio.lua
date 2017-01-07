--$Name:Отсек K007$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "hideinv"

R = room
O = obj
rem = remove
mf = math.floor
sf = string.format

_alert = false

require "xact"
require "nouse"

main = timerpause(1100, 999, "main2");

main2 = R {
	nam = '...';
  title = { "О", "Т", "С", "Е", "К", " ", "0", "0", "7" };
  num = 4;
	forcedsc = true;
	hideinv = true;
  enter = function() music_("pumped",0)();take 'sh' end;
	dsc = [[Я WR017 и моя вахта уже подходит к концу.
	Сейчас я заканчиваю уборку в крио-отсеке К007 и 
	у меня еще останется время, чтобы спокойно добраться
	до своего отсека и уйти в гибернацию...^^
	{xwalk(r7)|Дальше}]];
}

rat = O {
	nam = 'крыса';
	dsc = "Я вижу как жирная {крыса} грызет оплетку кабеля у одной из капсул.";
	act = "Эти твари размножаются с огромной скоростью. Им уже тесно на нижних палубах."
}

port2 = O {
	nam = function(s)
		if s._conn then
			pr "*"
		end
		pr 'порт XG232';
	end;
	inv = [[Это отладочный порт.]];
	use = function(s, w)
		if w == port then
			if s._conn and port3._conn then
				p "Я подсоединил кабель к отладочному порту."
				_debug = true
				put(wire, port);
				rem(s, me())
				rem(port3, me())
			else
				p "Это не сработает. Мне нужно как-то подключиться к порту."
			end
		end
	end;
	nouse = "Отладочный порт тут не поможет."
}

port3 = O {
	nam = function(s)
		if s._conn then
			pr "*"
		end
		pr 'порт US19';
	end;
	inv = "Это эксплуатационный порт.";
	nouse = "Этот порт не поможет."
}

wire = O {
	nam = 'кабель';
	inv = "Коммуникационный кабель.";
	dsc = "К порту подключен {кабель}.";
	act = function(s)
		if _mem[0x78] ~= 0xff then
			walkin 'hack'
		else
			p [[Я выбросил провод, чтобы у них не было лишних вопросов.]]
			rem(s)
		end
	end;
	use = function(s, w)
		if w == port2 or w == port3 then
			p "Я подсоединил провод к порту."
			w._conn = true
		end
	end;
	nouse = "Провод тут не поможет.";
}

lcd = O {
	nam = 'индикатор';
	inv = "Индикатор больше ничего не показывает.";
	nouse = "Индикатор не может осуществлять индикацию.";
}

sh2 = O {
	nam = 'щетка';
	inv = [[Теперь это устройство для уборки лишено своих интеллектуальных функций.]];
	use = function(s, w)
		return sh:use(w)
	end
}

trash = O {
	nam = 'мусор';
	dsc = [[На полу валяются {запчасти} от швабры.]];
	act = function(s)
		rem(s)
		take 'port2'
		take 'port3'
		take 'wire'
		take 'lcd'
		take 'sh2'
		p [[Я забрал то, что осталось целым.]]
	end
}

blast = O {
	nam = 'бластер';
	inv = [[Хе-хе...]];
	_s = false;
	use = function(s, w)
		if _alert then
			if w == sh and _port and not taken(port2) then
				sound_("shoot_lazer")();
				p [[Я разнес швабру бластером!!!]]
				rem(sh, me())
				put(trash)
				return
			end
			return "Я уже наигрался с бластером!!!"
		end
		if w == rat then
			if not s._s then
				sound_("shoot_lazer")();
				s._s = true
				p [[Я прицелился и выстрелил в эту гадину.]]
				p [[^^Проклятые манипуляторы!
				Конечно, я промазал!!! Вернее, я попал,
				но не в крысу, а в блок управления криосном...^^
				Я понял это по мерцанию индикатора.]]
			else
				if comp._s == 13 then
					return "Сначала надо понять что я наделал!!!"
				end
				walk 'p2'
			end
		else
		end
	end;
	nouse = [[Не стоит зря размахивать оружием.]];
}

shl1 = O {
	nam = 'шкафчики';
	dsc = [[У стен, рядом с каждой капсулой расположены {шкафчики}.]];
	act = function(s)
		if s._br then
			p "Один из шкафчиков открыт... гм... Вернее, он разломан."
			if not taken 'blast' then
				p [[Я обнаружил там какую-то одежду и бластер!!!]]
				take 'blast'
			end
		end
		if seen(rat) then
			p [[Шкафчики закрыты.]]
		else
			p [[Наверное, это личные шкафчики обитателей криокапсул.]];
		end
	end
}

cap = O {
	nam = 'капсулы';
	dsc = [[В этом крио-отсеке установлены 6 {капсул}.]];
	act = [[Не имею никакого понятия, кто там внутри.]];
}
port = O {
	nam = 'порт';
	dsc = [[В блоке управления есть отладочный {порт}.]];
	act = function(s)
		if _debug then
			p [[Вообще-то у меня другая специализация...]]
			return
		end
		p [[Тут нужен разъем, которого у меня нет!!!]]
		_port = true;
	end;
	obj = { };
}:disable()

comp = O {
	nam = 'комп';
	dsc = [[В середине комнаты расположен {блок} управления криосном.]];
	_s = 13;
	act = function(s)
		if _alert then
			p [[Я бросился к блоку управления. Он выглядел не важно,
			но я все-таки обнаружил порт отладки.]]
			port:enable()
			return
		end
		if _mem[0x78] == 0xff then
			p [[Я прочитал надпись на индикаторе:^^
				Все системы в норме.]]
			return
		end
		if blast._s then
			p [[Не без содрогания я прочитал надпись на индикаторе:^^
				Нарушена контрольная сумма.^
				Осуществляется переход на резервную копию: ]]
			p (s._s, '%')
			s._s = s._s + 5
			if s._s >= 100 then
				s._s = 99
			end
			p [[^Фух... Кажется, на этот раз пронесло.]]
			return
		end
		p [[Это лучше не трогать.]]
	end;
	obj = { port };
}

fl = O {
	nam = 'пол';
	_pena = false;
	dsc = function(s)
		if s._pena then
			p [[{Пол} залит пеной.]];
		else
			p [[{Пол} здесь уже почти идеально чист.]];
		end
	end;
	act = function(s)
		if _alert then
			return "Нет времени пялиться на пол!"
		end
		if s._pena then
			return "Предстоит много работы..."
		end
		p [[Моя работа почти завершена.]]
	end;
}

sh = O {
	nam = 'швабра';
	inv = function(s)
		p "Этой электро-швабре лет 500, но она отлично работает.";
		if _port then
			p [[Электро-швабра интеллектуальное устройство,
			может быть в ней есть отладочный порт?]];
		end
		return
	end;
	_s = 1;
	use = function(s, w)
		if _alert then
			return "Нет времени заниматься уборкой!"
		end
		if w == fl then
			if w._pena then
				p [[Я очищаю пену с пола.]]
				w._pena = w._pena - 1
				if w._pena == 0 then
					p [[Все... Пол чист.]]
					w._pena = false
				end
				return
			end
			s._s = s._s + 1
			p [[Я еще немного почистил пол.]]
			if s._s == 5 then
				putf(rat);
				p [[^^Внезапно, мои звуковые рецепторы задетектировали какой-то шум. Я обернулся. Это была она! Жирная тварь как-то проникла в жизненно важный отсек и грызла проводку!!!]]
			end
		elseif w == rat then
			p [[Проклятая тварь не боится меня. Она просто отпрыгнула от швабры, но потом принялась за свое.]]
		elseif w == shl1 then
			if seen 'rat' then
				p [[Я не смог открыть шкафчик шваброй.]]
			else
				p [[Я почистил плинтуса у шкафчиков.]]
			end
		elseif w == cap then
			p [[Я почистил капсулы.]]
		end
	end;
	nouse = [[Шваброй?]];
}

flame = O {
	nam = 'огнетушитель';
	inv = "Я еле держу его своими манипуляторами.";
	use = function(s, w)
		if _alert then
			return "Ситуация вышла из под контроля!"
		end
		if w == rat then
			if not fl._pena then fl._pena = 0 end
			fl._pena = fl._pena + 5
			p [[Мои манипуляторы не привыкли управляться огнетушителем,
				поэтому я запенил большую часть отсека, но проклятая
				крыса это проигнорировала.]];
		elseif w == shl1 then
			if not shl1._br then
				p [[Сам не зная, что я делаю. Я принялся разрушать один из шкафчиков.]]
				shl1._br = true
				p [[Это оказалось не просто, но у меня получилось.]]
			else
				p [[Хватит разрушений. Кому-то придется отвечать за это... потом.]]
			end
		end
	end;
	nouse = 'Лучше быть осторожней с этим огнетушителем.';
}

slf = O {
	nam = 'шкаф';
	dsc = [[У стены установлен {шкафчик} красного цвета.]];
	act = function(s)
		if not taken 'flame' then
			p [[Шкафчик не был закрыт, и в нем оказался огнетушитель.]];
			take 'flame'
		else
			p [[Шкафчик пуст.]]
		end
	end
}

ex = R {
	nam = 'Лифт';
	enter = function(s)
		if _mem[0x78] == 0xff then
			walk 'theend'
			return
		end
		p [[Мне рано уходить.]]
		return false
	end;
}

out = R {
	nam = 'Криоблок';
  pxa = {
    { "door4", 50 },
    { "box3", 380 }
  },
	dsc = [[Я в коридоре криоблока корабля.]];
	obj = { slf },
	way = { 'r7', 'ex' };
}

r7 = R {
	exit = function(s)
		if _alert then
			p [[Бежать! Сначала в шлюз, потом в спасательную капсулу!!!^^
			Нет... Это не поможет. Они уничтожат меня! Что же делать! Что же делать!]];
			return false
		end
		if seen(rat) then
			return
		end
		if fl._pena or sh._s < 5 then
			p [[Пол пока не достаточно чист.]]
			return false
		end
	end;
	nam = 'К007';
  pxa = {
    { "door4", 10 },
    { if_("not blast._s","panel","panel_broken"), 220 },
    { if_("exist(rat)","rat"), 180 },
    { "crio", 300 }
  };
	dsc = [[В крио-отсеке.]];
	obj = { cap, shl1, comp, fl };
	way = { out };
}

p2 = room {
	nam = '...';
	_s = 1;
	forcedsc = true;
	hideinv = true;
  pxa = {
    { if_("p2._s<5", "rat"), 220 }
  };
	dscs = { 
	    "Ну, уж на этот раз я не промахнусь!",
	    "...",
	    "После того, как луч бластера выбил сноп искр из блока управления криосном, cвет в отсеке погас.",
	    "Несколько секунд было тихо, а затем послышался противный пульсирующий звук и свет наконец снова зажегся.",
	    "Крыса куда-то делась... Но мне было уже не до нее!!!",
	    "Внимание! Послышался женский голос. Целостность программы нарушена!!! Аварийный выход из гибернации через 60 секунд!!!",
	    "Что я наделал?",
	};
	dsc = function(s)
		p (s.dscs[s._s])
	end;
	exit = function(s)
		_alert = true
		rem(rat, r7)
	end;
	obj = { O {
		nam = '';
		dsc = "{Дальше}";
		act = function(s)
			here()._s = here()._s + 1
      if here()._s == 2 then
        sound_("shoot_lazer")();
      end
			if here()._s == 8 then
				back();
			end
			return true
		end;
	}};
}

hack = R {
	hideinv = true;
  pxa = { { "panel", 215 } };
	entered = function(s)
		s._flt = stead.mouse_filter(0)
	end;
	left = function(s)
		stead.mouse_filter(s._flt)
		if _mem[0x78] ~= 0xff then
			p [[Я отсоединился от порта. Я никогда не разберусь в этом!]]
		else
			_alert = false
			p [[Я отсоединился от порта. Мои манипуляторы дрожали.
			Женский голос произнес:^^
			Целостность восстановлена!^
			Раздражающий звук затих.]]
		end
	end;
	nam = 'Отладка';
	_s = 1;
	forcedsc = true;
	dsc = function(s)
		if s._s == 1 then
			p [[HX-OS 14.1^^DEBUG INTERFACE^^]];
			if _mem[0x78] ~= 0xff then
				p [[CRC FAILED]]
			else
				p [[CRC PASSED]]
			end
		elseif s._s == 2 then
			local t = txttab("20%", "left")
			local tt = txttab("50%", "left")
			pn ("1200"..t.."dd cd 01 2f"..tt.."INP R01,P07")
			pn ("1204"..t.."2b 98 01 78"..tt.."CMP R01,addr:78")
			pn ("1208"..t.."34 d0 12 14"..tt.."JN 1214")
			pn ("120C"..t.."34 22 90 90"..tt.."WAIT")
			pn ("1210"..t.."2b ee 12 00"..tt.."JUMP 1200")
			pn ("1214"..t.."98 32 6b 82"..tt.."P 'CR'")
			pn ("1218"..t.."98 32 6b 20"..tt.."P 'C '")
			pn ("121C"..t.."98 32 46 41"..tt.."P 'FA'")
			pn ("1220"..t.."98 32 49 4c"..tt.."P 'IL'")
			pn ("1224"..t.."98 32 45 44"..tt.."P 'ED'")
			pn ("1228"..t.."98 32 12 00"..tt.."JUMP 1200")
		elseif s._s == 3 then
			local i
			for i = 0,15 do
				local r = rnd(255)
				if i == 7 then
					r = 255
				end
				pn (sf("P%02x: %02x", i, r))
			end
		elseif s._s == 4 then
			pr "Addr: <u>"
			pr ("{a0|", sf(" %x", a0._s), "}")
			pr ("{a1|", sf("%x</u> ", a1._s), "}")
			pr " Data: [<u>"
			pr ("{a2|", sf(" %x", a2._s), "}")
			pr ("{a3|", sf("%x</u> ", a3._s), "}")
			pr "]"
		end

	end;
	obj = {
		O {
			nam = '';
			dsc = function(s)
				if _stop then
					p "{Продолжить выполнение}"
					return
				end
				p [[{Контрольная точка}]];
			end;
			act = function(s)
				if _stop then
					p [[Я запустил программу.]]
					here()._s = 1
				else
					p [[Я остановил программу.
					Кажется, это цикл проверки контрольной суммы...]]
					here()._s = 2
				end
				_stop = not _stop
			end;
		},
		O {
			nam = '';
			dsc = "^{Регистры ввода-вывода}";
			act = function(s)
				p [[Я вывел дамп регистров ввода-вывода.]]
				here()._s = 3
			end;
		},
		O {
			nam = '';
			dsc = "^{Память}";
			act = function(s)
				if not _stop then
					p [[Опасно менять данные памяти во время работы кода.]]
					return
				end
				p [[Я запустил редактор памяти.]]
				here()._s = 4
			end;
		};
		O {
			nam = '';
			dsc = [[^{Выход}]];
			act = code [[ back() ]];
		};
		obj = {'a0', 'a1'}
	}
}
_mem = { }

function init()
	local i
	for i=0,255 do
		local r = (12751%(i+1))%256;
		_mem[i] = r
	end
end

inp = function()
	local o = xact('', function(s)
			s._s = s._s + 1
			if s._s > 15 then
				s._s = 0
			end
			local a = a0._s * 16 + a1._s
			if s.t then
				local v = _mem[a]
				a2._s = mf(v/16)
				a3._s = mf(v%16)
			else
				local v = a2._s * 16 + a3._s
				_mem[a] = v
			end
			return true
		end)
	o._s = 0
	return o
end

a0 = inp()
a0.t = true
a1 = inp()
a1.t = true

a2 = inp()
a3 = inp()

function start()
	if here() == hack then
		stead.mouse_filter(0)
	end
end
theend = R {
	nam = '...';
	hideinv = true;
  enter = function() mute_()(); complete_("crio")(); end;
	dsc = function(s)
		p [[Я без приключений добрался до своего отсека и закрыл за собой дверь.	^
		Все закончилось не так уж и плохо!]]
		p [[Я был уверен, что правильно починил блок управления, хотя
		это был мой первый опыт проникновения...]]
		if seen(wire, r7) then
			p [[^^Перед тем как отключиться, я вдруг вспомнил, что
				оставил кабель в отладочном порту блока управления....]];
		end
		p [[В любом случае это были уже не мои проблемы...]]
	end;
  act = gamefile_("watch.lua");
  obj = { vobj("next", txtc("^{КОНЕЦ?}")) }
}
