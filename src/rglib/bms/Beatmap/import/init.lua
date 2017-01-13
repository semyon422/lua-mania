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
	self.bpm = {}
	
	self.channels = {}
	self.timedChannels = {}
	
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
			elseif string.sub(line, 2, 4) == "BPM" then
				if string.sub(line, 5, 5) == " " then
					self.baseBpm = tonumber(string.sub(line, 6, -1))
					self.measureLength = 60000 / self.baseBpm * 4
				else
					self.bpm[string.sub(line, 5, 6)] = tonumber(string.sub(line, 8, -1))
				end
			elseif string.sub(line, 2, 10) == "STAGEFILE" and not self.backgroundPath then
				self.backgroundPath = self.mapPath .. "/" .. string.sub(line, 12, -1)
			elseif string.sub(line, 7, 7) == ":" then
				local measure = tonumber(string.sub(line, 2, 4))
				local channel = tonumber(string.sub(line, 5, 6))
				local message = trim(string.sub(line, 8, -1))
				self.channels[channel] = self.channels[channel] or {}
				self.channels[channel][measure] = self.channels[channel][measure] or {}
				if channel ~= 2 then
					local length = #message / 2
					local points = {}
					for pointIndex = 1, length do
						local point = string.sub(message, 2 * pointIndex - 1, 2 * pointIndex)
						points[pointIndex] = point
					end
					table.insert(self.channels[channel][measure], points)
				else
					table.insert(self.channels[channel][measure], tonumber(message))
				end
			end
		end
	end
	
	self.timeSignature = {}
	table.insert(self.timeSignature, {
		startTime = 0,
		measure = 0,
		signature = 4/4
	})
	if self.channels[2] then
		for measure, data in pairs(self.channels[2]) do
			table.insert(self.timeSignature, {
				measure = measure,
				signature = data[1]
			})
		end
	end
	
	self.timingData = {}
	table.insert(self.timingData, {
		startTime = 0,
		measure = 0,
		part = 0,
		bpm = self.baseBpm
	})
	for i, channel in pairs({3, 8}) do
		if self.channels[channel] then
			for measure, data in pairs(self.channels[3]) do
				for pointsIndex, points in ipairs(data) do
					for pointIndex, point in ipairs(points) do
						if point ~= "00" then
							local part = (pointIndex - 1) / #points
							local bpm
							if channel == 3 then
								bpm = tonumber(point, 16)
							elseif channel == 8 then
								bpm = tonumber(self.bpm[point])
							end
							table.insert(self.timingData, {
								measure = measure,
								part = part,
								bpm = bpm
							})
						end
					end
				end
			end
		end
	end
	table.sort(self.timingData, function(a, b)
		if a.measure == b.measure then
			return a.part < b.part
		else
			return a.measure < b.measure
		end
	end)
	-- for i,v in ipairs(self.timingData) do
		-- print(v.measure, v.part, v.bpm)
	-- end
	-- error()
	
	
	local getSignature = function(measure)
		for index, signatureData in ipairs(self.timeSignature) do
			if measure == signatureData.measure then
				return signatureData.signature
			end
		end
		return 4/4
	end
	local getMeasureTiming = function(measure)
		local timing = {}
		local prevTiming = self.timingData[1]
		local currentTimings = {}
		for timingIndex, timingData in ipairs(self.timingData) do
			if timingData.measure < measure then
				prevTiming = timingData
			elseif timingData.measure == measure then
				table.insert(currentTimings, timingData)
			end
		end
		if (#currentTimings > 0) and (currentTimings[1].part == 0) then
			prevTiming = nil
		else
			table.insert(currentTimings, 1, {
				measure = measure,
				part = 0,
				bpm = prevTiming.bpm,
			})
		end
		local out = {}
		for index = 1, #currentTimings do
			local timingData = currentTimings[index]
			local timingDataPart = currentTimings[index].part
			local nextTimingDataPart = 1
			if index ~= #currentTimings then
				nextTimingDataPart = currentTimings[index + 1].part
			end
			local signature = getSignature(measure)
			table.insert(out, {
				length = (60000 / timingData.bpm) * signature * 4 * (nextTimingDataPart - timingDataPart),
				part = timingDataPart
			})
		end
		return out
	end
	local getFullLengthOfMeasure = function(measure)
		measureTiming = getMeasureTiming(measure)
		local length = 0
		for timingIndex, timingData in ipairs(measureTiming) do
			length = length + timingData.length
		end
		return length
	end
	local getPointOffset = function(pointIndex, pointCount, measure)
		measureTiming = getMeasureTiming(measure)
		local part = (pointIndex - 1) / pointCount
		
		local offset = 0
		for timingDataIndex = 1, #measureTiming do
			local timingData = measureTiming[timingDataIndex]
			local nextTimingData = measureTiming[timingDataIndex + 1]
			if timingDataIndex ~= #measureTiming then
				if nextTimingData.part < part then
					offset = offset + timingData.length
				elseif nextTimingData.part == part then
					offset = offset + timingData.length
					break
				else
					offset = offset + timingData.length * (part - timingData.part)
					break
				end
			else
				offset = offset + timingData.length * (part - timingData.part)
			end
		end
		return offset
	end
	
	for channel, channelData in pairs(self.channels) do
		for measure, data in pairs(channelData) do
			local globalOffset = 0
			for i = 0, measure - 1 do
				globalOffset = globalOffset + getFullLengthOfMeasure(i)
			end
			
			if channel ~= 2 then
				for pointsIndex, points in ipairs(data) do
					local pointOffset = 0
					for pointIndex, point in ipairs(points) do
						if point ~= "00" then
							local startTime = globalOffset + pointOffset
							self.timedChannels[channel] = self.timedChannels[channel] or {}
							table.insert(self.timedChannels[channel], {
								startTime = startTime,
								point = point,
								measure = measure,
								part = (pointIndex - 1) / #points,
								pointIndex = pointIndex
							})
						end
						pointOffset = getPointOffset(pointIndex + 1, #points, measure)
					end
				end
			else
				self.timedChannels[channel] = self.timedChannels[channel] or {}
				table.insert(self.timedChannels[channel], {
					startTime = globalOffset,
					measure = measure,
					point = data[1]
				})
			end
		end
		table.sort(self.timedChannels[channel], function(a, b)
			return a.startTime < b.startTime
		end)
	end
	for i, channel in pairs({3, 8}) do
		if self.timedChannels[channel] then
			for index, timingPoint in ipairs(self.timedChannels[channel]) do
				for index, timingData in ipairs(self.timingData) do
					if timingPoint.measure == timingData.measure and timingPoint.part == timingData.part then
						timingData.startTime = timingPoint.startTime
					end
				end
			end
		end
	end
	-- for i, v in ipairs(self.timingData) do
		-- print(v.startTime, v.part, v.measure, v.bpm)
	-- end
	-- error()
	-- for i, v in ipairs(self.timedChannels[3]) do
		-- print(v.startTime, v.point, v.measure, v.pointIndex)
	-- end
	-- error()
	-----------------
	
	for timingPointIndex = 1, #self.timingData do
		local timingData = self.timingData[timingPointIndex]
		timingData.beatLength = 60000 / timingData.bpm
		
		table.insert(self.timingPoints, self.TimingPoint:new({beatmap = self}):import(timingData))
		local current = self.timingPoints[#self.timingPoints]
		local prev = self.timingPoints[#self.timingPoints - 1]
		
		if #self.timingPoints == 1 and current.startTime > 0 then
			self.timingPoints[2] = current
			self.timingPoints[2].index = 2
			self.timingPoints[1] = self.TimingPoint:new({beatmap = self}):import(timingData)
			current = self.timingPoints[2]
			prev = self.timingPoints[1]
			prev.index = 1
			prev.startTime = 0
			prev.endTime = current.startTime
		end
		
		if prev and not prev.endTime then prev.endTime = current.startTime end
	end
	-- self.timingPoints[#self.timingPoints].endTime = self.audioDuration
	
	-- local beatLength2beatLengths = {}
	-- local beatLengths = {}
	-- for timingPointIndex = 1, #self.timingPoints do
		-- local current = self.timingPoints[timingPointIndex]
		
		-- current.lengthTime = current.endTime - current.startTime
		-- beatLength2beatLengths[current.beatLength] = beatLength2beatLengths[current.beatLength] or {current.beatLength, 0, #beatLengths + 1}
		-- beatLength2beatLengths[current.beatLength][2] = beatLength2beatLengths[current.beatLength][2] + current.lengthTime
		-- beatLengths[beatLength2beatLengths[current.beatLength][3]] = beatLength2beatLengths[current.beatLength]
	-- end
	-- table.sort(beatLengths, function(a, b)
		-- return a[2] > b[2]
	-- end)
	-- self.baseBeatLenght = beatLengths[1][1]
	
	for timingPointIndex = 1, #self.timingPoints do
		local current = self.timingPoints[timingPointIndex]
		-- local prev = self.timingPoints[timingPointIndex - 1]
		
		-- current.velocity = self.baseBeatLenght / current.beatLength
		current.velocity = 1
	end
	self.timingPoints[#self.timingPoints].endTime = math.huge
	
	for channel, key in pairs(self.channel2key) do
		if self.timedChannels[channel] then
			for index, hitObject in ipairs(self.timedChannels[channel]) do
				table.insert(hitObjectsSection, {
					startTime = hitObject.startTime,
					hitSoundsList = {
						self.wav[hitObject.point]
					},
					key = key
				})
			end
		end
	end
	for hitObjectIndex = 1, #hitObjectsSection do
		local line = hitObjectsSection[hitObjectIndex]
		table.insert(self.hitObjects, self.HitObject:new({beatmap = self}):import(line))
	end
	
	self.audioDuration = self.hitObjects[#self.hitObjects].startTime
	local soundData = love.sound.newSoundData(44100 * self.audioDuration / 1000)
	self.audio = love.audio.newSource(soundData)
	
	if self.timedChannels[1] then
		for index, eventSample in ipairs(self.timedChannels[1]) do
			if self.wav[eventSample.point] then
				table.insert(self.eventSamples, {
					startTime = eventSample.startTime,
					fileName = self.wav[eventSample.point]
				})
			end
		end
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
