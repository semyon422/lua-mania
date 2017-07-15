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
	
	-- if self.timingChange == 0 then
		-- self.baseBeatLenght = self.beatLength
		-- self.baseVelocity = -100 / self.baseBeatLenght
		-- self.inherited = true
	-- elseif self.timingChange == 1 then
		-- self.baseVelocity = 1
		-- self.inherited = false
		-- if self.beatLength < 0 then
			-- self.baseBeatLenght = self.beatLength
			-- self.baseVelocity = -100 / self.baseBeatLenght
			-- self.inherited = true
		-- end
	-- end
end
