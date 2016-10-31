local init = function(output, loveio)
--------------------------------
local Position = {}

--TODO: ratio, resolution, align, scale, offset
--e.g.: {ratios = {4/3, 5/3}, resolution = {{640, 480}, {800, 500}}, scale = {0.9, 1}, offset = {-20, 30}}
Position.new = function(self, position)
	local position = position or {}
	position.ratios = position.ratios or {0, 0}
	position.resolutions = position.resolutions or {{1, 1}, {1, 1}}
	position.box = {}
	
	setmetatable(position, self)
	self.__index = self
	
	position:update()
	
	return position
end

Position.update = function(self)
	if self.realWidth ~= love.graphics.getWidth() or self.realHeight ~= love.graphics.getHeight() then
		self.realWidth = love.graphics.getWidth()
		self.realHeight = love.graphics.getHeight()
		self.realRatio = self.realWidth / self.realHeight
		
		local rW = self.realWidth
		local rH = self.realHeight
		local rR = self.realRatio
		
		local minRat = self.ratios[1]
		local maxRat = self.ratios[2]
		local minRes = self.resolutions[1]
		local maxRes = self.resolutions[2]
		
		if minRat == maxRat then
			if minRat == 0 then
				self.ratio = rR
			else
				self.ratio = minRat
				print(self.ratio)
			end
			self.resolution = minRes
		else
			if rR <= minRat then
				self.ratio = minRat
				self.resolution = minRes
			elseif rR >= maxRat then
				self.ratio = maxRat
				self.resolution = maxRes
			else
				self.ratio = rR
				local x, y = minRes[1], minRes[2]
				if minRes[1] ~= maxRes[1] then
					x = minRes[1] + ((self.ratio - minRat) / (maxRat - minRat)) * (maxRes[1] - minRes[1])
				end
				if minRes[2] ~= maxRes[2] then
					y = minRes[2] + ((self.ratio - minRat) / (maxRat - minRat)) * (maxRes[2] - minRes[2])
				end
				self.resolution = {x, y}
			end
		end
		
		if rW / rH > self.ratio then
			self.box.h = rH
			self.box.w = rH * self.ratio
			self.box.x = (rW - self.box.w) / 2
			self.box.y = 0
		elseif rW / rH < self.ratio then
			self.box.w = rW
			self.box.h = rW / self.ratio
			self.box.y = (rH - self.box.h) / 2
			self.box.x = 0
		else
			self.box.w = rW
			self.box.h = rH
			self.box.y = 0
			self.box.x = 0
		end
	end
end

Position.x2y = function(self, x)
	if not x then return end
	self:update()
	return x * self.ratio / self.resolution[2]
end
Position.y2x = function(self, y)
	if not y then return end
	self:update()
	return y / self.ratio / self.resolution[1]
end
Position.X2Y = function(self, X, g)
	if not X then return end
	self:update()
	if g then
		return (X - self.box.x) * self.ratio
	else
		return X * self.ratio
	end
end
Position.Y2X = function(self, Y, g)
	if not Y then return end
	self:update()
	if g then
		return (Y - self.box.y) / self.ratio
	else
		return Y / self.ratio
	end
end
Position.X2x = function(self, X, g)
	if not X then return end
	self:update()
	if g then
		return (X - self.box.x) / self.box.w / self.resolution[1]
	else
		return X / self.box.w / self.resolution[1]
	end
end
Position.Y2y = function(self, Y, g)
	if not Y then return end
	self:update()
	if g then
		return (Y - self.box.y) / self.box.h / self.resolution[2]
	else
		return Y / self.box.h / self.resolution[2]
	end
end
Position.x2X = function(self, x, g)
	if not x then return end
	self:update()
	if g then
		return self.box.x + x * self.box.w / self.resolution[1]
	else
		return x * self.box.w / self.resolution[1]
	end
end
Position.y2Y = function(self, y, g)
	if not y then return end
	self:update()
	if g then
		return self.box.y + y * self.box.h / self.resolution[2]
	else
		return y * self.box.h / self.resolution[2]
	end
end

return Position
--------------------------------
end

return init