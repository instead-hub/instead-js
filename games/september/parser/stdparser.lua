function redirect(o, w)
	return function(s)
		return stead.call(stead.ref(o), w)
	end
end

parser.ifobj = function(s, w)
	local k, o 
	local n
	for k,o in opairs(objs()) do
		if not isDisabled(o) then
			return w
		end
	end
	return
end

parser.directions = { 
	{"n_to", "на", "север" };
	{"ne_to", "на", "северо-восток"};
	{"e_to",  "на", "восток"};
	{"se_to", "на",  "юго-восток"};
	{"s_to",  "на", "юг"};
	{"sw_to", "на",  "юго-запад"};
	{"w_to",  "на", "запад"};
	{"nw_to", "на", "северо-запад"};
	{"d_to","вниз"};
	{"u_to","наверх"};
}

parser.events.Wait = [[Проходит немного времени.]]

local function walk_to_obj(s, w)
	local m
	if not isRoom(w) and isObject(w) and w.door then
		if w.openable and not w.opened then
			m = stead.call(w, 'when_closed')
			if not m then
				local rc = w:G()
				local closed = ''
				if rc.male then
					closed = 'закрыт.'
				elseif rc.female then
					closed = 'закрыта.'
				else
					closed = 'закрыто.'
				end
				m = parser:cap(w:M 'им')..' '..closed;
			end
			return m;
		end
		m = stead.call(w, 'door_to')
		if not m then
			error ("Wrong direction (door_to): "..stead.deref(w));
		end
		walk(m)
	end
end

local function live_act(s, w)
	p (parser:cap(w:M 'дт'), " это не понравится.")
end

parser.events.Climb = function(s, w)
	if w:G().live then
		live_act(self, w)
		return 
	end
	return ("Не стоит залезать на "..w:M 'вн'..'.')
end

parser.events.WalkIn = function(s, w)
	if not isRoom(w) and isObject(w) then
		if w.door then
			return walk_to_obj(s, w)
		end
	end
	if w:G().live then
		live_act(self, w)
		return 
	end
	return ("Нельзя зайти в "..w:M 'вн'..'.')
end

