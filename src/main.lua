function love.load()
	helpers = require("helpers")
	log = helpers.logger.log
	loveio = require("loveio")
	pos = loveio.output.position
	nav = loveio.input.navigation
	
	osu = require("osu")
	ui = require("ui")
	luaMania = require("luaMania")
	objects = {
		["luaMania"] = {
			update = luaMania.update
		},
		["ui"] = {
			update = ui.update
		},
		["position"] = loveio.output.position.object,
		["navigation"] = loveio.input.navigation.object
	}
	luaMania.load()
	loveio.init(objects)
	
end