local init = function(Beatmap, osu)
--------------------------------
local EventSample = {}

EventSample.data = {}

EventSample.new = function(self, eventSample)
	local eventSample = eventSample or {}
	setmetatable(eventSample, self)
	self.__index = self
	return eventSample
end

EventSample.import = function(self, line)
	local breaked = explode(",", line)
	
	self.startTime = tonumber(breaked[2])
	self.fileName = breaked[4]
	if string.sub(self.fileName, 1, 1) == "\"" and string.sub(self.fileName, -1, -1) == "\"" then
		self.fileName = string.sub(self.fileName, 2, -2)
	end
	
	self.volume = tonumber(breaked[5]) / 100
	
	return self
end

EventSample.export = function(self)

end

return EventSample
--------------------------------
end

return init