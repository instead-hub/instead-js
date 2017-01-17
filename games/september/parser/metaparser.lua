-- require "para"
require "click"
require "theme"
require "timer"
require "quotes"
require "dash"


stead.mouse_filter(0)
kbden = {
	shifted = {
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = "$",
	["5"] = "%",
	["6"] = "^",
	["7"] = "&",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
	["-"] = "_",
	["="] = "+",
	["["] = "{",
	["]"] = "}",
	["\\"] = "|",
	[";"] = ":",
	["'"] = "\"",
	[","] = "<",
	["."] = ">",
	["/"] = "?",
	}
}

kbdru = {
	["q"] = "й",
	["w"] = "ц",
	["e"] = "у",
	["r"] = "к",
	["t"] = "е",
	["y"] = "н",
	["u"] = "г",
	["i"] = "ш",
	["o"] = "щ",
	["p"] = "з",
	["{"] = "х",
	["}"] = "ъ",	
	["["] = "х",
	["]"] = "ъ",
	["a"] = "ф",
	["s"] = "ы",
	["d"] = "в",
	["f"] = "а",
	["g"] = "п",
	["h"] = "р",
	["j"] = "о",
	["k"] = "л",
	["l"] = "д",
	[";"] = "ж",
	["'"] = "э",
	["z"] = "я",
	["x"] = "ч",
	["c"] = "с",
	["v"] = "м",
	["b"] = "и",
	["n"] = "т",
	["m"] = "ь",
	[","] = "б",
	["."] = "ю",
	["`"] = "ё",
	
	shifted = {
	["q"] = "Й",
	["w"] = "Ц",
	["e"] = "У",
	["r"] = "К",
	["t"] = "Е",
	["y"] = "Н",
	["u"] = "Г",
	["i"] = "Ш",
	["o"] = "Щ",
	["p"] = "З",
	["["] = "Х",
	["]"] = "Ъ",
	["a"] = "Ф",
	["s"] = "Ы",
	["d"] = "В",
	["f"] = "А",
	["g"] = "П",
	["h"] = "Р",
	["j"] = "О",
	["k"] = "Л",
	["l"] = "Д",
	[";"] = "Ж",
	["'"] = "Э",
	["z"] = "Я",
	["x"] = "Ч",
	["c"] = "С",
	["v"] = "М",
	["b"] = "И",
	["n"] = "Т",
	["m"] = "Ь",
	[","] = "Б",
	["."] = "Ю",
	["`"] = "Ё",
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = ";",
	["5"] = "%",
	["6"] = ":",
	["7"] = "?",
	["8"] = "*",
	["9"] = "(",
	["0"] = ")",
	["-"] = "_",
	["="] = "+",
	}
}

kbdlower = {
	['А'] = 'а',
	['Б'] = 'б',
	['В'] = 'в',
	['Г'] = 'г',
	['Д'] = 'д',
	['Е'] = 'е',
	['Ё'] = 'ё',
	['Ж'] = 'ж',
	['З'] = 'з',
	['И'] = 'и',
	['Й'] = 'й',
	['К'] = 'к',
	['Л'] = 'л',
	['М'] = 'м',
	['Н'] = 'н',
	['О'] = 'о',
	['П'] = 'п',
	['Р'] = 'р',
	['С'] = 'с',
	['Т'] = 'т',
	['У'] = 'у',
	['Ф'] = 'ф',
	['Х'] = 'х',
	['Ц'] = 'ц',
	['Ч'] = 'ч',
	['Ш'] = 'ш',
	['Щ'] = 'щ',
	['Ъ'] = 'ъ',
	['Э'] = 'э',
	['Ь'] = 'ь',
	['Ю'] = 'ю',
	['Ы'] = 'ы',
	['Я'] = 'я',
--	['ё'] = 'е';
--	['Ё'] = 'Е';
}

kbdupper = {
	['а'] = 'А',
	['б'] = 'Б',
	['в'] = 'В',
	['г'] = 'Г',
	['д'] = 'Д',
	['е'] = 'Е',
	['ё'] = 'Ё',
	['ж'] = 'Ж',
	['з'] = 'З',
	['и'] = 'И',
	['й'] = 'Й',
	['к'] = 'К',
	['л'] = 'Л',
	['м'] = 'М',
	['н'] = 'Н',
	['о'] = 'О',
	['п'] = 'П',
	['р'] = 'Р',
	['с'] = 'С',
	['т'] = 'Т',
	['у'] = 'У',
	['ф'] = 'Ф',
	['х'] = 'Х',
	['ц'] = 'Ц',
	['ч'] = 'Ч',
	['ш'] = 'Ш',
	['щ'] = 'Щ',
	['ъ'] = 'Ъ',
	['э'] = 'Э',
	['ь'] = 'Ь',
	['ю'] = 'Ю',
	['ы'] = 'Ы',
	['я'] = 'Я',
--	['ё'] = 'Е';
--	['Ё'] = 'Е';
}

function tolow(s)
	if not s then
		return
	end
	s = s:lower();
	s = s:gsub("[^a-zA-Z0-9.%-%%%#%* ][^a-zA-Z0-9.%-%%%#%* ]", kbdlower)
	if not morph.yo then
		s = s:gsub("ё", "е");
	end
--	local xlat = kbdlower
--	if xlat then
--		local k,v
--		for k,v in pairs(xlat) do
--			s = s:gsub(k,v);
--		end
--	end
	return s;
end


