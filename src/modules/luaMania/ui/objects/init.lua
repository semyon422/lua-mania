local objects = {}

objects.gameState = require("luaMania.ui.objects.gameState")
objects.mapList = require("luaMania.ui.objects.mapList")
objects.background = require("luaMania.ui.objects.background")
objects.circle = require("luaMania.ui.objects.circle")
objects["button123"] = ui.classes.button:new({
	name = "button123",
	layer = 2,
	x = 100,
	y = 100,
	form = "circle",
	r = 20,
	mode = "line",
	text = "t",
	color = {255,255,255},
	textColor = {255,255,255},
	action = function() end
})
objects["button456"] = ui.classes.button:new({
	name = "button456",
	layer = 2,
	x = 100,
	y = 200,
	form = "rectangle",
	mode = "line",
	text = "text",
	color = {255,255,255},
	textColor = {255,255,255},
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end
})

return objects