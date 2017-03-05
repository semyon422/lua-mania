local init = function(output, loveio)
--------------------------------
local DrawableBox = output.classes.OutputObject:new()

DrawableBox.w = 1
DrawableBox.h = 1
DrawableBox.xAlign = "center"
DrawableBox.yAlign = "center"
DrawableBox.locate = "in"

DrawableBox.draw = function(self)
	local base = {
		x = self:getAbs("x", true),
		y = self:getAbs("y", true),
		w = self:getAbs("w"),
		h = self:getAbs("h")
	}
	local box = {
		w = self.drawable:getWidth(),
		h = self.drawable:getHeight()
	}
	local align = {
		self.xAlign, self.yAlign
	}
	local dims = loveio.output.Position.getDimensionsSimple(base, box, align, self.locate)

	local oldColor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.draw(self.drawable,
					    dims.x,
					    dims.y,
					   self.r,
					    dims.scale,
					    dims.scale,
					   self:getAbs("ox"),
					   self:getAbs("oy"))
	love.graphics.setColor(oldColor)
end

return DrawableBox
--------------------------------
end

return init