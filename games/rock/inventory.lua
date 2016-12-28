----------------------------------
-- Будут инициализированны позже
----------------------------------

guitar = {}

----------------------------------
-- Всякия разные предметы
----------------------------------

money = obj {
  nam = 'деньги',
  use = function(s, w)
    if w._is_musician then
      p [[ Пусть сначала отыграет программу! ]]
    else
      return false
    end
  end,
  inv = [[ Довольно потасканная купюра. ]],
}

key = obj {
  nam = 'ключ',
  dsc = [[ Рядом с жилетом лежит какой-то {ключ}. ]],
  tak = [[ Я подобрал ключ. ]],
  inv = function(s)
    if visited('boxroom') then
      p [[ Ключ от подсобки. ]]
    else
      p [[ Небольшой металлический ключ. Я не знаю, от чего он. ]]
    end
  end,
  use = function(s, w)
    if w == guitar and s._is_hot then
      p [[ Раскалённым ключом я накарябал на гитаре советскую звезду и заключил ее в выжженный чёрный круг. ]]
      timer:stop()
      w._marked = true
      s._is_hot = nil -- Поди уж не надо писать, что ключ остыл
    end
  end,
}:disable();

markers = obj {
  nam = 'фломастеры',
  dsc = [[ В ней я вижу набор {фломастеров} для грима. ]],
  tak = [[ Я взял фломастеры. ]],
  inv = [[ Уже не новые, конечно. ]]
}:disable()

charge = obj {
  nam = 'зарядка',
  dsc = [[ На дне красной коробки среди блестящей мишуры и цветных перьев я вижу {зарядку} для ноутбука. ]],
  tak = [[ Я взял зарядку. К сожалению, у нее нет кабеля питания. Видимо, за это её и поселили здесь. ]],
  inv = function(s)
    p [[ Универсальная китайская зарядка. Подходит, почти к любому ноутбуку. ]]
    if not s._fixed then
      p [[ К сожалению, у нее отсутствует кабель питания. ]]
    end
  end,
  use = function(s, w)
    if stead.nameof(w) == 'кабель питания' then
      p [[ Так не получается. ]]
      return false
    elseif not s._fixed then
    p [[ Ну и кому нужна зарядка, если ее нельзя воткнуть в розетку? ]]
      return false
    elseif w == sean then
      inv():del(s)
      sean._aim = 2
      set_music 'mus/pacman.ogg'
    elseif stead.nameof(w) == 'розетки' then
      p [[ Я подключил зарядку к розетке и увидел, что лампочка загорелась. Значит, должна работать. ]]
      return false
    end
  end,
}:disable()

t_shirt = obj {
  nam = 'футболка',
  dsc = [[ просторную белую {футболку}, ]],
  tak = function()
    if me()._know_draw then
      p [[ Я поднял футболку. Думаю, этот реквизит Стиву точно не интересен. ]]
      return true
    else
      p [[ Ничего интересного. ]]
      return false
    end
  end,
  used = function(s, w)
    if w == markers and not s._painted then
      p [[ Я взял красный фломастер и изобразил на футболке, как умел, большую птичью лапку.
        Затем обвел ярким кругом и подписал PEACE разноцветными буквами. Надеюсь, результат понравится Джо. ]]
      s._painted = true
    else
      return false
    end
  end,
  inv = function(s)
    p [[ Просторная белая футболка. ]]
    if s._painted then
      p [[ На груди красуется яркий пацифик -- результат моего художества. ]]
    end
  end,
}:disable()

recipe = obj {
  nam = 'рецепт',
  inv = function(s)
    p [[
      <c>РЕЦЕПТ ОТ ПОХМЕЛЬЯ:</c>^ Смешать 100 мл. томатного сока и один сырой яичный желток. Непрерывно помешивая,
        засыпать одну растолчённую таблетку аспирина. Добавить щепотку соли и щепотку красного перца. Выпить залпом.
    ]]
  end,
}

