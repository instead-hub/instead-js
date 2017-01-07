-- $Name: Вахта$
-- $Version: 0.2$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "timer"
require "xact"

game.use = "Ошибка программы! Ээээ... т.е. нет, так лучше не делать."
local oob = obj;
function tc(f,s)
if type(f) == "function" then return tc(f(s),s) else return f end
end
function obj(t)
local d = t.dsc;
t.dsc = function(s) if s.cnd == nil or s:cnd() then return tc(d,s) end end
return oob(t);
end

main = timerpause(999, 700, "main2");

main2 = room {
_hand=false,
nam = "...",
enter = music_("square",0),
title = { "В", "А", "Х", "Т", "А" },
num =5,
act = function(s) walk(wakeup)end,
dsc="Я -- вахтенный робот WR005. Раз в сто лет я выхожу из режима гибернации и несу на корабле вахту на протяжении года, а потом снова отключаюсь. Куда корабль летит я не знаю -- этого нет в моих банках памяти. Но я знаю, что весь экипаж в глубокой криозаморозке.^^И вот вновь настала моя очередь дежурить. Я включаюсь...",
obj = { vobj("next", '{Начать игру}') }
}

wakeup = room {
nam = "Пробуждение",_s=1,_f=0,
dsc = function(s) return s._dsc end,
_dsc = [[Я только что вышел из режима гибернации. Необходимо запустить {diag|программу диагностики}.^]],
timer = function(s)
s._f=s._f+1;
if s._f==1 then
s._dsc=s._dsc.."^"..s.diags[s._s];
elseif s._f>1 and s._f<5 then
s._dsc=s._dsc..".";
elseif s._f==5 then
if s._s==4 then
s._dsc=s._dsc.." ошибка! отсутствует правая рука!";
timer:stop();
s._do=true;
else
s._dsc=s._dsc.." нормально";
s._f=0;
s._s=s._s+1;
end
end
walk(wakeup);
end,
diags= {"Банки памяти","Центральный процессор","Зрительные окуляры","Моторика"},
obj = { xact("diag", code[[timer:set(500)]]), "wakeup_next" }
}

wakeup_next = obj {
nam="wakeup_next",
cnd=function()return wakeup._do end,
dsc="{Продолжить}",
act=function()walk(cabin1)end
}

cabin1 = room {
nam = "Отсек WR005",_closed=false,
pxa = { 
 { if_("exist(oil)","oil"), 80, 100 },
{ if_("cabin1._closed", "door4", "door2_open"), 190 } 
},
enter=function(s)
if s._closed then
p "Дверь в мой отсек закрыта. Надо будет потом придумать, как её снова открыть. Но на этом у меня есть целый год.";
return false; 
end
end,
exit=function(s)if s._closed then p "Сначала нужно открыть дверь.";return false; end end,
dsc = "Я нахожусь в своем отсеке. Здесь я провел сто лет в режиме гибернации.",
obj={"cabin1_walls","oil","button","cabin1_door"},
way = {"block"}
}

cabin1_walls=obj {
nam="",dsc="Здесь почти ничего нет -- голые металлические стены. В свою прошлую вахту я так и не успел тут всё как следует обставить. Может, в этот раз найдётся время."
}

oil=obj {
nam="Маслёнка",dsc="На узенькой полке на стене справа лежит {маслёнка}.",
tak="Я беру маслёнку. Масло всегда пригодится.",
inv="Маслёнка. Почти полная.",
use=function(s,v)
if v==hand then
hand._oil=true;
remove(oil,me());
return "Я смазываю маслом все гайки на правой руке моего коллеги. Теперь я должен без проблем её открутить.";
end
end
}

button=obj {
nam="",dsc="У двери красуется огромная {красная кнопка}.",
act=function()
local t="Я нажимаю на кнопку, и дверь ";
if cabin1._closed then t=t.."открывается." else t=t.."закрывается." end
cabin1._closed=not cabin1._closed;return t;
end
}
cabin1_door=obj {
 nam="",dsc=function()if cabin1._closed then return "Сейчас дверь закрыта." else return "Сейчас дверь открыта." end end
}

block = room {
nam = "Технический блок",
pxa = {
  { "toolbox", 440},
  { if_("cabin1._closed", "door4", "door2_open"), 10 },
  { if_("main2._hand", "robot_nohand", "robot"), 187 },
  { if_("cabin1._closed", "door2_open", "door4"), 150 },
  { "door1", 300 },
},
dsc = "Технический блок №2. Здесь есть два отсека для вахтенных роботов и большая толстая дверь в коридор, который ведёт на главную палубу.",
obj = {"blockbutton","toolbox","key","tube"},
way = {"cabin1","cabin2",vroom("Коридор","endgame1")}
}

blockbutton=obj {
nam="",
dsc="Отсюда я вижу проход в мой отсек. Если встать под углом сорок пять градусов, то можно даже заметить большу {круглую кнопку}, которая закрывает дверь отсека.",
act="Я, конечно, могу дотянуться до кнопки, но тогда дверь опустится и отрубит мою единственную руку.",
cnd=function(s)return not cabin1._closed end
}

