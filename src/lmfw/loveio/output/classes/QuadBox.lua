local init = function(output, loveio)
--------------------------------
local QuadBox = output.classes.OutputObject:new()

QuadBox.w = 1
QuadBox.h = 1
QuadBox.xAlign = "center"
QuadBox.yAlign = "center"
QuadBox.locate = "in"

QuadBox.draw = function(self)
	local base = {
		x = self:getAbs("x", true),
		y = self:getAbs("y", true),
		w = self:getAbs("w"),
		h = self:getAbs("h")
	}
	local box = {
		w = self.quadWidth,
		h = self.quadHeight
	}
	local align = {
		self.xAlign, self.yAlign
	}
	local dims = loveio.output.Position.getDimensionsSimple(base, box, align, self.locate)
	
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.draw(self.drawable,
					   self.quad,
					    dims.x,
					    dims.y,
					   self.r,
					    dims.scale,
					    dims.scale,
					   self:getAbs("ox"),
					   self:getAbs("oy"))
	love.graphics.setColor(oldColor)
end

return QuadBox
--------------------------------
end

return init
