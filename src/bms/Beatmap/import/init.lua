local init = function(Beatmap, bms)
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
	
	self.keymode = 8
	self.hitObjects = {}
	self.timingPoints = {}
	self.eventSamples = {}

	self.channel2key = {
		[16] = 1,
		[11] = 2,
		[12] = 3,
		[13] = 4,
		[14] = 5,
		[15] = 6,
		[18] = 7,
		[19] = 8,
	}
	
	self.wav = {}
	
	local timingPointsSection = {}
	local hitObjectsSection = {}
	
	for line in file:lines() do
		if string.sub(line, 1, 1) == "#" then
			if string.sub(line, 2, 4) == "WAV" then
				local key = string.sub(line, 5, 6)
				local value = string.sub(line, 8, -1)
				self.wav[key] = value
			elseif string.sub(line, 2, 6) == "TITLE" then
				self.title = string.sub(line, 8, -1)
			elseif string.sub(line, 2, 7) == "ARTIST" then
				self.artist = string.sub(line, 9, -1)
			elseif string.sub(line, 2, 4) == "BPM" and not self.bpm then
				self.bpm = tonumber(string.sub(line, 6, -1))
				self.measureLength = 60000 / self.bpm * 4
			elseif string.sub(line, 2, 10) == "STAGEFILE" and not self.backgroundPath then
				self.backgroundPath = self.mapPath .. "/" .. string.sub(line, 12, -1)
			elseif string.sub(line, 7, 7) == ":" then
				local measureOffset = self.measureOffset or 0
				local measure = string.sub(line, 2, 4) - measureOffset
				local offsetTime = self.offsetTime or 0
				local channel = tonumber(string.sub(line, 5, 6))
				local message = trim(string.sub(line, 8, -1))
				local length = #message / 2
				for pointIndex = 1, length do
					local point = string.sub(message, 2 * pointIndex - 1, 2 * pointIndex)
					if point ~= "00" then
						local part = (pointIndex - 1) / length
						local startTime = offsetTime + math.ceil((measure + part) * self.measureLength)
						if channel == 3 then
							table.insert(timingPointsSection, {
								startTime = startTime + offsetTime,
								beatLength = 60000 / tonumber(point, 16)
							})
							self.measureLength = timingPointsSection[#timingPointsSection].beatLength * 4
							self.measureOffset = measure + measureOffset
							measure = 0
							self.offsetTime = startTime
						end
						if channel == 1 then
							if self.wav[point] then
								table.insert(self.eventSamples, {
									startTime = startTime,
									fileName = self.wav[point]
								})
							end
						elseif channel >= 11 then
							table.insert(hitObjectsSection, {
								startTime = startTime,
								hitSoundsList = {
									self.wav[point]
								},
								key = self.channel2key[channel]
							})
						end
					end
				end
			end
		end
	end
	
	self.audioDuration = hitObjectsSection[#hitObjectsSection].startTime / 1000
	local soundData = love.sound.newSoundData(44100 * self.audioDuration)
	self.audio = love.audio.newSource(soundData)
	
	if #timingPointsSection == 0 then
		timingPointsSection[1] = {
			startTime = 0,
			beatLength = 60000 / self.bpm
		}
	end
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
	end
	self.timingPoints[#self.timingPoints].endTime = self.audioDuration
	
	local beatLength2beatLengths = {}
	local beatLengths = {}
	for timingPointIndex = 1, #self.timingPoints do
		local current = self.timingPoints[timingPointIndex]
		
		current.lengthTime = current.endTime - current.startTime
		beatLength2beatLengths[current.beatLength] = beatLength2beatLengths[current.beatLength] or {current.beatLength, 0, #beatLengths + 1}
		beatLength2beatLengths[current.beatLength][2] = beatLength2beatLengths[current.beatLength][2] + current.lengthTime
		beatLengths[beatLength2beatLengths[current.beatLength][3]] = beatLength2beatLengths[current.beatLength]
	end
	table.sort(beatLengths, function(a, b)
		return a[2] > b[2]
	end)
	self.baseBeatLenght = beatLengths[1][1]
	
	for timingPointIndex = 1, #self.timingPoints do
		local current = self.timingPoints[timingPointIndex]
		local prev = self.timingPoints[timingPointIndex - 1]
		
		-- current.velocity = self.baseBeatLenght / current.beatLength
		current.velocity = 1
	end
	self.timingPoints[#self.timingPoints].endTime = math.huge
	
	for hitObjectIndex = 1, #hitObjectsSection do
		local line = hitObjectsSection[hitObjectIndex]
		table.insert(self.hitObjects, self.HitObject:new({beatmap = self}):import(line))
	end
	
	self.sortByTime = function(a, b)
		return a.startTime < b.startTime
	end
	table.sort(self.eventSamples, self.sortByTime)
	table.sort(self.hitObjects, self.sortByTime)
	table.sort(self.timingPoints, self.sortByTime)
	
	return self
end

return import
--------------------------------
end

return init
