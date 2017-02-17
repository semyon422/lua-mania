local List = loveio.LoveioObject:new()

List.new = function(self)
	local list = {}
	list.itemsById = {}
	list.itemsByIndex = {}
	list.buttons = {}
	
	setmetatable(list, self)
	self.__index = self

	return list
end

local Button = ui.classes.Button:new()

List.load = function(self)
	
end

List.postUpdate = function(self)
	if not self.scrollTargetIndex and self.scrollTargetId then
		for index, item in ipairs(self.itemsByIndex) do
			if item.id == self.scrollTargetId then
				self.scrollTargetId = nil
				self.scrollTargetIndex = index
				break
			end
		end
	end
	if self.scrollTargetIndex then
		if self.scroll < self.scrollTargetIndex then
			self.scroll = self.scroll + 1
		elseif self.scroll > self.scrollTargetIndex then
			self.scroll = self.scroll - 1
		end
	end
end

List.unload = function(self)
end


List.insertItem = function(self, item, id, index)
	self.itemsById[id] = item
	if index then
		table.insert(self.itemsByIndex, index, item)
	else
		table.insert(self.itemsByIndex, item)
	end
end
List.removeItem = function(self, id, index)
	if index then
		local item = self.itemsByIndex[index]
		self.itemsById[item.id] = nil
		self.itemsByIndex[index] = nil
	elseif id then
		for index, item in ipairs(self.itemsByIndex) do
			if item.id == id then
				self.itemsByIndex[index] = nil
				break
			end
		end
		self.itemsById[id] = nil
	end
end


List.select = function(self, id, index, pre)
	local id, index = id, index
	if id and self.itemsById[id] then
		index = nil
	elseif index and self.itemsByIndex[index] then
		id = nil
	end
	if pre then
		self.preSelectedId = id
		self.preSelectedIndex = index
	else
		self.selectedId = id
		self.selectedIndex = index
	end
	self:goTo(id, index)
end
List.goTo = function(self, id, index)
	local id, index = id, index
	if id and self.itemsById[id] then
		index = nil
	elseif index and self.itemsByIndex[index] then
		id = nil
	end
	self.scrollTargetId = id
	self.scrollTargetIndex = index
end


