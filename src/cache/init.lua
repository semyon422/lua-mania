local init = function(luaMania)
--------------------------------
local cache = {}

cache.cachers = {}
cache.cachers.osu = require("luaMania.cache.osuCacher")(cache, luaMania)
cache.cachers.bms = require("luaMania.cache.bmsCacher")(cache, luaMania)
cache.cachers.lmx = require("luaMania.cache.lmxCacher")(cache, luaMania)

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
		if fileType == "lmx" then
			return cache.cachers.lmx(filePath)
		end
	end
end

cache.rules = {
	path = "res/Songs/",
	callback = cache.callback
}

loveio.input.callbacks.keypressed.cacheHandle = function(key)
	if luaMania.ui.mapList.state == "songs" then
		if key == "f7" then
			luaMania.cache.data = cacheManager.generate(luaMania.cache.rules)
			if objects[tostring(luaMania.ui.mapList)] then
				luaMania.ui.mapList.list = luaMania.cache.data
				luaMania.ui.mapList:calcButtons()
			end
		elseif key == "f8" then
			cacheManager.save(luaMania.cache.data, "cache.lua")
		elseif key == "f9" then
			luaMania.cache.data = cacheManager.load("cache.lua")
			if objects[tostring(luaMania.ui.mapList)] then
				luaMania.ui.mapList.list = luaMania.cache.data
				luaMania.ui.mapList:calcButtons()
			end
		end
	end
end

return cache
--------------------------------
end

return init
