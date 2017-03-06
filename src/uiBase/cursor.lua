local cursor = ui.classes.UiObject:new()

local image = love.graphics.newImage("res/cursor.png")
local pos = loveio.output.Position:new({ratios = {1}, resolutions = {{1, 1}}})
local wh = 0.1

cursor.load = function(self)
	love.mouse.setVisible(false)
	self.drawableBox = loveio.output.classes.DrawableBox:new({
		x = 0, y = 0, w = wh, h = wh,
		drawable = image,
		layer = 1001,
		pos = pos
	}):insert(loveio.output.objects)
	
	loveio.input.callbacks.mousepressed.cursor = function(mx, my)
		self.drawableBox.x = pos:X2x(mx, true) - wh/2
		self.drawableBox.y = pos:Y2y(my, true) - wh/2
	end
	loveio.input.callbacks.mousemoved.cursor = function(mx, my)
		self.drawableBox.x = pos:X2x(mx, true) - wh/2
		self.drawableBox.y = pos:Y2y(my, true) - wh/2
	end
	loveio.input.callbacks.mousereleased.cursor = function(mx, my)
		self.drawableBox.x = pos:X2x(mx, true) - wh/2
		self.drawableBox.y = pos:Y2y(my, true) - wh/2
	end
end

cursor.unload = function(self)
	if self.drawableBox then
		self.drawableBox:remove()
	end
	loveio.input.callbacks.mousepressed.cursor = nil
	loveio.input.callbacks.mousemoved.cursor = nil
	loveio.input.callbacks.mousereleased.cursor = nil
end

return cursor
