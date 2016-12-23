-- $Name:Mansion$
-- $Name(ru):Особняк$
-- $Name(es):Palacio$
-- $Version:1.5$
-- $Author:Peter Kosyh$

instead_version '1.5.0'

if stead.version < "1.5.3" then
	walk = _G["goto"]
	walkin = goin
	walkout = goout
	walkback = goback
end

main = room {
	nam = '?';
	dsc = function(s)
		if LANG == 'ru' then
			p (txtc([[Выберите язык игры:]]));
		else
			p (txtc([[Select game language:]]));
		end
	end;
	obj = {
		obj {
			nam = 'ru'; dsc = txtc(img('ru.png')..' {Русский}')..'^'; act = code [[ gamefile('main.ru.lua', true) ]];
		};
		obj {
			nam = 'es'; dsc = txtc(img('es.png')..' {Español}'); act = code [[ gamefile('main.es.lua', true) ]];
		};
	}
}
