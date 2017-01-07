-- $Name: Ремонт$
-- $Version: 0.1$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "xact"

game.use = "Нет, думаю так делать не стоит."
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
  ,title = { "Р", "Е", "М", "О", "Н", "Т" }
  ,enter = music_("influensa",0)
  ,num = 3
  ,act = function(s) walk("crio") end
  ,dsc = "Ну и дела! Мне через пару часов в холодильник отправляться, а главный инженер меня к себе вызывает -- говорит, неотложные проблемы какие-то, никто кроме меня помочь не может.^Прихожу, а оказывается, что в K007 все криокапсулы отрубились. Ремонт требуется.^-- Ну, а роботы на что? -- спрашиваю я. -- Они же должны такими вещами заниматься.^-- Вот они и постарались, -- говорит главный инженер. -- Пришёл тут один лампочку заменить. Свет горит, да. Но зато весь криоблок отрубился.^Ну и дела!"
  ,obj = { vobj("next", '{Начать игру}') }
}

crio = room {
   _done = false
  ,nam = "К007"
  ,pxa = if_("not darkness:cnd()",
    {
      { "door4", 5 }, 
      { "panel", 150 },
      { "toolbox", 220 },
      { "crio", 310 },
      --{ "crio", 420 }
    })
  ,dsc = "Я в криоблоке К007."
  ,obj = { "darkness", "capsulas", "cinfo", "toolbox", "screw", "flash", "powerbox", "switch" }
  ,way = { vroom("Коридор","endgame") }
}

darkness = obj {
   dsc = "Здесь темно, и я почти ничего не вижу."
  ,cnd = function() return switch._off or redwire._set ~= "red" and bluewire._set ~= "red" and greenwire._set ~= "red" end
}

capsulas = obj {
   _exam = false
  ,dsc = function(s)
     if s:func() then
       return "Кабины {крио-капсул} слабо подсвечиваются синим.";
     else
       return "Здесь стоят шесть {крио-капсул}. Ни один из индикаторов на них не горит, и кабины кажутся чёрными, а должны подсвечиваться, когда капсулы исправны."
     end
   end
  ,act = function(s)
     if not s._exam then
       return "Да, надо бы проверить все эти капсулы. Возможно, трансформаторы перегорели. Но тут потребуются инструменты.";
     else
       if s:func() then
         return "Капсулы работают.";
       else
         return "С самими капсулами всё в порядке. Однако они не работают.";
       end
     end
   end
  ,func= function() return redwire._set == "blue" or ((greenwire._set == "blue" or bluewire._set == "blue") and darkness:cnd()) end
  ,cnd = function(s) return not darkness:cnd() or s:func() end
}

cinfo = obj {
   dsc = "На самой первой капсуле есть маленькая {табличка}."
  ,act = [["Не меньше 2-52". Ну, мне это известно.]]
  ,cnd = function() return not darkness:cnd() end
}

powerbox = obj {
   _open = false
  ,dsc = function(s)
     if darkness:cnd() then
       return "Я едва могу различить очертания {электрического щитка}.";
     else
       local str = "На стене у выхода висит {электрический щиток}."
       if s._open then
         str = str.." Щиток открыт.";
       end
       return str;
     end
   end
  ,act = function(s)
     if capsulas._exam and switch._exam and not s._open then
       return "Крышка щитка привинчена здоровыми винтами.";
     elseif capsulas._exam and switch._exam and s._open then
       walk(electro);
     else
       return "Я не уверен, что мне стоит туда лезть. Там контуры, отвечающие за освещение.";
     end
   end
}

switch = obj {
   _off = false
  ,_exam = false
  ,dsc = function(s)
     local str = "Рядом со щитком есть {выключатель света}. ";
     if s._off then
       return str.."Сейчас свет выключен.";
     else
       return str.."Сейчас свет горит.";
     end
   end
  ,act = function(s)
     if redwire._set ~= "red" and bluewire._set ~= "red" and greenwire._set ~= "red" then
       return "Я нажимаю на кнопку, но ничего не происходит -- свет не работает.";
     else
       if s._off then
         s._off = false;
         return "Я нашарил в темноте кнопку на стене и включил свет. Да, так значительно лучше.";
       else
         s._off = true;
         s._exam = true;
         return "Я нажал на кнопку, и свет во всём отсеке погас.";
       end
     end
   end
}