function kbdxlat(s)
	local kbd
	if s == 'space' then
		return ' '
	end
	if s == 'return' then
		return '\n'
	end

	if s:len() > 1 then
		return
	end

	if true or input.kbd_alt and 
		(game.codepage == 'UTF-8' or game.codepage == 'utf-8') then
		kbd = kbdru;
	else
		kbd = kbden
	end

	if kbd and input.kbd_shift then
		kbd = kbd.shifted;
	end

	if not kbd[s] then
		if input.kbd_shift then
			return s:upper();
		end
		return s;
	end
	return kbd[s]
end
local function reset_state()
	parser.cur = ''
	parser.state = 0
	input._txt = ''
	parser_menu_items.filled = false
end

game.action = stead.hook(game.action, function (f, s, cmd, ...)
	if cmd == 'parser_edit' then
		return nil, true
	elseif cmd == 'parser_enter' then
		local t = input._txt;
		return parser:enter(t);
	elseif cmd == 'parser_error' then
		local t = input._txt;
		return parser:error(t);
	end
	return f(s, cmd, ...)
end)

local function append_cmd_history(s, str)
	parser.logit("> ", str)
	s.history_pos = nil
	if s.history_db[1] == str then
		return
	end
	stead.table.insert(s.history_db, 1, str);
	if #s.history_db > s.history_len then
		stead.table.remove(s.history_db, #s.history_db)
	end
end

input_kbd = function(s, down, key)
	if here().noparser then
		return
	end
	if not me().parser then
		return
	end
	if key:find("shift") then
		input.kbd_shift = down
	elseif key:find("alt") then
		if down then
--			input.kbd_alt = not input.kbd_alt;
			input.alt = true
		else
			input.alt = false
		end
	elseif down then
		if key == 'f11' and morph.debug then
			morph:recompile()
			return
		end
		if parser.nokbd then
			return
		end
		if parser.cmd_history and not input.kbd_shift and ( key == 'up' or key == 'down' ) then
			if not parser.history_pos then
				if key == 'up' then
					parser.history_pos = 1
				else
					parser.history_pos = #parser.history_db
				end
			else
				if key == 'up' then
					parser.history_pos = parser.history_pos + 1
				else
					parser.history_pos = parser.history_pos - 1
				end
				if parser.history_pos <= 0 then
					parser.history_pos = 1
				elseif parser.history_pos > #parser.history_db then
					parser.history_pos = #parser.history_db
				end
			end
			local t = parser.history_db[parser.history_pos]
			local s
			if not t then
				return "parser_edit"
			end
			parser:reset()
			for s in t:gmatch("[^ ]+") do
				input._txt = input._txt..s
				parser_menu_items:fill()
				if parser_menu_items:filter(input._txt..' ') then
					input._txt = input._txt..' '
				elseif not parser_menu_items:completion() then
					input._txt = input._txt..' '
					input._txt = input._txt:gsub("[ ]+$", " ");
				end
			end
			return "parser_edit"
		end
		if key == 'space' or key == 'tab' then
			if key == 'tab' and input._txt == '' then
				return
			end
			if key ~= 'space' or not parser_menu_items:filter(input._txt..' ') then
				if not parser_menu_items:completion() and key == 'space' and not parser.err_filter then
					input._txt = input._txt .. ' '
					input._txt = input._txt:gsub("[ ]+$", " ");
				end
				return "parser_edit"
			end
		end
		if key == "return" then
			if input.alt then
				return
			end
			if input._txt == '' then
				parser._lastcmd = ''
				return "look"
			end
			local t = input._txt
			parser_menu_items:completion()
			parser_menu_items:fill()
			if t ~= input._txt then
				parser_menu_items:completion()
				parser_menu_items:fill()
			end
			if parser:eol() then
				return "parser_enter"
			end
			if not parser.err_filter then --and #parser_menu_items.obj == 0 or exist('{}', parser_menu_items) then
				append_cmd_history(parser, input._txt);
				return "parser_error"
			end
			return "parser_edit"
		end
		if key == "backspace" then
			if input._txt == '' then
				return "parser_edit"
			end
			if input._txt:byte(input._txt:len()) >= 128 then
				input._txt = input._txt:sub(1, input._txt:len() - 2);
			else
				input._txt = input._txt:sub(1, input._txt:len() - 1);
			end
			parser_menu_items:filter(input._txt, true)
			parser_menu_items.filled = false
			return "parser_edit"
		end
		if key and input.alt then
			return
		end
		local c = kbdxlat(key);
		if not c then return end
		if not parser.filter or parser_menu_items:filter(input._txt..c) then
			input._txt = input._txt..c;
		end
		parser_menu_items.filled = false
		return "parser_edit"
	end
end

local with_system_verbs = function(w, ww)
	local k,v
	if ww.with_system_verbs_toggle then
		return w
	end
	if not parser.verbs then
		return w
	end
	for k,v in ipairs(parser.verbs) do
		stead.table.insert(w, v)
	end
	ww.with_system_verbs_toggle = true
	return w
end

function verbs()
	if not here().verbs then
		if not game.verbs then
			return with_system_verbs(me().verbs, me())
		end
		return game.verbs
	else
		return with_system_verbs(here().verbs, here())
	end
end
local function getcur()
	local k
	parser.cur = ''
	for k=1, parser.state do
		if parser.words[k].txt then
			parser.cur = parser.cur..parser.words[k].txt..' '
		end
	end
end

local function skip_state()
	parser.state = parser.state + 1
	parser.words[parser.state] = { txt = false, obj = false };
end

local function inc_state(s)
	local k
	parser_menu_items.filled = false
	parser.state = s.state + 1
	parser.words[parser.state] = { txt = s.word, obj = s.ob };
	if parser.state == 1 then
		parser.verbnr = s.num
	end
	input._txt = input._txt..s.word..' ';
	getcur()
end
local function noverbs()
	if type(here().hideverbs) == 'boolean' then
		return here().hideverbs
	end
	return parser.hideverbs
end

local function nohints()
	if type(here().nohints) == 'boolean' then
		return here().nohints
	end
	return parser.nohints
end

function menu_word(num, nam, word, ob, verb)
	local v = { nam = nam }
	v.num = num
	v.state = parser.state
	if word:find("^~") then
		word = word:gsub("^~", "")
		v.hidden = true
	end
	v.word = word
	v.disp = function(s)
		if nohints() then
			return false
		end
		local k, cur, beg, p
		beg = input._txt
		if s.hidden or (verb and noverbs()) then
			local s, e
			s, e = parser.cur:find(beg, 1, true)
			if s then
				p = parser.cur:sub(e):gsub("[ \t]*", "")
			end
			if s and p == "" then
				return false
			end
		end
		local rt = s.word
		if parser.hintobj and s.ob then
			local i
			for i=1,parser.state do
				if parser:object(i) == s.ob then
					rt = iface:under(iface:nb(rt))
					break
				end
			end
		end
		if parser.hintinv and s.ob and seen(s.ob, me()) then
			rt = iface:em(rt)
		end
		return rt
	end
	v.num = num
	v.ob = ob
	v.save = function() end
	v.menu = function(s)
		parser_menu_items:filter(input._txt, true, true)
		inc_state(s)
		return parser_menu_items:fill(true)
	end
	return menu(v);
end

click.bg = true
click.button = true
game.click = function(s, m, x, y, px, py)
	if m == 1 and not px then
		return
	end
	parser:reset()
--	parser_menu_items:fill()
	return nil, true
end

function menu_eol(name)
	local v = { nam = '{}'; disp = name; }
	v.save = function() end
	v.word = ''
	v.menu = function(s)
		local r,v = parser:doit()
		reset_state()
--		parser_menu_items:fill()
		return r,v
	end
	return menu(v);
end

function menu_eow(name)
	local v = { nam = '{}'; disp = name; }
	v.eow_type = true
	v.save = function() end
	v.word = ''
	v.menu = function(s, noact)
		local r,v
		r,v = input._txt:find(parser.cur, 1, true)
		s.word = input._txt:sub(v + 1)
		input._txt = parser.cur
		inc_state(s)
		if not noact then
			r,v = parser:doit()
			reset_state()
--			parser_menu_items:fill()
			return r,v
		end
	end
	return menu(v);
end

local function dump_obj(ob, m, beg, cur, recur)
	local k, o
	for k,o in ipairs(ob) do
		if o ~= parser_menu_items  and not isDisabled(o) then
			local p
			if m then
				p = parser:morph(o, m)
			else
				p = stead.dispof(o)
				p = tolow(p)
			end

			if type(p) ~= 'string' then
				return
			end
			p:gsub("[^|]+", function(s) 
				local os = s:gsub("^[ \t]+","")
				if os:find("^~") then
					s = os:gsub("^~", "")
				end
				st = (cur..tolow(s)):find(beg, 1, true)
--					print(cur..tolow(s), beg)
				if st == 1 then
					put(menu_word(parser.verbnr, nameof(o), os, o, false), parser_menu_items)
				end
			end)
			if recur then
				dump_obj(o.obj, m, beg, cur, recur)
			end
		end
	end
end
local function dump_text()
	local keys = { 'пробел', 'удалить', 'А','Б','В','Г','Д','Е','Ё','Ж','З','И','Й',
			'К','Л','М','Н','О','П','Р','О','С','Т','У','Ф',
			'Х','Ц','Ч','Ш','Щ','Ь','Ы','Ъ','Э','Ю','Я'};
--			'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
--			'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
--			'U', 'V', 'W', 'X', 'Y', 'Z' };
	local k, v
	for k, v in ipairs(keys) do
		local o = menu {
			nam = v;
			disp = v;
			sort = k;
			save = function() end;
			menu = function(s)
				if s.disp == 'пробел' then
					input_kbd(input, true, 'space')
				elseif s.disp == 'удалить' then
					input_kbd(input, true, 'backspace')
				else
					input._txt = input._txt .. tolow(s.disp)
				end
			end
		}
		put(o, parser_menu_items);
	end
	put(menu_eow('<ввод>'), parser_menu_items);
