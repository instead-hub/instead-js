-- $Name:Созвездие: Чёрная Дыра$
-- $Version:1.04$
-- $Name(ru):Созвездие: Чёрная Дыра$	-- Название игры на русском
instead_version "1.8.0"

require "xact"			-- подключаем модуль xact
require "hideinv"		-- подключаем модуль hideinv
require "para"			-- догадайтесь, что мы подключили в этот раз ;)
require "dash"			-- подключаем dash
require "quotes"		-- подключаем quotes 
require "theme"

dofile "dialogues.lua"
dofile "objects.lua"

game.codepage="UTF-8";

game.act = 'Не получается.';
game.inv = 'Гм.. Странная штука..';
game.use = 'Не сработает...';

stead.phrase_prefix = '-- ';

global {
global_var_dzuba = 1;
global_var_dzuba_ill = 0;
global_var_med = 0;
global_var_time = 40.21;
global_var_light = 0;
global_var_pass = 0;
global_var_coord = 0;
global_var_mech = 0;
global_var_coffee = 0;
ship = 0;
logb = 0;
ext = 0;
achiv = 0;
achiv_spirt = 0;
achiv_hear = 0;
achiv_hack = 0;
achiv_persist = 0;
};

------------------------------------------------------------------------------------------------------------------

main = room {
	forcedsc = true;
	nam = "На мостике";
	pic = 'gfx/c0.gif';
	enter = function()
		set_music('bgm/Hold_Me.ogg');
	end,
	dsc = '{constellation|"Созвездие"} сотрясалось, аварийная сирена заглушалась только свистом уходящего в космос воздуха и скрипом опускаемых переборок. Пульт мигал сотнями красных сигналов. {xwalk(cap_dlg)|Капитан Киркунов}, как обычно невозмутимый, сидел в своем капитанском кресле. Старший помощник {morze|Морзе} находился немного ниже у своего пульта.';
	obj = {xact('constellation', '"Созвездие" - это один из самых современных кораблей флота Федерации, проекта 94, бортовой номер К-117. Построен в 2224 при сотрудничестве "КосмоВАЗа", "Южмаша" и "Челябинского Тракторного".'); xact('morze', 'Морзе - это старший помощник и правая рука капитана Киркунова.');};
};

bridge = room {
	forcedsc = true;
	nam = "Мостик";
	pic = 'gfx/c0.gif';
	enter = function()
		if ext == 1 then p 'Морзе скользнул на свое место.'; end;
	end;
	dsc = function()
		if ext == 1 then p 'На мостике все в сборе. {xwalk(cap_dlg3)|Капитан Киркунов}, как обычно невозмутимый, сидел в своем капитанском кресле. Старший помощник {morze|Морзе} находился немного ниже у своего пульта.';
		elseif global_var_coord == 2 then p 'На мостике остался дежурить только автопилот, невысокий цилиндрический дроид. Увидев старпома, он приветственно просигналил.';
		elseif global_var_coffee == 1 then p '{pult|Пульт} мигал красными сигналами. {xwalk(cap_dlg2)|Капитан Киркунов}, как обычно невозмутимый, сидел в своем капитанском кресле, прихлебывая кофе из своей любимой кружки с рисунком в виде красного сердечка.';
		else p '{pult|Пульт} мигал красными сигналами. {xwalk(cap_dlg2)|Капитан Киркунов}, как обычно невозмутимый, сидел в своем капитанском кресле. Старший помощник {morze|Морзе} находился немного ниже у своего пульта.';
		end;
	end;
	obj = {xact('constellation', '"Созвездие" - это один из лучших кораблей флота Федерации, проекта 94, бортовой номер К-117. Построен в 2224 при сотрудничестве "КосмоВАЗа", "Южмаша" и "Челябинского Тракторного".'); xact('morze', 'Морзе - это старший помощник и правая рука капитана Киркунова.'); 'pult';};
	way = {'first_deck'};
};

first_deck = room {
	forcedsc = true;
	pic = 'gfx/c1.png';
	nam = 'Первая палуба';
	dsc = 'Морзе вышел на первую палубу "Созвездия". На этой палубе расположены каюты офицеров.';
	way = {'bridge', 'cap_cabin', 'morze_cabin', 'nav_cabin', 'lift'};
	exit = function(s, t)
		if ext == 1 and t ~= bridge then p 'Капитан ждет меня на мостике!'; return false; end;
	end;
};

lift = room {
	forcedsc = true;
	nam = "Лифт";
	pic = 'gfx/c1.png';
	entered = function()
		if from() == first_deck then here().pic = 'gfx/c1.png';
		elseif from() == second_deck then here().pic = 'gfx/c2.png';
		elseif from() == third_deck then here().pic = 'gfx/c3.png';
		end;
	end;
	dsc = 'Морзе вошел в кабину лифта.';
	way = {'first_deck', 'second_deck', 'third_deck'};
};

