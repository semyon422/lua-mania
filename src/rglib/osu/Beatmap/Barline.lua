local init = function(Beatmap, osu)
--------------------------------
local Barline = {}

Barline.data = {}

Barline.new = function(self, barline)
	local barline = barline or {}

	setmetatable(barline, self)
	self.__index = self

	barline.startTimingPoint = barline:getTimingPoint(barline.startTime)

	return barline
end

Barline.getTimingPoint = Beatmap.HitObject.getTimingPoint

return Barline
--------------------------------
end

return init
