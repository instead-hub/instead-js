-- $Name:Returning the Quantum Cat$
-- $Name(ru):Возвращение квантового кота$
-- $Version: 1.6$

if stead.version < "1.5.3" then
	walk = _G["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

require "xact"

gam_lang = {
	ru = 'Язык',
	en = 'Language',
}

gam_title = {
	ru = 'Возвращение квантового кота',
	en = 'Returning the Quantum Cat',
}

if not LANG or not gam_lang[LANG] then
	LANG = "en"
end

gam_lang = gam_lang[LANG]
gam_title = gam_title[LANG]

main = room {
	nam = gam_title;
	forcedsc = true;
	dsc = txtc (
		txtb(gam_lang)..'^^'..
		img('gb.png')..' '..[[{en:English}^]]..
		img('ru.png')..' '..[[{ru:Русский}^]]);
	obj = {
		xact("ru", code [[ gamefile('main-ru.lua', true); return walk 'main' ]]);
		xact("en", code [[ gamefile('main-en.lua', true); return walk 'main' ]]);
	}
}
