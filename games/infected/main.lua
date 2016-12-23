-- $Name: Заражённые$
-- $Version: 1.3$
instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "theme"
require "hideinv"

game.use = "Нет, так ничего не выйдет."

main = room {
  nam = "Нашествие",
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_simple.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = function(s)
    theme.set("scr.gfx.bg", "theme/bg.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 238);
    theme.set("win.w", 432);
    theme.set("win.h", 352);
    set_music("unfa.ogg",0);
    take(gun);
    walk(street1);
  end,
  dsc = [[Прошло уже несколько лет после начала эпидемии. Первые заражённые давно умерли, но вирус всё ещё
          гуляет по стране, и по-прежнему нужно быть очень осторожным. Цивилизация погибла. Чем больше людей
          собираются вместе, тем выше вероятность того, что появится новый заражённый, и тогда уже никому
          не миновать тяжёлой участи. Заражённые не чувствуют боли, и холодное оружие против них не помогает.
          Только выстрел в голову может остановить заражённого. До сих пор так и неизвестно, как появился
          вирус. Зато известно, как он передаётся -- через кровь.^^
          Я уже больше года путешествую один, по брошенным городам, пытаясь с оружием в руках добыть себе
          пропитание. Я слышал, что где-то далеко на юге есть самый настоящий город с высокими стенами,
          хорошо защищённый от заражённых. Но я в это не верю. Люди любят придумывать сказки. Я иду на север.]],
  obj = { 
    vobj("next", '{Начать игру}'),
    "info"
  }
}

info = obj {
  nam = "info",
  dsc = "^^^^^^Информация о создателях в файле credits.txt."
}

function checkzombi(v)
  if v.zombi and not v._dead then
    return walk(gameover2);
  end
end

local old_obj = obj;
function tcall(f,s)
  if type(f) == "function" then
    return tcall(f(s),s);
  else
    return f;
  end
end
function obj(tab)
  local dsc = tab.dsc;
  tab.dsc = function(s)
    if s.cnd == nil or s:cnd() then
      return tcall(dsc,s);
    end
  end
  return old_obj(tab);
end

local old_room = room;
function room(tab)
  --tab.disp = "";
  return old_room(tab);
end

instead.get_title=function()
  return "";
end

--items
gun = obj {
  _load = 0,
  nam = function(s)
    if s._load==0 then
      return "Ружьё";
    else
      return "Ружьё ("..tostring(s._load)..")";
    end
  end,
  inv = function(s)
    local d = "Моё старое ружьё. ";
    if s._load == 0 then
      return d.."Сейчас ружьё не заряжено, все патроны кончились.";
    else
      return d.."Я пересчистываю патроны. Всего я насчитал: "..tostring(s._load)..".";
    end
  end,
  use = function(s,v)
    if v.zombi and s._load==0 then
      return "У меня нет патрон!";
    elseif v==zombi10 then
      set_sound("gunshot.ogg");
      v._dead=true;
      s._load=s._load-1;
      return [[Я выстрелил в заражённого, и того отбросило назад, к окну. Послышался треск досок и звон стекла. Заражённый проломил заколоченное
               окно и вылетел на улицу. На торчащих вокруг оконной рамы щепках остались капли его крови.]];
    elseif v==zombi11 then
      set_sound("gunshot.ogg");
      v._dead=true;
      s._load=s._load-1;
      return [[Я выстрелил в заражённого старика и попал ему в голову. Старик растянулся на полу.]];
    elseif v.zombi then
      set_sound("gunshot.ogg");
      v._dead = true;
      local tab = {
        "Я выстрелил в заражённого и попал ему прямо в глаз.",
        "Я прицелился в голову заражённого и выстрелил. Точное попадание!",
        "Рука моя немного дрогнула в последний момент, но я всё равно попал заражённому в голову.",
        "За время своих странствий я научился метко стрелять. Мне требуется всего пара секунд, чтобы прицелиться и выстрелить заражённому прямо промеж глаз.",
        "Я пристрелил заражённого из ружья."
      };
      s._load=s._load-1;
      return tab[rnd(5)];
    elseif v==oldman or v==girl then
      return "Я не убийца!";
    else
      return "Ружьё не для этого. Ещё сломаю.";
    end
  end
}

pipe = obj {
  nam = "Обломок трубы",
  dsc = [[Рядом с киоском на земле валяется {обломок трубы}.]],
  tak = [[Я подобрал обломок трубы.]],
  inv = [[Обгорелый обломок трубы с острым рваным концом.]],
  use = function(s,v)
    checkzombi(v);
    if v==gasstation_entrance and not gasstation2._open then
      gasstation2._open = true;
      return "С помощью трубы я сорвал навесной замок. Вот труба и пригодилась!";
    elseif v==gasstation_entrance and not gasstation2._open then
      return "Я уже открыл дверь.";
    elseif v==house1level2_room21_box and not house1level2_room21_box._open then
      house1level2_room21_box._open = true;
      return [[Я использовал трубу как рычаг и перевернул шкаф. Оказалось, что внутри лежит только порванное платье.]];
    elseif v==house1level2_room21_box and house1level2_room21_box._open then
      return "Я уже перевернул этот шкаф.";
    end
  end
}

rope = obj {
  nam = "Шланг",
  dsc = [[Рядом с одной из колонок валяется оторванный {шланг}.]],
  tak = [[Я поднимаю шланг.]],
  inv = [[Длинный резиновый шланг.]],
  use = function(s,v)
    checkzombi(v);
    if v==stone then
      stone._rope=true;
      remove(rope,me());
      return "Я привязал шланг к камню.";
    elseif v==house1level2_flat2 then
      return "Лучше я сначала привяжу шланг к камню.";
    end
  end
}

plant = obj {
  _took = false,
  nam = "Бутон",
  dsc = [[{Бутон} этого растения похож на какой-то съедобный плод.]],
  cnd = function(s)
    return house1level2_room21_cactus._alive;
  end,
  tak = function(s)
    s._took=true;
    return [[Я сорвал бутон странного растения.]];
  end,
  use = function(s,v)
    if v==girl then
      return walk(girl_dlg2);
    end
  end,
  inv = function(s)
    return [[Мягкий мясистый бутон.]];
  end
}

plant1 = obj {
  _took = false,
  nam = "Половинка бутона (1)",
  inv = [[Половинка бутона -- одну я могу отдать.]],
  use = function(s,v)
    if v==girl then
      return walk(girl_dlg3);
    end
  end
}

plant2 = obj {
  _took = false,
  nam = "Половинка бутона (2)",
  inv = [[Половинка бутона -- одну я могу отдать.]],
  use = function(s,v)
    if v==girl then
      return walk(girl_dlg3);
    end
  end
}

knife = obj {
  _clean = false,
  _used = false,
  nam = "Нож",
  dsc = function(s)
    if not s._clean then
      return [[Рядом с одной из кабинок валяется окровавленный {нож}.]];
    else
      return [[Рядом с одной из кабинок валяется {нож}.]];
    end
  end,
  inv = [[Обычный перочинный нож. Лезвие довольно толстое и крепкое.]],
  tak = function(s)
    if not s._clean then
      p [[Нож мне может пригодиться, свой последний нож я сломал. Однако этот нож весь в крови, и это может быть кровь
          заражённого. Надо сначала вытереть чем-нибудь кровь. И я не хочу делать это своей одеждой.]];
      return false;
    else
      return "Я поднимаю нож.";
    end
  end,
  use = function(s,v)
    if v==house1level1_room11_painting and not house1level1_room11_painting._open then
      house1level1_room11_painting._open=true;
      return [[Я просунул нож под раму и, сильно надавив на рукоятку, используя нож как рычаг, смог отодвинуть дверцу тайника.]];
    elseif v==house1level1_room11_painting and house1level1_room11_painting._open then
      return "Я уже открыл тайник.";
    elseif v==toolbox and not toolbox._used then
      remove(toolbox,me());
      toolbox._used = true;
      take(hammer);
      return [[Я открыл ящик с инструментами с помощью ножа. Внутри оказался строительный молоток.]];
    elseif v==toolbox and toolbox._used then
      return "Я уже открыл ящик с инструментами.";
    elseif v==car_box and not car_box._open then
      gun._load=gun._load+2;
      car_box._open=true;
      return [[Я взломал бардачок с помощью ножа. Внутри оказалось два патрона, которые подошли к моему ружью.
               Удивительно, что они не взорвались! Наверное, их защитил бардачок.]];
    elseif v==car_box and car_box._open then
      return "Я уже взломал бардачок.";
    elseif v==house1level2_room21_cactus then
      return "Нет смысла резать это ножом.";
    elseif v==plant and not s._used then
      remove(plant,me());
      take(plant1);
      take(plant2);
      return "Я разрезал плод на две половинки. Надеюсь, одной половины хватит, чтобы исцелиться.";
    end
  end
}

hammer = obj {
  nam = "Молоток",
  inv = "Строительный молоток с гвоздодёром.",
  use = function(s,v)
    if v==warehouse1_entrance and not warehouse1_entrance._open then
      warehouse1_entrance._open = true;
      return [[Я выломал молотком все доски, которыми была заколочена дверь. Теперь можно зайти.]];
    elseif v==warehouse1_entrance and warehouse1_entrance._open then
      return [[Я уже выломал все доски.]];
    elseif v==warehouse4_box and not warehouse4_box._open then
      warehouse4_box._open = true;
      return "Я разбил молотком крышку ящика.";
    elseif v==warehouse4_box and warehouse4_box._open then
      return "Я уже разбил крышку ящика.";
    end
  end
}

key = obj {
  _done=false;
  nam = "Ключ",
  inv = [[Обычный ключ от замка.]],
  use = function(s,v)
    if v==house1level1_flat2 and not s._open then
      house1level1_flat2._open=true;
      if not s._done then
        s._done=true;
        return "Удивительно, но ключ подошёл к замку! Я отпер дверь.";
      else
        return "Я отпер дверь.";
      end
    elseif v==house1level1_flat2 and s._open then
      return "Дверь уже отперта.";
    end
  end
}

food1 = obj {
  _take = false,
  nam = "Консерва бобов",
  inv = [[Консерва бобов, больше ничего и не скажешь.]],
  use = function(s,v)
    if v==oldman and not oldman._first then
      return "Не пойму, зачем ему отдавать продукты. Я с ним даже не поговорил и не знаю, кто он. Мне от этого никакой выгоды.";
    elseif v==girl then
      return "Не думаю, что ей нужна моя консерва.";
    elseif v.zombi then
      return "Я не собираюсь кормить заражённых консервами! Да они и сами обычно предпочитают совсем не консервированные бобы...";
    elseif v==oldman and oldman._first then
      oldman._food = true;
      remove(food1,me());
      take(key2);
      return walk(oldman_dlg2);
    end
  end
}

key2 = obj {
  nam = "Ключ 2",
  inv = [[Ключ от замка.]],
  use = function(s,v)
    if v==warehouse3_entrance then
      warehouse3_entrance._open=true;
      return "Я отпер дверь ключом, который дал мне старик.";
    end
  end
}

bottle = obj {
  _taken = false,
  nam = "Бутылка",
  dsc = "Рядом с ящиком стоит пластиковая {бутылка} с какой-то жидкостью.",
  tak = function(s)
    s._taken = true;
    return "Я подобрал бутылку.";
  end,
  inv = "Жидкость у бутылке имеет странный и резкий запах. Это точно не вода. Лучше это не пить.",
  use = function(s,v)
    if v==house1level2_room21_cactus then
      remove(s,me());
      house1level2_room21_cactus._alive=true;
      return "Я полил растение из бутылки, и растение неожиданно расцвело -- бутон тут же набух и стал сочным.";
    end
  end
}

dress = obj {
  nam = "Порванное платье",
  dsc = [[В шкафу лежит {порванное платье}.]],
  tak = [[Я взял порванное платье.]],
  inv = [[Порванное женское платье.]],
  use = function(s,v)
    if v == knife then
      remove(s,me());
      knife._clean = true;
      return "Я аккуратно стёр с ножа всю кровь. Теперь нож можно использовать.";
    end
  end,
  cnd = function(s)
    return house1level2_room21_box._open;
  end
}

--street1
street1 = room {
  _seen = false,
  nam = "На улице",
  pic = "gfx/street1.jpg",
  dsc = function(s)
    local md = 
        [[Я стою в самом начале улицы. Позади меня -- выход из города, на шоссе, но уходить мне
          пока ещё рано.]];
    if s._seen then
      return md;
    else
      s._seen = true;
      return 
        [[Я набрёл на очередной заброшенный город. Это очень кстати. У меня как раз закончились все
          припасы, а в таких местах обычно есть чем поживиться.^ ]]..md
    end
  end,
  obj = { "street1fuel", "street1kiosk", "street1street" },
  way = { vroom("Заправочная станция","gasstation"), vroom("Киоск","kiosk"), vroom("Вниз по улице","street2") }
}

street1fuel = obj {
  nam = "street1fuel",
  dsc = "Справа от меня -- {заправочная станция},",
  act = "Я люблю заправки -- там часто можно найти много чего интересного."
}

street1street = obj {
  nam = "street1street",
  dsc = "Я могу пойти {вниз по улице}.",
  act = "Улица впереди ещё длинная."
}

street1kiosk = obj {
  nam = "street1kiosk",
  dsc = "а слева -- пустой {газетный киоск}.",
  act = "Кажется, этот киоск горел."
}

--kiosk
kiosk = room {
  nam = "Газетный киоск",
  pic = "gfx/street1.jpg",
  dsc = [[Этот газетный киоск явно горел. Изнутри всё чёрное. Такое впечатление, что его облили бензином
          и подожгли. Но зачем?]],
  obj = { "kioskbody", "pipe" },
  way = { vroom("Улица","street1") }
}

kioskbody = obj {
  nam = "kioskbody",
  dsc = [[Через выбитое окно киоска я вижу чей-то {обгоревший труп}.]],
  act = [[Нет! Я не собираюсь к нему прикасаться! Он совсем сгорел, почти превратился в пепел. Лучше
          его не трогать.]]
}

--gasstation
gasstation = room {
  nam = "Заправочная станция",
  pic = "gfx/gasstation1.jpg",
  dsc = [[Заброшенная заправка -- такие мне попадались уже сотни раз. Обычно тут есть чем разживиться.]],
  obj = { "gasstation_columns", "rope", "gasstation_entrance" },
  way = { vroom("Здание","gasstation2"), vroom("Улица","street1") }
  
}

gasstation_columns = obj {
  nam = "gasstation_columns",
  dsc = [[Все {колонки} разбиты, у многих оборваны резиновые шланги для заправки.]],
  act = [[Нет, тут я не вижу ничего полезного.]]
}

gasstation_entrance = obj {
  nam = "gasstation_entrance",
  dsc = [[Справа от меня -- {дверь} в здание заправочной станции.]],
  act = function(s)
    if gasstation2._open then
      return [[Дверь открыта, я могу зайти.]];
    else
      return [[Дверь закрыта на большой навесной замок.]];
    end
  end
}

--gasstation2
gasstation2 = room {
  _open = false,
  nam = "Внутри заправочной станции",
  pic = "gfx/gasstation2.jpg",
  enter = function(s)
    if not s._open then
      p [[Дверь закрыта на большой навесной замок.]];
      return false;
    end
  end,
  dsc = [[Я нахожусь в небольшом запылённом помещении. Пылью затянуты даже окна, и из-за этого здесь
          довольно темно.]],
  obj = { "gasstation2_shelves", "gasstation2_cashier", "zombi1" },
  way = { vroom("Улица","gasstation") }
}

gasstation2_shelves = obj {
  nam = "gasstation2_shelves",
  dsc = [[Слева от меня -- длинные ряды магазинных {полок}.]],
  act = function(s)
    if not zombi1._dead then
      return walk(gameover1);
    elseif food1._take then
      return "Больше здесь нет ничего интересного.";
    else
      take(food1);
      food1._take=true;
      return "Я внимательно осмотрел полки, но нашел только мятую консерву с бобами. Больше ничего полезного тут нет. Что ж, и это неплохо.";
    end
  end
}

gasstation2_cashier = obj {
  _open = false,
  nam = "gasstation2_cashier",
  dsc = [[Справа -- высокая {стойка с кассой}.]],
  act = function(s)
    if not zombi1._dead then
      return walk(gameover1);
    end
    if not s._open then
      gun._load = gun._load+1;
      s._open=true;
      return "Я внимательно осмотрел стол и кассу и нашёл один патрон, который подходит для моего ружья.";
    else
      return "Здесь больше ничего нет.";
    end
  end
}

zombi1 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi1",
  act = function(s)
    if not s._dead then
      return "Он идёт прямо на меня! Нельзя терять времени!";
    else
      return "Я обыскал труп заражённого, но ничего не нашёл.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[На полу валяется {труп заражённого}, которого я застрелил.]];
    else
      return 
          [[^Я слышу какой-то шорох, и через секунду передо мной появляется окровавленный мужчина
            в рваной одежде. Глаза у него мутные, как у слепого. Это {заражённый}! Я лихорадочно
            проверяю патроны в своём дробовике.]]
    end
  end
}

