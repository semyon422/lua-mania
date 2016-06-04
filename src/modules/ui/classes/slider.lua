local slider = {}

slider.x = 0
slider.y = 0
slider.w = 1
slider.h = 1
slider.r = pos.X2x(4)
slider.layer = 2
slider.loaded = false
slider.minvalue = 0
slider.maxvalue = 1
slider.oldValue = slider.minvalue
slider.value = slider.oldValue
slider.xAlign = "center"
slider.yAlign = "top"
slider.action = function() end
slider.objectCount = 4
slider.textColor = {255, 255, 255, 255}
slider.backgroundColor = {0, 0, 0, 127}
slider.update = function() end
slider.pressed = false
slider.apply = false
slider.round = false

slider.new = function(self, object)
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "slider" .. math.random()
	object.getValue = object.getValue or function() return object.value end
		
	object.update = function(command)
		local x, y, w, h, r = object.x, object.y, object.w, object.h, object.r
		object.value = object.getValue()
		local oldValue = object.oldValue
		local value = object.value
		local minvalue = object.minvalue
		local maxvalue = object.maxvalue
		local name = object.name
		if command == "activate" then
			object.action(value)
			return
		elseif command == "close" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			loveio.objects[name] = nil
			return
		elseif command == "reload" then
			object.loaded = false
			return
		end
		
		if oldValue ~= value or not object.loaded then
			loveio.output.objects[name .. 3] = {
				class = "circle",
				x = x + h / 2 + value / (maxvalue - minvalue) * (w - h), y = y + h / 2,
				r = r,
				mode = "fill",
				layer = object.layer + 1,
				color = object.textColor
			}
			loveio.output.objects[name .. 4] = {
				class = "text",
				x = x, y = y + h / 2 - r, limit = (h / 2 + value / (maxvalue - minvalue) * (w - h)) * 2,
				xAlign = object.xAlign, yAlign = object.yAlign,
				text = object.value,
				layer = object.layer + 1,
				color = object.textColor
			}
			object.oldValue = value
		end
		if not object.loaded then
			loveio.output.objects[name .. 1] = {
				class = "rectangle",
				x = x, y = y,
				w = w, h = h,
				mode = "fill", color = object.backgroundColor,
				layer = object.layer
			}
			loveio.output.objects[name .. 2] = {
				class = "rectangle",
				x = x + h / 2, y = y + h / 2 - pos.Y2y(1),
				w = w - h, h = pos.Y2y(2),
				mode = "fill",
				layer = object.layer + 1,
				color = object.textColor
			}
			loveio.input.callbacks[name] = {
				mousepressed = function(mx, my)
					local oldmx = mx
					local oldmy = my
					local mx = pos.X2x(mx, true)
					local my = pos.Y2y(my, true)
					if mx >= x and mx <= x + w and my >= y and my <= y + h then
						object.pressed = true
						loveio.input.callbacks[name].mousemoved(oldmx, oldmy)
					end
				end,
				mousemoved = function(mx, my)
					local mx = pos.X2x(mx, true)
					local my = pos.Y2y(my, true)
					if object.pressed then
						object.value = (mx - (x + h / 2)) / (w - h) * (maxvalue - minvalue)
						if type(object.round) == "function" then
							object.value = object.round(object.value)
						end
						if object.value > maxvalue then object.value = maxvalue
						elseif object.value < minvalue then object.value = minvalue
						end
						object.action(object.value)
					end
				end,
				mousereleased = function(mx, my)
					if object.pressed then object.pressed = false end
				end,
			}
			object.loaded = true
		end
	end
	
	if object.apply then
		loveio.objects[object.name] = object
	end
	return object
end

return slider
