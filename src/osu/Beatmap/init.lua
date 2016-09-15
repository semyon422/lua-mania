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
	
	self.eventSamples = {}
	self.timingPoints = {}
	self.hitObjects = {}
	return beatmap
end

Beatmap.import = require(osu.path .. "Beatmap/import")(Beatmap, osu)

Beatmap.EventSample = require(osu.path .. "Beatmap/EventSample")(Beatmap, osu)
Beatmap.TimingPoint = require(osu.path .. "Beatmap/TimingPoint")(Beatmap, osu)
Beatmap.HitObject = require(osu.path .. "Beatmap/HitObject")(Beatmap, osu)

return Beatmap
--------------------------------
end

return init
