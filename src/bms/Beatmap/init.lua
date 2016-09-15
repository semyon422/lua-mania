local init = function(osu)
--------------------------------
local Beatmap = {}

Beatmap.data = {}

Beatmap.new = function(self)
	local beatmap = {}
	setmetatable(beatmap, self)
	self.__index = self

	return beatmap
end

Beatmap.import = require(osu.path .. "Beatmap/import")(Beatmap, bms)

return Beatmap
--------------------------------
end

return init