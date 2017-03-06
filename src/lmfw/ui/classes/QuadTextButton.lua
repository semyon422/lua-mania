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
	self.fontBaseResolution = self.fontBaseResolution or {self.pos:x2X(1), self.pos:y2Y(1)}
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
		if isInBox(mx, my, x, y, w, h) then
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
QuadTextButton.valueChanged = classes.DrawableTextButton.valueChanged

return QuadTextButton
--------------------------------
end

return init
