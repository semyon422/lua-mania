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

	self.audioFilename = "virtual"
	self.keymode = 8
	self.hitObjects = {}
	self.timingPoints = {}
	self.eventSamples = {}
	
	self.timingPoints[1] = {}
	
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
				self.measureLenght = 60000 / self.bpm * 4
			elseif string.sub(line, 7, 7) == ":" then
				local measure = string.sub(line, 2, 4)
				local channel = tonumber(string.sub(line, 5, 6))
				local message = string.sub(line, 8, -1)
				local lenght = #message / 2
				for pointIndex = 1, lenght do
					local point = string.sub(message, 2 * pointIndex - 1, 2 * pointIndex)
					if point ~= "00" then
						local part = (pointIndex - 1) / lenght
						local startTime = math.floor((measure + part) * self.measureLenght)
						if channel == 1 then
							if self.wav[point] then
								table.insert(self.eventSamples, {
									startTime = startTime,
									fileName = self.wav[point]
								})
							end
						elseif channel >= 11 then
							table.insert(self.hitObjects, {
								startTime = startTime,
								hitSoundsList = {
									self.wav[point]
								},
								key = self.channel2key[channel],
								startTimingPoint = self.timingPoints[1]
							})
						end
					end
				end
			end
		end
	end
	self.timingPoints[1].index = 1
	self.timingPoints[1].startTime = 0
	self.timingPoints[1].endTime = self.eventSamples[#self.eventSamples].startTime
	self.timingPoints[1].velocity = 1
	
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