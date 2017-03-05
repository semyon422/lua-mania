local init = function(classes, ui)
--------------------------------
local DrawableTextButton = classes.UiObject:new()

DrawableTextButton.layer = 2

DrawableTextButton.textXAlign = "center"
DrawableTextButton.textYAlign = "center"
DrawableTextButton.textXPadding = 0
DrawableTextButton.textYPadding = 0
DrawableTextButton.textColor = {255, 255, 255, 255}

DrawableTextButton.drawableXAlign = "center"
DrawableTextButton.drawableYAlign = "center"
DrawableTextButton.drawableXPadding = 0
DrawableTextButton.drawableYPadding = 0
DrawableTextButton.drawableColor = {255, 255, 255, 255}
DrawableTextButton.locate = "in"

DrawableTextButton.load = function(self)
	self.fontBaseResolution = {self.pos:x2X(1), self.pos:y2Y(1)}
	self.drawable = self.drawable or love.graphics.newImage(self.imagePath)
	self.drawableObject = loveio.output.classes.DrawableBox:new({
		x = self.x + self.drawableXPadding, y = self.y + self.drawableYPadding,
		w = self.w - 2*self.drawableXPadding, h = self.h - 2*self.drawableYPadding,
		drawable = self.drawable,
		xAlign = self.drawableXAlign, yAlign = self.drawableYAlign,
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
DrawableTextButton.unload = function(self)
	if self.loaded then
		self.drawableObject:remove()
		self["text-1"]:remove()
		loveio.input.callbacks.mousepressed[tostring(self)] = nil
		loveio.input.callbacks.resize[tostring(self)] = nil
	end
end
DrawableTextButton.valueChanged = function(self)
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

return DrawableTextButton
--------------------------------
end

return init
