local Note = {}

Note.new = function(self)
	local note = {}
	note.events = {}
	-- int StartTime
	-- int endTime
	-- int layer
	
	self.__index = self
	setmetatable(note, self)
	
	return note
end

return Note
