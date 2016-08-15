local init = function(classes, ui)
--------------------------------
local List = {}

List.x = 0
List.y = 0
List.w = 1
List.h = 1
List.layer = 2
List.loaded = false
List.oldValue = 1
List.value = List.oldValue
List.xAlign = "center"
List.yAlign = "center"
List.action = function() end
List.objectCount = 2
List.textColor = {255, 255, 255, 255}
List.backgroundColor = {0, 0, 0, 127}
List.update = function() end
List.objects = {{}}
List.apply = false

List.new = function(self, object)
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "List" .. math.random()
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
		end
		
		if oldValue ~= value or not object.loaded then
			------
			object.oldValue = value
		end
		if not object.loaded then
			------
			object.loaded = true
		end
	end
	
	if object.apply then
		loveio.objects[object.name] = object
	end
	return object
end

return List
--------------------------------
end

return init