toolbox = obj {
   _exam= false
  ,dsc = "На полу стоит мой {ящик с инструментами}."
  ,act = function(s)
     if not s._exam then
       s._exam = true;
       return "Я открыл ящик с инструментами.";
     else
       return "Ящик уже открыт.";
     end
   end
  ,cnd = cinfo.cnd
}

screw = obj {
   nam = "Отвёртка"
  ,dsc = "На дне ящика лежит {электрическая отвёртка}."
  ,inv = "Моя любимая электрическая отвёртка. Всегда выручает."
  ,use = function(s,v)
     if v == capsulas then
       if switch._off then
         return "Лучше сначала включить свет.";
       end
       if capsulas._exam then
         return "Я уже проверил капсулы, с ними всё в порядке.";
       else
         capsulas._exam = true;
         return "Я проверяю несколько капсул -- все цепи целы, трансформаторы работают. Непонятно, в чём может быть проблема.";
       end
     elseif v == powerbox then
       if powerbox._open then
         return "Я уже открыл щиток.";
       else
         powerbox._open = true;
         return "Электрическая отвёртка никогда не подводит. Всего за несколько секунд я скрутил все винты и открыл щиток.";
       end
     end
   end
  ,tak = "Я вытащил из ящика отвёртку."
  ,cnd = function() return toolbox:cnd() and toolbox._exam end
}

flash = obj {
   _on = false
  ,nam = "Фонарик"
  ,dsc = function(s)
     if darkness:cnd() then
       return "В темноте слабо поблёскивает мой {фонарик}.";
     else
       return "Из бокового отделения ящика торчит маленький {фонарик}."
     end
   end
  ,inv = function(s)
     local str = "Небольшой фонарик размером с ручку. Света от него немного.^";
     if s._on then
       s._on = false;
       return str.."Я нажимаю на кнопку с тыльной стороны фонарика и выключаю его.";
     else
       s._on = true;
       if here() == crio and (switch._off or redwire._set == "") then
         return str.."Я включаю фонарик, однако это не помогает.";
       else
         return str.."Я включаю фонарик.";
       end
     end
   end
  ,tak = "Я взял фонарик."
  ,cnd = function() return toolbox._exam end
}

electro = room {
   nam = "Щиток"
  ,pxa = { { if_("not nosee:cnd()", "panel"), 215 } }
  ,exit = function(s)
    remove(green,me());
    remove(blue,me());
    remove(red,me());
  end
  ,dsc = "Я стою у открытого щитка. Здесь три провода, которые можно подключать к разным портам."
  ,obj = { "nosee", "bluewire", "greenwire", "redwire", "blueport", "greenport", "redport", "info" }
  ,way = { "crio" }
}

nosee = obj {
   dsc = "Я ничего не вижу. Здесь совсем темно."
  ,cnd = function() return (switch._off or (redwire._set ~= "red" and bluewire._set ~= "red" and greenwire._set ~= "red")) and not flash._on end
}

info = obj {
   dsc = "^На крышке щитка есть маленькая {наклейка}."
  ,act = "Красный -- 2-53, зелёный -- 2-50, синий -- 2-48. Ну, понятно, я всё это и так знаю."
  ,cnd = function() return not nosee:cnd() end
}

function turn(s,str)
  if s._set == "green" then
    return str.."зелёному порту.";
  elseif s._set == "red" then
    return str.."красному порту.";
  elseif s._set == "blue" then
    return str.."синему порту.";
  end
end
bluewire = obj {
   _set= "blue"
  ,dsc = function(s)
     if s._set == "" and have(blue) then
       return "Синий провод ни к чему не подключён.";
     elseif s._set == "" then
       return "{Синий провод} ни к чему не подключён.";
     end
     local str = "{Синий провод} подключён к ";
     return turn(s,str);
   end
  ,act = function(s)
     local o = ref(string.gsub(deref(s), "wire", ""));
     if s._set == "" then
       take(o);
       return "Я беру в руку "..o.alt ..".";
     end
     take(o);
     local app = "";
     if s._set == "red" then
       app = " Внезапно свет в помещении гаснет."
     end
     s._set = "";
     return "Я отсоединяю "..o.alt.." от порта."..app;
   end
  ,cnd = info.cnd
}

