nclib.OsuParser.NoteParser = createClass()
local NoteParser = nclib.OsuParser.NoteParser

NoteParser.parseStage1 = function(self)
	self.lineTable = self.line:split(",")
	self.additionLineTable = self.lineTable[6]:split(":")
	
	self:updateKey()
	
	self.startTime = tonumber(self.lineTable[3])
	self.type = tonumber(self.lineTable[4])
	
	if bit.band(self.type, 128) == 128 then
		self.endTime = tonumber(self.additionLineTable[1])
		table.remove(self.additionLineTable, 1)
	end
end

NoteParser.updateKey = function(self)
	local x = tonumber(self.lineTable[1])
	local y = tonumber(self.lineTable[2])
	
	local interval = 512 / self.noteChart.keymode
	for newKey = 1, self.noteChart.keymode do
		if x >= interval * (newKey - 1) and x < newKey * interval then
			self.key = newKey
			break
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