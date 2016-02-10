local function lm2lua(self, cache)

	data.beatmap = {}
	beatmap = data.beatmap
	beatmap.HitObjectsCount = 0
	beatmap.General = {}
	beatmap.General["CircleSize"] = 4
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	beatmap.title = cache.title
	beatmap.artist = cache.artist
	beatmap.difficulity = cache.difficulity
	beatmap.audioFile = cache.audioFile
	beatmap.currentNote = {}
	beatmap.missedHitObjects = {}
		beatmap.audio = love.audio.newSource(cache.pathAudio)
	
	beatmap.HitSounds = {}
	local file = io.open(beatmap.pathFile, "r")
	local tblLines = {}
	for line in file:lines() do
		table.insert(tblLines, line)
	end
	file:close()
	
	local eventsLine = 0
	for n,line in pairs(tblLines) do
		if string.sub(line, 1, 13) == "audioFilename" then
			beatmap.audioFile = string.sub(line, 15, -1)
		end
		if string.sub(line, 1, 5) == "title" then
			beatmap.title = string.sub(line, 7, -1)
		end
		if string.sub(line, 1, 6) == "events" then
			eventsLine = n
			break
		end
	end
	
	beatmap.events = {}
	beatmap.events.offset = 0
	beatmap.events.BPM = 120
	beatmap.events.volume = 30
	beatmap.events.beatDivisor = 12
	local beatTime = 60 * 1000 / beatmap.events.BPM
	local tact = 0
	local subTact = 0
	local key = 1
	local type = {1,0}
	local time = 0
	local lenght = 0
	local endtime = 0
	local hitsound = nil
	local image = nil
	local tempLine = {}
	local tempKey = {}
	
	for line = eventsLine + 1, #tblLines do
		if string.sub(tblLines[line], 1, 1) == "#" then
			tempLine = explode(",", tblLines[line])
			if tempLine[1] ~= nil then
				tact = tonumber(string.sub(tempLine[1], 2, -1))
			end
			if tempLine[2] ~= nil then
				beatmap.events.offset = tonumber(string.sub(tempLine[2], 1, -1))
			end
			if tempLine[3] ~= nil then
				beatmap.events.BPM = tonumber(string.sub(tempLine[3], 1, -1))
				beatTime = 60 * 1000 / beatmap.events.BPM
			end
			if tempLine[4] ~= nil then
				beatmap.events.volume = tonumber(string.sub(tempLine[4], 1, -1))
			end
			if tempLine[5] ~= nil then
				beatmap.events.beatDivisor = tonumber(string.sub(tempLine[5], 1, -1))
			end
			tempLine = {}
		else
			tempLine = explode(",", tblLines[line])
			if tempLine[1] ~= nil then
				subTact = tonumber(string.sub(tempLine[1], 1, -1))
			end
			time = math.floor(beatmap.events.offset + (tact + subTact / beatmap.events.beatDivisor) * 4 * beatTime)
			beatmap.events[time] = {}
			for ikey = 1, #tempLine - 1 do
				tempKey = explode(":", tempLine[ikey + 1])
				if tempKey[1] ~= nil then
					key = tonumber(string.sub(tempKey[1], 1, -1))
				end
				if tempKey[2] ~= nil then
					type = {tonumber(string.sub(tempKey[2], 1, -1)), 0}
				end
				if tempKey[3] ~= nil then
					lenght = tonumber(string.sub(tempKey[3], 1, -1))
					endtime = math.floor(beatmap.events.offset + (tact + subTact / beatmap.events.beatDivisor + lenght / beatmap.events.beatDivisor) * 4 * beatTime)
				end
				if tempKey[4] ~= nil then
					hitsound = string.sub(tempKey[4], 1, -1)
				end
				if tempKey[5] ~= nil then
					image = tonumber(string.sub(tempKey[5], 1, -1))
				end
				
				tempKey = {}
				beatmap.events[time][key] = {type, time, endtime, hitsound, image}
				print(time .. " => " .. type[1])
				type = {1,0}
			end
		end
		if string.sub(line, 1, 2) == "#e" then break end
	end
	
	
	beatmap.HitObjects = beatmap.events
end

return lm2lua