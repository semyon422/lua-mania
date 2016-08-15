local init = function(output, loveio)
--------------------------------
local OutputObject = {}

OutputObject.x = 0
OutputObject.y = 0
OutputObject.color = {255, 255, 255, 255}

OutputObject.new = function(self, object)
	local object = object or {}
	self.__index = self
	setmetatable(object, self)
	return object
end

OutputObject.draw = function(self)
end

OutputObject.set = function(self, key, value)
	self[key] = value
end
OutputObject.get = function(self, key, g)
	if string.lower(key) == key then
		if key:find("x") or key:find("w") or key:find("r") or key:find("limit") then
			return self[key] or pos.X2x(self[key:upper()], g)
		elseif key:find("y") or key:find("h") then
			return self[key] or pos.Y2y(self[key:upper()], g)
		end
	elseif string.upper(key) == key then
		if key:find("X") or key:find("W") or key:find("R") or key:find("LIMIT") then
			return self[key] or pos.x2X(self[key:lower()], g)
		elseif key:find("Y") or key:find("H") then
			return self[key] or pos.y2Y(self[key:lower()], g)
		end
	end
end

return OutputObject
--------------------------------
end

return init