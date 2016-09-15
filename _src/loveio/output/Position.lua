local init = function(output, loveio)
--------------------------------
local Position = {}

Position.new = function(self, resolution, ratio)
	local position = {
		resolution = resolution,
		ratio = ratio,
		X = 0, Y = 0,
		W = love.graphics.getWidth(), H = love.graphics.getHeight()
	}
	if not ratio then
		position.noRatio = true
		position.ratio = love.graphics.getWidth() / love.graphics.getHeight()
	end
	position.rW = position.W
	position.rH = position.H
	
	setmetatable(position, self)
	self.__index = self

	return position
end

Position.update = function(self)
	if self.rW ~= love.graphics.getWidth() or self.rH ~= love.graphics.getHeight() then
		self.rW = love.graphics.getWidth()
		self.rH = love.graphics.getHeight()
		local W = self.rW
		local H = self.rH
		if self.noRatio then
			self.ratio = W / H
		end
		if W / H > self.ratio then
			self.H = H
			self.W = H * self.ratio
			self.X = (W - self.W) / 2
			self.Y = 0
		elseif W / H < self.ratio then
			self.W = W
			self.H = W / self.ratio
			self.Y = (H - self.H) / 2
			self.X = 0
		else
			self.W = W
			self.H = H
			self.Y = 0
			self.X = 0
		end
	end
end

Position.x2y = function(self, x)
	if not x then return end
	self:update()
	return x * self.ratio
end
Position.y2x = function(self, y)
	if not y then return end
	self:update()
	return y / self.ratio
end
Position.X2Y = function(self, X, g)
	if not X then return end
	self:update()
	if g then
		return (X - self.X) * self.ratio
	else
		return X * self.ratio
	end
end
Position.Y2X = function(self, Y, g)
	if not Y then return end
	self:update()
	if g then
		return (Y - self.Y) / self.ratio
	else
		return Y / self.ratio
	end
end
Position.X2x = function(self, X, g)
	if not X then return end
	self:update()
	if g then
		return (X - self.X) / self.W
	else
		return X / self.W
	end
end
Position.Y2y = function(self, Y, g)
	if not Y then return end
	self:update()
	if g then
		return (Y - self.Y) / self.H
	else
		return Y / self.H
	end
end
Position.x2X = function(self, x, g)
	if not x then return end
	self:update()
	if g then
		return self.X + x * self.W
	else
		return x * self.W
	end
end
Position.y2Y = function(self, y, g)
	if not y then return end
	self:update()
	if g then
		return self.Y + y * self.H
	else
		return y * self.H
	end
end

return Position
--------------------------------
end

return init