require "sprites"
titles = room {
	nam = '';
	noparser = true;
	hideinv = true, 
	txt = { 
		"КРАСКИ СЕНТЯБРЯ",
		" ",
		" ",
		" ",
		"Программирование и иллюстрации:", 
		"Петр Косых", 
		" ",
		"Тестирование:",
		"Андрей Лобанов",
		"im-kerber",
		" ",
		"Музыка:",
		"Александр Соборов (excelenter)",
		"Numrah (soundcloud.com)",
		"www.jamendo.com",
		" ",
		"Звуки:",
		"http://www.freesound.org",
		" ",
		"Движок INSTEAD:",
		"Петр Косых",
		"http://instead.syscall.ru",
		" ",
		"Благодарности:",
		"Жене и детям",
		"Всем, кто не мешал работать",
		"Тестерам",
		" ",
		"Спасибо вам за то, что прошли эту игру!",
		" ",
		" ",
		"Если вам понравилась игра",
		"Вы можете найти другие INSTEAD игры",
		"на http://instead.syscall.ru",
		"или написать свою...",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		"right",
		"Петр Косых",
		"2015",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		" ",
		"center",
		"КОНЕЦ",
	};
	off = 200;
	w = 0;
	enter = function(s)
		picture = false;
		if theme:name() ~= '.' then
			return walk 'titles2';
		end
	end;
	fading = 16;
	entered = function(s)
		theme.set('scr.gfx.x', 50)
		theme.set('scr.gfx.y', 200)
		theme.set('scr.gfx.w', 500)
		theme.set('scr.gfx.h', 200)
		theme.win.geom((600 - 500) / 2, (600 - 200) / 2, 500, 200);
		theme.set('scr.gfx.bg', '');
		theme.set('scr.col.bg', 'black');
		theme.set('inv.mode', 'disabled');
		s:ini(true, true)
	end;
	timer = function(s)
		sprite.fill(SCR, 'black')
		sprite.draw(TEXT, s.pic, (500 - s.w) / 2, s.off);
		s.off = s.off - 1
		local w,h = sprite.size(TEXT)
		if s.off < -h + 100 - FH/2 then
			timer:stop()
		end
	end;
	ini = function(s, load, force)
		local k, v, h
		local spr = {};
		local w = 0
		local m = 0
		local center = true
		local left = false
		local right = false
		if (not load or not visited(s)) and not force then
			return
		end
		FN = sprite.font('theme/LiberationSerif-Regular.ttf', 16)
		SCR = sprite.load ('box:500x200,black')
		if not FN or not SCR then
			return
		end
		h = sprite.font_height(FN)
		FH = h
		for k,v in ipairs(s.txt) do
			if v == 'left' then
				table.insert(spr, v);
			elseif v == 'center' then
				table.insert(spr, v);
			elseif v == 'right' then
				table.insert(spr, v);
			else
				m = m + 1
				local t = sprite.text(FN, v, 'white');
				table.insert(spr, t);
				local ww, hh = sprite.size(t);
				if ww > w then
					w = ww
				end
			end
		end
		TEXT = sprite.load('box:'..tostring(w)..'x'..tostring(h * m)..',black');
		if not TEXT then
			return
		end
		local x, y
		y = 0
		for k, v in ipairs(spr) do
			if v == 'left' then center, right = false, false
			elseif v == 'center' then center, right = true, false
			elseif v == 'right' then right, center = true, false
			else
				local ww, hh = sprite.size(v);
				if center then
					x = ((w - ww) / 2)
				elseif right then
					x = ((w - ww))
				else
					x = 0;
				end
				sprite.draw(v, TEXT, x, y);
				y = y + sprite.font_height(FN)
			end
		end
		s.w = w
		s.pic = SCR
		timer:set(60)
	end;
}

titles2 = room {
	nam = '...';
	hideinv = true;
	noparser = true;
	forcedsc = true;
	dsc = function(s)
		local k,v
		local center = true
		local left = false
		local right = false
		for k,v in ipairs(titles.txt) do
			if v == 'left' then center, right = false, false
			elseif v == 'center' then center, right = true, false
			elseif v == 'right' then right, center = true, false
			else
				if center then
					pn(txtc(v))
				elseif right then
					pn(txtr(v))
				else
					pn(v)
				end
			end
		end
	end;
}
