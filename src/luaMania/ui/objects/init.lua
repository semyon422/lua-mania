local init = function(lmui, luaMania)
--------------------------------
local objects = {}

objects.fpsDisplay = ui.classes.Button:new({
	name = "fpsDisplay",
	x = 1 - 0.05, y = 0, w = 0.05, h = pos.x2y(0.05),
	getValue = function() return love.timer.getFPS() end,
	action = function(self) print("FPS: " .. self.value) end,
	backgroundColor = {255, 255, 255, 31}
})
objects.goFullscreen = ui.classes.Button:new({
	name = "goFullscreen",
	x = 1 - 0.08, y = 0, w = 0.08, h = pos.x2y(0.05),
	value = "full\nscreen",
	action = function() love.window.setFullscreen(not (love.window.getFullscreen())) end
})
objects.gameState = require("luaMania.ui.objects.gameState")
objects.mapList = require("luaMania.ui.objects.mapList")
objects.menuBackground = require("luaMania.ui.objects.menuBackground")
objects.game = luaMania.game
objects.playButton = ui.classes.Button:new({
	name = "playButton",
	x = 0.5 - 0.15 / 2,
	y = 0.5 - pos.x2y(0.075) / 2,
	w = 0.15, h = pos.x2y(0.075),
	value = "play",
	action = function() objects.gameState.data.state = "mapList"; objects.gameState.data.switched = false end,
	backgroundColor = {255, 255, 255, 31}
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
--------------------------------
end

return init