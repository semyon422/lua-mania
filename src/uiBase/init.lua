local init = function()
--------------------------------
local uiBase = {}

uiBase.fpsDisplay = ui.classes.Button:new({
	x = 1 - 0.075, y = 0, w = 0.075, h = 0.075,
	getValue = function() return love.timer.getFPS() end,
	action = function(self) print("FPS: " .. self.value) end,
	backgroundColor = {255, 255, 255, 31},
	pos = loveio.output.Position:new({ratios = {1}, align = {"right", "top"}})
})
uiBase.mapList = require("uiBase.mapList")
uiBase.menuBackground = ui.classes.Picture:new({
	value = "res/bg.jpg",
	pos = loveio.output.Position:new({ratios = {0}}),
	mode = "fit",
	layer = 0
})
uiBase.playButton = ui.classes.Button:new({
	x = 0.4,
	y = 0.45,
	w = 0.2, h = 0.1,
	value = "play",
	action = function() mainCli:run("gameState set mapList") end,
	backgroundColor = {255, 255, 255, 31},
	pos = loveio.output.Position:new({ratios = {1}, align = {"center", "center"}})
})
uiBase.backButton = ui.classes.Button:new({
	x = 0.8,
	y = 0.9,
	w = 0.2, h = 0.1,
	value = "back",
	action = function() mainCli:run("gameState set mapList") end,
	pos = loveio.output.Position:new({ratios = {1}, align = {"right", "bottom"}})
})
uiBase.cursor = require("uiBase.cursor")

return uiBase
--------------------------------
end

return init