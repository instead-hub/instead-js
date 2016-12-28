-- $Name:Рок$
-- $Version:1.01$
-- Created by IntelliJ IDEA.
-- User: epoxa
-- Date: 30.05.15

instead_version "1.9.1"

require "xact"
require "click"
require "dash"
require "para"
require "quotes"
require "dlg"
require "hideinv"
require "walk"
require "nouse"
require "timer"

require "vv_dlg"

game.nouse = [[ Зачем? ]]
game.act = [[ Хм... Да ну нафиг. ]]
game.inv = function(s, w)
  p(w.nam)
end

global {
  use_pics = false
}

main = room {
  nam = 'Пролог',
  forcedsc = true,
  dsc = [[ В детстве мы мечтаем стать космонавтами и супергероями.
  ^
  Повзрослев, мы мечтаем стать рок-звездами – космическая слава и супергеройская популярность прилагаются автоматически.
  Но мало кто знает, что за каждой рок-группой стоит незаметная, но крайне важная фигура, без которой успех может и не прийти…
  ^
  Попробуйте себя в роли менеджера популярного коллектива, окунитесь в атмосферу закулисья шоу-бизнеса
  и рискните достичь вершин музыкального Олимпа, покорив Рок-Империю!
  ^^
  Эпизод I^Опять двадцать пять...
  ]],
  way = {
    vroom('Играть без картинок', 'dlg_intro'),
    vroom('Включить иллюстрации', 'dlg_pics_notice'),
    --    vroom('Начать игру', 'passage'),
    --    vroom('Начать игру', 'the_end'),
  },
}

dlg_pics_notice = room {
  nam = 'Предупреждение',
  pic = 'img/puzzle.png',
  forcedsc = true,
  dsc = [[ На данный момент графика выполнена частично. Не все локации проиллюстрированы, а изображения могут не полностью соответствовать тексту.
   ^Вы можете относиться к иллюстрациям, как к дополнительному элементу оформления, способствующему созданию нужного настроения.
   ^Итак?]],
  way = {
    room {
      nam = 'Хорошо!',
      enter = code [[ use_pics = true; walk 'dlg_intro' ]],
    },
    vroom('Отключить графику', 'dlg_intro'),
  },
}

function pic(src)
  return function()
    if use_pics == true then
      return src
    else
      return false
    end
  end
end

epilog = room {
  nam = 'Эпилог',
  forcedsc = true,
  dsc = [[ Через несколько минут я уже сидел, прикрыв глаза, и устало улыбался. Я снова это сделал! И я, наконец, могу отдохнуть...^
    Стены не могли заглушить мощный поток музыкального драйва, доносившегося из зала.
    Настоящего рока -- такого, какой умеют делать "Bad Instead", когда соберутся.^
    Это -- победа!]],
  enter = function()
    set_music 'mus/rock.ogg'
  end,
  way = {
    vroom('Дальше', 'the_end'),
  },
}

the_end = room {
  nam = 'Об авторах',
  forcedsc = true,
  enter = code [[ format.quotes = false ]],
  dsc = function()
    p [[
      Автор сценария: Саша Amtazy Киндсфатер^
      Программирование: epoxa^
      Иллюстрации: Роман Есенин^
      ^
      В игре использованы музыкальные композиции:^
      D.I.P. Project -- Pacman^
      Euphorya -- Satan^
      Jah Love People -- Rhodes^
      Justin Robert -- (Bossa Nova) A Vida Está^
      Matti Paalanen -- Drum^
      Nexus -- Bitch Or Not To Be^
      Peter Kind -- Rock^
      Stellar Art Wars -- Temptation Dub Bass^
      Twistboy -- Stilbite^
      Whirlwind Storm -- Afterlight^
      ^
      А также звуковые эффекты с сайта www.freesound.org^
    ]]
  end,
  exit = function()
    format.quotes = true
  end,
}

steve = {}
joe = {}
chuck = {}
sean = {}
sam = {}

require "inventory"
require "boss"
require "rooms"

require "steve"
require "joe"
require "sean"
require "chuck"
require "sam"

require "hall"

lifeon(boss_office)

