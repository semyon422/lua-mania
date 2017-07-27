NoteChart.OsuParser = createClass(Parcer)
local OsuParser = NoteChart.OsuParser

require("NoteChart.OsuParser.NoteParser")
require("NoteChart.OsuParser.TimingPointParser")

OsuParser.parse = function(self)
	--load from file timing and notes
	--set hitsounds for notes and get timingPoints for them
	--get list of timingPoints which have notes and calculate base BPM and recalculate velocity
	--create table with notes sorted by draw virtual time at currentTime == 0
	--compute barlines
	self:parseStage1()
	self:parseStage2()
	self:parseFinal()
end

OsuParser.parseStage1 = function(self)
	self.metaData = {}
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

OsuParser.getTimingPointParser = function(self, time)
	if not time then return end
	for index = 1, #self.timingPointParsers do
		local currentParser = self.timingPointParsers[index]
		local nextParser = self.timingPointParsers[index + 1] or {offset = math.huge}
		
		if time >= currentParser.offset and time < nextParser.offset then
			return currentParser
		end
	end
end

OsuParser.getSampleSetName = function(self)
	local sampleSet = string.lower(self.metaData.SampleSet)
	if sampleSet == "none" then
		return "soft"
	else
		return sampleSet
	end
end

OsuParser.parseStage2 = function(self)
	-- for _, timingPointParser in ipairs(self.timingPointParsers) do
		-- timingPoint:parseStage2()
	-- end
	for _, noteParser in ipairs(self.noteParsers) do
		noteParser:parseStage2()
	end
end

OsuParser.parseFinal = function(self)
	for _, timingPointParser in ipairs(self.timingPointParsers) do
		timingPointParser:parseFinal()
	end
	for _, noteParser in ipairs(self.noteParsers) do
		noteParser:parseFinal()
	end
	
	local compareByStartTime = function(a, b) return a.startTime < b.startTime end
	table.sort(self.noteChart.timingData, compareByStartTime)
	table.sort(self.noteChart.noteData, compareByStartTime)
end

OsuParser.parseStage1MetaDataLine = function(self, line)
	local lineTable = line:trim():split(":")
	local key = lineTable[1]:trim()
	table.remove(lineTable, 1)
	local value = table.concat(lineTable, ":"):trim()
	self.metaData[key] = value
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
	local timingPointParser = self.TimingPointParser:new()
	table.insert(self.timingPointParsers, timingPointParser)
	timingPointParser.osuParser = self
	timingPointParser.line = line
	
	timingPointParser:parseStage1()
end

OsuParser.parseStage1HitObjectLine = function(self, line)
	local noteParser = self.NoteParser:new()
	table.insert(self.noteParsers, noteParser)
	noteParser.osuParser = self
	noteParser.line = line
	
	noteParser:parseStage1()
end