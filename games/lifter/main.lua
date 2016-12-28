-- $Name: Лифтер$
-- $Version: 0.4$
if stead.version < "1.1.6" then
	error [[Для игры нужен INSTEAD версии не ниже, чем 1.1.6
	http://instead.googlecode.com]]
end

if stead.version < "1.5.3" then
	walk = _G["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

--на случай если версия < 1.1.6
--function p(...)
--	local i
--	for i = 1, stead.table.maxn(arg) do
--		cctx().txt = par('',cctx().txt, arg[i]);
--		end
--end;

game.act = 'Не понимаю, что это.';
game.inv = 'Странный предмет.';
game.use = 'Не получится.';
game.codepage="UTF-8"
dofile("intro.lua");
dofile("d1.lua");
dofile("d2.lua");
