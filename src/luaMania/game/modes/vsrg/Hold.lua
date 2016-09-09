local init = function(vsrg, game, luaMania)
--------------------------------
local Hold = vsrg.HitObject:new({})

Hold.new = function(self, hold)
	setmetatable(hold, self)
	self.__index = self
	hold.name = "hold" .. hold.column.key .. "-" .. hold.columnIndex
	
	return hold
end

Hold.update = function(self)
	local currentTime = self.column.map.currentTime
	local deltaStartTime = self.startTime - currentTime
	local deltaEndTime = self.endTime - currentTime
	
	local startJudgement, startDelay = self:getJudgement(deltaStartTime)
	local endJudgement, endDelay = self:getJudgement(deltaEndTime)
	
	local keyIsDown = self.column.keyInfo.isDown
	
	if self.state == "clear" then
		if startJudgement == "miss" and startDelay == "lately" then
			self.state = "startMissed"
			self.column.vsrg.combo = 0
		elseif keyIsDown then
			if startJudgement == "miss" and startDelay == "early" then
				self.state = "startMissedPressed"
				self.column.vsrg.combo = 0
			elseif startJudgement == "pass" then
				self.state = "startPassed"
				self.column.vsrg.combo = self.column.vsrg.combo + 1
			end
		end
	elseif self.state == "startPassed" then
		self.pseudoStartTime = currentTime
		if not keyIsDown then
			if endJudgement == "none" then
				self.state = "startMissed"
				self.column.vsrg.combo = 0
			elseif endJudgement == "pass" then
				self.state = "endPassed"
				self.column.vsrg.combo = self.column.vsrg.combo + 1
				self:next()
			end
		elseif endJudgement == "miss" and endDelay == "lately" then
			self.column.keyInfo.isDown = false
			self.state = "endMissed"
			self.column.vsrg.combo = 0
			self:next()
		end
	elseif self.state == "startMissedPressed" then
		if not keyIsDown then
			if endJudgement == "pass" then
				self.state = "endMissedPassed"
				self.column.vsrg.combo = self.column.vsrg.combo + 1
				self:next()
			elseif endJudgement == "none" then
				self.state = "startMissed"
			elseif endJudgement == "miss" then
				self.state = "startMissed"
			end
		elseif endJudgement == "miss" and endDelay == "lately" then
			self.column.keyInfo.isDown = false
			self.state = "endMissed"
			self.column.vsrg.combo = 0
			self:next()
		end
	elseif self.state == "startMissed" then
		if keyIsDown then
			self.state = "startMissedPressed"
		elseif endJudgement == "miss" and endDelay == "lately" then
			self.column.keyInfo.isDown = false
			self.state = "endMissed"
			self.column.vsrg.combo = 0
			self:next()
		end
	end
end

Hold.drawLoad = function(self)
	self.h = 0.05
	self.color = {255, 255, 255, 255}
	loveio.output.objects[self.name .. "head"] = loveio.output.classes.Rectangle:new({
		x = 0, y = 0, w = 0.1, h = self.h, mode = "fill", layer = 3, color = self.color
	})
	loveio.output.objects[self.name .. "tail"] = loveio.output.classes.Rectangle:new({
		x = 0, y = 0, w = 0.1, h = self.h, mode = "fill", layer = 3, color = self.color
	})
	loveio.output.objects[self.name .. "body"] = loveio.output.classes.Rectangle:new({
		x = 0, y = 0, w = 0.08, h = self.h, mode = "fill", layer = 3, color = self.color
	})
	self.head = loveio.output.objects[self.name .. "head"]
	self.tail = loveio.output.objects[self.name .. "tail"]
	self.body = loveio.output.objects[self.name .. "body"]
end
Hold.drawUpdate = function(self)
	local ox = (self.key - 1) / 10
	local oyStart = self.column:getCoord(self, "startTime")
	local oyEnd = self.column:getCoord(self, "endTime")
	self.head.x = ox
	self.tail.x = ox
	self.body.x = ox + 0.01
	self.head.y = oyStart - self.h
	self.tail.y = oyEnd - self.h
	self.body.y = oyEnd - self.h/2
	
	if self.state == "clear" then
		self.color[1], self.color[2], self.color[3] = 255, 255, 255
		self.body.h = self.head.y - self.tail.y
	elseif self.state == "startPassed" then
		self.color[1], self.color[2], self.color[3] = 127, 255, 127
		if self.pseudoStartTime and self.pseudoStartTime > self.startTime then
			self.head.y = self.column:getCoord(self, "pseudoStartTime") - self.h
		else
			self.head.y = self.column:getCoord(self, "startTime") - self.h
		end
		
		self.longH = self.head.y - self.tail.y
		if self.longH > 0 then
			self.body.h = self.longH
		else
			self:remove()
		end
	elseif self.state == "startMissedPressed" then
		self.color[1], self.color[2], self.color[3], self.color[4] = 127, 192, 127, 255
		self.body.h = self.head.y - self.tail.y
	elseif self.state == "startMissed" then
		self.color[1], self.color[2], self.color[3], self.color[4] = 127, 127, 127, 255
		self.body.h = self.head.y - self.tail.y
	elseif self.state == "endPassed" or self.state == "endMissed" then
		self:remove()
	end
end
Hold.drawRemove = function(self)
	loveio.output.objects[self.name .. "head"] = nil
	loveio.output.objects[self.name .. "tail"] = nil
	loveio.output.objects[self.name .. "body"] = nil
end

return Hold
--------------------------------
end

return init