local init = function(Beatmap, lmn)
--------------------------------
local import = function(self, filePath)
	local breakedPath = explode("/", filePath)
	self.mapFileName = breakedPath[#breakedPath]
	self.mapPath = string.sub(filePath, 1, #filePath - #self.mapFileName - 1)
	
	local file = love.filesystem.newFile(filePath)
	file:open("r")
	
	self.timingPoints = {}
	self.hitObjects = {}
	self.eventSamples = {}
	
	local currentBlock = ""
	for line in file:lines() do
		if line:sub(1, 2) == "--" then
			currentBlock = trim(line:sub(3, -1))
		elseif currentBlock == "metadata" then
			if line:sub(1, 5) == "title" then
				self.title = trim(line:sub(7, -1))
			elseif line:sub(1, 6) == "artist" then
				self.artist = trim(line:sub(8, -1))
			elseif line:sub(1, 7) == "mapName" then
				self.mapName = trim(line:sub(9, -1))
			elseif line:sub(1, 7) == "creator" then
				self.creator = trim(line:sub(9, -1))
			elseif line:sub(1, 7) == "keymode" then
				self.keymode = tonumber(trim(line:sub(9, -1)))
			elseif line:sub(1, 5) == "audio" then
				self.audioFileName = trim(line:sub(7, -1))
			end
		elseif currentBlock == "timing" then
			local breaked = explode(",", line)
			if #breaked > 1 then
				local timingPoint = {}
				
				timingPoint.startTime = tonumber(breaked[1])
				timingPoint.beatLength = 60000/tonumber(breaked[2])
				timingPoint.velocity = tonumber(breaked[3])
				timingPoint.index = #self.timingPoints + 1
				
				table.insert(self.timingPoints, timingPoint)
			end
		elseif currentBlock == "hitObjects" then
			local breaked = explode(",", line)
			if #breaked > 1 then
				local hitObject = {}
				
				hitObject.key = tonumber(breaked[1])
				hitObject.startTime = tonumber(breaked[2])
				hitObject.endTime = tonumber(breaked[3])
				hitObject.hitSoundsList = {}
				
				table.insert(self.hitObjects, hitObject)
			end
		end
	end
	
	for timingPointIndex = 2, #self.timingPoints do
		local currentTimingPoint = self.timingPoints[timingPointIndex]
		local previousTimingPoint = self.timingPoints[timingPointIndex - 1]
		
		previousTimingPoint.endTime = currentTimingPoint.startTime - 1
		if timingPointIndex == #self.timingPoints then
			currentTimingPoint.endTime = math.huge
		end
	end
	
	local getTimingPoint = function(time)
		for timingPointIndex, timingPoint in ipairs(self.timingPoints) do
			if time >= timingPoint.startTime and time <= timingPoint.endTime or
				(timingPointIndex == #self.timingPoints and time >= timingPoint.startTime) then
				return timingPoint
			end
		end
		return self.timingPoints[1]
	end
	for hitObjectIndex, hitObject in pairs(self.hitObjects) do
		hitObject.startTimingPoint = getTimingPoint(hitObject.startTime)
		if hitObject.endTime then
			hitObject.endTimingPoint = getTimingPoint(hitObject.endTime)
		end
	end
	
	self.audio = love.audio.newSource(self.mapPath .. "/" .. self.audioFileName)
	
	return self
end

return import
--------------------------------
end

return init
