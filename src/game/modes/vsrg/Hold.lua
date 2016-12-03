local init = function(vsrg, game)
--------------------------------
local Hold = vsrg.HitObject:new({})

Hold.new = function(self, hold)
	setmetatable(hold, self)
	self.__index = self
	
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
				self.column.vsrg.score[1] = self.column.vsrg.score[1] + 0.5 * (self.judgement["pass"][2] - math.abs(deltaStartTime)) / self.judgement["pass"][2] * (500000 / #self.column.vsrg.map.hitObjects)
				self.column.vsrg.accuracyWatcher:addLine(deltaStartTime)
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
				--self.column.vsrg.combo = self.column.vsrg.combo + 1
				self.column.vsrg.score[1] = self.column.vsrg.score[1] + 0.5 * (self.judgement["pass"][2] - math.abs(deltaEndTime)) / self.judgement["pass"][2] * (500000 / #self.column.vsrg.map.hitObjects)
				self.column.vsrg.accuracyWatcher:addLine(deltaStartTime)
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
				--self.column.vsrg.combo = self.column.vsrg.combo + 1
				self.column.vsrg.score[1] = self.column.vsrg.score[1] + 0.5 * (self.judgement["pass"][2] - math.abs(deltaEndTime)) / self.judgement["pass"][2] * (500000 / #self.column.vsrg.map.hitObjects)
				self.column.vsrg.accuracyWatcher:addLine(deltaStartTime)
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
	local skin = self.column.vsrg.skin
	local head = self.column.vsrg.skin.game.vsrg.head
	local tail = self.column.vsrg.skin.game.vsrg.tail
	local body = self.column.vsrg.skin.game.vsrg.body
	self.color = {255, 255, 255, 255}
	self.h = pos:x2y(skin.game.vsrg.columnWidth)
	self.gHead = loveio.output.classes.Drawable:new({
		drawable = head, sx = skin.game.vsrg.columnWidth / pos:X2x(head:getWidth()),
		x = 0, y = 0, layer = 6, color = self.color
	}):insert(loveio.output.objects)
	self.gTail = loveio.output.classes.Drawable:new({
		drawable = tail, sx = skin.game.vsrg.columnWidth / pos:X2x(tail:getWidth()),
		x = 0, y = 0, layer = 5, color = self.color
	}):insert(loveio.output.objects)
	self.gBody = loveio.output.classes.Drawable:new({
		drawable = body, sx = skin.game.vsrg.columnWidth / pos:X2x(body:getWidth()),
		x = 0, y = 0, layer = 4, color = self.color
	}):insert(loveio.output.objects)
end
Hold.drawUpdate = function(self)
	local columnStart = self.column.vsrg.skin.game.vsrg.columnStart
	local columnWidth = self.column.vsrg.skin.game.vsrg.columnWidth
	local ox = columnStart + columnWidth * (self.key - 1)
	local oyStart = self.column:getCoord(self, "pseudoStartTime") or self.column:getCoord(self, "startTime")
	local oyEnd = self.column:getCoord(self, "endTime")
	self.gHead.x = ox
	self.gTail.x = ox
	self.gBody.x = ox
	self.gHead.y = oyStart - self.h
	self.gTail.y = oyEnd - self.h
	self.gBody.y = oyEnd - self.h/2
	
	self.gBody.sy = (self.gHead.y - self.gTail.y) / pos:Y2y(self.gBody.drawable:getHeight())
	
	if self.state == "clear" then
		self.color[1], self.color[2], self.color[3] = 255, 255, 255
	elseif self.state == "startPassed" then
		self.color[1], self.color[2], self.color[3] = 191, 255, 191
		if self.pseudoStartTime and self.pseudoStartTime > self.startTime then
			self.gHead.y = self.column:getCoord(self, "pseudoStartTime") - self.h
		else
			self.gHead.y = self.column:getCoord(self, "startTime") - self.h
		end
		
		self.gBody.sy = (self.gHead.y - self.gTail.y) / pos:Y2y(self.gBody.drawable:getHeight())
		if self.gBody.sy <= 0 then
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
Hold.drawRemove = function(self)
	if self.gHead then self.gHead:remove() end
	if self.gTail then self.gTail:remove() end
	if self.gBody then self.gBody:remove() end
end

return Hold
--------------------------------
end

return init