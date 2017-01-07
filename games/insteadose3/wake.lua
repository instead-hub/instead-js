-- $Name: Пробуждение$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
game.use = "Нет, так ничего не выйдет."

main = room {
  nam = "...",
  enter = music_("spookyloop",0),
  title = {"П", "Р", "О", "Б", "У", "Ж", "Д", "Е", "Н", "И", "Е"},
  num =15,
  act = function() walk(room1) end,
  dsc = [[Я слышал об этом, но никогда не верил, что это действительно может произойти.
          Говорят, что есть один шанс из миллиона, что человек не сможет проснуться после криосна.
          Тело его просыпается, но разум остаётся где-то там -- в чёрной космической безде.
          Сохраняются только основные инстинкты.^
          Я слышал об этом, но никогда не верил, что это может действительно произойти.]],
  obj = { vobj("next", '{Начать игру}') }
}

room1 = room {
  nam = "К007",
  pxa = {
    { "crio", 10 },
    { "med", 310 },
    { "door4", 370 }
  },
  enter = function() 
    if room1_neibor._zombi then
      p "Нет, туда пути больше нет.";
      return false 
    end
  end,
  dsc = "Я в крио-отсеке. Сложно поверить в то, что я спал больше тысячи лет. Кажется, только вчера мы улетели с Земли.",
  obj = { "room1_capsulas", "room1_neibor", "room1_door", "room1_med" },
  way = { "coridor" }
}

room1_capsulas = obj {
  nam = "капсулы",
  dsc = "Здесь {шесть капсул}, но отключаются они постепенно. Сейчас отключилась только моя и моего соседа справа.",
  act = "Стандартные капсулы для криосна."
}

room1_neibor = obj {
  nam = "сосед",
  dsc = function(s)
    if room1_neibor._zombi then
      return "{Александр} слепо наступает на меня, издавая странный тяжёлый хрип.";
    else
      return "Я его почти не знаю. Но, кажется, его зовут {Александр}. Он плохо выглядит -- сидит и неподвижно смотрит в одну точку.";
    end
  end,
  act = function(s)
    if room1_neibor._zombi then
      return "Уговоры не помогут, я должен спасаться бегством!";
    else
      return "Он никак на меня не реагирует -- просто смотрит в одну точку. Надо бы ему помочь."
    end
  end
}

room1_door = obj {
  nam = "дверь",
  dsc = "На стене у {двери}",
  act = function()
    if room1_neibor._zombi then
      return "Дверь не закрыта. Нужно бежать отсюда!";
    else
      return "Выход из крио-отсека, в коридор. Но уходить пока рано, надо бы помочь Александру."
    end
  end
}

room1_med = obj {
  nam = "аптечка",
  dsc = "висит {аптечка}.",
  act = function(s)
    if not adrenalin._taken then
      take(adrenalin);
      adrenalin._taken = true;
      return "Я нашёл в аптечке шприц с адреналином. Надо сделать инъекцию Александру.";
    else
      return "Здесь больше нет ничего, что мне было бы нужно.";
    end
  end
}

adrenalin = obj {
  nam = "шприц",
  inv = "Одноразовый шприц с порцией адреналина. Некоторым при выходе из крио-сна это нужно.",
  use = function(s,v)
    if v == room1_neibor then
      remove(s,me());
      room1_neibor._zombi=true;
      return [[Я делаю Александру инъекцию, он странно вздрагивает, смотрит на меня мутными ничего не 
          выражающими глазами, а потом вдруг мощным ударом отшвыривает меня к двери. Не может быть!
          Он не в себе! Я кричу Александру, пытаюсь остановить его, но он как будто не слышит и
          продолжает наступать на меня, вытянув вперёд руки.]];
    end
  end
}

coridor = room {
  nam = "Коридор",
  pxa = {
    { if_("armoryobj._open","door1_open","door1"), 10 },
    { "door2", 200 },
    { if_("not zombi._dead","zombi", "zombi_dead"), if_("not zombi._dead", 420, 380) },
    { if_("not zombi._dead","hatch2", "hatch"), 460 }
  },
  enter = function()
    if not room1_neibor._zombi then
      p "Надо бы сначала помочь Александру.";
      return false;
    end
  end,
  dsc = "Я в коридоре крио-блока.",
  obj = { "lock", "zombi", "elevator", "cleaner", "armoryobj", "codereader" },
  way = { "room1", vroom("Лифт","goodend"), "armory" }
}

zombi = obj {
  nam = "Александр",
  dsc = function(s,v)
    if zombi._dead then
      return "На полу лежит труп {Александра}. Дверь разрубила его тело попалам. Весь пол залит кровью.";
    else
      return "{Александр} идёт прямо на меня. В глазах его горит безумие.";
    end
  end,
  act = function(s,v)
    if zombi._dead then
      return "Очень жаль, что мне пришлось сделать это. Но у меня не было другого выхода.";
    else
      return "Это синдром выхода из криосна. Теперь в этом нет сомнений! Боюсь, ему уже не помочь..."
    end
  end
}

