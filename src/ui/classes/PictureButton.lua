local init = function(classes, ui)
--------------------------------
local PictureButton = classes.UiObject:new()

PictureButton.layer = 2
PictureButton.xAlign = "center"
PictureButton.yAlign = "center"
PictureButton.xPadding = 0
PictureButton.yPadding = 0
PictureButton.textColor = {255, 255, 255, 255}
PictureButton.align = {"center", "center"}
PictureButton.locate = "in"
PictureButton.fontBaseResolution = {pos:x2X(1), pos:y2Y(1)}

PictureButton.load = function(self)
	self.pos = self.pos or pos
	self.drawable = self.drawable or love.graphics.newImage(self.imagePath)
	self.drawableObject = loveio.output.classes.Drawable:new({
		drawable = self.drawable,
		layer = self.layer,
		pos = self.pos,
		layer = self.layer
	}):insert(loveio.output.objects)
	
	loveio.input.callbacks.mousepressed[tostring(self)] = function(mx, my)
		local x = self:getAbs("x", true)
		local y = self:getAbs("y", true)
		local w = self:getAbs("w")
		local h = self:getAbs("h")
		if mx >= x and mx <= x + w and my >= y and my <= y + h then
			self:activate()
		end
	end
	loveio.input.callbacks.resize[tostring(self)] = function()
		self.base = {x = pos:x2X(self.x, true), y = pos:y2Y(self.y, true), w = pos:x2X(self.w), h = pos:y2Y(self.h)}
		self.box = {w = self.drawable:getWidth(), h = self.drawable:getHeight()}
		self.dims = loveio.output.Position.getDimensionsSimple(self.base, self.box, self.align, self.locate)
		self.drawableObject.x = pos:X2x(self.dims.x, true)
		self.drawableObject.y = pos:Y2y(self.dims.y, true)
		self.drawableObject.sx = self.dims.scale
	end
	loveio.input.callbacks.resize[tostring(self)]()
	self:valueChanged()
	self.loaded = true
end
PictureButton.unload = function(self)
	if self.drawableObject then self.drawableObject:remove() end
	loveio.input.callbacks.mousepressed[tostring(self)] = nil
	if self["text-1"] then self["text-1"]:remove() end
end
PictureButton.valueChanged = function(self)
	if self["text-1"] then self["text-1"]:remove() end
	local sx = self.pos:x2X(1) / self.fontBaseResolution[1]
	self["text-1"] = loveio.output.classes.Text:new({
		x = self.x + self.xPadding, y = self.y + self.h / 2,
		limit = self.w - 2*self.xPadding,
		text = self.value, xAlign = self.xAlign, yAlign = self.yAlign,
		font = self.font,
		color = self.textColor,
		sx = sx,
		layer = self.layer + 1,
		pos = self.pos
	}):insert(loveio.output.objects)
	self.oldValue = value
end

return PictureButton
--------------------------------
end

return init
