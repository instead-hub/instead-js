N = 0;
E = 1;
S = 2;
W = 3;

function direction(n)
    return function ()
        return compass:select(n);
    end
end

n = menu
{
    nam = true,
    inv = direction(N),
};

s = menu
{
    nam = true,
    inv = direction(S),
};

e = menu
{
    nam = true,
    inv = direction(E),
};

w = menu
{
    nam = true,
    inv = direction(W),
};

compass = stat
{
    nam = function ()
    	local dirs = 
        {
    		n = 'north',
    		s = 'south',
    		e = 'east',
    		w = 'west',
    	};
    	local get_dir = function (s)
    		local nm = 'images/compass_'..s;
    		local o = here()[dirs[s]]
    		if not o then nm = nm..'_dark' end
    		nm = img(nm..'.png');
    		if o then
    			nm = xref(nm, ref(s));
    		end
    		return nm
    	end
        return txtc(img('images/compass_nw.png')..
        		get_dir 'n'..
        		img('images/compass_ne.png')..'^'..
        		get_dir 'w'..
        		img('images/compass_c.png')..
        		get_dir 'e'..'^'..
      			img('images/compass_sw.png')..
      			get_dir 's'..
      			img('images/compass_se.png'));
    end,
    select = function (s, n)
        if (n == N) then
           status._way = 'N';
           walk (here().north);
           return;
        end
        if (n == E) then
           status._way = 'E';
           walk (here().east);
           return;
        end
        if (n == S) then
           status._way = 'S';
           walk (here().south);
           return;
        end
        if (n == W) then
           status._way = 'W';
           walk (here().west);
           return;
        end
        return 'Направление:'..n;
    end
}

--inv():add('compass');
--inv():add('n')
--inv():add('s')
--inv():add('e')
--inv():add('w')

