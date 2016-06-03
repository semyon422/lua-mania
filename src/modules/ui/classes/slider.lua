local slider = {}

slider.new = function(self, data)
	local object = {}
	object.x = data.x or 0
	object.y = data.y or 0
	object.w = data.w or 1
	object.h = data.h or 1
	object.r = data.r or 4
	object.layer = data.layer or 2
	object.loaded = false
	object.pressed = false
	object.minvalue = data.minvalue or 0
	object.maxvalue = data.maxvalue or 1
	object.round = data.round or false
	object.oldValue = data.value or object.minvalue
	object.value = data.value or object.oldValue
	object.getValue = data.getValue or function() return object.value end
	object.value = object.getValue()
	object.action = data.action or function() end
	object.name = data.name or "slider" .. math.random()
	object.objectCount = 4
		
	object.update = function(command)
		local x, y, w, h, r = object.x, object.y, object.w, object.h, object.r
		object.value = object.getValue()
		local oldValue = object.oldValue
		local value = object.value
		local minvalue = object.minvalue
		local maxvalue = object.maxvalue
		local name = object.name
		
		if oldValue ~= value or not object.loaded then
			loveio.output.objects[name .. 3] = {
				class = "circle",
				x = x + h / 2 + value / (maxvalue - minvalue) * (w - h), y = y + h / 2,
				r = r,
				mode = "fill",
				layer = object.layer + 1
			}
			loveio.output.objects[name .. 4] = {
				class = "text",
				x = x + h / 2 + value / (maxvalue - minvalue) * (w - h), y = y + h / 2 - r,
				xAlign = "center", yAlign = "top",
				text = object.value,
				layer = object.layer + 1
			}
		end
		if not object.loaded then
			loveio.output.objects[name .. 1] = {
				class = "rectangle",
				x = x, y = y,
				w = w, h = h,
				mode = "fill", color = {0,0,0,127},
				layer = object.layer
			}
			loveio.output.objects[name .. 2] = {
				class = "rectangle",
				x = x + h / 2, y = y + h / 2 - 1,
				w = w - h, h = 2,
				mode = "fill",
				layer = object.layer + 1
			}
			loveio.input.callbacks[name] = {
				mousepressed = function(mx, my)
					if mx >= x and mx <= x + w and my >= y and my <= y + h then
						local mx = pos.X2x(mx)
						local my = pos.Y2y(my)
						object.pressed = true
						loveio.input.callbacks[name].mousemoved(mx, my)
					end
				end,
				mousemoved = function(mx, my)
					local mx = pos.X2x(mx)
					local my = pos.Y2y(my)
					if object.pressed then
						object.value = (mx - (x + h / 2)) * (maxvalue - minvalue) / (w - h)
						if type(object.round) == "function" then
							object.value = object.round(object.value)
						end
						if object.value > maxvalue then object.value = maxvalue
						elseif object.value < minvalue then object.value = minvalue
						end
						loveio.output.objects[name .. 3].x = x + h / 2 + object.value / (maxvalue - minvalue) * (w - h)
						loveio.output.objects[name .. 4].x = x + h / 2 + object.value / (maxvalue - minvalue) * (w - h)
						loveio.output.objects[name .. 4].text = object.value
						object.action(object.value)
					end
				end,
				mousereleased = function(mx, my)
					if object.pressed then object.pressed = false end
				end,
			}
			object.loaded = true
		end
		if command == "close" then
			objects[name] = nil
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
		end
		if command == "reload" then
			object.loaded = false
		end
	end
	
	setmetatable(object, self)
	self.__index = self
	return object
end

return slider
