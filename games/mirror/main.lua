-- $Name:Mirror$
-- $Name(ru):Зеркало$
-- $Version:0.9$
instead_version '1.6.0'

main = room {
    nam = 'Mirror';
    pic = 'images/title_small.png',
    dsc = function(s)
        if LANG == 'ru' then
            p [[Выберите язык игры:]];
        else
            p [[Select game language:]];
        end
    end;
    obj = {
        obj {
            nam = 'en'; dsc = '> {English} (3 parts from 4)^'; act = code [[ gamefile('main_eng.lua', true) ]];
        };
        obj {
            nam = 'ru'; dsc = '> {Русский}'; act = code [[ gamefile('main_rus.lua', true) ]];
        };
    }
}
