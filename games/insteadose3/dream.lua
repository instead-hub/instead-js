--$Name: Сон$
--$Version: 0.1$
--$Author: Андрей Лобанов$

instead_version '1.9.1'
require "lib"
require "para"
require "dash"
require "quotes"
require "hideinv"
require "nouse"

main=room{
   nam='...',
   title = {"С", "О", "Н" },
   num = 12,
   enter = music_("influensa",0),
   dsc='Я прожил достойную жизнь. Построил свой дом, вырастил детей... Теперь они уважаемые люди. С соседями я в хороших отношениях. Мне нечего стыдиться за всю мою долгую жизнь.^^Но в последнее время странные события начали происходить вокруг меня. Сперва я всё списывал на причудливые видения старика, но сейчас мне страшно. И никто вокруг не замечает происходящего.',
   act=function()
      walk(home)
   end,
   obj={vobj('next','{Продолжить}')},
}

home=room{
   nam='Мой дом',
   pxa = {
    { "window4", 20 },
    { "table6", 240 },
    { "chair1", 440 },
    { "toolbox", 10 }
   },
   dsc='Я нахожусь у себя дома.',
   obj={'window','mtable', 'box'},
   way={'yard'},
}

window=obj{
   nam='Окно',
   dsc='Во двор выходит большое {окно}.',
   act='На улице хорошая погода.',
}

mtable=obj{
   nam='Стол',
   dsc='Возле окна стоит {стол}.',
   act='Грубо сработанный, но добротный стол, который я сделал сам.',
}

box=obj{
   nam='Ящик',
   dsc='В углу стоит {ящик} с инструментами.',
   act=function(s)
      if not s._need then
	 return 'Мне сейчас не нужны инструменты.'
      else
	 if not have(axe) then
	    take(axe)
	    return 'Я взял топор.'
	 else
	    return 'Мне больше ничего не нужно из инструментов.'
	 end
      end
   end,
}

axe=obj{
   _i=0,
   _cuts=0,
   nam='Топор',
   inv='Хороший острый топор.',
   use=function(s,w)
      if w==fence then
	 return 'Этот забор я строил сам. Не буду его ломать.'
      elseif w== people then
	 return 'Не буду я учинять бесчинства и убивать своих соседей и друзей.'
      elseif w==tree then
	 ways(square):disable_all()
	 if not exist(branch) then
	    put(branch, tree)
	 elseif branch._i<4 then
	    branch._i=branch._i+1
	    if branch._i==4 then
	       walk(death)
	    end
	 end
	 s._i=s._i+1
	 if s._i==10 then
	    objs(tree):del(branch)
	    walk(after)
	 end
	 return 'Я замахнулся и как следует ударил по дереву.'
      elseif w==branch then
	 if branch._i<3 then
	    return 'Слишком высоко -- мне никак не дотянуться до неё.'
	 else
	    branch._i=0
      s._cuts=s._cuts+1;
	    return 'Ловко увернувшись, я одним сильным ударом отрубил ветку.'
	 end
      end
   end,
   nouse='Не стоит размахивать топором налево и направо.',
}

yard=room{
   nam='Двор',
   pxa = {
    { if_("exist(neighbor)","yard2","yard"), 0 }
   },
   dsc='Я стою во дворе своего дома.',
   obj={'fence'},
   way={'home'},
}

fence=obj{
   nam='Забор',
   dsc='Двор обнесён невысоким {забором}.',
   act=function()
      if not exist(neighbor) and not box._need then
	 place(neighbor)
	 return 'За зобором я увидел соседа.'
      else
	 return 'Этот забор я сам построил.'
      end
   end,
}

neighbor=obj{
   nam='Сосед',
   dsc='За забором своими делами занимается {сосед}.',
   act=function(s)
      if not s._dlg then
	 walk(neighor_dlg)
      else
	 return 'Сосед занимается своими делами.'
      end
   end,
}

neighor_dlg=dlg{
   hideinv=true,
   pxa = {
    { "yard2", 0 }
   },
   nam='Разговор с соседом',
   enter='Как только я обратил на соседа внимение, как он повернулся ко мне и сказал:^^-- Привет. Видал что на площади делается?',
   phr={
      {1,true,'Нет','-- Выросло там за ночь большое дерево чудное. Аккурат там где молодёжь в лапту играет. Ни клён ни берёза. Никогда таких деревьев не видел.',[[pon(2)]]},
      {2,false,'Чудно. Надо посмотреть.','-- Ага. Все сейчас там и столпились.',[[neighbor._dlg=true;ways(yard):add(square);back()]]},
   },
}

square=room{
   nam='Площадь',
   pxa = {
    { if_("axe._cuts==0", "bigtree",
        if_("axe._cuts==1", "bigtree_nb1",
          if_("axe._cuts>1", "bigtree_nb2")
            )
          )
          ,0 }
   },
   dsc='Я нахожусь на площади.',
   obj={'tree','people'},
   way={'yard'},
}

tree=obj{
   nam='Дерево',
   dsc=function()
      if here()==square then
	 return 'Прямо посреди площади стоит большущее {дерево}.'
      else
	 return 'Посреди площади лежит срубленное мной {дерево}.'
      end
   end,
   act=function()
      if here()==square then
	 return 'Никогда ничего подобного я не видел.'
      else
	 objs(after):del(tree)
	 objs(after):add(hole)
	 return 'Едва я взглянул на дерево, как оно начало менять свою форму и обернулось гигантским червём, который запросто мог бы проглотить меня.^^Червь набросился на меня столь стремительно, что я едва успел увернуться. Он вгрызся в землю и исчез, оставив после себя широкий тоннель, уходящий вглубь.'
      end
   end,
}

