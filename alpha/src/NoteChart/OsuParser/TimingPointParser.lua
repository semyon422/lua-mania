OsuParser.TimingPointParser = createClass()
local TimingPointParser = OsuParser.TimingPointParser

TimingPointParser.parseStage1 = function(self)
	self.lineTable = self.line:split(",")
	
	self.offset = tonumber(self.lineTable[1])
	self.beatLength = tonumber(self.lineTable[2])
	self.timingSignature = tonumber(self.lineTable[3])
	self.sampleSetId = tonumber(self.lineTable[4])
	self.customSampleIndex = tonumber(self.lineTable[5])
	self.sampleVolume = tonumber(self.lineTable[6])
	self.timingChange = tonumber(self.lineTable[7])
	self.kiaiTimeActive = tonumber(self.lineTable[8])
end

-- TimingPointParser.parseStage2 = function(self) end

TimingPointParser.parseFinal = function(self)
	local timingPoint = self.noteChart.TimingPoint:new()
	timingPoint.startTime = self.offset
	timingPoint.velocity = 1
	
	table.insert(self.noteChart.timingData, timingPoint)
end