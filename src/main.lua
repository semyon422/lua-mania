function love.load()
	helpers = require("helpers")
	log = helpers.logger.log
	loveio = require("loveio")
	pos = loveio.output.position
	
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
		["position"] = loveio.output.position.object
	}
	luaMania.load()
	loveio.init(objects)
	
end