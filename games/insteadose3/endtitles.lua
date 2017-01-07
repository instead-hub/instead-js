require "sprites"
require "timer"
require "xact"
require "lib"

function cleanlines()
  if game.cachefontbox == nil then
    game.cachefontbox = sprite.box(465, 260, "black");
  end
  sprite.copy(game.cachefontbox, sprite.screen(), 45, 300);
end

function drawline(txt,y)
  if game.cachefont == nil then
    game.cachefont = sprite.font("theme/pf7.ttf", 22);
  end
  local w, h = sprite.text_size(game.cachefont, txt);
  local tz = sprite.text(game.cachefont, txt, "gray");
  sprite.draw(tz, sprite.screen(), (465-w)/2+30, y);
  sprite.free(tz);
  sprite.free(bx);
end

function titleroom(r)
  local timer = r.timer;
  r.timer = function(s)
    if game.codec == nil then
      game.codec = 0;
    end
    local spr = loadsprite("code");
    sprite.copy(spr, 0, game.codec, 180, 483, sprite.screen(), 578, 35);
    game.codec = game.codec + 2;
    if timer ~= nil then
      return timer(s);
    end
  end
  return room(r);
end

function drawbg(s)
  if not main.bgdrawn then
    local px = sprite.load("theme/back.png");
    sprite.copy(px, sprite.screen(), 0, 0);
    sprite.free(px);
    main.bgdrawn = true;
  end
  if not s.bgdrawn then
    local px = sprite.box(500, 200, "black");
    sprite.copy(px, sprite.screen(), 30, 30);
    sprite.free(px);
    cleanlines();
    s.bgdrawn = true;
  end
end

main = room {
   nam = ""
  ,enter = function(s)
    mute_(0,0)();
    music_("datagroove")();
    timer:set(600);
   end
  ,timer = function(s)
    timer:stop();
    walk(title1);
   end
}

title1 = titleroom {
   nam = ""
  ,enter = function(s)
    timer:set(200);
   end
  ,prepare = function(s)
      drawbg(s);
      if not s.directdrawn then
        local tab = sprite.load("gfx/table5.png");
        sprite.copy(tab, sprite.screen(), 130, 110);
        sprite.free(tab);
        local door = sprite.load("gfx/door4.png");
        sprite.copy(door, 0, 0, 70, 140, sprite.screen(), 460, 90);
        sprite.free(door);
        s.directdrawn = true;
      end
   end
  ,timer = function(s)
    s:prepare();
    if s._frame == nil then
      s._frame = 0;
    end
    local spr1 = loadsprite("ratsmall");
    local spr2 = loadsprite("rat");
    if s._frame == 1 then
      play_sound("cork");
      sprite.copy(spr1, sprite.screen(), 40, 195);
    elseif s._frame == 2 then
      sprite.copy(spr2, sprite.screen(), 40, 165);
    elseif s._frame == 4 then
      play_sound("cork");
      sprite.copy(spr1, sprite.screen(), 120, 135);
    elseif s._frame == 5 then
      sprite.copy(spr2, sprite.screen(), 120, 105);
    elseif s._frame == 7 then
      play_sound("cork");
      sprite.copy(spr1, sprite.screen(), 270, 135);
    elseif s._frame == 8 then
      sprite.copy(spr2, sprite.screen(), 270, 105);
    elseif s._frame == 10 then
      play_sound("cork");
      sprite.copy(spr1, sprite.screen(), 340, 195);
    elseif s._frame == 11 then
      sprite.copy(spr2, sprite.screen(), 340, 165);
    elseif s._frame == 13 then
      play_sound("cork");
      sprite.copy(spr1, sprite.screen(), 405, 195);
    elseif s._frame == 14 then
      sprite.copy(spr2, sprite.screen(), 405, 165);
    elseif s._frame == 16 then
      drawline("платформа instead", 400);
      drawline("ПЁТР КОСЫХ", 430);
    elseif s._frame == 26 then
      cleanlines();
      drawline("составление сборника", 400);
      drawline("ВАСИЛИЙ ВОРОНКОВ", 430);
    elseif s._frame == 36 then
      cleanlines();
      drawline("графика и оформление", 400);
      drawline("ВАСИЛИЙ ВОРОНКОВ", 430);
    elseif s._frame == 46 then
      return walk(title2);
    end
    s._frame = s._frame + 1;
   end
  ,exit = function(s)
    timer:stop();
    s._frame = nil;
   end
}

