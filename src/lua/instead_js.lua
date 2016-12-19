INSTEAD_PLACEHOLDER = function()
    return
end

table_get_maxn = function(tbl)
	local c=0
	for k in pairs(tbl) do
		if type(k)=='number' and (c == nil or k > c) then
			c=k
		end
	end
	return c
end

set_instead_gamepath = function(path)
  INSTEAD_GAMEPATH=path
end

instead_gamepath=function()
  return INSTEAD_GAMEPATH
end

instead_realpath=function()
  return nil
end

function url_decode(str)
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)",
      function(h) return string.char(tonumber(h,16)) end)
  return str
end

function url_encode(str)
  if (str) then
    str = string.gsub (str, "([^%w %-%_%.%~])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str	
end

-- sprites are not supported (yet?)
instead_font_load = INSTEAD_PLACEHOLDER
instead_font_free = INSTEAD_PLACEHOLDER
instead_font_scaled_size = INSTEAD_PLACEHOLDER
instead_sprite_alpha = INSTEAD_PLACEHOLDER
instead_sprite_dup = INSTEAD_PLACEHOLDER
instead_sprite_scale = INSTEAD_PLACEHOLDER
instead_sprite_rotate = INSTEAD_PLACEHOLDER
instead_sprite_text = INSTEAD_PLACEHOLDER
instead_sprite_text_size = INSTEAD_PLACEHOLDER
instead_sprite_draw = INSTEAD_PLACEHOLDER
instead_sprite_copy = INSTEAD_PLACEHOLDER
instead_sprite_compose = INSTEAD_PLACEHOLDER
instead_sprite_fill = INSTEAD_PLACEHOLDER
instead_sprite_pixel = INSTEAD_PLACEHOLDER
instead_sprite_load = INSTEAD_PLACEHOLDER
instead_sprite_free = INSTEAD_PLACEHOLDER
instead_sprite_size = INSTEAD_PLACEHOLDER
instead_sprites_free = INSTEAD_PLACEHOLDER
instead_sprite_colorkey = INSTEAD_PLACEHOLDER

-- initialization
require "stead"
require "gui"

stead.init(stead)

stead.io.open = function(filename, mode)
    return {
        name = filename,
        content = '',
        write = function(self, ...)
            local a = { ... }
            for i,v in ipairs(a) do
                self.content = self.content .. tostring(v);
            end
        end,
        flush = INSTEAD_PLACEHOLDER,
        close = function(self)
            js.run('Lua.saveFile("' .. self.name .. '", "' .. url_encode(self.content) ..'")')
        end
    }
end

instead_loadgame = function(content)
    file_content = url_decode(content)
    do
        -- redefine loadfile to return custom content
        loadfile = function()
            return assert(loadstring(file_content));
        end
        iface.cmd(iface, 'load INSTEAD_SAVED_GAME')
    end
end
