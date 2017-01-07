-- $Name: ИНСТЕДОЗ 3: Последний рейс$
-- $Version: 0.4$
instead_version "1.9.1"
require "lib"
require "para"
require "dash"
require "quotes"
require "timer"
require "xact"
require "sprites"

main = room {
   nam = "Об игре"
  ,pic = function(s)
    s:ensurecache();
    return game.cache;
   end
  ,ensurecache = function(s)
    if game.cache == nil then
      game.cache = sprite.load("gfx/pic.png");
    else
      local pt = sprite.blank(500, 200);
      sprite.copy(pt, game.cache, 0, 0);
      sprite.free(pt);
    end
   end
  ,enter = function(s)
    if iscomplete("insteadose") or main.insteadose then
      music_("poppies",0)();
      prefs["insteadose"] = nil;
      prefs:store();
      main.insteadose = true;
    else
      music_("railroad",0)();
    end
    timer:set(90);
   end
  ,timer = function(s)
    if s.cachesf == nil then
      s.cachesf = sprite.load("gfx/starfield.png");
    end
    if s.cachesf2 == nil then
      s.cachesf2 = sprite.load("gfx/caption.png");
    end
    if s._x == nil then
      s._x = 0;
    end
    local w = 500;
    if s._x > 500 then
      w = w - (s._x-500);
    end
    sprite.copy(s.cachesf, s._x, 0, w, 200, game.cache, 0, 0);
    if s._x > 500 then
      sprite.copy(s.cachesf, 0, 0, 500-w, 200, game.cache, w, 0);
    end
    sprite.draw(s.cachesf2, game.cache, 0, 0);
    s._x = s._x + 2;
    if s._x > 1000 then
      s._x = 0;
    end
   end
  ,exit = function(s)
    if s.cachesf ~= nil then
      sprite.free(s.cachesf);
      s.cachesf = nil;
    end
    if s.cachesf2 ~= nil then
      sprite.free(s.cachesf2);
      s.cachesf2 = nil;
    end
    s._x = nil;
    timer:stop();
   end
  ,dsc =
    [["ИНСТЕДОЗ 3" -- это сборник небольших текстовых игр, написанных разными авторами в рамках единого сюжета. Сборник включает в себя
      17 самостоятельных игр, однако все они складываются в единую историю, поэтому мы советуем вам пройти "ИНСТЕДОЗ 3" последовательно,
      начиная с пролога и до самого конца.^^
      "ИНСТЕДОЗ 3" проводился в 2013 году. В создании этого сборника принимали участие двенадцать авторов. Подробную информацию о создателях
      смотрите в разделе "Создатели".^^
      Версия 0.4]]
}

credits = room {
   nam = "Создатели"
  ,pic = main.pic
  ,ensurecache = main.ensurecache
  ,exit = main.exit
  ,enter = main.enter
  ,timer = main.timer
  ,dsc = 
    txtb("Платформа INSTEAD:").. " Пётр Косых^" ..
    txtb("Подготовка сборника:").." Василий Воронков^^"..
    txtb("Авторы игр:")..
    [[^Андрей Лобанов ("Разорванный цикл", "Сон")
      ^Антон и Ольга Колосовы ("Пробуждение-2")
      ^Василий Воронков ("Вахта", "Долгая служба", "Ремонт", "Банкет", "Крысиная нора")
      ^Дмитрий Дударь ("Пояс астероидов")
      ^Дмитрий Колесников ("Пробуждение")
      ^Егор Харват ("Повар")
      ^Максим Клиш ("Старый друг")
      ^Максим "j-maks" ("Робот, который видит...")
      ^Пётр Косых ("Отсек К007", "Прибытие")
      ^Роман "Irreman" ("Инженер")
      ^zerg.pro ("Личность")^^]]..
    txtb("Музыка:")..
    [[^8bit Betty ("Spooky Loop")
      ^J. Arthur Keenes ("The Day Before Boxing Day Eve")
      ^Rolemusic ("Ladybug Castle", "Spell", "Scape from the city", "Death on the battlefield", "Poppies")
      ^Goto80 ("this machine thinks", "square and enjoy", "influensa", "datagroove", "5pyhun73r 3l337 v3r")
      ^Edward Shallow ("The Infinite Railroad")^^
     ]]..
     txtb("Шрифты:")..
     [[^Pixel Font-7 (разработчик www.styleseven.com, бесплатен для бесплатного ПО)
       ^Terminus (SIL OFL 1.1)^^
     ]]..
     txtb("Код и графика:^")..
     [[Весь код игр, библиотечный код, а также всё графическое оформление доступны под лицензией CC BY 4.0^^
      (Подробную информацию о лицензиях см. в прилагаемом файле licenses.txt)]]
}

function chapter(s)
  local nam = s.nam;
  s.nam = function(s)
    if iscomplete(deref(s)) then
      return img("pad:0 5 0 0,gfx/dot2.png")..nam;
    else
      return img("pad:0 5 0 0,gfx/dot.png")..nam;
    end
  end
  s.inv = function(s)
    local nm = deref(s);
    if nm == "endtitles" then theme.gfx.mode("direct"); end
    gamefile_(nm..".lua")();
  end
  return menu(s);
end

before_About = menu {
   nam = "Об игре"
  ,inv = function() walk(main) end
}

before_Credits = menu {
   nam = "Создатели"
  ,inv = function() walk(credits) end
}

empty = menu { nam = "" }

prologue = chapter {
  nam = "Пролог"
}
rat = chapter {
  nam = "Крысиная нора"
}
longwork = chapter {
  nam = "Долгая служба"
}
repair = chapter {
  nam = "Ремонт"
}
crio = chapter {
  nam = "Отсек 007"
}
watch = chapter {
  nam = "Вахта"
}
brokencycle = chapter {
  nam = "Разорванный цикл"
}
meteor = chapter {
  nam = "Пояс астероидов"
}
robot = chapter {
  nam = "Робот, который видит"
}
engineer = chapter {
  nam = "Инженер"
}
oldfriend = chapter {
  nam = "Старый друг"
}
cook = chapter {
  nam = "Повар"
}
dream = chapter {
  nam = "Сон"
}
nightmare = chapter {
  nam = "Банкет"
}
persona = chapter {
  nam = "Личность"
}
wake = chapter {
  nam = "Пробуждение"
}
wake2 = chapter {
  nam = "Пробуждение 2"
}
arrival = chapter {
  nam = "Прибытие"
}

endtitles = chapter {
  nam = "Титры"
}

function init()
  take(before_About);
  take(before_Credits);
  take(empty);
  take(prologue);
  take(rat);
  take(longwork);
  take(repair);
  take(crio);
  take(watch);
  take(brokencycle);
  take(meteor);
  take(robot);
  take(engineer);
  take(oldfriend);
  take(cook);
  take(dream);
  take(nightmare);
  take(persona);
  take(wake);
  take(wake2);
  take(arrival);
  --take(endtitles);
end