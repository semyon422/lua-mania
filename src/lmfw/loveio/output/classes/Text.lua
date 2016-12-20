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
	local lineCount = #explode("\n", tostring(self.text))
	local sx = self.sx or 1
	local sy = self.sy or sx
	if self.yAlign == "center" then
		--y = math.floor(self:getAbs("y", true) - (self.font:getHeight()*sy / 2) * lineCount)
		y = (self:getAbs("y", true) - (self.font:getHeight()*sy / 2) * lineCount)
	elseif self.yAlign == "top" then
		--y = math.floor(self:getAbs("y", true) - self.font:getHeight()*sy * lineCount)
		y = (self:getAbs("y", true) - self.font:getHeight()*sy * lineCount)
	end
	
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font)
	if not multipleColors then love.graphics.setColor(255, 255, 255, 255) end
	love.graphics.printf({self.color, tostring(self.text)},
						 self:getAbs("x", true),
						-- math.floor(self:getAbs("x", true)),
						 y,
						-- math.floor(y),
						 self:getAbs("limit"),
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
