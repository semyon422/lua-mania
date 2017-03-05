local init = function(classes, ui)
--------------------------------
local Button = classes.UiObject:new()

Button.layer = 2
Button.xAlign = "center"
Button.yAlign = "center"
Button.xPadding = 0
Button.yPadding = 0
Button.textColor = {255, 255, 255, 255}
Button.backgroundColor = {0, 0, 0, 127}

Button.load = function(self)
	self.fontBaseResolution = {self.pos:x2X(1), self.pos:y2Y(1)}
	self["rectangle-1"] = loveio.output.classes.Rectangle:new({
		x = self.x, y = self.y,
		w = self.w, h = self.h,
		mode = "fill", color = self.backgroundColor,
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
		self:valueChanged()
	end
	self:valueChanged()
end
Button.unload = function(self)
	if self.loaded then
		self["rectangle-1"]:remove()
		self["text-1"]:remove()
		loveio.input.callbacks.mousepressed[tostring(self)] = nil
		loveio.input.callbacks.resize[tostring(self)] = nil
	end
end
Button.valueChanged = function(self)
	if self["text-1"] then self["text-1"]:remove() end
	local sx = self.pos:x2X(1) / self.fontBaseResolution[1] * self.pos.scale[1]
	local sy = self.pos:y2Y(1) / self.fontBaseResolution[2] * self.pos.scale[2]
	self["text-1"] = loveio.output.classes.TextBox:new({
		x = self.x + self.xPadding*sx, y = self.y + self.yPadding*sy,
		w = self.w/sx - 2*self.xPadding*sx,
		h = self.h - 2*self.yPadding*sx,
		text = self.value, xAlign = self.xAlign, yAlign = self.yAlign,
		font = self.font,
		color = self.textColor,
		layer = self.layer + 1,
		pos = self.pos,
		sx = sx, sy = sy
	}):insert(loveio.output.objects)
	self.oldValue = value
end

return Button
--------------------------------
end

return init