end
local function parse_pattern(pattern)
	local beg = tolow(input._txt)
	local cur = parser.cur;
	local k, v
--	print(pattern)

	cur = tolow(cur) --:gsub("^[ \t]+", ""):gsub("[ \t]+$", ""));

	if pattern:find("^{[^}]*}") then
		local a = pattern:gsub("^{([^}]*)}.*$", "%1")
		local m = pattern:gsub("[^}]+}[ \t]*([^ \t]*)$", "%1")
		if m == '' then m = nil end
		local k, o
		local ob
		local recur = true
		if a == 'obj'then
			ob = objs()
		elseif a == 'inv' then
			ob = inv()
		elseif a == 'way' then
			ob = ways()
			recur = false
		elseif a == 'text' then
			dump_text();
			return
		elseif a:find('^code') then
			a = a:gsub("^code ", "")
			pattern = stead.eval('return '..a);
			if pattern then
				return parse_patterns(pattern());
			end
			error ("Bad code: "..a, 2);
		elseif a == '' then
			local st = (cur..a):find(beg, 1, true)
			if st == 1 then
				put(menu_eol('<ввод>'), parser_menu_items)
			end
			return
		else -- some object
			local new = stead.ref(a)
			ob = { new }
		end
		dump_obj(ob, m, beg, cur, recur);
	else
		local st = (cur..tolow(pattern:gsub("^~", ""))):find(beg, 1, true)
		if st == 1 then
			put(menu_word(parser.verbnr, pattern, pattern, nil, false), parser_menu_items)
		end
	end
