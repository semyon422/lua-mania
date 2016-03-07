--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getGeneral(fileLines, first, last, cache)
	if data.beatmap.objects == nil then
		data.beatmap.objects = {
			clean = {},
			current = {},
			missed = {},
			count = 0
		}
		data.beatmap.hitSounds = {}
		data.beatmap.path = cache.path
		data.beatmap.pathFile = cache.pathFile
		data.beatmap.pathAudio = cache.pathAudio
		if cache.audioFile ~= "virtual" then
			data.beatmap.audio = love.audio.newSource(cache.pathAudio)
		else
			data.beatmap.audio = nil
		end
	end
	local interval = 512 / data.beatmap.info.keymode
	local getHitSound = require("src.converters.osu.getHitObjects.getHitSound")
	
	for numberLine = first, last do
		local line = fileLines[numberLine]
	
		local raw = explode(",", line)
		
		local time = tonumber(raw[3])
		if time == nil then break end
		if data.beatmap.objects.clean[time] == nil then
			data.beatmap.objects.clean[time] = {}
		end
		
		local key = 0
		for newKey = 1, data.beatmap.info.keymode do
			if tonumber(raw[1]) >= interval * (newKey - 1) and tonumber(raw[1]) < newKey * interval then
				key = newKey
			end
		end
		
		local noteData = explode(":", raw[#raw])
		
		local type = {1, 0}
		local endtime = tonumber(noteData[1])
		if raw[4] == "128" then
			type = {2, 0}
			endtime = tonumber(noteData[1])
		end
		
		
		if data.beatmap.info.sampleSet == "None" then
			data.beatmap.info.sampleSet = "Soft"
		end
		
		local volume = tonumber(noteData[#noteData - 1]) / 100
		local hitSound = {osu:removeExtension(trim(tostring(noteData[#noteData])))}
		if hitSound[1] == "" then
			hitSound = getHitSound(tonumber(raw[5]))
			volume = 1
		end
		
		if data.beatmap.hitSounds[key] == nil then data.beatmap.hitSounds[key] = {} end
		table.insert(data.beatmap.hitSounds[key], {hitSound, volume})
		
		data.beatmap.objects.clean[time][key] = {type, time, endtime}
		data.beatmap.objects.count = data.beatmap.objects.count + 1
	end
end

return getGeneral

