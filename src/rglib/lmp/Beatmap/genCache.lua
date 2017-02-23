local init = function(Beatmap, lmp)
--------------------------------
local function lmpCacher(filePath)
	local title, artist, version
	print(1)	
	local breakedPath = explode("/", filePath)
	local mapFileName = breakedPath[#breakedPath]
	local mapPath = string.sub(filePath, 1, #filePath - #mapFileName - 1)
	
	local file = io.open(filePath, "r")
	local fileLines = {}
	for line in file:lines() do
		if string.sub(line, 1, 7) == "--title" then
			title = utf8validate(trim(string.sub(line, 8, -1)))
		elseif string.sub(line, 1, 4) == "----" then
			break
		end
	end
	file:close()
	
	return {
		title = title,
		artist = "",
		mapName = "",
		filePath = filePath,
		mapFileName = mapFileName,
		mapPath = mapPath,
		mode = "lmp",
		format = "lmp"
	}
end

return lmpCacher
--------------------------------
end

return init