--street2
street2 = room {
  _fall = false,
  nam = "На улице",
  enter = function(s)
    if plant._took and not s._fall and not zombi12._dead then
      s._fall=true;
      p [[Я выпрыгнул из окна и остался жив. Однако я серьёзно повредил ногу, возможно, даже сломал. Идти я ещё могу, но с трудом.]];
    end
  end,
  pic = "gfx/street2.jpg",
  dsc = [[Я стою посреди улицы.]],  
  obj = { "street2shop", "street2house", "street2street" },
  way = { vroom("Магазин","shop"), vroom("Жилой дом","house1level1"), vroom("Вверх по улице","street1"), vroom("Вниз по улице","street3") }
}

street2shop = obj {
  nam = "street2shop",
  dsc = [[Слева от меня {магазин} с разбитой витриной,]],
  act = [[Похоже, это когда-то был продуктовый магазин.]]
}

street2house = obj {
  nam = "street2house",
  dsc = [[а справа -- {вход в подъезд} жилого дома.]],
  act = [[Это вход в небольшое трёхэтажное здание.]]
}

street2street = obj {
  nam = "street2street",
  dsc = [[Я могу пойти вниз или вверх по {улице}.]],
  act = [[Улица не кончается, до конца города ещё далеко.]]
}

--shop
shop = room {
  nam = "Магазин",
  pic = "gfx/shop.jpg",
  dsc = [[Магазин полностью разграблен -- стеллажи перевёрнуты, касса разбита. Здесь ничего не осталось.]],
  obj = { "shop_cashier", "shop_toiletdoor" },
  way = { vroom("Улица","street2"), vroom("Туалет","shop_toilet") }
}

