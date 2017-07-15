OsuParser.NoteParser = createClass()
local NoteParser = OsuParser.NoteParser

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
	self.additionSampleSetId = tonumber(addition[1])
	self.additionAdditionalSampleSetId = tonumber(addition[2])
	self.additionCustomSampleSetIndex = tonumber(addition[3])
	self.additionHitSoundVolume = tonumber(addition[4])
	self.additionCustomHitSound = addition[5]
end

NoteParser.parseStage2 = function(self)
	self.startTimingPointParser = self.osuParser:getTimingPointParser(self.startTime)
	self.endTimingPointParser = self.osuParser:getTimingPointParser(self.endTime)
	self:updateColumnIndex()
end

NoteParser.updateColumnIndex = function(self)
	local interval = 512 / self.noteChart.keymode
	for currentColumnIndex = 1, self.noteChart.keymode do
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

NoteParser.updateHitSoundVolume = function(self)
	if self.additionHitSoundVolume and self.additionHitSoundVolume ~= 0 then
		self.hitSoundVolume = self.additionHitSoundVolume / 100
	else
		self.hitSoundVolume = self.startTimingPoint.sampleVolume
	end
end

NoteParser.updateHitSounds = function(self)
	--[[
		if have hitsound at end of addition then set it and skip other hitsounds
			get volume from addition
			elseif addition's volume is 0 then get volume from timing point
		else
			set customSampleSetIndex from addition else from timing
			set sampleSetName form addition[2] else from addition[1]
			set hitsound names from bitmap else use hitnormal
			compute full name for hitsounds
				sampleSetName-hitsound[customSampleSetIndex]
		
	]]
	self:updateHitSoundVolume()
	
	self.hitSoundFileNames = {}
	if self.additionCustomHitSound and self.additionCustomHitSound ~= "" then
		self.hitSoundFileNames[1] = self.additionCustomHitSound
		return
	else
		self:updateHitSoundList()
		self:updateSampleSetName()
		self:updateCustomSampleSetIndex()
	end
	----
	

	self.sampleSetName = self:getSampleSetNameById(self.startTimingPoint.sampleSetId)
	if self.addition.sampleSetId ~= 0 then
		self.sampleSetName = self:getSampleSetNameById(self.addition.sampleSetId)
	end
	if self.addition.additionalSampleSetId ~= 0 then
		self.sampleSetName = self:getSampleSetNameById(self.addition.additionalSampleSetId)
	end
	
	if self.startTimingPoint.customSampleIndex ~= 0 then
		self.customSampleIndex = self.startTimingPoint.customSampleIndex
	else
		self.customSampleIndex = ""
	end
	
	if self.addition.hitSoundVolume > 0 then
		self.volume = self.addition.hitSoundVolume / 100
	else
		self.volume = self.startTimingPoint.sampleVolume / 100
	end
	
	self.hitSoundsList = {}
	if self.addition.customHitSound ~= "" then
		self.hitSoundsList[1] = self.addition.customHitSound
	elseif self.hitSoundBitmap ~= 0 then
		if bit.band(self.hitSoundBitmap, 2) then
			local fileName = self.sampleSetName .. "-hitwhistle" .. self.customSampleIndex
			if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			end
			table.insert(self.hitSoundsList, fileName)
		end
		if bit.band(self.hitSoundBitmap, 4) then
			local fileName = self.sampleSetName .. "-hitfinish" .. self.customSampleIndex
			if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			end
			table.insert(self.hitSoundsList, fileName)
		end
		if bit.band(self.hitSoundBitmap, 8) then
			local fileName = self.sampleSetName .. "-hitclap" .. self.customSampleIndex
			if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			end
			table.insert(self.hitSoundsList, fileName)
		end
	else
		if #self.hitSoundsList == 0 then
			local fileName = self.sampleSetName .. "-hitnormal" .. self.customSampleIndex
			if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			end
			table.insert(self.hitSoundsList, fileName)
		end
	end
end

-- NoteParser.import = function(self, line)
	-- local breaked = explode(",", line)
	-- local addition = explode(":", breaked[6])
	
	-- self.x = tonumber(breaked[1])
	-- self.y = tonumber(breaked[2])
	
	-- local interval = 512 / self.beatmap.keymode
	-- for newKey = 1, self.beatmap.keymode do
		-- if self.x >= interval * (newKey - 1) and self.x < newKey * interval then
			-- self.key = newKey
			-- break
		-- end
	-- end
	
	-- self.startTime = tonumber(breaked[3])
	-- self.type = tonumber(breaked[4])
	
	-- self.hitSoundBitmap = tonumber(breaked[5])
	
	-- self.addition = {}
	-- self.addition.sampleSetId = tonumber(addition[#addition - 4])
	-- self.addition.additionalSampleSetId = tonumber(addition[#addition - 3])
	-- self.addition.customSampleSetIndex = tonumber(addition[#addition - 2])
	-- self.addition.hitSoundVolume = tonumber(addition[#addition - 1])
	-- self.addition.customHitSound = addition[#addition]
	
	-- if bit.band(self.type, 128) == 128 then
		-- self.endTime = tonumber(addition[1])
		-- self.endTimingPoint = self:getTimingPoint(self.endTime)
	-- end
	
	-- self.startTimingPoint = self:getTimingPoint(self.startTime)
	
	-- self.sampleSetName = self:getSampleSetName(self.startTimingPoint.sampleSetId)
	-- if self.addition.sampleSetId ~= 0 then
		-- self.sampleSetName = self:getSampleSetName(self.addition.sampleSetId)
	-- end
	-- if self.addition.additionalSampleSetId ~= 0 then
		-- self.sampleSetName = self:getSampleSetName(self.addition.additionalSampleSetId)
	-- end
	
	-- if self.startTimingPoint.customSampleIndex ~= 0 then
		-- self.customSampleIndex = self.startTimingPoint.customSampleIndex
	-- else
		-- self.customSampleIndex = ""
	-- end
	
	-- if self.addition.hitSoundVolume > 0 then
		-- self.volume = self.addition.hitSoundVolume / 100
	-- else
		-- self.volume = self.startTimingPoint.sampleVolume / 100
	-- end
	
	-- self.hitSoundsList = {}
	-- if self.addition.customHitSound ~= "" then
		-- self.hitSoundsList[1] = self.addition.customHitSound
	-- elseif self.hitSoundBitmap ~= 0 then
		-- if bit.band(self.hitSoundBitmap, 2) then
			-- local fileName = self.sampleSetName .. "-hitwhistle" .. self.customSampleIndex
			-- if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				-- fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			-- end
			-- table.insert(self.hitSoundsList, fileName)
		-- end
		-- if bit.band(self.hitSoundBitmap, 4) then
			-- local fileName = self.sampleSetName .. "-hitfinish" .. self.customSampleIndex
			-- if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				-- fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			-- end
			-- table.insert(self.hitSoundsList, fileName)
		-- end
		-- if bit.band(self.hitSoundBitmap, 8) then
			-- local fileName = self.sampleSetName .. "-hitclap" .. self.customSampleIndex
			-- if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				-- fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			-- end
			-- table.insert(self.hitSoundsList, fileName)
		-- end
	-- else
		-- if #self.hitSoundsList == 0 then
			-- local fileName = self.sampleSetName .. "-hitnormal" .. self.customSampleIndex
			-- if not helpers.getFilePath(fileName, self.beatmap.hitSoundsRules) then
				-- fileName = string.sub(fileName, 1, #fileName - #tostring(self.customSampleIndex))
			-- end
			-- table.insert(self.hitSoundsList, fileName)
		-- end
	-- end
	
	-- return self
-- end