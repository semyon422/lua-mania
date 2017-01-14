local init = function(Beatmap, bms)
--------------------------------
local function bmsCacher(filePath)
	local title, artist, version
	
	local breakedPath = explode("/", filePath)
	local mapFileName = breakedPath[#breakedPath]
	local mapPath = string.sub(filePath, 1, #filePath - #mapFileName - 1)
	
	local file = io.open(filePath, "r")
	if not file then return end
	local fileLines = {}
	for line in file:lines() do
		if string.sub(line, 1, 6) == "#TITLE" then
			title = utf8validate(trim(string.sub(line, 7, -1)))
		end
		if string.sub(line, 1, 7) == "#ARTIST" then
			artist = utf8validate(trim(string.sub(line, 8, -1)))
		end
		if string.sub(line, 1, 10) == "#PLAYLEVEL" then
			mapName = utf8validate(trim(string.sub(line, 11, -1)) .. " level")
		end
		if string.sub(line, 1, 4) == "#WAV" then
			break
		end
	end
	file:close()
	
	return {
		title = title,
		artist = artist,
		mapName = mapName,
		filePath = filePath,
		mapFileName = mapFileName,
		mapPath = mapPath,
		mode = "vsrg",
		format = "bms"
	}
end

return bmsCacher
--------------------------------
end

return init
