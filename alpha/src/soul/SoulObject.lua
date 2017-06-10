soul.SoulObject = createClass()
local SoulObject = soul.SoulObject

SoulObject.loaded = false

SoulObject.update = function(self) end

SoulObject.load = function(self)
	self.loaded = true
end
SoulObject.unload = function(self)
	self.loaded = false
end

SoulObject.reload = function(self)
	self:unload()
	self:load()
end

SoulObject.deactivate = function(self)
	self:unload()
	soul.objects[self] = nil
end
SoulObject.activate = function(self)
	self:load()
	soul.objects[self] = self
end