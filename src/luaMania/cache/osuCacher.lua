local init = function(cache, luaMania)
--------------------------------
local function osuCache(filePath)
	local title, artist, version, creator, source
	
	local file = io.open(filePath, "r")
	local fileLines = {}
	for line in file:lines() do
		if string.sub(line, 1, 6) == "Title:" then
			title = trim(string.sub(line, 7, -1))
		end
		if string.sub(line, 1, 7) == "Artist:" then
			artist = trim(string.sub(line, 8, -1))
		end
		if string.sub(line, 1, 7) == "Version" then
			version = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 7) == "Creator" then
			creator = trim(string.sub(line, 9, -1))
		end
		if string.sub(line, 1, 6) == "Source" then
			source = trim(string.sub(line, 8, -1))
			if source == "" then source = "No source" end
		end
		if string.sub(line, 1, -1) == "[TimingPoints]" then
			break
		end
	end
	file:close()
	
	return {
		title = title,
		artist = artist,
		version = version,
		creator = creator,
		source = source,
		filePath = filePath,
		mode = "vsrg",
		format = "osu"
	}
end

return osuCache
--------------------------------
end

return init