local init = function(classes, ui)
--------------------------------
local Slider = classes.UiObject:new()

Slider.r = 0.005
Slider.layer = 2
Slider.minvalue = 0
Slider.maxvalue = 1
Slider.oldValue = Slider.minvalue
Slider.value = Slider.oldValue
Slider.xAlign = "center"
Slider.yAlign = "top"
Slider.textColor = {255, 255, 255, 255}
Slider.backgroundColor = {0, 0, 0, 127}

Slider.load = function(self)
	loveio.output.objects[tostring(self) .. "-rectangle-1"] = loveio.output.classes.Rectangle:new({
		x = self.x, y = self.y,
		w = self.w, h = self.h,
		mode = "fill", color = self.backgroundColor,
		layer = self.layer
	})
	loveio.output.objects[tostring(self) .. "-rectangle-2"] = loveio.output.classes.Rectangle:new({
		x = self.x + self.h / 2, y = self.y + self.h / 2 - pos:Y2y(1),
		w = self.w - self.h, h = pos:Y2y(2),
		mode = "fill",
		layer = self.layer + 1,
		color = self.textColor
	})
	loveio.input.callbacks.mousepressed[tostring(self)] = function(mx, my)
		local oldmx = mx
		local oldmy = my
		local mx = pos:X2x(mx, true)
		local my = pos:Y2y(my, true)
		if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
			self.pressed = true
			loveio.input.callbacks.mousemoved[tostring(self)](oldmx, oldmy)
		end
	end
	loveio.input.callbacks.mousemoved[tostring(self)] = function(mx, my)
		local mx = pos:X2x(mx, true)
		local my = pos:Y2y(my, true)
		if self.pressed then
			self.value = (mx - (self.x + self.h / 2)) / (self.w - self.h) * (self.maxvalue - self.minvalue)
			if type(self.round) == "function" then
				self.value = self.round(self.value)
			end
			if self.value > self.maxvalue then self.value = self.maxvalue
			elseif self.value < self.minvalue then self.value = self.minvalue
			end
			self:action()
		end
	end
	loveio.input.callbacks.mousereleased[tostring(self)] = function(mx, my)
		if self.pressed then self.pressed = false end
	end
	self:valueChanged()
	self.loaded = true
end
Slider.unload = function(self)

end
Slider.valueChanged = function(self)
	loveio.output.objects[tostring(self) .. 3] = loveio.output.classes.Circle:new({
		x = self.x + self.h / 2 + self.value / (self.maxvalue - self.minvalue) * (self.w - self.h), y = self.y + self.h / 2,
		r = self.r,
		mode = "fill",
		layer = self.layer + 1,
		color = self.textColor
	})
	loveio.output.objects[tostring(self) .. 4] = loveio.output.classes.Text:new({
		x = self.x, y = self.y + self.h / 2 - self.r, limit = (self.h / 2 + self.value / (self.maxvalue - self.minvalue) * (self.w - self.h)) * 2,
		xAlign = self.xAlign, yAlign = self.yAlign,
		text = self.value,
		font = self.font,
		layer = self.layer + 1,
		color = self.textColor
	})
	self.oldValue = value
end

return Slider
--------------------------------
end

return init