title2 = titleroom {
   nam = ""
  ,enter = function(s)
    timer:set(200);
   end
  ,prepare = function(s)
    drawbg(s);
   end
  ,timer = function(s)
    s:prepare();
    if s._frame == nil then
      s._frame = 0;
    end
    if s.bx == nil then
      s.bx = sprite.box(300, 172, "black");
    end
    local spr4 = loadsprite("crio_blood");
    
    local spr1 = loadsprite("mutant2");
    local spr2 = loadsprite("mutant3");
    local spr3 = loadsprite("mutant4");
    
    if s._frame == 1 then
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr3, sprite.screen(), 150, 58);
    elseif s._frame == 2 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr2, sprite.screen(), 155, 58);
    elseif s._frame == 3 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr1, sprite.screen(), 160, 58);
    elseif s._frame == 4 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr2, sprite.screen(), 155, 58);
    elseif s._frame == 5 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr3, sprite.screen(), 150, 58);
      
    
    elseif s._frame == 6 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr2, sprite.screen(), 155, 58);
    elseif s._frame == 7 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr1, sprite.screen(), 160, 58);
    elseif s._frame == 8 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr2, sprite.screen(), 155, 58);
    elseif s._frame == 9 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr3, sprite.screen(), 150, 58);
    
    
    elseif s._frame == 10 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr2, sprite.screen(), 155, 58);
    elseif s._frame == 11 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr1, sprite.screen(), 160, 58);
    elseif s._frame == 12 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr2, sprite.screen(), 155, 58);
    elseif s._frame == 13 then
      sprite.copy(s.bx, sprite.screen(), 150, 58);
      sprite.copy(spr4, sprite.screen(), 230, 75);
      sprite.draw(spr3, sprite.screen(), 150, 58);
    
    elseif s._frame == 15 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("АНДРЕЙ ЛОБАНОВ", 430);
    elseif s._frame == 25 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("АНТОН И ОЛЬГА КОЛОСОВЫ", 430);
    elseif s._frame == 35 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("ВАСИЛИЙ ВОРОНКОВ", 430);
    elseif s._frame == 45 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("ДМИТРИЙ ДУДАРЬ", 430);
    elseif s._frame == 55 then
      return walk(title3);
    end
    
    s._frame = s._frame + 1;
   end
  ,exit = function(s)
    timer:stop();
    s._frame = nil;
    if s.bx ~= nil then
      sprite.free(s.bx);
      s.bx = nil;
    end
   end
}

