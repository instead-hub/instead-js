-- $Name: Долгая служба$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "xact"

game.use = "Бип-бип! Невозможно выполнить запрошенное действие... Эх, надо было всё-таки обновить прошивку, когда мне говорили."
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

main = timerpause(1100, 1100, "main2");

main2 = room {
   nam = "..."
  ,enter = music_("square",0)
  ,title = { "Д", "О", "Л", "Г", "А", "Я", " ", "С", "Л", "У", "Ж", "Б", "А" }
  ,num = 2
  ,act = function(s) walk("sylo") end
  ,dsc = "Прошло несколько дней с тех пор, как корабль вылетел с Земли. Скоро весь экипаж отправится по своим криокапсулам, а мне предстоит нести самую первую годовую вахту.^Я робот WR001. По документам -- новая модель, недавно вышедшая с конвейера. Однако на самом деле это не совсем так. Где-то там наверху что-то перепутали и вместо того, чтобы отправить меня на пенсию, приписали к этому кораблю под видом новой модели. Мне предстоит десять вахт и путь длиной в тысячу лет.^Надеюсь, у меня ничего не отвалится за это время."
  ,obj = { vobj("next", '{Начать игру}') }
}

sylo = room {
   nam = "Хранилище"
  ,pxa = {
    { "door4", 150 }, 
    { if_("not have(box1) and not box1._done", "box"), 40 },
    { "box2", 320 },
    { "shelf", 415 }
  }
  ,exit= function(s)
     if not box1._done then
       p "Надо сначала составить все эти ящики.";
       return false;
     elseif box1._done and not communice._done then
       p "Лучше сначала ответить на вызов.";
       return false;
     end
   end
  ,dsc = "Я нахожусь в хранилище. Здесь, на ровных полках, лежат разнообразные детали в металлических коробках. Моя задача -- отсортировать коробки в соответствии с номерками на них. Работа почти выполнена."
  ,obj = { "silence", "communice", "boxes", "shelf", "box1", "box2", "emptybox" }
  ,way = { "coridor" }
}

communice = obj {
   _done= false
  ,dsc = "{Передатчик} у меня на груди мигает. Меня кто-то вызывает.^"
  ,act = function(s,v)
     communice._done = true;
     return "Это главный инженер. Он хочет видеть меня в крио-блоке. Что ж, мне надо поторопиться.";
   end
  ,cnd = function(s) return box1._done and not s._done end
}

shelf = obj {
   dsc = function(s)
     if box1._done then
       return "Все коробки стоят на полках. Моя работа здесь закончена.";
     else
       return "На {полке} осталось место для последней коробки.";
     end
   end
  ,act = "Сюда нужно поставить последнюю коробку. Это сложно, но я справлюсь."
}

box1 = obj {
   _done= false
  ,nam = "Коробка 19"
  ,dsc = function(s)
     if not s._done then return "На полу лежит {коробка} под номером 19." end
   end
  ,tak = function(s)
     if not s._done then return "Я поднимаю с пола коробку." end
   end
  ,use = function(s,v)
     if v == shelf then
       s._done = true;
       drop(s);
       return "Я ставлю последнюю коробку на полку. Что ж, моя работа здесь закончена. Вдруг раздаётся протяжный гудок, и передатчик у меня на груди начинает мигать.";
     end
   end
  ,act = "Просто пустой ящик."
  ,inv = "Просто пустой ящик."
}

emptybox = obj {
  act=function()
    return ({"Коробка пуста.","Странно, но тут ничего нет.","Абсолютно пустая коробка.","Видимо, сюда забыли что-то положить.","Пусто!"})[rnd(5)];
  end
}

boxes = obj {
  dsc = function(s)
    local str = "Вся эта комната заставлена металлическими коробками. Коробок очень много, а именно:";
    local i = 0;
    local last = 18;
    if box1._done then 
      last = 19;
    end
    while i < last do
      i = i + 1;
      if i == last then
        str = str.." и";
      end
      if i == 12 then
        str = str.." {box2|коробка "..tostring(i).."}";
      elseif i == 19 then
        str = str.." {box1|коробка "..tostring(i).."}";
      else
        str = str.." {emptybox|коробка "..tostring(i).."}";
      end
      if i < last - 1 then
        str = str..",";
      elseif i == last then
        str = str..".";
      end
    end
    return str;
  end
}

