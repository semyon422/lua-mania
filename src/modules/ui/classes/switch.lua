local switch = {}

switch.new = function(self, data)
	local object = {}
	object.x = data.x or 0
	object.y = data.y or 0
	object.w = data.w or 1
	object.h = data.h or 1
	object.layer = data.layer or 2
	object.loaded = false
	object.oldValue = data.value or false
	object.value = data.value or object.oldValue
	object.getValue = data.getValue or function() return object.value end
	object.value = object.getValue()
	object.action = data.action or function() end
	object.name = data.name or "switch" .. math.random()
	object.objectCount = 2
		
	object.update = function(command)
		local x, y, w, h = object.x, object.y, object.w, object.h
		object.value = object.getValue()
		local oldValue = object.oldValue
		local value = object.value
		local name = object.name
		if oldValue ~= value or not object.loaded then
			loveio.output.objects[name .. 2] = {
				class = "text",
				x = x + w / 2, y = y + h / 2,
				text = tostring(object.value), xAlign = "center", yAlign = "center",
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
			loveio.input.callbacks[object.name] = {
				mousepressed = function(mx, my)
					if mx >= x and mx <= x + w and my >= y and my <= y + h then
						local mx = pos.X2x(mx)
						local my = pos.Y2y(my)
						if object.value == true then
							object.value = false
							loveio.output.objects[name .. 2].text = tostring(object.value)
						else
							object.value = true
							loveio.output.objects[name .. 2].text = tostring(object.value)
						end
						object.action(object.value)
					end
				end
			}
			object.loaded = true
		end
		if command == "close" then
			loveio.input.callbacks[name] = nil
			for i = 1, object.objectCount do
				loveio.output.objects[name .. i] = nil
			end
			objects[object.name] = nil
		end
		if command == "reload" then
			object.loaded = false
		end
	end
	
	setmetatable(object, self)
	self.__index = self
	return object
end

return switch
