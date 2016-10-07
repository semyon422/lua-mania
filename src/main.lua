function love.load()
	helpers = require("helpers")
	log = helpers.logger.log
	
	configManager = require("configManager")
	mainConfig = configManager.load("config.txt")
	cacheManager = require("cacheManager")
	
	loveio = require("loveio")
	pos = loveio.output.Position:new({1, 1}, tonumber(mainConfig["position.ratio"] and mainConfig["position.ratio"].value))
	
	objects = {}
	loveio.init(objects)
	
	ui = require("ui")
	
	cli = require("cli")
	
	osu = require("osu")
	bms = require("bms")
	luaMania = require("luaMania")
	luaMania.load()

	love.graphics.setBackgroundColor(127, 127, 127)
end