title3 = titleroom {
   nam = ""
  ,enter = function(s)
    timer:set(200);
   end
  ,prepare = function(s)
      drawbg(s);
   end
  ,timer = function(s)
    s:prepare();
    if s._frame == nil then
      s._frame = 0;
    end
    if s.bx == nil then
      s.bx = sprite.box(60, 65, "black");
    end
    if s.bx2 == nil then
      s.bx2 = sprite.box(40, 45, "black");
    end
    local spr1 = loadsprite("rat");
    local spr2 = loadsprite("rat_dead");
    if s._frame == 1 then
      sprite.copy(spr1, sprite.screen(), 400, 165);
    elseif s._frame == 2 then
      sprite.copy(s.bx, sprite.screen(), 400, 165);
      sprite.copy(spr1, sprite.screen(), 390, 160);
    elseif s._frame == 3 then
      sprite.copy(s.bx, sprite.screen(), 390, 160);
      sprite.copy(spr1, sprite.screen(), 380, 155);
    elseif s._frame == 4 then
      sprite.copy(s.bx, sprite.screen(), 380, 155);
      sprite.copy(spr1, sprite.screen(), 370, 150);
    elseif s._frame == 5 then
      sprite.copy(s.bx, sprite.screen(), 370, 150);
      sprite.copy(spr1, sprite.screen(), 360, 155);
    elseif s._frame == 6 then
      sprite.copy(s.bx, sprite.screen(), 360, 155);
      sprite.copy(spr1, sprite.screen(), 350, 160);
    elseif s._frame == 7 then
      sprite.copy(s.bx, sprite.screen(), 350, 160);
      sprite.copy(spr1, sprite.screen(), 340, 165);
    
    elseif s._frame == 8 then
      sprite.copy(s.bx, sprite.screen(), 340, 165);
      sprite.copy(spr1, sprite.screen(), 330, 160);
    elseif s._frame == 9 then
      sprite.copy(s.bx, sprite.screen(), 330, 160);
      sprite.copy(spr1, sprite.screen(), 320, 155);
    elseif s._frame == 10 then
      sprite.copy(s.bx, sprite.screen(), 320, 155);
      sprite.copy(spr1, sprite.screen(), 310, 150);
    elseif s._frame == 11 then
      sprite.copy(s.bx, sprite.screen(), 310, 150);
      sprite.copy(spr1, sprite.screen(), 300, 155);
    elseif s._frame == 12 then
      sprite.copy(s.bx, sprite.screen(), 300, 155);
      sprite.copy(spr1, sprite.screen(), 290, 160);
    elseif s._frame == 13 then
      sprite.copy(s.bx, sprite.screen(), 290, 160);
      sprite.copy(spr1, sprite.screen(), 280, 165);

    elseif s._frame == 14 then
      sprite.copy(s.bx, sprite.screen(), 280, 165);
      sprite.copy(spr1, sprite.screen(), 270, 160);
    elseif s._frame == 15 then
      sprite.copy(s.bx, sprite.screen(), 270, 160);
      sprite.copy(spr1, sprite.screen(), 260, 155);
    elseif s._frame == 16 then
      sprite.copy(s.bx, sprite.screen(), 260, 155);
      sprite.copy(spr1, sprite.screen(), 250, 150);
    elseif s._frame == 17 then
      sprite.copy(s.bx, sprite.screen(), 250, 150);
      sprite.copy(spr1, sprite.screen(), 240, 155);
    elseif s._frame == 18 then
      sprite.copy(s.bx, sprite.screen(), 240, 155);
      sprite.copy(spr1, sprite.screen(), 230, 160);
    elseif s._frame == 19 then
      sprite.copy(s.bx, sprite.screen(), 230, 160);
      sprite.copy(spr1, sprite.screen(), 220, 165);
    
    elseif s._frame == 20 then
      sprite.draw(loadsprite("shoot"), sprite.screen(), 30, 180);
    elseif s._frame == 21 then  
      sprite.copy(s.bx2, sprite.screen(), 30, 180);
      sprite.draw(loadsprite("shoot"), sprite.screen(), 70, 180);
    elseif s._frame == 22 then
      sprite.copy(s.bx2, sprite.screen(), 70, 180);
      sprite.draw(loadsprite("shoot"), sprite.screen(), 110, 180);
    elseif s._frame == 23 then
      sprite.copy(s.bx2, sprite.screen(), 110, 180);
      sprite.draw(loadsprite("shoot"), sprite.screen(), 150, 180);
    elseif s._frame == 24 then
      sprite.copy(s.bx2, sprite.screen(), 150, 180);
      sprite.draw(loadsprite("shoot"), sprite.screen(), 190, 180);
    elseif s._frame == 25 then
      sprite.copy(s.bx2, sprite.screen(), 190, 180);
      sprite.copy(spr2, sprite.screen(), 220, 130);
    
     
    elseif s._frame == 27 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("ДМИТРИЙ КОЛЕСНИКОВ", 430);
    elseif s._frame == 37 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("ЕГОР ХАРВАТ", 430);
    elseif s._frame == 47 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("МАКСИМ КЛИШ", 430);
    elseif s._frame == 57 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("МАКСИМ J-MAKS", 430);
    elseif s._frame == 67 then
      return walk(title4);
    end
    s._frame = s._frame + 1;
   end
  ,exit = function(s)
    timer:stop();
    s._frame = nil;
    if s.bx ~= nil then
      sprite.free(s.bx);
      s.bx =nil;
    end
    if s.bx2 ~= nil then
      sprite.free(s.bx2);
      s.bx2=nil;
    end
   end
}

