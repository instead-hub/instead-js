me()._boatle_empty = false; --пустая бутылка
me()._drunken = false; --пьяный
me()._full = false; --сытый

function music(v, n)
	return function()
		set_music(v, n)
	end
end;

main = room {
	--enter = music('mus/trade.ogg'),
	nam = 'Продуктовый магазин',
	dsc = [[Я стою в продуктовом магазине. Передо мной очередь, которая желает приобрести дешёвый алкоголь. Идут множественные споры, просьбы продать в кредит...^^
	Очередь доходит до меня. Я считаю деньги. С трудом собираю нужную сумму... Хватает!]],
	obj = { vway('Продолжить','{Продолжить}','kitchen') },
	pic = 'img/main.png',
};
--music('mus/trade.ogg');
set_music("mus/trade.ogg");

--нож
knife = obj {
	nam = img('img/knife.png')..'нож',
	dsc = [[{нож}, ]],
	tak = 'Я взял нож.',
	inv = 'Кухонный нож.',
};

--бутылка 777
boatle = obj {
	nam = img('img/boatle.png')..'бутылка',
	dsc = [[{бутылка} портвейна "777", ]],
	tak = 'Я взял бутылку портвейна в руки.',
	inv = function()
		if me()._boatle_empty then
			return [[Открытая бутылка портвейна "777".]];
		else
			return [[Бутылка портвейна "777".]];
		end
	end,
	act = function()
		if me()._drunken then
			return 'Пустая бутылка из-под портвейна...';
		end
	end,
	use = function(s, w)
		if w == 'pile' then
			me()._boatle_empty = true;
			return [[Я налил в рюмку портвейн.]];
		end
	end,
};

--рюмка
pile = obj {
	nam = 'рюмка',
	dsc = [[{рюмка}, ]],
	act = function()
		if me()._drunken then
			return [[Пустая рюмка. Всё выпито...]];
		elseif me()._boatle_empty then
			me()._drunken = true;
			remove('boatle', me());
			k_table.obj:add('boatle', 1);
			boatle.tak = nil;
			return [[Я выпиваю рюмку портвейна... Затем ещё, ещё... И так всю бутылку. Ой, надо бы закусить.]];
		else
			return [[Пустая рюмка.]];
		end
	end,
};

--миска
dish = obj {
	nam = 'миска',
	dsc = function()
		if me()._full then
			return 'пустая {миска}.';
		else
			return '{миска} с пельменями.';
		end
	end,
	act = function()
		if me()._full then
			return 'Миска пуста. Я съел все пельмени.';
		elseif me()._drunken then
			me()._full = true;
			return 'Я съедаю все пельмени. Теперь можно и поспать.';
		else
			return 'Миска с пельменями. Немного остыли. Пока есть неохота.';
		end
	end,
};

--cтол
k_table = obj {
	nam = 'стол',
	dsc = [[У стены стоит деревянный старый {стол}. На нём находятся: ]],
	obj = {'knife', 'boatle', 'pile', 'dish'},
	act = 'Это мой стол, который достался по наследству. Он даже без скатерти.',
};

--Кухня
kitchen = room {
	enter = music('mus/main.ogg'),
	nam = 'Кухня',
	dsc = [[Я сижу в кухне...]],
	obj = {'k_table'},
	way = {'k_exit'},
	exit = function()
		if not me()._full or not have('knife') then
			return 'Ещё рано. Хочу ещё посидеть.', false;
		end
	end,
	pic = function()
		p 'img/kitchen.png';
		if not me()._full then
			p ';img/kitchen_dish.png@236,154';
		end
		if seen ('knife') then
			p ';img/kitchen_knife.png@25,193';
		end
		if seen('boatle') and me()._boatle_empty then
			p ';img/kitchen_boatle_null.png@128,119';
		end
		if seen('boatle') and not me()._drunken then
			p ';img/kitchen_boatle.png@128,119';
		end
	end
};

--Выход
k_exit = room {
	nam = 'Выход',
	enter = function()
		return walk('bedroom');
	end,
};

--кровать
bed = obj {
	nam = 'кровать',
	dsc = 'Всё, что я сейчас вижу — это только {кровать}.',
	act = function()
		return walk('dream');
	end,
};

--Спальня
bedroom = room {
	nam = 'Спальня',
	dsc = 'Я сразу пошёл в спальню, потому как мне хочется спать.',
	obj = {'bed'},
	pic = 'img/bedroom.png',
};

--Сон
dream = room {
	nam = 'Сон',
	enter = function()
		return walk('screen');
	end,
};
