-- $Name: Подготовка к пробуждению$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "xact"

_patterns = {};

game.use = "Вариантов успешного завершения инструкций 0... Отмена действия."
main = room {
    nam = "...",
    title = { "П", "О", "В", "А", "Р" },
    num = 11,
    enter = music_("daybefore",0),
    act = function(s) walk("sylo") end,
    dsc = "WR021 активирован.^Я один из роботов, обслуживающих космический корабль.^Меньше слов, больше выполненных заданий из списка, как говорил наладчик моих модулей индивидуальности.",
    obj = { vobj("next", '{Выехать из отсека}') },
}

sylo = room {
    nam = "Технический блок №11",
    pxa = {
      { "door4", 10 },
      { "door3", 150},
      { if_("gates._acted", "door1_open", "door1"), 360 }
    },
    dsc = "Один из многих технических блоков. Здесь всего две камеры с роботами WR, две стальные двери. Хорошо, что мне удалось воспользоваться модулем индивидуальности и выкрасить свою дверь в оранжевый. Хоть что-то среди этого набора из сотни зануд.",
    obj = {"todo", "gates"},
	exit = function (s, w)
		if not todo._acted then
			p 'И зачем мне выезжать из блока? Открытых заданий нет.'
			return false;
		end
	end
}

main_deck = room {
	nam = "Главная палуба",
  pxa = {
    { "window", 90 },
    { "door2", 180 },
    { "window", 380 }
  },
	dsc = "Главная палуба. Отсюда я могу добраться к любому другому отсеку.",
	obj = {"button"},
	way = {"elevator"},
}

organic = room {
	nam = "Камера органического синтеза",
  pxa = {
    { "door2", 10 },
    { "panel", 140 },
    { "device", 340 }
  },
	dsc = "Борщ, пиво, стейк с кровью. Тут можно синтезировать всё, кроме заливной рыбы, которая была запрещена восемь циклов назад.",
	act = function(s) walk("synthesizer") end,
	obj = {"button", vobj("next", '{Подключиться} к синтезатору.')},
	way = {"elevator"},
}

elevator = room {
	nam = "Лифт",
  pxa = {
    { "door2", 180 }
  },
	dsc = "Кабина лифта. Ничего необычного.",
	obj = {"level_buttons"},
	way = {"main_deck", "store"},
}

synthesizer = room {
	nam = "Органический синтезатор",
  pxa = {
    { "device", 177 }
  },
	dsc = "Органический синтезатор соединён с клеточными наполнителями. Вся синтезированная продукция поступает непосредственно на склад.",
	obj = {"wishlist", "ingridients", "mixer", "separator"},
	way = {"organic"},
}

virtual_store = room {
	nam = "Виртуальный склад",
  pxa = {
    { "device", 177 }
  },
	dsc = "Продукты из виртуального склада синтезируются из субклеточной эмульсии. После выбора синтезированные продукты автоматически будут добавлены в миксер.",
	obj = {"malt", "yeast", "watermelon", "pineapple", "mayonnaise", "potato"},
	way = {"synthesizer"},
}

store = room {
	nam = "Склад",
  pxa = {
    { "door2", 10 },
    { if_("exist(destructor)", "bfg"), 140 },
    { if_("exist(rat)",if_("rat._fired","rat_dead","rat")), 330 },
    { "box", 400 }
  },
	dsc = "Склад продуктов, которые нельзя просто так синтезировать.",
	obj = {"malt", "yeast", "rat", "destructor"},
	way = {"elevator"},
	exit = function (s, w)
		if have("destructor") then
			p "Распылитель лучше положить на место.";
			return false;
		end;
	end,
	enter = function (s)
        if not have(rat) then
		    place("rat", here());
            rat._fired = false;
        end
		place("malt", here());
		place("yeast", here());
	end,
}:disable();

wishlist = obj {
	nam = "Список пожеланий",
	act = "Список блюд на вечеринку:^- Пиво^- Фруктовый салат^- Жареный картофель^",
	dsc = "{Список пожеланий персонала}^",
}

ingridients = obj {
	nam = "Ингредиенты",
	act = function(s) walk("virtual_store"); end,
	dsc = "{Выбор ингредиентов}^",
}

