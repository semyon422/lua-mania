function love.load()
	osu = require("osu")
	ui = require("ui")
	helpers = require("helpers")
	log = helpers.logger.log
	luaMania = require("luaMania")
	loveio = require("loveio")
	objects = {
		["luaMania"] = {
			update = luaMania.update
		},
		["ui"] = {
			update = ui.update
		}
	}
	luaMania.load()
	loveio.init(objects)
end