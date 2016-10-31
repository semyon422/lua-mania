local init = function(output, loveio)
--------------------------------
local OutputObject = loveio.LoveioObject:new()

OutputObject.x = 0
OutputObject.y = 0
OutputObject.color = {255, 255, 255, 255}

OutputObject.draw = function(self)
end

OutputObject.getAbs = function(self, key, g)
	local pos = self.pos or pos
	if key:find("x") or key:find("w") or key:find("r") or key:find("limit") then
		return pos:x2X(self[key], g)
	elseif key:find("y") or key:find("h") then
		return pos:y2Y(self[key], g)
	end
end

return OutputObject
--------------------------------
end

return init