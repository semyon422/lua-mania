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
	
	if data.beatmap.info.sampleSet == "None" then
		data.beatmap.info.sampleSet = "Soft"
	end
	
	local hitCircleSyntax = {
		x = 1,
		y = 2,
		startTime = 3,
		type = 4,
		hitSound = 5,
		addition = 6
	}
	local sliderSyntax = {
		x = 1,
		y = 2,
		startTime = 3,
		type = 4,
		hitSound = 5,
		sliderType = 6,
		numRepeat = 7,
		pixelLength = 8,
		edgeHitsound = 9,
		edgeAddition = 10,
		addition = 11
	}
	local spinnerSyntax = {
		x = 1,
		y = 2,
		startTime = 3,
		type = 4,
		hitSound = 5,
		endTime = 6,
		addition = 7
	}
	
	for numberLine = first, last do
		local line = fileLines[numberLine]
		
		local raw = explode(",", line)
		
		local x, y, startTime, type, hitSound, endTime, addition, volume
		local syntax = hitCircleSyntax
		
		type = tonumber(raw[4])
		
		if type == 1 or type == 5 then
			type = {1, 0}
			syntax = hitCircleSyntax
		elseif type == 2 or type == 6 then
			type = {2, 0}
			syntax = sliderSyntax
		elseif type == 8 or type == 12 then
			type = {2, 0}
			syntax = spinnerSyntax
		end
		
		local startTime = tonumber(raw[syntax.startTime])
		if data.beatmap.objects.clean[startTime] == nil then
			data.beatmap.objects.clean[startTime] = {}
		end
		
		if syntax.endTime ~= nil then
			endTime = tonumber(raw[syntax.endTime])
		end
		
		if raw[syntax.addition] ~= nil then
			local addition = explode(":", raw[syntax.addition])
		
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
		
		local color = getTaikoColors(tonumber(raw[5]), 2)
		if #color == 1 then
			if color == "b" then
				key = getKey("blue")
				data.beatmap.objects.clean[startTime][key] = {{1,0}, startTime, endTime}
				table.insert(data.beatmap.hitSounds[key], {hitSound, volume})
			elseif color == "r" then
				key = getKey("red")
				data.beatmap.objects.clean[startTime][key] = {{1,0}, startTime, endTime}
				table.insert(data.beatmap.hitSounds[key], {hitSound, volume})
			end
			
			data.beatmap.objects.count = data.beatmap.objects.count + 1
		elseif #color == 2 then
			if color == "bb" then
				data.beatmap.objects.clean[startTime][1] = {{1,0}, startTime, endTime}
				data.beatmap.objects.clean[startTime][4] = {{1,0}, startTime, endTime}
				table.insert(data.beatmap.hitSounds[1], {hitSound, volume})
				table.insert(data.beatmap.hitSounds[4], {hitSound, volume})
			elseif color == "rr" then
				data.beatmap.objects.clean[startTime][2] = {{1,0}, startTime, endTime}
				data.beatmap.objects.clean[startTime][3] = {{1,0}, startTime, endTime}
				table.insert(data.beatmap.hitSounds[2], {hitSound, volume})
				table.insert(data.beatmap.hitSounds[3], {hitSound, volume})
			end
		
			data.beatmap.objects.count = data.beatmap.objects.count + 2
		end
		
	end
end

return getHitObjects
