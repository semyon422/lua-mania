--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getHitObjects(fileLines, first, last, cache)
	if data.beatmap.objects == nil then
		data.beatmap.objects = {
			clean = {},
			current = {},
			missed = {},
			count = 0
		}
		data.beatmap.hitSounds = {{},{},{},{}}
		data.beatmap.path = cache.path
		data.beatmap.pathFile = cache.pathFile
		data.beatmap.pathAudio = cache.pathAudio
		if cache.audioFile ~= "virtual" then
			data.beatmap.audio = love.audio.newSource(cache.pathAudio)
		else
			data.beatmap.audio = nil
		end
	end
	data.beatmap.info.keymode = 4
	
	local getHitSound = require("src.converters.osu.getHitObjects.getHitSound")
	local getTaikoColors = require("src.converters.osu.getHitObjects.getTaikoColors")
	
	local sider = -1
	local sideb = -1
	local function getKey(key)
		if key == "blue" then
			key = -2
			key = key * sideb
			sideb = -sideb
		elseif key == "red" then
			key = -1
			key = key * sider
			sider = -sider
		end
		
		if key == -2 then return 1
		elseif key == -1 then return 2
		elseif key == 1 then return 3
		elseif key == 2 then return 4
		end
	end
	
	for numberLine = first, last do
		local line = fileLines[numberLine]
	
		local raw = explode(",", line)
		
		local time = tonumber(raw[3])
		if data.beatmap.objects.clean[time] == nil then
			data.beatmap.objects.clean[time] = {}
		end
		
		local noteData = explode(":", raw[#raw])
		
		if data.beatmap.info.sampleSet == "None" then
			data.beatmap.info.sampleSet = "Soft"
		end
		
		local volume = tonumber(noteData[#noteData - 1]) / 100
		local hitSound = {osu:removeExtension(trim(tostring(noteData[#noteData])))}
		if hitSound[1] == "" then
			hitSound = getHitSound(tonumber(raw[5]))
			volume = 1
		end
		
		local type = {1, 0}
		if raw[4] == "12" then
			type = {2, 0}
			endtime = tonumber(raw[6])
		end
		
		local color = getTaikoColors(tonumber(raw[5]), 2)
		if #color == 1 then
			if color == "b" then
				key = getKey("blue")
				data.beatmap.objects.clean[time][key] = {{1,0}, time, endtime}
				table.insert(data.beatmap.hitSounds[key], {hitSound, volume})
			elseif color == "r" then
				key = getKey("red")
				data.beatmap.objects.clean[time][key] = {{1,0}, time, endtime}
				table.insert(data.beatmap.hitSounds[key], {hitSound, volume})
			end
			
			data.beatmap.objects.count = data.beatmap.objects.count + 1
		elseif #color == 2 then
			if color == "bb" then
				data.beatmap.objects.clean[time][1] = {{1,0}, time, endtime}
				data.beatmap.objects.clean[time][4] = {{1,0}, time, endtime}
				table.insert(data.beatmap.hitSounds[1], {hitSound, volume})
				table.insert(data.beatmap.hitSounds[4], {hitSound, volume})
			elseif color == "rr" then
				data.beatmap.objects.clean[time][2] = {{1,0}, time, endtime}
				data.beatmap.objects.clean[time][3] = {{1,0}, time, endtime}
				table.insert(data.beatmap.hitSounds[2], {hitSound, volume})
				table.insert(data.beatmap.hitSounds[3], {hitSound, volume})
			end
		
			data.beatmap.objects.count = data.beatmap.objects.count + 2
		end
		
	end
end

return getHitObjects
