local init = function(vsrg, game, luaMania)
--------------------------------
local VsrgHitObject = {}

VsrgHitObject.new = function(self, hitObject)
	setmetatable(hitObject, self)
	self.__index = self
	hitObject.name = "VsrgHO" .. hitObject.column.key .. "-" .. hitObject.columnIndex
	return hitObject
end

VsrgHitObject.state = "clear"
VsrgHitObject.removeQueued = false

VsrgHitObject.judgement = {
	["pass"] = {0, 150},
	["miss"] = {151, 180}
}

VsrgHitObject.getJudgement = function(self, deltaTime)
	local outJudgement, outDelay
	for judgementIndex, judgement in pairs(self.judgement) do
		if deltaTime - judgement[1] > 0 and deltaTime - judgement[2] < 0 then
			outJudgement, outDelay = judgementIndex, "early"
		elseif deltaTime + judgement[1] < 0 and deltaTime + judgement[2] > 0 then
			outJudgement, outDelay = judgementIndex, "lately"
		end
	end
	if not outJudgement and not outDelay then
		if deltaTime + self.judgement.miss[1] < 0 then
			outJudgement, outDelay = "miss", "lately"
		end
	end
	if not outJudgement and not outDelay then
		outJudgement, outDelay = "none", "none"
	end
	return outJudgement, outDelay
end

VsrgHitObject.next = function(self)
	self.column.currentHitObject = self.column.hitObjects[self.columnIndex + 1]
end

VsrgHitObject.update = function(self)
	local deltaStartTime = self.startTime - 1000*self.column.map.audio:tell()
	local deltaEndTime = 0
	if self.endTime then
		deltaEndTime = self.endTime - 1000*self.column.map.audio:tell()
	end
	
	local startJudgement, startDelay = self:getJudgement(deltaStartTime)
	local endJudgement, endDelay = self:getJudgement(deltaEndTime)
	
	local keyIsDown = self.column.keyInfo.isDown
	
	if not self.endTime then
		if startJudgement == "miss" and startDelay == "early" and keyIsDown then
			self.column.keyInfo.isDown = false
			self.state = "startMissed"
			self.column.vsrg.combo = 0
			self:next()
		elseif startJudgement == "miss" and startDelay == "lately" then
			self.state = "startMissed"
			self.column.vsrg.combo = 0
			self:next()
		elseif startJudgement == "pass" and keyIsDown then
			self.column.keyInfo.isDown = false
			self.state = "endPassed"
			self.column.vsrg.combo = self.column.vsrg.combo + 1
			self:next()
		end
	else
		if self.state == "clear" then
			if startJudgement == "miss" and startDelay == "lately" then
				self.state = "startMissed"
				self.column.vsrg.combo = 0
			elseif keyIsDown then
				if startJudgement == "miss" and startDelay == "early" then
					self.state = "startMissed"
					self.column.vsrg.combo = 0
				elseif startJudgement == "pass" then
					self.state = "startPassed"
					self.column.vsrg.combo = self.column.vsrg.combo + 1
				end
			end
		elseif self.state == "startPassed" then
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
		elseif self.state == "startMissed" then
			if not keyIsDown then
				if endJudgement == "pass" then
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
		end
	end
end

VsrgHitObject.draw = function(self, ox, oy)
	if not self.column.createdObjects[self.name] then
		self.column.createdObjects[self.name] = self
	end
	if not loveio.output.objects[self.name] then
		if not self.endTime then
			loveio.output.objects[self.name] = loveio.output.classes.Rectangle:new({
				x = 0, y = 0, w = 0.1, h = 0.05, mode = "fill", layer = 3
			})
		else
			loveio.output.objects[self.name] = loveio.output.classes.Rectangle:new({
				x = 0, y = 0, w = 0.1, h = 0.05 + (self.endTime - self.startTime) / 1000, mode = "fill", layer = 3
			})
		end
	end
	
	loveio.output.objects[self.name].x = ox
	if self.endTime then
		loveio.output.objects[self.name].y = oy - (self.endTime - self.startTime) / 1000 - 0.05
	else
		loveio.output.objects[self.name].y = oy - 0.05
	end
	if self.state == "clear" then
		loveio.output.objects[self.name].color = {255, 255, 255, 255}
	elseif self.state == "startPassed" then
		loveio.output.objects[self.name].color = {127, 255, 127, 255}
	elseif self.state == "startMissed" then
		loveio.output.objects[self.name].color = {255, 127, 127, 127}
	elseif self.state == "endPassed" or self.state == "endMissed" then
		self:remove()
	end
end

VsrgHitObject.remove = function(self)
	loveio.output.objects[self.name] = nil
end

return VsrgHitObject
--------------------------------
end

return init