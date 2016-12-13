local init = function(output, loveio)
--------------------------------
local Circle = output.classes.OutputObject:new()

Circle.r = 1
Circle.mode = "fill"

Circle.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.circle(self.mode,
						 self:getAbs("x", true),
						 self:getAbs("y", true),
						 self:getAbs("r"))
	love.graphics.setColor(oldColor)
end

return Circle
--------------------------------
end

return init