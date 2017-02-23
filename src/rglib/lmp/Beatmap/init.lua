local init = function(lmp)
--------------------------------
local Beatmap = {}

Beatmap.data = {}

Beatmap.new = function(self)
	local beatmap = {}
	setmetatable(beatmap, self)
	self.__index = self

	return beatmap
end

Beatmap.Slide = require(lmp.path .. "Beatmap/Slide")(Beatmap, lmp)
Beatmap.import = require(lmp.path .. "Beatmap/import")(Beatmap, lmp)
Beatmap.genCache = require(lmp.path .. "Beatmap/genCache")(Beatmap, lmp)

return Beatmap
--------------------------------
end

return init
