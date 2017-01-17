-- $Name: Краски сентября$
-- $Version: 1.4$

instead_version "1.9.0"
require "hideinv"

require "quotes"
require "dash"
-- require "para"

require "parser/metaparser"

input.cursor = img 'theme/cursor.gif'

global { picture = 'gfx/skam.png' };


-- morph.debug = true
parser.cmd_history = true
parser.empty_warning = '?'
parser.notitle = true
parser.hintinv = true
parser.hideverbs = true

parser.inv_delim = img 'pad:2 4 0 4,box:1x14,#cccccc'
morph.yo = false
morph:init ('main.lua', 'game.lua')
me().person = 1

parser.err_filter = false
-- parser.scroll = false
game.pic = function(s)
	return picture 
end

parser.events.after_Any = function(s)
	if player_moved() and not here().nocls then
		if not restore_mode then
			parser:cls()
		end
	end
	restore_mode = false
end
game.fading = function()
	if player_moved() and not here().nocls then
		return 6
	end
end

me().Exam = function(s)
	if here() == park1 then
		return [[Кажется, со мной все в порядке.]]
	end
	if hole._in then
		if ranen then
			return [[Похоже, я ранен.]]
		end
		return [[Меня беспокоит острая боль в боку.]]
	end
	p [[Мне не хочется заниматься самоанализом.]];
end
dofile 'game.lua'

help = cutscene {
	hideverbs = false;
	nam = 'Помощь';
	dsc = { [[Добро пожаловать! Вы играете в текстовую игру, в которой все взаимодействия 
		с окружающим миром осуществляются путем ввода команд. Такие игры также 
		известны как парсерные. Во время ввода текста игра будет подсказывать вам 
		что именно вы можете ввести, а если в нижней части экрана появляется знак 
		вопроса, то это означает, что игра не понимает введенную вами команду.^^
		Чтобы читать дальше, наберите на клавиатуре "дальше" и нажмите ввод.]],

		[[Например, если вы введете букву "о", то можете увидеть список всех действий, 
		которые начинаются на "о". Вам необязательно набирать все слово целиком -- 
		нажмите "TAB" или "пробел", и игра автоматически подставит подходящий вариант 
		в строку ввода. После этого вы увидите все объекты, над которым можно совершить 
		выбранное действие.^^Сейчас нажмите на клавишу "д" и затем -- "пробел".]],

		[[Чаще всего вы будете использовать команду "осмотреть" -- при этом вы получите описание
		ситуации. Также этой командой вы можете осматривать интересующие вас объекты и 
		персонажей.^^Удачного прохождения!]];
	};
	walk_to = 'main';
}
main = room {
	hideverbs = false;
	nam = 'Краски сентября';
	dsc = function(s)
		pn (txtb[[Версия: ]], "1.4")
		pn (txtb[[История, код, рисунки: ]], [[Петр Косых]])
		pn (txtb[[Тестирование: ]], [[Андрей Лобанов, im-kerber]])
		pn (txtb[[Звук: ]], [[freesound.org]])
		pn (txtb[[Музыка: ]], [[excelenter, Numrah, www.jamendo.com]])
		pn (txtb[[Движок: ]], [[http://instead.syscall.ru]])
		pn ()
		pn (txtr [[Москва, 2015 г.]])
	end;
	Help = function(s)
		walk 'help'
	end;
	Next = function(s)
		walk 'intro'
	end;
	verbs = {
		{ "Help", "как играть" },
		{ "Next", "начать" },
	};
}

intro = cutscene {
	hideverbs = false;
	nam = 'Пролог';
	entered = function(s)
		set_music 'snd/1.ogg'
	end;
	dsc = [[В то утро я как обычно был в своей мастерской.
		Капли дождя оставляли на стекле небольшого чердачного окна
		длинные следы. Я сидел на стуле и смотрел на картину, которую
		собирался закончить вот уже несколько дней...^^
		Осень на картине, осень в моей душе...]];
	walk_to = 'mast';
	left = function(s)
		picture = 'gfx/mast.png'
	end;
}

function init()
	if PLATFORM == 'ANDROID' or PLATFORM == 'IOS' or PLATFORM == 'S60'
		or PLATFORM == 'WINCE' then
		parser.hideverbs = false
	end
end

parser.verb._Service()

dofile 'titles.lua'
-- vim:tabstop=4
-- vim:shiftwidth=4