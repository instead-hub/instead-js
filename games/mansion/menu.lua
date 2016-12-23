if not MENU_HOOKS then -- like module
function action(text)
	local v = menu {
		action_type = true;
		system_type = true;
		nam = text;
		disp = function(s)
			if s.state then
				p (txtb(txtu(s.nam)))
			else
				p (txtb(s.nam))
			end
		end;
		var { state = false };
		menu = function(s)
			if s.state then
				return
			end
			s.state = true;
			s:enable_all();
			local k,v
			for k,v in ipairs(objs(me())) do
				if v.action_type and v ~= s then
					v.state = false
					v:disable_all()
				end
			end
			s:ini();
			return
		end;
		ini = function(s)
			if s.state then
				inventory:make_menu((s == mode_take) or (s == mode_exam))
			end
		end
	}
	v:disable_all()
	return v
end

mode_exam = action('ОСМОТРЕТЬ')
mode_take = action('ВЗЯТЬ');
mode_use = action('ДЕЙСТВОВАТЬ');

inventory = obj {
	nam = true;
	system_type = true;
	make_menu = function(s, t)
		local k,v
		for k,v in ipairs(objs(s)) do
			v.menu_type = t
			for r,w in ipairs(objs(v)) do
				w.menu_type = t
			end
		end
	end
}

inv_sep = stat {
	nam = "Инвентарь";
	system_type = true;
	disp = function(s)
		if #inv() ~= 0 then
			return txtem(txtc '^Инвентарь');
		else
			return '';
		end
	end
}


take = stead.hook(take, function(f, v, ...)
	ref(v).menu_type = true
	return f(v, ...)
end)

obj = stead.hook(obj, function(f, v, ...)
	if isRoom(v) or isPlayer(v) then
		return f(v, ...)
	end
	v.orig_act = v.act;
	v.inv = function(s)
		if mode_exam.state then
			return call(s, 'exam');
		elseif mode_take.state then
			return "Я уже это взял."
		elseif mode_use.state then
			return call(s, 'useit');
		end
	end
	v.act = function(s)
		if disabled(mode_exam) then
			return call(v, 'orig_act');
		end
		if mode_exam.state then
			if not s.exam then
				return 'Ничего необычного.'
			end
			return call(s, 'exam');
		elseif mode_take.state then
			if not s.take then
				return 'Это нельзя взять.'
			end
			local r,v = call(s, 'take');
			if v == true then
				take(s)
				s.menu_type = true
			end
			return r,v
		elseif mode_use.state then
			local r,v = call(s, 'useit');
			if not r and not v then
				p [[Гм... Я не знаю как это использовать...]]
				return
			end
			return r,v
		end
	end
	return f(v);
end)

mode_exam.life = function(s)
	s:menu()
end

game_newlife = function(s)
	local r,v = game:oldlife()
	if gameover then
		return
	end
	return r,v
end

if game.life ~= game_newlife then
	game.oldlife = game.life
	game.life = game_newlife
end

stead.module_init(function()
	take(mode_exam)
	take(mode_take)
	take(mode_use)
	take(inv_sep)
	take(inventory);
	lifeon(mode_exam);
	inv = function()
		return objs(inventory);
	end
	mode_exam.state = true
	mode_exam:ini()
end)

MENU_HOOKS = true
end
