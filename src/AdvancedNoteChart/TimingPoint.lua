local TimingPoint = {}

TimingPoint.new = function(self)
	local timingPoint = {}
	-- int startTime
	-- float bpm
	-- float velocity
	-- int layer
	
	self.__index = self
	setmetatable(timingPoint, self)
	
	return timingPoint
end

return TimingPoint
