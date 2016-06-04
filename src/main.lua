function love.load()
	helpers = require("helpers")
	log = helpers.logger.log
	loveio = require("loveio")
	pos = loveio.output.position
	nav = loveio.input.navigation
	
	objects = {}
	loveio.init(objects)
	
	ui = require("ui")
	
	osu = require("osu")
	luaMania = require("luaMania")
	luaMania.load()
	
	objects["luaMania"] = { update = luaMania.update }
	objects["position"] = loveio.output.position.object
	objects["navigation"] = loveio.input.navigation.object
	objects["ui"] = { update = ui.update }
end