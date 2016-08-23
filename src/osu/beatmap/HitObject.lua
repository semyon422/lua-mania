local init = function(Beatmap, osu)
--------------------------------
local HitObject = {}

HitObject.data = {}

HitObject.new = function(self, hitObject)
	local hitObject = hitObject or {}
	setmetatable(hitObject, self)
	self.__index = self
	return hitObject
end

HitObject.getTimingPoint = function(self, time)
	for timingPointIndex, timingPoint in ipairs(self.beatmap.timingPoints) do
		if timingPointIndex == #self.beatmap.timingPoints or time > timingPoint.startTime and time < timingPoint.endTime then
			return timingPoint
		end
	end
end

HitObject.getSampleSetName = function(self, id)
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

HitObject.import = function(self, line)
	local breaked = explode(",", line)
	local addition = explode(":", breaked[6])
	
	self.x = tonumber(breaked[1])
	self.y = tonumber(breaked[2])
	self.startTime = tonumber(breaked[3])
	self.type = tonumber(breaked[4])
	
	self.hitSoundBitmap = tonumber(breaked[5])
	
	self.addition = {}
	self.addition.sampleSetId = tonumber(addition[#addition - 4])
	self.addition.additionalSampleSetId = tonumber(addition[#addition - 3])
	self.addition.customSampleSetIndex = tonumber(addition[#addition - 2])
	self.addition.hitSoundVolume = tonumber(addition[#addition - 1])
	self.addition.customHitSound = addition[#addition]
	
	if bit.band(self.type, 128) == 128 then
		self.endTime = tonumber(addition[1])
	end
	
	local timingPoint = self:getTimingPoint(self.startTime)
	
	self.sampleSetName = self:getSampleSetName(timingPoint.sampleSetId)
	if self.addition.sampleSetId ~= 0 then
		self.sampleSetName = self:getSampleSetName(self.addition.sampleSetId)
	end
	if self.addition.additionalSampleSetId ~= 0 then
		self.sampleSetName = self:getSampleSetName(self.addition.additionalSampleSetId)
	end
	
	if timingPoint.customSampleIndex ~= 0 then
		self.customSampleIndex = timingPoint.customSampleIndex
	else
		self.customSampleIndex = ""
	end
	
	if self.addition.hitSoundVolume > 0 then
		self.volume = self.addition.hitSoundVolume / 100
	else
		self.volume = timingPoint.sampleVolume / 100
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
	
	return self
end

HitObject.export = function(self)

end

return HitObject
--------------------------------
end

return init