local luaMania = {}

luaMania.ui = require("luaMania.ui")
luaMania.cache = require("luaMania.cache")
luaMania.modes = require("luaMania.game")
luaMania.load = require("luaMania.load")
luaMania.update = require("luaMania.update")

luaMania.defaultConfig = require("luaMania.config")
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

luaMania.skin = require("res/skin")

return luaMania