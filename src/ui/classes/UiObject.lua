local init = function(classes, ui)
--------------------------------
local UiObject = {}

UiObject.x = 0
UiObject.y = 0
UiObject.w = 1
UiObject.h = 1
UiObject.r = 1
UiObject.layer = 1
UiObject.objectCount = 1
UiObject.accesable = true
UiObject.accessLevel = 1

UiObject.new = function(self, object)
	local object = object or {}
	setmetatable(object, self)
	self.__index = self
	
	object.name = object.name or "UiObject" .. math.random()
	
	if object.apply then
		loveio.objects[object.name] = object
	end
	return object
end

UiObject.update = function(self)
	if self.getValue then self.value = self.getValue() end
	if self.hidden then return end
	
	if self.value ~= nil and (self.oldValue ~= self.value or not self.loaded) then
		self:valueChanged()
		self.oldValue = self.value
	end
	if not self.loaded then
		self:load()
		self.loaded = true
	end
end

UiObject.set = function(self, key, value)
	self[key] = value
end
UiObject.get = loveio.output.classes.OutputObject.get

UiObject.load = function(self)

end
UiObject.unload = function(self)

end
UiObject.valueChanged = function(self)

end

UiObject.activate = function(self)
	if self.action then self:action() end
end
UiObject.remove = function(self)
	self:unload()
	loveio.objects[self.name] = nil
end
UiObject.reload = function(self)
	self:unload()
	self:load()
	self:valueChanged()
end
UiObject.show = function(self)
	self.hidden = false
	self.loaded = false
end

return UiObject
--------------------------------
end

return init
