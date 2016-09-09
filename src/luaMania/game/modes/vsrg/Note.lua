local init = function(vsrg, game, luaMania)
--------------------------------
local Note = vsrg.HitObject:new({})

Note.new = function(self, note)
	setmetatable(note, self)
	self.__index = self
	note.name = "note" .. note.column.key .. "-" .. note.columnIndex
	
	return note
end

Note.update = function(self)
	local currentTime = self.column.map.currentTime
	local deltaStartTime = self.startTime - currentTime
	
	local startJudgement, startDelay = self:getJudgement(deltaStartTime)
	local keyIsDown = self.column.keyInfo.isDown
	
	if startJudgement == "miss" and startDelay == "early" and keyIsDown then
		self.column.keyInfo.isDown = false
		self.state = "missed"
		self.column.vsrg.combo = 0
		self:next()
	elseif startJudgement == "miss" and startDelay == "lately" then
		self.state = "missed"
		self.column.vsrg.combo = 0
		self:next()
	elseif startJudgement == "pass" and keyIsDown then
		self.column.keyInfo.isDown = false
		self.state = "passed"
		self.column.vsrg.combo = self.column.vsrg.combo + 1
		self:next()
	end
end

Note.drawLoad = function(self)
	self.h = 0.05
	loveio.output.objects[self.name] = loveio.output.classes.Rectangle:new({
		x = 0, y = 0, w = 0.1, h = self.h, mode = "fill", layer = 3
	})
end
Note.drawUpdate = function(self)
	local ox = (self.key - 1) / 10
	local oy = self.column:getCoord(self, "startTime")
	loveio.output.objects[self.name].x = ox
	loveio.output.objects[self.name].y = oy - self.h
	
	if self.state == "missed" then
		loveio.output.objects[self.name].color = {127, 127, 127, 255}
	elseif self.state == "passed" then
		self:remove()
	end
end
Note.drawRemove = function(self)
	loveio.output.objects[self.name] = nil
end

return Note
--------------------------------
end

return init