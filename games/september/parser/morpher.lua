local function gramtab(file, nr, ofile)
	local line
	local v = { }
	if not file or not nr then
		return
	end
	local function parse_line(s)
		local v = {}
		s:gsub("[^ \t]+", function(s)
			stead.table.insert(v, s)
		end)
		return v
	end
	local function parse_attr(s)
		local v = {}
		v.weight = 9
		s = s:gsub("пр,2$", "пр2");
		s:gsub("[^,]+", function(s)
			if s == 'мр' then
				v.male = true
			elseif tonumber(s) then
				v.secondary = true
			elseif s == 'жр' then
				v.female = true
			elseif s == 'мр-жр' then
				v.male = true
				v.female = true
			elseif s == 'ср' then
				v.neuter = true
			elseif s == 'ед' then
				v.singular = true
			elseif s == 'мн' then
				v.plural = true
			elseif s == 'од' then
				v.live = true
			elseif s == 'арх' then
				v.archaism = true
			elseif s == 'прев' then
				v.perfect = true
			elseif s == 'но' then
				v.live = false
			elseif s == 'им' then
				v.nom = true
				v.weight = 1
			elseif s == 'рд' then
				v.gen = true
				if v.weight > 2 then
					v.weight = 2
				end
			elseif s == 'дт' then
				v.dat = true
				if v.weight > 3 then
					v.weight = 3
				end
			elseif s == 'вн' then
				v.acc = true
				if v.weight > 4 then
					v.weight = 4
				end
			elseif s == 'тв' then
				v.ins = true
				if v.weight > 5 then
					v.weight = 5
				end
			elseif s == 'пр' then
				v.loc = true
				if v.weight > 6 then
					v.weight = 6
				end
			elseif s == 'зв' then
				v.ask = true
				if v.weight > 8 then
					v.weight = 8
				end
			elseif s == 'пр2' then
				v.loc2 = true
				if v.weight > 7 then
					v.weight = 7
				end
			end
		end)
		return v
	end
	for line in file:lines() do
		if ofile then
			ofile:write(line, "\n")
			stead.busy(true)
		end
		line = line:gsub("^[ \t]+",""):gsub("[ \t]+$", "");
		if not line:find("^//") and line ~= '' then
			local l = parse_line(line)
--			if l[3] == 'С' or l[3] == 'П' then
			if l[4] then
				v[l[1]] = parse_attr(l[4])
				v[l[1]].type = l[3]
			end
		end
		nr = nr - 1
		if nr == 0 then
			break
		end
	end
	return v
end

local function paradigms(line, gtab)
	local v = {}
	line:gsub("[^ \t]+", function(s)
		local vx = { }
		local vv = {}
		if s == '-' then
			vx.code = nil
		else
			s:gsub("[^:]+", function(s)
				stead.table.insert(vv, s);
			end)
			vx.suffix = vv[2]
			vx.code = vv[1]
			vx.grammar = gtab[vx.code]
		end
		stead.table.insert(v, vx)
	end)
	return v
end

local function get_acc(line)
	local vv = {}
	line:gsub("[^ \t]+", function(s)
		local n = tonumber(s)
		if not n or n == 255 then
			n = -1
		end
		stead.table.insert(vv, n)
	end)
	return vv
end

local function morph_load(fname, words, oname)
	local ofile
	local file = io.open(fname, "r")
	if oname then
		ofile = io.open(oname, "wb")
	end
	local line
	local db = {}
	local pre = {}
	local para = {}
	local para2 = {}
	local accs = {}
	local accs2 = {}
	local npara
	local npre
	local ngtab
	local gtab
	local nacc
	if not file then
		return
	end

	for line in file:lines() do
		ngtab = tonumber(line) 
		if ofile then
			ofile:write(ngtab, "\n")
		end
		morph.gtab = gramtab(file, ngtab, ofile)
		gtab = morph.gtab
		if ofile then
			stead.busy(true)
		end
		break
	end

	for line in file:lines() do
		if not npara then 
			npara = tonumber(line) 
--			print(npara)
		else
			if ofile then
				stead.busy(true)
			end
			stead.table.insert(para, paradigms(line, gtab))
			npara = npara - 1
			if npara == 0 then break end
		end
	end

	for line in file:lines() do
		if not nacc then 
			nacc = tonumber(line) 
--			print(npara)
		else
			if ofile then
				stead.busy(true)
			end
			stead.table.insert(accs, get_acc(line))
			nacc = nacc - 1
			if nacc == 0 then break end
		end
	end

	for line in file:lines() do
		if not npre then 
			npre = tonumber(line) 
