STANDALONE = true
local INSTEAD_THEME_NAME = ''

INSTEAD_PLACEHOLDER = function()
    return
end

INSTEAD_EMPTYSTR = function()
  return ''
end

-- call JS function with given parameters
insteadjs_call = function(jsfn, arg)
    local arguments = ''
    for i,v in ipairs(arg) do
        arguments = arguments .. '"' .. tostring(v) .. '",'
    end
    arguments = arguments:sub(1, -2)
    js.run(jsfn .. '(' .. arguments .. ')')
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

local INSTEAD_GAMEPATH = ''

js_instead_gamepath = function(path)
  INSTEAD_GAMEPATH=path
end

instead_gamepath=function()
  return INSTEAD_GAMEPATH
end

instead_realpath = INSTEAD_EMPTYSTR
instead_savepath = INSTEAD_EMPTYSTR
instead_exepath = INSTEAD_EMPTYSTR

-- theme
function instead_theme_var(name, value)
    -- TODO: get theme variable from JS
    if (value) then
        js.run('insteadTheme("' .. tostring(name) .. '","' .. tostring(value) .. '")')
    end
end

function js_instead_theme_name(theme)
  INSTEAD_THEME_NAME=theme
end

function instead_theme_name()
    return INSTEAD_THEME_NAME
end

-- timer
instead_timer = function(t)
    js.run('instead_settimer("' .. tostring(t) .. '")')
end

-- sound
instead_sound = INSTEAD_PLACEHOLDER
instead_sound_load = INSTEAD_PLACEHOLDER
instead_sound_free = INSTEAD_PLACEHOLDER
instead_sounds_free = INSTEAD_PLACEHOLDER
instead_sound_channel = INSTEAD_PLACEHOLDER
instead_sound_volume = INSTEAD_PLACEHOLDER
instead_sound_panning = INSTEAD_PLACEHOLDER
instead_sound_load_mem = INSTEAD_PLACEHOLDER -- stead 3
instead_music_callback = INSTEAD_PLACEHOLDER -- stead 3

-- sprites are not supported (yet?)
sprite_descriptors = {}
font_descriptors = {}

instead_font_load = function(filename, size)
    js.run('Sprite.font("' .. tostring(filename) .. '","' .. tostring(size) .. '")')
    return font_descriptors[filename .. size]
end
js_instead_font_load = function(font, id)
    font_descriptors[font] = id
end
instead_font_free = function()
    -- fonts are not taking much memory, no need to 'free' them
    return
end
instead_font_scaled_size = function(size)
    -- TODO: return size as-is
    return size
end
instead_sprite_alpha = function()
    print('NOT IMPLEMENTED: sprite.sprite_alpha')
end
instead_sprite_dup = function()
    print('NOT IMPLEMENTED: sprite.dup')
end
instead_sprite_scale = function()
    print('NOT IMPLEMENTED: sprite.scale')
end
instead_sprite_rotate = function()
    print('NOT IMPLEMENTED: sprite.rotate')
end
instead_sprite_text = function(font, text, col, style)
    local arguments = ''
    arguments = arguments .. '"' .. tostring(font) .. '",'
    arguments = arguments .. '"' .. tostring(text) .. '",'
    arguments = arguments .. '"' .. tostring(col) .. '",'
    arguments = arguments .. '"' .. tostring(style) .. '"'
    js.run('Sprite.text(' .. arguments .. ')')
    return sprite_descriptors[font]
end
js_instead_sprite_text = function(font, id)
    sprite_descriptors[font] = id
end
instead_sprite_text_size = function()
    print('NOT IMPLEMENTED: sprite.text_size')
end
instead_sprite_draw = function(...)
    insteadjs_call('Sprite.draw', {...})
end
instead_sprite_copy = function(...)
    insteadjs_call('Sprite.copy', {...})
end
instead_sprite_compose = function(...)
    insteadjs_call('Sprite.compose', {...})
end
instead_sprite_fill = function(...)
    insteadjs_call('Sprite.fill', {...})
end
instead_sprite_pixel = function(...)
    insteadjs_call('Sprite.pixel', {...})
end
instead_sprite_load = function(filename)
    js.run('Sprite.load("' .. tostring(filename) .. '")')
    return sprite_descriptors[filename]
end
js_instead_sprite_load = function(filename, id)
    sprite_descriptors[filename] = id
end
instead_sprite_free = function(descriptor)
    js.run('Sprite.free("' .. tostring(descriptor) .. '")')
end
instead_sprite_size = function()
    print('NOT IMPLEMENTED: sprite.size')
end
instead_sprites_free = INSTEAD_PLACEHOLDER
instead_sprite_colorkey = INSTEAD_PLACEHOLDER
instead_ticks = function()
    return js.run_string('Date.now()')
end
instead_mouse_pos = INSTEAD_PLACEHOLDER
instead_mouse_show = INSTEAD_PLACEHOLDER
instead_finger_pos = INSTEAD_PLACEHOLDER
function instead_mouse_filter(...)
  insteadjs_call('console.log', {...})
end
instead_busy = INSTEAD_PLACEHOLDER

-- click
instead_click = function(x,y)
    local cmd = iface:input('mouse', true, 1, x, y, x, y)
    if (cmd) then
       return iface:cmd(cmd)
    end
end
