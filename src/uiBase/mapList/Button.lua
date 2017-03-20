local init = function(mapList)
--------------------------------
local Button = ui.classes.QuadTextButton:new()

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
Button.fontBaseResolution = {600, 600}

Button.oldX = 0
Button.oldY = 0
Button.xSpawn = 0.5
Button.xSpeedMultiplier = 8
Button.ySpeedMultiplier = 12
Button.xTargetOffsetSelected = 0
Button.xTargetOffsetStageMultiplier = 0.1

Button.postUpdate = function(self)
	local dt =  math.min(1/60, love.timer.getDelta())
	
	if self.mapList.selectedItem == self.itemIndex then
		self.xTargetOffsetSelected = -0.2
	else
		self.xTargetOffsetSelected = 0
	end
	local dy = self.mapList.dy
	local yTarget, xTarget
	yTarget = (self.yTargetOffset or 0) + dy * (self.itemIndex - 1 - self.mapList.scroll + self.mapList.scrollOffset) - self.h/2 + dy
	self.y = self.y + dt * (yTarget - self.y) * self.ySpeedMultiplier
	
	if self.y + 3*self.h/2 >= 0 and self.y + self.h/2 < 0.5 then
		xTarget = (self.xTargetOffset or 0) + self.xTargetOffsetSelected - (1/4)*(self.y + self.h/2) + 1/4 + 1/4 + self.xTargetOffsetStageMultiplier*(self.object.stage or 0)
		self.x = self.x + dt * (xTarget - self.x) * self.xSpeedMultiplier
	elseif self.y + self.h/2 > 0.5 and self.y - 2*self.h/2 <= 1 then
		xTarget = (self.xTargetOffset or 0) + self.xTargetOffsetSelected + (1/4)*(self.y + self.h/2) + 1/4 + self.xTargetOffsetStageMultiplier*(self.object.stage or 0)
		self.x = self.x + dt * (xTarget - self.x) * self.xSpeedMultiplier
	elseif self.y + self.h/2 == 0.5 then
		xTarget = (self.xTargetOffset or 0) + self.xTargetOffsetSelected + 1/4 + self.xTargetOffsetStageMultiplier*(self.object.stage or 0)
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
	if (yTarget + self.mapList.liveZone + self.h <= 0 or yTarget - self.mapList.liveZone >= 1) and
	   (self.y + self.mapList.liveZone + self.h <= 0 or self.y - self.mapList.liveZone >= 1) then
		self:remove()
		self.mapList.buttons[tostring(self)] = nil
	end
	
	local mx, my = self.pos:X2x(loveio.input.mouse.x, true), self.pos:Y2y(loveio.input.mouse.y, true)
	if isInBox(mx, my, self.x, self.y, self.w, self.h) then
		self.xTargetOffset = -0.1
		self.yTargetOffset = 0
		for _, button in pairs(self.mapList.buttons) do
			if button.itemIndex < self.itemIndex then
				button.yTargetOffset = -(self.h - dy)
			elseif button.itemIndex > self.itemIndex then
				button.yTargetOffset = self.h - dy
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
		self.mapList.buttons[tostring(self)] = nil
    end
end

return Button
--------------------------------
end

return init