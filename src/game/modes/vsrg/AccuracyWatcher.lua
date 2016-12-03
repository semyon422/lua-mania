local init = function(vsrg, game)
--------------------------------
local Line = loveio.LoveioObject:new()

Line.new = function(self, line)
	line.timer = 1
	line.time = line.timer
	setmetatable(line, self)
	self.__index = self
	
	return line
end

Line.load = function(self)
	self.rectangle = loveio.output.classes.Rectangle:new({
		color = {255, 255, 255, 255},
		x = self.x,
		y = self.y,
		w = self.w,
		h = self.h,
		layer = 20
	}):insert(loveio.output.objects)
end

Line.postUpdate = function(self)
	if self.temporary then
		self.timer = self.timer - love.timer.getDelta()
		if self.timer <= 0 then
			self:remove()
		else
			self.rectangle.color[4] = self.timer / self.time * 255
		end
	end
end

Line.unload = function(self)
	self.rectangle:remove()
end

local AccuracyWatcher = loveio.LoveioObject:new()

AccuracyWatcher.new = function(self, accuracyWatcher)
	setmetatable(accuracyWatcher, self)
	self.__index = self
	
	return accuracyWatcher
end

AccuracyWatcher.load = function(self)
	self.centralLine = Line:new({x = self.x, y = self.y, w = self.w, h = self.h}):insert(loveio.objects)
end

AccuracyWatcher.addLine = function(self, offset)
	Line:new({x = self.x, y = self.y - pos:Y2y(offset), w = self.w, h = self.h/2, temporary = true}):insert(loveio.objects)
end

AccuracyWatcher.unload = function(self)
	self.centralLine:remove()
end

return AccuracyWatcher
--------------------------------
end

return init