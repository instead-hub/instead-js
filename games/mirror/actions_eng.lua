dofile('menu.lua');

Look = function(s)
	if not s.exam then
		return 'Nothing important...';
	end
	return call(s,'exam');
end

Open = function(s)
	if not s.open then
		return 'It can’t be opened...';
	end
	if s.Opened then
		return 'It’s already open...';
	end
	local r,v = call(s,'open');
	if v ~= false then
		s.Opened = true;
	end
	return r
end

Close = function(s)
	if not s.close then
		return 'Это нельзя закрыть...';
	end
	if not s.Opened then
		return 'Уже закрыто...';
	end
	local r,v = call(s,'close');
	if v ~= false then
		s.Opened = false;
	end
	return r;
end

Take = function(s)
    if have(s) then
        return 'I already have this.';
    end
    if not s.take then
        return 'It can’t be taken...';
    end
    local r,v= call(s,'take');
    if v ~= false then
        if s._weight then
            if (status._cargo + s._weight > 100) then
                return 'Too heavy!';
            end
            status._cargo = status._cargo + s._weight;
        end
        take(s);
    end
    return r
end

Drop = function(s)
    local q = here();
    if q._water then
        p 'If I drop it in water, I won’t be able to retrieve it later.';
        return false;
    end
    if not have(s) then
        return 'I have no this item.';
    end
    if not s.drop then
        return 'It can’t be dropped.';
    end
    local r,v = call(here(), 'drop', deref(s))
    if not r then
        r,v = call(s,'drop');
    end
    if v ~= false then
        do_drop(s, w);
    end
    return r;
end


do_drop = function(s, w)
    s = ref(s)
    if s._weight ~= nil then
        status._cargo = status._cargo - s._weight;
    end
    drop(s, w);
end

Push = function(s)
	if not s.push then
		return 'Это нельзя толкнуть...';
	end
	local r = call(s, 'push');
	return r;
end

Eat = function(s)
	if not s.eat then
		return 'Это нельзя есть...';
	end
	local r,v = call(s,'eat');
	if v ~= false then
		inv():del(s);
	end
	return r;
end

Talk = function(s)
	if not s.talk then
		return 'Hmm... won’t speak with this...';
	end
	local r,v=call(s, 'talk');
	return r
end

Give = function(s, w)
	local r, v, rr, vv;
	if not have(s) then
		p 'I can’t give it...';
		return false;
	end
	if not s.give and not ref(w).accept then
		p 'What for?';
		return false;
	end
	r, v = call(s, 'give', w);
	if v ~= false then
		rr, vv = call(ref(w), 'accept', s);
		if vv ~= false then
			remove(s, me());
		end
	end
        if type(r) ~= 'string' and type(rr) ~= 'string' and (r == true or rr == true) then
                return true, false
        end
	return stead.par(' ', r, rr),false
end


Use = function(s, w)
	local r,v;
	if givem._state then
		if w == nil then
			return 'It’s nonsense...'
		end
		return Give(s, w);
	end
	if not w then
		if not s.useit then
			return 'How would you do that?'
		end
		r, v = call(s, 'useit', w);
	else
		r, v = call(s, 'useon', w);
	end
	return r, v;
end

function iobj(v)
	v.act = Look;
	v.inv = Look;
	v.Open = Open;
	v.Close = Close;
	v.Push = Push;
	v.Take = Take;
	v.Drop = Drop;
	v.Eat = Eat;
	v.Exam = Look;
	v.Talk = Talk;
	v.use = Use;
	return menu(v);
end


-- for aliases
act = {
	exam = function(s)
		return call(s, 'exam');
	end,
	take = function(s)
		return call(s, 'take');
	end,
	drop = function(s)
		return call(s, 'drop');
	end,
	push = function(s)
		return call(s, 'push');
	end,
	eat = function(s)
		return call(s, 'eat');
	end,
	talk = function(s)
		return call(s, 'talk');
	end,
	open = function(s)
		return call(s, 'open');
	end,
	close = function(s)
		return call(s, 'close');
	end,
	useon = function(s, w)
		return call(s, 'useon', w);
	end,
	useit = function(s)
		return call(s, 'useit');
	end,
	give = function(s, w)
		return call(s, 'give', w);
	end
};

takem  = actmenu('TAKE', 'Take', true);
dropm  = actmenu('DROP', 'Drop', false, true);
pushm  = actmenu('PUSH', 'Push', true);
eatm   = actmenu('EAT', 'Eat', true, true);
talkm  = actmenu('TALK', 'Talk', true);
openm  = actmenu('OPEN', 'Open', true, true);
closem = actmenu('CLOSE', 'Close', true, true);
usem   = actmenu('USE', 'use', true, true);
givem  = actmenu('GIVE', 'use', true, true, true);

rest   = menu {
    action_type = true,
    nam = 'REST',
    inv = function(s)
    if here() == Cell and (guardian._state == GOING or guardian._state == ENTER or guardian._state == BEAT) then
        return 'I can’t rest right now...';
    end

    if here() == Forest_Troll_Village and (troll._state == TROLL_SEATING or troll._state == TROLL_HIDING or troll._state == TROLL_PREPARING) then
        return '';
    end

    if here() == River_Bank and River_Bank._just_arrive then
        status._health = status._health + 10;
        River_Bank._just_arrive = false;
        here()._rested = true;
        return 'Journey by the river exhausted me. After resting a while I feel much better...';
    end

    if here()._rested then
        if here().rested then
            return call(here(), 'rested');
        end
        return 'I don’t want to rest any more...';
    end
    here()._rested = true
    if here()._add_health_rest then
        status._health = status._health + here()._add_health_rest;
    end
    if here().rest then
        return call(here(), 'rest');
    end

    return 'I rest for a while.'
    end,
};

pocketm = pocket('INVENTORY');

inv = function(s)
    return pocketm.robj;
end

menu_init();

function actions_init()
    put(pocketm, 'pl');
    put(takem, 'pl');
    put(dropm, 'pl');
    put(usem, 'pl');
    put(talkm, 'pl');
    put(givem, 'pl');
    put(rest, 'pl');
--    put(pushm, 'pl');
--    put(eatm, 'pl');
--    put(openm, 'pl');
--    put(closem, 'pl');
--    put(stat { nam = ' ' }, 'pl');
end
