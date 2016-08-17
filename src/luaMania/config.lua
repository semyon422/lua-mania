local init = function(luaMania)
--------------------------------
local config = {}

config.game = {}
config.game.vsrg = {}
config.game.vsrg.hitPosition = 0
config.game.vsrg["7K"] = {"w", "e", "r", "space", "o", "p", "["}
config.game.vsrg["4K"] = {"e", "r", "o", "p"}

return configManager.toOneDim(config)
--------------------------------
end

return init