local osuImport = function(filePath)
	local map = {}
	local osuMap = osu.beatmap.import(filePath)
	local breakedPath = explode("/", filePath)
	local mapFileName = breakedPath[#breakedPath]
	breakedPath = nil
	local mapPath = string.sub(filePath, 1, #filePath - #mapFileName)
	
	map.info = {}
	
	map.info.audioFileName = osuMap.General.AudioFilename
	map.info.audioLeadIn = osuMap.General.AudioLeadIn
	map.info.previewTime = osuMap.General.PreviewTime
	map.info.sampleSet = osuMap.General.SampleSet
	map.info.mode = osuMap.General.Mode
	
	map.info.title = osuMap.Metadata.TitleUnicode
	map.info.artist = osuMap.Metadata.ArtistUnicode
	map.info.creator = osuMap.Metadata.Creator
	map.info.version = osuMap.Metadata.Version
	map.info.source = osuMap.Metadata.Source
	map.info.tags = osuMap.Metadata.Tags
	
	map.info.circleSize = osuMap.Difficulty.CircleSize
	map.info.keymode = osuMap.Difficulty.CircleSize
	map.info.overallDifficulty = osuMap.Difficulty.OverallDifficulty
	map.info.sliderMultiplier = osuMap.Difficulty.SliderMultiplier
	
	map.mapPath = mapPath
	map.mapFileName = mapFileName
	map.audioFilePath = mapPath .. map.info.audioFileName
	map.audio = love.audio.newSource(map.audioFilePath)
	
	map.timingPoints = {}
	for timingPointIndex = 1, #osuMap.TimingPoints do
		local osuTimingPoint = osuMap.TimingPoints[timingPointIndex]
		local timingPoint = {}
		
		timingPoint.startTime = osuTimingPoint.offset
		if osuTimingPoint.timingChange == 0 then
			timingPoint.beatLength = map.timingPoints[#map.timingPoints].beatLength
			timingPoint.velocity = -100 / timingPoint.beatLength
		else
			timingPoint.beatLength = osuTimingPoint.beatLength
			timingPoint.velocity = 1
		end
		timingPoint.signature = osuTimingPoint.timingSignature
		timingPoint.sampleSetId = osuTimingPoint.sampleSetId
		timingPoint.customSampleIndex = osuTimingPoint.customSampleIndex
		timingPoint.volume = osuTimingPoint.sampleVolume
		timingPoint.kiai = osuTimingPoint.kiaiTimeActive
		
		if #map.timingPoints ~= 0 then
			map.timingPoints[#map.timingPoints].endTime = timingPoint.startTime - 1
		end
		table.insert(map.timingPoints, timingPoint)
	end
	map.timingPoints[#map.timingPoints].endTime = 3600000
	
	map.hitObjects = {}
	map.hitSounds = {}
	for hitObjectIndex = 1, #osuMap.HitObjects do
		local osuHitObject = osuMap.HitObjects[hitObjectIndex]
		local hitObject = {}
		
		hitObject.x = osuHitObject.x
		hitObject.y = osuHitObject.y
		
		if bit.band(osuHitObject.type, 1) == 1 then
			hitObject.type = 1
		else
			hitObject.type = 2
		end
		hitObject.state = 0
		
		hitObject.startTime = osuHitObject.startTime
		hitObject.endTime = osuHitObject.endTime
		
		hitObject.hitSound = {osuHitObject.hitSound, osuHitObject.hitSoundVolume}
		
		table.insert(map.hitObjects, hitObject)
		
		for _, filename in pairs(osuHitObject.hitSound) do
			if not map.hitSounds[filename] then
				map.hitSounds[filename] = love.audio.newSource(helpers.getFilePath(filename), "static")
			end
		end
	end
	
	map.stats = {
		hits = {},
		combo = {
			current = 0,
			max = 0
		},
		currentTime = -map.info.audioLeadIn,
		startTime = love.timer.getTime()
	}
	
	return map
end

return osuImport