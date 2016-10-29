local luaMania = loveio.LoveioObject:new()

luaMania.game = require("luaMania.game")(luaMania)
luaMania.ui = require("luaMania.ui")(luaMania)
luaMania.cache = require("luaMania.cache")(luaMania)
luaMania.cliBinds = require("luaMania.cliBinds")(luaMania)
luaMania.cli = cli.Cli:new({binds = luaMania.cliBinds})

luaMania.defaultConfig = require("luaMania.config")(luaMania)
luaMania.config = mainConfig
setmetatable(luaMania.config, luaMania.defaultConfig)
luaMania.defaultConfig.__index = luaMania.defaultConfig

luaMania.skin = require("res/defaultSkin")(luaMania)

--configManager.save(luaMania.config, "config.txt")

luaMania.load = function()
	objects.gameState = luaMania.ui.gameState
	loveio.input.callbacks.keypressed.someBinds = function(key)
		if key == "f7" then
			luaMania.cache.data = cacheManager.generate(luaMania.cache.rules)
			if objects[tostring(luaMania.ui.mapList)] then luaMania.ui.mapList:reload() end
		elseif key == "f8" then
			cacheManager.save(luaMania.cache.data, "cache.lua")
		elseif key == "f9" then
			luaMania.cache.data = cacheManager.load("cache.lua")
			if objects[tostring(luaMania.ui.mapList)] then luaMania.ui.mapList:reload() end
		end
	end
end

return luaMania