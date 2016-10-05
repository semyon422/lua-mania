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
	self["rectangle-1"] = loveio.output.classes.Rectangle:new({
		x = self.x, y = self.y,
		w = self.w, h = self.h,
		mode = "fill", color = self.backgroundColor,
		layer = self.layer
	}):insert(loveio.output.objects)
	
	loveio.input.callbacks.mousepressed[tostring(self)] = function(mx, my)
		local mx = pos:X2x(mx, true)
		local my = pos:Y2y(my, true)
		if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
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
	self["text-1"] = loveio.output.classes.Text:new({
		x = self.x + self.xPadding, y = self.y + self.h / 2,
		limit = self.w - 2*self.xPadding,
		text = self.value, xAlign = self.xAlign, yAlign = self.yAlign,
		font = self.font,
		color = self.textColor,
		layer = self.layer + 1
	}):insert(loveio.output.objects)
	self.oldValue = value
end

return Button
--------------------------------
end

return init
