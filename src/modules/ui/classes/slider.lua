local slider = {}

slider.new = function(self, data)
	local object = {}
	object.data = {}
	object.data.x = data.x or 0
	object.data.y = data.y or 0
	object.data.w = data.w or 160
	object.data.h = data.h or 40
	object.data.r = data.r or 4
	object.data.layer = data.layer or 2
	object.data.loaded = false
	object.data.pressed = false
	object.data.value = data.value or 0
	object.data.action = data.action or function() end
	object.data.name = data.name or "unnamedSlider"
	object.data.objectCount = 4
		
	object.update = function(command)
		local x, y, w, h, r, value = object.data.x, object.data.y, object.data.w, object.data.h, object.data.r, object.data.value
		local name = object.data.name
		if not object.data.loaded then
			loveio.output.objects[name .. 1] = {
				class = "rectangle",
				x = x, y = y,
				w = w, h = h,
				mode = "fill", color = {123,123,123,63}
			}
			loveio.output.objects[name .. 2] = {
				class = "rectangle",
				x = x + h / 2, y = y + h / 2 - 1,
				w = w - h, h = 2,
				mode = "fill"
			}
			loveio.output.objects[name .. 3] = {
				class = "circle",
				x = x + h / 2 + value * (w - h), y = y + h / 2,
				r = r,
				mode = "fill"
			}
			loveio.output.objects[name .. 4] = {
				class = "text",
				x = x + h / 2 + value * (w - h), y = y + h / 2 - r,
				xAlign = "center", yAlign = "top",
				text = object.data.value
			}
		end
		loveio.input.callbacks["object.data"] = {
			mousepressed = function(mx, my)
				if mx >= x and mx <= x + w and my >= y and my <= y + h then
					object.data.pressed = true
				end
			end,
			mousemoved = function(mx, my)
				if object.data.pressed then
					object.data.value = (mx - (x + h / 2)) / (w - h)
					object.data.value = math.floor(object.data.value * 100) / 100
					if object.data.value > 1 then object.data.value = 1
					elseif object.data.value < 0 then object.data.value = 0
					end
					loveio.output.objects[name .. 3].x = x + h / 2 + object.data.value * (w - h)
					loveio.output.objects[name .. 4].x = x + h / 2 + object.data.value * (w - h)
					object.data.action(object.data.value)
				end
			end,
			mousereleased = function(x, y)
				if object.data.pressed then object.data.pressed = false end
			end,
		}
		if command == "close" then
			objects[object.data.name] = nil
			loveio.input.callbacks[object.data.name] = nil
			for i = 1, object.data.objectCount do
				loveio.output.objects[name .. i] = nil
			end
		end
	end
	
	setmetatable(object, self)
	self.__index = self
	return object
end

return slider
