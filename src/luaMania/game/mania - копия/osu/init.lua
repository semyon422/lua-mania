local convert = function(map)
	local newMap = {}
	
	newMap.info = newMap.info or {}
	
	newMap.info.audioFilename = map.General["AudioFilename"]
	newMap.info.audioLeadIn = map.General["AudioLeadIn"]
	newMap.info.previewTime = map.General["PreviewTime"]
	newMap.info.sampleSet = map.General["SampleSet"]
	newMap.info.mode = map.General["Mode"]
	
	newMap.info.title = map.Metadata["TitleUnicode"]
	newMap.info.artist = map.Metadata["ArtistUnicode"]
	newMap.info.creator = map.Metadata["Creator"]
	newMap.info.version = map.Metadata["Version"]
	newMap.info.source = map.Metadata["Source"]
	newMap.info.tags = map.Metadata["Tags"]
	
	newMap.info.keymode = map.Difficulty["CircleSize"]
	newMap.info.overallDifficulty = map.Difficulty["OverallDifficulty"]
	newMap.info.sliderMultiplier = map.Difficulty["SliderMultiplier"]
	
	newMap.timing = newMap.timing or {all = {}}
	for timingPointIndex = 1, #map.TimingPoints do
		local oldTimingPoint = map.TimingPoints[timingPointIndex]
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
	newMap.hitSoundsQueue = {}
	newMap.path = cache.path
	newMap.pathFile = cache.pathFile
	newMap.pathAudio = cache.pathAudio
	newMap.audio = love.audio.newSource(cache.pathAudio)
	local interval = 512 / newMap.info.keymode
	for hitObjectIndex = 1, #map.HitObjects do
		local oldHitObject = map.HitObjects[hitObjectIndex]
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
		newMap.objects.clean[hitObject.startTime][hitObject.key] = hitObject
		
		newMap.hitSoundsQueue[hitObject.key] = newMap.hitSoundsQueue[hitObject.key] or {}
		table.insert(newMap.hitSoundsQueue[hitObject.key], {oldHitObject.hitSound, oldHitObject.hitSoundVolume})
		for _, filename in pairs(oldHitObject.hitSound) do
			if not newMap.hitSounds[filename] then
				newMap.hitSounds[filename] = love.audio.newSource(helpers.getFilePath(filename))
			end
		end
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
	return newMap
end

return convert