title4 = titleroom {
   nam = ""
  ,enter = function(s)
    timer:set(200);
   end
  ,prepare = function(s)
      drawbg(s);
   end
  ,timer = function(s)
    s:prepare();
    if s._frame == nil then
      s._frame = 0;
    end
    if s.bx == nil then
      s.bx = sprite.box(200, 125, "black");
    end
    local spr1 = loadsprite("robodance1");
    local spr2 = loadsprite("robodance2");
    local spr3 = loadsprite("robodance3");
    local spr4 = loadsprite("robodance4");
    local spr5 = loadsprite("robodance5");
    local spr6 = loadsprite("robodance6");
    
    if s._frame == 1 then
      sprite.copy(spr2, sprite.screen(), 180, 105);
    elseif s._frame == 2 then
      sprite.copy(s.bx, sprite.screen(), 180, 105);
      sprite.copy(spr2, sprite.screen(), 170, 105);
    elseif s._frame == 3 then
      sprite.copy(s.bx, sprite.screen(), 170, 105);
      sprite.copy(spr2, sprite.screen(), 160, 105);
    elseif s._frame == 4 then
      sprite.copy(s.bx, sprite.screen(), 160, 105);
      sprite.copy(spr2, sprite.screen(), 150, 105);
    elseif s._frame == 5 then
      sprite.copy(s.bx, sprite.screen(), 150, 105);
      sprite.copy(spr3, sprite.screen(), 160, 105);
    elseif s._frame == 6 then
      sprite.copy(s.bx, sprite.screen(), 160, 105);
      sprite.copy(spr3, sprite.screen(), 170, 105);
    elseif s._frame == 7 then
      sprite.copy(s.bx, sprite.screen(), 170, 105);
      sprite.copy(spr3, sprite.screen(), 180, 105);
    elseif s._frame == 8 then
      sprite.copy(s.bx, sprite.screen(), 180, 105);
      sprite.copy(spr3, sprite.screen(), 190, 105);
    elseif s._frame == 9 then
      sprite.copy(s.bx, sprite.screen(), 190, 105);
      sprite.copy(spr3, sprite.screen(), 200, 105);
    elseif s._frame == 10 then
      sprite.copy(s.bx, sprite.screen(), 200, 105);
      sprite.copy(spr2, sprite.screen(), 190, 105);
    elseif s._frame == 11 then
      sprite.copy(s.bx, sprite.screen(), 190, 105);
      sprite.copy(spr2, sprite.screen(), 180, 105);
    elseif s._frame == 11 then
      sprite.copy(spr4, sprite.screen(), 180, 105);
    elseif s._frame == 12 then
      sprite.copy(spr5, sprite.screen(), 180, 105);
    elseif s._frame == 13 then
      sprite.copy(spr6, sprite.screen(), 180, 105);
    
    elseif s._frame == 15 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("ПЁТР КОСЫХ", 430);
    elseif s._frame == 25 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("РОМАН IRREMAN", 430);
    elseif s._frame == 35 then
      cleanlines();
      drawline("авторы игр", 400);
      drawline("ZERG.PRO", 430);
    elseif s._frame == 45 then
      return walk(title5);
    end
    
    s._frame = s._frame + 1;
   end
  ,exit = function(s)
    timer:stop();
    s._frame = nil;
    if s.bx ~= nil then
      sprite.free(s.bx);
      s.bx = nil;
    end
   end
}

