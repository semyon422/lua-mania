nclib.OsuParser = createClass(nclib.Parcer)
local OsuParser = nclib.OsuParser

require("nclib.OsuParser.HitObject")
require("nclib.OsuParser.TimingPoint")

OsuParser.parse = function(self)
	self.metaData = {}
	self.timingData = {}
	self.noteData = {}
	
	
end

OsuParser.load = function(self, cache)
	local file = love.filesystem.newFile(self.filePath)
	file:open("r")
	if not file then error(self.filePath) end
	
	local fileLines = {}
	for line in file:lines() do
		table.insert(fileLines, line)
	end
	file:close()
	
	local blockName
	for i = 1, #fileLines do
		local line = fileLines[i]
		while line:trim() == "" do
			i = i + 1
			line = fileLines[i]
		end
		
		if line:startsWith("[") then
			blockName = line:trim():sub(2, -2)
		elseif blockName ~= "Events" and blockName ~= "TimingPoints" and blockName ~= "HitObjects" then
			self:parseMetaDataLine(line)
		elseif blockName == "Events" then
			self:parseEventsLine(line)
		elseif blockName == "TimingPoints" then
			self:parseTimingPointsLine(line)
		elseif blockName == "HitObjects" then
			self:parseHitObjectsLine(line)
		end
	end
	self:processMetadata()
end

OsuParser.parseMetadataLine = function(self, line)
	local lineTable = line:trim():split(":")
	local key = lineTable[1]:trim()
	table.remove(lineTable, 1)
	local value = table.concat(lineTable, ":"):trim()
	self.osuMetaData[key] = value
end

OsuParser.processMetadata = function(self)
	for key, value in pairs(self.osuMetaData) do
		if key == "AudioFilename" and value ~= "virtual" then
			self.metaData.audioFileName = value
		end
	end
end

OsuParser.parseEventsLine = function(self, line)

end

OsuParser.parseTimingPointsLine = function(self, line)
	-- local lineTable = line:split(",")
	
	-- self.offset = tonumber(lineTable[1])
	-- self.beatLength = tonumber(lineTable[2])
	-- self.timingSignature = tonumber(lineTable[3])
	-- self.sampleSetId = tonumber(lineTable[4])
	-- self.customSampleIndex = tonumber(lineTable[5])
	-- self.sampleVolume = tonumber(lineTable[6])
	-- self.timingChange = tonumber(lineTable[7])
	-- self.kiaiTimeActive = tonumber(lineTable[8])
	
	-- self.startTime = self.offset
	
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
	
	-- self.index = #self.beatmap.timingPoints + 1
end

OsuParser.parseHitObjectsLine = function(self, line)

end