local button = {}

button.new = function(self, data)
	local object = {}
	object.x = data.x or 0
	object.y = data.y or 0
	object.w = data.w or 1
	object.h = data.h or 1
	object.layer = data.layer or 2
	object.loaded = false
	object.oldValue = data.value or ""
	object.value = data.value or object.oldValue
	object.getValue = data.getValue or function() return object.value end
	object.value = object.getValue()
	object.xAlign = data.xAlign or "center"
	object.action = data.action or function() end
	object.name = data.name or "button" .. math.random()
	object.objectCount = 2
	object.textColor = data.textColor
	object.BGColor = data.BGColor or {0,0,0,127}
		
	object.update = function(command)
		local x, y, w, h = object.x, object.y, object.w, object.h
		object.value = object.getValue()
		local oldValue = object.oldValue
		local value = object.value
		local name = object.name
		
		if oldValue ~= value or not object.loaded then
			loveio.output.objects[name .. 2] = {
				class = "text",
				x = x, y = y + h / 2,
				limit = w,
				text = object.value, xAlign = object.xAlign, yAlign = "center",
				color = object.textColor,
				layer = object.layer + 1
			}
			object.oldValue = value
		end
		if not object.loaded then
			loveio.output.objects[name .. 1] = {
				class = "rectangle",
				x = x, y = y,
				w = w, h = h,
				mode = "fill", color = object.BGColor,
				layer = object.layer
			}
			loveio.input.callbacks[object.name] = {
				mousepressed = function(mx, my)
					local mx = pos.X2x(mx, true)
					local my = pos.Y2y(my, true)
					if mx >= x and mx <= x + w and my >= y and my <= y + h then
						object.update("activate")
					end
				end
			}
			object.loaded = true
		end
		if command == "activate" then
			object.action(object.value)
		elseif command == "close" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			objects[object.name] = nil
		elseif command == "reload" then
			object.loaded = false
		end
	end
	
	setmetatable(object, self)
	self.__index = self
	return object
end

return button
