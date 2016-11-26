local init = function(output, loveio)
--------------------------------
local Position = {}

Position.new = function(self, position)
	local position = position or {}
	position.ratios = position.ratios or {0}
	position.resolutions = position.resolutions or {{1, 1}}
	position.align = position.align or {"center", "center"}
	position.locate = position.locate or "in"
	position.scale = position.scale or {1, 1}
	position.offset = position.offset or {0, 0}
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
		
		if #self.ratios == 1 then
			if self.ratios[1] == 0 then
				self.ratio = self.realRatio
			else
				self.ratio = self.ratios[1]
			end
			if self.resolutions[1][1] == 0 or self.resolutions[1][2] == 0 then
				self.resolution = {rW, rH}
			else
				self.resolution = self.resolutions[1]
			end
		else
			if self.realRatio <= self.ratios[1] then
				self.ratio = self.ratios[1]
				self.resolution = self.resolutions[1]
			elseif self.realRatio >= self.ratios[#self.ratios] then
				self.ratio = self.ratios[#self.ratios]
				self.resolution = self.resolutions[#self.resolutions]
			else
				local minIndex, maxIndex
				for index = 1, #self.ratios - 1 do
					local ratio = self.ratios[index]
					local nextRatio = self.ratios[index + 1]
					if self.realRatio > ratio and self.realRatio < nextRatio then
						minIndex, maxIndex = index, index + 1
						break
					elseif self.realRatio == ratio then
						minIndex, maxIndex = index, index
						break
					elseif self.realRatio == nextRatio then
						minIndex, maxIndex = index + 1, index + 1
						break
					end
				end
				self.ratio = self.realRatio
				local minResolution, maxResolution = self.resolutions[minIndex], self.resolutions[maxIndex]
				local minRatio, maxRatio = self.ratios[minIndex], self.ratios[maxIndex]
				local w, h = minResolution[1], maxResolution[2]
				if minResolution[1] ~= maxResolution[1] then
					w = minResolution[1] + ((self.ratio - minRatio) / (maxRatio - minRatio)) * (maxResolution[1] - minResolution[1])
				end
				if minResolution[2] ~= maxResolution[2] then
					h = minResolution[2] + ((self.ratio - minRatio) / (maxRatio - minRatio)) * (maxResolution[2] - minResolution[2])
				end
				self.resolution = {w, h}
			end
		end
		
		-- local ox, oy = Position.getOffsets(rW/rH, self.ratio, self.align, "in")
		-- local cx, cy = Position.getCentralCoords(0, 0, rW, rH, ox, oy)
		-- local scale = Position.getScale(rW, rH, self.ratio, 1, "in")
		-- local x, y, w, h = Position.getDimensions(cx, cy, self.ratio, 1, scale)
		
		local base = {x = 0, y = 0, w = rW, h = rH}
		local box = {w = self.ratio, h = 1}
		local dims = Position.getDimensionsSimple(base, box, self.align, self.locate)
		self.box.x, self.box.y, self.box.w, self.box.h = dims.x, dims.y, dims.w, dims.h
		self.box.x = self.box.x + self.offset[1] * self.box.w
		self.box.y = self.box.y + self.offset[2] * self.box.h
	end
end

Position.getOX = function(ratioBase, ratioBox, align)
	if align == "left" then
		return (ratioBox - ratioBase) / (2 * ratioBase)
	elseif align == "center" then
		return 0
	elseif align == "right" then
		return -(ratioBox - ratioBase) / (2 * ratioBase)
	end
end
Position.getOY = function(ratioBase, ratioBox, align)
	if align == "top" then
		return (1/ratioBox - 1/ratioBase) / (2 * 1/ratioBase)
	elseif align == "center" then
		return 0
	elseif align == "bottom" then
		return -(1/ratioBox - 1/ratioBase) / (2 * 1/ratioBase)
	end
end
Position.getOffsets = function(ratioBase, ratioBox, align, locate)
	if (locate == "in" and ratioBase > ratioBox) or (locate == "out" and ratioBase < ratioBox) then
		return Position.getOX(ratioBase, ratioBox, align[1]), 0
	elseif (locate == "in" and ratioBase < ratioBox) or (locate == "out" and ratioBase > ratioBox) then
		return 0, Position.getOY(ratioBase, ratioBox, align[2])
	else
		return 0, 0
	end
end

Position.getCentralCoords = function(x, y, w, h, ox, oy)
	return x + (w * (0.5 + ox)), y + (h * (0.5 + oy))
end
Position.getScale = function(bw, bh, w, h, locate)
	local scale = 1
	if locate == "out" then
		if bw / bh < w / h then
			scale = bh / h
		else -- if bw / bh > w / h then
			scale = bw / w
		end
	elseif locate == "in" then
		if bw / bh < w / h then
			scale = bw / w
		else -- if bw / bh > w / h then
			scale = bh / h
		end
	end
	return scale
end
Position.getDimensions = function(cx, cy, w, h, scale)
	local x = cx - (w * scale / 2)
	local y = cy - (h * scale / 2)
	local w = w * scale
	local h = h * scale
	return x, y, w, h
end
Position.getDimensionsSimple = function(base, box, align, locate)
	local xBase, yBase, wBase, hBase = base.x, base.y, base.w, base.h
	local wBox, hBox = box.w, box.h

	local ox, oy = Position.getOffsets(wBase/hBase, wBox/hBox, align, locate)
	local cx, cy = Position.getCentralCoords(xBase, yBase, wBase, hBase, ox, oy)
	local scale = Position.getScale(wBase, hBase, wBox, hBox, locate)
	
	local x = cx - (wBox * scale / 2)
	local y = cy - (hBox * scale / 2)
	local w = wBox * scale
	local h = hBox * scale
	return {
		x = x,
		y = y,
		w = w,
		h = h,
		ox = ox,
		oy = oy,
		cx = cx,
		cy = cy,
		scale = scale
	}
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