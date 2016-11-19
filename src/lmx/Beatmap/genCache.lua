local init = function(Beatmap, lmx)
--------------------------------
local function osuCache(filePath)
	local title, artist, version, creator, source
	
	local file = io.open(filePath, "r")
	local fileLines = {}
	for line in file:lines() do
		if string.sub(line, 1, 5) == "title" then
			title = trim(string.sub(line, 7, -1))
		end
	end
	file:close()
	
	return {
		title = title,
		artist = "",
		version = "",
		creator = "",
		source = "",
		filePath = filePath,
		mode = "lmx",
		format = "lmx"
	}
end

return osuCache
--------------------------------
end

return init