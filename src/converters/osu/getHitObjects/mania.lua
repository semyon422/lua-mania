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
	
	if data.beatmap.info.sampleSet == "None" then
		data.beatmap.info.sampleSet = "Soft"
	end
	
	local noteSyntax = {
		x = 1,
		y = 2,
		startTime = 3,
		type = 4,
		hitSound = 5,
		addition = 6
	}
	
	for numberLine = first, last do
		local line = fileLines[numberLine]
		
		local raw = explode(",", line)
		
		local x, y, startTime, type, hitSound, endTime, addition, volume
		local syntax = noteSyntax
		
		type = tonumber(raw[4])
		
		if type == 1 or type == 5 then
			type = {1, 0}
		elseif type == 128 then
			type = {2, 0}
		end
		
		local startTime = tonumber(raw[3])
		if startTime == nil then break end
		if data.beatmap.objects.clean[startTime] == nil then
			data.beatmap.objects.clean[startTime] = {}
		end
		
		local key = 0
		for newKey = 1, data.beatmap.info.keymode do
			if tonumber(raw[syntax.x]) >= interval * (newKey - 1) and tonumber(raw[syntax.x]) < newKey * interval then
				key = newKey
			end
		end
		
		if raw[syntax.addition] ~= nil then
			local addition = explode(":", raw[syntax.addition])
			if type[1] == 2 then
				endTime = tonumber(addition[1])
			end
		
			volume = tonumber(addition[#addition - 1]) / 100
			hitSound = {osu:removeExtension(trim(tostring(addition[#addition])))}
			if hitSound[1] == "" then
				hitSound = getHitSound(tonumber(raw[syntax.hitSound]))
				volume = 1
			end
		else
			volume = 1
			hitSound = getHitSound(tonumber(raw[syntax.hitSound]))
		end
		
		if data.beatmap.hitSounds[key] == nil then data.beatmap.hitSounds[key] = {} end
		table.insert(data.beatmap.hitSounds[key], {hitSound, volume})
		
		data.beatmap.objects.clean[startTime][key] = {type = type, startTime = startTime, endTime = endTime}
		data.beatmap.objects.count = data.beatmap.objects.count + 1
	end
end

return getHitObjects

