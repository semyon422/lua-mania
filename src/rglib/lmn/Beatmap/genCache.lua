local init = function(Beatmap, lmx)
--------------------------------
local function lmnCache(filePath)
	local title, artist, version, creator, source
	
	local file = io.open(filePath, "r")
	local fileLines = {}
	for line in file:lines() do
		if string.sub(line, 1, 5) == "title" then
			title = trim(string.sub(line, 7, -1))
		end
		if string.sub(line, 1, 6) == "artist" then
			artist = trim(string.sub(line, 8, -1))
		end
		if string.sub(line, 1, 7) == "mapName" then
			mapName = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 7) == "creator" then
			creator = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, -1) == "--timingPoints" then
			break
		end
	end
	file:close()
	
	return {
		title = title,
		artist = artist,
		mapName = mapName,
		creator = creator,
		source = "",
		filePath = filePath,
		mode = "vsrg",
		format = "lmn"
	}
end

return lmnCache
--------------------------------
end

return init
