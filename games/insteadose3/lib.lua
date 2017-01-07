require "sprites"
require "click"
require "snapshots"
require "prefs"

function complete_(game)
  return function()
    prefs[game] = true;
    prefs:store();
  end
end

function iscomplete(game)
  prefs:load();
  return prefs[game] ~= nil;
end

alphas = {
   ["А"] = { 0, 4}
  ,["Б"] = { 5, 4}
  ,["В"] = { 10, 4}
  ,["Г"] = { 15, 4}
  ,["Д"] = { 20, 6}
  ,["Е"] = { 27, 4}
  ,["Ж"] = { 32, 5}
  ,["З"] = { 38, 4}
  ,["И"] = { 43, 4}
  ,["К"] = { 48, 4}
  ,["Л"] = { 53, 5}
  ,["М"] = { 59, 5}
  ,["Н"] = { 65, 4}
  ,["О"] = { 70, 4}
  ,["П"] = { 75, 4}
  ,["Р"] = { 80, 4}
  ,["С"] = { 85, 4}
  ,["Т"] = { 90, 5}
  ,["У"] = { 96, 4}
  ,["Ф"] = { 101, 5}
  ,["Х"] = { 107, 4}
  ,["Ц"] = { 112, 5}
  ,["Ч"] = { 118, 4}
  ,["Ш"] = { 123, 5}
  ,["Щ"] = { 129, 6}
  ,["Ъ"] = { 136, 5}
  ,["Ы"] = { 142, 6}
  ,["Ь"] = { 149, 4}
  ,["Э"] = { 154, 4}
  ,["Ю"] = { 159, 5}
  ,["Я"] = { 165, 4}
  ,["0"] = { 170, 4}
  ,["7"] = { 175, 4}
  ,["2"] = { 180, 4}
  ,["Й"] = { 185, 5}
  ,[" "] = { nil, 2}
}
function drawalpha(num,str)
  local px = game.cache_alpha1;
  if px == nil then
    px = sprite.load("gfx/alpha.png");
    game.cache_alpha1 = px;
  end
  local px2 = game.cache_alpha2;
  if px2 == nil then
    px2 = sprite.load("gfx/nums.png");
    game.cache_alpha2 = px2;
  end
  local len = 0;
  for _,v in ipairs(str) do
    len = len + (alphas[v][2]*5) + 5;
  end
  local spr = sprite.box(500, 200, "black");
  if num ~= nil then
    --28
    local strnum = tostring(num);
    if string.len(strnum) == 1 then
      sprite.copy(px2, num*4*20, 0, 4*20, 140, spr, 210, 30);
    else
      local n1 = string.char(strnum:byte(1))+0;
      local n2 = string.char(strnum:byte(2))+0;
      sprite.copy(px2, n1*4*20, 0, 4*20, 140, spr, 165, 30);
      sprite.copy(px2, n2*4*20, 0, 4*20, 140, spr, 255, 30);
    end
  end
  local xl = (500-len)/2;
  for _,v in ipairs(str) do
    local x,w = alphas[v][1],alphas[v][2];
    if x ~= nil then
      sprite.draw(px, x*5, 0, w*5, 35, spr, xl, 82);
    end
    xl = xl + (w*5) + 5;
  end
  return spr;
end

function cleancache()
  if game.cache_alpha1 ~= nil then
    sprite.free(game.cache_alpha1);
    game.cache_alpha1 = nil;
  end
  if game.cache_alpha2 ~= nil then
    sprite.free(game.cache_alpha2);
    game.cache_alpha2 = nil;
  end
  if game.cache ~= nil then
    sprite.free(game.cache);
    game.cache = nil;
  end
  if game.cache2 ~= nil then
    sprite.free(game.cache2);
    game.cache2 = nil;
  end
  if game.cache_nums ~= nil then
    for k,v in pairs(game.cache_nums) do
      sprite.free(v);
      game.cache_nums[k] = nil;
    end
    game.cache_nums = nil;
  end
  if game.cache_sprites ~= nil then
    for k,v in pairs(game.cache_sprites) do
      sprite.free(v);
      game.cache_sprites[k] = nil;
    end
    game.cache_sprites = nil;
  end
end

local old_snapshot = restore_snapshot;
function restore_snapshot(n)
  cleancache();
  return old_snapshot(n);
end

local old_title = instead.get_title;
instead.get_title = function()
  local r = old_title();
  return txttop(r)..img("blank:10x50");
end

function if_(cnd,x,y)
  return function(s)
    if apply(cnd,s) then
      return x;
    else
      return y;
    end
  end
end

function restart_item(gf)
  restart_obj = menu {
     nam = "restart_item"
    ,disp = txtb("Начать сначала")
    ,inv = gamefile_(gf..".lua")
  };
  sep_obj = menu {nam=" ", inv = function() end};
  take(restart_obj);
  take(sep_obj);
end

