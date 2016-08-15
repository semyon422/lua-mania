local init = function(output, loveio)
--------------------------------
local Polygon = output.classes.OutputObject:new()

Polygon.mode = "fill"
Polygon.vertices = {}

Polygon.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.polygon(self.mode, self.vertices)
	love.graphics.setColor(self.oldColor)
end

return Polygon
--------------------------------
end

return init