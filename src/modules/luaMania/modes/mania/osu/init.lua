local convert = function()
	local newMap = {}
	
	newMap.info = newMap.info or {}
	
	newMap.info.audioFilename = luaMania.state.map.General["AudioFilename"]
	newMap.info.audioLeadIn = luaMania.state.map.General["AudioLeadIn"]
	newMap.info.previewTime = luaMania.state.map.General["PreviewTime"]
	newMap.info.sampleSet = luaMania.state.map.General["SampleSet"]
	newMap.info.mode = luaMania.state.map.General["Mode"]
	
	newMap.info.title = luaMania.state.map.Metadata["TitleUnicode"]
	newMap.info.artist = luaMania.state.map.Metadata["ArtistUnicode"]
	newMap.info.creator = luaMania.state.map.Metadata["Creator"]
	newMap.info.version = luaMania.state.map.Metadata["Version"]
	newMap.info.source = luaMania.state.map.Metadata["Source"]
	newMap.info.tags = luaMania.state.map.Metadata["Tags"]
	
	newMap.info.keymode = luaMania.state.map.Difficulty["CircleSize"]
	newMap.info.overallDifficulty = luaMania.state.map.Difficulty["OverallDifficulty"]
	newMap.info.sliderMultiplier = luaMania.state.map.Difficulty["SliderMultiplier"]
	
	newMap.timing = newMap.timing or {all = {}}
	for timingPointIndex = 1, #luaMania.state.map.TimingPoints do
		local oldTimingPoint = luaMania.state.map.TimingPoints[timingPointIndex]
		local timingPoint = {}
		
		timingPoint.offset = oldTimingPoint.offset
		timingPoint.beatLength = oldTimingPoint.beatLength
		timingPoint.timingSignature = oldTimingPoint.timingSignature
		timingPoint.sampleSetId = oldTimingPoint.sampleSetId
		timingPoint.customSampleIndex = oldTimingPoint.customSampleIndex
		timingPoint.sampleVolume = oldTimingPoint.sampleVolume
		timingPoint.timingChange = oldTimingPoint.timingChange
		timingPoint.kiaiTimeActive = oldTimingPoint.kiaiTimeActive
		
		table.insert(newMap.timing.all, timingPoint)
	end
	
	local cache = luaMania.data.cache[luaMania.state.cachePosition]
	newMap.objects = newMap.objects or {clean = {}, current = {}, missed = {}, count = 0}
	newMap.hitSounds = {}
	newMap.path = cache.path
	newMap.pathFile = cache.pathFile
	newMap.pathAudio = cache.pathAudio
	newMap.audio = love.audio.newSource(cache.pathAudio)
	for hitObjectIndex = 1, #luaMania.state.map.HitObjects do
		local oldHitObject = luaMania.state.map.HitObjects[hitObjectIndex]
		local hitObject = {}
		
		hitObject.x = hitObject.x
		hitObject.y = hitObject.x
		hitObject.type = hitObject.x
		hitObject.startTime = hitObject.x
		hitObject.hitSound = hitObject.x
		
		table.insert(newMap.objects.clean, hitObject)
	end
	
end

return convert