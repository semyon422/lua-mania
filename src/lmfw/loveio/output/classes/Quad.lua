local init = function(output, loveio)
--------------------------------
local Quad = output.classes.OutputObject:new()

Quad.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.draw(self.drawable,
					   self.quad,
					   self:getAbs("x", true),
					   self:getAbs("y", true),
					   self.r,
					   self.sx,
					   self.sy,
					   self:getAbs("ox"),
					   self:getAbs("oy"))
	love.graphics.setColor(oldColor)
end

return Quad
--------------------------------
end

return init
