mlook = obj_menu ('ОСМОТРЕТЬ', 'exam', true);
minv  = obj_menu ('С СОБОЙ', 'exam', false, true);
mtake = obj_menu ('ВЗЯТЬ', 'take', true);
mdrop = obj_menu ('БРОСИТЬ', 'drop', false, true);
muse  = use_menu ('ИСПОЛЬЗОВАТЬ', 'use', 'used', 'useit', true, true);
mtalk = obj_menu ('ГОВОРИТЬ', 'talk', true);
mgive = use_menu ('ОТДАТЬ', 'give', 'accept', false, true, true, true);
mwait = act_menu ('ЖДАТЬ', 'wait', false);
mwalk = obj_menu ('ИДТИ', 'walk', false, false, true);
mrest = act_menu ('ОТДЫХАТЬ', 'rest', false);


game.take = function (s, w)
    if w.weight and (w.weight > 100) then
        p 'Слишком тяжело!';
    else
        p 'Это нельзя взять.';
    end
end


game.after_take = function (s, w)
    take (w);
end


game.after_drop = function (s, w)
    drop (w);
end


game.before_give = function(s, w, ww)
    if not have (w) then
        p 'У меня этого нет.';
        return false;
    end
end


game.rest = function (s, w)
    clock_next ();
    if here().rest then
        return call(here(), 'rest');
    end
end


game.useit = 'Не получается...';
game.use = 'Не получается использовать это...';
game.give = 'Не получается отдать это...';
game.talk = 'Нет ответа...';
game.wait = 'Прошло немного времени...';


function actions_init()
    put ( mrest, me() );
    put ( mlook, me() );
    put ( minv, me() );
    put ( mtake, me() );
    put ( mdrop, me() );
    put ( muse, me() );
    put ( mtalk, me() );
    put ( mgive, me() );
--    put ( mwait, me() );
--    put (mwalk, me());
end
