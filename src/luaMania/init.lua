local luaMania = loveio.LoveioObject:new()

luaMania.ui = require("luaMania.ui")(luaMania)
luaMania.cache = require("luaMania.cache")(luaMania)
luaMania.game = require("luaMania.game")(luaMania)

luaMania.defaultConfig = require("luaMania.config")(luaMania)
luaMania.config = configManager.load("config.txt")
setmetatable(luaMania.config, luaMania.defaultConfig)
luaMania.defaultConfig.__index = luaMania.defaultConfig

	--testing
	luaMania.config["qqq"]:set("function() print(234234) end", true)
	print(luaMania.config["qqq"]:get())
	luaMania.config["qwe"]:set(2)
	print(luaMania.config["qwe"]:get())
	print(luaMania.config["qa.ws.ed"]:get())

	configManager.save(luaMania.config, "config.txt")

--luaMania.skin = require("res/skin")(luaMania)
luaMania.load = function()
	luaMania.ui.objects = require("luaMania.ui.objects")
	objects.gameState = luaMania.ui.objects.gameState
	
	luaMania.cache.data = cacheManager.generate(luaMania.cache.rules)
end

return luaMania