local init = function(bms)
--------------------------------
local Beatmap = {}

Beatmap.data = {}

Beatmap.new = function(self)
	local beatmap = {}
	setmetatable(beatmap, self)
	self.__index = self

	return beatmap
end

Beatmap.import = require(bms.path .. "Beatmap/import")(Beatmap, bms)
Beatmap.genCache = require(bms.path .. "Beatmap/genCache")(Beatmap, bms)

Beatmap.TimingPoint = require(bms.path .. "Beatmap/TimingPoint")(Beatmap, bms)
Beatmap.HitObject = require(bms.path .. "Beatmap/HitObject")(Beatmap, bms)

return Beatmap
--------------------------------
end

return init