--			print(npre)
		else
			if ofile then
				stead.busy(true)
			end
			stead.table.insert(pre, line)
			npre = npre - 1
			if npre == 0 then break end
		end
	end
	local num = 0
	local dict = {}
	for line in file:lines() do
		local v = {};
		if ofile then
			stead.busy(true)
		end
		line:gsub("[^ \t]+", function(s)
			stead.table.insert(v, s)
		end)
		local b = v[1]
		local base = b
		local acc = tonumber(v[3])
		local pgen = v[4]
		local pp = tonumber(v[5])
		local prist = pp
		if not prist then
			prist = ' '..pgen
		else
			prist = ' '..pgen..' '..v[4]
		end
		if b == '#' then b = '' end
		local p = tonumber(v[2])
		local k, v
		if pp then
			pp = pre[pp + 1]
		else
			pp = ''
		end

		b = pp..b;

		p = para[p + 1]
		acc = accs[acc + 1]

		local hit = false
		for k,v in ipairs(p) do
			local g = v.grammar
			local s = v.suffix
			if not s then s = '' end
			if g and g.nom then
				s = b..s

				if not morph.yo then
					s = s:gsub("ё","е")
				end

				if words then
					if words.db[s] then
						hit = true
--						words.db[s] = false
					end
				else
					if not db[s] then
						db[s] = {}
					end
					stead.table.insert(db[s], { b, g, p, acc, acc[k], pgen })
				end
			end
		end
		if hit then
			p.used = true
			p.num = num
			stead.table.insert(para2, p)
			if not acc.used then
				acc.used = true
				stead.table.insert(accs2, acc)
				acc.num = #accs2 - 1
			end
			stead.table.insert(dict, base..' '..num.." "..acc.num..prist)
			num = num + 1
		end
	end
	if words and ofile then
		stead.busy(true)
		ofile:write(num,"\n")
		for k,v in ipairs(para2) do
			local kk,vv 
			local rc
			rc = ''
			for kk,vv in ipairs(v) do
				local a, b, c
				a = vv.prefix
				b = vv.code
				c = vv.suffix
				if not a then 
					a = '' 
				else
					a = ':'..a
				end
				if not c then 
					c = '' 
				else
					c = ':'..c
				end
				if rc ~= '' then
					rc = rc..' '
				end
				if not b then b = '-' end
				rc = rc .. b .. c.. a;
			end
			ofile:write(rc, "\n")
		end
		ofile:write(#accs2, "\n")
		for k,v in ipairs(accs2) do
			local kk,vv
			for kk,vv in ipairs(v) do
				ofile:write(vv)
				if kk ~= #v then
					ofile:write(" ")
				end
			end
			ofile:write("\n")
		end
		ofile:write(#pre, "\n")
		for k,v in ipairs(pre) do
			ofile:write(v, "\n")
		end
		for k,v in ipairs(dict) do
			ofile:write(v, "\n")
		end
	end
	file:close()
	if ofile then
		ofile:close()
	end
	return db
end
local function gr_match(a, b)
	if a.perfect ~= b.perfect then
		return
	end

	if a.archaism ~= b.archaism then
		
		return
	end

	if a.live ~= nil then
		if a.live and not b.live then
			return false
		end
		if not a.live and b.live then
			return false
		end
	end
	if a.male ~= nil and b.male ~= nil and a.male ~= b.male then
		return false
	end
	if a.female ~= nil and b.female ~= nil and a.female ~= b.female then
		return false
	end
	if a.neuter ~= nil and b.neuter ~= nil and a.neuter ~= b.neuter then
		return false
	end

	if a.singular ~= nil and b.singular ~= nil and a.singular ~= b.singular then
		return false
	end

	if a.plural ~= nil and b.plural ~= nil and a.plural ~= b.plural then
		return false
	end
	return true
end
local function match_grammar(p, acc, g, n, gr)
	local k,v
	local res = {}
	for k,v in ipairs(p) do
--		if v.grammar.weight > n then
--			break
--		end
		if v.grammar and v.grammar.weight == n then
			if (not gr or gr_match(v.grammar, gr)) and v.grammar.male == g.male and v.grammar.female == g.female and
			v.grammar.neuter == g.neuter and v.grammar.plural == g.plural 
			and v.grammar.singular == g.singular then
--			print(v.suffix, b)

				stead.table.insert(res, { v.suffix, acc[k] })
			end
		end
	end
	return res
end
local function do_morph(db, word, n, gr)
	if n == 1 or not db then
		return word
	end
	ww = word:gsub("[^ ~|\t-]+", function(w)
		if morph.words[w] then
			if morph.words[w][n] and gr_match(morph.words[w], gr) then
				return morph.words[w][n]
			end
			if n == 7 then n = 6 elseif n == 8 then n = 1 end
			if morph.words[w][n] and gr_match(morph.words[w], gr) then
				return morph.words[w][n]
			end
			return w
		end

		local s = db[w]
		local ww
		if not s then
			return w
		end
		local k, v
		for k, v in ipairs(s) do
			local g = morph.gtab[v[6]]; -- word grammar
			s = v
			if not gr or not g or gr_match(g, gr) then
				break
			end
		end
		local b = s[1]
		local g = s[2]
		local p = s[3]
		local acc = s[4]
		local acc_n = s[5]
		local post = ''
		ww = w
		local res
		res = match_grammar(p, acc, g, n, gr);
		if #res == 0 then
			if n == 7 then
				n = 6
			elseif n == 8 then
				n = 1
			end
			res = match_grammar(p, acc, g, n, gr);
			if #res == 0 then
				return w
			end
		end
--		stead.table.sort(res, function(a, b)
--			return math.abs(a[2] - acc_n) < math.abs(b[2] - acc_n)
--		end)

		post = res[1][1]
		if not post then
			post = ''
		end
		if not morph.yo then
			post = post:gsub("ё","е")
			b = b:gsub("ё","е")
		end
		ww = b
		return ww..post
	end)
	return ww
end


local function add_dict(fname, words)
	local file = io.open(fname, "r")
	if not file then
		return false
	end
	local line
	if not words.num then words.num = 0 end
	if not words.db then words.db = {} end
	for line in file:lines() do
		line:gsub("_['\"]([^'\"]+)['\"]", function(s)
			s:gsub(morph.word_pattern, function(s)
				if not morph.yo then
					s = s:gsub("ё","е")
				end
				s = tolow(s)
				if not words.db[s] then
					words.db[s] = true;
					words.num = words.num + 1
				end
			end)
		end)
	end
	file:close()
	return true
end

morph = {
	word_pattern = "[^ ~|\t,.?!:-]+";
	debug = false;
	yo = true;
	words = { };
	word = function(s, v)
		local n = tolow(v[1])
		s.words[n] = v;
	end;
	case2n = function(s, w)
		local pp = {
			['им'] = 1,
			['рд'] = 2,
			['дт'] = 3,
			['вн'] = 4,
			['тв'] = 5,
			['пр'] = 6,
			['пр2'] = 7,
			['зв'] = 8, 
		}
		if type(w) ~= 'string' then
			error("Wrong case: "..tostring(w), 3)
		end
		local n = pp[w]
		if not n then
			error("Wrong case: "..tostring(w), 3)
		end
		return n
	end;
	make_dict = function(s, ...)
		local a = { ... };
		local k,v
		local words = {}
		stead.busy(true)
		for k,v in ipairs(a) do
			add_dict(v, words)
		end
		stead.busy(true)
		print("Converting dict from: "..instead_steadpath()..'/morph.dict')
		local db = morph_load(instead_steadpath()..'/morph.dict', words, instead_gamepath() .. '/game.dict')
		if not db then
			print("Converting dict from: "..instead_gamepath()..'/morph.dict')
			db = morph_load(instead_gamepath()..'/morph.dict', words, instead_gamepath() .. '/game.dict')
		end
		stead.busy(false)
		return
	end;
	recompile = function(s)
		s:make_dict(stead.unpack(s.files))
		s.morph_db = morph_load(instead_gamepath() .. '/game.dict')
	end;
	init = function(s, ...)
		s.files = {...};
		s.morph_db = morph_load(instead_gamepath() .. '/game.dict')
		if not s.morph_db then -- try make own
			s:make_dict(...)
		end
		s.morph_db = morph_load(instead_gamepath() .. '/game.dict')
	end;
	gender = function(s, word, gr)
		local male
		local female
		local plural
		local neuter
		local singular
		local live
		local perfect
		local archaism
		local ww = word:gsub("[^ \t-]+", function(w)
			local ss = s.words[w]
			local ww, b, g
			local wg = {}
--			print("got", w)
			if not ss then
				ss = s.morph_db[w]
				if not ss then
					return
				end
				local k, v
				for k, v in ipairs(ss) do
					wg = morph.gtab[v[6]]; -- word grammar
					ss = v
					if not gr or not wg or gr_match(wg, gr) then
						break
					end
				end
				b = ss[1]
				g = ss[2]
			else
				g = ss
				s = ss
			end
			if not male then
				male = g.male or wg.male
			end
			if not female then
				female = g.female or wg.female
			end
			if not singualr then
				singular = g.singular or wg.singualr
			end
			if not plural then
				plural = g.plural or wg.plural
			end
			if not neuter then
				neuter = g.neuter or wg.neuter
			end
			if not live then
				live = g.live or wg.live
			end
			if not perfect then
				perfect = g.perfect or wg.perfect
			end
			if not archaism then
				archaism = g.archaism or wg.archaism
			end
		end)
		return { male = male, female = female, plural = plural, neuter = neuter, singular = singular, live = live, perfect = perfect, archaism = archaism };
	end;
	case = function(s, w, a, gr)
		local n = s:case2n(a)
		return do_morph(s.morph_db, w, n, gr)
	end
}
function _(s)
	return s
end
