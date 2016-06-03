local objects = {}

objects.gameState = require("luaMania.ui.objects.gameState")
objects.mapList = require("luaMania.ui.objects.mapList")
objects.background = ui.classes.picture:new({layer = 1, x = 0, y = 0, w = 1, h = 1, value = "res/skin/background.png", mode = "fill",
	callbacks = {
		resize = function()
			objects.background.loaded = false
		end
	}
})
objects.mania = require("luaMania.modes.mania")
objects["buttonPlay"] = ui.classes.button:new({
	x = 0.5 - 0.075 / 2,
	y = 0.5 - pos.x2y(0.075) / 2,
	w = 0.075, h = pos.x2y(0.075),
	value = "play",
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end
})

return objects