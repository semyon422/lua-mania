local init = function(luaMania)
--------------------------------
local config = {}

config["game.vsrg.offset"] = 0
config["game.vsrg.speed"] = 1
config["game.vsrg.velocityPower"] = 1
config["game.vsrg.velocityMode"] = 1
config["game.vsrg.hitSoundSourceType"] = "static"
config["game.vsrg.audioSourceType"] = "stream"
config["game.vsrg.audioPitch"] = 1
config["keyBind.game.vsrg.4K"] = {"d", "f", "j", "k"}
config["keyBind.game.vsrg.5K"] = {"d", "f", "space", "j", "k"}
config["keyBind.game.vsrg.6K"] = {"s", "d", "f", "j", "k", "l"}
config["keyBind.game.vsrg.7K"] = {"s", "d", "f", "space", "j", "k", "l"}
config["keyBind.game.vsrg.8K"] = {"a", "s", "d", "f", "j", "k", "l", ";"}
config["keyBind.game.vsrg.9K"] = {"a", "s", "d", "f", "space", "j", "k", "l", ";"}

return configManager.toConfig(config)
--------------------------------
end

return init