local init = function(classes, ui)
--------------------------------
local QuadTextButton = classes.UiObject:new()

QuadTextButton.layer = 2

QuadTextButton.textXAlign = "center"
QuadTextButton.textYAlign = "center"
QuadTextButton.textXPadding = 0
QuadTextButton.textYPadding = 0
QuadTextButton.textColor = {255, 255, 255, 255}

QuadTextButton.quadXAlign = "center"
QuadTextButton.quadYAlign = "center"
QuadTextButton.quadXPadding = 0
QuadTextButton.quadYPadding = 0
QuadTextButton.quadColor = {255, 255, 255, 255}
QuadTextButton.locate = "in"

QuadTextButton.load = function(self)
	self.fontBaseResolution = {self.pos:x2X(1), self.pos:y2Y(1)}
	self.drawable = self.drawable or love.graphics.newImage(self.imagePath)
	self.quad = self.quad or love.graphics.newQuad(self.quadX, self.quadY, self.quadWidth, self.quadHeight, self.drawable:getWidth(), self.drawable:getHeight())
	self.quadObject = loveio.output.classes.QuadBox:new({
		x = self.x + self.quadXPadding, y = self.y + self.quadYPadding,
		w = self.w - 2*self.quadXPadding, h = self.h - 2*self.quadYPadding,
		drawable = self.drawable, quad = self.quad,
		xAlign = self.quadXAlign, yAlign = self.quadYAlign,
		quadWidth = self.quadWidth,
		quadHeight = self.quadHeight,
		layer = self.layer,
		locate = self.locate,
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
		self:valueChanged()
	end
	self:valueChanged()
end
QuadTextButton.unload = function(self)
	if self.loaded then
		self.quadObject:remove()
		self["text-1"]:remove()
		loveio.input.callbacks.mousepressed[tostring(self)] = nil
		loveio.input.callbacks.resize[tostring(self)] = nil
	end
end
QuadTextButton.valueChanged = function(self)
	if self["text-1"] then self["text-1"]:remove() end
	local sx = self.pos:x2X(1) / self.fontBaseResolution[1] * self.pos.scale[1]
	local sy = self.pos:y2Y(1) / self.fontBaseResolution[2] * self.pos.scale[2]
	self["text-1"] = loveio.output.classes.TextBox:new({
		x = self.x + self.textXPadding*sx, y = self.y + self.textYPadding*sy,
		w = self.w/sx - 2*self.textXPadding*sx,
		h = self.h - 2*self.textYPadding*sx,
		text = self.value, xAlign = self.textXAlign, yAlign = self.textYAlign,
		font = self.font,
		color = self.textColor,
		layer = self.layer + 1,
		pos = self.pos,
		sx = sx, sy = sy
	}):insert(loveio.output.objects)
end

return QuadTextButton
--------------------------------
end

return init
