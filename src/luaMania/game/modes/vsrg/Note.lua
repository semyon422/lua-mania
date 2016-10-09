local init = function(vsrg, game, luaMania)
--------------------------------
local Note = vsrg.HitObject:new({})

Note.new = function(self, note)
	setmetatable(note, self)
	self.__index = self
	
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
	local circle = luaMania.skin.game.vsrg.circle
	self.color = {255, 255, 255, 255}
	self.h = pos:x2y(0.1)
	self.gNote = loveio.output.classes.Drawable:new({
		drawable = circle,
		x = 0, y = 0, sx = 0.1 / pos:X2x(circle:getWidth()),
		layer = 7
	}):insert(loveio.output.objects)
end
Note.drawUpdate = function(self)
	local columnStart = luaMania.skin.game.vsrg.columnStart
	local columnWidth = luaMania.skin.game.vsrg.columnWidth
	local ox = columnStart + columnWidth * (self.key - 1)
	local oy = self.column:getCoord(self, "startTime")
	self.gNote.x = ox
	self.gNote.y = oy - self.h
	
	if self.state == "missed" then
		self.color[1], self.color[2], self.color[3] = 127, 127, 127
	elseif self.state == "passed" then
		self:remove()
	end
end
Note.drawRemove = function(self)
	if self.gNote then self.gNote:remove() end
end

return Note
--------------------------------
end

return init