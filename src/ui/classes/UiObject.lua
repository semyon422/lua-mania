local UiObject = {}

UiObject.x = 0
UiObject.y = 0
UiObject.w = 1
UiObject.h = 1
UiObject.layer = 1
UiObject.objectCount = 1
UiObject.accesable = true
UiObject.accessLevel = 1

UiObject.new = function(self, object)
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

UiObject.load = function()

end
UiObject.unload = function()

end
UiObject.valueChanged = function()

end

UiObject.activate = function(self)
	if self.action then self:action() end
end
UiObject.remove = function(self)
	self:hide()
	loveio.objects[self.name] = nil
end
UiObject.reload = function(self)
	self:unload()
	self:load()
end
UiObject.hide = function(self)
	--loveio.input.callbacks[name] = nil
	for i = 1, self.objectCount do
		loveio.output.objects[name .. i] = nil
	end
	self.hidden = true
end
UiObject.show = function(self)
	self.hidden = false
	self.loaded = false
end

return UiObject