branch=obj{
   _i=0,
   nam='Ветка',
   dsc=function(s)
      if s._i==0 then
	 return 'Одна из {веток} начала двигаться ко мне.'
      elseif s._i==1 then
	 return 'Одна из {веток} приближается ко мне.'
      elseif s._i == 2 then
	 return '{Ветка} скоро дотянется до меня.'
      elseif s._i==3 then
	 return '{Ветка} уже почти дотянулась до меня.'
      end
   end,
   act='Нельзя допустить чтобы она успела коснуться меня.',
}

people=obj{
   nam='Люди',
   dsc='Вокруг дерева столпились {жители} нашей деревни.',
   act=function(s)
      if here()==square then
	 if not have(axe) and event._n==3 then
	    return 'Стоят и смотрят на это жуткое дерево как ни в чём не бывало.'
	 else
	    if not have(axe) then
	       walk(event)
	    else
	       return 'Пока меня не было, исчезло очень много народу, а остальные стоят -- не шелохнутся. И все смотрят на это страшное дерево.'
	    end
	 end
      else
	 return 'Немногие оставшиеся жители стоят и смотрят туда, где только что стояло дерево. Они даже не моргают.'
      end
   end,
}

after=room{
   nam='Площадь',
   pxa = {
    { if_("not exist(hole)","bigtree2","tunnel"), 0 }
   },
   dsc=function(s)
      if not s._seen then
	 s._seen=true
	 return 'Наконец, я срубил дерево.'
      else
	 return 'Я нахожусь на площади.'
      end
   end,
   obj={'tree','people'},
}

hole=obj{
   nam='Тоннель',
   dsc='Посреди площади находится большая {дыра}, оставленная червём..',
   act=function(s)
      if not s._seen then
	 s._seen=true
	 if not path(vroom('В туннель','tunnel')) then
	    ways():add(vroom('В туннель','tunnel'))
	 end
      end
      return 'Абсалютно прямой туннель, в конце которого что-то ослепительно сияет.'
   end,
}

event=room{
   hideinv=true,
   forcedsc=true,
   _n=0,
   nam='Площадь',
   pxa = {
     {"bigtree", 0}
   },
   dsc=function(s)
      v='Вдруг одна ветка шевельнулась.'
      music_("death",0)();
      if s._n>=1 then
	 v=v..'^^Неторопливым движением она склонилась к молоденькой девушке, что живёт недалеко от меня.'
      end
      if s._n>1 then
	 v=v..'^^Ветка всё ближе и ближе пожбирается к девушке. Похоже, никто кроме меня не замечает этого.'
      end
      if s._n>2 then
	 v=v..'^^Вот ветка коснулась девушки и она пропала. Просто исчезла, как будто и не было её никогда. И никто не заметил этого!'
      end
      return v
   end,
   act=function(s)
      if s._n==0 then
	 s._n=1
	 return true
      elseif s._n==1 then
	 s._n=2
	 return true
      elseif s._n==2 then
	 s._n=3
	 return true
      else
	 box._need=true
	 objs(yard):del(neighbor)
	 walk(square)
      end
   end,
   obj={vobj('next','{>>>>}')},
}

tunnel=room{
   nam='Туннель',
   dsc='Я нахожусь в туннеле.',
   way={'after',vroom('К свету','nearlight')}
}

nearlight=room{
   nam='Туннель',
   dsc='Я всё шёл и шёл. Выход уже давно пропал вдали, а свет всё не приближался. В конце концов я понял что не могу идти обратно -- что-то толкает меня вглубь тоннеля и не пускает обратно.',
   enter=function()
      inv():del(axe)
   end,
   way={vroom('К свету','nearlight2')},
}

nearlight2=room{
   nam='Тоннель',
   dsc='Яркий свет заливает всё вокруг. Я уже не вижу стен туннеля, не вижу своих рук и ног -- есть только красивый и тёплый свет, заполняющий собой весь мир.',
   act=function()
      walk(dos)
   end,
   obj={vobj('next','{Далее}')},
}

dos=room{
   nam='Операционная система',
   dsc=function(s)
      if not s._seen then
	 s._seen=true
	 return 'Всё исчезло. Остались только темнота и холод. Некоторое время ничего не происходило, а потом я услышал приятный голос операционной системы:^^-- Ваш сон закончен. Спасибо что использовали программное обеспечение "Dream Software".^^Ваши сны -- наша забота.'
      else
	 return 'Я нахожусь в криокапсуле. Крышка капсулы не открывается.'
      end
   end,
   act=function(s)
      if not exist(button) then
	 put(button)
	 objs():del('next')
	 return 'Я осмотрелся повнимательней. Меня всё ещё мутит и я не очень понимаю где и кто я.'
      end
   end,
   obj={vobj('next','{Далее}')},
}

button=obj{
   nam='Кнопка',
   dsc='Я вижу {кнопку} аварийного открытия капсулы.',
   act=function()
      walk(theend)
   end,
}

theend=room{
   nam='Конец',
   enter = function() mute_()(); complete_("dream")() end,
   dsc='Крышка отъехала в сторону. Трясясь от холода, я вышел в отсек K013...',
  act = gamefile_("nightmare.lua"),
  obj = { vobj("next", txtc("{Продолжение...}")) }
}

light=obj{
   nam='Свет',
   dsc='Вдалеке виден {свет}.',
   act='Я не знаю почему, но меня тянет к нему.',
}

death=room{
   nam='Конец',
   dsc='Ветка всё таки коснулась меня.^^Время замерло, свет начал медленно угасать...',
}
