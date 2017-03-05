local init = function(output, loveio)
--------------------------------
local TextBox = output.classes.OutputObject:new()

TextBox.w = 1
TextBox.h = 1
TextBox.xAlign = "left"
TextBox.yAlign = "top"
TextBox.text = ""
TextBox.font = love.graphics.getFont()

TextBox.draw = function(self)
	local y = self:getAbs("y", true)
	local w = self:getAbs("w")
	local h = self:getAbs("h")
	local width, wrappedText = self.font:getWrap(self.text, w)
	local lineCount = #wrappedText
	local sx = self.sx or 1
	local sy = self.sy or sx
	if self.yAlign == "center" then
		y = y + h/2 - (self.font:getHeight()*sy / 2) * lineCount
	elseif self.yAlign == "bottom" then
		y = y + h - self.font:getHeight()*sy * lineCount
	end
	
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font)
	if not self.multipleColors then love.graphics.setColor(255, 255, 255, 255) end
	love.graphics.printf({self.color, tostring(self.text)},
						 self:getAbs("x", true),
						 y,
						 self:getAbs("w"),
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

return TextBox
--------------------------------
end

return init
