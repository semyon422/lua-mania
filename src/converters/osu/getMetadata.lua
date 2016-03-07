--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function getMetadata(fileLines, bStart, bEnd)
	for numberLine = bStart, bEnd do
		local line = fileLines[numberLine]
		
		if data.beatmap.info == nil then data.beatmap.info = {} end
		if string.sub(line, 1, 12) == "TitleUnicode" then
			data.beatmap.info.title = trim(string.sub(line, 14, -1))
		end
		if string.sub(line, 1, 13) == "ArtistUnicode" then
			data.beatmap.info.artist = trim(string.sub(line, 15, -1))
		end
		if string.sub(line, 1, 7) == "Creator" then
			data.beatmap.info.creator = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 7) == "Version" then
			data.beatmap.info.version = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 6) == "Source" then
			data.beatmap.info.source = trim(string.sub(line, 8, -1))
		end
		if string.sub(line, 1, 4) == "Tags" then
			data.beatmap.info.tags = trim(string.sub(line, 6, -1))
		end
	end
end

return getMetadata
