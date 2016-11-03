local mapList = ui.classes.UiObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = ui.classes.Button:new()
mapList.Button = Button
Button.w = 0.5
Button.h = 0.12
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
		for _, button in pairs(self.mapList.buttons) do
			if button.itemIndex < self.itemIndex then
				button.yTargetOffset = -0.05
			elseif button.itemIndex > self.itemIndex then
				button.yTargetOffset = 0.05
			end
		end
		self.mapList.buttonUnderMouse = self
	elseif self.mapList.buttonUnderMouse == self then
		self.xTargetOffset = 0
		for _, button in pairs(self.mapList.buttons) do
			button.yTargetOffset = 0
		end
		self.mapList.mouseOnButton = nil
	end
end

mapList.load = function(self)
	self.buttons = {}
	self.scroll = luaMania.cache.mapListScroll or 0
	self.dy = 0.125
	self.scrollOffset = 1 / self.dy / 2
	self.circle = {}
	self.circle.x = 1.5
	self.circle.y = 0.5
	self.liveZone = 0.25
	
	self.list = luaMania.cache.data
	
	self.works = {}
	
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
	self.list = luaMania.cache.data
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
				local button = Button:new({
					x = xSpawn, y = y,
					value = item.title .. " - " .. item.version,
					action = function()
						luaMania.cache.position = itemIndex
						luaMania.cli:run("gameState set game")
					end,
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
