local AdvancedNoteChart = NoteChart:new()

AdvancedNoteChart.getTimingPoint = function(self, time)
	if not time then return end
	for index = 1 #self.timingPoints do
		local currentTimingPoint = self.timingPoints[index]
		local nextTimingPoint = self.timingPoints[index + 1] or {startTime = math.huge}
		
		if time >= currentTimingPoint.startTime and time < nextTimingPoint.startTime then
			return timingPoint
		end
	end
end

AdvancedNoteChart.load = function(self)
	local breakedPath = self.filePath:split("/")
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = self.filePath:sub(1, #filePath - #self.mapFileName - 1)
	
	self.audio = love.audio.newSource(self.mapPath .. "/" .. self.metaData.audio)

	return self
end

return AdvancedNoteChart