greenwire = obj {
   _set= "green"
  ,dsc = function(s)
     if s._set == "" and have(green) then
       return "Отсоединённый зелёный провод торчит из щитка.";
     elseif s._set == "" then
       return "Отсоединённый {зелёный провод} торчит из щитка.";
     end
     local str = "{Зелёный} подключён к ";
     return turn(s,str);
   end
  ,act = bluewire.act
  ,cnd = info.cnd
}

redwire = obj {
   _set= "red"
  ,dsc = function(s)
     if s._set == "" and have(red) then
       return "Красный провод отсоёдинен.";
     elseif s._set == "" then
       return "{Красный провод} отсоёдинен.";
     end
     local str = "А {красный провод} подключён к ";
     return turn(s,str);
   end
  ,act = bluewire.act
  ,cnd = info.cnd
}

blueport = obj {
   dsc = "Всего здесь три порта -- {синий},"
  ,act = function(s)
     local nm = string.gsub(deref(s), "port", "");
     if bluewire._set == nm then
       return "К этому порту подключён синий провод.";
     elseif greenwire._set == nm then
       return "К этому порту подключён зелёный провод.";
     elseif redwire._set == nm then
       return "К этому порту подключён красный провод.";
     else
       return "К этому порту ничего не подключено.";
     end
   end
  ,cnd = info.cnd
}

greenport = obj {
   dsc = "{зелёный} и"
  ,act = blueport.act
  ,cnd = info.cnd
}

redport = obj {
   dsc = "{красный}."
  ,act = blueport.act
  ,cnd = info.cnd
}

blue = obj {
   nam = "Синий провод"
  ,alt = "синий провод"
  ,set = "blue"
  ,inv = function(s)
           return "Я держу в руке "..s.alt..".";
         end
  ,use = function(s,v)
     local o = ref(deref(s).."wire");
     if v == blueport or v == redport or v == greenport then
       local nm = string.gsub(deref(v), "port", "");
       if bluewire._set == nm or redwire._set == nm or greenwire._set == nm then
         return "К этому порту уже подсоединён провод.";
       end
     end
     if v == blueport then
       o._set = "blue";
       remove(s,me());
       return "Я подключаю "..s.alt.." к синему порту.";
     elseif v == redport then
       o._set = "red";
       remove(s,me());
       return "Я подключаю "..s.alt.." к красному порту. Свет в помещении загорается. От неожиданности я даже на секунду зажмуриваю глаза.";
     elseif v == greenport then
       o._set = "green";
       remove(s,me());
       return "Я подключаю "..s.alt.." к зелёному порту.";
     end
   end
}

green = obj {
   nam = "Зелёный провод"
  ,alt = "зелёный провод"
  ,set = "green"
  ,inv = blue.inv
  ,use = blue.use
}

red = obj {
   nam = "Красный провод"
  ,alt = "красный провод"
  ,set = "red"
  ,inv = blue.inv
  ,use = blue.use
}

endgame = room {
   nam = "Конец"
  ,enter= function()
      if not capsulas:func() then
        p "Нет, надо сначала решить проблему с капсулами.";
        return false;
      elseif capsulas:func() and darkness:cnd() then
        p "В этой темноте я и дверь-то с трудом вижу. Нет, надо всё же сначала разобраться с тем, что здесь происходит."
        return false;
      elseif capsulas:func() and not darkness:cnd() and greenwire._set ~= "green" then
        p "Странно. Я подхожу к двери, но она не открывается.";
        return false;
      end
      mute_()();
      complete_("repair")();
      remove(flash,me());
      remove(screw,me());
    end
  ,dsc = "Ну, наконец-то! И что только творится в электрических мозгах у этих роботов?! Как можно было так подключить энергетические контуры?^Довольный, я вернулся в свой крио-блок и столкнулся там с потрёпанным на вид роботом.^-- Были проблемы с освещением, -- сказал робот. -- Но я всё починил. Волноваться не о чем.^И быстро вышел в коридор -- странной прихрамывающей походкой."
  ,act = gamefile_("crio.lua")
  ,obj = { vobj("next", txtc("^{Продолжение...}")) }
}
