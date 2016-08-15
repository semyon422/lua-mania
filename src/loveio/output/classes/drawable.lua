local init = function(output, loveio)
--------------------------------
local Drawable = output.classes.OutputObject:new()

Drawable.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.draw(self.drawable,
					   self:get("X", true),
					   self:get("Y", true),
					   self:get("R"),
					   self.sx,
					   self.sy,
					   self:get("SX"),
					   self:get("SY"))
	love.graphics.setColor(oldColor)
end

return Drawable
--------------------------------
end

return init