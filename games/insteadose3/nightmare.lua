-- $Name: Банкет$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "timer"
require "xact"
require "hideinv"

game.use = "Пип-Пип! Запрошенная операция невыполнима! Принудительная перезагрузка системы... Ну, вот! Пип!"
local old = obj;
function tcall(f,s)
  if type(f) == "function" then
    return tcall(f(s),s);
  else
    return f;
  end
end
function obj(tab)
  if tab.nam == nil then tab.nam = "" end
  local dsc = tab.dsc;
  tab.dsc = function(s)
    if s.cnd == nil or s:cnd() then
      return tcall(dsc,s);
    end
  end
  return old(tab);
end

main = room {
   nam = "..."
  ,title = {"Б", "А", "Н", "К", "Е", "Т" }
  ,num = 13
  ,enter = music_("square",0)
  ,act = function() walk(hall) end
  ,dsc = "Я -- WR001. Мы с роботами провели жеребьёвку, и мне выпала почётная обязанность -- накрыть стол для праздничного обеда. Ведь сегодня -- особенный день! Люди выходят из своих капсул, а всего через год мы прибываем на место. Со времени нашего отлёта с Земли прошло уже больше тысячи лет. Даже удивительно, что я продержался всё это время..."
  ,obj = { vobj("next", '{Пип-пип!}') }
}

hall = room {
   done = function() return takeflower._take==0 and vase._water and flower._cut end
  ,_call = false
  ,pxa = {
     { "window2", 10 }
    ,{ "table", 110 }
    ,{ if_("takeflower._take<2", if_("takeflower._take==0","vase_flower","vase")), 220 }
    ,{ "communicator", 420 }
   }
  ,nam = "Банкетный зал"
  ,dsc = "Я в банкетном зале. Здесь будет проводиться праздничный обед."
  ,obj = { "communicator", "desk", "takeflower", "takeknife", "takefork", "toiletdoor" }
  ,way = { "coridor", "toilet" }
}

toiletdoor = obj {
   _open = false
  ,dsc = "^В конце зала есть {дверь} в туалет."
  ,act = function(s)
     if s._open then
      return "Из интерфейсного разъёма двери торчит вилка. Пип-пип!";
     else
      return [[Дверь закрыта, а на небольшом табло светится надпись: "Санузел №233 переведён в режим блокировки. Открытие только через порт неотложного доступа."^Порт неотложного доступа находится рядом с дверью -- у него два отверстия, прямо как у моего манипулятора.^Я вставляю в отверстие манипулятор, и дверь открывается. Убираю манипулятор, и дверь закрывается. Пип!]];
     end
   end
}

communicator = obj {
   dsc = "На стене висит {коммуникатор}."
  ,act = function()
    if not hall:done() then
      return "Нет, нужно сначала закончить с сервировкой, а потом приглашать людей. Пип.";
    elseif hall._call then
      return "Я уже позвонил по коммуникатору. Пип.";
    else
      return walk(communicator_dlg);
    end
   end
}

communicator_dlg = dlg {
   nam = "Коммуникатор"
  ,pxa = {
     { "communicator", 220 }
   }
  ,hideinv = true
  ,dsc = "Стандартный коммуникатор."
  ,obj = {
     [1]=phr{ "Пип!", "Пип!", code[[walk(communicator_dlg2)]]}
    ,[2]=phr{ "Пап!", "Пап!", code[[walk(communicator_dlg2)]]}
   }
  ,way = { "hall" }
}

communicator_dlg2 = room {
   nam = "Коммуникатор"
  ,pxa = {
     { "communicator", 220 }
   }
  ,act = function()
    hall._call = true;
    p "Скоро люди появятся. Я мог бы подождать их в коридоре. Пип.";
    walk(hall);
   end
  ,dsc = [[Нет, что это я? Это же не дверь! Пип!^^Внимание! Внимание! Пип! -- говорю я, используя свой стандартный голос №23 -- человеческой особи женского пола двадцати трёх лет. -- Стол готов! Добро пожаловать на праздничный обед! Пип-пип!^^И почему я после каждой фразы вставляю "пип", пип? Что-то не так с моей прошивкой!]]
  ,obj = { vobj("next", '{Пип-пип!}') }
}

desk = obj {
   dsc = function()
      local str = "Посреди зала стоит широкий {обеденный стол}.";
      if not hall:done() then
        str = str.." Стол почти сервирован. Но чего-то всё-таки не хватает."
      else
        str = str.." Стол полностью сервирован."
      end
      return str;
   end,
   act = "Стол заполнен яствами, которые приготовлены, как мне сообщили, из свежайших продуктов. Непонятно правда, откуда здесь взяли свежие продукты? Пип-пип."
}

