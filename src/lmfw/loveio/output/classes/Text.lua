local init = function(output, loveio)
--------------------------------
local Text = output.classes.OutputObject:new()

Text.limit = 0
Text.xAlign = "left"
Text.yAlign = "bottom"
Text.text = ""
Text.font = love.graphics.getFont()

Text.draw = function(self)
	local y = self:getAbs("y", true)
	local limit = self:getAbs("limit")
	local h = self:getAbs("h")
	local width, wrappedText = self.font:getWrap(self.text, limit)
	local lineCount = #wrappedText
	local sx = self.sx or 1
	local sy = self.sy or sx
	if self.yAlign == "center" then
		y = y - (self.font:getHeight()*sy / 2) * lineCount
	elseif self.yAlign == "top" then
		y = y - self.font:getHeight()*sy * lineCount
	end
	
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font)
	if not multipleColors then love.graphics.setColor(255, 255, 255, 255) end
	love.graphics.printf({self.color, tostring(self.text)},
						 self:getAbs("x", true),
						 y,
						 limit,
						 self.xAlign,
						 self.r,
						 self.sx,
						 self.sy,
						 self:getAbs("ox"),
						 self:getAbs("oy"),
						 self.kx,
						 self.ky)
	love.graphics.setColor(oldColor)
	love.graphics.setFont(oldFont)
end

return Text
--------------------------------
end

return init
