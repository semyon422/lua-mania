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

TimingPoint.import = function(self, line)
	local breaked = explode(",", line)
	
	self.offset = math.ceil(tonumber(breaked[1]))
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
		self.baseBeatLenght = self.beatLength
		self.baseVelocity = -100 / self.baseBeatLenght
		self.inherited = true
	elseif self.timingChange == 1 then
		self.baseVelocity = 1
		self.inherited = false
		if self.beatLength < 0 then
			self.baseBeatLenght = self.beatLength
			self.baseVelocity = -100 / self.baseBeatLenght
			self.inherited = true
		end
	end
	
	self.index = #self.beatmap.timingPoints + 1
	
	return self
end
TimingPoint.export = function(self)

end

return TimingPoint
--------------------------------
end

return init