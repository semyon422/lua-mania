local init = function(classes, ui)
--------------------------------
local Picture = classes.UiObject:new()

Picture.modes = {}
Picture.modes.fit = function(gw, gh, drawable)
	local base = {x = 0, y = 0, w = gw, h = gh}
	local box = {w = drawable:getWidth(), h = drawable:getHeight()}
	local dims = loveio.output.Position.getDimensionsSimple(base, box, {"center", "center"}, "out")
	
	return dims.x, dims.y, dims.scale
end

Picture.layer = 2
Picture.mode = "fill" --center - центр, fill - заполн, fit - по размеру, stretch - раст, tile - тайл, span - ?

Picture.load = function(self)
	local pos = self.pos or pos
	self.drawable = love.graphics.newImage(self.value)
	self.drawableObject = loveio.output.classes.Drawable:new({
		drawable = self.drawable,
		layer = self.layer,
		pos = self.pos
	}):insert(loveio.output.objects)
	
	loveio.input.callbacks.resize[tostring(self)] = function(w, h)
		local x, y, scale = (self.modes[self.mode] or self.modes.fit)(pos:x2X(1), pos:y2Y(1), self.drawable)
		self.drawableObject.x = pos:X2x(x)
		self.drawableObject.y = pos:Y2y(y)
		self.drawableObject.sx = scale
	end
	loveio.input.callbacks.resize[tostring(self)]()
end
Picture.unload = function(self)
	if self.drawableObject then self.drawableObject:remove() end
	loveio.input.callbacks.resize[tostring(self)] = nil
end

return Picture
--------------------------------
end

return init