cap_cabin = room {
	forcedsc = true;
	nam = "Каюта капитана";
	pic = 'gfx/c6.png';
	dsc = 'В каюте капитана пахло кожей и табаком. На настенных полках стояла {books|коллекция бумажных книг} капитана. Весьма, кстати, недешевое увлечение. Дубовый стол с вмонтированным терминалом и кожаное кресло дополняли картину.';
	obj = {xact('books', 'Старпом взял наугад какую-то книгу и прочел название - "Инви Непобедимый". Кажется что-то знакомое. И поставил обратно на полку.')};
	way = {'first_deck'};
};

morze_cabin = room {
	forcedsc = true;
	nam = "Каюта старпома";
	pic = 'gfx/c7.png';
	dsc = 'Морзе вошел в свою каюту. Знакомая стандартная обстановка. Стойка головизора в центре помещения, перед ней удобное, но тоже стандартное кресло. Разве что {piano|пианино} выделялось из общей картины образцовой каюты космофлота.';
	obj = {'screwdriver'; xact('piano','Старпом открыл крышку и провел рукой по клавишам. Играть он так и не научился. Да и пианино попало в его каюту абсолютно случайно и по ошибке.')};
	way = {'first_deck'};
};

nav_cabin = room {
	forcedsc = true;
	nam = "Каюта навигатора";
	pic = 'gfx/c1.png';
	enter = 'Морзе подошел к каюте навигатора и вспомнил, что навигатор в криокамере. Так как необходимость в его присутствии на мостике пропала после внедрения новой программы навигации. И с разрешения капитана, навигатор впал в спячку.';
	way = {'first_deck'};
};

second_deck = room {
	forcedsc = true;
	nam = "Вторая палуба";
	pic = 'gfx/c2.png';
	dsc = 'Морзе вышел на вторую палубу. Робоуборщик с жужжанием старательно начищал пол недалеко от старпома.';
	way = {'lift', 'orang', 'observ', 'caboose', 'medbay'};
};

orang = room {
	forcedsc = true;
	nam = "Оранжерея";
	pic = 'gfx/c2.png';
	dsc = 'Старпом заглянул в оранжерею и вдохнул запах фруктов и овощей. Говорят, что гидропоник где-то тут выращивает каннабис, но найти заветную делянку никто так и не сумел.';
	way = {'second_deck'};
};

observ = room {
	nam = "Обсерватория";
	pic = 'gfx/c8.png';
	forcedsc = true;
	enter = function()
		if global_var_med == 1 then
		p '^^Морзе и доктор Ибанез вошли в обсерваторию. Дзюба продолжал напевно декламировать всякий бред. Доктор положил свой медицинский чемоданчик на стол и открыв его, вынул из него инъектор. После чего сделал быстрый шаг к космологу и прижав ему инъектор к шее, нажал на спуск. Космолог замолчал и мягко осел.^-- Помогите же, - бросил медик, поддерживая Дзюбу. Морзе помог дотащить космолога до койки, в которой его и оставили спать.';
		walk('doctor_dlg2');
		end;
	end;
	dsc = function()
		if global_var_med == 0 then p 'Старпом вошел в обсерваторию. {xwalk(dzuba_dlg)|Борткосмолог Дзюба} мерно расхаживает по помещению и что-то декламирует.';
		else p 'Космолог мирно спит в койке. Доктор уже ушел обратно в медотсек. В углу установлен {xwalk(terminal_dlg)|терминал обсерватории}.';
		end;
	end;
	obj = {};
	way = {'second_deck'};
};

caboose = room {
	forcedsc = true;
	nam = 'Камбуз';
	pic = 'gfx/c9.png';
	dsc = 'Морзе вошел в камбуз. Вкусный запах гречки заполняет помещение. {xwalk(cook_dlg)|Робокок} как ни в чем, ни бывало готовит обед для экипажа. Впрочем в чем-то он прав. Черная дыра или не черная, а экипаж кормить надо по расписанию.^На плите стоят {pan|кастрюльки} разных калибров.';
	obj = {'pan'};
	way = {'second_deck'};
};

medbay = room {
	forcedsc = true;
	nam = 'Медотсек';
	pic = 'gfx/c10.png';
	dsc = 'Морзе вошел в медотсек. {xwalk(doctor_dlg)|Доктор Ибанез} что-то читал на терминале, но услышав шаги старпома обернулся и вопросительно взглянул.';
	way = {'second_deck'};
};

third_deck = room {
	forcedsc = true;
	nam = 'Третья палуба';
	pic = function()
		if global_var_light == 0 then here().pic = 'gfx/c3.gif';
		else here().pic = 'gfx/c3.png';
		end;
	end;
	dsc = 'Морзе вышел на третью палубу. Здесь находятся всякие технические отсеки и кубрики космодесанта.';
	obj = {'light_panel'};
	way = {'lift', 'second_hangar', 'dvig', 'orlop_dlg', 'tech'};
};

second_hangar = room {
	forcedsc = true;
	nam = 'Второй ангар';
	pic = 'gfx/c11.png';
	dsc = 'В ангаре стоит {xwalk(bolo_dlg)|Боло}. Многотонный танк с продвинутым искусственным интеллектом. Найденный капитаном на одной пустынной планете артефакт древней цивилизации и самое разрушительное оружие на борту "Созвездия".';
	way = {'third_deck'};
};