shop_cashier = obj {
  nam = "shop_cashier",
  dsc = [[Справа от меня -- {стойка продавца}.]],
  act = [[Нет, здесь ничего нет. Пусто.]]
}

shop_toiletdoor = obj {
  nam = "shop_toiletdoor",
  dsc = [[Впереди виднеется {дверь в туалет}.]],
  act = [[Дверь не заперта.]]
}

--shop_toilet
shop_toilet = room {
  nam = "Туалет",
  pic = "gfx/toilet.jpg",
  dsc = [[В туалете стоит такой запах, что мне приходится зажать рукой нос. Всё вокруг разрушено, умывальники заполнены
          грязью, зеркала расколоты.]],
  obj = { "shop_toilet_blood", "knife" },
  way = { vroom("Магазин", "shop") }
}

shop_toilet_blood = obj {
  nam = "shop_toilet_blood",
  dsc = [[Я вижу на полу {пятна крови}.]],
  act = [[Это может быть кровь заражённых. Лучше к ней не прикасаться.]]
}

--house1level1
house1level1 = room {
  nam = "Первый этаж",
  pic = "gfx/level1.jpg",
  exit = function(s,v)
    if plant._took and v==house1level2 and not zombi12._dead then
      p "Лучше не подниматься наверх. Там всё ещё может быть этот заражённый.";
      return false;
    end
  end,
  dsc = [[Я стою в подъезде заброшенного жилого дома. Здесь очень грязно и стоит тяжёлый тошнотворный
          запах гнилости.]],
  obj = { "house1level1_flat1", "house1level1_flat2", "house1level1_stairs" },
  way = { "house1level1_room11", "house1level1_room12", vroom("На улицу","street2"), "house1level2" }
}

house1level1_flat1 = obj {
  nam = "house1level1_flat1",
  dsc = [[Слева от меня -- {дверь в квартиру 11}.]],
  act = [[Дверь в квартиру 11. Дверь не заперта -- замок выломан. Видно, кто-то уже побывал здесь до меня.]]
}

house1level1_flat2 = obj {
  _open = false,
  nam = "house1level1_flat2",
  dsc = [[Справа от меня -- {дверь в квартиру 12}.]],
  act = function(s)
    if not s._open then
      return [[Дверь в квартиру 12. Дверь металлическая и очень крепкая на вид. Закрыта на замок. Не думаю, что я смогу туда попасть без ключа.]];
    else
      return [[Дверь в квартиру 12 отперта, и я могу войти.]]
    end
  end
}

house1level1_stairs = obj {
  nam = "house1level1_stairs",
  dsc = [[Передо мной -- {лестница} на второй этаж.]],
  act = [[Все ступеньки оббиты, а перила сломаны, но здесь можно подняться.]]
}

--house1level1_room11
house1level1_room11 = room {
  nam = "Квартира 11",
  pic = "gfx/condom1.jpg",
  dsc = [[Тот, кто побывал до меня в 11-й квартире, выгреб всё подчистую. Здесь не осталось даже мебели. К тому же, пахнет
          мочой и экскрементами.]],
  obj = { "house1level1_room11_painting", "house1level1_room11_painting_bullets" },
  way = { vroom("Выйти","house1level1") }
}

house1level1_room11_painting = obj {
  _open = false,
  nam = "house1level1_room11_painting",
  dsc = function(s)
    if not s._open then
      return [[На стене слева висит картина -- закат над рекой. {Край рамы} как-то странно отходит от стены, как будто
              за картиной находится тайник.]];
    else
      return [[На стене слева -- открытая {дверца тайника}, замаскированная под картину.]]
    end
  end,
  act = function(s)
    if not s._open then
      return [[Кажется, тайник не закрыт, но руками отодвинуть картину не получается. Она застряла.]];
    else
      return [[Интересное расположение для тайника.]]
    end
  end
}

house1level1_room11_painting_bullets = obj {
  _took = false,
  nam = "house1level1_room11_painting_bullets",
  dsc = function(s)
    if s._took then
      return [[В тайнике лежит {коробка из-под патрон}.]];
    else 
      return [[В тайнике лежит {коробка патрон}.]];
    end
  end,
  act = function(s)
    s._took=true;
    gun._load = gun._load+2;
    return "В коробке оказалось два патрона. Что ж, неплохо.";
  end,
  cnd = function(s)
    return house1level1_room11_painting._open and not s._took;
  end
}

--house1level1_room12
house1level1_room12 = room {
  nam = "Квартира 12",
  pic = "gfx/condom3.jpg",
  enter = function(s)
    if not house1level1_flat2._open then
      p "Дверь заперта. Сначала надо открыть дверь.";
      return false;
    end
  end,
  dsc = [[Я нахожусь в небольшой комнате, которая имеет вполне обжитой вид. Правда, часть мебели зачем-то затянута
          чёрным полиэтиленовыми мешками, а у выхода стоят чемоданы, как будто кто-то собирался в путь.]],
  obj = { "house1level1_room12_box", "girl" },
  way = { vroom("Лестничная клетка","house1level1") }
}

house1level1_room12_box = obj {
  _empty = false,
  nam = "house1level1_room12_box",
  dsc = function(s)
    if not s._empty then
      return "На одном из чемоданов лежит {коробка патрон}.";
    else
      return "На одном из чемоданов лежит {коробка из-под патрон}.";
    end
  end,
  act = function(s,v)
    if not s._empty then
      s._empty = true;
      gun._load=gun._load+2;
      return "В коробке оказалось два патрона.";
    else
      return "Коробка пуста.";
    end
  end
}

girl = obj {
  _first = false,
  nam = "girl",
  dsc = function(s)
    if not s._first then
      return [[У окна сидит {девушка} лет пятнадцати и смотрит на меня с ужасом.]];
    else
      return [[У окна сидит {девушка} лет пятнадцати.]];
    end
  end,
  act = function(s)
    if not s._first then
      s._first=true;
      walk(girl_dlg1);
    else
      return [[Я должен ей помочь. У меня самого никого не осталось, моя семья погибла. А всё, что я делаю -- это пытаюсь
               выжить, наплевав на других людей. Возможно, это мой последний шанс на искупление.]];
    end
  end
}

girl_dlg1 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_dialog2.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = function(s)
    walk(girl_dlg1b);
  end,
  dsc = [[-- Кто вы? -- испуганно закричала девушка. -- Где мой отец? Как вы сюда попали?^
          -- Твой отец? -- удивился я и тут же понял. -- Извини, но он... Я нашёл ключ от этой квартиры на пустыре.
          У заражённого.^
          -- У заражённого? -- Девушка закрыла лицо руками и заплакала.^
          -- Но почему он пошёл туда? -- спросил я. -- Судя по всему, вы собирались уехать.^
          Девушка ничего не сказала и вместо этого закатала рукав своей куртки и показывала мне царапину на своём локте.^
          -- И что это значит? -- спросил я. -- Царапина?^
          -- Заражённая кровь, -- ответила девушка. -- Попало совсем немного, поэтому я ещё не больна. Но это скоро случится.^
          -- Но тогда извини, -- сказал я, -- у тебя нет...^
          -- Надежда есть! -- крикнула девушка. -- Мы нашли противоядие! Это такое растение, бутон. Если выпить его сок в течение
          первых дней после заражения, и если вируса в крови ещё не очень много...^
          Девушка снова закрыла лицо руками.^
          -- Но всё это уже не имеет ни малейшего значения! Мой отец мёртв!]],
  obj = { 
    vobj("next", '{Дальше}')
  }
}

