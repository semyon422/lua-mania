local init = function(...)
--------------------------------
local HitObject = {}

HitObject.data = {}

HitObject.new = function(self, hitObject)
	local hitObject = hitObject or {}
	setmetatable(hitObject, self)
	self.__index = self
	return hitObject
end

HitObject.import = function(self, line)
	local breaked = explode(",", line)
	
	self.x = tonumber(breaked[1])
	self.y = tonumber(breaked[2])
	self.startTime = tonumber(breaked[3])
	self.type = tonumber(breaked[4])
	self.hitSound = tonumber(breaked[5])
	
	if bit.band(self.type, 128) == 128 then
		local addition = explode(":", breaked[6])
		self.endTime = tonumber(addition[1])
	end
	
	return self
end
HitObject.export = function(self)

end

return HitObject
--------------------------------
end

return init