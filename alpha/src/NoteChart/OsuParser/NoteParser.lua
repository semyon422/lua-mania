NoteChart.OsuParser.NoteParser = createClass()
local NoteParser = NoteChart.OsuParser.NoteParser

NoteParser.parseStage1 = function(self)
	self.lineTable = self.line:split(",")
	self.additionLineTable = self.lineTable[6]:split(":")
	
	self.x = tonumber(self.lineTable[1])
	self.y = tonumber(self.lineTable[2])
	self.startTime = tonumber(self.lineTable[3])
	self.type = tonumber(self.lineTable[4])
	self.hitSoundBitmap = tonumber(self.lineTable[5])
	if bit.band(self.type, 128) == 128 then
		self.endTime = tonumber(self.additionLineTable[1])
		table.remove(self.additionLineTable, 1)
	end
	self.additionSampleSetId = tonumber(self.additionLineTable[1])
	self.additionAdditionalSampleSetId = tonumber(self.additionLineTable[2])
	self.additionCustomSampleSetIndex = tonumber(self.additionLineTable[3])
	self.additionHitSoundVolume = tonumber(self.additionLineTable[4])
	self.additionCustomHitSound = self.additionLineTable[5]
end

NoteParser.parseStage2 = function(self)
	self.startTimingPointParser = self.osuParser:getTimingPointParser(self.startTime)
	self.endTimingPointParser = self.osuParser:getTimingPointParser(self.endTime)
	self:updateColumnIndex()
end

NoteParser.parseFinal = function(self)
	local note = self.osuParser.noteChart.Note:new()
	note.columnIndex = self.columnIndex
	note.startTime = self.startTime
	note.endTime = self.endTime
	note.startTimingPoint = self.startTimingPoint
	note.endTimingPoint = self.endTimingPoint
	note.hitSoundFileNames = self.hitSoundFileNames
	
	table.insert(self.osuParser.noteChart.noteData, note)
end

NoteParser.updateColumnIndex = function(self)
	local keymode = self.osuParser.metaData.CircleSize
	local interval = 512 / keymode
	for currentColumnIndex = 1, keymode do
		if self.x >= interval * (currentColumnIndex - 1) and self.x < currentColumnIndex * interval then
			self.columnIndex = currentColumnIndex
			break
		end
	end
end

NoteParser.getSampleSetNameById = function(self, id)
	if id == 0 then
		return "none"
	elseif id == 1 then
		return "normal"
	elseif id == 2 then
		return "soft"
	elseif id == 3 then
		return "drum"
	end
end

NoteParser.updateHitSoundList = function(self)
	self.hitSoundList = {}
	if self.hitSoundBitmap ~= 0 then
		if bit.band(self.hitSoundBitmap, 2) then
			table.insert(self.hitSoundList, "hitwhistle")
		end
		if bit.band(self.hitSoundBitmap, 4) then
			table.insert(self.hitSoundList, "hitfinish")
		end
		if bit.band(self.hitSoundBitmap, 8) then
			table.insert(self.hitSoundList, "hitclap")
		end
	else
		table.insert(self.hitSoundList, "hitnormal")
	end
end

NoteParser.updateSampleSetName = function(self)
	if self.additionAdditionalSampleSetId and self.additionAdditionalSampleSetId ~= 0 then
		self.sampleSetName = self:getSampleSetNameById(self.additionAdditionalSampleSetId)
	elseif self.additionSampleSetId and self.additionSampleSetId ~= 0 then
		self.sampleSetName = self:getSampleSetNameById(self.additionSampleSetId)
	elseif self.startTimingPoint.sampleSetId then
		self.sampleSetName = self:getSampleSetNameById(self.startTimingPoint.sampleSetId)
	else
		self.sampleSetName = self.osuParser:getSampleSetName()
	end
end

NoteParser.updateCustomSampleSetIndex = function(self)
	self.customSampleIndex = self.startTimingPoint.customSampleIndex
end

NoteParser.updateHitSoundFileNames = function(self)
	for i = 1, #self.hitSoundList do
		self.hitSoundList[i] = self.sampleSetName .. "-" .. self.sampleSetName[i] .. self.customSampleIndex
	end
end

NoteParser.updateHitSoundVolume = function(self)
	if self.additionHitSoundVolume and self.additionHitSoundVolume ~= 0 then
		self.hitSoundVolume = self.additionHitSoundVolume / 100
	else
		self.hitSoundVolume = self.startTimingPoint.sampleVolume / 100
	end
end

NoteParser.updateHitSounds = function(self)
	self:updateHitSoundVolume()
	
	self.hitSoundFileNames = {}
	if self.additionCustomHitSound and self.additionCustomHitSound ~= "" then
		self.hitSoundFileNames[1] = self.additionCustomHitSound
		return
	else
		self:updateHitSoundList()
		self:updateSampleSetName()
		self:updateCustomSampleSetIndex()
		self:updateHitSoundFileNames()
	end
end
