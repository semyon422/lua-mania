local init = function(Beatmap, bms)
--------------------------------
local HitObject = {}

HitObject.data = {}

HitObject.new = function(self, hitObject)
	local hitObject = hitObject or {}
	setmetatable(hitObject, self)
	self.__index = self
	return hitObject
end

HitObject.getTimingPoint = function(self, time)
	for timingPointIndex, timingPoint in ipairs(self.beatmap.timingPoints) do
		if time >= timingPoint.startTime and time <= timingPoint.endTime or
			(timingPointIndex == #self.beatmap.timingPoints and time >= timingPoint.startTime) then
			return timingPoint
		end
	end
	print("not found", time)
	return self.beatmap.timingPoints[1]
end

HitObject.import = function(self, data)
	self.key = data.key
	self.startTime = data.startTime
	self.hitSoundsList = data.hitSoundsList
	self.type = 1
	
	self.startTimingPoint = self:getTimingPoint(self.startTime)
	
	return self
end

HitObject.export = function(self)

end

return HitObject
--------------------------------
end

return init