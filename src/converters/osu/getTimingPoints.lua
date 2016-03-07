--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getTimingPoints(fileLines, first, last)
	if data.beatmap.timing == nil then
		data.beatmap.timing = {
			all = {},
			global = nil,
			current = nil,
			barlines = {}
		}
	end
	for numberLine = first, last do
		local line = fileLines[numberLine]
		
		local raw = explode(",", line)
		
		local time = math.ceil(tonumber(raw[1]))
		
		local type = 1
		local value = -100
		if tonumber(raw[7]) == 0 then
			type = 1
			value = -100 / tonumber(raw[2])
		elseif tonumber(raw[7]) == 1 then
			type = 0
			value = tonumber(raw[2])
		end
		
		local volume = tonumber(raw[6])/100
		
		if #data.beatmap.timing.all == 0 and time > 0 then
			table.insert(data.beatmap.timing.all, {type = type, time = 0, endtime = time, value = value, volume = volume})
		end
		table.insert(data.beatmap.timing.all, {type = type, time = time, endtime = endtime, value = value, volume = volume})
		if #data.beatmap.timing.all > 1 then
			data.beatmap.timing.all[#data.beatmap.timing.all - 1].endtime = time
		end
		if numberLine == last then
			data.beatmap.timing.all[#data.beatmap.timing.all].endtime = 3600000
		end
	end
end

return getTimingPoints