parser.events.Walk = function(s, w)
	local k,v
	if not isRoom(w) and isObject(w) then
		if w.door then
			return walk_to_obj(s, w)
		end
		local rc = w:G()
		p (w:CM 'им', " и так ")
		if rc.singular then
			p 'находится'
		else
			p 'находятся'
		end
		p [[здесь.]];
		return
	end
	if isRoom(w) then
		return stead.walk(w)
	end
	for k,v in ipairs(s.directions) do
		if v[#v] == w then
			local m = here()[v[1]]
			if type(m) == 'string' then
				local w = stead.ref(m)
				if not isRoom(w) then
					return walk_to_obj(s, w)
				end
				return walk(m)
			else
				local r, v = stead.call(here(), v[1])
				if r ~= nil or v ~= nil then
					return r,v
				end
			end
		end
	end
	if parser.noway then
		return stead.call(parser, 'noway', w);
	end
	return "Некуда идти."
end
local function mwalk(d)
	local vv
	if tonumber(d) then
		vv = parser.directions[d]
		d = vv[1]
	end
	return function(s)
		local k,v
		v = vv
		if parser.compass or here()[d] then
			if v then
				return '~'..v[#v]
			end
			for k,v in ipairs(s.directions) do
				if v[1] == d then
					return '~'..v[#v]
				end
			end
		end
	end
end

local putany = function(s)
	if s:word(3) == 'на' then
		return 'PutOn %2 %4 | ReceiveOn %4 %2'
	elseif s:word(3) == 'в' then
		return 'PutIn %2 %4 | Receive %4 %2'
	else
		return 'PutUnder %2 %4 | ReceiveUnder %4 %2'
	end
end

local lookany = function(s)
	if s:word(2) == 'на' then
		return 'LookAt %3'
	elseif s:word(2) == 'в' then
		return 'LookAt %3'
	end
end

local lookobj = function(s)
	if s:word(2) == 'на' then
		return '{obj}вн|{inv}вн'
	elseif s:word(2) == 'в' then
		return '{obj}вн|{inv}вн'
	end
end

local searchany = function(s)
	if s:word(2) == 'на' then
		return 'SearchOn %3'
	elseif s:word(2) == 'в' then
		return 'Search %3'
	else
		return 'SearchUnder %3'
	end
end

local searchobj = function(s)
	if s:word(2) == 'на' then
		return '{obj}пр2|{inv}пр2'
	elseif s:word(2) == 'в' then
		return '{obj}пр2|{inv}пр2'
	else
		return '{obj}тв|{inv}тв'
	end
end

local pushobj = function(s)
	if s:word(3) == 'к'  then
		return "{obj}дт"
	elseif s:word(3) == 'на' then
		return "{obj}вн"
	end
end

local walkany = function(s)
	local k,v
	local w = s:object(3)
	if w then
		if isRoom(w) then
			return "Walk %3"
		end
		if s:word(2) == 'на' then
			return "Climb %3"
		elseif s:word(2) == 'в' then
			return "WalkIn %3"
		else
			return "Walk %3"
		end
	end
	w = s:object(2)
	if w then
		return "Walk %2"
	end
	w = s:word(3)
	if not w then
		w = s:word(2)
		return "Walk %2"
	else
		return "Walk %3"
	end
end

local walkall = function(s)
	local rc = ''
	local k, v
	local u = {}
	for k, v in ipairs(s.directions) do
		if (parser.compass or here()[v[1]]) and not u[v[2]] then
			u[v[2]] = true
			rc = rc .. v[2]..'|'
		end
	end
--	if #ways() ~= 0 then
--		rc = rc..'{way}|'
--	end
	local r = #objs() ~= 0 or #ways() ~= 0 
	if r and not u["в"] then
		rc = rc..'в|';
	end
	if r and not u["к"] then
		rc = rc..'к|';
	end
	if r and not u["на"] then
		rc = rc..'на';
	end
	return rc
end

local walkall2 = function(s)
	local k, v
	local rc = ''

--	if path(s:word()) then
--		return "{}"
--	end

	for k, v in ipairs(s.directions) do
		if s:word() == v[2] and not v[3] then
			return "{}"
		end
	end

	for k, v in ipairs(s.directions) do
		if parser.compass or here()[v[1]] then
			if v[3] then
				rc = rc..v[3]..'|'
			end
		end
	end

	if s:word() == 'на' then
		rc = rc..'{way}вн|{obj}вн'
	elseif s:word() == 'к' then
		rc = rc..'{way}дт|{obj}дт'
	elseif s:word() == 'в' then
		rc = rc..'{way}вн|{obj}вн'
	end
	return rc
end

parser.events._log = function(self, s)
	local on
	if s == 'да' then
		on = true
	elseif s == 'нет' then
		on = false
	else
		if parser.logname then
			p ([[Открыт журнал: ]]..parser.logname)
		else
			p [[Журнал выключен.]]
		end
		return
	end
	if on then
		parser:openlog()
		p ([[Открыт журнал: ]]..parser.logname)
	else
		parser.logname = false
		p [[Журнал выключен.]]
	end
end

parser.verb = {}

function parser.verb._Service(...)
	_Verb ({ "_log %2", "~_журнал","да|нет|{}" }, ...);
end

function parser.verb.Inventory(...)
	Verb ({ "Inventory", "инвентарь" }, ...);
end

function parser.verb.Exam(...)
	Verb ({ "Exam %2", "осмотреть|~изучить|~исследовать", "{}|{obj}вн|{me()}вн|все" }, ...);
end

function parser.verb.Walk(...)
	Verb ({ walkany, "идти|~зайти|~залезть|~лезть|~забраться|~подойти|~пойти", walkall, walkall2 }, ...);
	local k, v
	for k, v in ipairs(parser.directions) do
		Verb ({ "Walk %1", mwalk(k)}, ...);
	end
end

function parser.verb.LookAt(...)
	Verb ({ "LookAt %3", "посмотреть|~смотреть", "на|в", "{obj}вн|{inv}вн" }, ...);
end

function parser.verb.Search(...)
	Verb ({ searchany, "искать", "на|в|под", searchobj }, ...);
	Verb ({ 'Search %2', "~обыскать", "{obj}вн|{inv}вн" }, ...);
end


function parser.verb.Open(...)
	Verb ({ "Open %2 %3|OpenBy %3 %2", "открыть", "{obj}вн|{inv}вн", "{}|{inv}тв" }, ...);
end

function parser.verb.Close(...)
	Verb ({ "Close %2 %3", "закрыть", "{obj}вн|{inv}вн", "{}|{inv}тв" }, ...);
end

function parser.verb.Push(...)
	Verb ({ "Push %2 %4|Moved %4 %2", "толкнуть|~двигать|~сдвинуть", "{obj}вн", "{}|к|на", pushobj }, ...);
end

function parser.verb.Pull(...)
	Verb ({ "Pull %2", "тянуть", "{obj}вн", ...});
end

function parser.verb.Smell(...)
	Verb ({ "Smell %2", "нюхать|~понюхать", "{obj}вн|{inv}вн" }, ...);
end

function parser.verb.Eat(...)
	Verb ({ "Eat %2", "есть|~съесть", "{inv}вн" }, ...);
end

function parser.verb.Put(...)
	Verb ({ "PutIn %2 %4|Receive %4 %2", "вставить|~воткнуть", "{inv}вн", "в", "{obj}вн|{inv}вн"}, ...);
	Verb ({ putany, "поставить|~положить", "{inv}вн", "{}|на|в|под", "{obj}вн|{inv}вн"}, ...);
end

function parser.verb.Attack(...)
	Verb ({ "Attack %2 %3", "ударить|~бить|~разбить|~сломать", "{obj}вн|{inv}вн", "{}|{inv}тв"}, ...);
end

function parser.verb.Take(...)
	Verb ({ "Take %2", "взять|~забрать", "{obj}вн" }, ...);
end

function parser.verb.Drop(...)
	Verb ({ function(s)
		if s:word(3) == 'в' then
			return "Drop %2 %4 | Receive %4 %2"
		else
			return "Drop %2 %4 | ReceiveOn %4 %2"
		end
	end, "бросить|~кинуть", "{inv}вн", '{}|в|на', "{obj}вн"}, ...);
	Verb ({ "Drop %2","~выбросить", "{inv}вн" }, ...);
end

function parser.verb.Remove(...)
	Verb ({ "Remove %2 %3", "извлечь|~вытащить", "{obj}вн", "{}|{inv}тв"}, ...);
end

function parser.verb.Wait(...)
	Verb ({ "Wait", "ждать|~подождать" }, ...);
end

function parser.verb.Read(...)
	Verb ({ "Read %2", "читать|~почитать|~прочитать", "{obj}вн|{inv}вн" }, ...);
end

function parser.verb.Tie(...)
	Verb ({ "Tie %2 %4", "привязать", "{inv}вн", "к", "{obj}дт|{inv}дт" }, ...);
end

function parser.verb.TalkTo(...)
	Verb ({ "TalkTo %3", "говорить|~поговорить", "с|со", "{obj}тв" }, ...);
end

function parser.verb.Give(...)
	Verb ({ "Give %2 %3|Receive %3 %2", "отдать|~дать|~подарить", "{inv}вн", "{obj}дт" }, ...);
end

function parser.init()
	game.verbs = {};

	parser.verb.Inventory()
	parser.verb.Exam()
	parser.verb.Walk()
	parser.verb.LookAt()
	parser.verb.Search()
	parser.verb.Open()
	parser.verb.Close()
	parser.verb.Push()
	parser.verb.Pull()
	parser.verb.Smell()
	parser.verb.Eat()
	parser.verb.Put()
	parser.verb.Attack()
	parser.verb.Take()
	parser.verb.Drop()
	parser.verb.Remove()
	parser.verb.Wait()
	parser.verb.Read()
	parser.verb.Tie()
	parser.verb.TalkTo()
	parser.verb.Give()
end
parser:init()

parser.it = function(s, w, nm)
	local rc, n, v

	nm = morph:case2n(nm)

	local a1 = {'он', 'его', 'ему', 'его', 'им', 'нем' };
	local a2 = {'оно', 'его', 'ему', 'его', 'им', 'нем' };
	local a3 = {'она', 'её', 'ей', 'ее', 'ней', 'ней' };
	local a4 = { 'они', 'их', 'им', 'их', 'ими', 'них' };
	
	rc = parser:gender(w)
	if rc.plural then
		v = a4
	elseif rc.male then
		v = a1
	elseif rc.female then
		v = a3
	else
		v = a2
	end
	return v[nm]
end

parser.need = function(s, w)
	local rc
	rc = parser:gender(w)
	if rc.plural then
		return "нужны"
	elseif rc.male then
		return "нужен"
	elseif rc.female then
		return "нужна"
	else
		return "нужно"
	end
end

local person = function(a, b, c, d)
	local p
	if not me().person then
		p = 1
	else
		p = me().person;
	end
	if not a then
		return p
	end
	if p == 1 then
		return a
	elseif p == 2 then
		if me().plural and d then
			return c
		end
		return b
	end
	if d then
		return d
	end
	return c
end

local gen = function (m, f, n)
	if me().male then
		return m
	elseif me().female then
		return f
	else
		return n
	end
end


parser.events.before_Exam = function(self, s)
	if not s or not self:object() then
		stead.need_scene()
		return true
	end
end

parser.me = function(self, s)
	return me():M(s)
end

parser.Me = function(self, s)
	return self:cap(me():M(s))
end

parser.events.Give = function(self, s, w)
	if person() == 1 then
		p ("Мне не удалось отдать ", s:M 'вн', " ", w:M 'дт', ".");
	elseif person() == 2 then
		if me().plural then
			p ("Вам не удалось отдать ", s:M 'вн', " ", w:M 'дт', ".");
		else
			p ("Тебе не удалось отдать ", s:M 'вн', " ", w:M 'дт', ".");
		end
	elseif person() == 3 then
		p (self:Me('дт') .. " не удалось отдать ", s:M 'вн', " ", w:M 'дт', ".");
	end
end;

parser.events.Tie = function(self, s, w)
	p ("Бессмысленно привязывать ", s:M 'вн', " к ", w:M 'дт', ".");
end;

parser.events.after_Exam = function(self, s)
	if self:react() then
		return
	end
	local w = s
	local what = w:M 'вн'
	local it = w:it 'пр';

	if w == me() then
		what = 'себя';
		it = 'себе'
	end
--[[
	if w.container and (w.opened or not w.openable) then
		local r, n = self:content(w)
		if n == 1 then
			p ("В ", w:M 'дт', " находится ");
			return
		elseif n > 1 then
			p ("В ", w:M 'дт', " находятся: ", r);
			return
		end
	end
]]--
	if person() == 1 then
		p ("Я осмотрел ", what, " и не нашёл в ", it, " ничего необычного.");
	elseif person() == 2 then
		if me().plural then
			p ("Вы осмотрели", gen("", "а", "о")," ", 
				what, 
				" и не нашли",
				" в ", it, " ничего необычного.");
		else
			p ("Ты осмотрел", gen("", "а", "о")," ", 
				what, 
				" и не ", gen("нашёл", "нашла", "нашло"),
				" в ", it, " ничего необычного.");
		end
	else
		p (self:Me().. " осмотрел", gen("", "а", "о")," ", 
			what,
			" и не ", gen("нашёл", "нашла", "нашло"),
			" в ", it, " ничего необычного.");
	end
	return
end;

parser.events.TalkTo = function(self, w)
	local rc = w:G()
	if rc.singular then
		rc = 'игнорирует'
	else
		rc = 'игнорируют'
	end
	if person() == 1 then
		p (self:cap(w:M 'им'), ' меня '..rc..'.');
	elseif person() == 2 then
		if me().plural then
			p (self:cap(w:M 'им'), ' вас '..rc..'.');
		else
			p (self:cap(w:M 'им'), ' тебя '..rc..'.');
		end
	else
		p (self:cap(w:M 'им'), ' '..rc..' ', self:me('вн'),'.');
	end
	return
end;
parser.content = function(s, w)
	local k, v, rc, m, n
	m = 0
	n = 0
	rc = ''

	for k,v in ipairs(objs(w)) do
		if v ~= parser_menu_items and not v.hidden and not isDisabled(v) then
			n = n + 1
		end
	end

	for k,v in ipairs(objs(w)) do
		if v ~= parser_menu_items and not v.hidden and not isDisabled(v) then
			rc = rc .. v:M(); --stead.dispof(v)
			m = m + 1
			if m == n then
				rc = rc..'.'
			elseif m == n - 1 then
				rc = rc..' и ';
			else
				rc = rc..', '
			end
		end
	end
	if rc == '' then rc = nil end
	return rc, n
end

parser.events.Inventory = function(self, s)
	local k,v
	local n = 0
	local m = 0
	local rc = 0
	v, n = self:content(me())
	if n == 0 then 
		return person("У меня с собой ничего нет.", "У тебя с собой ничего нет.", "У вас собой ничего нет.", "У "..self:me('вн').." с собой ничего нет.");
	end
	if n <= 2 then 
		rc = person("У меня с собой только ",  "У тебя с собой только ", "У вас с собой только ", "У "..self:me('вн').." с собой только ");
	else
		rc = person("У меня с собой: ", "У тебя с собой: ", "У вас с собой: ", "У "..self:me('вн').." с собой: ");
	end
	rc = rc .. v
	return rc
end

parser.events.Drop = function(self, s, w)
	if not s.dropable then
		local rc = s:G()
		if rc.singular then
			rc = 'может'
		else
			rc = 'могут'
		end
		if person() == 1 then
			p ("Мне ", s:it 'им', ' еще '..rc..' пригодиться.');
		elseif person() == 2 then
			if me().plural then
				p ("Вам ", s:it 'им', ' еще '..rc..' пригодиться.');
			else
				p ("Тебе ", s:it 'им', ' еще '..rc..' пригодиться.');
			end
		else
			p (self:Me('дт')..' ', s:it 'им', ' еще '..rc..' пригодиться.');
		end
		return
	end
	if w then
		return "В этом нет смысла."
	end
	drop(s)
	return r, v
end

parser.events.after_Drop = function(self, s, w, t)
	if self:react() then
		return
	end
	if person() == 1 then
		p ("Я ", gen("выбросил ", "выбросила ", "выбросило "),s:M 'вн',".")
	elseif person() == 2 then
		if me().plural then
			p ("Вы выбросили ", s:M 'вн',".")
		else
			p ("Ты ", gen("выбросил ", "выбросила ", "выбросило "), s:M 'вн',".")
		end
	else
		p (self:Me(),' ', gen("выбросил ", "выбросила ", "выбросило "), s:M 'вн',".")
	end
end

parser.events.Read = function(self, s, ...)
	parser:redirect({ "Exam", s, ... })
--	p ([[На ]]..s:M 'дт'.." ничего не написано.")
end


parser.events.Take = function(self, s)
	if not s.takeable then
		if s:G().live then
			live_act(self, s)
			return 
		end
		if person() == 1 then
			p ("Мне не ", parser:need(s), " ", s:M 'им', ".")
		elseif person() == 2 then
			if me().plural then
				p ("Вам не ", parser:need(s), " ", s:M 'им', ".")
			else
				p ("Тебе не ", parser:need(s), " ", s:M 'им', ".")
			end
		else
			p (self:Me 'дт', " не ", parser:need(s), " ", s:M 'им', ".")
		end
		return false
	end
	take(s)
end;

parser.events.after_Take = function(self, s)
	if self:react() then
		return
	end
	if person() == 1 then
		p ("Я забрал ", s:M 'вн', ".");
	elseif person() == 2 then
		if me().plural then
			p ("Вы забрали ", s:M 'вн', ".");
		else
			p ("Ты забрал ", s:M 'вн', ".");
		end
	else
		p (self:Me().." забрал ", s:M 'вн', ".");
	end
end;

parser.gensw = function(s, w, a, b, c, d, e, f)
	local rc = parser:gender(w)
	if rc.male then
		if rc.singular then
			rc = a
		else
			rc = d;
		end
	elseif rc.female then
		if rc.singular then
			rc = b;
		else
			rc = e
		end
	else
		if rc.singular then
			rc = c;
		else
			rc = f
		end
	end
	return rc
end

parser.events.Open = function(self, s, w)
	if s.openable then
		if s.opened then
			local rc = parser:gensw(s, "открыт", "открыта", "открыто", "открыты", "открыты", "открыты")
			p (parser:cap(s:M 'им'), " уже ", rc, ".");
			return
		end
--		if w then
--			return "Может, сделать это проще?"
--		end
	else
		p (parser:cap(s:M 'вн'), " нельзя открыть.");
		return
	end
	s.opened = true;
end

parser.events.after_Open = function(self, s)
	if self:react() then
		return
	end
	if person() == 1 then
		p ("Я открыл ", s:M 'вн', ".");
	elseif person() == 2 then
		if me().plural then
			p ("Вы открыли ", s:M 'вн', ".");
		else
			p ("Ты открыл ", s:M 'вн', ".");
		end
	else
		p (self:Me()," открыл ", s:M 'вн', ".");
	end
	s:enable_all()
end;

parser.events.Close = function(self, s, w)
	if s.openable then
		if not s.opened then
			local rc = parser:gensw(s, "закрыт", "закрыта", "закрыто", "закрыты", "закрыты", "закрыты")
			p (parser:cap(s:M 'им'), " уже ", rc, ".");
			return
		end
--		if w then
--			return "Может, сделать это проще?"
--		end
	else
		p (parser:cap(s:M 'вн'), " нельзя закрыть.");
		return
	end
	s.opened = false
end;

parser.events.after_Close = function(self, s)
	if self:react() then
		return
	end
	if person() == 1 then
		p ("Я закрыл ", s:M 'вн', ".");
	elseif person() == 2 then
		if me().plural then
			p ("Вы закрыли ", s:M 'вн', ".");
		else
			p ("Ты закрыл ", s:M 'вн', ".");
		end
	else
		p (self:Me()," закрыл ", s:M 'вн', ".");
	end
	s:disable_all()
end;

parser.events.Push = function(self, s)
	if s:G().live then
		return live_act(self, s)
	end
end

parser.events.Pull = function(self, s)
	if s:G().live then
		return live_act(self, s)
	end
end

parser.events.after_Push = function(self, s, w)
	if self:react() then
		return
	end
	p ([[Нет смысла двигать ]], s:M 'вн', '.')
end

parser.events.after_Pull = function(self, s, w)
	if self:react() then
		return
	end
	p ([[Нет смысла тянуть ]], s:M 'вн', '.')
end

parser.events.after_Attack = function(self, s, w)
	if self:react() then
		return
	end
	p ([[Агрессия к ]],  s:M 'дт', [[ не оправдана.]])
	return
end

parser.events.after_LookAt = function(self, s, ...)
	if self:react() then
		return
	end
	parser:redirect({ "Exam", s, ... })
	return true 
end

parser.events.Search = function(self, s, w)
	if s:G().live then
		return live_act(self, s)
	end
	return
end
parser.events.SearchOn = parser.events.Search
parser.events.SearchUnder = parser.events.Search

parser.events.after_Search = function(self, s, w)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я не нахожу в ]],  s:M 'пр', [[ ничего интересного.]])
	elseif person() == 2 then
		if me().plural then
			p ([[Вы не находите в ]],  s:M 'пр', [[ ничего интересного.]])
		else
			p ([[Ты не находишь в ]],  s:M 'пр', [[ ничего интересного.]])
		end
	else
		p (self:Me()..[[ не находит в ]],  s:M 'пр', [[ ничего интересного.]])
	end
	return
