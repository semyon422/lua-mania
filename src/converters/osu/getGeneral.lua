--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getGeneral(fileLines, bStart, bEnd)
	for numberLine = bStart, bEnd do
		local line = fileLines[numberLine]
		
		if data.beatmap.info == nil then data.beatmap.info = {} end
		if string.sub(line, 1, 13) == "AudioFilename" then
			data.beatmap.info.audioFilename = trim(string.sub(line, 15, -1))
		end
		if string.sub(line, 1, 11) == "AudioLeadIn" then
			data.beatmap.info.audioLeadIn = tonumber(trim(string.sub(line, 13, -1)))
		end
		if string.sub(line, 1, 11) == "PreviewTime" then
			data.beatmap.info.previewTime = tonumber(trim(string.sub(line, 13, -1)))
		end
		if string.sub(line, 1, 9) == "SampleSet" then
			data.beatmap.info.sampleSet = trim(string.sub(line, 11, -1))
		end
		if string.sub(line, 1, 4) == "Mode" then
			data.beatmap.info.mode = trim(string.sub(line, 6, -1))
		end
	end
end

return getGeneral
