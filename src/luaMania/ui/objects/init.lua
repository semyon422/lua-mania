local objects = {}

objects.gameState = require("luaMania.ui.objects.gameState")
objects.mapList = require("luaMania.ui.objects.mapList")
objects.menuBackground = require("luaMania.ui.objects.menuBackground")
objects.game = require("luaMania.game")(luaMania)
objects.playButton = ui.classes.Button:new({
	name = "playButton",
	x = 0.5 - 0.075 / 2,
	y = 0.5 - pos.x2y(0.075) / 2,
	w = 0.075, h = pos.x2y(0.075),
	value = "play",
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end
})
objects.backButton = ui.classes.Button:new({
	name = "backButton",
	x = 0.9,
	y = 0.9,
	w = 0.1, h = 0.1,
	value = "back",
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end
})
objects.luaManiaLogo = ui.classes.Button:new({
	name = "luaManiaLogo",
	x = 0.5 - 0.15 / 2,
	y = 1 / 6 - pos.x2y(0.05) / 2,
	w = 0.15, h = pos.x2y(0.05),
	value = "lua-mania"
})
objects.cursor = require("luaMania.ui.objects.cursor")

return objects