box2 = obj {
   _done= false
  ,nam = "Коробка 12"
  ,act = function(s)
     if not s._done then
       s._done = true;
       take(key);
       return "В коробке оказался гаечный ключ. Недолго думая, я забрал его себе. Надеюсь, его никто не хватится.";
     else
       return "В коробке больше ничего нет.";
     end
   end
}

key = obj {
   nam = "Гаечный ключ"
  ,inv = "Складной гаечный ключ -- удобно и практично."
  ,use = function(s,v)
     if v == hand then
       return "Нет, ничего не получается. Рука испорчена!";
     elseif v == robothand then
       robothand._done = true;
       return "Раз-два -- и готово! Обычный обмен деталями, всё нормально. Мы же роботы в конце концов! Так что теперь у меня блестящая новенькая рука.";
     elseif v == ear then
       ear._fix = true;
       remove(ear,me());
       return "Я прикручиваю отвалившийся модуль обратно в то место, откуда он упал. Что ж, теперь я почти как новый. Почти, да.";
     end
   end
}

coridor = room {
   nam = "Коридор"
  ,pxa = {
    { "door4", 30 }, 
    { if_("not robot._done", "robot_cargo"), 240 },
    { if_("not sylo2._open", "door1", "door1_open"), 370 }, 
  }
  ,enter= function(s)
    if not ear._done then
      ear._done = true;
      p "Я выхожу в коридор, как вдруг из моей спины выпадает какой-то модуль.";
    end
  end
  ,dsc = "Я в коридоре, соединяющем отсеки."
  ,obj = { "silence", "hand", "ear", "robot" }
  ,way = { "sylo", "elevator", "sylo2" }
}

silence = obj {
   dsc = "Здесь на удивление {тихо}."
  ,act = "Я вообще ничего не слышу. Ни малейшего шороха."
  ,cnd = function() return ear._done and not ear._fix end
}

ear = obj {
   _done= false
  ,_fix = false
  ,nam = "Модуль XR304558"
  ,dsc = "На полу валяется {модуль} размером с кирпич. Неужели это выпало из меня?"
  ,inv = "Непонятно, что это за штука. В моих банках памяти ничего нет. Правда, надо сказать, я последнее время о многом стал забывать. В любом случае мне и без этого модуля хорошо."
  ,tak = "Я поднимаю с пола модуль. На нем длинный и непонятный регистрационный номер."
}

robot = obj {
   _done= false
  ,dsc = "По коридору идёт {робот}, мой коллега. Робот несёт в руках огромный металлический контейнер."
  ,act = function(s)
    local str = "Думаю, он идёт в продовольственный отсек. Интересно, как он собирается открыть дверь, когда у него обе руки заняты? Наверное, ему придётся сначала поставить контейнер на пол. Я начинаю следить за роботом из чистого любопытства. Он подходит к двери в продовольственный отсек и..."
    if not ear._fix then
      return str.." дверь сама открывается! Удивительно. Все двери здесь должны быть на магнитном замке.^Робот быстро возвращается из отсека без контейнера, а через несколько минут появляется снова -- с ещё одним огромным ящиком в руках. Что ж, у некоторых работа ещё тяжелее, чем у меня.";
    else
      s._done = true
      return str.." начинает издавать смешные звуки -- пип, пап, пип, пип, пап. На секунду я думаю, что мой коллега сошёл с ума, однако дверь в продовольственный отсек открывается. Удивительно! И почему мне никто не сказал, что так можно."
    end
  end
  ,cnd = function(s) return not s._done end
}

hand = obj {
   _done= false
  ,_fix = false
  ,nam = "Сломанная рука"
  ,dsc = "На полу валяется моя отломавшаяся {правая рука}."
  ,tak = "Я поднимаю свою отвалившуюся руку."
  ,inv = "Она испорчена, совершенно испорчена! От неё теперь никакого прока!"
  ,use = function(s,v)
     if v == robot2 then
       s._fix = true;
       remove(s,me());
       return "Я аккуратненько прикручиваю сломанную руку к своему коллеге. Держится хорошо, да. Работать, конечно, не будет, но это уже детали.";
     end
   end
  ,cnd = function(s) return s._done end
}

