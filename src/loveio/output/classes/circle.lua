local init = function(output, loveio)
--------------------------------
local Circle = output.classes.OutputObject:new()

Circle.r = 1
Circle.mode = "fill"

Circle.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.circle(self.mode,
						 self:get("X", true),
						 self:get("Y", true),
						 self:get("R"))
	love.graphics.setColor(oldColor)
end

return Circle
--------------------------------
end

return init