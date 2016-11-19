local init = function(lmx)
--------------------------------
local Beatmap = {}

Beatmap.data = {}

Beatmap.metatable = {
	__index = Beatmap
}

Beatmap.new = function(self)
	local beatmap = {}
	setmetatable(beatmap, Beatmap.metatable)
	
	return beatmap
end

Beatmap.import = require(lmx.path .. "Beatmap/import")(Beatmap, lmx)

return Beatmap
--------------------------------
end

return init
