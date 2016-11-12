local init = function(Beatmap, osu)
--------------------------------
local import = function(self, filePath)
	local breakedPath = explode("/", filePath)
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = string.sub(filePath, 1, #filePath - #self.mapFileName - 1)
	
	self.hitSoundsRules = {
		formats = {"wav", "mp3", "ogg"},
		paths = {self.mapPath}
	}
	
	local file = io.open(filePath, "r")
	local fileLines = {}

	local timingPointsSection = {}
	local hitObjectsSection = {}
	
	local blockName = ""
	for line in file:lines() do
		if line:sub(1,1) == "[" then
			blockName = trim(line):sub(2, -2)
		elseif blockName ~= "Events" and blockName ~= "TimingPoints" and blockName ~= "HitObjects" then
			if string.sub(line, 1, #("AudioFilename")) == "AudioFilename" then
				self.audioFilename = trim(string.sub(line, #("AudioFilename") + 2, -1))
			elseif string.sub(line, 1, #("CircleSize")) == "CircleSize" then
				self.keymode = tonumber(string.sub(line, #("CircleSize") + 2, -1))
			end
		elseif blockName == "Events" and trim(line) ~= "" then
			if string.sub(line, 1, 6) == "Sample" then
				table.insert(self.eventSamples, self.EventSample:new({beatmap = self}):import(line))
			elseif not self.backgroundPath and string.sub(line, 1, 5) == "0,0,\"" then
				self.backgroundPath = self.mapPath .. "/" .. explode("\"", line)[2]
			end
		elseif blockName == "TimingPoints" and trim(line) ~= "" then
			table.insert(timingPointsSection, line)
		elseif blockName == "HitObjects" and trim(line) ~= "" then
			table.insert(hitObjectsSection, line)
			-- table.insert(self.hitObjects, self.HitObject:new({beatmap = self}):import(line))
		end
	end
	
	if self.audioFilename ~= "virtual" then
		local sourceType = luaMania.config["game.vsrg.audioSourceType"]:get()
		self.audio = love.audio.newSource(self.mapPath .. "/" .. self.audioFilename, sourceType)
	else
		local lastHitObject = self.hitObjects[#self.hitObjects]
		local samples = 44100 * ((lastHitObject.endTime and lastHitObject.endTime or lastHitObject.startTime) / 1000 + 2)
		local soundData = love.sound.newSoundData(samples)
		self.audio = love.audio.newSource(soundData)
	end
	self.audioDuration = self.audio:getDuration("seconds") * 1000
	
	for timingPointIndex = 1, #timingPointsSection do
		local line = timingPointsSection[timingPointIndex]
		
		table.insert(self.timingPoints, self.TimingPoint:new({beatmap = self}):import(line))
		local current = self.timingPoints[#self.timingPoints]
		local prev = self.timingPoints[#self.timingPoints - 1]
		
		if #self.timingPoints == 1 and current.startTime > 0 then
			self.timingPoints[2] = current
			self.timingPoints[2].index = 2
			self.timingPoints[1] = self.TimingPoint:new({beatmap = self}):import(line)
			current = self.timingPoints[2]
			prev = self.timingPoints[1]
			prev.index = 1
			prev.startTime = 0
			prev.endTime = current.startTime
		end
		
		if prev and not prev.endTime then prev.endTime = current.startTime end
		if prev and current.inherited then
			current.beatLength = prev.beatLength
		end
	end
	self.timingPoints[#self.timingPoints].endTime = self.audioDuration
	
	local beatLength2beatLengths = {}
	local beatLengths = {}
	for timingPointIndex = 1, #self.timingPoints do
		local current = self.timingPoints[timingPointIndex]
		
		current.lenghtTime = current.endTime - current.startTime
		beatLength2beatLengths[current.beatLength] = beatLength2beatLengths[current.beatLength] or {current.beatLength, 0, #beatLengths + 1}
		beatLength2beatLengths[current.beatLength][2] = beatLength2beatLengths[current.beatLength][2] + current.lenghtTime
		beatLengths[beatLength2beatLengths[current.beatLength][3]] = beatLength2beatLengths[current.beatLength]
	end
	table.sort(beatLengths, function(a, b)
		return a[2] > b[2]
	end)
	self.baseBeatLenght = beatLengths[1][1]
	
	for timingPointIndex = 1, #self.timingPoints do
		local current = self.timingPoints[timingPointIndex]
		local prev = self.timingPoints[timingPointIndex - 1]
		
		if current.inherited then
			current.velocity = -100 / current.baseBeatLenght * self.baseBeatLenght / current.beatLength
		else
			current.velocity = self.baseBeatLenght / current.beatLength
		end
	end
	self.timingPoints[#self.timingPoints].endTime = math.huge
	
	for hitObjectIndex = 1, #hitObjectsSection do
		local line = hitObjectsSection[hitObjectIndex]
		table.insert(self.hitObjects, self.HitObject:new({beatmap = self}):import(line))
	end
	
	return self
end

return import
--------------------------------
end

return init