end

parser.events.after_SearchOn = function(self, s, w)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я не нахожу на ]],  s:M 'пр', [[ ничего интересного.]])
	elseif person() == 2 then
		if me().plural then
			p ([[Вы не находите на ]],  s:M 'пр', [[ ничего интересного.]])
		else
			p ([[Ты не находишь на ]],  s:M 'пр', [[ ничего интересного.]])
		end
	else
		p (self:Me()..[[ не находит на ]],  s:M 'пр', [[ ничего интересного.]])
	end
	return
end

parser.events.after_SearchUnder = function(self, s, w)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я не нахожу под ]],  s:M 'тв', [[ ничего интересного.]])
	elseif person() == 2 then
		if me().plural then
			p ([[Вы не находите под ]],  s:M 'тв', [[ ничего интересного.]])
		else
			p ([[Ты не находишь под ]],  s:M 'тв', [[ ничего интересного.]])
		end
	else
		p (self:Me()..[[ не находит под ]],  s:M 'тв', [[ ничего интересного.]])
	end
	return
end

--parser.events.after_SearchOn = parser.events.after_Search
--parser.events.after_SearchUnder = parser.events.after_Search

parser.events.after_Smell = function(self, s)
	if self:react() then
		return
	end
	if not s or s.live then
		p [[Никакого необычного запаха нет.]]
		return
	end
	if person() == 1 then
		p ([[Я ]], gen("понюхал", "понюхала", "понюхало"), " ",  s:M 'вн', [[. Пахнет как ]], s:M 'им', '.')
	elseif person() == 2 then
		if me().plural then
			p ([[Вы понюхали ]], s:M 'вн', [[. Пахнет как ]], s:M 'им', '.')
		else
			p ([[Ты ]], gen("понюхал", "понюхала", "понюхало"), " ", s:M 'вн', [[. Пахнет как ]], s:M 'им', '.')
		end
	else
		p (self:Me()..' ', gen("понюхал", "понюхала", "понюхало"), " ", s:M 'вн', [[. Пахнет как ]], s:M 'им', '.')
	end
