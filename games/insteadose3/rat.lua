-- $Name: Долгая служба$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "xact"

game.use = function(s,v)
  return "Это не есть "..v.nam .."!";
end
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
function vb(o) o.inv = function(s) return s.nam.."!" end; return obj(o) end

main = room {
   nam = "..."
  ,dsc = "Я есть бежать."
  ,act = function()
 walk(start2);
end
  ,obj = { vobj("next", '{Дальше}') }
}

start2 = room {
  nam = "..."
  ,act = function() walk(start3) end
  ,dsc= "Я есть бежать, бежать."
  ,obj = { vobj("next", '{Дальше}') }
}

start3 = room {
  nam = "..."
  ,act = function() walk(start4) end
  ,dsc= "Зубастый гнаться за мной, я не успеть бежать в нора как раньше. Я бежать в какой-то другой нора -- длинный-длинный туннель. Потом ещё один туннель. Потом бежать в ещё один туннель. Потом в ещё один туннель.^Зубастый не отставать, зубастый бежать быстро-быстро."
  ,obj = { vobj("next", '{Дальше}') }
}
start4 = room {
  nam = "..."
  ,enter = music_("daybefore", 0)
  ,title = { "К", "Р", "Ы", "С", "И", "Н", "А", "Я", " ", "Н", "О", "Р", "А" }
  ,num = 1
  ,act = function() take(eat);take(cry);take(th);take(climb);take(cry);walk(floor) end
  ,dsc= "Я бежать мимо человеков, потом бежать в какой-то странный большой нора, который двигаться вверх! Потом я бежать куда-то, где много человеков. Я бояться! Я лезть на ящик. Потом я лезть на ящик. Потом я ещё лезть на ящик. Потом я лезть в потолочный нора. Потом я бежать по потолочный нора -- длинный-длинный нора! Потом я вдруг падать! Больно падать! И вот я здесь..."
  ,obj = { vobj("next", '{Где я?}') }
}

eat = vb {
   nam = "ЖРАТЬ"
  ,use = function(s,v)
    if v==cheesetake or v==cheesetake0 then
      v._on=false;
      return "Сыр вкусно! Могу жрать сколько угодно сыр! Ещё! Ещё!";
    end
  end
}

push = vb {
   nam = "ТОЛКАТЬ"
  ,use = function(s,v)
    if v==cheesetake then
      v._on = false;
      cheesetake0._on = true;
      return "Я толкать сыр. Сыр падать на пол, прямо к двери.";
    elseif v==cheesetake0 then
      return "Некуда толкать!";
    end
  end
}

th = vb {
   nam = "ГРЫЗТЬ"
  ,use = function(s,v)
  if v==cheesetake_stick then
    cheesetake._on = false;
    cheesetake0._on = true;
    return "Я грызть странный скобка. Скобка неожиданно сгибаться, и сыр падать со стола!";
  end
  if v==chair1 or v==chair2 then return "Я грызть стул... Стул есть невкусный! Не еда!" end
  if v==desk1 or v==desk2 then return "Я пытаться грызть стол... Глупый стол! Почти сломать мне зуба!" end
  if v==door then return "Человечий двери не прогрызть! Я пытаться... Терять два, нет... двадцать два зуба!" end
  if v==computer and not v._used then 
    v._used = true;
    return "Я грызть глупый устройство... Невкусно! Но я грызть и грызть. Вдруг чёрный коробка вспыхивать! И появляться в чёрный коробка зверь страшный-страшный -- чёрный шерсть всклокоченный, красный глаза гореть! Страшно!.. А, нет. Это же я.^Потом появляться другой картинка -- железный человек, похожий на мусорный бак заходить в комната! Он вставать у двери и пищать, как я! Пи-па-пи-пи-па! Дверь открываться!"
  elseif v==computer then
    return "Устройство больше не вспыхивать! Всё есть сгрызено. Надо грызть другой устройство!";
  elseif v==foodgen then
    foodgen._ch = not foodgen._ch;
    return "Я грызть большая ручка, и она повернуться!";
  elseif v==foodgen2 then
    if foodgen._ch then
      if cheesetake._on then
        return "Уже есть сыр! Надо жрать! Жрать! Жрать!";
      else
        cheesetake._on=true;
        return "Из устройства выпадать кусочек... сыра!";
      end
    else
      return "Из устройства что-то литься и растекаться по стол!";
    end
  elseif v==cheesetake or v==cheesetake0 then
    return "Сыр надо жрать!";
  end
end
}

