local init = function(...)
--------------------------------
local mainMenu = loveio.LoveioObject:new()

mainMenu.load = function(self)
	self.playButton = ui.classes.Button:new({
		x = 0.5, y = 0.5, w = 0.1, h = 0.1,
		value = "play",
		action = function() mainCli:run("gameState set mapList") end
	}):insert(loveio.objects)
end

mainMenu.unload = function(self)
	if self.playButton then
		self.playButton:remove()
	end
end

return mainMenu
--------------------------------
end

return init