takeflower = obj {
   _take = 0
  ,nam = "Ваза с цветами"
  ,dsc = function(s)
    if s._take == 2 then
      return;
    end
    local str = "На столе стоит ";
    if s._take == 0 then
      str = str.."{ваза с цветами}.";
    elseif s._take == 1 then
      str = str.."{ваза}.";
    end
    if s._take == 0 then
      if vase._water and not flower._cut then
        str = str.." Как я и предполагал, вода ничуть не помогла. Цветы выглядят всё так же. Может, нужно просто обновить версию их прошивки? Пип-пип."
      elseif vase._water and flower._cut then
        str = str.." Цветы кажутся заметно похорошевшими. Удивительно! Может быть, и мне поможет такая процедура? Пип-пип.";
      else
        str = str.." Цветы почти завяли. Пип.";
      end
    end
    return str;
   end
  ,act = function(s)
     if vase._water and flower._cut then
       return "Цветы выглядят отлично. Больше ничего делать не нужно. Пип.";
     end
     if s._take == 0 then
       s._take = 1;
       take(flower);
       return "Я достаю из вазы цветы. Цветы совсем недавно были сорваны в гидропонике, однако выглядят довольно квело. Пип-пип... Видимо, я о чём-то забыл. Пип.";
     elseif s._take == 1 then
       take(vase);
       s._take = 2;
       return "Я беру со стола вазу. Пип-пип.";
     end
   end
}

vase = obj {
   _water = false
  ,nam = function(s)
    if s._water then return "Ваза с водой" else return "Ваза" end
   end
  ,inv = function(s)
      local str = "Пустая ваза.";
      if s._water then
        str = "Ваза с водой.";
      end
      return str..[[ Интерфейс данной вазы совместим с объектом "цветы". Пип-пип!]];
   end
  ,use = function(s,v)
    if v == washer and not s._water then
      s._water = true;
      return "Вообще я всегда был уверен, что наливать воду в интерфейсные порты -- это плохая идея. Впрочем, люди такие странные. Я немного подумал и заполнил вазу водой. Пип.";
    elseif v == washer and s._water then
      return "Здесь и так полно воды! Пип!";
    elseif v == desk then
      takeflower._take = 1;
      drop(vase, me());
      return "Я ставлю вазу на стол. Пип-пип.";
    end
   end
}

flower = obj {
   _cut = false
  ,nam = function(s)
    if s._cut then return "Цветы с зачищенными контактами" else return "Цветы" end
   end
  ,inv = "Цветы почти завяли, ещё немного -- и их придётся выбросить. Пип."
  ,use = function(s,v)
    if v == vase then
      return "Установка цветов в вазу -- крайне сложная и кропотливая задача. Лучше сначала поставить вазу на стол. Пип.";
    elseif v == desk then
      return "Цветы нужно устанавливать в вазу. Пип-пип!";
    elseif v == takeflower and takeflower._take == 1 then
      takeflower._take = 0;
      drop(flower, me());
      local str = "Это было тяжело, но я справился. Цветы благополучно установлены в вазу, ни один лепесток не пострадал. Пип-пип!";
      if s._cut and vase._water then
        str = str.."^Кажется, цветам это пошло на пользу. Вот что значит зачистить контакты! Пип-пип! Что ж, я всё сделал. Теперь нужно пригласить людей по коммуникатору. Пип-пип!";
      end
      return str;
    end
   end
}

takeknife = obj {
   dsc = "Рядом с блюдами лежат {ножи}"
  ,act = function()
    if have(knife) then
      return "Я уже взял нож, одного мне достаточно. Пип-пип!";
    else
      take(knife);
      return "Я беру со стола нож. Пип.";
    end
   end
}

takefork = obj {
   dsc = "и {вилки}."
  ,act = function()
    if have(fork) then
      return "У меня уже есть вилка. Пип-пип!";
    else
      take(fork);
      return "Я беру со стола вилку. Пип.";
    end
   end
}

knife = obj {
   nam = "Столовый нож"
  ,inv = "Обычный столовый нож, вполне сгодится для того, чтобы что-нибудь отрезать. Пип-пип!"
  ,use = function(s,v)
    if v == flower and not flower._cut then
      flower._cut = true;
      remove(s,me());
      return "Точно! Нужно просто зачистить контакты! И как я не догадался? Пип-пип!^Я срезаю ножом кончики стебельков. Всё готово. Пип.";
    elseif v == flower and flower._cut then
      return "Как я понимаю, люди цветы не едят. Не стоит делать из них салат. Пип-пип!";
    end
   end
}

