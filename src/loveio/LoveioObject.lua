local init = function(loveio)
--------------------------------
local LoveioObject = {}

LoveioObject.new = function(self, object)
	local object = object or {}
	setmetatable(object, self)
	self.__index = self
	
	return object
end

LoveioObject.update = function(self)	
	self:preUpdate()
	if not self.loaded then
		self:load()
		self.loaded = true
	end
	self:postUpdate()
end
LoveioObject.preUpdate = function(self)
end
LoveioObject.postUpdate = function(self)
end

LoveioObject.load = function(self)
end
LoveioObject.unload = function(self)
end

LoveioObject.remove = function(self)
	self:unload()
	if self.insertTraget then self.insertTraget[tostring(self)] = nil end
end
LoveioObject.reload = function(self)
	self:unload()
	self:load()
end
LoveioObject.insert = function(self, target)
	self.insertTraget = target
	target[tostring(self)] = self
	return self
end

return LoveioObject
--------------------------------
end

return init
