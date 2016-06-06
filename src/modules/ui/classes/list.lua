local list = {}

list.x = 0
list.y = 0
list.w = 1
list.h = 1
list.layer = 2
list.loaded = false
list.oldValue = 1
list.value = list.oldValue
list.xAlign = "center"
list.yAlign = "center"
list.action = function() end
list.objectCount = 2
list.textColor = {255, 255, 255, 255}
list.backgroundColor = {0, 0, 0, 127}
list.update = function() end
list.objects = {{}}
list.apply = false

list.new = function(self, object)
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "list" .. math.random()
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

return list