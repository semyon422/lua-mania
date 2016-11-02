local mapList = ui.classes.UiObject:new()

mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = ui.classes.Button:new()
mapList.Button = Button
Button.ox = 0.5
Button.pos = mapList.pos
Button.underMouse = false
Button.postUpdate = function(self)
	if self.y >= 0.1 and self.y <= 0.9 then
		if self.y < 0.5 then
			local limit = self.ox - self.y + 0.1
			if self.x > limit then
				self.x = self.x - love.timer.getDelta() * (self.x / limit - 1)
			elseif self.x < limit then
				self.x = self.x + love.timer.getDelta() * (limit / self.x - 1)
			end
		elseif self.y > 0.5 then
			local limit = self.ox - (0.9 - self.y)
			if self.x > limit then
				self.x = self.x - love.timer.getDelta() * (self.x / limit - 1)
			elseif self.x < limit then
				self.x = self.x + love.timer.getDelta() * (limit / self.x - 1)
			end
		else
			local limit = self.ox - 0.4
			if self.x > limit then
				self.x = self.x - love.timer.getDelta() * (self.x / limit - 1)
			elseif self.x < limit then
				self.x = self.x + love.timer.getDelta() * (limit / self.x - 1)
			end
		end
	else
		local limit = self.ox
		if self.x < limit then
			self.x = self.x + love.timer.getDelta() * (limit / self.x - 1)
		elseif self.x > limit then
			self.x = self.x - love.timer.getDelta() * (self.x / limit - 1)
		end
	end
	if self.oldX ~= self.x or self.oldY ~= self.y then
		self:reload()
		self.oldX = self.x
	end
end

mapList.load = function(self)
	self.buttons = {}
	self.scroll = luaMania.cache.mapListScroll or 0
	self.oy = 0
	self.dy = 0.125
	
	self.works = {}
	
	self:calcButtons()
	
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		if direction == -1 then
			--self.scroll = self.scroll + 0.1
			local scroll = 0
			local mod = 2
			if self.works.scrollUp then
				mod = 8
			end
			self.works.scrollUp = function()
				if scroll < 1 then
					self.scroll = self.scroll + love.timer.getDelta() * mod
					scroll = scroll + love.timer.getDelta() * mod
					self:calcButtons()
				else
					self.works.scrollUp = nil
				end
			end
			self.works.scrollDown = nil
		elseif direction == 1 then
			--self.scroll = self.scroll - 0.1
			local scroll = 1
			local mod = 2
			if self.works.scrollDown then
				mod = 8
			end
			self.works.scrollDown = function()
				if scroll > 0 then
					self.scroll = self.scroll - love.timer.getDelta() * mod
					scroll = scroll - love.timer.getDelta() * mod
					self:calcButtons()
				else
					self.works.scrollDown = nil
				end
			end
			self.works.scrollUp = nil
		end
		self:calcButtons()
	end
end

mapList.postUpdate = function(self)
	for _, work in pairs(self.works) do
		work()
	end
	luaMania.cache.mapListScroll = self.scroll
end

mapList.calcButtons = function(self)
	local cacheIndexKeys = {}
	for buttonIndex, button in pairs(self.buttons) do
		button.buttonIndex = buttonIndex
		cacheIndexKeys[button.cacheIndex] = button
	end
	for cacheIndex, cacheItem in ipairs(luaMania.cache.data) do
		local y = self.oy + self.dy * (cacheIndex - 1 - self.scroll) - self.h / 2
		if cacheIndexKeys[cacheIndex] then
			cacheIndexKeys[cacheIndex].y = y
			if y < -0.1 or y > 1.1 then
				cacheIndexKeys[cacheIndex]:remove()
				self.buttons[tostring(cacheIndexKeys[cacheIndex])] = nil
			end
		end
		
		if y >= -0.1 and y <= 1.1 then
			if not cacheIndexKeys[cacheIndex] then
				local button = Button:new({
					x = Button.ox, y = y, w = 0.5, h = 0.1,
					value = cacheItem.title .. " - " .. cacheItem.version,
					action = function()
						luaMania.cache.position = cacheIndex
						luaMania.cli:run("gameState set game")
					end,
					backgroundColor = {255, 255, 255, 31},
					pos = self.pos,
					cacheIndex = cacheIndex
				}):insert(loveio.objects)
				self.buttons[tostring(button)] = button
			else
				cacheIndexKeys[cacheIndex]:reload()
			end
		elseif y > 1.1 then
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