fork = obj {
   nam = "Вилка"
  ,inv = "Вилка с двумя зубцами, чем-то похожа на мой манипулятор. Пип!"
  ,use = function(s,v)
    if v == toiletdoor and toiletdoor._open then
      return "Из интерфейсного разъёма двери уже торчит вилка. Пип-пип!";
    elseif v == toiletdoor then
      toiletdoor._open = true;
      remove(s,me());
      return "Я вставляю вилку в интерфейсный разъём, и дверь открывается. Пип!";
    end
   end
}

toilet = room {
   nam = "Туалет"
  ,enter = function()
    if not toiletdoor._open then
      p "Дверь в туалет закрыта. Пип-пип!";
      return false;
    end
   end
  ,pxa = {
     { "toilet", 170 }
    ,{ "washer", 260 }
   }
  ,dsc = "Туалет. Роботы не пользуются туалетом. Пип!"
  ,obj = { "washer", "devices" }
  ,way = { "hall" }
}

washer = obj {
   dsc = "У стены стоит раковина с {краном}."
  ,act = "Вода есть. Как хорошо, когда всё работает! Пип-пип!"
}

devices = obj {
   dsc = "Здесь есть также остальные {устройства}, которыми не пользуются роботы."
  ,act = "С помощью этих устройств люди, видимо, сливают своё использованное масло. Или что там у них... Пип!"
}

coridor = room {
   _wait = 0
  ,nam = "Коридор"
  ,enter = function(s)
    if not hall:done() then
      p "Нет, пока я ещё не всё закончил. Пип-пип!";
      return false;
    elseif hall:done() and not hall._call then
      p "Надо сначала пригласить в банкетный зал людей. Пип-пип!";
      return false;
    end
   end
  ,pxa = {
     { "robot", 10 }
    ,{ "hatch2", 100 }
    ,{ if_("coridor._wait>0","rat"), 395 }
    ,{ if_("coridor._wait>1","rat"), 185 }
    ,{ if_("coridor._wait>2","rat"), 460 }
    ,{ if_("coridor._wait>2","rat"), 240 }
    ,{ if_("coridor._wait>3","rat"), 120 }
    --,{ if_("coridor._wait>3","rat"), 270 }
    ,{ if_("coridor._wait>3","rat"), 320 }
   }
  ,dsc = "Передо мной длинный пустой коридор. Пип-пип."
  ,obj = { "coridorstat" }
}

coridorstat = obj {
   dsc = function()
    if coridor._wait == 0 then
      return "Пока ещё никого нет. Надо немного {подождать}. Пип...";
    elseif coridor._wait == 1 then
      music_("spookyloop",0)();
      return "В коридоре появилась жирная крыса. Крыса смотрит на меня недобрым взглядом. {Пип-пип}!";
    elseif coridor._wait == 2 then
      return "Теперь передо мной две крысы. Что они здесь делают? Надеюсь, люди {скоро появятся}. Меня пугают эти злобные твари! Пип-пип!";
    elseif coridor._wait == 3 then
      return "Передо мной собралась целая стая жирных крыс. Они сидят и просверивают меня своими злобными красными глазищами. {Где же люди}? Пип!";
    elseif coridor._wait == 4 then
      return "Нет, не может быть! Весь коридор заполнен крысами! Пип! Пип-пип! Пип! Это какой-то кошмар! Такого не может быть! {Пип-пип}!";
    end
   end
  ,act = function()
    coridor._wait = coridor._wait + 1;
    if coridor._wait == 5 then
      return walk(endgame1);
    else
      return walk(coridor);
    end
   end
}

endgame1 = room {
   nam = "..."
  ,enter = function()
    mute_()();
    complete_("nightmare")();
    remove(fork,me());
    remove(knife,me());
   end
  ,act = function() walk(endgame2) end
  ,pxa = {
    { "robot_nohand", 212 }
   }
  ,dsc = "Пип! Это был всего лишь сон. Ну и намудрили с этой последней прошивкой -- теперь мне даже сны стали сниться. Ещё немного -- и я начну пользоваться человеческим туалетом для слива отработанного масла. Пип-пип!^Однако мне сегодня и правда нужно сервировать стол. Надо бы поторопиться."
  ,obj = { vobj("next", '{Пип-пип!}') }
}

endgame2 = room {
   nam = "Конец"
  ,pxa = {
    { "robot_nohand", 212 }
   }
  ,dsc = "Кстати, а где моя правая рука?"
  ,act = gamefile_("persona.lua")
  ,obj = { vobj("next", txtc("{Пип?}")) }
}