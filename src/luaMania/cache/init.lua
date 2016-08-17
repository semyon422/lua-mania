local init = function(luaMania)
--------------------------------
local cache = {}

local osuCache = require("luaMania.cache.osuCache")(cache, luaMania)

cache.data = {}

cache.callback = function(filePath)
	if love.filesystem.isFile(filePath) then
		if string.sub(filePath, -4, -1) == ".osu" then
			return osuCache(filePath)
		end
	end
end

cache.rules = {
	path = "res/Songs/",
	callback = cache.callback
}


return cache
--------------------------------
end

return init