cry = vb {
   nam = "ПИЩАТЬ"
  ,use = function(s,v)
    if v==door and computer._used then
      if rat1._on and rat2._on and cheesetake0._on then
        return walk(end1);
      else
        return [[Я пищать на дверь, пищать и пищать. Дверь открываться! Но тут же вновь закрываться! Мерзкий человечий голос говорить: "Не обнаружен объект у двери. Дверь блокируется".]];
      end
    else
      return "Пи-пи! Пи! Пи! Пи!"
    end
  end
}

climb = vb {
   nam = "ЛЕЗТЬ"
  ,use = function(s,v)
  if v==desk1 then return "Стол есть высоко! Не долезть!" end
  if v==shaft1 or v==shaft2 then return "Мне не долезть до потолочный нора!" end
  if v==floor1 then walk(floor) end
  if v==chair1 then walk(onchair) end
  if v==desk2 then walk(ondesk) end
  if v==chair2 then walk(onchair) end
  if v==device2 then walk(oncloner1) end
end
}

floor = room {
   nam = "На полу"
  ,pxa = {
    { "door4", 220 },
    { if_("rat1._on","rat"), 130 },
    { if_("rat2._on","rat"), 180 },
    { if_("rat2._on","rat"), 360 },
    { "column", 70 },
    { "column", 400 }
   }
  ,dsc = "Жилище людей. Пахнуть едой! И не едой..."
  ,obj = { "door", "cheesetake0", "rat1", "rat2", "shaft1", "desk1", "chair1", "device1" }
}

rat1 = obj {
   dsc= function(s)
    if cheesetake0._on then
      return "{Другой Я} сидеть у двери и жрать сыр! Но почему, если другой Я жрать сыр, я по-прежнему голоден?";
    else
      return "{Другой Я} сидеть далеко от двери. Другой Я вращать красными глазами.";
    end
   end
  ,act = "Это Я!"
  ,cnd = function(s) return s._on end
}

rat2 = obj {
   dsc= function(s)
    if cheesetake0._on then
      return "Два {других Я} пытаться отобрать у сыр у другого другого Я!";
    else
      return "Два {других Я} бродить по комнате и вращать красными глазами.";
    end
   end
  ,act = "Это Я!"
  ,cnd = function(s) return s._on end
}

cheesetake0 = obj {
   dsc = "У двери лежит {кусочек сыра}."
  ,act = "Сыр! Вкусно! Жрать!"
  ,cnd = function(s) return s._on end
}

door = obj {
   dsc = "Есть {дверь}."
  ,act = "Дверь есть закрыта!"
}

shaft1 = obj {
   dsc = "Есть потолочная {нора}."
  ,act = "Есть очень высоко-высоко. Нора не долезть. Люди тупой! Потолочная нора неудобно!"
}

desk1 = obj {
   dsc = "Есть {стол} и"
  ,act = "Стол большой."
}

chair1 = obj {
   dsc = "есть {стул}."
  ,act = "Стул! Стул! Лезть!"
}

device1 = obj {
   dsc = "Есть {что-то большой и гудящий}. Он есть похожий на мусорный бак, но в пять... нет в пятьдесят пять раз больше!"
  ,act = "Запах есть плохой. Не есть еда. Надо держаться дальше."
}

onchair = room {
   nam = "На стуле"
  ,pxa = {
    { "column", 455 },
    { "door6", 50 },
    { "shaft", 300 }
  }
  ,dsc = "Я лезть на стул."
  ,obj = { "floor1", "shaft1", "desk2" }
}

floor1 = obj { dsc = "Ниже есть {пол}.", act = "Пол! Слезть!" }

desk2 = obj {
   dsc = "Есть {стол}. Большой стол."
  ,act = "Близко! Совсем близко! Можно лезть! Там есть запах!"
}

ondesk = room {
   nam = "На столе"
  ,pxa = {
     { if_("foodgen._ch", "foodgen2","foodgen"), 0 },
     { if_("cheesetake._on","stick"), 160 },
     { if_("cheesetake._on","cheese"), 160, 130 },
     { "computer", 390 },
   }
  ,dsc = "Я сидеть на стол. Здесь запах!"
  ,obj = { "chair2", "foodgen", "foodgen2", "cheesetake_stick", "cheesetake", "computer", "shaft2", "device2" }
}

cheesetake_stick = obj {
   dsc = "Из стол выдвигаться странный {скобка},"
  ,act = "Странный скобка."
  ,cnd = function(s) return cheesetake._on end
}

