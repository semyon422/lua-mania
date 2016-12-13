local init = function(Beatmap, osu)
--------------------------------
local TimingPoint = {}

TimingPoint.data = {}

TimingPoint.new = function(self, timingPoint)
	local timingPoint = timingPoint or {}
	setmetatable(timingPoint, self)
	self.__index = self
	return timingPoint
end

TimingPoint.import = function(self, data)
	self.startTime = data.startTime
	self.beatLength = data.beatLength
	self.baseVelocity = 1
	
	self.index = #self.beatmap.timingPoints + 1
	
	return self
end
TimingPoint.export = function(self)

end

return TimingPoint
--------------------------------
end

return init