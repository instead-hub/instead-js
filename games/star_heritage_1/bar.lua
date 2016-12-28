bar = function (val)
    local i
    local n = 24
    local v = ''
    for i = 1, val do
       if i <= 8 then
           v=v..img('images/bar_red.png');
       elseif i <= 16 then
           v=v..img('images/bar_yellow.png');
       else
           v=v..img('images/bar_green.png');
       end
    end
    return v;
end
