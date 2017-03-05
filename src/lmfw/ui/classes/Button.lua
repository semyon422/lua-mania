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
	local pos = self.pos or pos
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
	self:valueChanged()
	self.loaded = true
end
Button.unload = function(self)
	if self["rectangle-1"] then self["rectangle-1"]:remove() end
	loveio.input.callbacks.mousepressed[tostring(self)] = nil
	if self["text-1"] then self["text-1"]:remove() end
end
Button.valueChanged = function(self)
	if self["text-1"] then self["text-1"]:remove() end
	self["text-1"] = loveio.output.classes.TextBox:new({
		x = self.x + self.xPadding, y = self.y + self.yPadding,
		w = self.w - 2*self.xPadding,
		h = self.h - 2*self.yPadding,
		text = self.value, xAlign = self.xAlign, yAlign = self.yAlign,
		font = self.font,
		color = self.textColor,
		layer = self.layer + 1,
		pos = self.pos
	}):insert(loveio.output.objects)
	self.oldValue = value
end

return Button
--------------------------------
end

return init
