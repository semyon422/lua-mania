local objects = {}

objects.gameState = require("luaMania.ui.objects.gameState")
objects.mapList = require("luaMania.ui.objects.mapList")
objects.background = require("luaMania.ui.objects.background")
objects.mania = require("luaMania.modes.mania")
objects["buttonPlay"] = ui.classes.button:new({
	name = "buttonPlay",
	layer = 2,
	x = love.graphics.getWidth() / 2,
	y = love.graphics.getHeight() / 2,
	r = 40,
	form = "circle",
	mode = "line",
	text = "play",
	color = {255,255,255},
	textColor = {255,255,255},
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end
})

return objects