elevator = room {
   nam = "Лифт"
  ,pxa = { { "door2", 190 } }
  ,enter= function(s)
    if not hand._done then
      hand._done = true;
      p "Я подхожу к лифту, нажимаю на кнопку вызова и... моя правая рука со встроенным чип-ключом отваливается и падает на пол. Караул! Кошмар! Я начинаю в панике метаться по коридору. Что делать? Как быть? Меня отправят под пресс!";
      return false;
    elseif hand._done and not robothand._done then
      p "Нет! Я не могу являться к начальству в таком виде! Меня тут же отправят в утиль!";
      return false;
    elseif robothand._done and not hand._fix then
      p "Как-то мне неудобно оставлять своего коллегу без руки. К тому же будет понятно, что рука исчезла... благодаря чьим-то стараниям.";
      return false;
    else
      p "Довольный собой, я вызываю лифт, жду несколько минут, напевая недавно выученную мелодию -- пип, пап, пип, пип, пап, -- потом захожу в лифт и... У меня отваливается правая нога! Я с грохотом падаю на пол.^Нет! Не может быть! Мне нельзя появляться перед инженером без ноги!";
    end
  end
  ,dsc = "Я с трудом поднялся и подпрыгиваю на одной ноге."
  ,obj = { "leg" }
}

leg = obj {
   dsc = "Моя отвалившаяся {нога} валяется на полу."
  ,tak = function()
    remove(s,me());
    remove(key,me());
    walk(endgame) 
  end
}

sylo2 = room {
   _open= false
  ,nam  = "Продовольственный отсек"
  ,pxa = {
    { if_("robothand._done and not hand._fix", "robot_nohand", "robot"), 40 },
    { "panel", 180 },
    { "box", 170 },
    { "box", 250 },
    { "shelf", 415 }
  }
  ,enter= function(s)
    if not hand._done then
      p "Нет, мне надо идти к главному инженеру."
      return false
    elseif hand._done and not robot._done then
      p "Дверь в продовольственный отсек закрыта. Я не смогу открыть её без руки.";
      return false;
    elseif not sylo2._open then
      return walk(sylocode);
    end
  end
  ,dsc = "Я в продовольственном отсеке. Здесь всё заставлено здоровыми контейнерами. Как же много собираются есть эти люди после пробуждения!"
  ,obj = { "robot2", "robothand" }
  ,way = { "coridor" }
}

robot2 = obj {
   dsc = "Мой {коллега} стоит у стены и не двигается. Длинный и толстый кабель тянется из его зада к стене."
  ,act = function()
     if robothand._done and not hand._fix then
       return "Мне так стыдно... Я не могу оставить его в таком виде. Всё же коллега...";
     elseif robothand._done and hand._fix then
       return "Можно сказать, так и было. Уверен, он даже не заметит и решит, что его рука просто сломалась.";
     else
       return "Утомился бедняга! И немудрено -- я бы давно рассыпался, если бы таскал такие контейнеры."
     end
   end
}

robothand = obj {
   _done= false
  ,dsc = "Кстати, у него отличная {правая рука}..."
  ,act = "Нет, тут нужны инструменты."
  ,cnd = function(s) return not s._done end
}

function tonecode_(n)
  return function()
    local c = sylocode;
    c._code = c._code..n;
    if string.len(c._code)>=5 then
      if c._code == "01001" then
        sylo2._open = true;
        p "Едва я закончил пищать, как дверь в продовольственный отсек открылась. Эх, до чего же дошла современная техника!";
        walk(coridor);
      else
        c._code = "";
        return "Нет, было как-то не так. Я где-то ошибся.";
      end
    else
      return string.gsub(string.gsub(c._code, "0", "Пип! "), "1", "Пап! ")
    end
  end
end

sylocode = room {
   _code = ""
  ,pxa = { { if_("not sylo2._open", "door1", "door1_open"), 190 } }
  ,nam = "У двери"
  ,dsc = "Я стою у двери в продовольственный отсек. Какие там звуки издавал тот робот? Пип, пап, пап... Нет, как-то не так. Он издавал..."
  ,obj = { "pip", "pap" }
  ,way = { "coridor" }
}

pip = obj {
   dsc = "{Пип!}^"
  ,act = tonecode_(0)
}

pap = obj {
   dsc = "{Пап!}"
  ,act = tonecode_(1)
}

endgame = room {
   nam = "Конец"
  ,enter = function() mute_()(); complete_("longwork")() end
  ,dsc = "Интересно, где бы мне взять исправную ногу?^^"
  ,act = gamefile_("repair.lua")
  ,obj = { vobj("next", txtc("{Продолжение...}")) }
}
