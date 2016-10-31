local init = function(luaMania)
--------------------------------
local lmui = {}

lmui.cliUi = cli.CliUi:new({
	name = "lmCliUi",
	x = 0, y = 0, w = 1, h = 0.5
})
lmui.fpsDisplay = ui.classes.Button:new({
	x = 1 - 0.075, y = 0, w = 0.075, h = 0.075,
	getValue = function() return love.timer.getFPS() end,
	action = function(self) print("FPS: " .. self.value) end,
	backgroundColor = {255, 255, 255, 31},
	pos = loveio.output.Position:new({ratios = {1}, align = {"right", "top"}})
})
lmui.mapList = require("luaMania.ui.mapList")
lmui.menuBackground = ui.classes.Picture:new({
	value = "res/bg.jpg",
	pos = loveio.output.Position:new({ratios = {0}}),
	mode = "fit",
	layer = 0
})
lmui.game = luaMania.game
lmui.playButton = ui.classes.Button:new({
	x = 0.4,
	y = 0.45,
	w = 0.2, h = 0.1,
	value = "play",
	action = function() luaMania.cli:run("gameState set mapList") end,
	backgroundColor = {255, 255, 255, 31},
	pos = loveio.output.Position:new({ratios = {1}, align = {"center", "center"}})
})
lmui.backButton = ui.classes.Button:new({
	x = 0.8,
	y = 0.9,
	w = 0.2, h = 0.1,
	value = "back",
	action = function() luaMania.cli:run("gameState set mapList") end,
	pos = loveio.output.Position:new({ratios = {1}, align = {"right", "bottom"}})
})
lmui.cursor = require("luaMania.ui.cursor")

lmui.gameState = require("luaMania.ui.gameState")(lmui, luaMania)

return lmui
--------------------------------
end

return init