mixer = obj {
	var {content = 0, pattern = "Позиция направлена на склад. Паттерн записан."},
	act = function (s)
        yeast.mix = false;
        malt.mix = false;
        watermelon.mix = false;
        pineapple.mix = false;
        potato.mix = false;
        water.mix = false;
        rat.mix = false;
        mayonnaise.mix = false;
		if s.content == 0 then
			s.content = 0;
			return "Миксер пуст.";
		elseif s.content == 19 then
			s.content = 0;
            _patterns[0] = true;
            check_conditions();
			return "Фруктовый салат готов. "..s.pattern;
		elseif s.content == 28 then
			s.content = 0;
            _patterns[1] = true;
            check_conditions();
			return "Пиво готово. "..s.pattern;
		elseif s.content == 64 then
			s.content = 0;
			return "Нагревательный элемент отсутствует. Миксер очищен.";
		elseif s.content == 96 then
			s.content = 0;
            _patterns[2] = true;
            check_conditions();
			return "Жареный картофель готов. "..s.pattern;
		else
			s.content = 0;
			return "Отвратительная смесь приготовлена и отправлена на переработку.";
		end;
	end,
	nam = "Миксер",
	dsc = "{Миксер}^",
}


separator = obj {
	nam = "Сепаратор",
	dsc = "{Молекулярный сепаратор}^",
    act = "Сепарируй и заливай.",
}

todo = obj {
    nam = "todo",
    var { _acted },
	act = function (s)
		if not s._acted then
			s._acted = true;
		end
		return "Всего один пункт:^   - Подготовка к вечеринке перед приземлением.^Что ж, это должно быть 101 из 101 по шкале интересности.";
	end,
    dsc = "{Список задач} доступен для чтения.",
}

button = obj {
	nam = "elevator call",
	act = "Никогда не понимал эти кнопки. И так ведь ясно, что я хочу куда то ехать. Зачем ещё её нажимать.",
	dsc = "На стене находится {кнопка вызова лифта}.^",
}

level_buttons = obj {
	nam = "level buttons",
	act = function (s)
		if not s._acted then
			s._acted = true;
			ways():add("organic");
		end
		return "Так, что у нас тут... машинный зал... отсек криокамер... о! камера органического синтеза, то, что нужно."
	end,
	dsc = "Справа находятся {кнопки отсеков}.^",
}

gates = obj {
	nam = "ворота",
	var { _state = "закрыты" },
	dsc = function(s) 
		return "{Ворота}, ведущие из технического отсека "..s._state.."."; 
	end,
	act = function (s)
		if not s._acted then
			s._acted = true;
			s._state = "открыты";
			ways():add("main_deck");
			return "Я приложил правую руку к считывателю и ворота открылись.";
		else
			return "Ворота на главную палубу уже открыты.";
		end
	end,
}

malt = obj {
    var {mix = false},
	nam = "Солод",
	dsc = function (s)
		if here() == "store" then
			return "Мешки с {солодом}^";
		else
			return "{Солод}^";
		end;
	end,
	act = function (s)
		if here() ~= store then
			store:enable();
			return "Этот ингредиент невозможно синтезировать. Придётся идти на склад."
        else
            take(malt);
            return "Солод погружен в отсек №3.";
		end;
	end,
    use = function (s, w)
        if w == mixer then
            if not s.mix then
                mixer.content = mixer.content + 4;
                s.mix = true;
            end;
            remove(s, me());
            return s.nam.." помещён в миксер."
        end
    end,
    inv = "Зерна солода. Странно, что люди так и не научились синтезировать что-то сложнее ватных фруктовых кубиков.",
}

yeast = obj {
    var {mix = false},
	nam = "Дрожжи",
	dsc = function (s)
		if here() == "store" then
			return "Пробирка с {дрожжами}^";
		else
			return "{Дрожжи}^";
		end;
	end,
	act = function (s)
		if here() ~= store then
			store:enable();
			return "Этот ингредиент невозможно синтезировать. Придётся идти на склад."
        else
            take(yeast);
            return "Пробирка с дрожжами помещена в отсек №7";
		end;
	end,
    use = function (s, w)
        if w == mixer then
            if not s.mix then
                mixer.content = mixer.content + 8;
                s.mix = true;
            end;
            remove(s, me());
            return s.nam.." помещены в миксер."
        end
    end,
    inv = "Штамм отличнейших дрожжей. Можно даже разглядеть отдельные клетки.",
}

