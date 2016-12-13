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

PictureButton.load = function(self)
	self.fontBaseResolution = self.fontBaseResolution or {pos:x2X(1), pos:y2Y(1)}
	self.pos = self.pos or pos
	self.drawable = self.drawable or love.graphics.newImage(self.imagePath)
	self.quadX = self.quadX or 0
	self.quadY = self.quadY or 0
	self.quadWidth = self.quadWidth or self.drawable:getWidth()
	self.quadHeight = self.quadHeight or self.drawable:getHeight()
	self.quad = self.quad or love.graphics.newQuad(self.quadX, self.quadY, self.quadWidth, self.quadHeight, self.drawable:getWidth(), self.drawable:getHeight())
	self.quadObject = loveio.output.classes.Quad:new({
		drawable = self.drawable,
		quad = self.quad,
		layer = self.layer,
		pos = self.pos
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
		self.base = {x = self.pos:x2X(self.x, true), y = self.pos:y2Y(self.y, true), w = self.pos:x2X(self.w), h = self.pos:y2Y(self.h)}
		self.box = {w = self.quadWidth, h = self.quadHeight}
		self.dims = loveio.output.Position.getDimensionsSimple(self.base, self.box, self.align, self.locate)
		self.quadObject.x = self.pos:X2x(self.dims.x, true)
		self.quadObject.y = self.pos:Y2y(self.dims.y, true)
		self.quadObject.sx = self.dims.scale
		self:valueChanged()
	end
	loveio.input.callbacks.resize[tostring(self)]()
	self:valueChanged()
	self.loaded = true
end
PictureButton.unload = function(self)
	if self.quadObject then self.quadObject:remove() end
	loveio.input.callbacks.mousepressed[tostring(self)] = nil
	loveio.input.callbacks.resize[tostring(self)] = nil
	if self["text-1"] then self["text-1"]:remove() end
end
PictureButton.valueChanged = function(self)
	if self["text-1"] then self["text-1"]:remove() end
	local sx = self.pos:x2X(1) / self.fontBaseResolution[1] * self.pos.scale[1]
	if self.quadObject then
		self["text-1"] = loveio.output.classes.Text:new({
			x = self.x + self.xPadding, y = self.y + self.h / 2,
			limit = (self.w - 2*self.xPadding) / sx,
			text = self.value, xAlign = self.xAlign, yAlign = self.yAlign,
			font = self.font,
			color = self.textColor,
			sx = sx,
			layer = self.layer + 1,
			pos = self.pos
		}):insert(loveio.output.objects)
	end
end

return PictureButton
--------------------------------
end

return init
