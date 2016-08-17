local init = function(vsrg, game, luaMania)
--------------------------------
local VsrgHitObject = {}

VsrgHitObject.new = function(self, hitObject)
	setmetatable(hitObject, self)
	self.__index = self
	hitObject.name = "VsrgHO" .. hitObject.column.key .. "-" .. hitObject.columnIndex
	return hitObject
end

VsrgHitObject.update = function(self)
	local missJudgement = {81, 120}
	local hitJudgement = {0, 80}
	local deltaTime = self.startTime - 1000*self.column.map.audio:tell()
	if deltaTime - missJudgement[1] > 0 and
	   deltaTime - missJudgement[2] < 0 and
	   self.column.keyInfo.isDown or
	   deltaTime + missJudgement[1] < 0 then
		self.column.keyInfo.isDown = false
		self.missed = true
		self.column.currentHitObject = self.column.hitObjects[self.columnIndex + 1]
	elseif math.abs(deltaTime) - hitJudgement[1] > 0 and
		   math.abs(deltaTime) - hitJudgement[2] < 0 and
		   self.column.keyInfo.isDown then
		self.column.keyInfo.isDown = false
		self.hitted = true
		self.column.currentHitObject = self.column.hitObjects[self.columnIndex + 1]
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
		loveio.output.objects[self.name].y = oy - (self.endTime - self.startTime) / 1000
	else
		loveio.output.objects[self.name].y = oy
	end
	if self.missed then
		loveio.output.objects[self.name].color = {255, 255, 255, 127}
	elseif self.hitted then
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