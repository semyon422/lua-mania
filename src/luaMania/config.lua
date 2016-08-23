local init = function(luaMania)
--------------------------------
local config = {}

config.game = {}
config.game.vsrg = {}
config.game.vsrg.speed = 1
config.game.vsrg["4K"] = {"d", "f", "j", "k"}
config.game.vsrg["5K"] = {"d", "f", "space", "j", "k"}
config.game.vsrg["6K"] = {"s", "d", "f", "j", "k", "l"}
config.game.vsrg["7K"] = {"s", "d", "f", "space", "j", "k", "l"}
config.game.vsrg["8K"] = {"a", "s", "d", "f", "j", "k", "l", ";"}
config.game.vsrg["9K"] = {"a", "s", "d", "f", "space", "j", "k", "l", ";"}

return configManager.toOneDim(config)
--------------------------------
end

return init