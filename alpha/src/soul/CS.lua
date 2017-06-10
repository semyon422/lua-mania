soul.CS = {} -- Coordinate System
local CS = soul.CS

CS.new = function(self, cs)
	local cs = cs or {}
	
	cs.res = cs.res or {w = 1, h = 1} -- resolution
	cs.align = cs.align or {x = "center", y = "center"}
	cs.locate = cs.locate or "in"
	
	setmetatable(cs, self)
	self.__index = self
	
	return cs
end

CS.update = function(self)
	if self.windowWidth ~= love.graphics.getWidth() or self.windowHeight ~= love.graphics.getHeight() then
		self.windowWidth = love.graphics.getWidth()
		self.windowHeight = love.graphics.getHeight()
		
		local frame = {w = self.res.w, h = self.res.h}
		self:updateFrame(self:getScreen(), frame, self.align, self.locate)
	end
end

CS.getScreen = function(self)
	return {
		x = 0, y = 0,
		w = love.graphics.getWidth(), h = love.graphics.getHeight()
	}
end

CS.getOffset = function(self, cScreen, cFrame, align)
	if align == "center" then
		return 0
	elseif align == "left" or align == "top" then
		return (cFrame - cScreen) / 2
	elseif align == "right" or align == "bottom" then
		return (cScreen - cFrame) / 2
	end
end

CS.getOffsets = function(self, screen, frame, align, locate)
	return self:getOffset(screen.w, frame.w, align.x),
		   self:getOffset(screen.h, frame.h, align.y)
end

CS.getScale = function(self, screen, frame, locate)
	local scale = 1
	local s1 = screen.w / screen.h <= frame.w / frame.h
	local s2 = screen.w / screen.h >= frame.w / frame.h
	
	if locate == "out" and s1 or locate == "in" and s2 then
		scale = screen.h / frame.h
	elseif locate == "out" and s2 or locate == "in" and s1 then
		scale = screen.w / frame.w
	end
	
	return scale
end

CS.updateFrame = function(self, screen, frame, align, locate)
	local scale = self:getScale(screen, frame, locate)
	frame.w = frame.w * scale
	frame.h = frame.h * scale
	
	local ox, oy = self:getOffsets(screen, frame, align, locate)
	
	self.frame = frame
	self.frame.x = math.floor(screen.x + (screen.w - frame.w) / 2 + ox)
	self.frame.y = math.floor(screen.y + (screen.h - frame.h) / 2 + oy)
	self.frame.w = math.ceil(self.frame.w)
	self.frame.h = math.ceil(self.frame.h)
	self.frame.scale = scale
end

CS.x = function(self, X, g)
	if not X then return end
	self:update()
	return (X - (g and self.frame.x or 0)) * self.res.w / self.frame.w
end

CS.y = function(self, Y, g)
	if not Y then return end
	self:update()
	return (Y - (g and self.frame.y or 0)) * self.res.h / self.frame.h
end

CS.X = function(self, x, g)
	if not x then return end
	self:update()
	return (g and self.frame.x or 0) + x / self.res.w * self.frame.w
end

CS.Y = function(self, y, g)
	if not y then return end
	self:update()
	return (g and self.frame.y or 0) + y / self.res.h * self.frame.h
end

CS.s = function(self)
	self:update()
	return self.frame.scale
end