girl_dlg1b = room {
  nam = "",
  hideinv = true,
  act = function(s)
    theme.set("scr.gfx.bg", "theme/bg.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 238);
    theme.set("win.w", 432);
    theme.set("win.h", 352);
    walk(house1level1_room12);
  end,
  dsc = [[-- Погоди, -- сказал я. -- Не отчаивайся. Я постараюсь тебе помочь. Быть может, я смогу найти это растение.^
          Девушка посмотрела на меня с таким видом, словно не верила мне.^
          -- Я правда помогу тебе, -- сказал я, и девушка, наконец, улыбнулась.]],
  obj = { 
    vobj("next", '{Вернуться}')
  }
}

girl_dlg2 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_dialog2.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = function(s)
    walk(ending2);
  end,
  dsc = function(s)
    if street2._fall then
      return
        [[-- Вот, возьми, -- сказал я, протягивая девушке бутон. -- Это тебе.^
          -- У вас получилось! -- воскликнула она. -- Но как?^
          -- Это неважно, -- сказал я, невольно коснувшись поцарапанного плеча. -- Возьми. И живи.^
          -- Но вы... -- начала девушка. -- Куда вы пойдёте? Может, нам...^
          -- Меня ждут, -- соврал я. -- Мне надо торопиться.^
          -- Но вы ранены, -- возразила девушка, -- ваша нога...^
          Я ничего не ответил и вышел на лестничную клетку.]];
    else
      return 
        [[-- Вот, возьми, -- сказал я, протягивая девушке бутон. -- Это тебе.^
          -- У вас получилось! -- воскликнула она. -- Но как?^
          -- Это неважно, -- сказал я, невольно коснувшись поцарапанного плеча. -- Возьми. И живи.^
          -- Но вы... -- начала девушка. -- Куда вы пойдёте? Может, нам...^
          -- Меня ждут, -- соврал я.^
          -- Ждут? Но я...^
          Я ничего не ответил и вышел на лестничную клетку.]]
    end
  end,
  obj = { 
    vobj("next", '{Дальше}')
  }
}

girl_dlg3 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_dialog2.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = function(s)
    walk(ending3);
  end,
  dsc = function(s)
    if street2._fall then
      return
        [[-- Вы ранены! -- воскликнула девушка, увидев меня.^
          -- Это неважно... -- начал я.^
          -- Но как же...^
          -- Сейчас есть дела и поважнее. Вот возьми, -- сказал я, протягивая девушке половину бутона. -- Надеюсь,
          одного хватит на нас обоих. Потому что я, к сожалению, тоже заразился.^
          -- Должно хватить, -- сказала девушка.^
          Мы съели растения.^
          -- И что теперь? -- спросила она.^
          -- Мне потребуется немного времени, чтобы прийти в себя, -- сказал я. -- А потом ты можешь пойти со мной.
          На юг. Не стоит тебе здесь одной оставаться.^
          -- На юг? -- спросила девушка.]];
    else
      return
        [[-- Вот возьми, -- сказал я, протягивая девушке половину бутона. -- Надеюсь,
          одного хватит на нас обоих. Потому что я, к сожалению, тоже заразился.^
          -- Должно хватить, -- сказала девушка.^
          Мы съели растения.^
          -- И что теперь? -- спросила она.^
          -- Мне потребуется немного времени, чтобы прийти в себя, -- сказал я. -- А потом ты можешь пойти со мной.
          На юг. Не стоит тебе здесь одной оставаться.^
          -- На юг? -- спросила девушка.]];
    end
  end,
  obj = { 
    vobj("next", '{Дальше}')
  }
}

--house1level2
house1level2 = room {
  nam = "Второй этаж",
  pic = "gfx/level2.jpg",
  enter = function(s)
    if have(stone) then
      p [[Я бросил тяжёлый камень. Перетащить его даже на несколько метров очень непросто.]];
      drop(stone);
    end
  end,
  exit = function(s,v)
    if have(stone) then
      p [[Не стоит таскать с собой этот камень. Он слишком тяжёлый.]];
      return false;
    end
    if house1level2_room21_cactus._alive and not zombi12._dead and v~=house1level2_room21 and v~=house1level2_room22 then
      return walk(gameover1);
    end
  end,
  dsc = [[Я на втором этаже здания. Единственное окно здесь заколочено досками, и из-за этого на этаже довольно сумрачно.]],
  obj = { "house1level2_flat1", "house1level2_flat2", "house1level2_stairs1", "house1level2_stairs2", "house1level2_floor", "house1level2_hole", "zombi12" },
  way = { "house1level2_room21", "house1level2_room22", "house1level1", "house1level3" }
}

house1level2_flat1 = obj {
  nam = "house1level2_flat2",
  dsc = [[Слева от меня -- {дверь в квартиру 21}.]],
  act = [[Дверь в квартиру 21. Дверь выломана -- такое впечатление, что её разбили топором.]]
}

house1level2_flat2 = obj {
  _open = false,
  nam = "house1level2_flat2",
  dsc = [[Справа от меня -- {дверь в квартиру 22}.]],
  act = function(s)
    if not s._open then
      return [[Дверь в квартиру 22. Дверь закрыта, однако личинка замка еле держится. Я думаю, что смог бы выломать эту дверь, если бы постарался.]];
    else
      return [[Дверь в квартиру 22. Замок полностью выломан -- теперь вместо него зияет огромная дыра.]];
    end
  end
}

house1level2_stairs1 = obj {
  nam = "house1level2_stairs1",
  dsc = [[Передо мной -- {лестница} на третий этаж.]],
  act = [[Все ступеньки оббиты, а перила сломаны.]]
}

house1level2_stairs2 = obj {
  nam = "house1level2_stairs2",
  dsc = [[Позади меня -- {лестница}, ведущая вниз.]],
  act = [[Это спуск на первый этаж.]]
}

house1level2_floor = obj {
  nam = "house1level2_floor",
  dsc = [[Весь {пол} здесь покрыт мусором и осколками стекла.]],
  act = "Я слышу каждый свой шаг."
}

house1level2_hole = obj {
  nam = "house1level2_stairs",
  dsc = [[Площадка рядом с лестницей, все перила выломаны, из-за чего получился отвесный {обрыв}. Надо быть осторожнее, если поскользнуться,
          можно упасть вниз.]],
  act = [[Здесь нет так высоко, но если я упаду, то наверняка переломаю себе все кости.]]
}

zombi12 = obj {
  _dead = false,
  _empty=false;
  zombi = true,
  nam = "zombi12",
  act = function(s)
    if not s._dead then
      return "Это заражённый, вниз мне не пройти!";
    elseif s._dead and not s._empty then
      gun._load=gun._load+3;
      s._empty=true;
      return "Я обыскал труп заражённого и нашёл три патрона, которые подошли для моего ружья.";
    else
      return "У этого заражённого больше ничего нет.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[На полу лежит {труп заражённого}, которого я застрелил.]];
    else
      return 
          [[^Спуск на первый этаж преграждает {заражённый}! Я могу попробовать проскользнуть в соседнюю квартиру, но спуститься
            вниз у меня точно не получится!]];
    end
  end,
  cnd = function(s)
    return plant._took;
  end
}

--house1level2_room21
house1level2_room21 = room {
  _open = false,
  nam = "Квартира 21",
  pic = "gfx/condom2.jpg",
  dsc = [[Я нахожусь в маленькой однокомнатной квартире. Вся мебель здесь сломана, обои на стенах ободраны и, кажется, кто-то разводил костёр
          прямо на полу.]],
  obj = { "house1level2_room21_box", "house1level2_room21_cactus", "plant", "dress" },
  way = { vroom("Лестничная клетка","house1level2") }
}

house1level2_room21_box = obj {
  _open = false,
  nam = "house1level2_room21_box",
  dsc = [[Посреди комнаты валяется перевернутый {шкаф}.]],
  act = function(s)
    if s._open then
      return "Обычный гардеробный шкаф.";
    else
      return "Шкаф очень тяжёлый. Голыми руками перевернуть его не получается.";
    end
  end
}

house1level2_room21_cactus = obj {
  _alive = false,
  nam = "house1level2_room21_cactus",
  dsc = function(s)
    if not s._alive then
      return [[На окне стоит кадка со {странным высохшим растением}.]];
    else
      return [[На окне стоит кадка со {странным растением}.]];
    end
  end,
  act = function(s)
    if not s._alive then
      return [[Растение представляет из себя сморщенный бутон в окружении пожухлых листьев.]];
    elseif not plant._took then
      return [[После того, как я полил растение водой, листва позеленела, а бутон набух и стал розовым и мясистым.]];
    else
      return [[Я уже сорвал у растения бутон, теперь здесь осталась только листва.]]
    end
  end
}

--house1level2_room22
function window_fun()
  if plant._took and house1level2_room22_window._broken then
    return "В окно";
  end
end