title5 = titleroom {
   nam = ""
  ,enter = function(s)
    timer:set(200);
   end
  ,prepare = function(s)
      drawbg(s);
      if not s.directdrawn then
        local spr = loadsprite("hatch2");
        sprite.copy(spr, sprite.screen(), 330, 30);
        s.directdrawn = true;
      end
   end
  ,timer = function(s)
    s:prepare();
    if s._frame == nil then
      s._frame = 0;
    end
    if s.bx == nil then
      s.bx = sprite.box(55, 124, "black");
    end
    if s.bx2 == nil then
      s.bx2 = sprite.box(240, 80, "black");
    end
    local spr1 = loadsprite("zombi");
    local spr2 = loadsprite("zombi_short");
    if s._frame == 1 then
      sprite.copy(spr1, sprite.screen(), 400, 105);
    elseif s._frame == 2 then
      sprite.copy(s.bx, sprite.screen(), 400, 105);
      sprite.copy(spr2, sprite.screen(), 395, 105);
    elseif s._frame == 3 then
      sprite.copy(s.bx, sprite.screen(), 395, 105);
      sprite.copy(spr1, sprite.screen(), 390, 105);
    elseif s._frame == 4 then
      sprite.copy(s.bx, sprite.screen(), 390, 105);
      sprite.copy(spr2, sprite.screen(), 385, 105);
    elseif s._frame == 5 then
      sprite.copy(s.bx, sprite.screen(), 385, 105);
      sprite.copy(spr1, sprite.screen(), 380, 105);
    elseif s._frame == 6 then
      sprite.copy(s.bx, sprite.screen(), 380, 105);
      sprite.copy(spr2, sprite.screen(), 375, 105);
    elseif s._frame == 7 then
      sprite.copy(s.bx, sprite.screen(), 375, 105);
      sprite.copy(spr1, sprite.screen(), 370, 105);
      
    elseif s._frame == 8 then
      sprite.copy(s.bx, sprite.screen(), 370, 105);
      sprite.copy(spr2, sprite.screen(), 365, 105);
    elseif s._frame == 9 then
      sprite.copy(s.bx, sprite.screen(), 365, 105);
      sprite.copy(spr1, sprite.screen(), 360, 105);
    elseif s._frame == 10 then
      sprite.copy(s.bx, sprite.screen(), 360, 105);
      sprite.copy(spr2, sprite.screen(), 355, 105);
    elseif s._frame == 11 then
      sprite.copy(s.bx, sprite.screen(), 355, 105);
      sprite.copy(spr1, sprite.screen(), 350, 105);
    elseif s._frame == 12 then
      sprite.copy(s.bx, sprite.screen(), 350, 105);
      sprite.copy(spr2, sprite.screen(), 345, 105);
    elseif s._frame == 13 then
      sprite.copy(s.bx, sprite.screen(), 345, 105);
      sprite.copy(spr1, sprite.screen(), 340, 105);
    
    elseif s._frame == 14 then
      sprite.copy(s.bx, sprite.screen(), 340, 105);
      sprite.copy(spr2, sprite.screen(), 335, 105);
    elseif s._frame == 15 then
      sprite.copy(s.bx, sprite.screen(), 335, 105);
      sprite.copy(spr1, sprite.screen(), 330, 105);
    elseif s._frame == 16 then
      sprite.copy(s.bx, sprite.screen(), 330, 105);
      sprite.copy(spr2, sprite.screen(), 325, 105);
    elseif s._frame == 17 then
      sprite.copy(s.bx, sprite.screen(), 325, 105);
      sprite.copy(spr1, sprite.screen(), 320, 105);
    elseif s._frame == 18 then
      sprite.copy(s.bx, sprite.screen(), 320, 105);
      sprite.copy(spr2, sprite.screen(), 315, 105);
    elseif s._frame == 19 then
      sprite.copy(s.bx, sprite.screen(), 315, 105);
      sprite.copy(spr1, sprite.screen(), 310, 105);
    elseif s._frame == 20 then
      sprite.copy(loadsprite("doorclose"), sprite.screen(), 40, 120);
    elseif s._frame == 23 then
      sprite.copy(s.bx2, sprite.screen(), 40, 120);
      sprite.copy(s.bx, sprite.screen(), 310, 105);
      sprite.draw(loadsprite("zombi_dead"), sprite.screen(), 260, 175);
      sprite.copy(loadsprite("hatch"), sprite.screen(), 330, 30);
    
    
    elseif s._frame == 25 then
      cleanlines();
      drawline("музыка", 400);
      drawline("8BIT BETTY", 430);
    elseif s._frame == 35 then
      cleanlines();
      drawline("музыка", 400);
      drawline("J. ARTHUR KEENES", 430);
    elseif s._frame == 45 then
      cleanlines();
      drawline("музыка", 400);
      drawline("ROLEMUSIC", 430);
    elseif s._frame == 55 then
      cleanlines();
      drawline("музыка", 400);
      drawline("GOTO80", 430);
    elseif s._frame == 65 then
      cleanlines();
      drawline("музыка", 400);
      drawline("EDWARD SHALLOW", 430);
    elseif s._frame == 75 then
      mute_()();
      theme.gfx.reset();
      main.bgdrawn = nil;
      title1.directdrawn=nil;
      title2.directdrawn=nil;
      title3.directdrawn=nil;
      title4.directdrawn=nil;
      title5.directdrawn=nil; 
      title1.bgdrawn=nil;
      title2.bgdrawn=nil;
      title3.bgdrawn=nil;
      title4.bgdrawn=nil;
      title5.bgdrawn=nil;
      game.codec=nil;
      if game.cachefont ~= nil then
        sprite.free_font(cachefont);
        game.cachefont = nil;
      end
      if game.cachefontbox ~= nil then
        sprite.free(game.cachefontbox);
        game.cachefontbox = nil;
      end
      return walk(hend1);
    end
    
    s._frame = s._frame + 1;
   end
  ,exit = function(s)
    timer:stop();
    s._frame = nil;
    if s.bx ~= nil then
      sprite.free(s.bx);
      s.bx = nil;
    end
    if s.bx2 ~= nil then
      sprite.free(s.bx2);
      s.bx2 = nil;
    end
   end
}

hend1 = room {
   nam = "Конец"
  ,pxa = {
    { "planet", 172, 22 }
  }
  ,dsc = "{xwalk(hend2)|-- Адмирал, есть ещё кое-что...}"
}

hend2 = room {
	nam = 'Конец';
  enter = music_("poppies",0);
  pxa = {
    { "planet", 172, 22 }
  };
  act = function()
    complete_("insteadose")();
    gamefile_("main.lua")();
  end;
	dsc = [[
		-- Я думаю вы должны знать.^
		-- Да?^
		-- Мы выяснили, куда делись жители планеты...^
		-- И?^
		-- Похоже, они отправились к Земле...
	]];
  obj = { vobj("next", txtc("{КОНЕЦ}")) }
}