end

parser.events.Remove = function(self, s, w)
	if not w and s.takeable then
		parser:redirect({"Take", s });
		return
	end
	if not s.removable then
		p (self:cap(s:M 'вн')..' нельзя извлечь.')
		if w then
			p ('Тем более '..w:M 'тв'..'.')
		end
		return
	end
	if not w then
		p "Как именно это сделать?"
		return
	end
	if not have(w) then
		if person() == 1 then
			p ("У меня нет "..w:M 'рд'..'.')
		elseif person() == 2 then
			if me().plural then
				p ("У вас нет "..w:M 'рд'..'.')
			else
				p ("У тебя нет "..w:M 'рд'..'.')
			end
		else
			p ("У ",self:me 'вн', " нет "..w:M 'рд'..'.')
		end
		return
	end
	take(s)
end

parser.events.after_Remove = function(self, s, w)
	if self:react() then
		return
	end
	if w then
		if person() == 1 then
			p ("Я ", gen("извлек", "извлекла", "извлекло"), " ",s:M 'вн'.." при помощи "..w:M 'рд'..'.')
		elseif person() == 2 then
			if me().plural then
				p ("Вы извлекли ",s:M 'вн'.." при помощи "..w:M 'рд'..'.')
			else
				p ("Ты ", gen("извлек", "извлекла", "извлекло"), " ",s:M 'вн'.." при помощи "..w:M 'рд'..'.')
			end
		else
			p (self:Me()..' ', gen("извлек", "извлекла", "извлекло"), " ",s:M 'вн'.." при помощи "..w:M 'рд'..'.')
		end
		return
	end
	if person() == 1 then
		p ("Я ", gen("взял", "взяла", "взяло"), " ",s:M 'вн');
	elseif person() == 2 then
		if me().plural then
			p ("Вы взяли ", s:M 'вн');
		else
			p ("Ты ", gen("взял", "взяла", "взяло"), " ", s:M 'вн');
		end
	else
		p (self:Me()..' ', gen("взял", "взяла", "взяло"), " ", s:M 'вн');
	end
