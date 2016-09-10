local init = function(skin, luaMania)
--------------------------------
local Hold = {}

Hold.arrow = love.graphics.newImage(skin.path .. "vsrg/arrow/ffffff.png")
Hold.hold = love.graphics.newImage(skin.path .. "vsrg/hold/ffffff.png")

Hold.drawLoad = function(self)
	self.color = {255, 255, 255, 255}
	self.h = pos:x2y(0.1)
	loveio.output.objects[self.name .. "head"] = loveio.output.classes.Drawable:new({
		drawable = Hold.arrow, sx = 0.1 / pos:X2x(Hold.arrow:getWidth()),
		x = 0, y = 0, layer = 3, color = self.color
	})
	loveio.output.objects[self.name .. "tail"] = loveio.output.classes.Drawable:new({
		drawable = Hold.arrow, sx = 0.1 / pos:X2x(Hold.arrow:getWidth()),
		x = 0, y = 0, layer = 3, color = self.color
	})
	loveio.output.objects[self.name .. "body"] = loveio.output.classes.Drawable:new({
		drawable = Hold.hold, sx = 0.1 / pos:X2x(Hold.hold:getWidth()),
		x = 0, y = 0, layer = 3, color = self.color
	})
	self.head = loveio.output.objects[self.name .. "head"]
	self.tail = loveio.output.objects[self.name .. "tail"]
	self.body = loveio.output.objects[self.name .. "body"]
end
Hold.drawUpdate = function(self)
	local ox = (self.key - 1) / 10
	local oyStart = self.column:getCoord(self, "pseudoStartTime") or self.column:getCoord(self, "startTime")
	local oyEnd = self.column:getCoord(self, "endTime")
	self.head.x = ox
	self.tail.x = ox
	self.body.x = ox
	self.head.y = oyStart - self.h
	self.tail.y = oyEnd - self.h
	self.body.y = oyEnd - self.h/2
	
	self.body.sy = (self.head.y - self.tail.y) / pos:Y2y(Hold.hold:getHeight())
	
	if self.state == "clear" then
		self.color[1], self.color[2], self.color[3] = 255, 255, 255
	elseif self.state == "startPassed" then
		self.color[1], self.color[2], self.color[3] = 191, 255, 191
		if self.pseudoStartTime and self.pseudoStartTime > self.startTime then
			self.head.y = self.column:getCoord(self, "pseudoStartTime") - self.h
		else
			self.head.y = self.column:getCoord(self, "startTime") - self.h
		end
		
		self.body.sy = (self.head.y - self.tail.y) / pos:Y2y(Hold.hold:getHeight())
		if self.body.sy <= 0 then
			self:remove()
		end
	elseif self.state == "startMissedPressed" then
		self.color[1], self.color[2], self.color[3], self.color[4] = 127, 159, 127, 255
	elseif self.state == "startMissed" then
		self.color[1], self.color[2], self.color[3], self.color[4] = 127, 127, 127, 255
	elseif self.state == "endPassed" or self.state == "endMissed" then
		self:remove()
	end
end

return Hold
--------------------------------
end

return init