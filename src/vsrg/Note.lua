local init = function(vsrg, game)
--------------------------------
local Note = vsrg.HitObject:new({})

Note.new = function(self, note)
	setmetatable(note, self)
	self.__index = self
	
	return note
end

Note.update = function(self)
	local currentTime = self.column.map.currentTime
	local deltaStartTime = (self.startTime - currentTime) / mainConfig:get("game.vsrg.audioPitch", 1)
	
	local startJudgement, startDelay, startScoreMultiplier, startIsMax = self:getJudgement(deltaStartTime)
	local keyIsDown = self.column.keyInfo.isDown
	
	if startJudgement == "miss" and startDelay == "early" and keyIsDown then
		self.column.keyInfo.isDown = false
		self.state = "missed"
		self.column.vsrg.combo = 0
		self.column.vsrg.accuracyWatcher:addLine(deltaStartTime, startScoreMultiplier, startIsMax)
		self:next()
	elseif startJudgement == "miss" and startDelay == "lately" then
		self.state = "missed"
		self.column.vsrg.combo = 0
		self.column.vsrg.accuracyWatcher:addLine(deltaStartTime, startScoreMultiplier, startIsMax)
		self:next()
	elseif startJudgement == "pass" and keyIsDown then
		self.column.keyInfo.isDown = false
		self.state = "passed"
		self.column.vsrg.combo = self.column.vsrg.combo + 1
		self.column.vsrg.score[1] = self.column.vsrg.score[1] + startScoreMultiplier * (500000 / #self.column.vsrg.map.hitObjects)
		self.column.vsrg.accuracyWatcher:addLine(deltaStartTime, startScoreMultiplier, startIsMax)
		self:next()
	end
end

Note.drawLoad = function(self)
	local pos = self.column.vsrg.pos
    local skin = self.column.vsrg.skin
    local keymode = self.column.vsrg.map.keymode
	
    local note = skin.get("noteImage", {keymode = keymode, key = self.key})

    self.columnStart = skin.get("columnStart", {keymode = keymode, key = self.key})
    self.columnWidth = skin.get("columnWidth", {keymode = keymode, key = self.key})

	self.color = {255, 255, 255, 255}
	self.h = pos:x2y(note:getHeight() * self.columnWidth / note:getWidth())
	self.gNote = loveio.output.classes.Drawable:new({
		drawable = note,
		x = 0, y = 0, sx = self.columnWidth / pos:X2x(note:getWidth()),
		color = self.color,
		layer = 7,
		pos = pos
	}):insert(loveio.output.objects)
end
Note.drawUpdate = function(self)
	local ox = self.columnStart
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