end

parser.events.Eat = function(self, s)
	if not s.eatable then
		if s:G().live then
			return live_act(self, s)
		end
		if person() == 1 then
			p ("Мне не хочется есть "..s:M 'вн'..'.')
		elseif person() == 2 then
			if me().plural then
				p ("Вам не хочется есть "..s:M 'вн'..'.')
			else
				p ("Тебе не хочется есть "..s:M 'вн'..'.')
			end
		else
			p (self:Me 'дт', " не хочется есть "..s:M 'вн'..'.')
		end
		return
	end
	inv():del(s)
end

parser.events.after_Eat = function(self, s)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я ]], gen("съел", "съела", "съело"), " ",  s:M 'вн', [[.]])
	elseif person() == 2 then
		if me().plural then
			p ([[Вы съели ]], s:M 'вн', [[.]])
		else
			p ([[Ты ]], gen("съел", "съела", "съело"), " ", s:M 'вн', [[.]])
		end
	else
		p (self:Me()..' ', gen("съел", "съела", "съело"), " ", s:M 'вн', [[.]])
	end
end

parser.events.PutIn = function(self, s, w)
	if not s.dropable then
		p (parser:cap(s:M 'им')..' еще может пригодиться.')
		return
	end

	if not w then
		self:redirect { "Drop", s }
		return
	end
	if w.container and self:curevent() == 'PutIn' then
		if  not w.openable or w.opened then
			drop(s, w)
		else
			p("Невозможно поместить "..s:M 'вн'..' в '..w:M 'вн'..'.')
		end
	else
		p 'В этом нет смысла.'
	end
	return r, v
