-- $Name:Особняк$
-- $Version:1.2.4$

instead_version "1.5.0"

require "sprites"
require "theme"
require "para"
require "quotes"
require "dash"
require "hideinv"
require "snapshots"
require "timer"

if stead.version < "1.5.3" then
	walk = _G["goto"]
	stead.walk = stead["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

dofile "menu.lua"
dofile "game.lua"
-- vim:ts=4
