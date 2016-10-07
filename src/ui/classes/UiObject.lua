local init = function(classes, ui)
--------------------------------
local UiObject = loveio.LoveioObject:new()

UiObject.x = 0
UiObject.y = 0
UiObject.w = 1
UiObject.h = 1
UiObject.r = 1
UiObject.layer = 1
UiObject.objectCount = 1

UiObject.update = function(self)
	if self.hidden then return end
	if self.getValue then self.value = self.getValue() end
	
	if self.value ~= nil and (self.oldValue ~= self.value or not self.loaded) then
		self:valueChanged()
		self.oldValue = self.value
	end
	if not self.loaded then
		self:load()
		self.loaded = true
	end
end

UiObject.set = loveio.output.classes.OutputObject.set
UiObject.get = loveio.output.classes.OutputObject.get

UiObject.valueChanged = function(self)

end

UiObject.activate = function(self)
	if self.action then
		if self.group and ui.accessableGroups[self.group] or not self.group then
			self:action()
		end
	end
end
UiObject.hide = function(self)
	self:unload()
	self.hidden = true
end
UiObject.show = function(self)
	self:load()
	self.hidden = false
end

return UiObject
--------------------------------
end

return init
