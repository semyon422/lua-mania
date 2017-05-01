local init = function(vsrg, game)
--------------------------------
local Barline = loveio.LoveioObject:new()

Barline.new = function(self, barline)
	setmetatable(barline, self)
	self.__index = self
	
	return barline
end

Barline.draw = function(self)
	if not self.drawedOnce then
		self:drawLoad()
		self.column.vsrg.createdObjects[tostring(self)] = self
		self.drawedOnce = true
	end
	self:drawUpdate()
end

Barline.drawLoad = function(self)
	local pos = self.column.vsrg.pos
	local skin = self.column.vsrg.skin
	self.color = {255, 255, 255, 255}
	self.gLine = loveio.output.classes.Rectangle:new({
		x = 0, y = 0, w = skin.game.vsrg.columnWidth, h = pos:Y2y(3),
		layer = 21,
		pos = vsrg.pos
	}):insert(loveio.output.objects)
end

Barline.drawUpdate = function(self)
	local columnStart = self.column.vsrg.skin.game.vsrg.columnStart
	local columnWidth = self.column.vsrg.skin.game.vsrg.columnWidth
	local ox = columnStart + columnWidth * (self.column.key - 1)
	local oy = self.column:getCoord(self, "startTime")
	self.gLine.x = ox
	self.gLine.y = oy
end

Barline.drawRemove = function(self)
	if self.gLine then self.gLine:remove() end
end

Barline.remove = function(self)
	self:drawRemove()
	self.column.vsrg.createdObjects[tostring(self)] = nil
end

return Barline
--------------------------------
end

return init
