--[[	lua-mania
		Copyright (C) 2016 Semyon Jolnirov (semyon422)
		This program licensed under the GNU GPLv3.	]]
local function osu2lua(self, cache)
	data.beatmap = {}
	
	data.beatmap.file = io.open(cache.pathFile, "r")
	data.beatmap.fileLines = {}
	
	for line in data.beatmap.file:lines() do
		if trim(line) ~= "" then
			table.insert(data.beatmap.fileLines, trim(line))
		end
	end
	
	local blocks = {}
	
	for numberLine = 1, #data.beatmap.fileLines do
		local line = trim(data.beatmap.fileLines[numberLine])
		if string.sub(line, 1, 1) == "[" then
			blocks[#blocks + 1] = {
				name = string.sub(line, 2, -2),
				first = numberLine + 1
			}
		end
		if #blocks > 1 then
			blocks[#blocks - 1].last = blocks[#blocks].first - 2
		end
		if numberLine == #data.beatmap.fileLines then
			blocks[#blocks].last = #data.beatmap.fileLines
		end
	end
	
	for numberBlock = 1, #blocks do
		local block = blocks[numberBlock]
		if block.name == "General" then require("src.converters.osu.getGeneral")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "Editor" then require("src.converters.osu.getEditor")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "Metadata" then require("src.converters.osu.getMetadata")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "Difficulty" then require("src.converters.osu.getDifficulty")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "Events" then require("src.converters.osu.getEvents")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "TimingPoints" then require("src.converters.osu.getTimingPoints")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "Colours" then require("src.converters.osu.getColours")(data.beatmap.fileLines, block.first, block.last) end
		if block.name == "HitObjects" then require("src.converters.osu.getHitObjects")(data.beatmap.fileLines, block.first, block.last, cache) end
	end
end

return osu2lua
