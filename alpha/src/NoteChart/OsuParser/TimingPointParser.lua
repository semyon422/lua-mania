NoteChart.OsuParser.TimingPointParser = createClass()
local TimingPointParser = NoteChart.OsuParser.TimingPointParser

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
	
	self.startTime = self.offset
end

-- TimingPointParser.parseStage2 = function(self) end

TimingPointParser.parseFinal = function(self)
	local timingPoint = self.osuParser.noteChart.TimingPoint:new()
	timingPoint.startTime = self.startTime
	timingPoint.velocity = 1
	
	table.insert(self.osuParser.noteChart.timingData, timingPoint)
end