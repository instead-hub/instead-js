-- io.open proxy
local mock_handle = {}

io.open = function (filename, mode)
	mock_handle[filename] = {}
	mock_handle[filename].lines = {}
    mock_handle[filename].content = ''
	mock_handle[filename].mode = mode
    local i = 0
	return {
        name = filename,
        lines = function (_)
            instead_file_set_content(tostring(_.name), js.run_string('Lua.openFile("' .. tostring(_.name) .. '")'))
            local n = #mock_handle[_.name].lines
            return function ()
               i = i + 1
               if i < n then return mock_handle[_.name].lines[i] end
            end
        end,
		setvbuf = function (_, s)
			return
		end,
        write = function(_, ...)
            local a = { ... }
            for i,v in ipairs(a) do
                mock_handle[_.name].content = mock_handle[_.name].content .. tostring(v)
            end
        end,
        flush = INSTEAD_PLACEHOLDER,
        close = function(_)
            if (mock_handle[_.name].content ~= '') then
                js.run('Lua.saveFile("' .. _.name .. '")')
            end
        end
	}
end

os.remove = INSTEAD_PLACEHOLDER
os.rename = INSTEAD_PLACEHOLDER

instead_file_get_content = function(file)
    return mock_handle[file].content
end

instead_file_set_content = function(file, content)
    mock_handle[file] = {}
    mock_handle[file].content = ''
    if (content ~= '') then
        mock_handle[file].content = content
    end
    local t = {}
    local function helper(line) table.insert(t, line) return "" end
    helper((content:gsub("(.-)\r?\n", helper)))
    mock_handle[file].lines = t
end

-- loadfile proxy
loadfile = function(file)
    local content = js.run_string('Lua.loadFile("' .. file .. '")')
    if (content ~= '') then
        return assert(loadstring(content))
    end
end
