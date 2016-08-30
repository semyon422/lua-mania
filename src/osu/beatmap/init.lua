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

Beatmap.import = require(osu.path .. "beatmap/import")(Beatmap, osu)

Beatmap.EventSample = require(osu.path .. "beatmap/EventSample")(Beatmap, osu)
Beatmap.TimingPoint = require(osu.path .. "beatmap/TimingPoint")(Beatmap, osu)
Beatmap.HitObject = require(osu.path .. "beatmap/HitObject")(Beatmap, osu)

return Beatmap
--------------------------------
end

return init