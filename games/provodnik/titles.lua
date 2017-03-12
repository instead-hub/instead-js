require "sprite"
require "theme"
require "timer"
local w, h

local font
local font_height

local text = {
	{ "ПРОВОДНИК", style = 1},
	{ },
	{ "Сюжет и код игры:", style = 2},
	{ "Петр Косых" },
	{ },
	{ "Иллюстрации:", style = 2 },
	{ "Петр Косых" },
	{ },
	{ "Музыка:", style = 2 },
	{ "http://bensound.com" },
	{ },
	{ "Тестирование:", style = 2 },
	{ "kerber" },
	{ "Петр Советов" },
	{ },
	{ "Игра написана в ферале 2017" },
	{ "Для тестирования движка STEAD3"},
	{ },
	{ "Спасибо Вам за прохождение!" },
	{ },
	{ "Благодарности:", style = 2 },
	{ },
	{ "Жене", },
	{ "Работодателю" },
	{ "Всем тем, кто не мешал..."},
	{ },
	{ "Если вам понравилась эта игра"},
	{ "Ищите другие хороше игры на: "},
	{ },
	{ "http://instead.syscall.ru"},
	{ "http://instead-games.ru"},
	{ },
	{ "Или ..."},
	{ "... напишите свою историю"},
	{ "с помощью движка"},
	{ "INSTEAD", style = 1 },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ "КОНЕЦ", style = 1 },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ },
	{ '26 февраля 2017', style = 2},

}

local offset = 0
local pos = 1
local line
local ww, hh

function game:timer()
	local scr = sprite.scr()
	if line == false then
		return
	end
	-- scroll
	scr:copy(0, 1, w, h - 1, scr, 0, 0)

	if offset >= font_height then
		pos = pos + 1
		offset = 0
	end

	if offset == 0 then
		if pos <= #text then
			line = text[pos]
			line = font:text(line[1] or ' ', line.color or 'white', line.style or 0)
			ww, hh = line:size()
		else
			line = false
		end
	end
	if line then
		offset = offset + 1
		scr:fill(0, h - offset, w, offset, 'black')
		line:draw(scr, math.floor((w - ww) / 2), h - offset)
	end
end
room {
	nam = 'legacy_titles',
	title = false,
	decor = function(s)
		for k, v in ipairs(text) do
			if v.style == 1 then
				pn(fmt.c(fmt.b(v[1] or '')))
			elseif v.style == 2 then
				pn(fmt.c(fmt.em(v[1] or '')))
			else
				pn(fmt.c(v[1] or ''))
			end
		end
	end;
}

global 'ontitles' (false)
local activated
room {
	title = false;
	nam = 'black';
	onenter = function()
		theme.set('scr.gfx.bg', '')
		theme.set('scr.col.bg', 'black')
		theme.set('menu.button.x', w)
		theme.set('win.down.x', w)
		theme.set('win.up.x', w)
		theme.set('inv.down.x', w)
		theme.set('inv.up.x', w)
		timer:set(1000)
	end;
	timer = function(s)
		if activated then
			return false
		end
		activated = true
		timer:set(30)
		sprite.direct(true)
		sprite.scr():fill 'black'
		return false
	end;
}

function end_titles()
	offset = 0
	ontitles = true
	if not sprite.direct(true) then
		timer:stop()
		instead.fading_value = 32
		walk ('legacy_titles', false)
		return
	end
	sprite.direct(false)
	instead.fading_value = 32
	w, h = std.tonum(theme.get 'scr.w'), std.tonum(theme.get 'scr.h')
	local fn = theme.get('win.fnt.name')
	font = sprite.fnt(fn, 16)
	font_height = font:height()
	walk ('black', false)
end
