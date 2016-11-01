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
			self.x = self.ox - self.y + 0.1
		elseif self.y > 0.5 then
			self.x = self.ox - (0.9 - self.y)
		else
			self.x = self.ox - 0.4
		end
	else
		self.x = self.ox
	end
end

mapList.load = function(self)
	self.buttons = {}
	self.scroll = 0
	self.oy = 0
	self.dy = 0.125
	
	self:calcButtons()
	
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		if direction == -1 then
			self.scroll = self.scroll + 0.1
		elseif direction == 1 then
			self.scroll = self.scroll - 0.1
		end
		self:calcButtons()
	end
end

mapList.calcButtons = function(self)
	for buttonIndex, button in pairs(self.buttons) do
		button:remove()
		self.buttons[buttonIndex] = nil
	end
	for cacheIndex, cacheItem in ipairs(luaMania.cache.data) do
		local y = self.oy + self.dy * (cacheIndex - 1 - self.scroll)
		if y >= 0 and y <= 1 then
			local button = Button:new({
				x = 0, y = y, w = 0.5, h = 0.1,
				value = cacheItem.title .. " - " .. cacheItem.version,
				action = function()
					luaMania.cache.position = cacheIndex
					luaMania.cli:run("gameState set game")
				end,
				backgroundColor = {255, 255, 255, 31},
				pos = self.pos,
				cacheItemIndex = i
			}):insert(loveio.objects)
			self.buttons[tostring(button)] = button
			button:postUpdate()
			button:reload()
		elseif y > 1 then
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