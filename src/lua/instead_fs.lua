-- io.open proxy
local files = {
}

io.open = function (filename, mode)
	local o = {
		mode = mode or "r",
		name = filename,
		new = function(s)
			if not s._lines and s.mode:find("r") then -- for read
				instead_file_set_content(
					s,
					js.run_string('Lua.openFile("' .. tostring(s.name) .. '")')
				)
			end
		end;
		lines = function (s)
			s:new()
			return function()
				return s:read('*line')
			end
		end,
		setvbuf = function ()
			return
		end,
		read = function(s, m) -- line by line
			s:new()
			if m == '*line' then
				local i = s.line_nr + 1
				s.line_nr = i;
				local n = #s._lines
				if i >= n then
					return
				end
				return s._lines[i]
			end
			return s.content
		end;
		write = function(s, ...)
			local a = { ... }
			for i, v in ipairs(a) do
				s.content = (s.content or '').. tostring(v)
			end
		end,
		flush = INSTEAD_PLACEHOLDER,
		close = function(s)
			if s.content ~= '' then
				js.run('Lua.saveFile("' .. s.name .. '")')
			end
		end
	}
	files[filename] = o
	return o
end

os.remove = INSTEAD_PLACEHOLDER
os.rename = INSTEAD_PLACEHOLDER

instead_file_get_content = function(file)
	return files[file] and files[file].content
end

instead_file_set_content = function(s, content)
	s.content = content
	local t = {}
	local function helper(line)
		table.insert(t, line)
		return ""
	end
	helper((content:gsub("(.-)\r?\n", helper)))
	s._lines = t
	s.line_nr = 0
end

-- loadfile proxy
loadfile = function(file)
	local content = js.run_string('Lua.loadFile("' .. file .. '")')
	if content ~= '' then
		return assert(loadstring(content))
	end
end

-- stead3
if std then
	std.loadfile = loadfile;
end

