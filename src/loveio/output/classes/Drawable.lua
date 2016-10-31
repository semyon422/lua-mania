local init = function(output, loveio)
--------------------------------
local Drawable = output.classes.OutputObject:new()

Drawable.draw = function(self)
	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.draw(self.drawable,
					   self:getAbs("x", true),
					   self:getAbs("y", true),
					   self.r,
					   self.sx,
					   self.sy,
					   self:getAbs("ox"),
					   self:getAbs("oy"))
	love.graphics.setColor(oldColor)
end

return Drawable
--------------------------------
end

return init