end

function parse_patterns(pattern)
	while type(pattern) == 'function' do
		pattern = pattern(parser)
	end

	if not pattern then
		return
	end

	pattern:gsub("[^|]+", function(s)
		parse_pattern(s)
	end)
end

parser_menu_items = obj {
	system_type = true;
	nam = 'parser_items';
	disp = false;
	completion = function(s)
		local cur = parser.cur
		local k, v
		local new_state = 0
		beg = tolow(beg)
		if exist('{}', s.obj) then
			return
		end

		if #s.obj == 1 then
			cur = cur..s.obj[1].word
			inc_state(s.obj[1])
			input._txt = cur..' '
--			s:fill()
		elseif #s.obj == 0 then
			return
		else
			local ww = {}
			for k,v in ipairs(s.obj) do
				v.len = v.word:len()
				stead.table.insert(ww, v)
			end
			stead.table.sort(ww, function(a, b)
				return a.len < b.len
			end)
			local len = 1
			local pass = 0
			if ww[1].word:byte(len) >= 128 then
				len = len + 1
			end
			while len <= ww[1].len do
				local p = tolow(ww[1].word:sub(1, len))
				for k,v in ipairs(ww) do
					local st = tolow(v.word):find(p, 1, true)
					if st ~= 1 then
						len = 0
						break
					end
				end
				if len == 0 then
					break
				end
				pass = len
				if len < ww[1].len and ww[1].word:byte(len + 1) >= 128 then
					len = len + 2
				else
					len = len + 1
				end
			end
			if cur..ww[1].word == input._txt then
				inc_state(ww[1])
				input._txt = cur..ww[1].word..' '
			else
				input._txt = cur..ww[1].word:sub(1, pass)
			end
			return true
--			s:fill()
		end
	end;
	filter = function(s, beg, back, mouse)
		local cur = ''
		local k, v
		local new_state = 0
		local prev = ''
		beg = tolow(beg)
		for k=1, parser.state do
			prev = cur
			if parser.words[k].txt then
				cur = cur..parser.words[k].txt..' '
				if beg:find(tolow(cur), 1, true) then
					new_state = k
				end
			else
				new_state = k
			end
		end
		if back then -- downshift
			if new_state < parser.state then
				input._txt = prev
				parser.state = parser.state - 1
				if parser.state < 0 then
					parser.state = 0
				end
				if parser.filter then
					s:fill(true)
				end
			else
				if parser.filter or mouse then
					input._txt = cur
				end
			end
			if parser.filter or mouse then
				s:fill(true)
			end
			return true
		end
		local eo = exist('{}', parser_menu_items)

		if eo and eo.eow_type then
			if input._txt:find("[ \t]+$") then
				return false
			end
			return true
		end

		cur = tolow(cur)
		for k,v in ipairs(parser_menu_items.obj) do
			local f = (cur..tolow(v.word))
			local st, ed = f:find(beg, 1, true)
			if st == 1 then
				return true
			end
		end
	end;
	fill = function(s, click, nozap)
		local optional = false
		local beg = input._txt
		local k, v 
		local pattern
		if not nozap then
			s.obj:zap();
		end
		getcur();
		local cur = parser.cur

		cur = tolow(cur) --:gsub("^[ \t]+", ""):gsub("[ \t]+$", ""));
		beg = tolow(beg) --:gsub("^[ \t]+", ""):gsub("[ \t]+$", ""));
