local luaMania = loveio.LoveioObject:new()

luaMania.game = require("luaMania.game")(luaMania)
luaMania.ui = require("luaMania.ui")(luaMania)
luaMania.cache = require("luaMania.cache")(luaMania)

luaMania.defaultConfig = require("luaMania.config")(luaMania)
luaMania.config = mainConfig
setmetatable(luaMania.config, luaMania.defaultConfig)
luaMania.defaultConfig.__index = luaMania.defaultConfig

--configManager.save(luaMania.config, "config.txt")

luaMania.load = function()
	objects.gameState = luaMania.ui.objects.gameState
	luaMania.cache.data = cacheManager.generate(luaMania.cache.rules)
	
	if luaMania.config["skinPath"] then
		luaMania.skin = require(luaMania.config["skinPath"].value)(luaMania)
		loveio.input.callbacks.keypressed.switchSkin = function(key)
			if key == "f5" then
				if not luaMania.skin.loaded then
					luaMania.skin.load()
				else
					luaMania.skin.unload()
				end
			end
		end
	end
end

return luaMania