end
parser.events.PutOn = parser.events.PutIn
parser.events.PutUnder = parser.events.PutIn

parser.events.after_PutIn = function(self, s, w)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я ]], gen("положил", "положила", "положило"), " ", (s:M 'вн')..' в '..(w:M 'вн')..'.')
	elseif person() == 2 then
		if me().plural then
			p ([[Вы положили ]],  (s:M 'вн')..' в '..(w:M 'вн')..'.')
		else
			p ([[Ты ]], gen("положил", "положила", "положило"), " ",  (s:M 'вн')..' в '..(w:M 'вн')..'.')
		end
	else
		p (self:Me()..' ', gen("положил", "положила", "положило"), " ",  (s:M 'вн')..' в '..(w:M 'вн')..'.')
	end
end

parser.events.after_PutOn = function(self, s, w)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я ]], gen("положил", "положила", "положило"), " ",(s:M 'вн')..' на '..(w:M 'вн')..'.')
	elseif person() == 2 then
		if me().plural then
			p ([[Вы положили ]],  (s:M 'вн')..' на '..(w:M 'вн')..'.')
		else
			p ([[Ты ]], gen("положил", "положила", "положило"), " ",(s:M 'вн')..' на '..(w:M 'вн')..'.')
		end
	else
		p (self:Me()..' ', gen("положил", "положила", "положило"), " ",  (s:M 'вн')..' на '..(w:M 'вн')..'.')
	end
