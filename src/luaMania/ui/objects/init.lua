local init = function(lmui, luaMania)
--------------------------------
local objects = {}

objects.cliUi = cli.CliUi:new({
	name = "lmCliUi",
	x = 0, y = 0, w = 1, h = 0.5
})
objects.fpsDisplay = ui.classes.Button:new({
	x = 1 - 0.05, y = 0, w = 0.05, h = pos:x2y(0.05),
	getValue = function() return love.timer.getFPS() end,
	action = function(self) print("FPS: " .. self.value) end,
	backgroundColor = {255, 255, 255, 31},
	pos = loveio.output.Position:new({1,1})
})
objects.mapList = require("luaMania.ui.objects.mapList")
objects.menuBackground = require("luaMania.ui.objects.menuBackground")
objects.game = luaMania.game
objects.playButton = ui.classes.Button:new({
	x = 0.5 - 0.15 / 2,
	y = 0.5 - pos:x2y(0.075) / 2,
	w = 0.15, h = pos:x2y(0.075),
	value = "play",
	action = function() luaMania.cli:run("gameState set mapList") end,
	backgroundColor = {255, 255, 255, 31}
})
objects.backButton = ui.classes.Button:new({
	x = 0.9,
	y = 0.9,
	w = 0.1, h = 0.1,
	value = "back",
	action = function() luaMania.cli:run("gameState set mapList") end
})
objects.luaManiaLogo = ui.classes.Button:new({
	x = 0.5 - 0.15 / 2,
	y = 1 / 6 - pos:x2y(0.05) / 2,
	w = 0.15, h = pos:x2y(0.05),
	value = "lua-mania"
})
objects.cursor = require("luaMania.ui.objects.cursor")

objects.gameState = require("luaMania.ui.objects.gameState")(objects, lmui, luaMania)

return objects
--------------------------------
end

return init