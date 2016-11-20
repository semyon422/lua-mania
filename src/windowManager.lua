local windowManager = {}

windowManager.Mode = {}

windowManager.Mode.new = function(self, width, height, flags)
	local currentWidth, currentHeight, currentFlags = love.window.getMode()
	local mode = {}
	mode.width = width or currentWidth
	mode.height = height or currentHeight
	mode.flags = flags or currentFlags
	
	setmetatable(mode, self)
	self.__index = self
	return mode
end

windowManager.Mode.enable = function(self)
	return love.window.setMode(self.width, self.height, self.flags)
end

return windowManager
