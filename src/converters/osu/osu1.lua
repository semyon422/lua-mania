--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function osu2lua(self, cache)
	data.beatmap = {}
	local beatmap = data.beatmap
	
	beatmap.file = io.open(cache.pathFile, "r")
	beatmap.fileLines = {}
	local stage = "info"
	beatmap.info = {}
	beatmap.timing = {}
	beatmap.timing.all = {}
	beatmap.timing.global = nil
	beatmap.timing.current = nil
	beatmap.timing.barlines = {}
	beatmap.objects = {}
	beatmap.objects.clean = {}
	beatmap.objects.current = {}
	beatmap.objects.missed = {}
	beatmap.objects.count = 0
	beatmap.hitSounds = {{},{},{},{}}
	
	local side = -1
	local function getKey(key)
		if key == "blue" then key = -2
		elseif key == "red" then key = -1
		end
		
		key = key * side
		side = -side
		
		if key == -2 then return 1
		elseif key == -1 then return 2
		elseif key == 1 then return 3
		elseif key == 2 then return 4
		end
	end
	
	for line in beatmap.file:lines() do
		table.insert(beatmap.fileLines, line)
	end
	for globalLine,line in pairs(beatmap.fileLines) do
		if stage == "info" then
			if string.sub(line, 1, 17) == "osu file format v" then
				beatmap.info.osuFileFormat = string.sub(line, 18, -1)
			end
			if string.sub(line, 1, 13) == "AudioFilename" then
				beatmap.info.audioFilename = trim(string.sub(line, 15, -1))
			end
			if string.sub(line, 1, 11) == "AudioLeadIn" then
				beatmap.info.audioLeadIn = tonumber(trim(string.sub(line, 13, -1)))
			end
			if string.sub(line, 1, 11) == "PreviewTime" then
				beatmap.info.previewTime = tonumber(trim(string.sub(line, 13, -1)))
			end
			if string.sub(line, 1, 9) == "SampleSet" then
				beatmap.info.sampleSet = trim(string.sub(line, 11, -1))
			end
			if string.sub(line, 1, 4) == "Mode" then
				beatmap.info.mode = trim(string.sub(line, 6, -1))
			end
			if string.sub(line, 1, 12) == "TitleUnicode" then
				beatmap.info.title = trim(string.sub(line, 14, -1))
			end
			if string.sub(line, 1, 13) == "ArtistUnicode" then
				beatmap.info.artist = trim(string.sub(line, 15, -1))
			end
			if string.sub(line, 1, 7) == "Creator" then
				beatmap.info.creator = trim(string.sub(line, 9, -1))
			end
			if string.sub(line, 1, 7) == "Version" then
				beatmap.info.version = trim(string.sub(line, 9, -1))
			end
			if string.sub(line, 1, 6) == "Source" then
				beatmap.info.source = trim(string.sub(line, 8, -1))
			end
			if string.sub(line, 1, 4) == "Tags" then
				beatmap.info.tags = trim(string.sub(line, 6, -1))
			end
			if string.sub(line, 1, 10) == "CircleSize" then
				beatmap.info.keymode = 4 --tonumber(trim(string.sub(line, 12, -1)))
			end
			if string.sub(line, 1, 17) == "OverallDifficulty" then
				beatmap.info.overallDifficulty = tonumber(trim(string.sub(line, 19, -1)))
			end
		end
		if string.sub(line, 1, 14) == "[TimingPoints]" then 
			stage = "timing"
		elseif stage == "timing" then
			if trim(string.sub(line, 1, 1)) ~= "[" and trim(explode(",", line)[1]) ~= "" and string.sub(line, 1, 5) ~= "Combo" then
				local time = nil
				local endtime = nil
				local value = -100
				local type = 1
				local volume = 100
				
				local raw = explode(",", line)
				
				time = math.ceil(tonumber(raw[1]))
				
				value = tonumber(raw[2])
				if value < 0 then
					type = 1
					value = -100 / value
				elseif value > 0 then
					type = 0
				end
				
				volume = tonumber(raw[6])/100
				if #beatmap.timing.all == 0 and time > 0 then
					table.insert(beatmap.timing.all, {type = type, time = 0, endtime = time, value = value, volume = volume})
				end
				table.insert(beatmap.timing.all, {type = type, time = time, endtime = endtime, value = value, volume = volume})
				if #beatmap.timing.all > 1 then
					beatmap.timing.all[#beatmap.timing.all - 1].endtime = time
				end
				--if beatmap.timing.global == nil then
				--	beatmap.timing.global = beatmap.timing.all[time]
				--end
				--if beatmap.timing.current == nil then
				--	beatmap.timing.current = beatmap.timing.all[time]
				--end
			end
		end
		if string.sub(line, 1, 12) == "[HitObjects]" then 
			stage = "objects"
		elseif stage == "objects" then
			if string.sub(line, 1, 1) ~= "[" then 
				interval = 512 / beatmap.info.keymode
				local time = nil
				--local key = nil
				local type = {0, 0}
				--local endtime = nil
				local hitSound = nil
				local volume = nil
				
				local raw = explode(",", line)
				
				time = tonumber(raw[3])
				if time == nil then break end
				if beatmap.objects.clean[time] == nil then
					beatmap.objects.clean[time] = {}
				end
				
				local noteData = explode(":", raw[#raw])
				
				--type[1] = 1
				--if raw[4] == "128" then
				--	type[1] = 2
				--	endtime = tonumber(noteData[1])
				--end
				
				hitSound = self:removeExtension(trim(tostring(noteData[#noteData])))
				volume = tonumber(noteData[#noteData - 1]) / 100
				if hitSound == "" then
					volume = nil
					if beatmap.info.sampleSet == "None" then
						beatmap.info.sampleSet = "Soft"
					end
					if raw[5] == "0" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitnormal"}
					end
					if raw[5] == "2" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitwhistle"}
					end
					if raw[5] == "4" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitfinish"}
					end
					if raw[5] == "6" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitwhistle",
									string.lower(beatmap.info.sampleSet) .. "-hitfinish"}
					end
					if raw[5] == "8" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitclap"}
					end
					if raw[5] == "10" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitwhistle",
									string.lower(beatmap.info.sampleSet) .. "-hitclap"}
					end
					if raw[5] == "12" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitfinish",
									string.lower(beatmap.info.sampleSet) .. "-hitclap"}
					end
					if raw[5] == "14" then
						hitSound = {string.lower(beatmap.info.sampleSet) .. "-hitwhistle",
									string.lower(beatmap.info.sampleSet) .. "-hitfinish",
									string.lower(beatmap.info.sampleSet) .. "-hitclap"}
					end
				end
				
				type[1] = 1
				if raw[4] == "12" then
					type[1] = 2
					endtime = tonumber(raw[6])
				end

				if tonumber(raw[5]) == 0 then --little red
					key = getKey("red")
					beatmap.objects.clean[time][key] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[key], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 1
				end
				if tonumber(raw[5]) == 2 then --little blue
					key = getKey("blue")
					beatmap.objects.clean[time][key] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[key], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 1
				end
				if tonumber(raw[5]) == 4 then --big red
					beatmap.objects.clean[time][2] = {{1,0}, time, endtime}
					beatmap.objects.clean[time][3] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[2], {hitSound, volume})
					table.insert(beatmap.hitSounds[3], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 2
				end
				if tonumber(raw[5]) == 6 then --big blue
					beatmap.objects.clean[time][1] = {{1,0}, time, endtime}
					beatmap.objects.clean[time][4] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[1], {hitSound, volume})
					table.insert(beatmap.hitSounds[4], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 2
				end
				if tonumber(raw[5]) == 8 then --little blue
					key = getKey("blue")
					beatmap.objects.clean[time][key] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[key], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 1
				end
				if tonumber(raw[5]) == 10 then --little blue
					key = getKey("blue")
					beatmap.objects.clean[time][key] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[key], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 1
				end
				if tonumber(raw[5]) == 12 then --big blue
					beatmap.objects.clean[time][1] = {{1,0}, time, endtime}
					beatmap.objects.clean[time][4] = {{1,0}, time, endtime}
					table.insert(beatmap.hitSounds[1], {hitSound, volume})
					table.insert(beatmap.hitSounds[4], {hitSound, volume})
					beatmap.objects.count = beatmap.objects.count + 2
				end
			end
		end
	end
	for time,note in pairs(beatmap.objects.clean) do
		if beatmap.timing.all[#beatmap.timing.all].endtime == nil then
			beatmap.timing.all[#beatmap.timing.all].endtime = time + 100
		elseif beatmap.timing.all[#beatmap.timing.all].endtime < time + 100 then
			beatmap.timing.all[#beatmap.timing.all].endtime = time + 100
		end
	end
	
	beatmap.path = cache.path
	beatmap.pathFile = cache.pathFile
	beatmap.pathAudio = cache.pathAudio
	if cache.audioFile ~= "virtual" then
		beatmap.audio = love.audio.newSource(cache.pathAudio)
	else
		beatmap.audio = nil
	end
end

return osu2lua