house1level2_room22 = room {
  nam = "Квартира 22",
  pic = "gfx/condom4.jpg",
  enter = function(s)
    if not house1level2_flat2._open then
      p "Дверь сначала нужно как-то выломать.";
      return false;
    end
  end,
  exit = function(s)
    if have(chair) and not plant._took then
      p [[Лучше я оставлю здесь этот стул.]];
      return false;
    end
  end,
  dsc = [[Я нахожусь в просторной комнате, которая похожая на гостиную. Однако здесь всё покрыто пылью -- видно, что
          жильцы ушли отсюда много лет назад.]],
  obj = { "house1level2_room22_floor", "house1level2_room22_window", "house1level2_room22_box", "house1level2_room22_table", "toolbox", "chair" },
  way = { vroom(window_fun,"street2"), vroom("Лестничная клетка","house1level2") }
  
}

house1level2_room22_floor = obj {
  nam = "house1level2_room22_floor",
  dsc = [[Весь {пол} покрыт грязью и осколками стекла.]],
  act = [[Наверное, кто-то уходит отсюда в спешке.]]
}

house1level2_room22_box = obj {
  nam = "house1level2_room22_box",
  dsc = [[У левой стены стоит высокий деревянный {шкаф}.]],
  act = [[В шкафу ничего нет.]]
}

house1level2_room22_table = obj {
  nam = "house1level2_room22_table",
  dsc = [[Справа от меня -- {деревянный письменный стол}.]],
  act = [[Я проверил ящики стола, в них ничего нет.]]
}

chair = obj {
  nam = "Стул",
  dsc = [[Рядом со столом стоит {стул}.]],
  tak = [[Я поднял стул.]],
  inv = "Самый обычный стул.",
  use = function(s,v)
    if v == house1level2_room22_floor or v == house1level2_room22_table then
      drop(s);
      return "Я ставлю стул рядом со столом.";
    elseif v == house1level2_room22_window and (not plant._took or zombi12._dead) then
      return "Зачем мне разбивать окно? Лучше я выйду через дверь.";
    elseif v == house1level2_room22_window and plant._took and not zombi12._dead then
      remove(s,me());
      house1level2_room22_window._broken = true;
      return "Я бросил стул в окно. Окно разбилось, теперь я могу выпрыгнуть из окна.";
    end
  end
}

house1level2_room22_window = obj {
  _broken = false,
  nam = "house1level2_room22_window",
  dsc = function(s)
    if not s._broken then
      return [[Единственное {окно} в этой комнате затянуто пылью, и из-за этого сюда почти не пробивается свет.]];
    else
      return [[Единственное {окно} в этой комнате разбито.]];
    end
  end,
  act = function(s)
    if not s._broken then
      return [[Окно, в которое открывается вид на улицу со второго этаже.]];
    else
      return 
        [[Окно разбито. Я мог бы попробовать спрыгнуть отсюда вниз. Здесь не очень высоко, правда, я всё равно могу разбиться. Но
          другого пути у меня нет.]];
    end
  end
}

toolbox = obj {
  _used = false;
  nam = "Ящик с инструментами",
  dsc = [[На столе лежит {ящик с инструментами}.]],
  tak = [[Я взял со стола ящик с инструментами.]],
  inv = [[Открыть ящик не получается. Кажется, его не открывали уже очень долго, и крышка ящика не желает подниматься.]],
  cnd = function(s)
    return not s._used;
  end
}

--house1level3
house1level3 = room {
  nam = "Третий этаж",
  pic = "gfx/level3.jpg",
  enter = function(s)
    if have(stone) then
      p [[Я бросил тяжёлый камень. Перетащить его даже на несколько метров очень непросто.]];
      drop(stone);
    end
  end,
  dsc = [[Я стою на лестнице перед третьим этажом. Дальше пройти не получится. Лестница обвалилась. Мне не остаётся ничего, кроме
          как спуститься вниз.]],
  obj = { "stone" },
  way = { "house1level2" }
}

stone = obj {
  _rope = false,
  _door = false,
  nam = function(s)
    if s._rope then
      return "Камень со шлангом";
    else
      return "Камень";
    end
  end,
  dsc = function(s)
    if s._rope and s._door then
      return [[К ручке двери 22-й квартиры привязан шланг, который обмотан вокруг {бетонной глыбы}.]]
    elseif s._rope then
      return [[Прямо передо мной лежит здоровый {камень}, к которому привязан шланг.]];
    else
      return [[Прямо передо мной лежит здоровый {камень}.]];
    end
  end,
  inv = function(s)
    if s._rope and s._door then
      return "Шланг одним концом привязан к ручке двери 22-й квартиры, а вторым -- к здоровому бетонному камню.";
    elseif s._rope then
      return "Здоровый камень, к которому привязан обрывок шланга, найденный мной у бензоколонки.";
    else
      return [[Это кусок бетона, очень тяжелый. Видимо, это осколок от лестничной ступеньки. Я едва могу приподнять его двумя руками.]];
    end
  end,
  tak = [[Я с большим трудом приподнимаю камень. Далеко я его не унесу.]],
  use = function(s,v)
    if v==house1level2_floor then
      drop(s);
      return "Я бросил камень на пол.";
    elseif v==house1level2_hole and not s._rope then
      return "Я, конечно, могу сбросить туда камень, но зачем это делать?";
    elseif v==house1level2_hole and s._rope and not s._door then
      return "Я мыслю в правильном направлении, но чего-то я ещё не сделал.";
    elseif v==house1level2_hole and s._rope and s._door then
      house1level2_flat2._open = true;
      drop(s);
      return [[Я сталкиваю камень вниз, и через мгновение раздаётся оглушительный треск. Ручка, к которой привязан шланг, вылетает из
                двери вместе с замком. Теперь ничто не мешает мне зайти в квартиру.]];
    elseif v==house1level2_flat2 and s._rope and not s._door then
      s._door=true;
      return "Я привязал шланг к ручке двери квартиры 22.";
    elseif v==house1level2_flat2 and s._rope and s._door then
      return "Шланг уже привязан к ручке двери квартиры 22.";
    else
      return [[Я едва приподнимаю камень, так у меня ничего не получится.]]
    end
  end,
  cnd = function(s)
    return not house1level2_flat2._open;
  end
}

--street3
street3 = room {
  nam = "На улице",
  pic = "gfx/street3.jpg",
  exit = function(s,t)
    if t ~= street2 and not zombi2._dead then
      return walk(gameover1);
    end
  end,
  dsc = [[Я стою посреди пустынной улицы.]],  
  obj = { "street3house1", "street3house2", "street3car", "street3street", "zombi2" },
  way = { vroom("Машина", "car"), vroom("Склад","warehouse1"), vroom("Жилой дом","house2level1"), vroom("Вверх по улице","street2"), vroom("Вниз по улице","street4") }
}

street3house1 = obj {
  nam = "street3house1",
  dsc = [[С левой стороны улицы стоят два дома. {Один дом} с заколоченными окнами похож на какой-то склад.]],
  act = [[Возможно, раньше здесь была продовольственная база.]]
}

street3house2 = obj {
  nam = "street3house2",
  dsc = [[Дверь {другого дома}, похожего на жилой, открыта.]],
  act = [[Это похоже на жилой дом, хотя я не уверен.]]
}

street3car = obj {
  nam = "street3car",
  dsc = [[C правой стороны улицы стоит {обгорелая машина}.]],
  act = [[Кажется, она взорвалась.]]
}

street3street = obj {
  nam = "street3street",
  dsc = [[Я могу пойти вниз или вверх по {улице}.]],
  act = [[Я уже вижу конец улицы впереди.]]
}

zombi2 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi2",
  act = function(s)
    if not s._dead then
      return "Это заражённый, дальше мне не пройти!";
    else
      return "Я обыскал труп заражённого, но ничего не нашёл.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[Посреди дороги лежит {труп заражённого}, которого я застрелил.]];
    else
      return 
          [[^Прямо посреди дороги стоит высокий мужчина. Он странно покачивается и издает звуки,
            напоминающие то ли стон, то ли хрип. Это {заражённый}!]];
    end
  end
}

--car
car = room {
  nam = "На улице",
  pic = "gfx/car.jpg",
  dsc = [[Я залез в сожжённую машину. Практически весь салон оплавился.]],
  obj = { "car_armbox", "car_box" },
  way = { vroom("Улица","street3") }
}

car_armbox = obj {
  nam = "car_armbox",
  dsc = [[Под моей правой рукой -- {подлокотник}.]],
  act = [[Подлокотник пуст.]]
}

car_box = obj {
  _open = false,
  nam = "car_box",
  dsc = [[С пассажирской стороны есть {бардачок}.]],
  act = function(s)
    if not s._open then
      return [[Крышка бардачка оплавилась и просто так не открывается.]];
    else
      return [[Я взломал крышку бардачка, и теперь бардачок открыт, однако внутри больше нет ничего полезного.]]
    end
  end
}

--house2level1
house2level1 = room {
  nam = "Первый этаж",
  pic = "gfx/emptyhouse2.jpg",
  dsc = [[Я стою посреди широкого помещения с ободранными стенами. Прямо в центре возвышается кирпичная колонна. Здесь всё завалено мусором.]],
  obj = { "oldman" },
  way = { vroom("Улица","street3"), vroom("Второй этаж", "house2level2") }
}

