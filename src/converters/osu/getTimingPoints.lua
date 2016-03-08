--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getTimingPoints(fileLines, first, last)
	if data.beatmap.timing == nil then
		data.beatmap.timing = {
			all = {},
			current = nil,
			barlines = {}
		}
	end
	
	local timingPointSyntax = {
		offset = 1,
		millisecondsPerBeat = 2,
		meter = 3,
		sampleType = 4,
		sampleSet = 5,
		volume = 6,
		inherited = 7,
		kiaiMode = 8
	}
	
	for numberLine = first, last do
		local line = fileLines[numberLine]
		
		local raw = explode(",", line)
		
		local startTime, beatLength, meter, sampleType, sampleSet, volume, inherited, kiaiMode, endTime, velocity
		local syntax = timingPointSyntax
		
		type = tonumber(raw[syntax.inherited])
		
		if type == 0 then
			velocity = -100 / tonumber(raw[syntax.millisecondsPerBeat])
			beatLength = data.beatmap.timing.all[#data.beatmap.timing.all].beatLength
		elseif type == 1 then
			velocity = 1
			beatLength = tonumber(raw[syntax.millisecondsPerBeat])
		end
		
		local startTime = math.ceil(tonumber(raw[syntax.offset]))
		
		local volume = tonumber(raw[syntax.volume])/100
		
		if #data.beatmap.timing.all == 0 and startTime > 0 then
			table.insert(data.beatmap.timing.all, {startTime = 0, endTime = startTime, beatLength = beatLength, velocity = velocity, volume = volume})
		end
		table.insert(data.beatmap.timing.all, {startTime = startTime, endTime = endTime, beatLength = beatLength, velocity = velocity, volume = volume})
		if #data.beatmap.timing.all > 1 then
			data.beatmap.timing.all[#data.beatmap.timing.all - 1].endTime = startTime
		end
		if numberLine == last then
			data.beatmap.timing.all[#data.beatmap.timing.all].endTime = 3600000
		end
	end
end

return getTimingPoints
