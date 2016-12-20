local init = function(osu)
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

Beatmap.load = require(osu.path .. "Beatmap/import/load")(Beatmap, osu)
Beatmap.compute = require(osu.path .. "Beatmap/import/compute")(Beatmap, osu)
Beatmap.import = require(osu.path .. "Beatmap/import")(Beatmap, osu)
Beatmap.genCache = require(osu.path .. "Beatmap/genCache")(Beatmap, osu)

Beatmap.EventSample = require(osu.path .. "Beatmap/EventSample")(Beatmap, osu)
Beatmap.TimingPoint = require(osu.path .. "Beatmap/TimingPoint")(Beatmap, osu)
Beatmap.HitObject = require(osu.path .. "Beatmap/HitObject")(Beatmap, osu)
Beatmap.Barline = require(osu.path .. "Beatmap/Barline")(Beatmap, osu)

return Beatmap
--------------------------------
end

return init