oldman = obj {
  _food = false,
  _first = false,
  nam = "Пожилой мужчина",
  dsc = [[Рядом с лестницей на второй этаж стоит {пожилой мужчина} в затёртой куртке. Я сразу вижу -- он не заражён.]],
  act = function(s)
    if not s._first then
      s._first = true;
      return walk(oldman_dlg1);
    elseif s._food then
      return "Говорить нам больше не о чем, каждый получил что хотел.";
    else
      return [[Он явно не хочет больше разговаривать. По крайней мере, пока я не принесу ему что-нибудь в обмен на ключ.]];
    end
  end,
  cnd = function(s)
    return not bottle._taken;
  end
}

oldman_dlg1 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_dialog1.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = function(s)
    theme.set("scr.gfx.bg", "theme/bg.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 238);
    theme.set("win.w", 432);
    theme.set("win.h", 352);
    walk(house2level1);
  end,
  dsc = [[-- Привет! -- сказал я.^
          -- Привет-привет, -- ответил старик. -- Давно к нам новенькие на захаживали. Какими судьбами?^
          -- Просто прохожу через город, думал найти какое-нибудь продовольствие.^
          -- Продовольствие! -- усмехнулся старик. -- Кому ж это сейчас не нужно! Только вот, боюсь, у нас беда
          произошла. На продовольственную базу заражённые проникли. Пришлось опечатать.^
          -- И всё продовольствие теперь потеряно? -- спросил я. -- Заражено?^
          -- Отчего же? Продовольствие в отдельной комнате, заперто. И там дверь такая, что никакой заражённый
          не проломит. А у меня ключик от двери есть. Только вот соваться я туда не намерен, там этих жмуриков
          туча.^
          -- А дай-ка мне ключ, -- предложил я. -- Может, у меня что и выйдет. А добычу поделим.^
          -- Ну уж, нет, -- ответил старик. -- Ты извини, брат, но я тебя впервые вижу и доверять тебе не буду.
          А мне, знаешь ли, тоже жрать хочется. Так что за просто так я тебе ключик не отдам.]],
  obj = { 
    vobj("next", '{Вернуться}')
  }
}

oldman_dlg2 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_dialog1.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = function(s)
    theme.set("scr.gfx.bg", "theme/bg.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 238);
    theme.set("win.w", 432);
    theme.set("win.h", 352);
    walk(house2level1);
  end,
  dsc = [[-- А давай так, -- предложил я, -- я тебе отдам эту банку бобов, а ты мне -- ключ. Когда я заберу продовольствие
          со склада, если у меня, конечно, это получится, то ещё и поделимся.^
          -- А не обманешь? -- с сомнением спросил старик.^
          -- Не обману, -- ответил я. -- Да и какой смысл тебе ключ держать? Сам же ты туда соваться не собираешься, как я понял.^
          -- Эх, ладно, -- согласился старик. -- Уговорил. Давай сюда свои бобы. Но смотри, не обмани. -- И посмотрел на меня как-то хитро.^
          Мы обменялись.]],
  obj = { 
    vobj("next", '{Вернуться}')
  }
}


--house2level1
house2level2 = room {
  nam = "Второй этаж",
  pic = "gfx/emptyhouse1.jpg",
  enter = function(s)
    if not bottle._taken then
      p "-- Куда это ты направился? -- спрашивает старик. -- Тебе там делать нечего!";
      return false;
    end
  end,
  exit = function(s)
    if not zombi11._dead then
      return walk(gameover1);
    end
  end,
  dsc = [[Я оказываюсь в грязном зловонном помещении, где всё завалено мусором.]],
  obj = { "house2level2_table", "house2level2_box1", "house2level2_box2", "house2level2_beans", "zombi11" },
  way = { vroom("Первый этаж", "house2level1") }
}

house2level2_table = obj {
  _taken = false,
  nam = "house2level2_table",
  dsc = "У разбитого окна лежит {перевёрнутый стол}.",
  act = function(s)
    if s._taken then
      return "В столе больше ничего нет.";
    else
      s._taken=true;
      gun._load=gun._load+1;
      return "Я нашёл в столе один патрон.";
    end
  end
}

house2level2_box1 = obj {
  nam = "house2level2_box1",
  dsc = "У стены стоит {ящик}.",
  act = "В ящике ничего нет."
}

house2level2_box2 = obj {
  nam = "house2level2_box2",
  dsc = "Прямо у меня под ногами валяется {коробка}.",
  act = "Коробка пустая."
}

house2level2_beans = obj {
  nam = "house2level2_beans",
  dsc = "Рядом с коробкой лежит пустая {консерва из-под бобов}.",
  act = [[Наверное, еда была заражена. Не может быть! Возможно, я не заметил какой-нибудь дыры в консерве.
          Этот человек заразился из-за меня!]]
}

zombi11 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi11",
  act = function(s)
    if not s._dead then
      return [[Он как будто не видит меня. Заражение произошло совсем недавно, и он пока что как будто в ступоре.
               Однако, кто знает, быть может, пройдёт лишь пара секунд, и он придёт в себя. Мне нельзя терять времени!]];
    else
      return "Я обыскал труп, но ничего не нашёл.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[На полу лежит {труп заражённого}, который был когда-то хозяином этой халупы. И погиб из-за банки бобов.]];
    else
      return [[^Выход из комнаты преграждает {пожилой мужчина}, который отправил меня на склад. Но с ним что-то не то...
               Руки у него трясутся, а глаза стали мутными. По подбородку стекает слюна. Он заразился!]];
    end
  end
}

--warehouse1
warehouse1 = room {
  _open = false,
  nam = "У склада",
  pic = "gfx/street3.jpg",
  dsc = [[Я стою у входа на склад. Это небольшое двухэтажное здание, все окна которого забиты досками.]],
  obj = { "warehouse1_entrance", "warehouse1_bin" },
  way = { vroom("Склад", "warehouse2"), vroom("Улица", "street3") }
}

warehouse1_entrance = obj {
  _open = false,
  nam = "warehouse1_entrance",
  pic = "gfx/street3.jpg",
  dsc = function(s)
    if not s._open then
      return [[{Дверь}, преграждающая вход, также заколочена досками. Без специальных инструментов тут не обойдёшься.]];
    else
      return "{Дверь} на склад открыта.";
    end
  end,
  act = function(s)
    if not s._open then
      return [[Дверь, преграждающая вход, также заколочена досками. Без специальных инструментов тут не обойдёшься.]];
    else
      return "На склад можно зайти.";
    end
  end
}

warehouse1_bin = obj {
  nam = "warehouse1_bin",
  dsc = [[У двери стоит большое {мусорное ведро}.]],
  act = [[Превозмогая отвращение, я осмотрел мусорное ведро, но не нашел ничего нужного.]]
}

--warehouse2
warehouse2 = room {
  nam = "Склад",
  pic = "gfx/warehouse1.jpg",
  enter = function(s,v)
    if plant._took then
      p "Стоит держаться оттуда подальше. Там множество заражённых!";
      return false;
    end
    if not have(key2) then
      p "Я не уверен, что стоит туда идти. Наверное, это здание опечатали неспроста.";
      return false;
    end
    if not warehouse1_entrance._open then 
      p "Сначала надо как-то выломать дверь.";
      return false;
    end
  end,
  exit = function(s,v)
    if not zombi6._dead and v~=warehouse1 then
      return walk(gameover1);
    end
  end,
  dsc = [[Я нахожусь в большом помещении с кирпичными стенами. Здесь холодно и сыро. К тому же из-за заколоченных досками
          окно в помещении совсем мало света.]],
  obj = { "warehouse2_door", "zombi6" },
  way = { vroom("Улица","warehouse1"), vroom("Второе помещение","warehouse3") }
}

warehouse2_door = obj {
  nam = "warehouse2door",
  dsc = [[Здесь есть {проход} во вторую часть помещения.]],
  act = [[Проход открыт, дверь снесена с петель.]]
}

zombi6 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi6",
  act = function(s)
    if not s._dead then
      return "Нужно стрелять! Нельзя медлить!";
    else
      return "У заражённого ничего нет.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[В правом углу лежит {труп заражённого}.]];
    else
      return 
          [[^Из дальнего угла помещения на меня медленно идёт {заражённый} с мутными глазами. Нельзя медлить!]];
    end
  end
}

--warehouse3
warehouse3 = room {
  nam = "Склад",
  pic = "gfx/warehouse2.jpg",
  exit = function(s,v)
    if v==warehouse2 and bottle._taken and (not zombi7._dead or not zombi8._dead or not zombi9._dead) then
      return walk(gameover1);
    end
  end,
  dsc = [[Я стою посреди широкого помещения, заставленного ящиками. Это место совершенно не похоже на продовольственную базу.
          Скорее, это строительный склад.]],
  obj = { "warehouse3_boxes", "warehouse3_entrance", "warehouse3_stairs", "manyzombi", "zombi7", "zombi8", "zombi9" },
  way = { vroom("Первое помещение","warehouse2"), vroom("Кладовая","warehouse4"), vroom("Второй этаж", "warehouse5") }
}

