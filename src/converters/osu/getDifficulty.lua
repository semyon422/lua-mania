--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getGeneral(fileLines, bStart, bEnd)
	for numberLine = bStart, bEnd do
		local line = fileLines[numberLine]
		
		if data.beatmap.info == nil then data.beatmap.info = {} end
		if string.sub(line, 1, 10) == "CircleSize" then
			data.beatmap.info.keymode = tonumber(trim(string.sub(line, 12, -1)))
		end
		if string.sub(line, 1, 17) == "OverallDifficulty" then
			data.beatmap.info.overallDifficulty = tonumber(trim(string.sub(line, 19, -1)))
		end
	end
end

return getGeneral
