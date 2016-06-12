local switch = {}

switch.x = 0
switch.y = 0
switch.w = 1
switch.h = 1
switch.layer = 2
switch.loaded = false
switch.oldValue = false
switch.value = switch.oldValue
switch.xAlign = "center"
switch.yAlign = "center"
switch.action = function() end
switch.objectCount = 2
switch.textColor = {255, 255, 255, 255}
switch.backgroundColor = {0, 0, 0, 127}
switch.font = nil
switch.update = function() end
switch.hidden = false
switch.apply = false

switch.new = function(self, object)
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "switch" .. math.random()
	object.getValue = object.getValue or function() return object.value end
		
	object.update = function(command)
		local x, y, w, h = object.x, object.y, object.w, object.h
		local name = object.name
		local oldValue = object.oldValue
		object.value = object.getValue()
		local value = object.value
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
				font = object.font,
				color = object.textColor,
				layer = object.layer + 1
			}
		end
		if not object.loaded then
			loveio.output.objects[name .. 1] = {
				class = "rectangle",
				x = x, y = y,
				w = w, h = h,
				mode = "fill", color = object.backgroundColor,
				layer = object.layer
			}
			loveio.input.callbacks[callbackName][object.name] = function(mx, my)
				local mx = pos.X2x(mx, true)
				local my = pos.Y2y(my, true)
				if mx >= x and mx <= x + w and my >= y and my <= y + h then
					local mx = pos.X2x(mx, true)
					local my = pos.Y2y(my, true)
					object.update("activate")
				end
			end
			object.loaded = true
		end
	end
	
	if object.apply then
		loveio.objects[object.name] = object
	end
	return object
end

return switch