watermelon = obj {
    var {mix = false},
	nam = "Арбузные кубики",
	dsc = "Сухие {арбузные кубики}^",
	act = function (s)
        if not s.mix then
            mixer.content = mixer.content + 1;
            s.mix = true;
        end;
		return s.nam.." добавлены в миксер.";
	end,
}

pineapple = obj {
    var {mix = false},
	nam = "Ананасовые кубики",
	dsc = "Сухие {ананасовые кубики}^",
	act = function (s)
        if not s.mix then
            mixer.content = mixer.content + 2;
            s.mix = true;
        end;
		return s.nam.." добавлены в миксер.";
	end,
}

mayonnaise = obj {
    var {mix = false},
	nam = "Майонез",
	dsc = "Взбитый {концентрат жира с яйцами}^",
	act = function (s)
        if not s.mix then
            mixer.content = mixer.content + 128;
            s.mix = true;
        end;
		return s.nam.." добавлен в миксер.";
	end,
}

potato = obj {
    var {mix = false},
	nam = "Картофельные бруски",
	dsc = "Синтезированный {картофель}^",
	act = function (s)
        if not s.mix then
            mixer.content = mixer.content + 64;
            s.mix = true;
        end;

		return s.nam.." добавлены в миксер.";
	end,
}

rat = obj {
    var {mix = false},
	var {_fired = false},
	nam = "Крыса",
	dsc = function(s)
        local state = "";
        if s._fired then
            state = "поджарена.";
        else
            state = "не поджарена.";
        end
        return "В углу сидит бесстрашная {жирная тварь}. Она "..state.."^";
    end,
	act = function (s)
		if not have("rat") then
			take(rat);
			return "Я ловким движением правой руки поймал крысу и положил в один из внутренних отсеков.";
		else
			return "Все подходящие отсеки заполнены. Отмена операции.";
		end
	end,
	use = function (s, w)
		if w == separator then
			remove(s, me());
			take(water);
			take(trash);
			return "Думаю, стоит тебя немного разделить.";
        elseif w == mixer then
            if s._fired then
                if not s.mix then
                    mixer.content = mixer.content + 32;
                    s.mix = true;
                end
                remove(s, me());
                return "Крыса добавлена в миксер.";
            else
                return "Необходимость добавления органической крысы в не выявлена. Операция отменена.";
            end
		end;
	end,
	inv = function (s) 
    local state = "не поджарена.";
		if s._fired then
            state = "поджарена.";
        end
		return "Если тыкнуть крысу, она запищит. Отпускать её однозначно не стоит. Тем более, что тварь "..state; 
	end,
}

water = obj {
    var {mix = false},
	nam = "Вода",
	dsc = "Вода, что тут ещё сказать.",
	use = function (s, w)
		if w == mixer then
            if not s.mix then
                s.mix = true;
                mixer.content = mixer.content + 16;
            end
			remove(s, me());
			return s.nam.." добавлена в миксер.";
		end;
	end,
    inv = "Набор молекул, заключенный в ограниченном объёме.",
}

trash = obj {
	nam = "Крысиная требуха",
	inv = "Молекулярная суспензия. Всё что осталось от крысы после отделения воды.",
}

destructor = obj {
	nam = "Термический распылитель",
	dsc = "Справа от двери висит {термический распылитель}^",
	act = function (s) 
		take(s);
		p "Распылитель пригодится. Мало ли каких тварей привлекают к себе заготовленные ингредиенты.";
	end,
    use = function (s, w)
        if w == rat then
            w._fired = true;
            sound_("shoot_destructor")();
            return "Один выстрел из термического распылителя в крысу превратит её в сгусток энергии при малейшей встряске. Обычно это позволяет убить чуть больше одной крысы за раз, когда они начинают бороться и убегать.";
        end
    end,
    inv = function(s)
        drop(s);
        return "На складе распылителю самое место.";
    end
}

endscreen = room {
    nam = "Конец",
    enter = function() mute_()(); complete_("cook")() end,
    dsc = "Вот и подошел конец моему дежурству. Надеюсь, вечеринка по случаю прибытия удастся.^Ну а мне пора в свой отсек, на очередную гибернацию.^",
   act = gamefile_("dream.lua"),
   obj = { vobj("next", txtc("{Продолжение...}")) }
}

greenlight = obj {
    nam = "Зелёный индикатор",
    inv = function (s)
        walk("endscreen");
    end,
}

function check_conditions ()
    if(_patterns[0] and _patterns[1] and _patterns[2]) then
        take("greenlight", me());
    end;
end
