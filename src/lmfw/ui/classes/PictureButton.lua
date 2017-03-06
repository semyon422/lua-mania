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
	self.pos = self.pos or defaultPos
	self.fontBaseResolution = self.fontBaseResolution or {self.pos:x2X(1), self.pos:y2Y(1)}
	self.drawable = self.drawable or love.graphics.newImage(self.imagePath)
	self.quadX = self.quadX or 0
	self.quadY = self.quadY or 0
	self.quadWidth = self.quadWidth or self.drawable:getWidth()
	self.quadHeight = self.quadHeight or self.drawable:getHeight()
	self.quad = self.quad or love.graphics.newQuad(self.quadX, self.quadY, self.quadWidth, self.quadHeight, self.drawable:getWidth(), self.drawable:getHeight())
	self.quadObject = loveio.output.classes.QuadBox:new({
		x = self.x, y = self.y, w = self.w, h = self.h,
		drawable = self.drawable,
		quad = self.quad,
		layer = self.layer,
		locate = self.locate,
		xAlign = self.align[1],
		yAlign = self.align[2],
		pos = self.pos,
		quadWidth = self.quadWidth or self.drawable:getWidth(),
		quadHeight = self.quadHeight or self.drawable:getHeight()
	}):insert(loveio.output.objects)
	
	loveio.input.callbacks.mousepressed[tostring(self)] = function(mx, my)
		local x = self:getAbs("x", true)
		local y = self:getAbs("y", true)
		local w = self:getAbs("w")
		local h = self:getAbs("h")
		if isInBox(mx, my, x, y, w, h) then
			self:activate()
		end
	end
	loveio.input.callbacks.resize[tostring(self)] = function()
		self:valueChanged()
	end
	loveio.input.callbacks.resize[tostring(self)]()
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
			x = self.x + self.xPadding, y = self.y + ((self.yNotCentered and self.yPadding) or self.h / 2),
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
