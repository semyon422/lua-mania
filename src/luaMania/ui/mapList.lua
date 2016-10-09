local mapList = ui.classes.UiObject:new()

mapList.load = function(self)
	self.buttons = self.buttons or {}
	self.radius = 1.4
	self.ox = 2
	self.oy = 0.5
	self.startAngle = 0.8 * math.pi
	self.endAngle = 1.2 * math.pi
	self.deltaAngle = 1/64 * 2*math.pi
	self.rotateAngle = self.rotateAngle or 0
	self.cacheOffset = self.cacheOffset or 0
	for angle = self.startAngle + self.rotateAngle, self.endAngle + self.rotateAngle, self.deltaAngle do
		local x, y = self.angle2coord(angle, self.radius, self.ox, self.oy)
		table.insert(self.buttons, ui.classes.Button:new({
			x = x, y = y-(0.125/2), w = 0.3, h = 0.125,
			value = "empty",
			backgroundColor = {255, 255, 255, 31}
		}):insert(loveio.objects))
	end
	for buttonIndex, button in ipairs(self.buttons) do
		local cacheIndex = buttonIndex + self.cacheOffset
		local cacheItem = luaMania.cache.data[cacheIndex]
		if cacheItem then
			button.value = cacheItem.title .. " - " .. cacheItem.version
			button.action = function()
				luaMania.cache.position = cacheIndex
				luaMania.cli:run("gameState set game")
			end
		end
	end
	loveio.input.callbacks.wheelmoved[tostring(self)] = function(_, direction)
		if direction == -1 then
			self.rotateAngle = self.rotateAngle + 2*math.pi/360
			if self.rotateAngle >= self.deltaAngle then
				self.rotateAngle = self.rotateAngle - self.deltaAngle
				self.cacheOffset = self.cacheOffset - 1
			end
		elseif direction == 1 then
			self.rotateAngle = self.rotateAngle - 2*math.pi/360
			if self.rotateAngle <= 0 then
				self.rotateAngle = self.rotateAngle + self.deltaAngle
				self.cacheOffset = self.cacheOffset + 1
			end
		end
		self:reload()
	end
end

mapList.unload = function(self)
	if self.buttons then
		for buttonIndex, button in pairs(self.buttons) do
			self.buttons[buttonIndex] = nil
			button:remove()
		end
	end
end

mapList.angle2coord = function(angle, r, ox, oy)
	local x = math.cos(angle)*(r or 1) + (ox or 0)
	local y = -math.sin(angle)*(r or 1) + (oy or 0)
	return x, y
end


return mapList