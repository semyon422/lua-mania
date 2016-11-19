local init = function(cache, luaMania)
--------------------------------
local function bmsCacher(filePath)
	local title, artist, version
	
	local file = io.open(filePath, "r")
	local fileLines = {}
	for line in file:lines() do
		if string.sub(line, 1, 6) == "#TITLE" then
			title = trim(string.sub(line, 7, -1))
		end
		if string.sub(line, 1, 7) == "#ARTIST" then
			artist = trim(string.sub(line, 8, -1))
		end
		if string.sub(line, 1, 10) == "#PLAYLEVEL" then
			version = trim(string.sub(line, 11, -1)) .. " level"
		end
		if string.sub(line, 1, 4) == "#WAV" then
			break
		end
	end
	file:close()
	
	return {
		title = title,
		artist = artist,
		version = version,
		filePath = filePath,
		mode = "vsrg",
		format = "bms"
	}
end

return bmsCacher
--------------------------------
end

return init