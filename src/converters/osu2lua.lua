local function osu2lua(self, cache)
	data.beatmap = {}
	beatmap = data.beatmap
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	beatmap.title = cache.title
	beatmap.artist = cache.artist
	beatmap.difficulity = cache.difficulity
	beatmap.audioFile = cache.audioFile
	if cache.audioFile ~= "virtual" then
		beatmap.audio = love.audio.newSource(cache.pathAudio)
	else
		beatmap.audio = nil
	end
	
	beatmap.currentNote = {}
	beatmap.missedHitObjects = {}
	
	beatmap.HitSounds = {}
	beatmap.raw = {}
	beatmap.raw.file = io.open(beatmap.pathFile, "r")
	beatmap.raw.array = {}
	beatmap.raw.HitObjects = {}
	beatmap.raw.General = {}
	beatmap.HitObjects = {}
	beatmap.HitObjectsCount = 0
	beatmap.General = {}
	for line in beatmap.raw.file:lines() do
		table.insert(beatmap.raw.array, line)
	end
	beatmap.raw.file:close()
	for globalLine = 1, #beatmap.raw.array do
		if #explode("General]", beatmap.raw.array[globalLine]) == 2 or
		--#explode("Editor", beatmap.raw.array[globalLine]) == 2 or
		#explode("Metadata]", beatmap.raw.array[globalLine]) == 2 or
		#explode("Difficulty]", beatmap.raw.array[globalLine]) == 2 then
			for offset = globalLine + 1, #beatmap.raw.array - globalLine do
				if string.find(beatmap.raw.array[offset], "[", 1, true) then
					break
				end
				localLine = offset - globalLine
				beatmap.raw.General[localLine] = explode(":", beatmap.raw.array[offset])
				beatmap.General[localLine] = {}
				beatmap.General[beatmap.raw.General[localLine][1]] = trim(tostring(beatmap.raw.General[localLine][2]))
			end
		end
		if #explode("HitObjects", beatmap.raw.array[globalLine]) == 2 then
			keymode = tonumber(beatmap.General["CircleSize"])
			interval = 512/keymode
			for offset = globalLine + 1, #beatmap.raw.array do
				local time = nil
				local key = nil
				local type = {1, 0}
				local endtime = nil
				local hitsound = nil
				
				localLine = offset - globalLine
				beatmap.raw.HitObjects[localLine] = explode(",", beatmap.raw.array[offset])
				
				time = tonumber(beatmap.raw.HitObjects[localLine][3])
				if time == nil then break end
				if beatmap.HitObjects[time] == nil then
					beatmap.HitObjects[time] = {}
				end
				
				beatmap.raw.HitObjects[localLine][1] = tonumber(beatmap.raw.HitObjects[localLine][1])
				for nkey = 1, keymode do
					if beatmap.raw.HitObjects[localLine][1] >= nkey * interval - interval and beatmap.raw.HitObjects[localLine][1] < nkey * interval then
						key = nkey
					end
				end
				
				type[1] = 1
				if beatmap.raw.HitObjects[localLine][4] == "128" then
					type[1] = 2
					endtime = tonumber(explode(":", beatmap.raw.HitObjects[localLine][6])[1])
				end
				
				local udata = explode(":", beatmap.raw.HitObjects[localLine][6])
				
				hitsound = self:removeExtension(tostring(udata[#udata]))
				
				if hitsound == "" then
					if beatmap.General["SampleSet"] == "None" then
						beatmap.General["SampleSet"] = "Soft"
					end
					hitsound = string.lower(beatmap.General["SampleSet"]) .. "-hitnormal"
				end
				
				beatmap.HitObjects[time][key] = {type, time, endtime, hitsound}
				beatmap.HitObjectsCount = beatmap.HitObjectsCount + 1
			end
		end
	end
end

return osu2lua