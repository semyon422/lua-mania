game.VSRG.Note = createClass()
local Note = game.VSRG.Note

Note.next = function(self)
	self.column.currentNote = self.column.noteData[self.index + 1]
end

Note.update = function(self)
	local vsrg = self.vsrg
	local currentTime = vsrg.currentTime
	local deltaTime = self.startTime - currentTime -- TODO: divide by pitch
	
	local timeState = vsrg:getTimeState(deltaTime)
	local keyIsDown = self.column.keyInfo.isDown
	
	if keyIsDown and timeState == "early" then
		self.column.keyInfo.isDown = false
		self.state = "missed"
		vsrg.playData.combo = 0
		self:next()
	elseif timeState == "late" then
		self.state = "missed"
		vsrg.playData.combo = 0
		self:next()
	elseif keyIsDown and timeState == "exactly" then
		self.column.keyInfo.isDown = false
		self.state = "passed"
		vsrg.playData.combo = vsrg.playData.combo + 1
		vsrg.playData.score = vsrg.playData.score + vsrg:getJudgeScore(deltaTime)
		self:next()
	end
end

Note.draw = function(self)
	self.drawableBox.y = self:getY(self.startTime)
	
	if self.state == "missed" then
		self:setMissLook()
	elseif self.state == "passed" then
		self:deactivate()
	end
end

Note.setMissLook = function(self)
	local color = self.drawableBox.color
	
	color[1] = 127
	color[2] = 127
	color[3] = 127
end

Note.willDrawEarly = function(self)
	if self:getY(self.startTime) < 0 then
		return true
	end
end

Note.willDrawLately = function(self)
	if not self.endTime and self:getY(self.startTime) > 1 + self.h or
		self.endTime and self:getY(self.endTime) > 1 + self.h then
		return true
	end
end

Note.activate = function(self)
	local noteSkin = self.vsrg.noteSkin
	
	local x = noteSkin:get({key = "x", index = self.key})
	local w = noteSkin:get({key = "w"})
	local h = noteSkin:get({key = "w"})
	local drawable = noteSkin:get({key = "note"})
	
	self.drawableBox = soul.graphics.DrawableBox:new({
		x = x, y = 0,
		w = w, h = h,
		drawable = drawable
	})
	
	self.column.drawingNotes[self] = self
	self.drawableBox:activate()
end

Note.deactivate = function(self)
	self.column.drawingNotes[self] = self
	self.drawableBox:deactivate()
	self.drawableBox = nil
end

self.getY = function(self, time)
	return 1 - (self.column.getVirtualTime(time) - self.vsrg.currentTime)/1000
end
