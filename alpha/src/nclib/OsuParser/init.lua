nclib.OsuParser = createClass(nclib.Parcer)
local OsuParser = nclib.OsuParser

require("nclib.OsuParser.NoteParser")
require("nclib.OsuParser.TimingPointParser")

OsuParser.parse = function(self)
	self:parseStage1()
end

OsuParser.parseStage1 = function(self)
	self.eventParsers = {}
	self.timingPointParsers = {}
	self.noteParsers = {}
	
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
			self:parseStage1MetaDataLine(line)
		elseif blockName == "Events" then
			self:parseStage1EventLine(line)
		elseif blockName == "TimingPoints" then
			self:parseStage1TimingPointLine(line)
		elseif blockName == "HitObjects" then
			self:parseStage1HitObjectLine(line)
		end
	end
	
	local compareByStartTime = function(a, b) return a.startTime < b.startTime end
	table.sort(self.timingPointParsers, compareByStartTime)
	table.sort(self.noteParsers, compareByStartTime)
end

OsuParser.parseStage2 = function(self)
	for _, noteParser in ipairs(self.noteParsers) do
		noteParser:parseStage2()
	end
end

OsuParser.parseStage1MetadataLine = function(self, line)
	local lineTable = line:trim():split(":")
	local key = lineTable[1]:trim()
	table.remove(lineTable, 1)
	local value = table.concat(lineTable, ":"):trim()
	self.osuMetaData[key] = value
end

-- OsuParser.processMetadata = function(self)
	-- for key, value in pairs(self.osuMetaData) do
		-- if key == "AudioFilename" and value ~= "virtual" then
			-- self.metaData.audioFileName = value
		-- end
	-- end
-- end

OsuParser.parseStage1EventLine = function(self, line)

end

OsuParser.parseStage1TimingPointLine = function(self, line)
	-- local osuTimingPoint = {}
	-- local timingPoint = {}
	-- timingPoint.osuTimingPoint = osuTimingPoint
	
	-- local lineTable = line:split(",")
	
	-- osuTimingPoint.offset = tonumber(lineTable[1])
	-- osuTimingPoint.beatLength = tonumber(lineTable[2])
	-- osuTimingPoint.timingSignature = tonumber(lineTable[3])
	-- osuTimingPoint.sampleSetId = tonumber(lineTable[4])
	-- osuTimingPoint.customSampleIndex = tonumber(lineTable[5])
	-- osuTimingPoint.sampleVolume = tonumber(lineTable[6])
	-- osuTimingPoint.timingChange = tonumber(lineTable[7])
	-- osuTimingPoint.kiaiTimeActive = tonumber(lineTable[8])
	
	-- timingPoint.startTime = osuTimingPoint.offset
	
	-- if osuTimingPoint.timingChange == 0 then
		-- timingPoint.velocity = -100 / osuTimingPoint.beatLenght
		-- timingPoint.inherited = true
	-- elseif osuTimingPoint.timingChange == 1 then
		-- timingPoint.beatLenght = osuTimingPoint.beatLength
		-- timingPoint.inherited = false
	-- end
	-- table.insert(timingPoint.noteChart, timingPoint)
end

OsuParser.parseStage1HitObjectLine = function(self, line)
	local note = self.noteChart.Note:new()
	table.insert(self.noteChart.noteData, note)
	
	local noteParser = self.NoteParser:new()
	table.insert(self.noteParsers, noteParser)
	noteParser.osuParser = self
	noteParser.note = note
	noteParser.line = line
	
	noteParser:parseStage1()
end