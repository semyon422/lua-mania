local mapList = ui.classes.UiObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = ui.classes.Button:new()
mapList.Button = Button
Button.xSpawn = 0.5
Button.xSpeedMultiplier = 4
Button.ySpeedMultiplier = 2
Button.pos = mapList.pos
Button.underMouse = false
Button.postUpdate = function(self)
	local limit = self.mapList.dy * (self.cacheIndex - 1 + self.mapList.scroll) - 0.05
	self.y = self.y + love.timer.getDelta() * (limit - self.y) * self.ySpeedMultiplier
	if self.y >= 0 and self.y <= 1 then
		if self.y < 0.5 then
			local limit = self.xSpawn - self.y
			self.x = self.x + love.timer.getDelta() * (limit - self.x) * self.xSpeedMultiplier
		elseif self.y > 0.5 then
			local limit = self.xSpawn - (1 - self.y)
			self.x = self.x + love.timer.getDelta() * (limit - self.x) * self.xSpeedMultiplier
		else
			local limit = self.xSpawn - 0.5
			self.x = self.x + love.timer.getDelta() * (limit - self.x) * self.xSpeedMultiplier
		end
	else
		local limit = self.xSpawn
		self.x = self.x - love.timer.getDelta() * (self.x - limit) * self.xSpeedMultiplier
	end

	if self.oldX ~= self.x or self.oldY ~= self.y then
		self:reload()
		self.oldX = self.x
		self.oldY = self.y
	end
end

mapList.load = function(self)
	self.buttons = {}
	self.scroll = luaMania.cache.mapListScroll or 0
	self.dy = 0.125
	
	self.works = {}
	
	self:calcButtons()
	
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		if direction == -1 then
			self.scroll = self.scroll + 1
		elseif direction == 1 then
			self.scroll = self.scroll - 1
		end
		self:calcButtons()
	end
end

mapList.postUpdate = function(self)
	luaMania.cache.mapListScroll = self.scroll
end

mapList.calcButtons = function(self)
	local cacheIndexKeys = {}
	for buttonIndex, button in pairs(self.buttons) do
		button.buttonIndex = buttonIndex
		cacheIndexKeys[button.cacheIndex] = button
	end
	for cacheIndex, cacheItem in ipairs(luaMania.cache.data) do
		local y = self.dy * (cacheIndex - 1 + self.scroll) - 0.05
		if cacheIndexKeys[cacheIndex] then
			local yReal = cacheIndexKeys[cacheIndex].y
			if yReal < -0.2 or yReal > 1.2 then
				cacheIndexKeys[cacheIndex]:remove()
				self.buttons[tostring(cacheIndexKeys[cacheIndex])] = nil
			end
		end
		
		if y >= -0.2 and y <= 1.2 then
			if not cacheIndexKeys[cacheIndex] then
				local button = Button:new({
					x = Button.xSpawn, y = y, yLimit = y, w = 0.5, h = 0.1,
					value = cacheItem.title .. " - " .. cacheItem.version,
					action = function()
						luaMania.cache.position = cacheIndex
						luaMania.cli:run("gameState set game")
					end,
					mapList = self,
					backgroundColor = {255, 255, 255, 31},
					pos = self.pos,
					cacheIndex = cacheIndex
				}):insert(loveio.objects)
				self.buttons[tostring(button)] = button
			else
				cacheIndexKeys[cacheIndex]:reload()
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
