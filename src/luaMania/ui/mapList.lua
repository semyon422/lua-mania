local mapList = ui.classes.UiObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = ui.classes.Button:new()
mapList.Button = Button
Button.xAlign = "left"
Button.xPadding = 0.05
Button.w = 0.8
Button.h = 0.125
Button.xSpawn = 0.5
Button.xSpeedMultiplier = 4
Button.ySpeedMultiplier = 2
Button.pos = mapList.pos
Button.postUpdate = function(self)
	local yTarget = (self.yTargetOffset or 0) + self.mapList.dy * (self.itemIndex - 1 - self.mapList.scroll) - self.h / 2
	self.y = self.y + love.timer.getDelta() * (yTarget - self.y) * self.ySpeedMultiplier
	
	if self.y >= 0 - self.h and self.y <= 1 + self.h then
		local circle = self.mapList.circle
		local xTarget = (self.xTargetOffset or 0) + circle.x - math.sqrt(circle.y^2 + (circle.x - self.xSpawn)^2 - (self.y - circle.y)^2)
		self.x = self.x + love.timer.getDelta() * (xTarget - self.x) * self.xSpeedMultiplier
	else
		local limit = (self.xTargetOffset or 0) + self.xSpawn
		self.x = self.x - love.timer.getDelta() * (self.x - limit) * self.xSpeedMultiplier
	end
	if self.oldX ~= self.x or self.oldY ~= self.y then
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
end

mapList.load = function(self)
	self.buttons = {}
	self.dy = 0.1
	self.scrollOffset = 1 / self.dy / 2
	self.scroll = luaMania.cache.mapListScroll or -self.scrollOffset
	self.circle = {}
	self.circle.x = 1.5
	self.circle.y = 0.5
	self.liveZone = 0.25
	
	self.state = self.state or "mainMenu"
	
	-- self.list = luaMania.cache.data
	self.list = self.list or {
		{
			title = "Play",
			action = function()
				self.state = "songs"
				luaMania.cache.data = cacheManager.load("cache.lua")
				self.list = luaMania.cache.data				
				self:reload()
			end
		},
		{
			title = "Options",
			action = function()
				print("options")
			end
		},
		{
			title = "Exit",
			action = function()
				love.event.quit()
			end
		}
	}
	
	self:calcButtons()
	
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		local scroll = self.scroll + self.scrollOffset
		if (scroll < #self.list + 1 and scroll > 0) or
		   (scroll >= #self.list and direction == -1) or
		   (scroll <= 0 and direction == 1) then
			self.scroll = self.scroll + direction
		end
		self:calcButtons()
	end
end

mapList.scrollTo = function(self, scroll)
	if scroll >= 0 and scroll <= #self.list then
		self.scroll = scroll
	end
end

mapList.postUpdate = function(self)
	luaMania.cache.mapListScroll = self.scroll
end

mapList.calcButtons = function(self)
	local itemIndexKeys = {}
	for buttonIndex, button in pairs(self.buttons) do
		button.buttonIndex = buttonIndex
		itemIndexKeys[button.itemIndex] = button
	end
	for itemIndex, item in ipairs(self.list) do
		local y = self.dy * (itemIndex - 1 - self.scroll) - Button.h / 2
		if y >= 0 - self.liveZone - Button.h and y <= 1 + self.liveZone then
			if not itemIndexKeys[itemIndex] then
				local xSpawn = Button.xSpawn
				if y >= 0 - Button.h and y <= 1 + Button.h then
					xSpawn = self.circle.x
				end
				
				local value, action = self:itemGetInfo(item, itemIndex)
				local button = Button:new({
					x = xSpawn, y = y,
					value = value,
					action = action,
					mapList = self,
					backgroundColor = {255, 255, 255, 31},
					pos = self.pos,
					itemIndex = itemIndex
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
		local value = item.title .. "\n" .. item.artist .. " // " .. (item.creator or item.format) .. "\n" .. item.version
		local action = function(self)
			luaMania.cache.position = itemIndex
			luaMania.cli:run("gameState set game")
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
end

mapList.angle2coord = function(angle, r, ox, oy)
	local x = math.cos(angle)*(r or 1) + (ox or 0)
	local y = -math.sin(angle)*(r or 1) + (oy or 0)
	return x, y
end


return mapList
