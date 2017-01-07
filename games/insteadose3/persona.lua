-- $Name: Личность$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "xact"
global {
	rat_i = 0;
	onedsc = 5;
	twodsc = 8;
	threedsc = 2;
	fourdsc = 6;
}
_patterns = {};

game.use = "Вариантов успешного завершения инструкций 0... Отмена действия."

main = room {
   nam = "..."
  ,enter = music_("castle")
  ,title = {"Л", "И", "Ч", "Н", "О", "С", "Т", "Ь" }
  ,num = 14
  ,act = function() walk(main2) end
  ,obj = { vobj("next", '{Начать игру}') }
}

main2 = room {
	forcedsc = true;
  pxa = {
    { "door4", 10 },
    { "panel", 150 },
    { if_("exist(programmator_mozgov)","program","program_empty"), 240, 50 },
    { "crio", 300 }
  },
	nam = "Выход",
	dsc = "Отсек криосна. Мне необходимо разобраться с одним из членов экипажа. Кажется у него какие-то проблемы с сознанием.",
	obj = {"chest", "criocaps","programmator_mozgov"},
}

chest = obj {
	nam = "chest",
	dsc = "На стене {ящик} с кодовым замком.",
	act = function (s) 
		walk("coderoom") 		
	end,
}

criocaps = obj {
	nam = "criocaps",
	dsc = "Рядом стоит {криокапсула}. Она светится синим светом изнутри.",
	act = "Судя по надписи - внутри инженер Александр. Тот кто нужен."
}

programmator_mozgov = obj {
	nam = function(s)
		if rat_i == 0 then
			p"Программатор личности"
		else 
			p"Программатор личности (с копией крысиной личности)"
			end
	end,
	dsc = "На стене под стеклом висит {программатор личности}.",
	act = function(s)
		p"Забираю программатор себе.";
		take(programmator_mozgov,me());
		remove(programmator_mozgov);
	end,
	use = function(s,w)
		if (w == criocaps) and (rat_i == 0) then
			walk(podsoznanie_room)
		elseif (w == criocaps) and (rat_i == 1) then
			walk(criocaps_final)
			p"Восстановление личности из резервной копии завершено.^Психологических проблем не обнаружено.^Спасибо за работу.^";
		elseif w == rat_in_chestroom then
			p"Сунув программатор в крысиную дыру удалось скопировать личность крысы.";
			rat_i = 1;
		end 
	end 
}

coderoom = room {
	nam = "Кодовый замок",
	entered = function(s)
		s._flt = stead.mouse_filter(0)
	end;
	left = function(s)
		stead.mouse_filter(s._flt)
	end;
	dsc = "Это ящик Александра",
	way = {"main2"},
	obj = {"one","two","three","four", "openbox"},
}

one = obj {
	nam = "one",
	dsc = function (s)
		return "{" .. tostring(onedsc).."}"
	end,
	act = function (s)
		onedsc = onedsc + 1;
		if onedsc == 10 then
			onedsc = 0;
		end;
		stead.need_scene()
		return true
	end
}

two = obj {
	nam = "two",
	dsc = function (s)
		return "{" .. tostring(twodsc) .. "}"
	end,
	act = function (s)
		twodsc = twodsc + 1;
		if twodsc == 10 then
			twodsc = 0;
		end;
		stead.need_scene()
		return true
	end
}

three = obj {
	nam = "three",
	dsc = function (s)
		return "{" .. tostring(threedsc) .. "}"
	end,
	act = function (s)
		threedsc = threedsc + 1;
		if threedsc == 10 then
			threedsc = 0;
		end;
		stead.need_scene()
		return true
	end
}

four = obj {
	nam = "four",
	dsc = function (s)
		return "{" .. tostring(fourdsc) .. "}"
	end,
	act = function (s)
		fourdsc = fourdsc + 1;
		if fourdsc == 10 then
			fourdsc = 0;
		end;
		stead.need_scene()
		return true
	end
}

openbox = obj {
	nam = "openbox",
	dsc = "^^{Открыть}",
	act = function (s) 
		if ((onedsc == 1) and (twodsc == 2) and (threedsc == 0) and (fourdsc == 0)) then
		 walk(chestroom)
		else
			p"Открыть не удается.."
		end
	end
}

podsoznanie_room = room {
    nam = "Подсознание",
  pxa = {
    { "screen", 165 }
  },
    way = {"podsoznanie_room","person","superego","main2"},
    obj = {"it_crioson","it_meds"},
}

criocaps_final = room {
	nam = "Подсознание",
  pxa = {
    { "screen", 165 }
  },
	way = {"criocaps_final","person_final","superego_final","final_rooom"},
	obj = {"it_crioson","it_meds"},
}

