local init = function(output, loveio)
--------------------------------
local Text = output.classes.OutputObject:new()

Text.limit = 0
Text.xAlign = "left"
Text.yAlign = "bottom"
Text.text = ""
Text.font = love.graphics.getFont()

Text.draw = function(self)
	local Y = self:get("Y", true)
	local lineCount = #explode("\n", tostring(self.text))
	if self.yAlign == "center" then
		Y = math.floor(self:get("Y", true) - (self.font:getHeight() / 2) * lineCount)
	elseif self.yAlign == "top" then
		Y = math.floor(self:get("Y", true) - self.font:getHeight() * lineCount)
	end
	
	local oldColor = {love.graphics.getColor()}
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font)
	if not multipleColors then love.graphics.setColor(255, 255, 255, 255) end
	love.graphics.printf({self.color, tostring(self.text)},
						 math.floor(self:get("X", true)),
						 math.floor(Y),
						 self:get("LIMIT"),
						 self.xAlign,
						 self.r,
						 self.sx,
						 self.sy,
						 self:get("OX"),
						 self:get("OX"),
						 self.kx,
						 self.ky)
	love.graphics.setColor(oldColor)
	love.graphics.setFont(oldFont)
end

return Text
--------------------------------
end

return init