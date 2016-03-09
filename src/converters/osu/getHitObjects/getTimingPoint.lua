--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getTimingPoint(time)
	for index,timingPoint in pairs(data.beatmap.timing.all) do
		if time >= timingPoint.startTime and time <= timingPoint.endTime then
			return data.beatmap.timing.all[index]
		end
	end
end

return getTimingPoint
