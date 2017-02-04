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
		color = self.color or {255, 255, 255, 255},
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

local HitScore = loveio.LoveioObject:new()

HitScore.new = function(self, hitScore)
	hitScore.timer = 0.2
	hitScore.time = hitScore.timer
	setmetatable(hitScore, self)
	self.__index = self
	
	return hitScore
end

HitScore.load = function(self)
	self.drawable = loveio.output.classes.Drawable:new({
		drawable = self.drawable or vsrg.skin.get("hitScore", "max"),
		color = {255, 255, 255, 255},
		x = self.x,
		y = self.y,
		sx = self.sx,
		layer = 21
	}):insert(loveio.output.objects)
end

HitScore.postUpdate = function(self)
	if self.temporary then
		self.timer = self.timer - love.timer.getDelta()
		if self.timer <= 0 then
			self:remove()
		else
			self.drawable.color[4] = self.timer / self.time * 255
		end
	end
end

HitScore.unload = function(self)
	self.drawable:remove()
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

AccuracyWatcher.addLine = function(self, offset, scoreMultiplier, isMax)
	local color
	if scoreMultiplier == 1 then
		color = {255, 255, 255, 255}
	elseif scoreMultiplier == 0.75 then
		color = {255, 255, 63, 255}
	elseif scoreMultiplier == 0.50 then
		color = {255, 191, 63, 255}
	elseif scoreMultiplier == 0.25 then
		color = {255, 127, 63, 255}
	elseif scoreMultiplier == 0 then
		color = {255, 63, 63, 255}
	end
	Line:new({
		x = self.x, y = self.y - pos:Y2y(offset), w = self.w, h = self.h/2, 
		temporary = true,
		color = color
	}):insert(loveio.objects)
	local data = scoreMultiplier
	if isMax then data = "max" end
	local drawable = vsrg.skin.get("hitScore", data)
	HitScore:new({
		x = self.x, y = self.y,
		sx = pos:x2X(self.w) / drawable:getWidth(),
		drawable = drawable,
		temporary = true
	}):insert(loveio.objects)
end

AccuracyWatcher.unload = function(self)
	self.centralLine:remove()
end

return AccuracyWatcher
--------------------------------
end

return init