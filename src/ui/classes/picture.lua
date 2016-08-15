local init = function(classes, ui)
--------------------------------
local Picture = classes.UiObject:new()

Picture.layer = 2
Picture.mode = "fill" --center - центр, fill - заполн, fit - по размеру, stretch - раст, tile - тайл, span - ?

Picture.load = function(self)
	self:valueChanged()
	self.loaded = true
end
Picture.unload = function(self)
	loveio.output.objects[self.name] = nil
end
Picture.valueChanged = function(self)
	local drawable = love.graphics.newImage(self.value)
	local dw = pos.X2x(drawable:getWidth())
	local dh = pos.Y2y(drawable:getHeight())
	loveio.output.objects[self.name] = loveio.output.classes.Drawable:new({
		x = self.x, y = self.y,
		sx = self.w / dw,
		drawable = drawable,
		layer = self.layer
	})
	self.oldValue = value
end

return Picture
--------------------------------
end

return init
