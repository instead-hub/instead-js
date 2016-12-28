-----------------
-- Коридор
-----------------

passage = room {
  nam = 'Коридор',
  pic = pic 'img/passage.jpg',
  way = {
    'boss_office',
    vroom('Гримёрки', 'dressrooms'),
    vroom('За сцену', 'backstage'),
    vroom('В зал', 'hall'),
  },
  _counter = 0,
  entered = function(s)
    p [[ Я вышел в коридор. Грязноватое нечто под ногами, когда-то бывшее ковровым покрытием, скрадывает звук моих шагов.
      Слышен приглушенный шум толпы – зрители уже собрались в зале в ожидании концерта. ]]
    set_music('mus/crowd-before-jazz-concert.ogg')
    if disabled 'door' then
      s._counter = s._counter + 1
      if s._counter > 20 then
        enable 'door'
      end
    end
  end,
  dsc = [[ Пустой коридор с множеством дверей. Вместо табличек – бумажные листки с надписями маркером,
    держащиеся на скотче и на добром слове местной уборщицы. ]],
  obj = {
    obj {
      nam = 'афиши',
      dsc = [[ На стенах пожелтевшие и кое-где ободранные {афиши} с наших прошлых концертов. ]],
      act = [[ Да… отличные были шоу. Но надо стремиться к большему! ]],
    },
    obj {
      nam = 'кулер',
      dsc = [[ Возле одной из стен стоит старенький и видавший виды, но, кажется, исправный {кулер} с холодной водой. ]],
      obj = { 'cup' },
      act = function()
        p [[ Он наполовину пуст. Ну, или наполовину полон – надо не терять оптимизм. ]]
        enable('cup')
      end,
    },
    'door',
  },
}

door = obj {
  nam = 'дверца',
  dsc = [[ С противоположной стороны коридора – неприметная {дверца}. ]],
  act = function(s)
    if visited('boxroom') then
      walk 'boxroom'
    elseif s._remarked then
      p [[ Заперто. ]]
    else
      p [[ Странно, что я раньше не обращал на эту дверь внимания. Видимо, потому что на ней нет таблички. ]]
      s._remarked = true
    end
  end,
  used = function(s, w)
    if (w.nam == 'ключ') then
      walk 'boxroom'
    else
      return false
    end
  end
}:disable()

dressrooms = room {
  nam = 'Второй этаж',
  enter = code [[ stop_music() ]],
  dsc = [[ Здесь ковер гораздо чище, а шума почти не слышно.
  У каждого из музыкантов своя гримёрка. Восходящие звезды рок-сцены уже могут себе это позволить.^^
  {xwalk(room_steve)|Стив (вокал)}^
  {xwalk(room_sean)|Шон (cоло)}^
  {xwalk(room_sam)|Сэм (ритм)}^
  {xwalk(room_joe)|Джо (бас)}^
  {xwalk(room_chuck)|Чак (ударные)}^
   ]],

  way = {
    vroom('Стив (вокал)^', 'room_steve'):disable(),
    vroom('Шон (cоло)^', 'room_sean'):disable(),
    vroom('Сэм (ритм)^', 'room_sam'):disable(),
    vroom('Джо (бас)^', 'room_joe'):disable(),
    vroom('Чак (ударные)^', 'room_chuck'):disable(),
    vroom('Вниз', 'passage'),
  },
}

iface.cmd = stead.hook(iface.cmd, function(f, s, inp, ...)
  if inp == 'look' then
    if here() == passage and have 'key' then
      door:enable()
    end
  end
  return f(s, inp, ...);
end);

-----------------------------------
-- Подсобка
-----------------------------------

boxroom = room {
  nam = 'Подсобка',
  enter = [[ Я вошёл, и на ощупь найдя выключатель на стене, осветил крошечное помещение. ]],
  dsc = [[ Похоже, уборщица тоже не замечает эту комнату. По крайней мере последние пару лет.^
    Вокруг меня полупустые пыльные полки. На них, кроме ветоши, кое-где стоят картонные коробки со старым сценическим реквизитом. ]],
  obj = {
    obj {
      nam = 'белая коробка',
      dsc = [[ Слева от меня стоит {белая коробка}. ]],
      obj = {
        'markers',
      },
      act = function()
        if joe._aim == 1 and not have('markers') and me()._know_draw then
          p [[ Кажется, это мне может пригодиться! ]]
          markers:enable();
          return true
        else
          p [[ Какие-то парики, сценический грим. Я не вижу там ничего интересного для себя. ]]
        end
      end,
    },
    obj {
      nam = 'красная коробка',
      dsc = [[ Справа -- {красная коробка}. ]],
      obj = {
        'charge',
      },
      act = function()
        if sean._aim == 1 and not have('charge') then
          p [[ Кажется, это мне может пригодиться! ]]
          charge:enable();
          return true
        else
          p [[ Навалены какие-то детали, разобранный радиоприемник. Я не вижу там ничего интересного для себя. ]]
        end
      end,
    },
  },
  way = { vroom('Выйти', 'passage') },
}


-----------------------------------
-- За сценой
-----------------------------------

backstage = room {
  nam = 'За сценой',
  enter = [[ Я вышел за сцену. Здесь почти как в первом ряду на концерте. Только музыканты всегда будут к тебе спиной. Не часто я тут бываю. ]],
  dsc = [[ Перед концертом за сценой можно встретить техников, осветителей или звуковиков, но сейчас никого нет. ]],
  obj = {
    vobj('мониторы', [[ В углу стоят старые сценические {мониторы}. ]]),
    obj {
      nam = 'розетки',
      dsc = [[ На стене в ряд расположены не меньше десятка электрических {розеток}. ]],
      act = function()
        if sean._aim == 1 and have('charge') and not have('cable') and not seen('cable') then
          p [[ Приглядевшись, я заметил, что не все провода ведут на сцену. ]]
          enable('cable')
        else
          p [[ Ничего интересного. ]]
        end
      end
    },
    obj {
      nam = 'провода',
      dsc = [[ Почти из каждой тянется {кабель} на сцену. ]],
      act = [[ Всё уже настроено для концерта. Лучше ничего не трогать. ]],
    },
    'cable',
    vobj('стойки', [[ Посередине стоит несколько софитных {стоек}. ]]),
  },
  act = [[ Ничего интересного. ]],
  way = {
    vroom('Вернуться', 'passage'),
    'scene',
  },
  timer = function()
    timer:stop()
    if key._is_hot then
      p [[ Через некоторое время ключ остыл. ]]
      key._is_hot = nil
    end
  end,
  exit = function(s)
    s.timer()
  end,
}

game.timer = function()
  timer:stop()
end

cable = obj {
  nam = 'кабель питания',
  dsc = [[ К одной из розеток подключен забытый кем-то {кабель питания}. Его второй конец болтается в воздухе. ]],
  tak = [[ Думаю, это мне пригодится! ]],
  use = function(s, w)
    if w == charge then
      p [[ Отлично! Теперь зарядное устройство готово к работе. ]]
      w._fixed = true
      inv():del(s)
    elseif stead.nameof(w) == 'розетки' then
      p [[ Я верну его на место потом, а сейчас он мне нужен. ]]
      return false
    else
      return false
    end
  end,
  used = function(s, w)
    if w == charge then
      p [[ Отлично! Теперь зарядное устройство готово к работе. ]]
      w._fixed = true
      inv():del(s)
    else
      return false
    end
  end,
  inv = [[ Совершенно стандартный кабель. Около полутора метров, должно хватить. ]],
}:disable()

