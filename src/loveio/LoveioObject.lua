local init = function(loveio)
--------------------------------
local LoveioObject = {}

LoveioObject.new = function(self, object)
	local object = object or {}
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "LoveioObject" .. math.random()
	
	if object.insert then
		object.insert[object.name] = object
	end
	return object
end

LoveioObject.update = function(self)	
	if not self.loaded then
		self:load()
		self.loaded = true
	end
end

LoveioObject.load = function(self)

end
LoveioObject.unload = function(self)

end

LoveioObject.remove = function(self)
	self:unload()
	if self.insert then self.insert[self.name] = nil end
end
LoveioObject.reload = function(self)
	self:unload()
	self:load()
end

return LoveioObject
--------------------------------
end

return init
