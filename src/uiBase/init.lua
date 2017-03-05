local init = function()
--------------------------------
local uiBase = {}

uiBase.fpsDisplay = ui.classes.DrawableTextButton:new({
	x = 1 - 0.1, y = 0, w = 0.1, h = 0.1/2,
	getValue = function() return love.timer.getFPS() end,
	imagePath = "res/fpsCounter.png", locate = "out",
	action = function(self) print("FPS: " .. self.value) end,
	pos = loveio.output.Position:new({ratios = {1}, align = {"right", "top"}}),
	layer = 1000,
	font = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 14)
})

uiBase.mapList = require("uiBase.mapList")
uiBase.Background = require("uiBase.Background")
uiBase.background = uiBase.Background:new()
uiBase.background.path = "res/bg.jpg"
uiBase.backButton = ui.classes.DrawableTextButton:new({
	x = 0.9, y = 0,
	w = 0.1, h = 1, value = "",
	imagePath = "res/backButton.png",
	action = function() mainCli:run("gameState set mapList") end,
	locate = "out",
	pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})
})
--uiBase.fileTree = require("uiBase.fileTree")()
uiBase.cacheUpdater = require("uiBase.cacheUpdater")()
uiBase.cursor = require("uiBase.cursor")
uiBase.mainMenu = require("uiBase.mainMenu")()

return uiBase
--------------------------------
end

return init
