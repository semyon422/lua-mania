local objects = {}

objects.gameState = require("luaMania.ui.objects.gameState")
objects.mapList = require("luaMania.ui.objects.mapList")
objects.background = ui.classes.picture:new({layer = 1, x = 0, y = 0, w = 1, h = 1, value = "res/skin/background.png", mode = "fill",
	callbacks = {
		resize = function()
			objects.background.x = pos.X2x(0, true)
			objects.background.y = pos.Y2y(0, true)
			objects.background.w = pos.X2x(love.graphics.getWidth())
			objects.background.h = pos.Y2y(love.graphics.getHeight())
			objects.background.loaded = false
		end
	}
})
objects.mania = require("luaMania.modes.mania")
objects.playButton = ui.classes.button:new({
	name = "playButton",
	x = 0.5 - 0.075 / 2,
	y = 0.5 - pos.x2y(0.075) / 2,
	w = 0.075, h = pos.x2y(0.075),
	value = "play",
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end
})
objects.luaManiaLogo = ui.classes.button:new({
	name = "luaManiaLogo",
	x = 0.5 - 0.15 / 2,
	y = 1 / 6 - pos.x2y(0.05) / 2,
	w = 0.15, h = pos.x2y(0.05),
	value = "lua-mania"
})

return objects