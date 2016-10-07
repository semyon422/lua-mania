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
	objects.gameState = luaMania.ui.objects.gameState
	luaMania.cache.data = cacheManager.generate(luaMania.cache.rules)
end

return luaMania