local init = function(output, loveio)
--------------------------------
local Rectangle = output.classes.OutputObject:new()

Rectangle.w = 1
Rectangle.h = 1
Rectangle.mode = "fill"

Rectangle.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.rectangle(self.mode,
						    self:getAbs("x", true),
							self:getAbs("y", true),
							self:getAbs("w"),
							self:getAbs("h"))
	love.graphics.setColor(oldColor)
end

return Rectangle
--------------------------------
end

return init