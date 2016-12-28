-----------------------------------
-- Сэм (ритм-гитара, сатанист)
-----------------------------------

room_sam = room {
  nam = 'Гримёрка ритм-гитариста',
  pic = pic 'img/sam.jpg',
  dsc = [[ Комната в черно-красных тонах. ]],
  enter = function()
    if sam._aim == 2 then
      set_music 'mus/afterlight.ogg'
    else
      set_music 'mus/satan.ogg'
    end
  end,
  way = { vroom('Выйти', 'dressrooms') },
  obj = {
    vobj('пепельница', [[ На столе -- {пепельница} стилизованная под человеческий череп. ]]),
    vobj('свеча', [[ В ней оплавленные остатки {свечи} черного цвета. ]]),
    'bowl',
    'guitar',
    'sam',
  },
}

sam = obj {
  nam = 'Сэм',
  _is_musician = true,
  dsc = function()
    if sam._aim == 2 then
      p [[ Посередине комнаты стоит {Сэм}. ]]
    elseif sam._aim == 1 then
      p [[ У стола вполоборота сидит {Сэм} и вопросительно глядит на меня. ]]
    else
      p [[ На диване полулежит {Сэм}, поглядывая на меня исподлобья. ]]
    end
  end,
  act = code [[ walk 'dlg_sam' ]],
}

bowl = obj {
  nam = 'кубок',
  dsc = [[ Рядом стоит {кубок}, наполненный, судя по всему, кровью.^ ]],
  act = function(s)
    if s._know_tomato then
      p [[ Это же обычный томатный сок! ]]
    else
      p [[ Надеюсь, это бутафорская кровь, а не настоящая. ]]
    end
  end,
}

guitar = obj {
  nam = 'гитара',
  dsc = function()
    if sam._aim == 2 then
      p [[ На плече правой рукой он держит {гитару} на манер героя американского боевика. ]]
    else
      p [[ В углу сиротливо стоит {гитара}. ]]
    end
  end,
  act = function()
    if sam._aim == 1 then
      walk 'dlg_sam_guitar'
    else
      p [[ Музыканты такой нервный народ -- лучше не трогать их инструменты. ]]
    end
  end,
  inv = function(s)
    if s._marked then
      p [[ Отличная гитара, на которой какие-то вандалы занимались выжиганием по дереву. ]]
    else
      p [[ Отличная гитара! Чем она только не нравится Сэму? ]]
    end
  end,
  use = function(s, w)
    if w._is_musician and w ~= sam then
      p [[ У каждого музыканта -- свой инструмент! Это гитара для Сэма. ]]
    elseif s._marked and w == sam then
      p [[ -- Это крутейшая пентаграмма! Спасибо! Теперь я готов к выступлению! ]]
      drop(s)
      sam._aim = 2
      set_music 'mus/afterlight.ogg'
    else
      return false
    end
  end,
}

dlg_sam = dlg {
  nam = 'Ритм-гитарист Сэм',
  pic = pic 'img/sam.jpg',
  hideinv = true,
  talk = {
    {
      [[ Труба зовет, пора на сцену! ]],
      cond = code [[ return sam._aim ~= 2 ]],
      persist = false,
      act = [[ -- Мне не на чем играть. ]],
      {
        [[ Как это? Вот же стоит гитара -- разве с ней что-то не так? ]],
        persist = true,
        act = function()
          p [[ -- С ней всё не так! ]]
          dlg_sam._q_1 = false
          dlg_sam._q_2 = false
          dlg_sam._q_3 = false
        end,
        stage = 'question',
        {
          [[ Она не строит? ]],
          act = function()
            p [[ -- Прекрасно держит тон по всему грифу. ]]
            dlg_sam._q_1 = true
          end,
          stage = 'question',
        },
        {
          [[ Звукосниматель барахлит? ]],
          act = function()
            p [[ -- Звукосниматель работает нормально. ]]
            dlg_sam._q_2 = true
          end,
          stage = 'question',
        },
        {
          [[ Может струны жёсткие? Давай поменяем. ]],
          act = function()
            p [[ -- Отличные струны. ]]
            dlg_sam._q_3 = true
          end,
          stage = 'question',
        },
        {
          [[ Так в чём же тогда, чёрт побери, дело? ]],
          persist = true,
          cond = code [[ return dlg_sam._q_1 and dlg_sam._q_2 and dlg_sam._q_3 ]],
          act = function()
            p [[ -- На моей гитаре есть специальная отметка - выжженная пентаграмма. А здесь нет такой метки. Я не могу играть на инструменте, пока его не коснулось очищающее пламя. ]]
            sam._aim = 1
          end,
        }
      },
      {
        [[ А где твоя гитара? ]],
        act = [[ -- Логистики что-то напутали, и вместо моей привезли вот эту. Но она меня не устраивает. ]],
        stage = 'question',
      },
    },
    {
      [[ Вот же стоит отличная гитара! ]],
      persist = true,
      cond = code [[ return sam._aim == 1 and not have(guitar) ]],
      act = [[ Я не могу играть на ней. ]],
      stage = 'question',
    },
    {
      [[ Я думаю, что смогу помочь тебе с гитарой! ]],
      persist = true,
      cond = code [[ return sam._aim == 1 and have(guitar) and not guitar._marked ]],
      act = [[ -- Надеюсь, сможешь. ]],
    },
    {
      [[ Смотри, на гитаре огненный знак! ]],
      persist = true,
      cond = code [[ return sam._aim == 1 and have(guitar) and guitar._marked ]],
      act = function()
        p [[ -- Это крутейшая пентаграмма! Спасибо! Теперь я готов к выступлению! ]]
        drop(guitar, room_sam)
        sam._aim = 2
        set_music 'mus/afterlight.ogg'
      end,
    },
    {
      [[ Труба зовет, пора на сцену! ]],
      cond = code [[ return sam._aim == 2 ]],
      persist = true,
      act = [[ -- Я готов! ]],
    },
    {
      [[ У тебя чисто случайно нет томатного сока? ]],
      cond = code [[ return cup:need('tomato') ]],
      act = function()
        p [[ -- Есть. Вон стоит на столе, можешь попить. ]]
        bowl._know_tomato = true
      end,
    },
    {
      [[ У тебя чисто случайно нет сырого яйца? ]],
      cond = code [[ return cup:need('egg') ]],
      act = [[ -- Нет ]],
      stage = 'top',
    },
    {
      [[ У тебя чисто случайно нет аспирина? ]],
      cond = code [[ return cup:need('aspirin') ]],
      act = [[ -- Нет ]],
      stage = 'top',
    },
    {
      [[ У тебя чисто случайно нет соли? ]],
      cond = code [[ return cup:need('') ]],
      act = [[ -- Нет. ]],
      stage = 'top',
    },
    {
      [[ У тебя чисто случайно нет красного перца? ]],
      cond = code [[ return cup:need('') ]],
      act = [[ -- Нет. ]],
      stage = 'top',
    },
  }
}

dlg_sam_guitar = dlg {
  nam = 'Ритм-гитарист Джо',
  pic = pic 'img/sam.jpg',
  hideinv = true,
  talk = {
    {
      [[ Да ведь это -- отличная гитара! ]],
      act = [[ -- На ней нет огненной пентаграммы. ]],
    },
    {
      [[ Можно я возьму ненадолго эту гитару? ]],
      act = function()
        p [[ -- Да, конечно, без проблем.^ Я взял гитару.]]
        take(guitar, room_sam)
      end,
    },
  }
}