--		print("filter:'"..beg.."' verb:'"..parser.verb.."'")
		local le = nil
		if parser.state == 0 then
			for k, v in ipairs(verbs()) do
				local pat
				if type(v.argv) == 'function'  then
					pat = v:argv(1)
				else
					pat = v[2]
				end
				while type(pat) == 'function' do
					pat = pat(parser)
				end
				if type(pat) == 'string' then
					pat:gsub("[^|]+", function(pat)
						local opat = pat
						pat = pat:gsub('^~','')
						local st = (cur..tolow(pat)):find(beg, 1, true) 
						if st == 1 then
							put(menu_word(k, opat, opat, nil, true), parser_menu_items)
						end
					end)
				end
			end
		else
			v = verbs()[parser.verbnr]
			if type(v.argv) == 'function'  then
				pattern = v:argv(parser.state + 1)
				le = not pattern
			else
				pattern = v[parser.state + 2]
			end
			if pattern then
				while type(pattern) == 'function' do
					pattern = pattern(parser)
				end
				if pattern and pattern:find("^?") then
					optional = true
					pattern = pattern:gsub("^?", "")
				end
			end
		end
		if pattern then
			parse_patterns(pattern)
		end
		if le == nil then le = (parser.state > 0 and (parser.state == #verbs()[parser.verbnr] - 1)) end
		if le and not exist ('{}',parser_menu_items) then
			if parser:eol() then
				put(menu_eol('<ввод>'), parser_menu_items)
			end
		end

		if click and (#s.obj == 0 or (#s.obj == 1 and stead.nameof(s.obj[1]) == '{}')) then
			local r
			if parser:eol() then
				r = parser:doit()
			end
			reset_state()
--			s:fill()
			return r
		end
		if not parser.nosort then
		stead.table.sort(s.obj, function(a, b)
			if a.sort and b.sort then
				return a.sort < b.sort
			end
			if stead.nameof(a) == '{}' and stead.nameof(b) ~= '{}' then
				return true
			end
			if stead.nameof(b) == '{}' and stead.nameof(a) ~= '{}' then
				return false
			end
			a = a.word; -- stead.dispof(a)
			b = b.word; -- stead.dispof(b)

			if a == true then a = '1' elseif a == false or a == nil then a = '0' end
			if b == true then b = '1' elseif b == false or b == nil then b = '0' end
			return a < b
		end)
		end
		s.filled = true
		if optional then
			local st = parser.state
			skip_state()
			s:fill(false, true);
			parser.state = st
		end
	end;
	obj = { };
}

local function fill_aliases(b, s)
	local k,v
	local base, before_base, after_base
	for k,v in ipairs(b) do
		if not base then
			base = s[v]
			before_base = s['before_'..v]
			after_base = s['after_'..v]
		else
			s[v] = base
			s['before_'..v] = before_base
			s['after_'..v] = after_base
		end
	end
end


function alias(t)
	local v = { }
	v.construct_type = true
	if type(t) ~= 'string' then
		error("Wrong aliase.", 2)
	end
	t:gsub("[^:, \t]+", function(s)
		local a = s
		stead.table.insert(v, a)
	end)
	v.constructor = fill_aliases;
	return v
end

function attr(t)
	local v = { }
	if type(t) ~= 'string' then
		error("Wrong attr.", 2)
	end
	t:gsub("[^, \t]+", function(s)
		local a = s:gsub("^~", "")
		if s:find("^~") then
			v[a] = false
		else
			v[a] = true
		end
	end)
	return var(v)
end


function Attribute(t)
	if type(t) ~= 'string' then
		error("Wrong attr.", 2)
	end
	t:gsub("[^, \t]+", function(s)
		local a = s:gsub("^~", "")
		if s:find("^~") then
			parser.attrs[a] = false
		else
			parser.attrs[b] = true
		end
	end)
end

local function parse_header(s)
	local l,r, exp
	local v = {}
	if not s:find(":", 1, true) then
		l = s
	else
		l = s:gsub("^([^:]+):.*$", "%1")
		r = s:gsub("^[^:]+:(.*)$", "%1")
	end
	l:gsub("[^ ,]+", function(s)
		stead.table.insert(v, s)
	end)
	v.expr = r
	return v
end
-- trigger [[tafter_adds():
-- after [[action,asdfs():
function trigger(t)
	local v = { }
	if type(t) ~= 'string' then
		error("Wrong trigger.", 2)
	end
	t:gsub("[^:, \t]+", function(s)
	end)
	return var(v)
end

local function musthave_checker(v)
	return function(s, ...)
		if not have(s) then
			if s.no_have_msg then
				p(s.no_have_msg)
			else
				p ([[Сначала нужно взять ]]..s:M 'вн'..'.')
			end
		end
	end
end

function musthave(t)
	if type(t) ~= 'string' then
		error("Wrong musthave argument.", 2)
	end
	local v = parse_header(t)
	v.construct_type = true
	v.constructor = function(o, s)
		local k, v
		for k,v in ipairs(o) do
			s[v] = musthave_checker(v)
		end
		s.no_have_msg = o.expr
	end
	return v
end

function Verb(s, w)
	if type(s) ~= 'table' then
		error ("Wrong Verb.", 2)
	end
	if not w then
		w = game
	end
	if not w.verbs then
		w.verbs = {}
	end
	stead.table.insert(w.verbs, s)
	return s;
end

function _Verb(s, w)
	Verb(s, parser)
	return Verb(s, w)
end

stead.module_init(function()
	input.cursor = '_'
	input._txt = ''
	input._history = {};
	input.histpos = 0;
	input.kbd_alt = true
	input.key = stead.hook(input.key,
	function(f, ...)
		local r = input_kbd(...)
		if r then return r end
		return f(...)
	end)
end)

function input_esc(s)
	local rep = function(s)
		return txtnb(s)
	end
	if not s then return end
	return s:gsub("[^ ]+", rep):gsub("[ \t]", rep);
end
--txtem = function(s)
--	return s
--end
local trim = function(s, n)
	local v = {}
	s:gsub("[^%^]*^", function(s)
		stead.table.insert(v, s)
		if #v > n then
			stead.table.remove(v, 1)
		end
	end)
	local a,b,rc
	rc = ''
	for a,b in ipairs(v) do
		rc = rc..b;
	end
	return rc
end

iface.fmt = function(self, cmd, st, moved, r, av, objs, pv) -- st -- changed state (main win), move -- loc changed
	if not parser._lastdisp then
		parser._lastdisp = ''
	end
	local l, vv, lastest, footer
	if not stead.state or not parser.scroll then
		lastest = ''
	else
		if parser.scroll then
			parser._lastdisp = trim(parser._lastdisp, parser.scroll_history)
		end
		lastest = parser._lastdisp
		if parser._lastcmd then
			lastest = lastest..iface:bold(stead.par('', '> ',parser._lastcmd))..'^'
		else
			lastest = lastest:gsub("[% ]+$", "")
		end
	end
	if st then
--		footer = stead.call(here(), 'footer')
		av = txtem(av);
		pv = txtem(pv);
--		if not PLAYER_MOVED then
			r = r -- txtem(r)
--		end
		if isForcedsc(stead.here()) or NEED_SCENE then
			local pic = stead.call(stead.here(), 'gfx')
			l = stead.here():scene();
			if pic then
				l = stead.par(stead.scene_delim, txtc(img(pic)), l)
				if format and format.para then
					l = '_'..l
				end
			end
			l = stead.par('^^', txtb(stead.dispof(here())), l)
			footer = stead.call(here(), 'footer')
			if not footer then
				footer = stead.call(parser, 'footer')
			end
--			lastest = ''
		elseif parser.scroll then
			if not isDialog(here()) then
				objs = nil
			end
			footer = nil
		end
		if stead.version >= "1.8.1" then
			if type(l) == 'string' then
				l = iface.anchor()..l
			elseif type(r) == 'string' then
				r = iface.anchor()..r
			elseif type(objs) == 'string' then
				objs = iface.anchor()..objs
			elseif type(av) == 'string' then
				av = iface.anchor()..av
			elseif type(pv) == 'string' then
				pv = iface.anchor()..pv
			end
		end

	end
	if moved then
		vv = stead.cat(stead.par(stead.scene_delim, r, l, av, objs, footer, pv), '^^');
	else
		vv = stead.cat(stead.par(stead.scene_delim, l, r, av, objs, footer, pv), '^^');
	end
	if stead.state and parser.scroll then
		parser.logit(vv)
		parser._lastdisp = stead.par('', lastest, vv)
		vv = parser._lastdisp
	end
	vv = stead.fmt(vv)
	return vv
end

local openlog = function()
	local r,v
	local nr = -1
	for v in stead.readdir(instead_savepath()) do
		if v:find("^log[0-9]+[.]txt$") then
			local n = v:gsub("^log([0-9]+)[.]txt$", "%1")
			if n then n = n:gsub("^0*", ""); end
			if not n or n == '' then n = 0 end
			if tonumber(n) and tonumber(n) > tonumber(nr) then
				nr = tonumber(n)
			end
		end
	end
	parser.logname = string.format(instead_savepath().."/log%04d.txt", nr + 1)
	print("Opening log: "..parser.logname);
end

parser = obj {
	nam = 'parser';
	system_type = true;
	scroll_history = 100;
	scroll = true;
	filter = false;
	err_filter = true;
	inv_delim = '|';
	openlog = openlog;
	var {
		logname = false;
	};
	logit = function(...)
		local k,v
		local rc = ''
		if not parser.logname then
			return
		end
		for k,v in ipairs({...}) do
			rc = stead.par('', rc, v)
		end
		rc = stead.fmt(rc)
		rc = rc:gsub("</?[^>]+>", ""):gsub("^[ \t]+", ""):gsub("[ \t]+$", ""):gsub("[ \t]+", " ");
		local f = io.open(parser.logname, "a+")
		print(rc)
		f:write(rc.."\n")
		f:close()
	end;
	cls = function(s)
		s._lastdisp = ''
		s._lastcmd = false
	end;
	reset = function(s)
		s._lastcmd = false
--		s.verb = 0
		reset_state()
	end;

	unknown_verb = function(s, a, v)
		p ("Я не понимаю, что значит "..v..".");
		return
	end;
	unknown_obj = function(s, a, v)
		if v == "" then
			p ("Предложение не окончено.")
			return
		end
		p ("Невозможно "..a..".")
		return
	end;
	timer = function(s)
		timer:set(s._timer)
		here().timer = s.timer_fn
		p ' '
	end;
	ini = function(s, load)
		if not load and parser.log then
			openlog()
		elseif load and parser.logname then
			openlog()
		end
		input._txt = ''
		s.state = 0
		if load and s.scroll and not here().noparser then
			if stead.version < "1.8.1" then
				game._lastdisp = game._lastdisp:gsub("[%^ \n]+$", "\n")
				s._lastdisp = s._lastdisp:gsub("[%^ \n]+$", "")
				s._lastcmd = false
				s.timer_fn = here().timer
				here().timer = s.timer
				s._timer = timer:set(1)
--			else
--				instead_theme_var("win.scroll.mode", 3);
			end
		end
	end;
	state = 0;
	words = {}, 
	verb = 0; 

	word = function(s, n)
		if not n then
			n = s.state
		end
		if n > s.state then
			return
		end
		return tolow(s.words[n].txt)
	end;

	object = function(s, n)
		if not s.state then
			return
		end
		if not n then
			n = s.state
		end
		if n > s.state then
			return
		end
		return s.words[n].obj
	end;

	disp = function(s)
		return par('', '>', input._txt, input.cursor);
	end;
	events = {};
	eol = function(s)
		local eo = exist('{}', parser_menu_items)
		local st = parser.cur:find(input._txt, 1, true)
--		print(parser.cur, input._txt)
		if eo and eo.eow_type then
			eo:menu(true)
			return true
		end

		local le = nil

		if parser.state > 0 and type(verbs()[parser.verbnr].argv) == 'function' then
			le = not verbs()[parser.verbnr]:argv(parser.state + 1)
		end

		if le == nil then le = (parser.state > 0 and parser.state == #verbs()[parser.verbnr] - 1) end

		if st == 1 and (le or eo) then
			return true
		end
	end;
	history_db = {};
	history_len = 100;
	curverb = function(s)
		return verbs()[s.verbnr];
	end;
	curevent = function(s)
		return s.curevname
	end;
	doit = function(s)
--		if stead.version >= "1.8.1" then
--			instead_theme_var("win.scroll.mode", 1);
--		end
		local ev, r, v
		if s.state == 0 then
			return
		end
		local exp = verbs()[s.verbnr][1]
		local a = {}
		s._lastcmd = input._txt
		while type(exp) == 'function' do
			exp = exp(parser)
		end
		if type(exp) ~= 'string' then
			return
		end
		append_cmd_history(s, s._lastcmd);
		exp:gsub("[^|]+", function(exp)
			stead.table.insert(a, {})
			local na = #a
			exp:gsub("[^ \t]+", function(str)
				if str:find("^%%[0-9]+$") then
					local n = tonumber(str:sub(2))
					local ss
--				print(n, str)
					if n > s.state then
						ss = false
					else
						ss = s.words[n].obj
						if not ss then
							ss = tolow(s.words[n].txt)
						end
					end
					str = ss
				end
				stead.table.insert(a[na], str)
			end)
		end)
		for r = 1,#a do
			if type(a[r][1]) ~= 'string' then
				error ("Wrong event: "..tostring(exp), 2)
			end
		end
		r,v = parser.event(parser, a)
		if r == nil then
			return nil, true
		end
		return r
	end;

	generic_event1 = function(s, n, a, o)
		local function get_event(n, ev)
			local event, event_default, event_any
			if n == 1 then
				event = 'before_'..ev
				event_default = 'before_Default'
				event_any = 'before_Any'
			elseif n == 2 then
				event = ev
				event_default = 'Default'
				event_any = 'Any'
			elseif n == 3 then
				event = 'after_'..ev
				event_default = 'after_Default'
				event_any = 'after_Any'
			end
			return event, event_default, event_any
		end
		local function get_args(t)
			local vv = {}
			local k, v
			for k, v in ipairs(t) do
				stead.table.insert(vv, v)
			end
			return vv
		end
		local function call_event(o, ev, event, default_event, as)
			local r, rr, vv
			if not o[event] then
				rr, vv = stead.call(o, default_event, ev, stead.unpack(as))
			else
				rr, vv = stead.call(o, event, stead.unpack(as))
			end
			r = stead.par(' ', r, rr)
			if rr ~= nil or vv ~= nil or s.redirect_ev then
				if (r == nil and rr == true) or s.redirect_ev then r = true end
				return r
			end
		end
		local k, v
		local rr, vv
		local r
		for k,v in ipairs(a) do
			local event, default_event, any_event

			local as = get_args(v)
			local ev = as[1]
			local oo = o
			s.curevname = ev
			stead.table.remove(as, 1)
			event, default_event, any_event = get_event(n, ev)

			if oo == s then
				local pevent, pdefault_event, pany_event 
				pevent, pdefault_event, pany_event = get_event(n, 'Action')
				s[pevent] = s.events[event]
				s[pdefault_event] = s.events[default_event]
				s[pany_event] = s.events[any_event]
				event, default_event, any_event = pevent, pdefault_event, pany_event
			end

			local ob = as[1]

			if not oo and isObject(ob) then
				oo = ob
				stead.table.remove(as, 1)
			end
			if oo then
				if n == 3 then
					r = call_event(oo, ev, event, default_event, as);
--					if r then return r end
				end
				rr, vv = stead.call(oo, any_event, ev, stead.unpack(as))
				r = stead.par(' ', r, rr)
				if rr ~= nil or vv ~= nil or s.redirect_ev then
					if (r == nil and rr == true) or s.redirect_ev then r = true end
					return r
				end
				if n == 1 or n == 2 then
					r = call_event(oo, ev, event, default_event, as);
				end
				if r then
					return r
				end
			end
		end
	end;
	generic_event = function(s, a, n)
		local r
		if n == 1 then
			parser.txt = s:generic_event1(n, a, s)
			if parser.txt then return parser.txt end
			parser.txt = s:generic_event1(n, a, here())
			if parser.txt then return parser.txt end
			parser.txt = s:generic_event1(n, a)
			return parser.txt
		elseif n == 2 then
			parser.txt = s:generic_event1(n, a)
			if parser.txt then return parser.txt end
			parser.txt = s:generic_event1(n, a, here())
			if parser.txt then return parser.txt end
			parser.txt = s:generic_event1(n, a, s)
			return parser.txt
		elseif n == 3 then
			local rc
			if parser.txt then rc = true end
			r = s:generic_event1(n, a)
			if r then rc = true end
			parser.txt = stead.par(' ', parser.txt, r) or rc
			r = s:generic_event1(n, a, here())
			if r then rc = true end
			parser.txt = stead.par(' ', parser.txt, r) or rc
			r = s:generic_event1(n, a, s)
			if r then rc = true end
			parser.txt = stead.par(' ', parser.txt, r) or rc
			return parser.txt or rc
		end
	end;
	redirect = function(s, ...)
		local a = { ... }
		s.redirect_ev = a;
	end;
	react = function(s, txt)
		local r = s.txt
		if txt then s.txt = txt end
		return r
	end;
	event = function(s, a)
		local r, v
		parser._lastcmd = input._txt
		local k
		parser.txt = false
		while true do
			for k = 1, 3 do
				r, v = s:generic_event(a, k)
				if r and k ~= 2 then
					break
				end
			end
			if not parser.redirect_ev then
				break
			end
			a = parser.redirect_ev 
			parser.redirect_ev = false
		end
		return r
	end;
	morph = function(s, w, p)
		local self = s
		if not p or not isObject(w) then
			return w
		end
		local d = stead.dispof(w)
		local nr = 1

		local function morphit(d, p, w)
			if type(d) ~= 'string' then
				return d
			end
			local cap
			if d:find("^[A-Z]") then
				cap = true
			else
				local a
				d:gsub("^..", function(s) a = s end);
				if kbdlower[a] then
					cap = true
				end
			end
			d = morph:case(tolow(d), p, w)
			if cap then
				return parser:cap(d)
			end
			return d
		end
		if w.morph then
			local n = morph:case2n(p)
			local ww
			if type(d) == 'string' then
				ww = d:gsub("[^~| -]+", function(s)
					if type(w.morph[nr]) == 'table' then
						s = nr
					elseif w.morph[nr] == nil and w.morph[s] == nil then
						return morphit(s, p, w)
					end
					nr = nr + 1
					if w.morph[s] then
						if w.morph[s][n] then
							return w.morph[s][n]
						elseif w.morph[s][1] then
							return w.morph[s][1]
						else
							error ("Wrong morph attribute on obj: "..stead.deref(w), 2)
						end
					else
						if w.morph[n] then
							return w.morph[n]
						elseif w.morph[1] then
							return w.morph[1]
						else
							error ("Wrong morph attribute on obj: "..stead.deref(w), 2)
						end
					end
				end)
			end
			return ww;
		end
		ww = d:gsub("[^~| -]+", function(s)
			return morphit(s, p, w)
		end)
		return ww --morphit(d, p, w)
	end;
	gender = function(s, w)
		local rc = {}
		local rc2
		if w.male then rc.male = true end
		if w.female then rc.female = true end
		if w.plural then rc.plural = true end
		if w.singular then rc.singular = true end
		if w.live ~= nil then rc.live = w.live end
		local g = rc.male or rc.female or rc.neuter
		local n = rc.singualr or rc.plural
		local l = (rc.live ~= nil)
		if g and n then
			return rc
		end
		rc2 = morph:gender(w:M(), w)
		if not g then
			rc.male = rc2.male
			rc.female = rc2.female
			rc.neuter = rc2.neuter
		end
		if not n then
			rc.plural = rc2.plural
			rc.singular = rc2.singular
		end
		if not l then
			rc.live = rc2.live
		end
		if not rc.singular and not rc.plural then
			rc.singular = true
		end
		if not rc.male and not rc.female and not rc.neuter then
			rc.male = true
		end
		return rc
	end;
	error = function(s, w)
		local r,v
		s._lastcmd = input._txt
		if s.state == 0 then
			local w = s._lastcmd:gsub("^[ \t]*([^ ]+).*$", "%1");
			r,v = stead.call(s, 'unknown_verb', s._lastcmd, w);
		else
			local w = input._txt:gsub(parser.cur, "");
			r,v = stead.call(s, 'unknown_obj', s._lastcmd:gsub("[ ]+$", ""), w);
		end
		reset_state()
		if not r and not v then
			return true
		end
		return r,v
	end;
	enter = function(s, w)
		local r,v  = s:doit()
		reset_state()
		return r,v
	end;
	cap = function(s, w)
		if not w then
			return
		end
		w = w:gsub("^..", kbdupper);
		return w
	end;
}
parser.attrs = {}

obj = stead.inherit(obj, function(v)
	local a,b
	local const = {}
	local new_attr = {};

	for a, b in ipairs(v) do
		if type(b) == 'table' then
			if b.construct_type then
				stead.table.insert(const, b)
			end
		end
	end
	for a, b in pairs(parser.attrs) do
		if v[a] == nil then
			new_attr[a] = b
		end
	end
	stead.add_var(v, new_attr)

	for a, b in ipairs(const) do
		b:constructor(v)
	end

	if not v.opened then
		stead.add_var(v, { opened = false; })
	end
	v.It = function(s, w)
		return parser:cap(parser:it(s, w))
	end
	v.it = function(s, w)
		return parser:it(s, w)
	end
	v.G = function(s)
		return parser:gender(s)
	end
	v.CM = function(s, w)
		return parser:cap(s:M(w))
	end;
	v.M = function(s, w)
		if not w then w = 'им' end
		local a = parser:morph(s, w)
		local ww
		if type(a) == 'string' then
			a:gsub("[^~|]+", function(s)
				if not ww then
					ww = s
				end
			end)
		end
		if ww then
			return ww
		end
		return a
	end
	v.menu_type = true
	return v
end)

parser_player = function(v)
	if v.nam == nil then
--		v.nam = 'parser player';
		v.nam = 'я';
		v.morph = {'я', 'меня', 'мне', 'себя', 'мной', 'меня' }; -- осмотреть себя, а не меня
	end
	if v.live == nil then
		v.live = true;
	end
	v.panel = list { 'parser' };
	v.parser = true;
	if not v.male and not v.female and not v.neuter then
		v.male = true;
	end
	if not v.person then
		v.person = 1;
	end
	v.obj = { 'parser_menu_items' };
	v.inv = function(s)
		if here().noparser then
			return
		end
		local a = s.panel:str()
		local b = ''
		if not parser_menu_items.filled then
			parser_menu_items:fill()
		end

		if parser.empty_warning and #parser_menu_items.obj == 0 then
			return a..'^'..parser.empty_warning;
		end

		stead.obj_tag(s, MENU_TAG_ID);
		local k,v
		for k,v in ipairs(parser_menu_items.obj) do
			local d = stead.dispof(v)
			if d then
				b = b..xref(d, v)..parser.inv_delim
			end
		end
		if type(a) == 'string' then a = a .. '^' else a = '' end
		return a..b:gsub(parser.inv_delim..'$', '')
	end
	return player(v)
end

pl = parser_player {
};

dofile "parser/morpher.lua"
dofile "parser/stdparser.lua"

-- change_pl 'parser_player'
game.fading = function(s)
	if parser.scroll and time() ~= 1 then
		return false
	end
	return game.gui.fading
end
game.hinting = false
game.gui.hideways = true
--iface.title = function(s, str)
--	return txtb(str)
--end
instead.get_title = function(s)
	if parser.notitle then
		return
	end
	local scene = stead.dispof(stead.here());
	if type(scene) ~= 'string' then
		scene = ''
	end
	return txtb(txtu(txtnb(scene))..txttab("100%", "right")..txtu(txtnb('Ходы: '..tostring(stead.time()))))
end
-- vim:ts=4

stead.module_init(function()
	pl = parser_player {
	};
end)