local old_room = room;
function room(r)
  if r.title ~= nil then
    r.pic = function(s)
      if s.cache_title == nil then
        s.cache_title = drawalpha(s.num,s.title);
      end
      return s.cache_title;
    end
    local exit = r.exit;
    r.exit = function(s,v,w)
      if exit ~= nil then
        local ret = exit(s,v,w);
        if ret ~= nil then
          return ret;
        end
      end
      if s.cache_title ~= nil then
        sprite.free(s.cache_title);
        s.cache_title = nil;
      end
    end
  end
  return old_room(r);
end

function string:charat(i)
  local c = 0;
  for uchar in string.gfind(self, "([%z\1-\127\194-\244][\128-\191]*)") do
    c = c + 1;
    if c == i then
      return uchar;
    end
  end
end

function timerpause(snum,enum,next)
  local sh = 1;
  if enum < snum then
    sh = -1;
    enum = enum - 1;
  else
    enum = enum + 1;
  end
  if game.cache_nums == nil then
    game.cache_nums = {}
  end
  return room {
    enum = enum, sh = sh, snum = snum,
    _cur = snum, _fr=0,
    nam = "",
    enter = function()
      timer:set(50);
    end,
    pic = function()
      if game.cache2 == nil then
        game.cache2 = sprite.load("gfx/timer1.png");
      end
      return game.cache2;
    end,
    pad = function(s,n)
      local sn = tostring(n);
      if string.len(sn) < 4 then
        return s:pad("0"..sn);
      end
      return sn;
    end,
    loadnum = function(s,n)
      if game.cache_nums[n] == nil then
        game.cache_nums[n] = sprite.load("gfx/"..n..".png");
      end
      return game.cache_nums[n];
    end,
    draw = function(s,d)
      local d = tostring(d);
      local n1,n2,n3,n4 = string.char(d:byte(1)),string.char(d:byte(2)),string.char(d:byte(3)),string.char(d:byte(4));
      local y = 67;
      if s.s1 ~= n1 then
        sprite.copy(s:loadnum(n1), game.cache2, 150+(50*0), y);
        s.s1 = n1;
      end
      if s.s2 ~= n2 then
        sprite.copy(s:loadnum(n2), game.cache2, 150+(50*1), y);
        s.s2 = n2;
      end
      if s.s3 ~= n3 then
        sprite.copy(s:loadnum(n3), game.cache2, 150+(50*2), y);
        s.s3 = n3;
      end
      if s.s4 ~= n4 then
        sprite.copy(s:loadnum(n4), game.cache2, 150+(50*3), y);
        s.s4 = n4;
      end
      if s._cur ~= s.snum then
        play_sound("tick");
      end
    end,
    timer = function(s)
      s._fr = s._fr + 1;
      if not s._nodraw then
        local sn = s:pad(s._cur);
        s:draw(sn);
        if s._fr > 40 then
          s._cur = s._cur + s.sh;
        end
      end
      if s._cur == s.enum then
        if s._nodraw == nil then
          s._nodraw = 0;
        end
        s._nodraw = s._nodraw + 1;
      end
      if s._nodraw ~= nil and (s._nodraw == 80 or s.snum == s.enum) then
        timer:stop();
        s._cur = s.snum;
        s._nodraw = nil;
        s._fr = 0;
        s.s1 = nil;
        s.s2 = nil;
        s.s3 = nil;
        s.s4 = nil;
        walk(next);
      end
    end,
  }
end

function loadsprite(vv)
  if game.cache_sprites == nil then
    game.cache_sprites = {};
  end
  local spr = game.cache_sprites[vv];
  if spr == nil then
    spr = sprite.load("gfx/"..vv..".png");
    game.cache_sprites[vv] = spr;
  end
  return spr;
end

