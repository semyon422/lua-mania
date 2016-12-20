local init = function(Beatmap, osu)
--------------------------------
local compute = function(self)
	print("  computing beatmap...")
	print("    loading audio...")
	if self.audioFilename ~= "virtual" then
		local sourceType = mainConfig:get("game.vsrg.audioSourceType", "stream")
		self.audio = love.audio.newSource(self.mapPath .. "/" .. self.audioFilename, sourceType)
	else
		local lastHitObject = self.hitObjects[#self.hitObjects]
		local samples = 44100 * (600)
		local soundData = love.sound.newSoundData(samples)
		self.audio = love.audio.newSource(soundData)
	end
	self.audioDuration = self.audio:getDuration("seconds") * 1000
	print("    complete!")
	
	print("    computing timing points...")
	for timingPointIndex = 1, #self.sections.timingPoints do
		local line = self.sections.timingPoints[timingPointIndex]
		
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
		
		if current.inherited then
			current.velocity = -100 / current.baseBeatLenght * self.baseBeatLenght / current.beatLength
		else
			current.velocity = self.baseBeatLenght / current.beatLength
		end
	end
	self.timingPoints[#self.timingPoints].endTime = math.huge
	print("    complete!")	

	print("    computing hitobjects...")
	for hitObjectIndex = 1, #self.sections.hitObjects do
		local line = self.sections.hitObjects[hitObjectIndex]
		table.insert(self.hitObjects, self.HitObject:new({beatmap = self}):import(line))
	end
	print("    complete!")

	print("    computing barlines...")
	self.barlines = {}
	print("      skipping, not optimised")
	--[[for _, timingPoint in ipairs(self.timingPoints) do
		local step = math.max(1, timingPoint.beatLength * timingPoint.timingSignature)
		for startTime = timingPoint.startTime, timingPoint.endTime, step do
			if startTime < timingPoint.endTime then
				table.insert(self.barlines, self.Barline:new({startTime = startTime, beatmap = self}))
			end
			if startTime >= self.audioDuration then
				break
			end
		end
	end]]
	print("    complete!")
	print("  complete!")
end

return compute
--------------------------------
end

return init
