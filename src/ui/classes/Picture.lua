local init = function(classes, ui)
--------------------------------
local Picture = classes.UiObject:new()

Picture.modes = {}
Picture.modes.fit = function(gw, gh, drawable)
	local scale = 1
	local w, h = drawable:getWidth(), drawable:getHeight()
	if gw < w * scale then
		-- nothing
	end
	if gh < h * scale then
		scale = gh / h
	end
	if gw > w * scale then
		scale = gw / w
	end
	if gh > h * scale then
		scale = gh / h
	end
	local x = (gw / 2) - (w*scale / 2)
	local y = (gh / 2) - (h*scale / 2)
	return x, y, scale
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
