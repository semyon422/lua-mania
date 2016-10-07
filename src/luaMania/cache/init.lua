local init = function(luaMania)
--------------------------------
local cache = {}

cache.cachers = {}
cache.cachers.osu = require("luaMania.cache.osuCacher")(cache, luaMania)
cache.cachers.bms = require("luaMania.cache.bmsCacher")(cache, luaMania)

cache.data = {}

cache.callback = function(filePath)
	if love.filesystem.isFile(filePath) then
		local breaked = explode(".", filePath)
		local fileType = breaked[#breaked]
		if fileType == "osu" then
			return cache.cachers.osu(filePath)
		end
		if fileType == "bms" or fileType == "bme" then
			return cache.cachers.bms(filePath)
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
