local requires = {}

function require(fn)
	if requires[fn] then return requires[fn] end
	local code = js.run_string('Lua.requireContent("' .. tostring(fn) .. '")')
	requires[fn] = loadstring(code)() or true
	return requires[fn]
end

require 'instead_js'
require 'stead'
require 'ext/gui'
require 'ext/paths'
require 'ext/sound'
require 'ext/sprites'
require 'ext/timer'

stead:init()

require 'instead_fs'