warehouse3_boxes = obj {
  nam = "warehouse3_boxes",
  dsc = [[У стены впереди меня стоят {ящики}.]],
  act = function(s)
    if bottle._taken and (not zombi7._dead or not zombi8._dead or not zombi9._dead) then
      return walk(gameover1);
    else
      return [[Я внимательно осмотрел ящики и ничего не нашёл. Ящики абсолютно пустые.]];
    end
  end
}

warehouse3_entrance = obj {
  _open = false,
  nam = "warehouse3_entrance",
  dsc = [[Слева от меня -- железная {дверь}, похожая на дверь в кладовую.]],
  act = function(s)
    if bottle._taken and (not zombi7._dead or not zombi8._dead or not zombi9._dead) then
      return walk(gameover1);
    elseif not s._open then
      return [[Должно быть, это то самое место, о котором говорил старик. Надо попробовать открыть её ключом.]];
    else
      return [[Дверь открыта, я могу зайти.]];
    end
  end
}

warehouse3_stairs = obj {
  _open = false,
  nam = "warehouse3_stairs",
  dsc = [[Справа -- {лестница} на второй этаж.]],
  act = "Лестница крепкая, по ней можно безопасно подняться."
}

manyzombi = obj {
  nam = "manyzombi",
  dsc = "^Пока меня не было, здесь появилось несколько заражённых!",
  cnd = function(s)
    return bottle._taken;
  end
}

zombi7 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi7",
  act = function(s)
    if not s._dead then
      return "Нужно стрелять! Нельзя медлить!";
    else
      return "У заражённого ничего нет.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[У выход на улицу лежит {труп заражённого}.]];
    else
      return [[{Заражённый мужчина} стоит в дальнем конце помещения и преграждает выход на улицу.]];
    end
  end,
  cnd = function(s)
    return bottle._taken;
  end
}

zombi8 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi8",
  act = function(s)
    if not s._dead then
      return "Нужно стрелять! Нельзя медлить!";
    else
      return "У заражённого ничего нет.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[Неподалеку от входа в кладовку валяется {застреленный заражённый}.]];
    else
      return [[{Заражённая женщина} с окровавленными волосами медленно приближается ко мне, вытянув дрожащие исцарапанные руки.]];
    end
  end,
  cnd = function(s)
    return bottle._taken;
  end
}

zombi9 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi9",
  act = function(s)
    if not s._dead then
      return "Нужно стрелять! Нельзя медлить!";
    else
      return "У заражённого ничего нет.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[На полу лежит {труп заражённого}.]];
    else
      return [[{Однорукий заражённый} стоит прямо посреди комнаты. Мне не пройти мимо него!]];
    end
  end,
  cnd = function(s)
    return bottle._taken;
  end
}

--warehouse4
warehouse4 = room {
  nam = "Склад",
  pic = "gfx/warehouse3.jpg",
  enter = function(s)
    if not warehouse3_entrance._open then
      p "Дверь заперта на ключ.";
      return false;
    end
  end,
  dsc = [[Я оказался в небольшой комнатке, которая вся заставлена высокими металлическими шкафами. Однако на полках ничего нет.
          Старик обманул меня! Здесь никогда не было продовольствия!]],
  obj = { "warehouse4_box", "bottle" },
  way = { vroom("Выйти","warehouse3") }
}

warehouse4_box = obj {
  _open = false,
  nam = "warehouse4_box",
  dsc = [[У дальней стены стоит фанерный {ящик}.]],
  act = function(s)
    if not s._open then
      return "У меня никак не получается открыть ящик руками.";
    else
      return [[В ящике ничего нет.]];
    end
  end
}

--warehouse5
warehouse5 = room {
  nam = "Склад",
  enter = function(s)
    if not have(bottle) then
      p "Думаю, стоит сначала осмотреть этот этаж.";
      return false;
    end
  end,
  pic = "gfx/warehouse4.jpg",
  dsc = [[Я нахожусь на втором этаже. Здесь совсем пусто -- нет даже шкафов и ящиков.]],
  obj = { "warehouse5_left", "doska" },
  way = { vroom("Первый этаж","warehouse3"),vroom("Комната","warehouse6") }
}

warehouse5_left = obj {
  nam = "warehouse5_left",
  dsc = "Я могу пройти {налево} -- там есть ещё одна комната.",
  act = "Больше мне идти некуда, внизу меня ждут заражённые. Ещё немного -- и они будут здесь. Надо торопиться!"
}

doska = obj {
  nam = "Доска",
  dsc = [[На полу валяется длинная {доска}.]],
  tak = "Я поднимаю доску, хотя она довольно тяжёлая.",
  use = function(s,v)
    if not zombi10._dead then
      return walk(gameover);
    elseif v==warehouse6_window then
      warehouse6_window._bridge=true;
      remove(s,me());
      return [[Я просунул доску в выломанное окно. Послышался звон. Доска оказалась достаточно длинной, я дотянулся до
               стены соседнего здания, и разбил там окно. Теперь путь открыт.]];
    end
  end
}

--warehouse6
function doska_fun()
  if warehouse6_window._bridge then
    return "Доска";
  end
end

warehouse6 = room {
  nam = "Склад",
  pic = "gfx/warehouse5.jpg",
  dsc = [[Я оказался в маленькой комнатке, которая вся завалена мусором, разбитым стеклом и сломанной мебелью.]],
  obj = { "warehouse6_window", "zombi10" },
  way = { vroom(doska_fun, "bridge"), vroom("Выйти","warehouse5") }
}

warehouse6_window = obj {
  _bridge = false,
  nam = "warehouse6_window",
  dsc = function(s)
    if not zombi10._dead then
      return "В комнате есть {широкое окно}, однако оно заколочено досками.";
    elseif not s._bridge then
      return "В комнате есть широкое {выбитое окно}, в которое только что вылетел заражённый.";
    else
      return "В комнате есть широкое {окно}, через которое перекинута доска.";
    end
  end,
  act = function(s)
    if not zombi10._dead then
      return walk(gameover1);
    elseif not s._bridge then
      return [[Окно открыто. Соседнее здание стоит совсем близко, причём окно в стене соседнего здания незакрыто.
               В теории я мог бы попробовать как-нибудь перескочить туда, но допрыгнуть не получится. Надо что-то
               придумать.]];
    else
      return "В соседнее здание перекинута доска. Осталось только пройти по ней.";
    end
  end
}

zombi10 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi10",
  act = "У меня есть только один выстрел.",
  dsc = [[^Прямо передо мной стоит {заражённый}! Он готов в любую секунду броситься на меня.]],
  cnd = function(s)
    return not s._dead;
  end
}

--bridge
bridge = room {
  nam = "Мост",
  pic = "gfx/bridge.jpg",
  enter = function(s)
    if not warehouse6_window._bridge then
      p "Пока что мне туда никак не попасть.";
      return false;
    end
  end,
  dsc = [[Я уже начал вылезать из окна, как вдруг за спиной послышался чей-то хрип. Заражённые! Они уже здесь!
          Я спешно через через окно и встал на висящую на улицей доску. Доска прогибалась под моим весом. Я был так
          взволнован, что не сразу заметил, что поцарапал плечо, пока вылезал. Заражённая кровь! Значит, и я теперь
          заражён тоже! Вируса в крови пока не очень много, но...]],
  obj = { "bridge_stand1", "bridge_stand2" },
  way = { vroom("Обратно","gameover1"), vroom("Соседнее здание","house2level2") }
}

bridge_stand1 = obj {
  nam = "bridge_stand1",
  dsc = [[Я стою на доске над улицей. Позади меня слышатся {хрипы заражённых}.]],
  act = "Я надеюсь, что они не полезут на эту доску."
}

bridge_stand2 = obj {
  nam = "bridge_stand2",
  dsc = [[Впереди меня -- {разбитое окно} соседнего здания.]],
  act = "Всего несколько шагов, и я там!"
}

--street4
street4 = room {
  nam = "На улице",
  exit = function(s,v)
    local cango = plant._took or (not girl._first and zombi10._dead);
    if v==ending1 and not cango then
      p "Уходить пока рано.";
      return false;
    end
  end,
  pic = "gfx/street4.jpg",
  dsc = [[Здесь город заканчивается, дальше начинается автострада, но уходить мне пока рано.]],
  obj = { "street4debris" },
  way = { vroom("Пустырь","debris1"), vroom("Вверх по улице","street3"), vroom("Автострада", "ending1") }
}

