local luaMania = loveio.LoveioObject:new()

luaMania.ui = require("luaMania.ui")(luaMania)
luaMania.cache = require("luaMania.cache")(luaMania)
luaMania.game = require("luaMania.game")(luaMania)

luaMania.defaultConfig = require("luaMania.config")(luaMania)
luaMania.config = configManager.load("config.txt")
setmetatable(luaMania.config, luaMania.defaultConfig)
luaMania.defaultConfig.__index = luaMania.defaultConfig

--configManager.save(luaMania.config, "config.txt")

--luaMania.skin = require("res/skin")(luaMania)
luaMania.load = function()
	objects.gameState = luaMania.ui.objects.gameState
	
	luaMania.cache.data = cacheManager.generate(luaMania.cache.rules)
end

return luaMania