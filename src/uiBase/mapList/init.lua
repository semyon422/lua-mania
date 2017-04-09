local mapList = loveio.LoveioObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = require("uiBase.mapList.Button")(mapList)

local groupSortRules = require("uiBase.mapList.groupSortRules")
local group = function(list)
	local stage = 1
	local list = list
	local nextList = {}
	
	while true do
		local id2index = {}
		for _, object in ipairs(list) do
			local data, title, id = groupSortRules.getGroupInfo(object, stage)
			if not id2index[id] then
				local index = #nextList + 1
				id2index[id] = index
				nextList[index] = {
					title = title,
					data = data,
					filePath = data.filePath,
					stage = stage
				}
			end
			local groupTable = nextList[id2index[id]]
			table.insert(groupTable, object)
		end
		for _, groupTable in ipairs(nextList) do
			table.sort(groupTable, groupSortRules.getSortFunction(stage))
		end
		if #nextList == 1 then break end
		list = nextList
		nextList = {}
		stage = stage + 1
	end
	
	return list
end

local compileList
compileList = function(groupedSortedList, list)
	for _, groupTable in ipairs(groupedSortedList) do
		table.insert(list, groupTable)
		groupTable.action = function(self)
			table.insert(mapList.backWay, mapList.list)
			mapList.list = self
			mapList.scroll = 1
			mapList:reload()
		end
	end
end
mapList.genList = function(self, cacheList)
	if not self.sourceList then
		self.sourceList = {}
		for filePath, object in pairs(cacheList) do
			table.insert(self.sourceList, object)
		end
	end
	
	if not self.groupedSortedList then
		self.groupedSortedList = group(self.sourceList)
	end
	-- local list = compileList(self.groupedSortedList, list)
	local list = self.groupedSortedList
	
	return list
end

mapList.load = function(self)
	self.buttons = {}
	self.dy = 1/16
	self.scrollOffset = 1 / self.dy / 2
	self.scroll = self.scroll or 1
	self.scrollTarget = self.scroll
	self.liveZone = self.dy*3
	
	self.backWay = self.backWay or {}
	
	self.list = self.list or (mainMenuList or {{title = "empty mapList"}})
	
	self.callbacks = self.callbacks or require("uiBase.mapList.callbacks")(self)
	loveio.input.callbacks.wheelmoved[tostring(self)] = self.callbacks.wheelmoved
	loveio.input.callbacks.keypressed[tostring(self)] = self.callbacks.keypressed
end

mapList.scrollTo = function(self, scroll)
	if scroll < 1 then scroll = 1
	elseif scroll > #self.list then scroll = #self.list
	end
	self.scrollTarget = scroll
	self:calcButtons()
end

mapList.postUpdate = function(self)
	self.scroll = math.ceil(self.scrollTarget)
	self:calcButtons()
end

mapList.calcButtons = function(self)
	local itemIndexKeys = {}
	for buttonIndex, button in pairs(self.buttons) do
		button.buttonIndex = buttonIndex
		itemIndexKeys[button.itemIndex] = button
	end
	local yMin = 0 - self.liveZone - Button.h
	local yMax = 1 + self.liveZone
	local itemIndexMin = math.ceil(yMin / self.dy + 1 + self.scroll - self.scrollOffset)
	local itemIndexMax = math.floor(yMax / self.dy + 1 + self.scroll - self.scrollOffset)
	for itemIndex = itemIndexMin, itemIndexMax do
		local item = self.list[itemIndex]
		if item then
			local y = self.dy * (itemIndex - 1 - self.scroll + self.scrollOffset)
			if not itemIndexKeys[itemIndex] then
				local xSpawn = Button.xSpawn
				if y >= 0 and y <= 1 then
					xSpawn = Button.xSpawn
				end
				local drawable, quad, quadX, quadY, quadWidth, quadHeight
				drawable = Button.drawable
				quadX = 0
				quadY = 0
				quadWidth = drawable:getWidth()
				quadHeight = drawable:getHeight()
				quad = love.graphics.newQuad(quadX, quadY, quadWidth, quadHeight, drawable:getWidth(), drawable:getHeight())
				local value, action = self:itemGetInfo(item, itemIndex)
				local button = Button:new({
					drawable = drawable, quad = quad,
					x = xSpawn, y = y, quadX = quadX, quadY = quadY,
					quadWidth = quadWidth, quadHeight = quadHeight,
					value = value, action = action,
					itemIndex = itemIndex, object = item, mapList = self,
					layer = 100 + itemIndex*2,
					pos = self.pos
				}):insert(loveio.objects)
				self.buttons[tostring(button)] = button
			end
		end
	end
end

mapList.itemGetInfo = function(self, item, itemIndex)
	if item.stage then
		local value = item.title
		local mapList = self
		local action = function(self)
			table.insert(mapList.backWay, mapList.list)
			mapList.list = item
			mapList.scroll = 1
			mapList:reload()
		end
		return value, action
	elseif item.mapName then
		local value = item.mapName
		local mapList = self
		local action = function(self)
			local random = tostring(math.random())
			temp[random] = self.object
			mainCli:run("gameState set game " .. random)
			temp[random] = nil
		end
		return value, action
	else
		local mapList = self
		local value = item.title
		local action = item.action
		return value, action
	end
end

mapList.unload = function(self)
	if self.buttons then
		for buttonIndex, button in pairs(self.buttons) do
			button:remove()
			self.buttons[buttonIndex] = nil
		end
	end
	loveio.input.callbacks.wheelmoved[tostring(self)] = nil
	loveio.input.callbacks.keypressed[tostring(self)] = nil
end

return mapList
