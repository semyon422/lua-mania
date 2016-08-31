function love.load()
	helpers = require("helpers")
	log = helpers.logger.log
	
	configManager = require("configManager")
	cacheManager = require("cacheManager")
	
	loveio = require("loveio")
	pos = loveio.output.position
	nav = loveio.input.navigation
	
	objects = {}
	loveio.init(objects)
	
	ui = require("ui")
	
	osu = require("osu")
	bms = require("bms")
	luaMania = require("luaMania")
	luaMania.load()
	
	objects["position"] = loveio.output.position.object
	objects["navigation"] = loveio.input.navigation.object
	objects["ui"] = ui
	love.graphics.setBackgroundColor(127, 127, 127)
end