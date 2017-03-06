local mapList = ui.classes.UiObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = require("uiBase.mapList.Button")(mapList)

mapList.sort = function(a, b)
	return (a.title or "") < (b.title or "")
end

mapList.genList = function(self, cacheList)
	local list = {}
	
	for filePath, object in pairs(cacheList) do
		object.type = "cacheItem"
		table.insert(list, object)
	end
	
	table.sort(list, mapList.sort)

	return list
end

mapList.load = function(self)
	self.buttons = {}
	self.dy = 1/9
	self.scrollOffset = 1 / self.dy / 2
	self.scroll = self.scroll or 1
	self.scrollTarget = self.scroll
	self.circle = {}
	self.circle.x = 1.25
	self.circle.y = 0.5
	self.liveZone = self.dy*3
	
	self.state = self.state or "mainMenu"
	
	self.list = self.list or (mainMenuList or {{title = "empty mapList"}})
	
	self:calcButtons()
	
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		self:scrollTo(self.scroll + direction)
	end
	loveio.input.callbacks.keypressed[tostring(self)] = function(key)
		if love.keyboard.isDown("lshift") then
			if tonumber(key) then
				local key = tonumber(key)
				if key ~= 0 then
					self:scrollTo(math.ceil(#self.list/9*(key-1)))
				else
					self:scrollTo(#self.list/9*9)
				end
			elseif key == "escape" then
				love.event.quit()
			end
		elseif key == "up" then
			self:scrollTo(self.scroll - 1)
		elseif key == "down" then
			self:scrollTo(self.scroll + 1)
		elseif key == "left" then
			self:scrollTo(self.scroll - 1)
			self.selectedItem = self.scrollTarget
		elseif key == "right" then
			self:scrollTo(self.scroll + 1)
			self.selectedItem = self.scrollTarget
		elseif key == "return" then
			if self.selectedItem then
				for _, button in pairs(self.buttons) do
					if button.itemIndex == self.selectedItem then
						button:action()
					end
				end
			end
		elseif key == "f5" then
			self.list = uiBase.mapList:genList(mapCache.list)
		end
	end
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
					xSpawn = self.circle.x
				end
				local drawable, quad, quadX, quadY, quadWidth, quadHeight
				if item.backgroundPath and false then
					drawable = love.graphics.newImage(item.backgroundPath)
					quadWidth = drawable:getWidth()
					quadHeight = drawable:getWidth() * Button.h / Button.w
					quadX = 0
					quadY = (drawable:getHeight() - quadHeight) / 2
					quad = love.graphics.newQuad(quadX, quadY, quadWidth, quadHeight, drawable:getWidth(), drawable:getHeight())
				else
					drawable = Button.drawable
					quadX = 0
					quadY = 0
					quadWidth = drawable:getWidth()
					quadHeight = drawable:getHeight()
					quad = love.graphics.newQuad(quadX, quadY, quadWidth, quadHeight, drawable:getWidth(), drawable:getHeight())
				end
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
	if item.type == "cacheItem" then
		local value = (item.title or "<title>") .. "\n" .. (item.artist or "<artist>") .. " // " .. ((item.creator or item.format) or "") .. "\n" .. (item.mapName or "<mapName>")
		local mapList = self
		local action = function(self)
			if mapList.selectedItem == itemIndex then
				local random = tostring(math.random())
				temp[random] = self.object
				mainCli:run("gameState set game " .. random)
				temp[random] = nil
			else
				mapList.selectedItem = self.itemIndex
				mapList:scrollTo(self.itemIndex - 1)
			end
		end
		return value, action
	else
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