game.pic = 
function()
  local s = here();
  if s.pxa == nil then
    return;
  end
  local pxa = tc(s.pxa,s);
  if pxa == nil then
    return;
  end
  if game.cache == nil then
    game.cache = sprite.load("gfx/pic.png");
  else
    local pt = sprite.blank(500, 200);
    sprite.copy(pt, game.cache, 0, 0);
    sprite.free(pt);
  end
  if game.cache_sprites == nil then
    game.cache_sprites = {};
  end
  for _,v in ipairs(pxa) do
    local vv = tc(v[1],s);
    if vv ~= nil then
      local spr = loadsprite(vv);
      local y = v[3];
      if y == nil then
        if vv == "panel" or vv == "panel_broken" then
          y = 60;
        elseif vv == "door1" or vv == "door1_open" then
          y = 35;
        elseif vv == "door2" or vv == "door3" or vv == "door4" or vv == "door2_open" or vv == "door5" or vv == "door5_open" then
          y = 60;
        elseif vv == "window" or vv == "window2" then
          y = 62;
        elseif vv == "toolbox" then
          y = 171;
        elseif vv == "crio" or vv == "crio_blood" then
          y = 45;
        elseif vv == "robot" or vv == "robot_nohand" or vv == "robot_nohand_blaster" or vv == "robot_cargo" then
          y = 75;
        elseif vv == "box" then
          y = 145;
        elseif vv == "shelf" then
          y = 60;
        elseif vv == "box2" then
          y = 50;
        elseif vv == "rat" then
          y = 135;
        elseif vv == "rat_dead" then
          y = 100;
        elseif vv == "box3" then
          y = 110;
        elseif vv == "blood" then
          y = 107;
        elseif vv == "shaft" or vv == "shaft_open" then
          y = 55;
        elseif vv == "mutant" then
          y = 28;
        elseif vv == "med" then
          y = 60;
        elseif vv == "zombi" then
          y = 75;
        elseif vv == "device" then
          y = 65;
        elseif vv == "bfg" then
          y = 40;
        elseif vv == "hole" then
          y = 65;
        elseif vv == "hole2" then
          y = 35;
        elseif vv == "washer" then
          y = 55;
        elseif vv == "toilet" then
          y = 90;
        elseif vv == "communicator" then
          y = 80;
        elseif vv == "table" or vv == "table3" or vv == "table3_keys" then
          y = 110;
        elseif vv == "extin" then
          y = 145;
        elseif vv == "fridge" then
          y = 105;
        elseif vv == "books" then
          y = 100;
        elseif vv == "table2" then
          y = 140;
        elseif vv == "window3" then
          y = 70;
        elseif vv == "zombi_dead" then
          y = 145;
        elseif vv == "blaster" or vv == "knife" then
          y = 40;
        elseif vv == "vase_flower" or vv == "vase" then
          y = 70;
        elseif vv == "repair" or vv == "repair_broken" or vv == "repair_meteor" then
          y = 95;
        elseif vv == "table4" then
          y = 90;
        elseif vv == "screen" then
          y = 50;
        elseif vv == "door6" then
          y = 100;
        elseif vv == "cheese" then
          y = 160;
        elseif vv == "table5" then
          y = 80;
        elseif vv == "chair1" or vv == "chair2" then
          y = 125;
        elseif vv == "foodgen" or vv=="foodgen2" then
          y = 110;
        elseif vv == "window4" then
          y = 30;
        elseif vv == "table6" then
          y = 140;
        elseif vv == "cleaner" then
          y = 105;
        elseif vv == "ballon" or vv == "ballon2" then
          y = 120;
        elseif vv == "monitor" or vv == "monitor2" then
          y = 50;
        elseif vv == "barrel" or vv == "barrel2" then
          y = 155;
        elseif vv == "ratsmall" then
          y = 165;
        elseif vv == "stick" then
          y = 170;
        end
      end
      sprite.compose(spr, game.cache, tc(v[2],s), y);
    end
  end
  return game.cache;
end

function exec_(s)
  return function(this)
    return exec(s,this);
  end
end

function apply(c,this)
  local f = assert(loadstring("return function(s) return ("..c.."); end"))();
  return f(this);
end

local oob = obj;
function tc(f,s)
if type(f) == "function" then return tc(f(s),s) else return f end
end
function obj(t)
local d = t.dsc;
if t.dsc then
    t.dsc = function(s) if s.cnd == nil or s:cnd() then return tc(d,s) end end
end
return oob(t);
end

function gamefile_(fl)
  return function()
    cleancache();
    gamefile(fl, true);
  end
end

function sound_(snd)
  return function() 
    play_sound(snd);
  end
end

function music_(mus, loop, fadeout, fadein)
  return function() 
    play_music(mus, loop, fadeout, fadein);
  end
end

function mute_(fadeout,fadein)
  return function()
    if fadeout == nil then
      fadeout = 3000;
    end
    play_music(nil, nil, fadeout, fadein);
  end
end

function playonce_(file,loop)
  return function()
    local hw = here();
    if hw["_"..file] == nil then
      play_music(file,loop);
      hw["_"..file] = true;
    end
  end
end

function play_music(file,loop,fadeout,fadein)
  local fl = file;
  local fout,fin = 2000,2000;
  if file ~= nil and file ~= "" then
    fl = "mus/"..file..".ogg";
  end
  if fadeout ~= nil then    
    fout = fadeout;
  end
  if fadein ~= nil then
    fin = fadein;
  end
  set_music_fading(fadeout, fadein);
  if loop == nil then
    loop = 1;
  end
  if fl ~= nil then
    set_music(fl, loop);
  else
    stop_music();
    mute_sound();
    _lastsound = nil;
  end
end

function play_sound(file,loop,ch)
  local fl = "mus/"..file..".ogg";
  if ch == nil then
    ch = 2;
  end
  set_sound(fl, ch, loop);
  if loop ~= nil then
    _lastsound = {file,loop,ch};
  end
end

function mute_sound()
  stop_sound(2);
  stop_sound(3);
  stop_sound(4);
end