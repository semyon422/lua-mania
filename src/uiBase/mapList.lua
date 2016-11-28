local mapList = ui.classes.UiObject:new()

-- mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}, scale = {0.5, 0.5}})
mapList.pos = loveio.output.Position:new({ratios = {1}, align = {"right", "center"}})

local Button = ui.classes.PictureButton:new()
mapList.Button = Button
Button.xAlign = "left"
Button.xPadding = 0.05
Button.w = 0.8
Button.h = 1/6
Button.xSpawn = 0.5
Button.xSpeedMultiplier = 4
Button.ySpeedMultiplier = 2
Button.pos = mapList.pos
Button.imagePath = "res/mapListButton.png"
Button.drawable = love.graphics.newImage(Button.imagePath)
Button.align = {"left", "center"}
Button.locate = "out"
Button.font = love.graphics.newFont("res/fonts/OpenSans/OpenSansRegular/OpenSansRegular.ttf", 16)
Button.fontBaseResolution = {mapList.pos:x2X(1), mapList.pos:y2Y(1)}
Button.xTargetOffsetSelected = 0

Button.postUpdate = function(self)
	local dt =  math.min(1/60, love.timer.getDelta())
	
	if self.mapList.selectedButton == self then
		self.xTargetOffsetSelected = -0.2
	else
		self.xTargetOffsetSelected = 0
	end
	local yTarget, xTarget
	yTarget = (self.yTargetOffset or 0) + self.mapList.dy * (self.itemIndex - 1 - self.mapList.scroll)
	self.y = self.y + dt * (yTarget - self.y) * self.ySpeedMultiplier
	
	if self.y >= 0 - self.h and self.y <= 1 then
		local circle = self.mapList.circle
		xTarget = (self.xTargetOffset or 0) + self.xTargetOffsetSelected 
+ circle.x - math.sqrt(circle.y^2 + (circle.x - self.xSpawn)^2 - (self.y + self.h/2 - circle.y)^2)
		self.x = self.x + dt * (xTarget - self.x) * self.xSpeedMultiplier
	else
		local limit = (self.xTargetOffset or 0) + self.xSpawn
		self.x = self.x - dt * (self.x - limit) * self.xSpeedMultiplier
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
	self.dy = 1/8
	self.scrollOffset = 1 / self.dy / 2
	self.scroll = self.scroll or -self.scrollOffset
	self.circle = {}
	self.circle.x = 1.5
	self.circle.y = 0.5
	self.liveZone = 0.25
	
	self.state = self.state or "mainMenu"
	
	self.list = self.list or {
		{
			title = "Play",
			action = function()
				self.state = "songs"
				self.list = mainCache
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
		if (scroll < #self.list and scroll > 0) or
		   (scroll >= #self.list and direction == -1) or
		   (scroll <= 0 and direction == 1) then
			self.scroll = self.scroll + direction
		end
		self:calcButtons()
	end
	loveio.input.callbacks.keypressed[tostring(self)] = function(key)
		local key = tonumber(key)
		if love.keyboard.isDown("lshift") and key then
			if key ~= 0 then
				self:scrollTo(math.ceil(#self.list/9*(key-1)))
			else
				self:scrollTo(#self.list/9*9)
			end
			self:calcButtons()
		end
	end
end

mapList.scrollTo = function(self, scroll)
	if scroll >= 0 and scroll <= #self.list then
		self.scroll = scroll - self.scrollOffset
	end
end

mapList.calcButtons = function(self)
	local itemIndexKeys = {}
	for buttonIndex, button in pairs(self.buttons) do
		button.buttonIndex = buttonIndex
		itemIndexKeys[button.itemIndex] = button
	end
	for itemIndex, item in ipairs(self.list) do
		local y = self.dy * (itemIndex - 1 - self.scroll)
		if y >= 0 - self.liveZone - Button.h and y <= 1 + self.liveZone then
			if not itemIndexKeys[itemIndex] then
				local xSpawn = Button.xSpawn
				-- if y >= 0 - Button.h and y <= 1 + Button.h then
				if y >= 0 and y <= 1 then
					xSpawn = self.circle.x
				end
				
				local value, action = self:itemGetInfo(item, itemIndex)
				local button = Button:new({
					x = xSpawn, y = y,
					value = value,
					action = action,
					mapList = self,
					pos = self.pos,
					itemIndex = itemIndex,
					layer = 1000 - itemIndex
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
		local mapList = self
		local action = function(self)
			if mapList.selectedButton == self then
				mainCli:run("gameState set game " .. itemIndex)
			else
				mapList.selectedButton = self
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
end

return mapList