lock = obj {
  nam = "Замок",
  dsc = "На стене у двери в К007 висит {панель} электронного замка.",
  act = function(s)
    if zombi._dead then
      return "Замок разворочен выстрелом.";
    else
      return "Александр уже вышел из комнаты, я не смогу его там закрыть.";
    end
  end
}

elevator = obj {
  nam = "Лифт",
  dsc = "Справа от меня -- {лифт}.",
  act = function(s)
    if zombi._dead then
      return "Лифт уже стоит на этаже. Надо лишь подойти к двери лифта.";
    end
    if s._call then
      return "Я уже вызвал лифт. Вряд ли я смогу как-то ускорить его прибытие.";
    else
      s._call=true;
      return "Я нажимаю на кнопку вызова лифта. Теперь остаётся ждать. Но у меня нет времени! Александр сошёл с ума и идёт прямо на меня!";
    end
  end
}

cleaner = obj {
  nam = "Швабра",
  dsc = "На полу валяется сломанная {швабра}.",
  inv = function(s,v)
    if zombi._dead then
      return "Не думаю, что мне это теперь пригодится.";
    else
      return "Вряд ли из неё получится хорошее оружие. Но кто знает..."
    end
  end,
  tak = "Я поднял швабру.",
  use = function(s,v)
    if v==zombi then
      if zombi._dead then
        return "Он и так мёртв.";
      else
        return walk(badend);
      end
    end
  end
}

armoryobj = obj {
  nam = "Оружейная",
  dsc = "Слева -- вход в {оружейную}.",
  act = function(s)
    if s._exam then
      if s._open then
        return "Дверь открыта.";
      else
        return "У меня должен быть допуск.";
      end
    else
      s._exam=true;
      return "Рядом с дверью висит сканер ретины. У меня должен быть допуск в оружейную.";
    end
  end
}

codereader = obj {
  nam = "Сканер ретины",
  dsc = "Рядом со входом в оружейную висит {сканер ретины}.",
  act = function(s)
    if armoryobj._open then
      return "Дверь уже открыта.";
    else
      armoryobj._open=true;
      return "Я смотрю в окуляры сканера. Проходит долгая секунда. Наконец, дверь открывается.";
    end
  end,
  cnd = function() return armoryobj._exam end
}

armory = room {
  nam = "Оружейная",
  pxa = {
    { "door1_open", 10 },
    { if_("not have(knife)", "knife"), 150 },
    { if_("not have(blaster)","blaster"), 180 },
    { "box", 180 },
    { "box", 280 },
    { "box", 380 },
  },
  enter = function(s)
    if not armoryobj._open then
      p "Дверь в оружейшую закрыта.";
      return false;
    elseif zombi._dead then
      p "Мне туда больше не нужно.";
      return false;
    end
  end,
  dsc = "Я в оружейной.",
  obj = { "knife", "blaster" },
  way = { "coridor" }
}

blaster = obj {
  nam = "Бластер",
  dsc = "Чуть дальше висит {бластер}.",
  tak = "Я взял бластер.",
  use = function(s,v)
    if v==zombi then
      return [[Я пытаюсь выстрелить в Александра, но в ответ мне раздаётся неприятный гудок, и на дисплее оружия высвечивается надпись: "Идентифицирован член экипажа. Выстрел отменён."]];
    elseif v==lock then
      sound_("shoot_lazer")();
      p "Я выстрелил в замок, дверь в К007 опустилась и разрубила Александра попалам. Ужасно! Но у меня не было выхода.^После того как тело Александра упало на пол, я услышал мелодичный звонок. На этаж пришёл лифт.";
      zombi._dead=true;
    else
      return "Это не поможет.";
    end
  end
}

knife = obj {
  nam = "Нож",
  dsc = "У двери висит {нож-пила}.",
  tak = "Я беру нож-пилу.",
  use = function(s,v)
    if v==zombi then
      if zombi._dead then
        return "Он и так мёртв.";
      else
        return walk(badend);
      end
    end
  end
}

badend = room {
  nam = "Конец",
  dsc = [[Я пытаюсь ударить Александра, но он как будто не чувствует удара. В ответ он с нечеловеческой силой отшвыривает меня
          к стене. Я падаю и проваливаюсь в темноту...]]
}

goodend = room {
  nam = "Конец",
  enter = function(s)
    if not zombi._dead then
      p "Лифта ещё нет на этаже.";
      return false;
    end
    mute_()();
    complete_("wake")();
  end,
  dsc = [[Я подхожу к лифту, дверь открывается и...^
          Передо мной оказывается какой-то человек с мутным невидящим взглядом. Не может быть! Ещё один! Руки безумца тянутся ко мне. Я застываю от ужаса, будучи не в силах даже пошевелиться.]],
  act = gamefile_("wake2.lua"),
  obj = { vobj("next", txtc("{КОНЕЦ?}")) }
}

