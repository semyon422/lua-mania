local convert = function()
	local newMap = {}
	
	newMap.info = newMap.info or {}
	
	newMap.info.audioFilename = luaMania.map.General["AudioFilename"]
	newMap.info.audioLeadIn = luaMania.map.General["AudioLeadIn"]
	newMap.info.previewTime = luaMania.map.General["PreviewTime"]
	newMap.info.sampleSet = luaMania.map.General["SampleSet"]
	newMap.info.mode = luaMania.map.General["Mode"]
	
	newMap.info.title = luaMania.map.Metadata["TitleUnicode"]
	newMap.info.artist = luaMania.map.Metadata["ArtistUnicode"]
	newMap.info.creator = luaMania.map.Metadata["Creator"]
	newMap.info.version = luaMania.map.Metadata["Version"]
	newMap.info.source = luaMania.map.Metadata["Source"]
	newMap.info.tags = luaMania.map.Metadata["Tags"]
	
	newMap.info.keymode = luaMania.map.Difficulty["CircleSize"]
	newMap.info.overallDifficulty = luaMania.map.Difficulty["OverallDifficulty"]
	newMap.info.sliderMultiplier = luaMania.map.Difficulty["SliderMultiplier"]
	
	newMap.timing = newMap.timing or {all = {}}
	for timingPointIndex = 1, #luaMania.map.TimingPoints do
		local oldTimingPoint = luaMania.map.TimingPoints[timingPointIndex]
		local timingPoint = {}
		
		timingPoint.startTime = oldTimingPoint.offset
		if oldTimingPoint.timingChange == 0 then
			timingPoint.beatLength = newMap.timing.all[#newMap.timing.all].beatLength
			timingPoint.velocity = -100 / oldTimingPoint.beatLength
		else
			timingPoint.beatLength = oldTimingPoint.beatLength
			timingPoint.velocity = 1
		end
		timingPoint.signature = oldTimingPoint.timingSignature
		timingPoint.sampleSetId = oldTimingPoint.sampleSetId
		timingPoint.customSampleIndex = oldTimingPoint.customSampleIndex
		timingPoint.volume = oldTimingPoint.sampleVolume
		timingPoint.kiai = oldTimingPoint.kiaiTimeActive
		
		if #newMap.timing.all ~= 0 then
			newMap.timing.all[#newMap.timing.all].endTime = timingPoint.startTime - 1
		end
		table.insert(newMap.timing.all, timingPoint)
	end
	newMap.timing.all[#newMap.timing.all].endTime = 3600000
	
	local cache = luaMania.cache.data[luaMania.cache.position]
	newMap.objects = newMap.objects or {clean = {}, current = {}, missed = {}, hitSounds = {}, count = 0}
	newMap.hitSounds = {}
	newMap.path = cache.path
	newMap.pathFile = cache.pathFile
	newMap.pathAudio = cache.pathAudio
	newMap.audio = love.audio.newSource(cache.pathAudio)
	local interval = 512 / newMap.info.keymode
	for hitObjectIndex = 1, #luaMania.map.HitObjects do
		local oldHitObject = luaMania.map.HitObjects[hitObjectIndex]
		local hitObject = {}
		
		hitObject.key = 0
		for newKey = 1, newMap.info.keymode do
			if oldHitObject.x >= interval * (newKey - 1) and oldHitObject.x < newKey * interval then
				hitObject.key = newKey
			end
		end
		
		if bit.band(oldHitObject.type, 1) == 1 then
			hitObject.type = 1
		else
			hitObject.type = 2
		end
		hitObject.state = 0
		
		hitObject.startTime = oldHitObject.startTime
		hitObject.endTime = oldHitObject.endTime
		
		newMap.objects.clean[hitObject.startTime] = newMap.objects.clean[hitObject.startTime] or {}
		newMap.objects.clean[hitObject.startTime][hitObject.key] = newMap.objects.clean[hitObject.startTime][hitObject.key] or {}
		newMap.objects.clean[hitObject.startTime][hitObject.key] = hitObject
	end
	
	newMap.stats = {
		hits = {},
		combo = {
			current = 0,
			max = 0
		},
		currentTime = -newMap.info.audioLeadIn,
		startTime = love.timer.getTime()
	}
	luaMania.map = newMap
end

return convert