street4debris = obj {
  nam = "street4debris",
  dsc = [[С левой стороны улицы простирается огромный {пустырь} или свалка, огороженный решетчатым забором.]],
  act = [[Ограда местами обвалилась, туда можно проникнуть.]]
}

--debris1
debris1 = room {
  nam = "Пустырь",
  pic = "gfx/debris1.jpg",
  exit = function(s,v)
    if v==debris2 and not zombi3._dead then
      return walk("gameover1");
    end
  end,
  dsc = [[Я стою посреди пустыря. Невозможно понять, что здесь было раньше. Пустырь весьма обширен и продолжается дальше.]],
  obj = { "debris1_plants", "zombi3" },
  way = { vroom("Конец пустыря","debris2"), vroom("Улица","street4") }
}

debris1_plants = obj {
  nam = "debris1_plants",
  dsc = [[Слева от меня есть какие-то {странные растения}.]],
  act = function(s,v)
    if v==debris2 and not zombi3._dead then
      return walk("gameover1");
    else
      return [[Растение напоминает какой-то бутон или плод в окружении зелёных листьев. Не представляю, что это такое.
          Однако кто-то прошёлся по этим растениям ногами, и все бутоны раздавлены.]];
    end
  end
}

zombi3 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi3",
  act = function(s)
    if not s._dead then
      return "Стреляй в голову, а потом -- думай, вот мой девиз!";
    else
      return "Я обыскал труп заражённой, но ничего не нашёл.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[Неподалёку от растоптанных растений лежит {труп заражённой}.]];
    else
      return 
          [[^Дорогу вперёд мне преграждает {невысокая женщина}. Достаточно одного взгляда, чтобы понять, что она заражена.]];
    end
  end
}

--debris2
debris2 = room {
  nam = "Пустырь",
  pic = "gfx/debris2.jpg",
  dsc = [[Я дошёл почти до самого конца пустыря. Повсюду валяется мусор.]],
  obj = { "zombi4", "zombi5" },
  way = { vroom("Начало пустыря","debris1") }
}

zombi4 = obj {
  _dead = false,
  zombi = true,
  nam = "zombi4",
  act = function(s)
    if not s._dead then
      return "Нет времени на раздумья, надо стрелять!";
    else
      if not zombi5._dead then
        return "Пока я буду его обыскивать на меня набросится другой заражённый.";
      else
        return "Я обыскал труп заражённого, но ничего не нашёл.";
      end
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[Неподалеку от меня валяется застреленный {заражённый}.]];
    else
      return 
          [[Слева от меня стоит {заражённый} в грязной оборванной одежде и с окровавленной головой.]];
    end
  end
}

zombi5 = obj {
  _dead = false,
  _empty = false,
  zombi = true,
  nam = "zombi5",
  act = function(s)
    if not s._dead then
      return "Ещё несколько секунд, и он набросится на меня!";
    elseif s._dead and not s._empty then
      if zombi4._dead then
        take(key);
        s._empty = true;
        return "Я обыскал труп заражённого и нашел в одном из его карманов ключ.";
      else
        return "Пока я буду его обыскивать на меня набросится другой заражённый.";
      end
    else
      return "Я больше ничего не нахожу у этого заражённого.";
    end
  end,
  dsc = function(s)
    if s._dead then
      return [[Справа лежит {труп заражённого}.]];
    else
      return 
          [[{Заражённый справа} от меня уже почуял моё приближение и возбуждённо дёргает головой.]];
    end
  end
}

--endings
ending1 = room {
  nam = "",
  hideinv = true,
  enter = function(s)
    if not girl._first then
      walk("ending4");
    end
  end,
  entered = function(s)
    set_music("sadend.ogg");
    theme.set("scr.gfx.bg", "theme/bg_end1.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  dsc = function(s)
    if street2._fall then
      return
        [[Только так и выживают в нашем мире -- каждый сам за себя. Я отдал бы бутон девушке, но... Когда на карту поставлена
          собственная жизнь, всё меняется. Может быть, когда-нибудь мне станет стыдно за этот поступок. А может быть, и не станет.
          В конце концов, я просто пытаюсь выжить.^
          Кстати, ногу я не сломал. Это был просто ушиб, и через несколько дней нога перестала болеть. А я продолжил свой путь
          на север.^^
          КОНЕЦ.]]
    else
      return
        [[Только так и выживают в нашем мире -- каждый сам за себя. Я отдал бы бутон девушке, но... Когда на карту поставлена
          собственная жизнь, всё меняется. Может быть, когда-нибудь мне станет стыдно за этот поступок. А может быть, и не станет.
          В конце концов, я просто пытаюсь выжить.^^
          КОНЕЦ.]]
    end
  end
}

ending2 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    set_music("sadend.ogg");
    theme.set("scr.gfx.bg", "theme/bg_end1.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  dsc = function(s)
    if street2._fall then
      return
        [[Я отдал девушке бутон и медленно побрёл по улице. Каждый шаг отзывался болью во всём теле, и я подволакивал ногу,
          как заражённый. Я не знал, сколько у меня оставалось времени -- несколько часов, быть может, дней? Всё, что я знал -- это
          то, что в конце своей жизни я сделал хоть одно доброе дело.^^
          КОНЕЦ.]];
    else
      return
        [[Я отдал девушке бутон и медленно побрёл по улице. Совсем скоро я стану заражённым. Я не знал, сколько у меня оставалось
          времени -- несколько часов, быть может, дней? Всё, что я знал -- это то, что в конце своей жизни я сделал хоть одно доброе дело.^^
          КОНЕЦ.]];
    end
  end
}

ending3 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    theme.set("scr.gfx.bg", "theme/bg_end3.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
    set_music("happyend.ogg");
  end,
  dsc = function(s)
    if street2._fall then
      return
        [[Через несколько дней я уже был в порядке. Ногу я не сломал, обошлось. Мы собрались и покинули город рано утром, взяв
          с собой только всё самое необходимое.^
          Несмотря на то, что мы оба съели бутоны, ещё неделю меня мучили кошмары -- я боялся, что стану заражённым. Однако всё
          обошлось. Мы не были больны.^
          Я не знаю, ждёт ли нас в действительности что-нибудь на юге, или это и правда глупая сказка, придуманная отчаявшимися
          людьми, как я считал раньше. Но в конце концов всем нам нужно во что-то верить. В противном случае жизнь превратится
          лишь в пустое бесцельное выживание.^
          И теперь я тоже верю. Я верю, что мы дойдём. Я верю, что там нас ждёт новая длинная жизнь.^^
          КОНЕЦ.]];
    else
      return
        [[Мы собрались и покинули город рано утром, взяв с собой только всё самое необходимое.^
          Несмотря на то, что мы оба съели бутоны, ещё неделю меня мучили кошмары -- я боялся, что стану заражённым. Однако всё
          обошлось. Мы не были больны.^
          Я не знаю, ждёт ли нас в действительности что-нибудь на юге, или это и правда глупая сказка, придуманная отчаявшимися
          людьми, как я считал раньше. Но в конце концов всем нам нужно во что-то верить. В противном случае жизнь превратится
          лишь в пустое бесцельное ожидание.^
          И теперь я тоже верю. Я верю, что мы дойдём. Я верю, что там нас ждёт новая длинная жизнь.^^
          КОНЕЦ.]];
    end
  end
}

ending4 = room {
  nam = "",
  hideinv = true,
  entered = function(s)
    set_music("sadend.ogg");
    theme.set("scr.gfx.bg", "theme/bg_end1.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  dsc = [[И снова неудача! Этот город не дал мне ничего. Я не нашёл продовольствия и едва не погиб. И к тому же -- заразился.
          Я не знаю, сколько мне осталось. Я не знаю, есть ли лекарство. Быть может, всё обошлось, и я всё-таки не стану заражённым?
          Но умом я понимаю, что это лишь бессмысленная надежда. Такая же, как мечты о юге.^^
          КОНЕЦ.]]
}

gameover1 = room {
  nam = "Конец",
  hideinv = true,
  entered = function(s)
    set_music("death.ogg");
    theme.set("scr.gfx.bg", "theme/bg_end2.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = stead.restart,
  dsc = [[Заражённый набросился на меня и... В общем, так и закончилась моя история. Или всё было иначе?]],
  obj = { 
    vobj("replay", '{Переиграть}')
  }
}

gameover2 = room {
  nam = "Конец",
  hideinv = true,
  entered = function(s)
    set_music("death.ogg");
    theme.set("scr.gfx.bg", "theme/bg_end2.jpg");
    theme.set("win.x", 40);
    theme.set("win.y", 44);
    theme.set("win.w", 432);
    theme.set("win.h", 502);
  end,
  act = stead.restart,
  dsc = [[Я попытался ударить заражённого, забыв от страха, что ничего, кроме выстрела в голову, не помогает.
          Заражённый набросился на меня и... В общем, так и закончилась моя история. Или всё было иначе?]],
  obj = { 
    vobj("replay", '{Переиграть}'),
  }
}
