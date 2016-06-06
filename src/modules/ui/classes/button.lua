local button = {}

button.x = 0
button.y = 0
button.w = 1
button.h = 1
button.layer = 2
button.loaded = false
button.oldValue = ""
button.value = button.oldValue
button.xAlign = "center"
button.yAlign = "center"
button.action = function() end
button.objectCount = 2
button.textColor = {255, 255, 255, 255}
button.backgroundColor = {0, 0, 0, 127}
button.update = function() end
button.hidden = false
button.apply = false

button.new = function(self, object)
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "button" .. math.random()
	object.getValue = object.getValue or function() return object.value end
		
	object.update = function(command)
		local x, y, w, h = object.x, object.y, object.w, object.h
		local name = object.name
		local oldValue = object.oldValue
		object.value = object.getValue()
		local value = object.value
		if command == "activate" then
			object.action(object.value)
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
		elseif command == "hide" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			object.hidden = true
			return
		elseif command == "show" then
			object.hidden = false
			object.loaded = false
		end
		if object.hidden then return end
		
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
				mode = "fill", color = object.backgroundColor,
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
	end
	
	if object.apply then
		loveio.objects[object.name] = object
	end
	return object
end

return button
