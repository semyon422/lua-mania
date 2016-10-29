local Profier = {}


Profier.new = function(self)
	local profiler = {}
	profiler.deltaTime = 0
	setmetatable(profiler, self)
	self.__index = self
	
	return profiler
end

Profier.start = function(self)
	self.startTime = love.timer.getTime() * 1000
end

Profier.stop = function(self)
	self.endTime = love.timer.getTime() * 1000
	self.deltaTime = self.endTime - self.startTime
end

Profier.getDelta = function(self)
	return self.deltaTime
end

return Profier