person_final = room {
	nam = "Личность",
  pxa = {
    { "screen", 165 }
  },
	way = {"criocaps_final","person_final","superego_final","final_rooom"},
	obj = {"final_person_dmitry"}
}

superego_final = room {
	nam = "Суперэго",
  pxa = {
    { "screen", 165 }
  },
	way = {"criocaps_final","person_final","superego_final","final_rooom"},
	obj = {"final_s_dm_parents"},
}

person = room {
	nam = "Личность",
  pxa = {
    { "screen", 165 }
  },
	way = {"podsoznanie_room","person","superego","main2"},
	obj = {"person_dmitry","p_dm_stress","p_dm_depression", }
}

superego = room {
	nam = "Суперэго",
  pxa = {
    { "screen", 165 }
  },
	way = {"podsoznanie_room","person","superego","main2"},
	obj = {"s_dm_parents","s_dm_dolg"},
}

final_person_dmitry = obj {
	nam = "person_dmitry",
	dsc = "- Самоидентификация личности: {Крыса}^^ + Проблем не выявлено.",
	act = "'...'",
}

final_s_dm_parents = obj {
	nam = "s_dm_dolg",
	dsc = "Найдено:^ - личность 'Крыса'^- остатки личности 'Александр' (анализ не возможен)^ ^Анализ личности 'Крыса':^ ^ + Проблем не выявлено.",
}

final_rooom = room {
	nam = "Выход",
  enter = function() mute_()(); complete_("persona")() end,
 act = gamefile_("wake.lua"),
 obj = { vobj("next", txtc("{КОНЕЦ?}")) }
}






p_dm_depression = obj {
	nam = "depression",
	dsc = "- {Вялотякущая депрессия}^^Необходимо восстановление личности из резевной копии",
	act = "'...Когда мы прилетим все, кого я знал, будут мертвы. Тысяча лет не шутки. Мои коллеги, мой начальник, родители, дочь. Я останусь один...'",
}

p_dm_stress = obj {
	nam = "stress",
	dsc = "^ ! Выявленные проблемы:^ - {Значительный стресс}^",
	act = "'...Я не уверен, что выживу в полете. Может произойти что угодно. Роботы перепутают провода, или начнуть отрывать друг другу конечности...'",
}

person_dmitry = obj {
	nam = "person_dmitry",
	dsc = "- Самоидентификация личности: {Александр}^",
	act = "'...Я - Александр, мне 43 года. Я инженер. Нахожусь в криосне на борту космического корабля, который в полете тысячу лет...'",
}

s_dm_parents = obj {
	nam = "s_dm_dolg",
	dsc = "Найдено:^ - личность 'Александр'^[альтернативные личности отсутствуют]^ ^Анализ личности 'Александр':^ - {Указания родителей} (хроническое)^",
	act = "'...Ты должен быть послушным мальчиком!... ...Не будешь учиться - продадим цыганам!... ...Запомни! Ты должен чистить зубы каждый день в полдень!...'",
}

s_dm_dolg = obj {
	nam = "s_dm_parents",
	dsc = "- {Долг перед обществом} (хроническое)^^ + Проблем не выявлено.",
	act = "'...Наша цивилизация поручила тебе ответственную миссию... ...Ты должен соответствовать... ...Ожидания командования вполне конкретны...'",
}

it_crioson = obj {
	nam = "it_crioson",
	dsc = "Модификации подсознания:^- {Состояние криосна}^",
	act = "[Ощущения от органов чувств заблокированы]",
}

it_meds = obj {
	nam = "it_meds",
	dsc = "- {Блокирование неуместных инстинктов}^^ + Проблем не выявлено.",
	act = "[Инстинкт размножения заблокирован]",
}

chestroom = room {
	nam = "Ящик Александра",
	obj = {"disk_in_chestroom","rat_in_chestroom"},
	way = {"main2"},
}

rat_in_chestroom = obj {
	nam = "rat_in_chestroom",
	dsc = "Рядом видна {крысиная нора}.",
	act = "Кажется крысы прорыли дыру в стене и повредили диск.",
}

disk_in_chestroom = obj {
	nam = "Диск с личностью Александра",
	dsc = "Внутри ящика {диск} с резервной копией личности Александра.. но он разломан и всюду видно следы чьих-то зубов. Надо найти другой диск.",
	act = "Диск значительно поврежден. Использовать его не получится. Нужен еще один.",
}

function start()
	if here() == coderoom then
		stead.mouse_filter(0)
	end
end