cheesetake = obj {
   dsc = "на котором лежать {сыр}!"
  ,act = "Сыр! Вкусно! Жрать! Жрать! Жрать!"
  ,cnd = function(s) return s._on end
}

chair2 = obj {
   dsc = "Ниже стол есть {стул}."
  ,act = "Лезть вниз. Можно!"
}

foodgen = obj {
   dsc = "На стол есть ящик с {длинный ручка} и"
  ,act = "Странно. Пахнуть еда. На устройство надпись: синтезатор... лактоза.. Больше не понимать! Давно ходить школа!"
}

foodgen2 = obj {
   dsc = "{большой кнопка}."
  ,act = "Странный большой кнопка..."
}

computer = obj {
   dsc = "На стол есть ещё один людское {устройство} -- чёрный коробка, много кнопок."
  ,act = "Люди глупый! Это нельзя есть!"
}

device2 = obj {
   dsc = "Рядом со стола есть большой и гудящий {мусорный бак}."
  ,act = "Он страшный. Страшно гудит."
}

shaft2 = obj {
   dsc = "Есть потолочная {нора}."
  ,act = "Потолочная нора уже близко. Почти залезть. Но надо выше. Надо лезть на большой и гудящий."
}

oncloner1 = room {
   nam=""
  ,pxa = { { "cloner", 407 } }
  ,enter = function(s) if rat2._on then p "Мне больше не нужно лезть на мусорный бак.";return false end end
  ,act = function() rat1._on=true; walk(floor) end
  ,dsc = function()
    if rat1._on then
      cheesetake0._on = false;
      rat2._on = true;
      return "Я снова лезть на мусорный бак! Другой Я лезть со мной! Другой я делать то же, что делать я, ведь это я. Мы оба падать в чёрный нора, оба сидеть там, и нас обоих выталкивать. Теперь других Я -- четыре! Много Я!";
    else
      return "Я лезть на мусорный бак. Я почти долезть! Но тут я падать! Падать и падать! Оказываться в какой-то тёмный запертый нора. Я думать -- полный капец. Еда -- нет. Выхода -- нет. Но потом вспышки! Потом меня что-то выталкивать! И вот я опять на полу комната.^Рядом со мной сидеть зверь страшный, со страшными красными глазами... Нет, это же я. Нет, как же? Я сидеть рядом с собой. Я не понимать!"
    end
  end
  ,obj = { vobj("next", '{Дальше}') }
}

end1 = room {
  nam = ""
 ,enter = mute_()
 ,act=function(s) walk(end2) end
 ,pxa = { { "door4", 190 } }
 ,dsc = [[Я пищать пи-па-пи-пи-па, и дверь открываться! Я тут же бежать из комната. Я вдруг думать -- зачем я бежать из комната, ведь там много других Я и много сыра! Но дверь уже закрыться! Я пищать на дверь, но дверь -- "не обнаружено объекта"! Это ужасно!]]
 ,obj = { vobj("next", '{Дальше}') }
}

end2=room{
nam="",
enter=function(s)
timer:set(3000)
end,
dsc=txtc("Спустя несколько часов..."),
timer=function()timer:stop();walk(end3)end
}

end3=room{
  nam="",
  enter=function(s)
  music_("spookyloop")();
  timer:set(3000)
  end,
  pxa = {
    {"cloner",407}, {"rat",10}, {"rat",80}, {"rat",150}, {"rat",220}, {"rat",300}, {"rat",370}
  },
  timer=function()timer:stop();walk(end4)end
}

end4=room{
nam="",
enter=function(s)
timer:set(3000)
end,
pxa = {
{"table5",150}, {"rat",185,75}, {"rat", 301,75}, {"rat",10}, {"rat",80}, {"rat",150}, {"rat",360}, {"rat",440}
},
timer=function()timer:stop();walk(end5)end
}
end5=room{
nam="",
enter=function(s)
timer:set(3000)
end,
pxa = {
{"door4",190}, {"rat",10}, {"rat", 80}, {"rat",150}, {"rat",80}, {"rat",320}, {"rat",390}, {"rat",470}
},
timer=function()timer:stop();walk(end6)end
}
end6=room{
nam="",
enter = function() mute_()(); complete_("rat")() end,
act = gamefile_("longwork.lua"),
obj = { vobj("next", txtc("КОНЕЦ?^^{Это только начало...}")) }
}