toolbox=obj {
nam="",
dsc = "В углу лежит {ящик с инструментами}.",
act=function(s)
if key._taken then
return "В ящике больше нет ничего полезного.";
else
s._exam=true;
return "Я ящике лежит большой гаечный ключ.";
end
end
}

key=obj {
nam="Гаечный ключ",
dsc="В ящике -- {гаечный ключ}.",
inv="Гаечный ключ -- старомодно, но удобно. Хорошо подходит для того, чтобы откручивать руки.",
tak=function(s) s._taken=true;return "Я взял гаечный ключ." end,
use=function(s,v)
if v==tube and not tube._done then
  tube._done=true;
  take(tube);
  return "Всё-таки гаечный ключ -- полезная штука! Раз-раз, и негодная труба выломана из стены. Теперь всё выглядит идеально.";
elseif v==hand and not hand._oil then
  return "Я пытаюсь открутить руку ключом, но ничего не выходит. Ни одна из гаек не желает поворачиваться.";
elseif v==hand and hand._oil and not main2._hand then
main2._hand=true;
remove(key,me());
return "Пара капель масла и... всё как по маслу! Я без проблем откручиваю у своего коллеги руку и приделываю эту руку себе. Ну, наконец-то! У меня снова две руки!";
end
end,
cnd=function()return toolbox._exam end
}

tube=obj {
nam="Обломок трубы",dsc="Из стены рядом с дверью в коридор торчит какая-то мятая {труба}. Труба еле держится.",
act="Без понятия, что это такое. Этого нет в моих банках памяти. Раз нет в банках памяти -- значит я за это не отвечаю. Да и вообще мятая труба как-то портит вид. Я пытаюсь выломать трубу из стены, но у меня ничего не получается.",
inv="Мятый обломок трубы. Выглядит отвратительно.",
use=function(s,v)
if v==blockbutton and have(oil) then
cabin1._closed=true;
remove(tube,me());
return "Да, отличная идея! Я встаю под углом в 45 градусом, просовываю в дверной проём трубу и касаюсь круглой кнопки. Дверь тут же опускается и поднимает под себя трубу. Так ей и надо, этой трубе. К тому же теперь мой отсек закрыт... Правда, мне потом потребуется ещё одна труба, чтобы попасть обратно.";
elseif v==blockbutton then 
return "Ошибка! Тупиковая ситуация! Эээ... нет, мне кажется я что-то ещё не сделал.";
end
end
}

cabin2=room {
nam = "Отсек WR006",
pxa = {
  { "door1_open", 80 },
  { if_("main2._hand", "robot_nohand", "robot"), 220 }
},
enter = function(s)
if not cabin1._closed then
p "Дверь в отсек WR006 закрыта. Она откроется только, когда будет закрыта дверь в мой отсек. Вот так здесь всё устроено.";return false;
end
end,
dsc = "Это отсек другого вахтенного робота -- он старше меня ровно на единицу.",
obj = {"robot","hand"},
way = {"block"}
}

robot=obj {
nam="",dsc="{Мой коллега} сейчас отключён и стоит неподвижно, как колонны, подпирающие потолок в коридоре.",
act=function() if main2._hand then return "Надеюсь, он не сильно расстроится, когда увидит, что у него нет правой руки." else return "Спать ему ещё целую сотню лет." end end
}

hand=obj {
nam="",dsc="Его {правая рука} на месте.",
act="Кстати, я не говорил, что мы полностью совместимы? Да, это наводит на мысли... Правда, тут нужны инструменты.",
cnd=function() return not main2._hand end
}

endgame1=room{
nam="",enter=function(s)
if not main2._hand then
p "Я не могу открыть дверь в коридор без моей правой руки. В неё встроен чип-ключ. Да и вообще без руки я не смогу нести вахту.";
return false;
else
timer:set(4000)
end
end,
dsc=txtc("Прошло сто лет..."),
timer=function()timer:stop();walk(endgame2)end
}

endgame2=room {
nam = "Пробуждение",_s=1,_f=0,
dsc = function(s) return s._dsc end,
_dsc = [[Я робот WR006. Я только что вышел из режима гибернации. Необходимо запустить {diag|программу диагностики}.^]],
timer = function(s)
s._f=s._f+1;
if s._s==5 then
mute_()();
complete_("watch")();
s._s=6;
s._dsc=s._dsc.."^^"..txtc("{next|КОНЕЦ?}");
timer:stop();
walk(endgame2);
return;
end
if s._f==1 then
s._dsc=s._dsc.."^"..s.diags[s._s];
elseif s._f>1 and s._f<5 then
s._dsc=s._dsc..".";
elseif s._f==5 then
if s._s==4 then
s._dsc=s._dsc.." ошибка! отсутствует правая рука!";
s._s=5;
else
s._dsc=s._dsc.." нормально";
s._f=0;
s._s=s._s+1;
end
end
walk(endgame2);
end,
diags= {"Банки памяти","Центральный процессор","Зрительные окуляры","Моторика"},
obj = { xact("diag", code[[timer:set(500)]]), xact("next", code[[gamefile_("brokencycle.lua")()]]) }
}