tech = room {
	forcedsc = true;
	nam = 'Тех.отдел';
	pic = 'gfx/c3.png';
	dsc = 'Морзе подошел к двери технического отдела, но оказалось что дверь заперта. На стене рядом с дверью расположен {terminal_tech|экран терминала}.';
	obj = {'terminal_tech'};
	way = {'third_deck'};
};

dvig = room {
	forcedsc = true;
	nam = 'Двигательный отсек';
	pic = 'gfx/c12.png';
	dsc = 'В двигательном отсеке пахнет смазкой и озоном. У широкого терминала работает {xwalk(mech_dlg)|главный механик}. Низкочастотное гудение от работающих механизмов наполняет отсек.';
	way = {'third_deck'};
};

lock = room {
	forcedsc = true;
	nam = 'Шлюз';
	pic = 'gfx/c1.png';
	enter = function()
		set_music('bgm/Hold_Me.ogg');
		if ext == 1 then
			p 'Морзе и последние из десантков ввалились в шлюз. Капитан скомандовал в коммуникатор: -- Автопилот, стартуем! Морзе, двигаем на мостик!';
			ways():del('outside');
		end;
	end;
	dsc = 'В шлюзе тихо и стерильно. Выход наружу разблокирован.';
	obj = {'locker'};
	way = {'first_deck', 'outside'};
	exit = function(s, t)
		if t == outside and not have 'scaf' then
			p 'Не стоит вылезать наружу без скафандра и оружия.';
			return false;
		end;
	end;
};

outside = room {
	forcedsc = true;
	nam = 'Космодром';
	pic = 'gfx/c4.png';
	enter = function()
		set_music('bgm/wind.ogg');
		if ship == 0 then p 'Капитан и десантники уже вышли наружу.^-- Вперед Морзе. Я организую оборону, а вы исследуйте те корабли, может найдете что-то полезное. Возьмите с собой десяток космодесантников. Будьте осторожны и не выключайте коммуникатор.';
		take 'comm';
		end;
	end;
	dsc = 'Только ветер гоняет песок по старому бетону.';
	obj = {'cap_on_field', 'ships'};
	way = {'lock'};
};

enterprise = room {
	forcedsc = true;
	nam = 'Шлюз "Предприимчивого"';
	pic = 'gfx/c5.png';
	enter = function()
		if visits() == 0 then p 'В шлюзе старпома догнал механик Петров.^-- Морзе, а вот и вы. Так мальчики направо, девочки налево, ха-ха! Ну же, не обижайтесь.';
		end;
	end;
	dsc = 'Шлюз наружу открыт. Направо и вглубь ведет неосвещенный коридор к {ent_mech|машинному отделению}.';
	obj = {'bulkhead', xact('ent_mech', 'Туда ушел механик, а мне надо попасть на мостик и забрать бортжурнал.')};
	way = {'outside'};
};

ent_post = room {
	forcedsc = true;
	nam = 'Мостик "Предприимчивого"';
	pic = 'gfx/c5.png';
	dsc = 'На мостике все покрыто пылью. Видимо тут очень давно никого не было.';
	obj = {'logbook'};
	way = {'enterprise'};
};

end2 = room {
	forcedsc = true;
	hideinv = true;
	nam = 'Конец';
	pic = 'gfx/c0.gif';
	dsc = function()
		p('Авторы персонажей капитана Киркунова и старшего помощника Морзе - @ap-Codkelden и @zweipluse. За Дзюбу и его речи ответственен @chegeware. Отдельная благодарность Vtroll и Петру gl00my Косых за пачку замечаний и найденных опечаток. Спасибо всем из конференции instead@conference.jabber.ru за моральную поддержку.^^Полученные достижения:^');
		if achiv_persist == 1 then p(img 'gfx/click.png', ' - Упорный.^'); achiv = achiv + 1; end;
		if global_var_light == 1 then p(img 'gfx/repair.png', ' - Ремонтник.^'); achiv = achiv + 1; end;
		if global_var_coffee == 1 then p(img 'gfx/coffee.png', ' - Кофе капитану!^'); achiv = achiv + 1; end;
		if achiv_hear == 1 then p(img 'gfx/ear.png', ' - Подслушивающий.^'); achiv = achiv + 1; end;
		if achiv_spirt == 1 then p(img 'gfx/bottle.png', ' - Собутыльник.^'); achiv = achiv + 1; end;
		if achiv_hack == 1 then p(img 'gfx/hack.png', ' - Хакер.^'); achiv = achiv + 1; end;
		p('Всего достижений получено ', achiv, ' из 6 доступных.^');
		p('^Контакты: arsche@jabber.ru, yatopor@gmail.com^^^Не прощаюсь, будет еще. Если не в виде игры, то в виде рассказов например.^Читайте http://ifhub.ru/tag/созвездие/^^ Удачи.');
	end;
};