cup = obj {
  nam = 'стакан',
  dsc = [[ Сбоку в прозрачном жёлобе – одноразовые {стаканчики}. ]],
  var {
    state = 'пуст',
  },
  what_is_inside = function(s)
    local cnt = 0
    local last
    for k, e in pairs { 'water', 'egg', 'tomato', 'aspirin', 'analgin' } do
      if s:srch(e) then
        last = e
        cnt = cnt + 1
      end
    end
    return cnt, last
  end,
  is_cocktail_ok = function(s)
    return s:srch('egg')
      and s:srch('tomato')
      and s:srch('aspirin')
      and not s:srch('water')
      and not s:srch('analgin')
  end,
  need = function(s, w)
    return have 'recipe' and not have(w) and not s.obj:srch(w) and chuck._aim ~= 2
  end,
  inv = function(s)
    local cnt, last = s:what_is_inside()
    if here() == ref('passage') and cnt == 1 and last == 'water' then
      p [[ Я жадно выпил воду... Эх, бегаешь тут, как белка в колесе... ]]
      s.obj:del('water')
    else
      p [[ Одноразовый стаканчик. ]]
      if cnt == 0 then
        p [[ Сейчас он пуст. ]]
      elseif cnt > 1 then
        p [[ Сейчас в нем намешано какое-то пойло. ]]
      elseif last == 'water' then
        p [[ Сейчас он наполнен водой. ]]
      elseif last == 'egg' then
        p [[ На его дне болтается жидкий яичный желток. ]]
      elseif last == 'tomato' then
        p [[ Больше, чем наполовину, он заполнен томатным соком. ]]
      else
        p [[ В нем что-то странное. Я даже не понимаю, что это. ]]
      end
    end
  end,
  act = function(s)
    if have 'cup' then
      p [[ Один взял – и хватит. Хорошего помаленьку. ]]
    else
      p [[ Беру себе стаканчик. Вроде чистый… ]]
      inv():add(s) -- если сделать take(s), то из кулера стаканчики пропадут
    end
  end,
  use = function(s, w)
    local cnt, last = s:what_is_inside()
    if stead.nameof(w) == 'кулер' then
      if cnt == 0 then
        p [[ Я осторожно наливаю воду в пластиковый стаканчик. ]]
      elseif s:srch('water') then
        p [[ В стакане уже есть вода. ]]
      else
        p [[ Я добавил в стакан немного воды. ]]
      end
      s.obj:add('water')
    elseif stead.nameof(w) == 'кубок' then
      if not ref('bowl')._know_tomato then
        return false
      elseif cnt == 0 then
        p [[ Я плеснул в стаканчик томатного сока. ]]
      elseif s:srch('tomato') then
        p [[ В стакане уже есть томатный сок. ]]
      else
        p [[ Я добавил в стакан томатного сока. ]]
      end
      s.obj:add('tomato')
    elseif w._is_musician then
      if cnt == 0 then
        p [[ Зачем ему пустой стакан? ]]
      elseif w ~= chuck then
        p [[ Выплеснуть ему за шиворот? Конечно, музыканты иногда меня бесят своими капризами, но надо держать себя в руках. ]]
      end
      return false
    elseif w._is_girl then
      if cnt == 0 then
        p [[ Зачем ей пустой стакан? ]]
      elseif cnt == 1 and last == 'water' then
        p [[ -- Спасибо! Здесь, действительно сильно жарко -- девушка выпила воду и выбросила использованный стаканчик. ]]
        s.obj:zap()
        inv():del(s)
      else
        p [[ Зачем ей это? ]]
      end
      return false
    end
  end,
}:disable()

water = obj {
  nam = function()
    return false
  end,
}

egg = obj {
  nam = function(s)
    if cup.obj:srch(s) then
      return false
    else
      return 'яйцо'
    end
  end,
  inv = [[ Сырое куриное яйцо. Я стараюсь обращаться с ним аккуратно -- не хочется потом ходить в липкой одежде. ]],
  use = function(s, w)
    if w == cup then
      p [[ Аккуратно разбив яйцо, я отделил желток и влил его в стакан. Остальное отправилось в помои. ]]
      move(s, 'cup', inv())
    else
      p [[ Нет, я пока приберегу его. ]]
    end
  end,
}

tomato = obj {
  nam = function()
    return false
  end,
}

aspirin = obj {
  nam = function(s)
    if cup.obj:srch(s) then
      return false
    else
      return 'аспирин'
    end
  end,
  inv = [[ Таблетка аспирина. Срок годности пока не истек. ]],
  use = function(s, w)
    if w == cup then
      local cnt, last = cup:what_is_inside()
      if cnt == 0 then
        p [[ Ну кто же кладет таблетку в пустой стакан? Это не по рецепту! ]]
      else
        p [[ Я растолок таблетку и высыпал ее в стакан, помешивая согласно рецепту. ]]
        move(s, 'cup', inv())
      end
    else
      p [[ Нет, я пока приберегу его. ]]
    end
  end,
}

lighter = obj {
  nam = 'зажигалка',
  dsc = [[ {зажигалка} и ]],
  tak = [[ Я взял зажигалку. ]],
  inv = [[ Обычная газовая зажигалка. Почти полная. ]],
  use = function(s, w)
    if stead.nameof(here()) == 'Подсобка' then
      p [[ Ни в коем случае! Здесь так тесно и кругом пыль -- я не хочу устроить пожар! ]]
    elseif w == guitar then
      p [[ Нет! Я так её просто сожгу. ]]
    elseif w == key and sam._aim == 1 then
      if stead.nameof(here()) == 'Подсобка' then
        p [[ Здесь слишком тесно и я боюсь устроить пожар. ]]
      elseif stead.nameof(here()) == 'За сценой' then
        p [[ На открытом огне я докрасна раскалил кончик ключа. ]]
        w._is_hot = true
        timer:set(4000)
      else
        p [[ Думаю, лучше это сделать в более укромном месте. ]]
      end
    elseif (w._is_musician and w ~= chuck) or stead.nameof(w) == 'охранник' or stead.nameof(w) == 'босс' then
      p [[ Я думаю, у него есть своя. ]]
    elseif (w._is_girl) then
      p [[ А может она не курит? ]]
    else
      p [[ Ну что за ребячество? ]]
    end
  end
}

analgin = obj {
  nam = function(s)
    if cup.obj:srch(s) then
      return false
    else
      return 'анальгин'
    end
  end,
  dsc = function()
    if not here().obj:srch('кулер') then
      p [[ начатая упаковка {анальгина}. ]]
    end
  end,
  act = function(s)
    if have(s) or cup.obj:srch(s) then
      p [[ Ещё осталось несколько таблеток. ]]
    else
      p [[ Я взял одну таблетку. ]]
      inv():add(s)
    end
  end,
  inv = [[ Таблетка анальгина. Срок годности пока не истек. ]],
  use = function(s, w)
    if w == cup then
      local cnt, last = cup:what_is_inside()
      if cnt == 0 then
        p [[ Ну кто же кладет таблетку в пустой стакан?  ]]
      else
        p [[ Я растолок таблетку и высыпал ее в стакан, как полагается. ]]
        move(s, 'cup', inv())
      end
    else
      p [[ Нет, я пока приберегу его. ]]
    end
  end,
}