end

parser.events.after_PutUnder = function(self, s, w)
	if self:react() then
		return
	end
	if person() == 1 then
		p ([[Я ]], gen("положил", "положила", "положило"), " ",(s:M 'вн')..' под '..(w:M 'вн')..'.')
	elseif person() == 2 then
		if me().plural then
			p ([[Вы положили ]],  (s:M 'вн')..' под '..(w:M 'вн')..'.')
		else
			p ([[Ты ]], gen("положил", "положила", "положило"), " ",(s:M 'вн')..' под '..(w:M 'вн')..'.')
		end
	else
		p (self:Me()..' ', gen("положил", "положила", "положило"), " ",  (s:M 'вн')..' под '..(w:M 'вн')..'.')
	end
end


function cutscene(v)
	v.cutscene_type = true
	if type(v.dsc) ~= 'table' then
		v.dscs = {};
		v.dscs[1] = v.dsc
	else
		v.dscs = v.dsc
	end
	v._num = 1;
	v.dsc = function(s)
		if type(s.dscs[s._num]) == 'function' then
			return s.dscs[s._num](s)
		end
		p (s.dscs[s._num])
	end;
	v.Next = function(s)
		s._num = s._num + 1;
		if s._num > #s.dscs then
			if type(s.walk_to) == 'function' then
				return stead.call(s, 'walk_to')
			end
			walk(s.walk_to)
			return
		end
		if type(s.dscs[s._num]) == 'function' then
			return s.dscs[s._num](s)
		end
		p (s.dscs[s._num])
	end;
	if v.enter == nil then
		v.enter = function(s)
			s._num = 1
		end
	end
	v.verbs = { 
		{ "Next", function(s)
			if here().walk_to then
				return "дальше"
			end
		end 
		};
	};
	return room(v);
