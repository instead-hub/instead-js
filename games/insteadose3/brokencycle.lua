--$Name: Разорванный цикл$
--$Version: 1.0$
--$Author: Андрей Лобанов
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "timer"
require "xact"
game.use='Не получается.'

main=room{
   nam='...',
   enter = music_("spell",0),
   title = { "Р", "А", "З", "О", "Р", "В", "А", "Н", "Н", "Ы", "Й", " ", "Ц", "И", "К", "Л"},
   num = 6,
   dsc='Сознание вернулось. А в месте с ним вернулись мрак и холод.',
   act=code 'walk(capsule)',
   obj={vobj('', '{Открыть глаза}')},
}
capsule=room{
   nam='Капсула',
   dsc='Я нахожусь в капсуле криосна.',
   obj={'capsule_cap'},
}
capsule_cap=obj{
   _seen=false,
   nam='Крышка',
   dsc='Я вижу {крышку} капсулы.',
   act=function(s)
      if not s._seen then
	 s._seen=true
	 put(button)
	 return 'Рядом с крышкой я заметил кнопку аварийного открытия капсулы.'
      else
	 return 'Не получается открыть её изнутри.'
      end
   end,
}
button=obj{
   nam='Кнопка',
   dsc='Рядом находится {кнопка}.',
   act=function()
      if not path(k007) then
	 ways():add(k007)
      return 'Я нажал на кнопку и крышка плавно отъехала в сторону.'
   else
      return 'Крышка уже открыта.'
   end
  end,
}
k007=room{
   nam='K007',
   dsc='Тёмный отсек.',
  pxa = {
    { "door4", 10 },
    { "panel", 220 },
    { "crio", 300 }
  };
   obj={'mcapsule','capsules','cabinets','cabinet'},
   exit=function(s,w)
      if w==crioblock and not have(cloth) then
	 p 'Мне холодно. Да и разгуливать по кораблю в одних трусах нет никакого желания.'
	 return false
      end
   end,
   way={'capsule','crioblock'},
}
mcapsule=obj{
   nam='Капсула',
   dsc='Крышка моей {капсулы} открыта.',
   act='Ничего примечательного.',
   obj={'display'},
}
display=obj{
   nam='Экран',
   dsc='Рядом с открытой крышкой находится {блок} управления криосном.',
   act='На экран выведено сообщение о поломке капсулы. Странно, что вахтенный робот не предпринял никаких действий.',
}
capsules=obj{
   nam='Капсулы',
   dsc='Вокруг меня пять других {капсул} криосна.',
   act='В каждой капсуле находится человек. Интересно почему я вышел из криосна.'
}
cabinets=obj{
   nam='Шкафы',
   dsc='Напротив капсул находятся {шкафы} с вещами членов экипажа.',
   act=function()
      if not have(cloth) then
	 take(cloth)
	 return 'Я открыл свой шкаф и взял свою одежду.'
      else
	 return 'Шкаф пуст.'
      end
   end,
}
cloth=obj{
   nam='Одежда',
   inv='Стандартная форма члена экипажа.',
   use=function(s,w)
      if w==sparecabinet then
	 inv():del(s)
	 return 'Я сложил одежду в шкаф.'
      end
   end,
}
cabinet=obj{
   nam='Шкаф',
   dsc='{Один} из шкафов сильно повреждён.',
   act='Такое впечатление, что его били чем-то увесистым.',
}
crioblock=room{
   nam='Криоблок',
   _grate=0,
   pxa = {
    { "box3", 20 },
    { if_("exist(grenade)","extin"), 90 },
    { "window", 170 },
    { function(s)
        if s._grate == 1 then
          return "shaft";
        elseif s._grate == 2 then
          return "shaft_open";
        end
      end, 440},
    { "door2", 300 }
   },
   dsc='Коридор едва освещён.',
   obj={'grenade','lift'},
   way={'k007'},
}
grenade=obj {
   nam='Огнетушитель',
   dsc=function()
      if here()==crioblock then
	 return 'Рядом с пожарным шкафчиком лежит {огнетушитель}.'
      else
	 return 'На полу лежит {огнетушитель}.'
      end
   end,
   tak='Я поднял огнетушитель.',
   inv='Похоже, им кто-то уже воспользовался.',
   use=function(s,w)
      if w==grate then
	 if here()==crioblock then
      crioblock._grate=2;
	    objs(lift):del(w)
	    ways():add(shaft)
	 else
      here()._grate=true;
	    objs():del(w)
	    ways():add(techblock)
	 end
	 objs():del(grate)
	 return 'Я выломал решётку огнетушителем.'
      elseif w==button2 and not sparehand._not then
	 cell21._opened=true
	 cell20._opened=nil,
	 objs(cell20):del(robot)
	 objs(cell20):del(button2)
	 objs(cell21):add(robot)
	 drop(s)
	 return 'Я швырнул огнетушитель в кнопку, он нажал её и выкатился обратно в технический блок прежде чем дверь закрылась.'
      else
	 return 'Не нужно крушить всё подряд.'
      end
   end,
}
lift=obj{
   nam='Лифт',
   dsc='Двери {лифта} закрыты.',
   act=function(s)
      v='Я нажал на кнопку вызова, но лифт не приехал.'
      if not s._seen then
	 s._seen=0
      elseif s._seen==0 then
	 s._seen=1
      elseif s._seen==1 then
	 s._seen=2
   crioblock._grate=1;
	 put(grate,s)
	 v=v..' Рядом с лифтом я заметил вентиляционное отверстие.'
      end
      return v
   end,
}
grate=obj{
   nam='Решётка',
   dsc=function()
      if here()==crioblock then
	 return 'Рядом с лифтом находится {решётка} вентиляционной шахты.'
      else
	 return 'Здесь есть {решётка}.'
      end
   end,
   act='Металлическая решётка.',
}
shaft=room{
   nam='Шахта',_grate=false,
   pxa = {
    { if_("shaft._grate", "shaft_open", "shaft"), 217 }
   },
   dsc='Я нахожусь на дне вентиляционной шахты.',
   enter=function(s)
      if not s._seen then
	 s._seen=true
	 return 'Я залез в шахту и попытался удержаться, упёршись руками и коленями в стенки, но после криосна силы ещё не полностью вернулись ко мне и я упал вниз.'
      end
   end,
   obj={'grate'},
}
techblock=room{
   nam='Технический блок',
   dsc='Технический блок №10.',
   pxa = {
    { if_("not _endgame", "robot_nohand"), 47 },
    { if_("cell20._opened","door2_open","door4"), 10 },
    { if_("have(hand)", "robot_nohand", "robot"), 177 },
    { if_("cell21._opened","door2_open","door4"), 140 },
    { "toolbox", 300 },
    { if_("door._opened","door1_open","door1"), 370 }
   },
   exit=function()
      if not sparehand._not then
	 if have(hand) then
	    p 'Нужно прикрутить руку обратно.'
	    return false
	 elseif have(wrench) then
	    p 'Незачем таскать с собой гаечный ключ.'
	    return false
	 end
      end
   end,
   obj={'cell20','cell21','box','door'},
   way={'shaft'},
}
cell21=obj{
   nam='Отсек №21',
   dsc=function(s)
      local v
      v='{Дверь} отсека №21 '
      if s._opened then
	 v=v..'открыта.'
      else
	 v=v..'закрыта.'
      end
      return v
   end,
   act=function(s)
      if not s._opened then
	 return 'Мне не открыть эту дверь руками.'
      else
	 return 'Дверь открыта.'
      end
   end,
}
cell20=obj{
   _opened=true,
   nam='Отсек №20',
   dsc=function(s)
      local v
      v='{Дверь} отсека №20 '
      if s._opened then
	 v=v..'открыта.'
      else
	 v=v..'закрыта.'
      end
      return v
   end,
   act='Стандартный отсек, в котором робот пребывает во время гибернации.',
   obj={'robot','button2'},
}
button2=obj{
   nam='Кнопка',
   dsc='В отсеке №20 на стене находится большая круглая {кнопка}.',
   act='Если я её нажму, то просто останусь в отсеке с роботом на ближайшие 99 лет.',
}
robot=obj{
   nam='Робот',
   dsc='В отсеке находится вахтенный {робот}.',
   act=function(s)
      if exist(s,cell20) then
	 return 'У робота отсутствует правая рука.'
      else
	 return 'Стандартный вахтенный робот.'
      end
   end,
}
hand=obj{
   nam='Рука робота',
   inv='Стандартная правая рука вахтенного робота. На ней есть универсальный ключ.',
   use=function(s,w)
      if w==door and not w._opened then
	 door._opened=true
	 ways():add(deck)
	 return 'Я использовал ключ на руке робота чтобы открыть дверь на главную палубу.'
      elseif w==robot then
	 if have(wrench) then
	    inv():del(hand)
	    return 'Я прикрутил руку на место.'
	 else
	    return 'Мне нечем прикрутить руку.'
	 end
      end
   end,
}
box=obj{
   nam='Ящик',
   dsc='На полу лежит {ящик} с инструментами.',
   act=function(s)
      if not have(wrench) then
	 take(wrench)
	 return 'Я взял гаечный ключ.'
      else
	 return 'В ящике больше нет ничего полезного.'
      end
   end,
}
wrench=obj{
   nam='Гаечный ключ',
   inv='Обычный разводной ключ.',
   use=function(s,w)
      if w==robot and exist(robot,cell21) and not have(hand) and not path(deck) then
	 take(hand)
	 return 'Я открутил правую руку у робота WR021.'
      elseif w == box then
	 drop(s,box)
	 return 'Я положил ключ обратно в ящик.'
      elseif w==sparehand and sparehand._not then
	 walk(hend)
      end
   end,
}
door=obj{
   nam='Дверь',
   dsc='Большая {дверь}, ведущая на главную палубу, находится напротив отсеков с роботами.',
   act=function(s)
      if not s._opened then
	 return 'Для открытия двери нужен ключ, который находится на правой руке роботов.'
      else
	 return 'Дверь открыта.'
      end
   end,
}
deck=room{
   nam='Главная палуба',
   pxa = {
      { "door2", 189 },
      { "window", 125 },
      { "window", 351 }
   },
   dsc='Я нахожусь на главной палубе.',
   obj={'mainlift'},
   way={'techblock'},
}
mainlift=obj{
   nam='Лифт',
   dsc='Здесь находятся двери главного {лифта} корабля.',
   act=function()
      if not path(liftinside) then
	 ways():add(liftinside)
	 return 'Я вызвал лифт.'
      else
	 return 'Лифт уже здесь.'
      end
   end,
}
liftinside=room{
   nam='Главный лифт',
   pxa = {
      { "door2", 189 }
   },
   dsc='Я нахожусь внутри главного лифта.',
   obj={'liftbuttons'},
   way={'deck'},
}
liftbuttons=obj{
   nam='Кнопки',
   dsc='На стене лифта находятся {кнопки}.',
   act=function()
      if not exist(sparehand, cell20) then
	 if path(deck) then
	    ways():del(deck)
	    ways():add(warehouse)
	    return 'Я нажал кнопку с подписью "Склад".'
	 else
	    ways():del(warehouse)
	    ways():add(deck)
	    return 'Я нажал кнопку с надписью "Главная палуба".'
	 end
      else
	 if path(deck) then
	    ways():del(deck)
	    ways():add(sparecrioblock)
	    return 'Я нажал кнопку с надписью "Резервный криоблок".'
	 else
	    ways():del(sparecrioblock)
	    ways():add(deck)
	    return 'Я нажал кнопку с надписью "Главная палуба".'
	 end
      end
   end,
}
warehouse=room{
   nam='Склад',
   pxa = {
    { "box", 10 },
    { "box", 100 },
    { "door2", 250 },
    { "shelf", 415 }
   },
   dsc='Я нахожусь в гигантском помещении склада.',
   obj={'boxes'},
   way={'liftinside'},
}
boxes=obj{
   _look=0,
   nam='Ящики',
   dsc='На складе стоит множество стеллажей, заставленных {ящиками}.',
   act=function(s)
      if s._look==0 then
	 s._look=1
	 return 'Где-то среди них должны быть ящики с запасными частями для вахтенных роботов.'
      elseif s._look==1 then
	 s._look=2
	 return 'Я нашёл стеллажи, на которых хранятся запасные части для вахтенных роботов.'
      elseif s._look==2 then
	 s._look=3
	 return 'Я нашёл ящики с запасными руками для роботов. Правда только левыми.'
      elseif s._look==3 then
	 s._look=4
	 take(sparehand)
	 return 'Наконец, я нашёл ящики с правыми руками роботов.'
      else
	 return 'Я уже нашёл то что мне было нужно.'
      end
   end,
}
sparehand=obj{
   nam='Запасная рука',
   dsc='Рядом с дверью отсека №20 лежит запасная правая {рука} робота.',
   tak='Я взял руку.',
   inv=function(s)
      if not s._not then
	 return 'Правая рука робота. Я нашёл её на складе.'
      else
	 return 'Правая рука.'
      end
   end,
   use=function(s,w)
      if w==cell20 and not s._not then
	 drop(s,cell20)
	 return 'Я положил запасную руку рядом с дверью отсека №20. Теперь можно отправляться в резервный криоблок.'
      end
   end,
}
sparecrioblock=room{
   nam='Резервный криоблок',
   pxa = {
    { "door4", 10 },
    { "panel", 220 },
    { "crio", 300 }
   },
   dsc='Я нахожусь в резервном криоблоке.',
   obj={'sparecapsule','sparecabinet'},
   way={'liftinside'},
}
sparecapsule=obj{
   nam='Капсулы',
   dsc='Здесь находятся резервные {капсулы} для криосна.',
   act=function()
      if have(cloth) then
	 return 'Прежде чем погружаться в криосон необходимо раздеться. Складки одежды могут навредить моему телу.'
      else
	 walk(last)
      end
   end,
}
sparecabinet=obj{
   nam='Шкаф',
   dsc='Напротив капсул стоят {шкафы}.',
   act='Обычные металлические шкафы для личных вещей.',
}
last=room{
   nam='Резервный криоблок',
   dsc='Напоследок, оглядев криоблок, я закрыл капсулу и погрузился в долгий сон, наполненный виртуальной жизнью...',
   act=function()
      walk(epilogue)
   end,
   obj={vobj('next','{Далее}')},
}
epilogue=room{
   nam="Отсек №21",
   dsc='Я -- вахтенный робот WR020. Раз в сто лет я выхожу из режима гибернации и несу на корабле вахту на протяжении года, а потом снова отключаюсь. Куда корабль летит я не знаю -- этого нет в моих банках памяти. Но я знаю, что весь экипаж в глубокой криозаморозке.^^И вот вновь настала моя очередь дежурить. Я включаюсь...',
   enter=function()
      sparehand._not=true
      inv():del(wrench)
      inv():disable_all()
      objs(cell21):del(robot)
      cell20._opened=true
      cell21._opened=nil
   end,
   act=function()
      walk(wakeup)
   end,
   obj={vobj('next', '{Далее}')}
}
wakeup=room {
   nam="Пробуждение",_s=1,_f=0,
   dsc=function(s) return s._dsc end,
   _dsc=[[Я только что вышел из режима гибернации. Необходимо запустить {diag|программу диагностики}.^]],
   timer=function(s)
      s._f=s._f+1;
      if s._f==1 then
	 s._dsc=s._dsc.."^"..s.diags[s._s];
      elseif s._f>1 and s._f<5 then
	 s._dsc=s._dsc..".";
      elseif s._f==5 then
	 if s._s==4 then
	    s._dsc=s._dsc.." ошибка! отсутствует правая рука!";
	    timer:stop();
	    put(vobj('next','{Продолжить}'))
	 else
	    s._dsc=s._dsc.." нормально";
	    s._f=0;
	    s._s=s._s+1;
	 end
      end
      walk(wakeup);
   end,
   act=function()
      walk(e_cell21)
   end,
   diags={"Банки памяти","Центральный процессор","Зрительные окуляры","Моторика"},
   obj ={xact("diag",code[[timer:set(500)]])}
}
_endgame=false;
e_cell21=room{
   nam='Отсек №21',
   enter=function() _endgame=true; end,
   pxa = {
    { "door1", 189 }
   },
   dsc='Я нахожусь в отсеке №21.',
   way={'techblock'},
}
hend=room{
   nam='Конец',
   dsc='Я прикрутил руку и спокойно начал нести свою вахту.',
   enter=function()
      mute_()();
      complete_("brokencycle")();
      inv():disable_all()
   end,
   act = gamefile_("meteor.lua"),
  obj = { vobj("next", txtc("^{Продолжение...}")) }
}
