local mapList = ui.classes.UiObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = ui.classes.QuadTextButton:new()
mapList.Button = Button

Button.textXAlign = "left"
Button.textYAlign = "center"
Button.textXPadding = 0.075
Button.textYPadding = 0
Button.textColor = {255, 255, 255, 255}

Button.quadXAlign = "left"
Button.quadYAlign = "center"
Button.quadXPadding = 0
Button.quadYPadding = 0
Button.quadColor = {255, 255, 255, 255}
Button.locate = "out"

Button.w = 1
Button.h = 1/6
Button.pos = mapList.pos
Button.imagePath = "res/mapListButton.png"
Button.drawable = love.graphics.newImage(Button.imagePath)
Button.font = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 16)

Button.oldX = 0
Button.oldY = 0
Button.xSpawn = 0.5
Button.xSpeedMultiplier = 4
Button.ySpeedMultiplier = 4
Button.xTargetOffsetSelected = 0

Button.postUpdate = function(self)
	local dt =  math.min(1/60, love.timer.getDelta())
	
	if self.mapList.selectedItem == self.itemIndex then
		self.xTargetOffsetSelected = -0.2
	else
		self.xTargetOffsetSelected = 0
	end
	local yTarget, xTarget
	yTarget = (self.yTargetOffset or 0) + self.mapList.dy * (self.itemIndex - 1 - self.mapList.scroll + self.mapList.scrollOffset)
	self.y = self.y + dt * (yTarget - self.y) * self.ySpeedMultiplier
	
	if self.y >= 0 - self.h and self.y <= 1 then
		local circle = self.mapList.circle
		xTarget = (self.xTargetOffset or 0) + self.xTargetOffsetSelected + circle.x - math.sqrt(circle.y^2 + (circle.x - self.xSpawn)^2 - (self.y + self.h/2 - circle.y)^2)
		self.x = self.x + dt * (xTarget - self.x) * self.xSpeedMultiplier
	else
		local limit = (self.xTargetOffset or 0) + self.xSpawn
		self.x = self.x - dt * (self.x - limit) * self.xSpeedMultiplier
	end
	
	if math.ceil(self.oldX*10000) ~= math.ceil(self.x*10000) or math.ceil(self.oldY*10000) ~= math.ceil(self.y*10000) then
		self:reload()
		self.oldX = self.x
		self.oldY = self.y
	end
	if (yTarget < 0 - self.mapList.liveZone - Button.h or yTarget > 1 + self.mapList.liveZone) and
	   (self.y < 0 - self.mapList.liveZone - Button.h or self.y > 1 + self.mapList.liveZone) then
		self:remove()
		self.mapList.buttons[tostring(self)] = nil
	end
	
	local mx, my = self.pos:X2x(loveio.input.mouse.x, true), self.pos:Y2y(loveio.input.mouse.y, true)
	if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
		self.xTargetOffset = -0.1
		self.yTargetOffset = 0
		for _, button in pairs(self.mapList.buttons) do
			if button.itemIndex < self.itemIndex then
				button.yTargetOffset = -0.05
			elseif button.itemIndex > self.itemIndex then
				button.yTargetOffset = 0.05
			end
		end
		self.mapList.buttonUnderMouse = self
	elseif self.mapList.buttonUnderMouse == self then
		for _, button in pairs(self.mapList.buttons) do
			button.yTargetOffset = 0
		end
		self.mapList.buttonUnderMouse = nil
	elseif self.mapList.buttonUnderMouse ~= self then
		self.xTargetOffset = 0
	end

	if not self.mapList.list[self.itemIndex] then
        self:remove()
        print(buttonIndex)
    end
end

mapList.sort = function(a, b)
	return (a.title or "") < (b.title or "")
end


-- local createTree
-- createTree = function(path, tree)
	-- if #path ~= 0 then
		-- local path1 = path[1]
		-- table.remove(path, 1)
		-- tree[path1] = tree[path1] or {}
		-- return createTree(path, tree[path1])
	-- end
	
	-- return tree
-- end
-- local createList
-- createList = function(tree, list)
	-- for index, subTree in pairs(tree) do
		-- if subTree.type == "cacheItem" then
			-- table.insert(list, subTree)
		-- else
			-- local listChanger = {}
			-- local nextList = createList(subTree, {})
			-- listChanger.title = index
			-- listChanger.action = function(self)
				-- table.insert(self.mapList.backWay, self.mapList.list)
				-- self.mapList.list = nextList
				-- self.mapList.scroll = 1
				-- self.mapList:reload()
			-- end
			-- table.insert(list, listChanger)
		-- end
		-- table.sort(list, mapList.sort)
	-- end
	-- return list
-- end
-- mapList.genList = function(self, objects, sort)
	-- local list = {}
	
	-- local objectsTree = {}
	
	-- for _, object in pairs(objects) do
		-- local path = explode("/", object.mapPath)
		-- table.remove(path, 1)
		-- table.remove(path, 1)
		-- local treeEnd = createTree(path, objectsTree)
		-- table.insert(treeEnd, object)
	-- end
	
	-- createList(objectsTree, list)

	-- return list
-- end
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
	self.dy = 1/8
	self.scrollOffset = 1 / self.dy / 2
	self.scroll = self.scroll or 1
	self.scrollTarget = self.scroll
	self.circle = {}
	self.circle.x = 1.25
	self.circle.y = 0.5
	self.liveZone = 0.25
	-- self.backWay = self.backWay or {}
	
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
		-- elseif key == "escape" then
			-- if #self.backWay >= 1 then
				-- self.list = self.backWay[#self.backWay]
				-- self.backWay[#self.backWay] = nil
				-- self.scroll = 1
				-- self:reload()
			-- end
		end
	end
end

mapList.scrollTo = function(self, scroll)
	local scroll = scroll
	if scroll < 1 then scroll = 1
	elseif scroll > #self.list then scroll = #self.list
	end
	self.scrollTarget = scroll
	self:calcButtons()
end

mapList.postUpdate = function(self)
	if self.scroll < self.scrollTarget then
		self.scroll = self.scroll + 1
		self:calcButtons()
	elseif self.scroll > self.scrollTarget then
		self.scroll = self.scroll - 1
		self:calcButtons()
	end
end

mapList.calcButtons = function(self)
	local itemIndexKeys = {}
	for buttonIndex, button in pairs(self.buttons) do
		button.buttonIndex = buttonIndex
		itemIndexKeys[button.itemIndex] = button
	end
	for itemIndex, item in ipairs(self.list) do
		local y = self.dy * (itemIndex - 1 - self.scroll + self.scrollOffset)
		if y >= 0 - self.liveZone - Button.h and y <= 1 + self.liveZone then
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
		elseif y > 1.2 then
			break
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
				mapList:scrollTo(self.itemIndex)
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