end

parser.dialog_rescan = stead.dialog_rescan;

parser.events.Phrase = function(s, n)
	local key = tostring(n)
	local ph = stead.here():srch(key);
	if ph and stead.nameof(ph) == key then
		local a = stead.call(ph, 'dsc')
		local r, v = stead.call(ph, 'act');
		if tostring(a) then
			parser._lastcmd = a
		end
		if isDialog(here()) then
			stead.dialog_rescan(here(), true)
		end
		return r,v
	end
end

stead.dialog_rescan = function(s, n, ...)
	local r, v = parser.dialog_rescan(s, n, ...)
	if n and tonumber(r) then
		s.verbs = {}
		local i,k,ph,ii, start
		k = 0
		start = s:current()
		for i,ph,ii in opairs(s.obj) do
			if ii >= start then
				if ii ~= start and k >= r then
					break
				end
				if isPhrase(ph) and not isDisabled(ph) then
					k = k + 1;
					--local d = stead.call(ph, 'dsc')
					Verb ({ "Phrase "..tostring(k), tostring(k), '{}' }, s);
				end
			end
		end
	end
	return r, v
end

function darkroom(v)
	v.orig_enter = v.enter
	v.darkroom_type = true
	v._light = false;
	v.light = function(s, on)
		local rc = s._light
		if on then
			s._light = true
			if here() == dark and dark._room == s then
				if not stead.in_onexit_call then
					walkin(s)
				end
				return
			end
		elseif on == false then
			s._light = false
			if here() == s then
				dark._room = here()
				if not stead.in_onexit_call then
					dark:before_Walk();
					walkin(dark)
				end
			end
			return
		end
		return rc
	end;
	v.enter = function(s, f)
		local r,v = stead.call(s, 'orig_enter');
		if v == false or r == false then
			return r, v
		end
		s:light(s._light)
	end;
	return room(v)
end

dark = room {
	system_type = true;
	nam = 'В темноте';
	dsc = [[Темно, ничего не видно.]];
	before_Inventory = function(s)
	end;
	before_Default = [[Здесь темно.]];
	ini = function(s)
		s:before_Walk();
	end;
	before_Walk = function(s, w)
		local k,v 
		if not s._room then
			return
		end
		for k,v in ipairs(parser.directions) do
			s[v[1]] = s._room[v[1]]
		end
	end;
	light = function(s, on)
		return(s._room:light(on))
	end;
}

--iam = obj {
--	nam = 'я';
--	morph = {'я', 'меня', 'мне', 'себя', 'мной', 'меня' }; -- осмотреть себя, а не меня
--	attr [[ hidden, ~dropable, live ]];
--}
