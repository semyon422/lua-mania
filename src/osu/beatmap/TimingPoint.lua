local init = function(...)
--------------------------------
local TimingPoint = {}

TimingPoint.data = {}

TimingPoint.new = function(self, timingPoint)
	local timingPoint = timingPoint or {}
	setmetatable(timingPoint, self)
	self.__index = self
	return timingPoint
end

TimingPoint.import = function(self, line)
	local breaked = explode(",", line)
	
	self.offset = tonumber(breaked[1])
	self.beatLength = tonumber(breaked[2])
	self.timingSignature = tonumber(breaked[3])
	self.sampleSetId = tonumber(breaked[4])
	self.customSampleIndex = tonumber(breaked[5])
	self.sampleVolume = tonumber(breaked[6])
	self.timingChange = tonumber(breaked[7])
	self.kiaiTimeActive = tonumber(breaked[8])
	
	
	self.startTime = self.offset
	self.endTime = nil
	
	if self.timingChange == 0 then
		self.velocity = -100 / self.beatLength
	elseif self.timingChange == 1 then
		self.velocity = 1
	end
	
	return self
end
TimingPoint.export = function(self)

end

return TimingPoint
--------------------------------
end

return init